= Implémentation des challenges <implementation>

== Architecture générale <architecture-generale>
La @docker-compose-2025 présente l'architecture mise à jour de la plateforme après l'intégration des nouveaux challenges 2025. L'infrastructure de base reste identique à celle décrite au chapitre @architecture-technique.

Un nouveau service "Admin bot" a été créé sur le port 3002 pour le challenge 6, simulant un administrateur qui interagit avec le frontend via des requêtes automatisées. Le backend expose désormais de nouveaux endpoints spécifiques aux challenges 2025 : `/2025/flag` et `/2025/checkFlag` pour la validation, ainsi que les routes de validation individuelles `/challenge2/validate`, `/challenge5/validate` et `/challenge6/validate`, complétées par l'endpoint `/challenge6/deleteFiles` pour la suppression des fichiers.

Trois conteneurs SSH spécialisés ont été ajoutés pour supporter les nouveaux défis. Le conteneur ssh-whois-modify, pour le challenge 1, propose une variante modifiée du service WHOIS. Le conteneur ssh-zipinfo du challenge 4, fournit des outils d'analyse d'archives. Enfin, le conteneur MySQL est toujours destiné aux exercices d'injection SQL, spécifiquement pour le challenge 2. Cette architecture permet d'isoler chaque nouveau challenge tout en réutilisant l'infrastructure existante de la plateforme.

#figure(
  image("schemas/docker_compose_2025.png"),
  caption: [Architecture Docker Compose de la plateforme _CyberGame_ avec les nouveaux challenges 2025],
)<docker-compose-2025>

#pagebreak()

== Détails d'implémentation par challenge <implementation-details>

L'implémentation de la plateforme a été pensée pour offrir aux joueur·euse·s une expérience immersive et cohérente, tout en restant fidèle au scénario du serious game. Chaque challenge combine une interface frontend simulant des environnements réalistes et, selon les besoins, un backend apportant des mécanismes techniques crédibles. L'objectif était de reproduire, directement dans le navigateur, les étapes que l'on retrouverait dans une véritable enquête de cybersécurité, sans nécessiter l'installation d'outils externes.

=== Challenge 1
Pour le challenge 1, une interface d'email a été développée, comme le montre la @chall1. #figure(image("imgs/chall1.png" , width: 70%), caption: [Visuel du mail avec en dessous le terminal, challenge 1])<chall1> Elle permet d'afficher un message suspect et d'accéder à ses détails techniques grâce à un bouton `Détails`. #figure(image("imgs/chall1'.png", width: 75%), caption: [Visuel des détails du mail, challenge 1])<chall1.1> L'idée est que le joueur·euse puisse à la fois consulter le mail tel qu'un employé l'aurait reçu et analyser ses en-têtes pour remonter au domaine frauduleux.

Le backend repose sur l'utilisation du docker `ssh-whois`, déjà créé et proposé dans les scénarios précédents. Il permet, depuis le terminal côté frontend, de lancer une commande `whois` sur le faux domaine `horizonsante-support.com` et de récupérer les informations relatives au domaine frauduleux qui apparaît dans l'email suspect.

=== Challenge 2
Le challenge 2 propose une page de connexion illustrant une attaque par injection SQL sur un portail frauduleux, protégé par un WAF (pare-feu applicatif) volontairement basique. #figure(image("imgs/chall2''.png", width: 70%), caption: [Page de connexion au portail frauduleux avec un message d'alerte du WAF, challenge 2])<chall2> Après avoir saisi la requête SQL dans le champ de mot de passe, le joueur·euse peut contourner l'authentification et accéder à une page de session simulant la réussite de la connexion. #figure(image("imgs/chall2'.png", width: 70%), caption: [Session connexion réussite, challenge 2])<chall2.>

Côté backend, une API REST a été créée dans le fichier `index.js`. Cette route `/challenge2/validate` intègre un WAF qui bloque certains patterns d'injection SQL (OR, --, UNION, SELECT). La vulnérabilité réside dans la seconde requête qui concatène directement les entrées utilisateur sans protection :

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

Les utilisateurs sont stockés dans une base de données MySQL pour rendre la simulation plus crédible et illustrer comment une mauvaise gestion des entrées utilisateur peut permettre d'injecter du SQL et de contourner l'authentification.

