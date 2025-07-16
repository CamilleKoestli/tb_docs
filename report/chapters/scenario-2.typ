== Scénario aventurier : Opération "CipherFox" - Infiltration <scénario-2>

Ce scénario plonge le joueur dans la peau d'un espion, l'agent CipherFox, qui doit infiltrer une entreprise de haute technologie pour voler des secrets industriels. Le joueur devra résoudre une série de défis techniques pour mener à bien sa mission sans se faire repérer par l'équipe de sécurité de l'entreprise. Cette histoire s'inspire de récits d'espionnage et de cyberattaques réels, où les hackers exploitent des vulnérabilités pour accéder à des informations sensibles @noauthor_quest-ce_nodate.

"Vous êtes un espion, l’agent CipherFox, et vous travaillez sous couverture. Déguisé en consultant, tu occupes la suite 1903 d’un palace à Genève. Votre mission : Voler les plans de KeyWave Systems : clé matérielle FIDO2 + déverrouillage biométrique qui pourrait tuer les mots de passe classiques. Sa valeur estimée est de plusieurs millions. 
Le plan d’exfiltration se déroule en cinq étapes ; chacun correspond à un "challenge" que vous devrez résoudre  pour mener à bien la mission sans attirer l’attention de l'équipe de sécurité (SOC) de l’entreprise."


