== Back-end <implementation-backend>

L’implémentation backend de la plateforme a été conçue pour compléter les interfaces frontend et apporter des mécanismes réalistes aux challenges. Le backend n’est pas utilisé de manière uniforme pour tous les challenges : certains s’appuient sur des scripts spécifiques accessibles via SSH, d’autres sur des routes d’API ou une base de données, tandis que certains n’en nécessitent pas du tout.

=== Challenge 1
Pour ce premier challenge, le backend repose sur l’utilisation du docker `ssh-whois`. Il permet, depuis le terminal intégré côté frontend, de lancer une commande `whois` et de récupérer les informations relatives au domaine frauduleux qui apparaît dans l’email suspect.


=== Challenge 2
Le deuxième challenge exploite davantage le backend, en particulier avec deux aspects.

Le premier, plutôt que de stocker les flags directement dans le code côté frontend (ce qui serait facilement contournable), une API REST a été créée dans le fichier `index.js`. Elle permet de récupérer dynamiquement le flag correspondant à un challenge et à une année.

```js
// Get flag for specific challenge
app.get("/:year/getFlag/:chall", (req, res) => {
  const { year, chall } = req.params;

  if (!VALID_YEARS.includes(year)) {
    return res.status(404).json({ error: "Invalid year" });
  }

  const flagsString = process.env[`CHALL_FLAGS_${year}`];
  if (!flagsString) {
    return res.status(404).json({ error: "No flags found" });
  }

  const targetFlag = flagsString
    .split(";")
    .find((flag) => flag.startsWith(`chall${chall}=`));
  if (!targetFlag) {
    return res.status(404).json({ error: "Flag not found" });
  }

  return res.json({ flag: targetFlag.split("=")[1] });
});
```
Ce code définit une route `/:year/getFlag/:chall`. Lorsqu’un joueur·euse tente de valider un challenge, l’application appelle cette API en lui passant l’année (par exemple 2025) et le numéro du challenge. La route vérifie d’abord que l’année demandée est valide. Ensuite, elle va chercher dans les variables d’environnement la liste des flags définis pour cette année.\
Chaque flag est stocké sous la forme `challX=FLAG_X`, séparés par des points-virgules. La fonction cherche alors le flag correspondant au challenge demandé et le renvoie au format JSON. Ce mécanisme permet de garder une flexibilité : les flags sont définis côté serveur dans des variables d’environnement et ne sont jamais visibles en clair dans le code source.



Ensuite , Pour rendre la simulation d’une attaque par injection SQL plus crédible, les utilisateurs et leurs mots de passe sont stockés dans une base de données MySQL, plutôt que directement en dur dans le code. Cela permet de montrer le fonctionnement classique d’une application vulnérable.

```sql
insert into users value ("admin@horizonsante.com", "ADMIN1234.");
insert into users value ("test@horizonsante.com", "T3st@H0riz0n");
insert into users value ("support@horizonsante.com", "SUPPORT1234.");
insert into users value ("robin.biro@horizonsante.com", "Horizon09876");
insert into users value ("charlie.brown@horizonsante.com", "pifPAFpouf");
insert into users value ("alice.durand@horizonsante.com", "Blackout_Horizon.");
```
Lorsqu’un utilisateur tente de se connecter, son email et son mot de passe sont vérifiés dans la base. Cela donne l’occasion d’illustrer comment une mauvaise gestion des entrées utilisateur peut permettre d’injecter du SQL et de contourner l’authentification.

=== Challenge 3
Le backend du challenge 3 est centré sur la navigation de répertoires simulés. Le fichier `blackoutmain.js` définit la logique permettant de mapper les paramètres `?dir=` de l’URL vers des fichiers HTML spécifiques.

