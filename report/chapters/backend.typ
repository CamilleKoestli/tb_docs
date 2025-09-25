== Back-end <implementation-backend>

L’implémentation backend de la plateforme a été conçue pour compléter les interfaces frontend et apporter des mécanismes réalistes aux challenges. Le backend n’est pas utilisé de manière uniforme pour tous les challenges : certains s’appuient sur des scripts spécifiques accessibles via SSH, d’autres sur des routes d’API ou une base de données, tandis que certains n’en nécessitent pas du tout.

=== Challenge 1
Pour ce premier challenge, le backend repose sur l’utilisation du docker `ssh-whois`. Il permet, depuis le terminal intégré côté frontend, de lancer une commande `whois` et de récupérer les informations relatives au domaine frauduleux qui apparaît dans l’email suspect.


=== Challenge 2 // TODO A CORRIGER
Le deuxième challenge exploite davantage le backend, en particulier avec deux aspects.

Le premier, plutôt que de stocker les flags directement dans le code côté frontend (ce qui serait facilement contournable), une API REST a été créée dans le fichier `index.js`. Elle permet de récupérer dynamiquement le flag correspondant à un challenge et à une année.

```js
// Challenge 2 2025
app.post("/challenge2/validate", (req, res) => {
  if (!req.body.user && !req.body.pass) {
    return res.status(400).json({ error: "Email et mot de passe requis" });
  }

  // WAF qui bloque certains patterns d'injection SQL
  function wafFilter(input) {
    const blockedPatterns = [/\bOR\b/i, /--/, /\bUNION\b/i, /\bSELECT\b/i];
    
    for (const pattern of blockedPatterns) {
      if (pattern.test(input)) {
        return false;
      }
    }
    return true;
  }

  const email = req.body.user;
  const password = req.body.pass;

  // Application WAF 
  if (!wafFilter(email) || !wafFilter(password)) {
    return res.status(403).json({ error: "WAF : Tentative d\'injection détectée et bloquée. Patterns bloqués : OR, --, UNION, SELECT" });
  }

  // Première vérif si email existe dans la base de données
  pool.query(
    "SELECT * FROM users WHERE ID = ?",
    [email],
    function (err, results, fields) {
      if (err) {
        return res.status(500).json({ error: "Database error" });
      }
      
      if (results.length === 0) {
        return res.status(404).json({ error: "Email incorrect" });
      }

      // Si email existe, valider mdp avec requête vulnérable
      pool.query(
        "SELECT * FROM users WHERE ID = '" + email + "' AND pass = '" + password + "'",
        function (err, results, fields) {
          if (err) {
            return res.status(500).json({ error: "Authentication error" });
          }
          
          if (results.length > 0) {
            let flag = process.env.CHALL_FLAGS_2025.split(";")
              .filter((x) => x.startsWith("chall2"))[0]
              .split("=")[1];
            return res.status(200).json({ 
              success: true, 
              message: "Authentication ok",
              user: results[0],
              flag: flag
            });
          } else {
            return res.status(401).json({ error: "Mot de passe incorrect" });
          }
        }
      );
    }
  );
});
```

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

=== Challenge 4 // TODO A COMPLETER
Le challenge 4 reprend le principe du challenge 1, mais cette fois avec un docker `ssh-zipinfo`. Ce module permet d’analyser un fichier ZIP via le terminal intégré, directement connecté au backend. Le joueur·euse peut ainsi exécuter une commande `zipinfo` et récupérer des informations sur le contenu de l’archive sans l’ouvrir directement. 


```js
// Challenge 4 2025
app.post("/challenge4/validate", (req, res) => {
  if (!req.body.flag) {
    return res.sendStatus(400);
  }

  const challengeName = "2025_chall4";
  
  db.models.flag.findOne({chall_name: challengeName}, (err, flag) => {
    if (err || !flag) {
      return res.sendStatus(404);
    }

    const hash = new SHA3(256);
    hash.update(req.body.flag);
    
    if (hash.digest('hex') === flag.value) {
      // HTML fichiers décompressés
      const decompressedFilesHtml = `
        <div class="challenge-card">
          <div class="header">
            <h2>📁 Dossier: /archives/2025/patient_audit_07-12</h2>
            <div class="user-info">
              <button disabled title="Accès administrateur requis">🗑️ Supprimer</button>
            </div>
          </div>
          <div class="file-browser">
            <table class="file-table">
              <thead>
                <tr>
                  <th>Nom</th>
                  <th>Type</th>
                  <th>Taille</th>
                  <th>Modifié</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="file-name">🐍 monitor_check_wip.py</td>
                  <td>fichier</td>
                  <td>1.9 KB</td>
                  <td>25/01/2025</td>
                </tr>
                <tr>
                  <td class="file-name">📄 patients_HorizonSante.xlsx</td>
                  <td>fichier</td>
                  <td>67 MB</td>
                  <td>12/07/2025</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      `;

      return res.status(200).json({ 
        success: true, 
        message: "ZIP décompressé",
        decompressedFiles: decompressedFilesHtml 
      });
    } else {
      console.log('invalid flag for challenge 4');
      return res.sendStatus(401);
    }
  });
});
```


=== Challenge 5
Le challenge 5 est entièrement géré côté frontend. Il n’a pas besoin du backend, car l’analyse repose sur l’IDE Python intégré (Pyodide) et les scripts fournis directement dans l’interface.

=== Challenge 6
TODO

=== Challenge 7
Enfin, le challenge 7 ne fait pas appel au backend. L’ensemble du challenge (analyse des logs et blocage de l’adresse IP) est simulé directement côté frontend pour simplifier l’implémentation et rester accessible sans nécessiter de configuration serveur complexe.