*Challenges à réaliser*
#table(
  columns: (auto, 1fr, 1fr, 2fr),

  table.header(
    [*Etape*],
    [*Nom du challenge*],
    [*Compétence travaillée*],
    [*Description du challenge*],
  ),

  [1], [#link(<ch2-1>)[Hotspot Mirage]], [OSINT & Cryptographie], [Retrouver le mot de passe Wi-Fi en comparant le SHA-1 stocké dans les métadonnées du PDF « keynote_KeyWave.pdf ».],
  [2], [#link(<ch2-2>)[Admin Bypass]], [Exploitation Web (SQLi bypass WAF)], [Contourner le filtre WAF sur le formulaire login des partenaires et obtenir le `session_token`.],
  [3], [#link(<ch2-3>)[Micro-Patch]], [Reverse Engineering], [Patcher le binaire `session_tap.exe` (x86) pour désactiver la routine `audit()`.],
  [4], [#link(<ch2-4>)[SecureNote Cipher]], [Cryptographie (XOR)], [Casser un XOR 3 octets dans `design_note.sec` afin d’extraire la pass-phrase qui protège les plans.],
  [5], [#link(<ch2-5>)[DNS Drip]], [Forensic réseau], [Reconstituer `plans.zip.aes` à partir des requêtes DNS vers `*.fox.tunnel`, décoder Base36, déchiffrer avec la pass-phrase.],
)

=== _Hotspot Mirage : OSINT et Cryptographie_ <ch2-1>
Pour ce premier challenge, le joueur doit se connecter au Wi-Fi de KeyWave Systems (KWS) pour accéder à leur intranet. Le mot de passe est partiellement lisible dans un prospectus trouvé dans sa chambre d'hôtel, mais il manque une partie du texte.
```css
Welcome to our guests!  Wi-Fi code: KeyWave-**-VIP
```
Le code suit toujours la convention interne : `KeyWave-<QUADRIMESTRE>-VIP`
Le joueur doit donc retrouver le mot de passe complet en analysant les métadonnées du PDF de la présentation de KeyWave Systems `keynote_KeyWave.pdf`, présent sur le flyer. Ce PDF contient un champ custom metadata `wifi_hash` : une empreinte du mot de passe complet.

+ Télécharger `keynote_KeyWave.pdf`, l’ouvrir avec exiftool et lire la ligne : 
  ```ini
wifi_hash = 779a10d6ff824bbdfbed49242e48c4806977db3b
```
+ Générer les 4 candidats : `KeyWave-Q1-VIP`, `KeyWave-Q2-VIP`, `KeyWave-Q3-VIP`, `KeyWave-Q4-VIP`
+ Calculer leurs SHA-1 (sha1sum ou CyberChef) et comparer pour trouver que seule `KeyWave-Q2-VIP` correspond.
+ Se connecter au réseau KWS-Guest avec ce mot de passe.

*Outils nécessaires*: exiftool, sha1sum ou CyberChef.

*Indices graduels*
- Indice 1 : Le QR code te permet d'avoir accès à une brochure PDF. Elle conserve des métadonnées ; ouvre-la avec exiftool pour voir s’il n’y a pas un champ inhabituel.
- Indice 2 : Le hash dans le PDF fait 40 hexa, ce qui correspond à SHA-1. 
- Indice 3 : le mot de passe suit toujours le motif KeyWave-Q?-VIP ; calcule le SHA-1 des quatre possibilités et repère celui qui correspond au hash trouvé.

*Flag attendu* : `KeyWave-Q2-VIP`
Le code permet d'avoir accès au Wi-Fi ainsi qu'à la page de connexion des partenaires.

=== _Admin Bypass : Web Exploitation_ <ch2-2>
Le joueur doit maintenant accéder à l'intranet de KeyWave Systems `https://intra.keywave.local/partners/login.php` pour voler les plans. Le formulaire de connexion comporte les champs e-mail et mot de passe. Un email de la responsable média se trouve sur le flyer. Il faudra l'utiliser pour se challenge. Il doit contourner le filtre basique WAF (Web Application Firewall) sur la page de connexion des partenaires, qui refuse toute requête contenant le mot-clé exact `OR` (maj/min indifférent) ou la séquence `--`. Aucune requête préparée et le back-end exécute toujours : 
```sql
SELECT partner_id, session_token
FROM partners
WHERE email = '$mail' AND passwd = '$pw';
```
Pour contourner le filtre, le joueur doit utiliser une injection SQL pour contourner la restriction WAF. Il peut utiliser un commentaire `(/**/)` SQL au milieu du mot-clé pour casser le mot-clé `OR` et ainsi obtenir le `session_token` du partenaire.
    
+ Renseigner e-mail avec une vraie adresse interne, qui se trouve dans le pdf `Responsable média : alice.martin@keywave.com`.
+ Dans mot de passe, saisir : `' O/**/R 1=1 #` (le `/**/` casse le mot-clé pour le WAF ; `#` remplace `--` comme commentaire fin de ligne accepté par MySQL).

*Outils nécessaires*: navigateur, optionnellement Burp Suite pour intercepter la requête.

*Indices graduels*
- Indice 1 : Le WAF bloque `OR` en clair, mais un commentaire `/**/` interrompt les mots.
- Indice 2 : MySQL accepte le dièse `#` comme commentaire d’une ligne. »
- Indice 3 : Essaie de scinder OR : `O/**/R`, puis termine le restant de la requête avec `#`. »

*Flag attendu* : `PART-7XG4`


=== _Micro-Patch – Reverse Engineering_ <ch2-3>
Le micro-service `session_tap.exe` consigne chaque utilisation d’un `session_token` partenaire.
Tant qu’il détecte la valeur `PART-7XG4` (celle récupérée dans le challenge 2), il écrit une ligne dans `audit.log`.
En modifiant la fonction `audit()` pour qu’elle retourne toujours 0, tu effaces toute trace de ta connexion.

+ Ouvrir `session_tap.exe` (PE 32 bits) dans Ghidra.
+ Rechercher la constante ASCII `PART-7XG4`, cela mène à `cmp eax, 0x50524154`.  (“PART”).
+ Dans l’éditeur d’octets : remplacer par `31 C0 C3` (`xor eax,eax; ret`).
+ Sauver le binaire, le copier sur la VM proxy et le relancer.

*Outils nécessaires*: Ghidra, éditeur hexadécimal intégré.

*Indices graduels*
- Indice 1 : Le fichier est un tout petit exécutable x86 (≈ 32 Ko).
- Indice 2 : La constante ASCII PART-7XG4 apparaît en clair dans les données.
- Indice 3 : Forcer eax à 0 juste avant ret neutralise la fonction de journalisation.

*Flag attendu* : `patched_md5=7ab8c6de`

=== _SecureNote Cipher : Cryptographie_ <ch2-4>
Après avoir effacé les journaux, tu peux fouiller le Nextcloud interne.
Le répertoire `/vault/` contient `design_note.sec`, chiffré "à la maison".
Le développeur a laissé l’en-tête `KWSXORv1` ; les six premiers octets en clair valent TITLE:.
Le reste est chiffré par un XOR répété de 3 octets.
En cassant cette clé, tu découvriras la pass-phrase qui protège les plans exfiltrés.

+ Télécharger `design_note.sec`.
+ Charger le fichier dans CyberChef et isoler le bloc chiffré.
+ XORer ce bloc avec le plaintext connu `TITLE:`, la clé trouvée : `55 1A C3`.
+ Appliquer la clé répétée à tout le fichier.
+ Lire la ligne PASSPHRASE.

*Outils nécessaires*: CyberChef ou script Python.

*Indices graduels*
- Indice 1 : Le header montre déjà six octets clairs.
- Indice 2 : Un XOR se casse par… un XOR.
- Indice 3 : La clé est courte (3 octets) applique-la en boucle.

*Flag attendu* : `FOX-VAULT-88`

=== _DNS Drip : Forensic réseau_ <ch2-5>
Les plans FIDO2 sont sortis via un tunnel DNS.
Le SOC a remis un PCAP `exfil_dns.pcapng` capturé sur l’IDS.
Chaque requête vers `*.fox.tunnel` transporte un bloc Base36 du fichier `plans.zip.aes`.
Recolle, décode, puis déchiffre l’archive avec la pass-phrase du défi 4.

+	Ouvrir le PCAP dans Wireshark ; filtre : `dns.qry.name contains .fox.tunnel`.
+	Exporter toutes les valeurs Query Name, trier, concaténer les labels avant `.fox.tunnel`.
+	Utiliser base36decode pour obtenir `plans.zip.aes`.
+	Déchiffrer : `openssl aes-256-cbc -d -k FOX-VAULT-88 -in plans.zip.aes -out plans.zip`.
+	Ouvrir README.txt ; la première ligne contient `FOX_COMPLETE`.

*Outils nécessaires*: Wireshark, utilitaire base36decode, openssl

*Indices graduels*
- Indice 1 : Les labels Base36 font ≤ 15 caractères, majuscules + chiffres.
- Indice 2 : La clé de déchiffrement est la pass-phrase trouvée juste avant.
- Indice 3 : Le fichier résultant est un ZIP AES ; pense à openssl aes-256-cbc.

*Flag attendu* : `FOX_COMPLETE`

"Une fois `FOX_COMPLETE` validé, l’agent CipherFox déclenche son plan d’exfiltration vers un serveur offshore ; les plans FIDO2 + biométrie quittent KeyWave Systems sans qu’aucune alerte ne soit déclenchée. Mission accomplie !"

*Inspiration*
- https://www.kaspersky.com/blog/the-dark-story-of-darkhotel/15022/
- https://en.wikipedia.org/wiki/Pegasus_%28spyware%29