== Scénario aventurier : Opération "CipherFox" - Infiltration <scénario-2>

Ce scénario plonge le joueur·euse dans la peau d'un espion, l'agent CipherFox, qui doit infiltrer une entreprise de haute technologie pour voler des secrets industriels. Le joueur·euse devra résoudre une série de défis techniques pour mener à bien sa mission sans se faire repérer par l'équipe de sécurité de l'entreprise. Cette histoire s'inspire de récits d'espionnage et de cyberattaques réels, où les hackers exploitent des vulnérabilités pour accéder à des informations sensibles @QuestceQueCyberespionnage.

Déguisé en consultant, le joueur·euse, alias CipherFox, commence son infiltration depuis sa suite d’hôtel : il déchiffre le hash SHA-1 caché dans les métadonnées d’un PDF public pour deviner le mot de passe et se connecter au Wi-Fi invité de KeyWave Systems.
En ligne, il se rend au portail partenaires ; grâce à une injection SQL furtive qui contourne le WAF, il ouvre une session interne et obtient un `session_token`. Afin d’effacer toute trace, il patche ensuite le micro-service `session_tap.exe` le journal d’audit ne consignera plus son passage. Dans le répertoire `/vault/`, il trouve `design_note.sec` qu'il devra réussir à déchiffrer. Enfin, la dernière étape, le SOC a intercepté un dump DNS où chaque sous-domaine `.fox.tunnel` transporte un fragment Base36. Il reconstitue le fichier `plans.zip.aes` et le déchiffre avec la pass-phrase trouvée dans le fichier précédent. Le flag final est révélé dans le fichier `README.txt` de l'archive.

"Vous êtes un espion, l’agent CipherFox, et vous travaillez sous couverture. Déguisé en consultant, tu occupes la suite 1903 d’un palace à Genève. Votre mission : Voler les plans de KeyWave Systems : clé matérielle FIDO2 + déverrouillage biométrique qui pourrait tuer les mots de passe classiques. Sa valeur estimée est de plusieurs millions.
Le plan d’exfiltration se déroule en cinq étapes ; chacun correspond à un "challenge" que vous devrez résoudre  pour mener à bien la mission sans attirer l’attention de l'équipe de sécurité (SOC) de l’entreprise."


