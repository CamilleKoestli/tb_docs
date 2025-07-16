== Scénario réaliste : Blackout dans le Centre Hospitalier Horizon Santé <scénario-1>

Ce scénario reprend une situation fictive, mais inspirée de faits réels. Ici, le joueur fait partie d'une équipe de cybersécurité qui fait face à une attaque de ransomware dans un hôpital. Le but est de résoudre des défis techniques pour rétablir les services vitaux avant qu'il ne soit trop tard. L'inspiration de ce scénario vient de plusieurs incidents réels, notamment les attaques de ransomware avec une hausse croissante sur des infrastructures critiques comme les hôpitaux et les réseaux électriques @noauthor_when_2025.

"Le Centre hospitalier Horizon Santé tourne sur groupe électrogène depuis trois heures : un ransomware a chiffré les serveurs cliniques, puis a sauté la barrière réseau et mis hors service le réseau électrique qui alimente le bloc opératoire. Le générateur de secours n’a plus que 68 minutes d’autonomie. Si rien n’est fait, huit opérations à cœur ouvert devront être interrompues.
Votre équipe vient d’être branchée en urgence sur le réseau isolé de l’hôpital. Votre mission : remettre les services vitaux en ligne avant la fin du compte à rebours et bloquer la seconde vague annoncée par les attaquants."

*Challenges à réaliser*
#table(
  columns: (auto, 1fr, 1fr, 2fr),

  table.header(
    [*Etape*],
    [*Nom du challenge*],
    [*Compétence travaillée*],
    [*Description du challenge*],
  ),

