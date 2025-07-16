== Scénario science-fiction : Fuite de l'Acheron <scénario-3>

Dans ce scénario, le joueur incarne un hacker capturé par des pirates de l’espace. Il devra résoudre une série de défis pour pouvoir s'échapper du vaisseau spatial Acheron. Le scénario est inspiré de récits de science-fiction et de jeux vidéo, où les joueurs doivent utiliser leur ingéniosité pour surmonter des obstacles technologiques.

"L’Acheron est un transport spatial pirate opérant dans la Ceinture de Kuiper. Son équipage t’a enlevé parce qu’ils connaissent ta réputation : ils veulent que tu craques le noyau de sécurité d’OrbitalBank, la banque décentralisée qui garde les coffres-forts crypto de la Fédération. Plutôt que de collaborer, tu décides d'essayer de te sauver. Le seul moyen de quitter l’Acheron est une navette de secours verrouillée au pont C. Pour l’atteindre, tu dois d’abord ouvrir chaque compartiment en détournant les systèmes du vaisseau."

*Challenges à réaliser*

#table(
  columns: (auto, 1fr, 1fr, 2fr),

  table.header(
    [*Etape*],
    [*Nom du challenge*],
    [*Compétence travaillée*],
    [*Description du challenge*],
  ),

  [1], [#link(<ch3-1>)[HashLock]], [Cryptographie], [Analyse du hash SHA-1 trouvé dans `hatch.cfg` ; utilisation d’une rainbow-table ou de hashcat pour révéler le code.],
  [2], [#link(<ch3-2>)[Portail Tech]], [Exploitation Web], [Altération du champ `ship_id` dans la requête React ; un payload `{"$ne":null}` retourne `{"access":"tech"}`.],
  [3], [#link(<ch3-3>)[Drone Patch]], [Reverse Engineering], [Recherche de la comparaison d’UID dans le binaire `drn_v2.4.bin`, remplacement par un saut direct puis reflash via JTAG pour rendre le drone indifférent à ton badge.],
  [4], [#link(<ch3-4>)[Override Hangar]], [Forensics – analyse de logs], [Parcours des 10 000 lignes JSON-L de `hangar.log` afin d’extraire le token `override` unique qui déverrouille la passerelle du hangar C.],
  [5], [#link(<ch3-5>)[Plan Secret]], [Stéganographie], [Extraction, avec zsteg, de la charge cachée en LSB dans `shuttle_blueprint.png` pour obtenir la pass-phrase.],
)

=== _HashLock : Cryptographie_ <ch3-1>
"En examinant la porte de ta cellule, tu découvre un boîtier. Sous le boîtier, tu découvres la carte SD du contrôleur ; le fichier `hatch.cfg` contient :
```ini
unlock_hash = 9f84e19c5ae86fe58a1858698c52c64142e8bdf7
```
Le fabricant a naïvement stocké le code en clair dans un dictionnaire courant avant de le hacher en `SHA-1`.
Retrouve la valeur d’origine, saisis-la sur le clavier, et la porte coulissera !"

+ Ouvrir la console fournie (terminal.html) et lire cuffs.cfg.	Isoler la valeur du hash.
+ Reconnaître qu’un digest de 40 hex qui est SHA-1.
+ Soumettre le hash à une base comme Hashes.com ou lancer hashcat avec la word-list rockyou.txt.
+ Le résultat `KUIPER-88` apparaît.

*Outils nécessaires*: navigateur et site de recherche de hash (Hashes.com) ou ligne de commande : hashcat -a 0 -m 100 <hash> rockyou.txt.


*Indices graduels*
- Indice 1 : 40 caractères hexadécimaux ? Pense à SHA-1.
- Indice 2 : Essaie une rainbow table en ligne si tu n’as pas hashcat.
- Indice 3 : Les pirates aiment la Ceinture… cherche un mot qui évoque Kuiper.

*Flag attendu* : `KUIPER-88`

=== _Portail Tech :	Exploitation Web_ <ch3-2>
La porte du couloir est pilotée par une page React servie sur `http://172.30.0.5:8080`. Elle a un champ `ship_id vulnérable` à l’injection NoSQL. Filtre-le pour obtenir access=tech.

+ Ouvrir l’outil DevTools, puis l'onglet Network pour capturer la requête POST.
+ Remplacer la valeur par `{"$ne":null}` ou `{"$gt":""}`.
+ Le serveur renvoie `{"access":"tech"}` ; la porte coulisse. 

*Outils nécessaires*: navigateur et DevTools

*Indices graduels*
- Indice 1 :  Le backend est un simple `findOne()` MongoDB.
- Indice 2 :  Un `$ne:null` vaut True pour tous. 
- Indice 3 :  Le champ access doit devenir tech.  

*Flag attendu* : `{"access":"tech"}`

=== _Drone Patch : Reverse Engineering_ <ch3-3>
Un droïde de maintenance patrouille le couloir. Télécharge son firmware (`drn_v2.4.bin`), trouve la fonction `patrol_area()` et patches-la pour qu’il ignore ta balise RFID. Reflash via le port JTAG exposé.

+ Ouvrir le firmware dans Ghidra.
+ Rechercher la chaîne `AABB9911` : mène à `cmp r0, #0xAABB9911`.
+ Remplacer l’instruction par `movs r0, #0 + bx lr` .
+ Reflasher via le port JTAG (simulateur fourni).


*Outils nécessaires*: Ghidra, petit script `openocd-flash.py`

*Indices graduels*
- Indice 1 :  Le firmware est ARM Cortex-M3 en little-endian.
- Indice 2 :  Cherche la comparaison d’UID.
- Indice 3 :  Un simple jump early suffit.

*Flag attendu* : `patched_crc32=0x5FCA9E7B`

=== _Override Hangar: Forensics – analyse de logs_ <ch3-4>
La porte du hangar C est verrouillée par un token override qui change chaque nuit. Les 10 000 lignes de hangar.log (JSON-Lines) contiennent l’entrée :
```json
{"time":"03:17","dest":"bridge","msg":"override generated","token":"OVR-???"}
```
Il faut récupérer la valeur du champ token.

+ Ouvrir hangar.log dans VS Code.
+ Rechercher override generated.
+ Copier le token (format : OVR-6HEX).
+ L’entrer dans le clavier numérique de la porte.

*Outils nécessaires*: VS Code. Notepad++, grep, jq ou un visualiseur JSON en ligne.

*Indices graduels*
- Indice 1 : Le mot `override` n’apparaît qu’une seule fois.
- Indice 2 : Le token commence par `OVR-`.
- Indice 3 : Il contient 6 hex, ex. `OVR-AB12CD`. 

*Flag attendu* : `OVR-3FD9A8`

=== _Plan Secret : Stéganographie_ <ch3-5>
Le tableau de bord de la navette exige une pass-phrase de 12 caractères. Les plans techniques `shuttle_blueprint.png` ont un poids inhabituel (14 Mo). Les ingénieurs cachent souvent les mots de passe dans les bits de poids faible.

+ Lancer zsteg `shuttle_blueprint.png`.
+ Extraire la couche `lsb-rgb,b1`. puis fichier `payload.txt`.
+ Ouvrir le fichier : contient `FREEFLY-42`.
+ Saisir la phrase dans la console de la navette ; moteurs au vert !

*Outils nécessaires*: binwalk / steghide / zsteg  et éditeur texte.

*Indices graduels*
- Indice 1 : Regarde les LSB, la taille du PNG est suspecte.
- Indice 2 : zsteg affiche un payload `b1, rgb`. 
- Indice 3 : Le mot comporte 42 à la fin. 

*Flag attendu* : `FREEFLY-42`

Le joueur entre la phrase dans la console de la navette. Les moteurs s’allument, et la porte du hangar s’ouvre. Il peut enfin s’échapper de l’Acheron grâce à la navette de secours.