*Challenges à réaliser*
#table(
  columns: (auto, 1fr, 1fr, 2fr),
  align: (center, left, left, left),

  table.header([*Etape*], [*Nom du challenge*], [*Compétence travaillée*], [*Description du challenge*]),

  [1],
  [#link(<ch2-1>)[Hotspot Mirage]],
  [OSINT et Cryptographie],
  [Retrouver le mot de passe Wi-Fi en comparant le SHA-1 stocké dans les métadonnées du PDF « keynote_KeyWave.pdf ».],

  [2],
  [#link(<ch2-2>)[Admin Bypass]],
  [Exploitation Web],
  [Contourner le filtre WAF sur le formulaire login des partenaires et obtenir le `session_token`.],

  [3],
  [#link(<ch2-3>)[Micro-Patch]],
  [Reverse Engineering],
  [Patcher le binaire `session_tap.exe` (x86) pour désactiver la routine `audit()`.],

  [4],
  [#link(<ch2-4>)[SecureNote Cipher]],
  [Cryptographie],
  [Casser un XOR 3 octets dans `design_note.sec` afin d’extraire la pass-phrase qui protège les plans.],

  [5],
  [#link(<ch2-5>)[DNS Drip]],
  [Forensic réseau],
  [Reconstituer `plans.zip.aes` à partir des requêtes DNS vers `*.fox.tunnel`, décoder Base36, déchiffrer avec la pass-phrase.],
)

=== _Hotspot Mirage_ : OSINT et Cryptographie <ch2-1>
Pour ce premier challenge, le joueur·euse doit se connecter au Wi-Fi de KeyWave Systems (KWS) pour accéder à leur intranet. Le mot de passe est partiellement lisible dans un prospectus trouvé dans sa chambre d'hôtel, mais il manque une partie du texte :
```css
Welcome to our guests!  Wi-Fi code: KeyWave-**-VIP
```
Le code suit toujours la convention interne : `KeyWave-<QUADRIMESTRE>-VIP`
Le joueur·euse doit donc retrouver le mot de passe complet en analysant les métadonnées du PDF de la présentation de KeyWave Systems `keynote_KeyWave.pdf`, présent sur le flyer. Ce PDF contient un champ custom metadata `wifi_hash` : une empreinte du mot de passe complet.

+ Télécharger `keynote_KeyWave.pdf`, l’ouvrir avec exiftool et lire la ligne :
  ```ini
  wifi_hash = 779a10d6ff824bbdfbed49242e48c4806977db3b
  ```
+ Générer les 4 candidats : `KeyWave-Q1-VIP`, `KeyWave-Q2-VIP`, `KeyWave-Q3-VIP`, `KeyWave-Q4-VIP`.
+ Calculer leurs SHA-1 (sha1sum ou CyberChef) et comparer pour trouver que seule `KeyWave-Q2-VIP` correspond.
+ Se connecter au réseau KWS-Guest avec ce mot de passe.

*Outils nécessaires* : Exiftool, sha1sum ou CyberChef.

*Indices graduels*
- Indice 1 : Le QR code te permet d'avoir accès à une brochure PDF. Elle conserve des métadonnées ; ouvre-la avec exiftool pour voir s’il n’y a pas un champ inhabituel.
- Indice 2 : Le hash dans le PDF fait 40 hexa, ce qui correspond à SHA-1.
- Indice 3 : le mot de passe suit toujours le motif KeyWave-Q?-VIP ; calcule le SHA-1 des quatre possibilités et repère celui qui correspond au hash trouvé.

*Flag attendu* : `KeyWave-Q2-VIP`
Le code permet d'avoir accès au Wi-Fi ainsi qu'à la page de connexion des partenaires.


=== _Admin Bypass_ : Web Exploitation<ch2-2>
Le joueur·euse doit maintenant accéder à l'intranet de KeyWave Systems `https://intra.keywave.local/partners/login.php` pour voler les plans. Le formulaire de connexion comporte les champs e-mail et mot de passe. Un email de la responsable média se trouve sur le flyer. Il faudra l'utiliser pour ce challenge. Il doit contourner le filtre basique WAF (Web Application Firewall) sur la page de connexion des partenaires, qui refuse toute requête contenant le mot-clé exact `OR` (maj/min indifférent) ou la séquence `--`. Aucune requête préparée et le back-end exécute toujours :
```sql
SELECT partner_id, session_token
FROM partners
WHERE email = '$mail' AND passwd = '$pw';
```
Pour contourner le filtre, le joueur·euse doit utiliser une injection SQL pour éviter la restriction WAF. Il peut utiliser un commentaire `(/**/)` SQL au milieu du mot-clé pour casser le mot-clé `OR` et ainsi obtenir le `session_token` du partenaire.

+ Renseigner e-mail avec une vraie adresse interne, qui se trouve dans le pdf `Responsable média : alice.martin@keywave.com`.
+ Dans mot de passe, saisir : `' O/**/R 1=1 #` (le `/**/` casse le mot-clé pour le WAF ; `#` remplace `--` comme commentaire fin de ligne accepté par MySQL).

*Outils nécessaires* : Navigateur.

*Indices graduels*
- Indice 1 : Le WAF bloque `OR` en clair, mais un commentaire `/**/` interrompt les mots.
- Indice 2 : MySQL accepte le dièse `#` comme commentaire d’une ligne.
- Indice 3 : Essaie de scinder `OR` : `O/**/R`, puis termine le restant de la requête avec `#`. N’oublie pas d’utiliser l’adresse `alice.martin@keywave.com` trouvée sur le flyer.

*Flag attendu* : `PART-7XG4`


=== _Micro-Patch_ : Reverse Engineering <ch2-3>
Le joueur·euse a maintenant le `session_token`, mais il doit effacer toute trace de sa connexion pour éviter d'être détecté par le SOC. Le micro-service `session_tap.exe` consigne chaque utilisation d’un `session_token` partenaire dans un fichier `audit.log`. Tant qu’il détecte la valeur `PART-7XG4` (celle récupérée dans le challenge 2), il écrit une ligne dans ce journal. Le joueur·euse doit modifier le binaire pour que la fonction `audit()` retourne toujours `0`, ce qui effacera toute trace de sa connexion.

+ Ouvrir `session_tap.exe` dans Ghidra.
+ Rechercher la constante ASCII `PART-7XG4`, cela mène à `cmp eax, 0x50415254`.  ("PART").
+ Dans l’éditeur d’octets, remplacer par `31 C0 C3` (`xor eax,eax; ret`).
+ Sauver le binaire et le relancer.

*Outils nécessaires* : Ghidra, éditeur hexadécimal intégré.

*Indices graduels*
- Indice 1 : Ouvre le binaire dans Ghidra et fais `Strings`. le token `PART-7XG4` s’y trouve en clair.
- Indice 2 : Clique sur Xrefs de cette chaîne et il y a un `cmp eax, 0x50415254 (ASCII “PART”)`.
- Indice 3 : Remplace le bloc de comparaison par `31 C0 C3 (xor eax,eax ; ret)`, ce qui permettra à la fonction de renvoyer toujours `0`.

*Flag attendu* : `patched_md5=7ab8c6de`


=== _SecureNote Cipher_ : Cryptographie <ch2-4>
Le joueur·euse a réussi à se connecter à l'intranet de KeyWave Systems, mais il doit maintenant accéder aux plans FIDO2. Ils sont stockés dans un fichier sécurisé `design_note.sec` dans le répertoire `/vault/`. Le fichier est chiffré avec un XOR répété de 3 octets.
La structure du fichier est la suivante : un en-tête non chiffré qui est `KWSXORv1` (8 octets), puis le contenu chiffré commence immédiatement après l'en-tête. Le joueur·euse sait que le texte chiffré commence par le mot `TITLE:` (6 octets). Il s'agit d'une attaque de type "known plaintext" (texte clair connu) sur un chiffrement XOR.

+ Télécharger `design_note.sec`.
+ Charger le fichier dans CyberChef et isoler le bloc chiffré.
+ XOR le bloc avec le plaintext connu `TITLE:`, permet de retrouver la clé.
+ Appliquer la clé répétée à tout le fichier.
+ Lire la ligne pass-phrase.

*Outils nécessaires* : CyberChef ou script Python.

*Indices graduels*
- Indice 1 : Le fichier commence par `KWSXORv1` non chiffré.
- Indice 2 : Juste après l’en-tête, il y a `TITLE:` en clair c’est un plaintext connu pour récupérer la clé.
- Indice 3 : La clé fait 3 octets et tourne en boucle, il faut l'appliquer sur tout le reste pour dévoiler la pass-phrase.

*Flag attendu* : `K3yW4v3-Q4-VIP-F1D0-M4st3rPl4n!`

=== _DNS Drip_ : Forensique réseau <ch2-5>
Le joueur·euse a maintenant la pass-phrase pour déchiffrer les plans, mais il doit d'abord les récupérer. Les plans FIDO2, contenus dans le fichier `plans.zip.aes`, ont été exfiltrés via un tunnel DNS. Le SOC a fourni un fichier PCAP, `exfil_dns.pcapng`, capturé sur leur Système de Détection d'Intrusion (IDS). Chaque requête DNS vers le domaine `*.fox.tunnel` transporte un bloc du fichier, encodé en Base36. Le joueur·euse doit donc reconstituer le fichier `plans.zip.aes` à partir de ces requêtes DNS capturées, décoder les blocs Base36, puis déchiffrer l'archive obtenue en utilisant la pass-phrase récupérée lors du défi précédent.

+ Ouvrir le PCAP dans Wireshark et filtrer `dns.qry.name contains .fox.tunnel`.
+ Exporter toutes les valeurs Query Name, trier, concaténer les labels avant `.fox.tunnel`.
+ Utiliser base36decode pour obtenir `plans.zip.aes`.
+ Déchiffrer en utilisant la pass-phrase du défi 4 `openssl aes-256-cbc -d -k K3yW4v3-Q4-VIP-F1D0-M4st3rPl4n! -in plans.zip.aes -out plans.zip`.
+ Ouvrir README.txt ; la première ligne contient le flag.

*Outils nécessaires* : Wireshark, utilitaire base36decode, openssl.

*Indices graduels*
- Indice 1 : Filtre dans Wireshark `dns.qry.name contains .fox.tunnel` pour repérer une centaine de requêtes successives.
- Indice 2 : Les sous-domaines mélangent A-Z et 0-9 seulement : c’est un encodage Base36.
- Indice 3 : Le fichier résultant est un ZIP AES, déchiffre-le avec la pass-phrase trouvée avant `openssl aes-256-cbc -d -k K3yW4v3-Q4-VIP-F1D0-M4st3rPl4n! -in plans.zip.aes -out plans.zip` pour lire le flag.

*Flag attendu* : `FOX_COMPLETE`

Une fois terminé, le joueur·euse a réussi à exfiltrer les plans FIDO2 de KeyWave Systems sans se faire repérer et un dernier message apparaît :
"`FOX_COMPLETE` est validé, l’agent CipherFox déclenche son plan d’exfiltration vers un serveur offshore ; les plans FIDO2 + biométrie quittent KeyWave Systems sans qu’aucune alerte ne soit déclenchée. Mission accomplie !"