=== Challenge 3
Dans le challenge 3, l'objectif est de mettre en avant la navigation dans des dossiers, afin de sensibiliser aux problèmes de contrôle d'accès. Le joueur·euse commence le défi en arrivant sur le dashboard du site des attaquants. #figure(image("imgs/chall3.png", width: 80%), caption: [Dashboard une fois connecté sur la plateforme des attaquants, challenge 3])<chall3> Sur cette page, il pourra ensuite cliquer sur le lien `Gestion des fichers` qui simule un gestionnaire de fichiers, avec un premier accès restreint au répertoire `/shared`. #figure(image("imgs/chall3'.png", width: 80%), caption: [Dossiers shared, challenge 3])<chall3.1> Le joueur·euse doit manipuler directement l'URL, dans un premier temps, en modifiant le paramètre `?dir=` pour retrouver le dossier racine, qui est la @chall3.2, puis explorer l'arborescence complète. Chaque dossier correspond à une page HTML distincte, ce qui permet de rendre la navigation concrète et progressive. On peut ainsi passer du tableau de bord au répertoire partagé, puis remonter à la racine et enfin atteindre des sous-dossiers sensibles comme `/archives`, qui se trouve dans la @chall3.3. #figure(image("imgs/chall3''.png", width: 80%), caption: [Dossiers racine, challenge 3])<chall3.2>
#figure(image("imgs/chall3'''.png", width: 80%), caption: [Exploration des dossiers jusqu'au dossier `/archives`, challenge 3])<chall3.3>

Le backend est centré sur la navigation de répertoires simulés. Le fichier `horizonmain.js` définit la logique permettant de mapper les paramètres `?dir=` de l'URL vers des fichiers HTML spécifiques. La fonction `loadIframe()` récupère le paramètre `dir` et charge la page correspondante dans un iframe selon un mapping prédéfini. La fonction `navigateToDirectory()` met à jour l'URL et recharge l'iframe lors de la navigation, reproduisant ainsi le comportement d'un gestionnaire de fichiers.

=== Challenge 4
Le challenge 4 introduit un environnement Python directement intégré dans le navigateur grâce à Pyodide. Cette technologie permet d'exécuter du code Python sans rien installer, en offrant un terminal interactif.
#figure(image("imgs/chall4.png"), caption: [IDE Python pour analyser le fichier et terminal afin de pouvoir réaliser un `zipinfo`, challenge 4])<chall4>
Au niveau du terminal, il est possible de changer entre un terminal Linux classique afin que le joueur·euse puisse exécuter la commande système `zipinfo` et un terminal Python pour exécuter des scripts Python. #figure(image("imgs/chall4'.png"), caption: [Terminaux disponibles pour le challenge, challenge 4])<chall4.1>

Le backend reprend le principe du challenge 1, mais cette fois avec un docker `ssh-zipinfo`. Ce module permet d'analyser un fichier ZIP via le terminal intégré, directement connecté au backend. Le joueur·euse peut ainsi exécuter une commande `zipinfo` et récupérer des informations sur le contenu de l'archive sans l'ouvrir directement.

Pour valider le flag, une route API `/challenge4/validate` a été créée. Elle compare le hash SHA3-256 du flag soumis avec celui stocké en base de données. S'il est valide, elle renvoie un HTML simulant l'affichage des fichiers décompressés (contenant notamment le fichier `monitor_check_wip.py` révélant les identifiants hardcodés).

=== Challenge 5
Le challenge 5 garde l'IDE Python embarqué, mais cette fois pour pousser le joueur·euse à écrire un peu de code et analyser un script. Il s'agit de décoder des informations cachées dans un fichier et de reconstituer une URL que les attaquants sont susceptibles d'utiliser. Le terminal et l'IDE sont au cœur de l'interface, de manière à donner l'impression de travailler dans un véritable environnement d'analyse, tout en restant guidé par les consignes du scénario.
#figure(image("imgs/chall5.png"), caption: [IDE Python pour analyser le fichier et réaliser du code pour identifer la page, challenge 5])<chall5>

Ce challenge est entièrement géré côté frontend. Il n'a pas besoin du backend, car l'analyse repose sur l'IDE Python intégré (Pyodide) et les scripts fournis directement dans l'interface.

=== Challenge 6
Le challenge 6 propose une interface avec un chatbot interactif. Il permet au joueur·euse de tester différentes commandes, comme `help`, mais contient aussi des vulnérabilités de sécurité qu'il va devoir exploiter. L'idée était de rendre l'expérience plus ludique et interactive, tout en introduisant des notions liées aux failles XSS et à la compromission de sessions. Le chatbot devient donc à la fois un outil d'aide et une cible d'attaque. #figure(image("imgs/chall6'.png", width: 80%), caption: [Interface du chatbot, challenge 6])<chall6>

