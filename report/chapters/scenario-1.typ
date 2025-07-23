== Scénario réaliste : Blackout dans le Centre Hospitalier Horizon Santé <scénario-1>

Ce scénario reprend une situation fictive, mais inspirée de faits réels. Ici, le joueur·euse fait partie d'une équipe de cybersécurité qui fait face à une attaque de ransomware dans un hôpital. Le but est de résoudre des défis techniques pour rétablir les services vitaux avant qu'il ne soit trop tard. L'inspiration de ce scénario vient de plusieurs incidents réels, notamment les attaques de ransomware avec une hausse croissante sur des infrastructures critiques comme les hôpitaux et les réseaux électriques @WhenRansomwareKills2025.

Dans un premier temps, le joueur·euse doit remonter à l'origine de l'attaque en analysant un e-mail de phishing qui a permis aux attaquants de pénétrer le réseau de l'hôpital. L’e-mail de phishing révèle le domaine pirate ; c’est la première piste. Ensuite, il devra explorer un faux portail VPN mis en place par les attaquants pour exfiltrer des données. Grâce au commentaire HTML laissé par négligence, le joueur·euse voit l’inventaire complet des sauvegardes et récupère une archive historique qui contient un malware. Dans cette archive se cache `hx_dropper.ps1` ; la dé-obfuscation fournit l’adresse du serveur C2, prouvant que l’hôpital est toujours sous contrôle externe. Sur le C2, un fichier de configuration chiffré recèle le mot de passe administratif du ransomware ; une simple attaque XOR suffit à l’extraire. Grâce à ce mot de passe, le joueur·euse peut accéder aux journaux du ransomware et découvrir un kill-switch caché dans une radiographie. En entrant ce kill-switch dans la console d’urgence, le joueur·euse neutralise la seconde vague d’attaques et sauve les services vitaux de l’hôpital.

"Le Centre hospitalier Horizon Santé tourne sur groupe électrogène depuis trois heures : un ransomware a chiffré les serveurs cliniques, puis a sauté la barrière réseau et mis hors service le réseau électrique qui alimente le bloc opératoire. Le générateur de secours n’a plus que 68 minutes d’autonomie. Si rien n’est fait, huit opérations à cœur ouvert devront être interrompues.
Votre équipe vient d’être branchée en urgence sur le réseau isolé de l’hôpital. Votre mission : remettre les services vitaux en ligne avant la fin du compte à rebours et bloquer la seconde vague annoncée par les attaquants."

