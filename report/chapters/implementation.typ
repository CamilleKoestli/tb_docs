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
Pour le challenge 1, une interface d'email a été développée, comme le montre la @chall1. #figure(image("imgs/chall1.png"), caption: [Visuel du mail avec en dessous le terminal, challenge 1])<chall1> Elle permet d'afficher un message suspect et d'accéder à ses détails techniques grâce à un bouton `Détails`. #figure(image("imgs/chall1'.png"), caption: [Visuel des détails du mail, challenge 1])<chall1.1> L'idée est que le joueur·euse puisse à la fois consulter le mail tel qu'un employé l'aurait reçu et analyser ses en-têtes pour remonter au domaine frauduleux.

Le backend repose sur l'utilisation du Docker `ssh-whois`, déjà créé et proposé dans les scénarios précédents. Il permet, depuis le terminal côté frontend, de lancer une commande `whois` sur le faux domaine `horizonsante-support.com` et de récupérer les informations relatives au domaine frauduleux qui apparaît dans l'email suspect.

=== Challenge 2
Le challenge 2 propose une page de connexion illustrant une attaque par injection SQL sur un portail frauduleux, protégé par un WAF (pare-feu) volontairement basique. Dans la @chall2 on peut voir une requête basique comme `OR 1=1; --` #figure(image("imgs/chall2''.png"), caption: [Page de connexion au portail frauduleux avec un message d'alerte du WAF, challenge 2])<chall2> Après avoir la connexion à la session réussie, le joueur·euse peut contourner l'authentification et accéder à une page de session simulant la réussite de la connexion. #figure(image("imgs/chall2'.png"), caption: [Session connexion réussite, challenge 2])<chall2.>

Côté backend, une API REST a été créée dans le fichier `index.js`. Cette route `/challenge2/validate` intègre un WAF qui bloque certains patterns d'injection SQL (`OR`, `--`, `UNION`, `SELECT`). La vulnérabilité réside dans la seconde requête qui concatène directement les entrées utilisateur sans protection :

```js
// Requête vulnérable à l'injection SQL
pool.query(
  "SELECT * FROM users WHERE ID = '" + email + "' AND pass = '" + password + "'",
  /* ... */
```

Les utilisateurs sont stockés dans une base de données MySQL pour rendre la simulation plus crédible, dans le cas où un joueur·euse voudrait essayer de récupérer des identifiants, et illustrer comment une mauvaise gestion des entrées utilisateur peut permettre d'injecter du SQL et de contourner l'authentification.

=== Challenge 3
Dans le challenge 3, l'objectif est de mettre en avant la navigation dans des dossiers, afin de sensibiliser aux problèmes de contrôle d'accès. Le joueur·euse commence le défi en arrivant sur le dashboard du site des attaquants. #figure(image("imgs/chall3.png"), caption: [Dashboard une fois connecté sur la plateforme des attaquants, challenge 3])<chall3> Sur cette page @chall3, il pourra ensuite cliquer sur le lien `Gestion des fichers` qui simule un gestionnaire de fichiers, avec un premier accès restreint au répertoire `/shared`. #figure(image("imgs/chall3'.png"), caption: [Dossiers shared, challenge 3])<chall3.1> Le joueur·euse doit manipuler directement l'URL, dans un premier temps, en modifiant le paramètre `?dir=` (@chall3.1) pour retrouver le dossier racine, comme visible dans la @chall3.2, puis explorer l'arborescence complète. Chaque dossier correspond à une page HTML distincte, ce qui permet de rendre la navigation concrète et progressive. On peut ainsi passer du tableau de bord au répertoire partagé, puis remonter à la racine et enfin atteindre des sous-dossiers sensibles comme `/archives`, qui se trouve dans la @chall3.3. #figure(image("imgs/chall3''.png"), caption: [Dossiers racine, challenge 3])<chall3.2>
#figure(image("imgs/chall3'''.png"), caption: [Exploration des dossiers jusqu'au dossier `/archives`, challenge 3])<chall3.3>