```js
// Modification fonction loadIframe
function loadIframe(idChall, urlChall) {
  var iframe = document.getElementById("iframeChall");

  if (idChall === "chall3") {
    // Chall3 -> navigation
    var queryParams = new URLSearchParams(window.location.search);
    var dirParam = queryParams.get("dir");

    // Mapping paramètres dir vers html
    var fileMapping = {
      "/": "dir.html",
      "/shared": "shared.html",
      "/shared/": "shared.html",
      "/public": "public.html",
      "/public/": "public.html",
      "/archives": "archives.html",
      "/archives/": "archives.html",
      "/archives/2020": "archives_2020.html",
      "/archives/2020/": "archives_2020.html",
      "/archives/2021": "archives_2021.html",
      "/archives/2021/": "archives_2021.html",
      "/archives/2022": "archives_2022.html",
      "/archives/2022/": "archives_2022.html",
      "/archives/2023": "archives_2023.html",
      "/archives/2023/": "archives_2023.html",
      "/archives/2024": "archives_2024.html",
      "/archives/2024/": "archives_2024.html",
      "/archives/2025": "archives_2025.html",
      "/archives/2025/": "archives_2025.html",
    };

    if (dirParam && fileMapping[dirParam]) {
      // Construire chemin vers html
      var basePath = urlChall.replace("index.html", "");
      iframe.src = basePath + fileMapping[dirParam];
    } else if (dirParam) {
      // Paramètre dir inconnu donc vers dir=/
      var basePath = urlChall.replace("index.html", "");
      iframe.src = basePath + "dir.html";
    } else {
      // Pas de paramètre dir vers index.html
      iframe.src = urlChall;
    }
  } else {
    // Normal autres challs
    iframe.src = urlChall;
  }
}

// Navigation chall3
function navigateToDirectory(dirPath) {
  // MAJ URL
  var newUrl = window.location.pathname + "?dir=" + dirPath;
  history.replaceState(null, null, newUrl);

  // Recharge iframe
  var iframe = document.getElementById("iframeChall");
  if (iframe && iframe.src) {
    // Chemin de base chall3
    var basePath = iframe.src.split("/").slice(0, -1).join("/") + "/";

    // Mapping paramètres dir vers html
    var fileMapping = {
      "/": "dir.html",
      "/shared": "shared.html",
      "/public": "public.html",
      "/archives": "archives.html",
      "/archives/2020": "archives_2020.html",
      "/archives/2021": "archives_2021.html",
      "/archives/2022": "archives_2022.html",
      "/archives/2023": "archives_2023.html",
      "/archives/2024": "archives_2024.html",
      "/archives/2025": "archives_2025.html",
    };

    if (fileMapping[dirPath]) {
      iframe.src = basePath + fileMapping[dirPath];
    }
  }
}
```

Cette fonction récupère le paramètre dir passé dans l’URL et charge la page HTML correspondante dans un iframe. Chaque répertoire (comme `/shared`, `/public` ou `/archives/2025`) correspond à une page HTML distincte.

Une seconde fonction, `navigateToDirectory`, met à jour l’URL et recharge l’iframe lorsque l’utilisateur clique sur un bouton de navigation. Cela permet de reproduire le fonctionnement d’un gestionnaire de fichiers.

=== Challenge 4
Le challenge 4 reprend le principe du challenge 1, mais cette fois avec un docker `ssh-zipinfo`. Ce module permet d’analyser un fichier ZIP via le terminal intégré, directement connecté au backend. Le joueur peut ainsi exécuter une commande `zipinfo` et récupérer des informations sur le contenu de l’archive sans l’ouvrir directement. 


=== Challenge 5
Le challenge 5 est entièrement géré côté frontend. Il n’a pas besoin du backend, car l’analyse repose sur l’IDE Python intégré (Pyodide) et les scripts fournis directement dans l’interface.

=== Challenge 6
TODO

=== Challenge 7
Enfin, le challenge 7 ne fait pas appel au backend. L’ensemble du challenge (analyse des logs et blocage de l’adresse IP) est simulé directement côté frontend pour simplifier l’implémentation et rester accessible sans nécessiter de configuration serveur complexe.