[1], [#link(<ch1-1>)[Mail Contagieux]], [OSINT & forensic e-mail], [Analyse d’un fichier .eml : inspection des entêtes Received/Return-Path pour identifier l’IP et le domaine d’envoi.],
[2], [#link(<ch1-2>)[Portail fantôme]], [Exploitation Web], [IDOR sur le faux portail VPN : modifier le paramètre id dans `repo.php` afin de télécharger le script.],
[3], [#link(<ch1-3>)[Script drainer]], [Reverse Engineering], [Dé-obfuscation d’un script PowerShell (Base64 + XOR 0x37) pour révéler l’URL C2 `https://c2.hz-cloud.net/api`.],
[4], [#link(<ch1-4>)[Chiffre de garde]], [Cryptographie], [Attaque known-plaintext sur `vault.cfg.enc` : découverte d’une clé XOR répétée (6 octets).],
[5.1], [#link(<ch1-5>)[Journal vital]], [Analyse de logs], [Extraction de l'ID dans `central_siem.log` pour neutraliser la seconde vague du ransomware.],
[5.2], [#link(<ch1-6>)[Radio-Silence]], [Stéganographie], [Extraction du kill-switch dissimulé dans la radiographie `thorax_xray.png` via `binwalk/steghide` .],
)

=== _Mail Contagieux : OSINT et forensic d'email_ <ch1-1>
Un courriel intitulé `planning_salle_op.xlsx` est suspecté d’être la porte d’entrée. Inspectez l'email de phishing pour identifier l'attaquant et comprendre comment il a accédé au réseau.

  + Ouvrir `planning_salle_op.eml` dans l’IDE.  
  + Ouvrir les en-têtes (Thunderbird / webmail / outil en ligne).
  + Repérer l’IP de la première ligne Received: et le domaine dans `Return-Path`.
  + Vérifier la réputation du domaine sur un service `WHOIS/OSINT`.

*Outils nécessaires* : IDE, WHOIS, VirusTotal.

*Indices graduels*
- Indice 1 : Cherche dans les premières lignes `Received:` et `Return-Path`. 
- Indice 2 : L’expéditeur imite le sous-domaine support d’Horizon Santé. 
- Indice 3 : Compare horizonsante.com avec horizonsante-support.com.

*Flag attendu* : `horizonsante-support.com`\ 
Le sous-domaine sera la cible du défi 2.


=== _Portail fantôme :  Exploitation Web (IDOR / contrôle d’accès)_ <ch1-2>
Le domaine démasqué héberge un faux portail VPN (`https://vpn.horizonsante-support.com/`). L’onglet Backups est gris, mais l’ID du dépôt transite en paramètre GET : `repo.php?id=42`.

+ Ouvrir la page et intercepter l’URL.
+ Baisser l’ID à `41` puis `40`. Cela télécharge `backup-2025-07-12.tar.gz`.
+ Extraire l’archive ; un script PowerShell obscur y attend.

*Outils nécessaires* : navigateur et DevTools.

*Indices graduels*
  - Indice 1 : Le bouton appelle `repo.php`. 
  - Indice 2 : Les ID semblent incrémentaux…
  - Indice 3 : Essaye `?id=41`.

*Flag attendu* : `backup-2025-07-12.tar.gz`\
Le script trouvé devient l’objet du défi 3.


=== _Script drainer : Reverse Engineering_ <ch1-3>
`drainer.ps1` est compacté : variables à un caractère, chaîne Base64 + XOR 0x37. Il reconstruit l’URL du serveur de commande-&-contrôle (C2).
- Repérer la chaîne Base64 dans le code.
- Dé-obfusquer : Base64 en bytes puis XOR 0x37.
- Lire l’URL C2 (`https://c2.hz-cloud.net/api`).

*Outils nécessaires* : petit script Python.

*Indices graduels*
- Indice 1 : Base-64 est un encodage, pas un chiffrement.
- Indice 2 : Après Base-64 tu verras beaucoup de 0x37.
- Indice 3 : XOR avec 0x37 caractère par caractère.

*FLAG attendu* : `c2.hz-cloud.net`\
Cette URL pointe vers la clé chiffrée du défi 4.


=== Chiffre de garde : Cryptographie <ch1-4>
Sur le C2 se trouve `vault.cfg.enc`. On sait que le fichier clair commence par `CFG=`. Le ransomware a utilisé un XOR de 6 octets.
+ Deviner que `CFG= (hex 43 46 47 3D)` est le plaintext.
+ XORer le début du chiffré avec `CFG=` et retrouver la clé `0x56 0x32 0x19 0x7A 0x56 0x32`.
+ Appliquer la clé en boucle pour déchiffrer tout le fichier.
+ Lire la ligne `ADMIN_PASS=Aur0raVital@2025`.

*Outils nécessaires* : script Python.

*Indices graduels*
- Indice 1 : Connais-tu le mot known-plaintext ?
- Indice 2 : Cherche une entête de configuration classique (CFG=). 
- Indice 3 : XOR se renverse en XOR. 

*Flag attendu* : `Aur0raVital@2025`\
Le mot de passe permet d’ouvrir les logs du défi 5.


=== OPTION 1 _Journal vital : Analyse de logs_ <ch1-5>
Grâce au mot de passe trouvé, vous ouvrez enfin la console d’administration Central SIEM de l’hôpital. Une alerte indique qu’un module du ransomware tente, toutes les 90 secondes, de déclencher la "seconde vague"  sur un serveur interne encore actif : ics-power-ctrl.hz.lan. Les quelque 8 000 lignes de log de la nuit ont été exportées dans le fichier texte `central_siem.log`. Trouver l’ID d’orchestration utilisé par les attaquants pour activer cette seconde charge et le publier dans la console afin de neutraliser la commande distante.
+ Télécharger le fichier` central_siem.log` (simple texte JSON-lines).
+ Filtrer les entrées où `dest_host:ics-power-ctrl.hz.lan` et `event:POST /launch`.
+ Repérer et copier la valeur du champ `orchestration_id`.

*Outils nécessaires* :  Un éditeur de texte avec recherche (VS Code, Notepad++, Sublime) ou grep/jq en ligne de commande ou un visualiseur JSON en ligne.

*Indices graduels*
- Indice 1 : Cherche la machine `ics-power-ctrl` – elle concentre les commandes critiques. 
- Indice 2 : Filtre les requêtes `POST /launch` : ce sont des déclencheurs. 
- Indice 3: L’ID que tu dois envoyer est dans le champ `orchestration_id`. 

*Flag attendu* : `6B98-F4A1-9112`

Une fois l’ID publié, la console affiche "Seconde vague neutralisée". Sur le tableau de bord SIEM, les alertes rouges passent successivement au vert. Le compte à rebours au bloc opératoire s’interrompt.

"Mission accomplie ! Les données patients sont sauves et la seconde vague n’aura jamais lieu. Nous avons déjà lancé le plan de remédiation complet et enclenché la traçabilité juridique grâce aux évidences collectées."


=== OPTION 2 _Radio-Silence : Stéganographie_ <ch1-6>
L’équipe d’analyse découvre qu’un cliché thoracique (`thorax_xray.png`) déposé la veille dans le Dossier Patient contient plus de 15 Mo, anormal pour une simple image PNG. Les renseignements obtenus dans le défi 4 (mot de passe `Aur0raVital@2025`) laissent penser que les pirates ont caché – à l’intérieur même de cette radio – la phrase secrète qui désactive définitivement leur ransomware. Il faudra extraire ce message dissimulé et l’injecter dans la console d’urgence du SI pour neutraliser la seconde vague.
+ Télécharger `thorax_xray.png`
+ Lancer `binwalk -e thorax_xray.png` ou ouvrir l’image avec `steghide`	et déceler un fichier caché (ZIP ou steghide data)
+ Quand l’outil demande le mot de passe, entrer `Aur0raVital@2025` (flag du défi 4)	Déverrouiller l’objet dissimulé
+ Extraire le petit fichier `kill.txt` (ou kill_switch.conf)	et lire son contenu
+ Noter la chaîne présente : `HZ_SECOND_STOP`.

*Outils nécessaires*: binwalk / steghide / zsteg et un éditeur de texte.

*Indices graduels*
- Indice 1 : Le PNG est vraiment trop lourd ; qu’est-ce qui se cache après l’entête ?
- Indice 2 : `binwalk` sait extraire les fichiers concaténés à une image. 
- Indice 3 : Le mot de passe du défi 4 ouvre ce qui est planqué. 

*Flag attendu* :`HZ_SECOND_STOP`

Le joueur copie la chaîne dans le champ kill-switch de la console d’urgence. L’alerte "Seconde vague neutralisée" s’affiche. Le compte à rebours au bloc opératoire s’interrompt.

"Mission accomplie ! Les données patients sont sauves et la seconde vague n’aura jamais lieu. Nous avons déjà lancé le plan de remédiation complet et enclenché la traçabilité juridique grâce aux évidences collectées."