Le backend est centré sur la navigation de répertoires simulés. Le fichier `horizonmain.js` définit la logique permettant de mapper le paramètre `?dir=` de l'URL vers des fichiers HTML spécifiques. La fonction `loadIframe()` récupère le paramètre `dir` et charge la page correspondante dans un iframe selon un mapping prédéfini. Ce mapping agit comme une liste blanche qui garantit que seules les pages prévues par le scénario sont accessibles, ce qui évite toute tentative de path traversal et simplifie la gestion des états du jeu. La fonction `navigateToDirectory()` met à jour l'URL et recharge l'iframe lors de la navigation, reproduisant ainsi le comportement d'un gestionnaire de fichiers.

=== Challenge 4
Le challenge 4 a besoin d'un environnement Python afin de réaliser un petit script. Il est donc directement intégré dans le navigateur grâce à Pyodide, qui embarque l'interpréteur Python. Cette technologie permet d'exécuter du code Python sans rien installer et permet à l'IDE de fonctionner ainsi que le terminal interactif visibles dans l'interface. L'exécution reste côté navigateur, ce qui évite de maintenir un conteneur backend simplement pour lancer du Python.
#figure(image("imgs/chall4.png"), caption: [IDE Python pour analyser le fichier et terminal afin de pouvoir réaliser un `zipinfo`, challenge 4])<chall4>
Au niveau du terminal, il est possible de changer entre un terminal Linux classique pour que le joueur·euse puisse exécuter la commande système `zipinfo` et un terminal Python pour exécuter des scripts Python. #figure(image("imgs/chall4'''.png"), caption: [Terminaux disponibles pour le challenge 4])<chall4.1>

Le backend reprend le principe du challenge 1, mais cette fois avec un conteneur Docker `ssh-zipinfo`, ce qui permet d'analyser un fichier ZIP via le terminal intégré, directement connecté au backend. Le joueur·euse peut ainsi exécuter une commande `zipinfo` et récupérer des informations sur le contenu de l'archive sans l'ouvrir directement.

Pour valider le flag, une route API `/challenge4/validate` a été créée. Elle compare le hash SHA3-256 du flag soumis avec celui stocké en base de données. S'il est valide, elle renvoie un HTML simulant l'affichage des fichiers décompressés (contenant notamment le fichier `monitor_check_wip.py` révélant les identifiants hardcodés).

=== Challenge 5
Le challenge 5 garde l'IDE Python embarqué, mais cette fois pour pousser le joueur·euse à écrire un peu de code et analyser un script. Il s'agit de décoder des informations cachées dans un fichier et de reconstituer une URL que les attaquants sont susceptibles d'utiliser. Le terminal et l'IDE sont au cœur de l'interface, de manière à donner l'impression de travailler dans un véritable environnement d'analyse, tout en restant guidé par les consignes du scénario.
#figure(image("imgs/chall5.png"), caption: [IDE Python pour analyser le fichier et réaliser du code pour identifer la page, challenge 5])<chall5>

Ce challenge est entièrement géré côté frontend. Il n'a pas besoin du backend, car l'analyse repose sur un IDE web qui s'appuie sur Pyodide et sur les scripts fournis directement dans l'interface.

=== Challenge 6
Le challenge 6 propose une interface avec un chatbot interactif. Il permet au joueur·euse de tester différentes commandes, comme `help`. L'idée était de rendre l'expérience plus ludique et interactive, tout en introduisant des notions liées aux failles XSS et à la compromission de sessions. Le chatbot devient donc à la fois un outil d'aide et une cible d'attaque. #figure(image("imgs/chall6'.png"), caption: [Interface du chatbot, challenge 6])<chall6>