*Challenges à réaliser*
#table(
  columns: (auto, 1fr, 1fr, 2fr),
  align: (center, left, left, left),

  table.header([*Etape*], [*Nom du challenge*], [*Compétence travaillée*], [*Description du challenge*]),

  [1],
  [#link(<ch1-1>)[Mail Contagieux]],
  [OSINT & forensic e-mail],
  [Analyse d’un fichier .eml : inspection des entêtes Received/Return-Path pour identifier l’IP et le domaine d’envoi.],

  [2],
  [#link(<ch1-2>)[Shadow VPN Portal]],
  [Exploitation Web],
  [Explorer l'HTML afin d'y trouver un commentaire qui contient la liste de toutes backup.],

  [3],
  [#link(<ch1-3>)[Script d’infection]],
  [Reverse Engineering],
  [Dé-obfuscation d’un script PowerShell (Base64 + XOR 0x20) pour révéler l’URL C2 `https://c2.hz-cloud.net/api`.],

  [4],
  [#link(<ch1-4>)[Coffre chiffré]],
  [Cryptographie],
  [Attaque known-plaintext sur `vault.cfg.enc` : découverte d’une clé XOR répétée (6 octets).],

  [5],
  [#link(<ch1-5>)[Radiographie piégée]],
  [Stéganographie],
  [Extraction du kill-switch dissimulé dans la radiographie `thorax_xray.png` via binwalk/steghide.],
)

=== _Mail Contagieux : OSINT et forensic d'email_ <ch1-1>
Dans un premier temps, le joueur·euse doit analyser un e-mail de phishing qui a permis aux attaquants de pénétrer le réseau de l'hôpital. Cet e-mail contient une pièce jointe malveillante `planning_salle_op.xlsx` qui a été ouverte par un employé, déclenchant ainsi l'attaque.

+ Ouvrir `planning_salle_op.eml` dans l’IDE.
+ Ouvrir les en-têtes (Thunderbird / webmail / outil en ligne).
+ Repérer l’IP de la première ligne `Received:` et le domaine dans `Return-Path`.
+ Vérifier la réputation du domaine sur un service `WHOIS/OSINT`.

*Outils nécessaires* : IDE, WHOIS.

*Indices graduels*
- Indice 1 : Consulte uniquement les tout premiers entêtes `Received:`, la vraie origine est souvent dans la ligne la plus basse.
- Indice 2 : L’expéditeur imite le sous-domaine support d’Horizon Santé.
- Indice 3 : Vérifie la réputation WHOIS : un domaine proche d’`horizonsante.com`, mais pas identique, ressort comme malveillant.

*Flag attendu* : `horizonsante-support.com`\
Le sous-domaine sera la cible du défi 2.


=== _Shadow VPN Portal :  Exploitation Web_ <ch1-2>
Le joueur·euse doit maintenant accéder à un faux portail VPN de l'hôpital `https://vpn.horizonsante-support.com/`, qui a été mis en place par les attaquants pour exfiltrer des données. Le faux portail VPN () propose un bouton « Dernière sauvegarde » qui appelle :
```http
https://vpn.horizonsante-support.com/repo/download.php?file=latest
```
Le joueur·euse devra ensuite explorer le code HTML pour trouver un commentaire qui pointe vers un fichier `/repo/manifest.json`, qui contient la liste des sauvegardes disponibles.

+ Afficher le code source de la page. Chercher `<!--` → on trouve :
  ```html
  <!-- TODO : nettoyer /repo/manifest.json avant mise en prod -->
  ```
+ Ouvrir `https://vpn.horizonsante-support.com/repo/manifest.json` Le JSON liste toutes les sauvegardes.
+ Rejouer la requête de téléchargement mais remplacer `file=latest` par
`file=backup-2025-07-12.tar.gz`.
+ Le serveur répond 200 OK et livre l’archive `backup-2025-07-12.tar.gz`.
+ En listant l'archive il voit une liste de dossiers et fichiers, dont un fichier `tar.gz` compressé.

*Outils nécessaires* : Navigateur et DevTools.

*Indices graduels*
- Indice 1 : Regarde le code source ; les développeurs commentent parfois des URLs utiles.
- Indice 2 : Le fichier `manifest.json` ressemble à un index automatique des sauvegardes.
- Indice 3 : Utilise l’un des noms trouvés pour remplacer `latest` dans le paramètre `file`.

*Flag attendu* : `hx_srv_full_0712.tar.gz`\
Une fois le fichier trouvé décompressé, il devient l’objet du défi 3.


=== _Script d’infection : Reverse Engineering_ <ch1-3>
Une fois qu'il a téléchargé le fichier `hx_srv_full_0712.tar.gz`, le joueur·euse découvre un script PowerShell obfusqué nommé `hx_dropper.ps1`. Ce script est compacté : variables à un caractère, chaîne Base64 + XOR 0x20. Il est utilisé par les attaquants pour établir une connexion avec leur serveur de commande et contrôle (C2) et exfiltrer des données.

+ Repérer la chaîne Base64 dans le code.
+ Dé-obfusquer : Base64 en bytes puis XOR 0x20.
+ Lire l’URL C2 (`https://c2.hz-cloud.net/api`).

*Outils nécessaires* : Script Python.

*Indices graduels*
- Indice 1 : Une chaîne très longue terminant par `=` ou `==` est presque toujours du Base64.
- Indice 2 : Après Base-64 tu verras beaucoup de `0x20`.
- Indice 3 : XOR avec `0x20` caractère par caractère.

*FLAG attendu* : `c2.hz-cloud.net`\
Cette URL pointe vers la clé chiffrée du défi 4.


=== _Coffre chiffré : Cryptographie_ <ch1-4>
Sur ce C2 se trouve `vault.cfg.enc`. Le joueur·euse doit maintenant déchiffrer le fichier de configuration chiffré `vault.cfg.enc` trouvé dans l'archive. Le fichier clair commence par `CFG=`. Le ransomware a utilisé un XOR de 6 octets pour chiffrer ce fichier. Le joueur·euse doit retrouver la clé de chiffrement en utilisant une attaque known-plaintext.

+ Deviner que `CFG= (hex 43 46 47 3D)` est le plaintext.
+ XOR le début du chiffré avec `CFG=` et retrouver la clé.
+ Appliquer la clé pour déchiffrer tout le fichier.
+ Lire la ligne `ADMIN_PASS=Aur0raVital@2025`.

*Outils nécessaires* : Script Python.

*Indices graduels*
- Indice 1 : Cherche un motif ASCII typique en clair dans le début du fichier ; un fichier de config commence souvent par `CFG=`.
- Indice 2 : Calcule `Chiffré ⊕ Clair` sur les 6 premiers octets.
- Indice 3 : Réapplique cette clé répétée jusqu’à la fin, le mot de passe admin apparaît vers les premières lignes.

*Flag attendu* : `Aur0raVital@2025`\
Le mot de passe permet d’ouvrir les logs du défi 5.

=== _Radiographie piégée : Stéganographie_ <ch1-5>
Dans le dossier patient, le joueur·euse trouve une radiographie `thorax_xray.png` qui semble normale, mais qui est anormalement lourd. Le ransomware a dissimulé un kill-switch dans cette image pour désactiver son attaque. Les renseignements obtenus dans le défi 4 (mot de passe `Aur0raVital@2025`) devront être utilisés pour extraire ce message.

+ Télécharger `thorax_xray.png`.
+ Lancer `binwalk -e thorax_xray.png` ou ouvrir l’image avec `steghide`	et déceler un fichier caché (ZIP ou steghide data)
+ Quand l’outil demande le mot de passe, entrer `Aur0raVital@2025` (flag du défi 4)
+ Extraire le petit fichier `kill.txt` (ou kill_switch.conf)	et lire son contenu

*Outils nécessaires* : Binwalk / steghide / zsteg et éditeur de texte.

*Indices graduels*
- Indice 1 : Le PNG fait anormalement > 15 Mo : il dissimule très probablement des données concaténées.
- Indice 2 : `binwalk -e` montre qu’un bloc ZIP/Steghide data débute après l’en-tête de l’image.
- Indice 3 : Utilise le mot de passe à l’étape 4 pour déverrouiller le fichier.

*Flag attendu* :`HZ_SECOND_STOP`

Le joueur·euse copie la chaîne dans le champ kill-switch de la console d’urgence. L’alerte "Seconde vague neutralisée" s’affiche. Le compte à rebours au bloc opératoire s’interrompt avec un dernier message : "Mission accomplie ! Les données patients sont sauves et la seconde vague n’aura jamais lieu. Nous avons déjà lancé le plan de remédiation complet et enclenché la traçabilité juridique grâce aux évidences collectées."