Le backend simule un scénario de type "bot headless administrateur" qui visite des pages et déclenche des actions sensibles grâce à un cookie privilégié. Le joueur·euse doit exploiter le bot pour récupérer le flag.

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
Enfin, le challenge 7 recrée l'interface interne de la plateforme hospitalière. #figure(image("imgs/chall7.png", width: 80%), caption: [Interface de la plateforme de l'hôpital, challenge 7])<chall7> Le joueur·euse y trouve un menu latéral regroupant différents outils, comme l'accès aux journaux VPN. Les logs peuvent être ouverts et analysés directement depuis l'interface, ce qui permet de repérer l'adresse IP la plus suspecte. #figure(image("imgs/chall7'.png"), caption: [Visuel des logs, challenge 7])<chall7.1>
Une fois cette IP identifiée, un formulaire intégré permet de la bloquer dans le pare-feu. La validation est confirmée par un message spécifique, simulant le succès de l'action. #figure(image("imgs/chall7''.png", width: 70%), caption: [Formulaire pour bloquer une IP et obtenir le code de validation, challenge 7])<chall7.2>

Ce challenge ne fait pas appel au backend. L'ensemble du challenge (analyse des logs et blocage de l'adresse IP) est simulé directement côté frontend pour simplifier l'implémentation et rester accessible sans nécessiter de configuration serveur complexe.

#pagebreak()

== Intégration sur le site web <integration-site-web>

L’intégration des nouveaux challenges "Horizon" dans la plateforme existante s’est faite en trois parties :

+ Initialisation des flags et extension du modèle de données
+ Ajout d’un nouveau "mini-site" de jeu (fichiers `horizongame.html` et `horizonmain.js`)
+ Raccordement à l’expérience globale (lien depuis `index.html`, popups d’intro avec les indices et configuration `.env`). Ces ajouts s’alignent sur l’architecture en place : un frontend statique routé par Traefik, un backend Express, et des données persistées (MongoDB et MySQL) déjà utilisées par les scénarios 2020/2021.

=== Initialisation des flags côté serveur

Pour éviter de placer les réponses dans le frontend, les flags 2025 sont déclarés dans les variables d’environnement et insérés au démarrage dans MongoDB au format SHA3-256, comme les scénarios 2020/2021. Le fragment suivant, ajouté à `db.js`, parcourt `CHALL_FLAGS_2025`, découpe chaque entrée `challX=VAL`, calcule le hash, puis crée le document Flag s’il n’existe pas.

```js
/* ... */
// Support for 2025 challenges
  const flags_2025 = process.env.CHALL_FLAGS_2025.split(';');

    for await (const flag of flags_2025) {
        const elem = flag.split('=');
        assert(elem.length === 2);
        const hash = new SHA3(256);
        hash.update(elem[1]);
        if (!(await Flag.exists({chall_name: "2025_"+elem[0]})))
            await Flag.create({chall_name: "2025_"+elem[0], value: hash.digest('hex')});
    }
```

=== Ajout du mini-site de jeu "Horizon"
Comme pour les anciens scénarios (chaque challenge = mini-site dans son dossier), Horizon introduit une page de jeu dédiée (`horizongame.html`) et un script de contrôle (`horizonmain.js`). Cette approche permet d’orchestrer l’UI du scénario (iframe principale, champ de réponse, popups d’aide/indices) sans impacter les autres jeux.

==== `horizongame.html`
Le fichier HTML charge le thème, les scripts communs, les popups par challenge (0 à 8) et l’iframe qui héberge l’écran actif. On y retrouve également le champ de validation (réponse) et les includes HTML (header, popups) pour conserver la même UX que les autres scénarios.

