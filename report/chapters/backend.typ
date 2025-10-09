== Backend <implementation-backend>

L’implémentation backend de la plateforme a été conçue pour compléter les interfaces frontend et apporter des mécanismes réalistes aux challenges. Le backend n’est pas utilisé de manière uniforme pour tous les challenges : certains s’appuient sur des scripts spécifiques accessibles via SSH, d’autres sur des routes d’API ou une base de données, tandis que certains n’en nécessitent pas du tout.

=== Challenge 1
Pour ce premier challenge, le backend repose sur l’utilisation du docker `ssh-whois`, déjà créé et proposé dans les scénarios précédents. Il permet, depuis le terminal côté frontend, de lancer une commande `whois` et de récupérer les informations relatives au domaine frauduleux qui apparaît dans l’email suspect.


=== Challenge 2
Le deuxième challenge exploite davantage le backend, en particulier avec deux aspects.

Le premier, plutôt que de stocker les flags directement dans le code côté frontend, ce qui serait facilement contournable, une API REST a été créée dans le fichier `index.js`. Cette route `/challenge2/validate` permet de valider les tentatives de connexion et intègre un WAF qui bloque certains patterns d'injection SQL (OR, --, UNION, SELECT). La vulnérabilité réside dans la seconde requête qui concatène directement les entrées utilisateur sans protection :

```js
// Requête vulnérable à l'injection SQL
pool.query(
  "SELECT * FROM users WHERE ID = '" + email + "' AND pass = '" + password + "'",
  function (err, results, fields) {
    // Si authentifié, retourne le flag
    if (results.length > 0) {
      let flag = process.env.CHALL_FLAGS_2025.split(";")
        .filter((x) => x.startsWith("chall2"))[0].split("=")[1];
      return res.status(200).json({ success: true, flag: flag });
    }
  }
);
```

Ensuite, pour rendre la simulation plus crédible, les utilisateurs sont stockés dans une base de données MySQL. Cela permet d'illustrer comment une mauvaise gestion des entrées utilisateur peut permettre d'injecter du SQL et de contourner l'authentification.

=== Challenge 3
Le backend du challenge 3 est centré sur la navigation de répertoires simulés. Le fichier `horizonmain.js` définit la logique permettant de mapper les paramètres `?dir=` de l'URL vers des fichiers HTML spécifiques. La fonction `loadIframe()` récupère le paramètre `dir` et charge la page correspondante dans un iframe selon un mapping prédéfini (`/archives/2025` → `archives_2025.html`). La fonction `navigateToDirectory()` met à jour l'URL et recharge l'iframe lors de la navigation, reproduisant ainsi le comportement d'un gestionnaire de fichiers.

=== Challenge 4
Le challenge 4 reprend le principe du challenge 1, mais cette fois avec un docker `ssh-zipinfo`. Ce module permet d’analyser un fichier ZIP via le terminal intégré, directement connecté au backend. Le joueur·euse peut ainsi exécuter une commande `zipinfo` et récupérer des informations sur le contenu de l’archive sans l’ouvrir directement. 

Pour valider le flag, une route API `/challenge4/validate` a été créée. Elle compare le hash SHA3-256 du flag soumis avec celui stocké en base de données. Si valide, elle renvoie un HTML simulant l'affichage des fichiers décompressés (contenant notamment le fichier `monitor_check_wip.py` révélant les identifiants hardcodés).


=== Challenge 5
Le challenge 5 est entièrement géré côté frontend. Il n’a pas besoin du backend, car l’analyse repose sur l’IDE Python intégré (Pyodide) et les scripts fournis directement dans l’interface.


=== Challenge 6

Le challenge 6 simule un scénario de type "bot headless administrateur" qui visite des pages et déclenche des actions sensibles grâce à un cookie privilégié. Le joueur·euse doit exploiter le bot pour récupérer le flag.

La configuration Docker du bot expose l'API sur le port 3001 via Traefik avec TLS. Un mécanisme de limitation de sessions évite qu'un joueur monopolise le bot trop longtemps. Un service `log-viewer` (Dozzle) permet de monitorer les logs du bot en mode développement.

Le bot, implémenté avec Puppeteer dans `bot.js`, expose une API permettant de créer une session, positionner des cookies et demander au bot d'exécuter des requêtes. Chaque joueur est associé à un identifiant unique `playerId` (UUID) pour éviter les interférences entre plusieurs utilisateurs simultanés.

Côté backend, deux routes sont essentielles :

- `POST /challenge6/validate` : permet de tester si un cookie admin est valide (`ADM1N_53551ON_TOKEN25`)
- `GET /challenge6/deleteFiles` : vérifie le cookie admin dans les headers et, si valide, retourne le flag extrait de la variable d'environnement `CHALL_FLAGS_2025`

```js
app.get("/challenge6/deleteFiles", (req, res) => {
  const adminCookie = req.cookies.admin;

  if (!adminCookie || adminCookie !== "ADM1N_53551ON_TOKEN25") {
    return res.status(403).json({ error: "Accès non autorisé" });
  }

  // Extraction et retour du flag
  const targetFlag = process.env.CHALL_FLAGS_2025
    .split(";").find((flag) => flag.startsWith("chall6="));
  return res.status(200).json({ success: true, flag: targetFlag.split("=")[1] });
});
```


=== Challenge 7
Enfin, le challenge 7 ne fait pas appel au backend. L’ensemble du challenge (analyse des logs et blocage de l’adresse IP) est simulé directement côté frontend pour simplifier l’implémentation et rester accessible sans nécessiter de configuration serveur complexe.