Le backend simule un bot connecté avec les droits administrateurs et ouvre les pages du chat pour chaque joueur connecté. Pour que les payloads XSS insérés dans le chat s'exécutent réellement, le bot commande un navigateur headless (Puppeteer) qui charge la conversation de l'utilisateur, attend un court moment pour laisser le script s'exécuter, puis referme l'onglet. Chaque joueur dispose d'un contexte isolé, le bot régénère un contexte séparé à chaque session afin d'éviter toute fuite de messages entre participant·e·s.

La configuration Docker du bot expose l'API sur le port 3001 via Traefik avec TLS. Un mécanisme de limitation de sessions évite qu'un joueur·euse monopolise le bot trop longtemps. Un service `log-viewer` (Dozzle) permet de monitorer les logs du bot en mode développement.

Le bot, implémenté avec Puppeteer dans `bot.js`, expose une API permettant de créer une session, positionner des cookies et demander au bot d'exécuter des requêtes. Chaque joueur·euse est associé·e à un identifiant unique `playerId` (UUID) pour éviter les interférences entre plusieurs utilisateur·trice·s simultané·e·s.

Côté backend, deux routes sont essentielles :

- `POST /challenge6/validate` : permet de tester si un cookie admin est valide (`ADM1N_53551ON_TOKEN25`).
- `GET /challenge6/deleteFiles` : une fois le cookie admin obtenu via une attaque XSS, le joueur·euse peut appeler cette route pour supprimer tous les fichiers et récupérer le flag (code ci-dessous).

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
Enfin, le challenge 7 recrée l'interface interne de la plateforme hospitalière. #figure(image("imgs/chall7.png"), caption: [Interface de la plateforme de l'hôpital, challenge 7])<chall7> Le joueur·euse y trouve un menu latéral regroupant différents outils, comme l'accès aux journaux VPN. Les logs peuvent être ouverts et analysés directement depuis l'interface, ce qui permet de repérer l'adresse IP la plus suspecte (@chall7.1). #figure(image("imgs/chall7'.png"), caption: [Visuel des logs, challenge 7])<chall7.1>
Une fois cette IP identifiée, un formulaire intégré (@chall7.2) permet de la bloquer dans le pare-feu. La validation est confirmée par un message spécifique, simulant le succès de l'action. #figure(image("imgs/chall7''.png"), caption: [Formulaire pour bloquer une IP et obtenir le code de validation, challenge 7])<chall7.2>

Ce challenge ne fait pas appel au backend. L'ensemble du challenge (analyse des logs et blocage de l'adresse IP) est simulé directement côté frontend pour simplifier l'implémentation et rester accessible sans nécessiter de configuration serveur complexe.

#pagebreak()

== Intégration sur le site web <integration-site-web>

L’intégration des nouveaux challenges "Horizon" dans la plateforme existante s’est faite en trois parties :

+ Initialisation des flags et extension du modèle de données
+ Ajout d’un nouveau "mini-site" de jeu (fichiers `horizongame.html` et `horizonmain.js`)
+ Raccordement à l’expérience globale (lien depuis `index.html`, popups d’intro avec les indices et configuration `.env`). Ces ajouts s’alignent sur l’architecture en place (@architecture-technique) et permettent de maintenir une cohérence avec les scénarios précédents.

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

==== `horizonmain.js`

Le fichier `horizonmain.js` (@horizonmain.js) constitue le cœur du moteur du scénario Horizon. Développé avec le framework Phaser, il orchestre l’affichage du niveau, le déplacement du personnage, l’interaction avec les plateformes représentant les différents challenges, ainsi que la communication avec le backend pour la validation des étapes.

Dès l’initialisation, le script charge les éléments visuels nécessaires : le fond, les textures des plateformes, le héros, ainsi que les données décrivant la disposition des plateformes dans le fichier `level01Horizon.json`. 

Chaque plateforme est associée à un challenge et rendue cliquable. Lorsqu’une plateforme est sélectionnée, le personnage se déplace automatiquement jusqu’à elle. Si le challenge est accessible, une popup s’ouvre pour présenter les consignes et permettre de lancer l’interface spécifique. Cette interface est affichée dans une iframe intégrée à la page principale.