```html
<!doctype html>
<head>
    <title>Les données de l'hôpital Horizon Santé ont été volées ! Aide nous à les récupérer.</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,700,800" rel="stylesheet">

    <link rel="stylesheet" href="css/animate.css">
    <link rel="stylesheet" href="css/owl.carousel.min.css">

    <link rel="stylesheet" href="fonts/ionicons/css/ionicons.min.css">
    <link rel="stylesheet" href="fonts/fontawesome/css/font-awesome.min.css">

    <!-- Theme Style -->
    <link rel="stylesheet" href="css/style.css">
    <style>
        canvas {
            margin: 0 auto;
        }
    </style>

    <link rel="apple-touch-icon" sizes="180x180" href="images/favicons/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192" href="images/favicons/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="images/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="images/favicons/favicon-16x16.png">
</head>
<div class="game horizongame" w3-include-html="./header.html"></div>
<body>
    <input id="inputHint" type="text" id="flag" name="flag" placeholder="réponse">
    <button id="sumbitHint" class="submitHint">Valider l'étape !</button>
    <div id="game"></div>
    <iframe id="iframeChall" src="" frameborder="0" style="display: block;background: #000;border: none;overflow:hidden;height:100vh;width:100%">
    </iframe>

    <!-- Challenge popup includes for Horizon 2025 -->
    <div w3-include-html="./challenges2025/0_intro/popup.html"></div>
    <div w3-include-html="./challenges2025/1_mail_contagieux/popup.html"></div>
    <div w3-include-html="./challenges2025/2_portail_frauduleux/popup.html"></div>
    <div w3-include-html="./challenges2025/3_partage_oublie/popup.html"></div>
    <div w3-include-html="./challenges2025/4_cle_cachee/popup.html"></div>
    <div w3-include-html="./challenges2025/5_script_mystere/popup.html"></div>
    <div w3-include-html="./challenges2025/6_cookie_rancon/popup.html"></div>
    <div w3-include-html="./challenges2025/7_blocage_cible/popup.html"></div>
    <div w3-include-html="./challenges2025/8_outro/popup.html"></div>
    <div w3-include-html="./popupSubmitChall.html"></div>
</body>

<script src="js/jquery-3.2.1.min.js"></script>
<script src="js/popper.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/owl.carousel.min.js"></script>
<script src="js/jquery.waypoints.min.js"></script>
<script src="js/template.js"></script>
<script src="js/includehtml.js"></script>
<script>
    includeHTML();
</script>
<script src="js/phaser.min.js"></script>
<script src="js/horizonmain.js"></script>
<script src="node_modules/@azerion/phaser-input/build/phaser-input.js"></script>

<script src="https://www.google.com/recaptcha/api.js"></script>
```

==== `horizonmain.js`

Le fichier `horizonmain.js` (@horizonmain.js) constitue le cœur du moteur du scénario Horizon. Développé avec le framework Phaser, il orchestre l’affichage du niveau, le déplacement du personnage, l’interaction avec les plateformes représentant les différents challenges, ainsi que la communication avec le backend pour la validation des étapes.

Dès l’initialisation, le script charge les éléments visuels nécessaires : le fond, les textures des plateformes, le héros, ainsi que les données décrivant la disposition des plateformes dans le fichier `level01Horizon.json`. 

Chaque plateforme est associée à un challenge et rendue cliquable. Lorsqu’une plateforme est sélectionnée, le personnage se déplace automatiquement jusqu’à elle. Si le challenge est accessible, une popup s’ouvre pour présenter les consignes et permettre de lancer l’interface spécifique. Cette interface est affichée dans une iframe intégrée à la page principale.

La progression est gérée grâce à un système de cookies : `bk2025_xH92f_curr` enregistre l’étape en cours et `bk2025_mP81x_all` mémorise l’ensemble des challenges débloqués.

Lorsqu’un joueur·euse saisit un flag dans le champ de réponse et le valide, le script envoie une requête POST au backend sur la route `/backend/2025/flag`. Le serveur vérifie la validité du flag et renvoie un code HTTP : `200` pour une réussite, ce qui débloque la plateforme suivante et affiche un message de félicitations, `401` si le flag est incorrect, avec un message d’encouragement, `404` en cas d’erreur de challenge. \
Cette logique garantit que la progression se fait de manière linéaire et que les étapes ne sont pas contournables. Les plateformes déjà résolues changent d’apparence (zone verte).

Le moteur intègre également des cas spécifiques, comme pour le Challenge 3, où un paramètre `?dir=` permet de simuler la navigation dans des dossiers via un mapping prédéfini entre les chemins et des pages HTML distinctes.

Enfin, `horizonmain.js` prend en charge la compatibilité et l’expérience utilisateur : il vérifie le type de navigateur et alerte si le jeu est lancé sur un appareil mobile ou un navigateur non supporté, afin de garantir la meilleure expérience possible.

