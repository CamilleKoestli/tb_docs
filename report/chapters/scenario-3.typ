== Scénario science-fiction : Fuite de l'Acheron <scénario-3>
Dans ce scénario, le joueur incarne un hacker capturé par des pirates de l’espace. Il devra résoudre une série de défis pour pouvoir s'échapper du vaisseau spatial Acheron. Le scénario est inspiré de récits de science-fiction et de jeux vidéo, où les joueurs doivent utiliser leur ingéniosité pour surmonter des obstacles technologiques.

Le premier défi consiste à déverrouiller la porte de sa cellule en retrouvant le mot de passe d'origine à partir d'un hash SHA-1 stocké dans le système de sécurité. Ensuite, il doit exploiter une vulnérabilité de type prototype pollution dans un portail web pour obtenir un accès technicien et débloquer le sas du couloir principal. Le joueur devra également patcher le firmware d'un droïde de maintenance pour neutraliser sa fonction de détection et pouvoir passer sans être repéré. Puis, en utilisant un shell restreint, il devra explorer le système pour récupérer une clé de déverrouillage cachée dans un fichier de service systemd et ouvrir le sas principal du hangar. Enfin, il devra utiliser des techniques de stéganographie pour extraire une phrase secrète dissimulée dans les bits de poids faible d'une image des plans de la navette, permettant ainsi de démarrer les moteurs et de s'échapper.

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

  [1], [#link(<ch3-1>)[HashLock]], [Cryptographie], [Analyse du hash SHA-1 trouvé dans `hatch.cfg`, utilisation d’une rainbow-table pour révéler le code.],
  [2], [#link(<ch3-2>)[Portail Tech]], [Exploitation Web], [Prototype-pollution : injecter `__proto__:{"role":"tech"}` dans le JSON `POST /api/door` afin que l'API donne le token et ouvre le sas du couloir.],
  [3], [#link(<ch3-3>)[Drone Patch]], [Reverse Engineering], [Dans `drn_guard.bin` localiser la chaîne FRIENDLY_UID, remplacer le bloc pour neutralise le droïde sentinelle.],
  [4], [#link(<ch3-4>)[Service Secret]], [Enum système / Forensic], [Avec le shell `tech_guest`, lire `/etc/systemd/system/hangar-door.service` et récupérer `ROOT_KEY` pour déverrouiller le sas principal du hangar.],
  [5], [#link(<ch3-5>)[Plan Secret]], [Stéganographie], [Extraction, avec zsteg, de la charge cachée en LSB dans `shuttle_blueprint.png` pour obtenir la pass-phrase.],
)

=== _HashLock : Cryptographie_ <ch3-1>
Le joueur découvre un boîtier de sécurité sur la porte de sa cellule. Il contient un fichier `hatch.cfg` avec un hash SHA-1. Le but est de retrouver le code d’origine pour déverrouiller la porte.
```ini
unlock_hash = 54b8bc82e430c3bd7a4b52f3c2537ef84c046c07
```

+ Ouvrir la console fournie  et lire hatch.cfg.	Isoler la valeur du hash.
+ Reconnaître qu’un digest de 40 hex qui est SHA-1.
+ Soumettre le hash à une base comme Hashes.com ou CrackStation.com.

*Outils nécessaires*: Navigateur et site de recherche de hash.

*Indices graduels*
- Indice 1 : Le hash fait 40 hexa, ce qui correspond à SHA-1. 
- Indice 2 : Essaie une rainbow table en ligne.
- Indice 3 : Les pirates adorent nommer leurs codes d’après les constellations, pense à un mot spatial + nombre .

*Flag attendu* : `Orion88`


=== _Portail Tech :	Exploitation Web_ <ch3-2>
Le joueur doit accéder au sas du couloir principal, qui est contrôlé par un portail React. Le front-end envoie une requête POST à l’API `http://172.30.0.5:8080/api/door` pour valider le badge du joueur.
Pour valider le badge, le front-end React envoie :
```http
POST /api/door
Content-Type: application/json

{
  "ship_id": 9724,
  "payload": {}
}
```
Le back-end Node.js assemble ensuite :
```js
const cfg = _.merge(
  { role: "guest" },        
  req.body.payload        
);
if (cfg.role === "tech") openDoor();
```
Comme il utilise `lodash.merge` sans vérification, il est vulnérable à la prototype pollution.
En injectant la clé spéciale `__proto__`, le joueur redéfinit la propriété `role` dans l’objet hérité, le sas pense alors que tu es technicien et s’ouvre.

+ Intercepter la requête `POST /api/door`.
+ Rejouer la requête (avec Burp Repeater ou l’onglet Edit and Resend) en remplaçant le JSON par :
  ```json
{
  "ship_id": 9724,
  "payload": {
    "__proto__": { "role": "tech" }
  }
}
```
+ Valider : la réponse renvoie
  ```json
{ 
  "access": "tech",
  "status": "door unlocked",
  "unlock_token": "ACRN-42F9-TEK" 
}
```

*Outils nécessaires*: Navigateur et DevTools.

*Indices graduels*
- Indice 1 : Le code front-end inclut lodash, cherche où `_.merge` est appelé avec `req.body.payload`.
- Indice 2 : Dans JavaScript, la clé magique `__proto__` peut injecter des propriétés dans tous les objets créés ensuite.
- Indice 3 : Si tu ajoutes `__proto__: {"role":"tech"}` dans payload, la condition `cfg.role === "tech"` devient vraie. 

*Flag attendu* : `ACRN-42F9-TEK`


=== _Drone Patch : Reverse Engineering_ <ch3-3>
Le joueur doit maintenant passer le droïde de maintenance qui garde le pont C. Le droïde est contrôlé par un firmware `drn_guard.bin` qui ne laisse passer que les badges dont l'UID est marqué comme "friendly". Par chance, les développeurs ont laissé la chaîne ASCII `FRIENDLY_UID` dans le binaire, juste avant la fonction de comparaison d'UID. En localisant cette chaîne et en remplaçant la comparaison qui suit par un retour 0, le joueur peut rendre le droïde aveugle à tous les badges, lui permettant ainsi de passer jusqu'au pont C sans être détecté.

+ Ouvrir `drn_guard.bin` dans Ghidra.
+ Rechercher la constante ASCII FRIENDLY_UID.
+ Dans l’éditeur d’octets, remplacer `cmp r0, #0xF00D ; bne` `par movs r0,#0 ; bx lr`.
+ Enregistrer le binaire et le relancer.

*Outils nécessaires*: Ghidra, éditeur hexadécimal intégré.

*Indices graduels*
- Indice 1 : Dans Ghidra, liste les Strings et repère FRIENDLY_UID, la zone de code associée suit juste derrière. .
- Indice 2 : Modifie ce test pour qu'il n'échoue jamais `cmp r0,#0xF00D ; bne` `: 0xF00D` est l’UID ami.
- Indice 3 : Remplace les octets par `01 20 70 47` (`movs r0,#0 + bx lr`), ça permet à la fonction de retourner toujours OK.

*Flag attendu* : `KPR-7B9C`
Ce jeton servira ensuite de mot de passe pour le terminal du sas dans le défi 4.

=== _Service Secret: Enum système / Forensic_ <ch3-4>
Le joueur doit maintenant ouvrir le sas principal du hangar C pour accéder à la navette de secours. Le sas est contrôlé par une unité systemd nommée `hangar-door.service`. En se connectant avec le jeton récupéré lors du défi précédent, le joueur obtient un shell restreint `tech_guest`. Les développeurs ont commis l'erreur de laisser le fichier de service lisible par tous, avec la clé de déverrouillage stockée en clair dans la section Environment. Il suffit donc d'afficher le contenu du fichier de service pour récupérer la clé et commander l'ouverture du sas.

+ Lister les unités systemd `systemctl list-unit-files | grep hangar`.
+ Afficher le fichier d’unité `cat /etc/systemd/system/hangar-door.service`.
+ Repérer la variable sensible :
  ```ini
  [Service]
  Environment=ROOT_KEY=HGR-42F9A8
  ExecStart=/usr/local/bin/doorctl --token ${ROOT_KEY}
  ```

*Outils nécessaires*: Shell bash.

*Indices graduels*
- Indice 1 : `systemctl list-unit-files` montre tous les services déclarés.
- Indice 2 : Les fichiers `.service` se trouvent dans `/etc/systemd/system/`.
- Indice 3 : Dans la section `[Service]`, surveille la directive `Environment=` : le mot de passe commence par `HGR-` et comporte 6 caractères hex après le tiret.

*Flag attendu* : `HGR-42F9A8`

=== _Plan Secret : Stéganographie_ <ch3-5>
Enfin, pour faire décoller la navette de secours, le joueur doit entrer une pass-phrase secrète. Les ingénieurs ont caché cette phrase dans les plans techniques de la navette, stockés dans un fichier image `shuttle_blueprint.png`. Le fichier a un poids inhabituel (14 Mo), ce qui laisse penser qu'il contient des données cachées. En utilisant zsteg, le joueur peut extraire les bits de poids faible (LSB) pour révéler la phrase secrète.

+ Lancer zsteg `shuttle_blueprint.png`.
+ Extraire la couche `lsb-rgb,b1`. puis fichier `payload.txt`.
+ Ouvrir le fichier qui contient la phrase secrète.

*Outils nécessaires*: Ninwalk / steghide / zsteg  et éditeur texte.

*Indices graduels*
- Indice 1 : Le PNG pèse 14 Mo, ce qui est trop lourd pour un plan 2D.
- Indice 2 : Zsteg indique un canal `b1, rgb` non vide, c’est souvent là que le texte est stocké. 
- Indice 3 : Le mot-clé final finit par 42. 

*Flag attendu* : `FREEFLY-42`

Le joueur entre la phrase dans la console de la navette. Les moteurs s’allument, et la porte du hangar s’ouvre. Il peut enfin s’échapper de l’Acheron grâce à la navette de secours avec un dernier message : "Mission accomplie ! Tu as réussi à t’échapper de l’Acheron et à éviter les pirates. Les données sensibles sont en sécurité, et tu as prouvé ta valeur en tant que hacker."