La progression est gérée grâce à un système de cookies : `bk2025_xH92f_curr` enregistre l’étape en cours et `bk2025_mP81x_all` mémorise l’ensemble des challenges débloqués.

Lorsqu’un joueur·euse saisit un flag dans le champ de réponse et le valide, le script envoie une requête POST au backend sur la route `/backend/2025/flag`. Le serveur vérifie la validité du flag et renvoie un code HTTP : `200` pour une réussite, ce qui débloque la plateforme suivante et affiche un message de félicitations, `401` si le flag est incorrect, avec un message d’encouragement, `404` en cas d’erreur de challenge. \
Cette logique garantit que la progression se fait de manière linéaire et que les étapes ne sont pas contournables. Les étapes déjà résolues changent d’apparence (zone verte).

Le moteur intègre également des cas spécifiques, comme pour le Challenge 3, où un paramètre `?dir=` permet de simuler la navigation dans des dossiers via un mapping prédéfini entre les chemins et des pages HTML distinctes.

Enfin, `horizonmain.js` prend en charge la compatibilité et l’expérience utilisateur : il vérifie le type de navigateur et alerte si le jeu est lancé sur un appareil mobile ou un navigateur non supporté, afin d'afficher une erreur si le navigateur n'est pas supporté.

//TODO A REVOIR
=== Raccordement dans la page d’accueil, routage et configuration des flags `.env` / `.env.prod`

Pour exposer le nouveau scénario dans l’UI globale, index.html reçoit une déclaration de l’année dans la constante `VALID_YEARS`, pour que la logique cliente supporte 2025 (comme 2020/2021) et un bloc de présentation (texte + vidéo) et un bouton d’accès à `horizongame.html`.

Cette intégration conserve le parcours utilisateur habituel : découverte, teaser, puis accès aux défis. Cette page est servie via Traefik, ce qui permet au client d’appeler `/backend/...` et d’intégrer des iframes `/ssh?...` sans connaître la topologie interne.

Enfin, les flags sont définis côté serveur, dans `.env` et `.env.prod`. Lors du boot, `db.js` se charge de les hacher et de les insérer si besoin. Le format clé-valeur séparé par ; reste identique.

Les bénéfices d'avoir des flags côté serveur sont qu'aucun secret/flag n’apparaît dans le code client. De plus, cela permet une gestion centralisée et versionnée par année, ainsi qu'une facilité d’opération (rotation, ajout/suppression sans rebuild du frontend).

== Améliorations de l'implémentation et futures corrections <ameliorations-corrections>

//L'implémentation actuelle des challenges 2025 constitue une base fonctionnelle, mais plusieurs axes d'amélioration ont été identifiés pour renforcer la plateforme et son expérience utilisateur.

Le scénario pourrait avoir plus de challenges pour couvrir plus d'aspects de vulnérabilités et techniques d'attaque. Des challenges supplémentaires permettraient d'approfondir certaines thématiques et d'offrir une progression pédagogique plus complète.

Le challenge 6, qui utilise un bot automatisé avec Puppeteer, révèle plutôt un problème côté client : le payload XSS s'exécute d'abord dans le navigateur du joueur·euse avant que le bot ne visite la page. Résultat, un message répété apparaît avec les cookies de l'utilisateur, puis un second avec ceux du bot. Il serait utile de conditionner l'exécution (ex. vérification du cookie admin) ou de limiter l'usage de `innerHTML` côté joueur afin d'éviter ce comportement par défaut.

Enfin le challenge 7 a une petite incohérence scénaristique. Le joueur·euse est censé·e bloquer une IP malveillante, mais en réalité l'attaquant pourrait tout a fait utiliser une autre IP pour continuer son attaque. Une meilleure approche serait de simuler un blocage plus efficace, comme la fermeture du port d'accès.