//TODO A REVOIR
=== Raccordement dans la page d’accueil, routage et configuration des flags `.env` / `.env.prod`

Pour exposer le nouveau scénario dans l’UI globale, index.html reçoit une déclaration de l’année dans la constante `VALID_YEARS`, pour que la logique cliente supporte 2025 (comme 2020/2021) et un bloc de présentation (texte + vidéo) et un bouton d’accès à `horizongame.html`.

Cette intégration conserve le parcours utilisateur habituel : découverte, teaser, puis accès aux défis.


```html
<!-- ... -->

const VALID_YEARS = ["2020", "2021", "2025"];
<!-- ... -->
      <a href="./horizongame.html" class="btn btn-white btn-outline-white px-3 py-3 long-txt-button col-2 ml-xl-5"> Horizon<span class="ion-arrow-right-c"></span></a>
<!-- ... -->
<!-- ... -->
<section class="section bg-light element-animate" id="game3">
    <div class="container introhacking">
        <div class="row justify-content-center align-items-center mb-5">
            <h2 class="">Fuite de données dans le Centre Hospitalier Horizon Santé</h2>
        </div>
        <div class="row align-items-center mb-5">
            <div class="col-md-7 pr-md-5 mb-5">
                <div class="block-41">
                    <div class="block-41-text">
                        <p>
                            Le Centre Hospitalier Horizon Santé a été victime d'une cyberattaque majeure, mettant en péril la sécurité des données de ses patients.
                        </p>
                        <p>
                            En tant qu'expert en cybersécurité, ta mission de réussir à infiltrer le domaine des attaquants, supprimer les données volées et bloquer les attaquants.
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 ">
                <!-- TODO CHANGE VIDEO -->
                <!-- <div class="embed-responsive embed-responsive-16by9">
                    <iframe src="https://www.youtube.com/embed/jgkrl94bnvw" allowfullscreen></iframe>
                </div>-->
                <br>
                <a href="./horizongame.html" class="btn btn-white btn-outline-white px-3 py-3 long-txt-button">Accéder aux
                    défis ! <span class="ion-arrow-right-c"></span></a>
            </div>
        </div>
    </div>
</section>
<!-- ... -->
```

Cette page est servie via Traefik (terminaison TLS, StripPrefix pour `/backend` et `/ssh`), ce qui permet au client d’appeler `/backend/...` et d’intégrer des iframes `/ssh?...` sans connaître la topologie interne. C’est ce même schéma qui rend "Horizon" plug-and-play au sein du site.

Enfin, les flags sont définis côté serveur, dans `.env` et `.env.prod`. Lors du boot, `db.js` se charge de les hacher et de les insérer si besoin. Le format clé-valeur séparé par ; reste identique.
```env
#...
CHALL_FLAGS_2025="chall1=horizonsante-support.com;
chall2=co_s3ss10n4cc3s5;chall3=patient_audit_07-12.zip;
chall4=horizon42;chall5=/admin/monitoring/bot_communication_panel_v2;
chall6=all_files_deleted;chall7=blk_185-225-123-77_ok"
```
Les bénéfices d'avoir des flags côté serveur sont qu'aucun secret/flag n’apparaît dans le code client. De plus, cela permet une gestion centralisée et versionnée par année, ainsi qu'une facilité d’opération (rotation, ajout/suppression sans rebuild du frontend).

== Améliorations de l'implémentation et futures corrections <ameliorations-corrections>

//L'implémentation actuelle des challenges 2025 constitue une base fonctionnelle, mais plusieurs axes d'amélioration ont été identifiés pour renforcer la plateforme et son expérience utilisateur.

Le scénario pourrait avoir plus de challenges pour couvrir plus d'aspects de vulnérabilités et techniques d'attaque. Des challenges supplémentaires permettraient d'approfondir certaines thématiques et d'offrir une progression pédagogique plus complète.

Le challenge 6, qui utilise un bot automatisé avec Puppeteer, présente un problème technique de gestion des cookies. Actuellement, le bot récupère les cookies de la session du joueur·euse au lieu d'utiliser son propre cookie administrateur privilégié.

Enfin le challenge 7 a une petite incohérence scénaristique. Le joueur·euse est censé·e bloquer une IP malveillante, mais en réalité l'attaquant pourrait tout a fait utiliser une autre IP pour continuer son attaque. Une meilleure approche serait de simuler un blocage plus efficace, comme la fermeture du port d'accès.
