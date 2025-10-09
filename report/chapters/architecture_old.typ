// = Architecture de la plateforme _CyberGame_ existante <architecture>
// Ce chapitre présente l'architecture technique de la plateforme _CyberGame_, en détaillant le frontend et backend, ainsi que les mécanismes de jeu. Il est important de souligner qu'il s'agit d'une analyse de la plateforme de 2020 avant sa restructuration qui a eu lieu en 2025. Cette analyse porte donc sur l’état initial du site, avant l’ajout de nouvelles fonctionnalités, la refonte du design ou l’amélioration de l’expérience utilisateur.

// == Présentation générale <presentation>
// Le site web est une plateforme pédagogique créée par le pôle Y-Security de la HEIG-VD. Il a pour objectif d'introduire au ethical hacking et propose actuellement deux scénarios interactifs. La plateforme est donc conçue avec une page d'accueil @InitiationAuEthical qui présente le cadre général. Le premier jeu "Shana a disparu" @ShanaDisparuRetrouvela ainsi qu'un autre scénario "Sauve la Terre de l'arme galactique !" @SauveTerreLarme se trouvent sur la plateforme. Pour aider les joueur·euse·s à avancer dans les différents challenges, tout en restant dans son navigateur, une boîte à outils et un petit IDE Python ont été mis en place @InitiationAuEthical.

// #figure(
//   image("schemas/site_web.png"),
//   caption: [Schéma de l'architecture globale de la plateforme _CyberGame_],
// )<site_web>

// == Mécanisme de jeu <mécanisme-de-jeu>

// La plateforme _CyberGame_ propose deux parcours structurés sous forme d'histoire progressive qui mettent en œuvre des techniques du hacking éthique. Chacun propose une enquête avec un scénario dont les étapes doivent être validées dans l'ordre afin de pouvoir progresser dans le déroulement de l'enquête.

// Le participant·e découvre, étape par étape, la méthodologie d'un professionnel de la cybersécurité à travers la chaîne "collecte – exploitation – preuve", où chaque résolution dévoile un indice pour le défi suivant. Chaque challenge reste en surface pour montrer à quoi pourrait ressembler des attaques de grandes envergures qui combinent une suite de failles bien différentes sur des aspects réseau, d'application web, d'analyses de fichier ou de systèmes intégrant de la cryptographie.

// === Scénario 1 : "Shana a disparu" <shana>

// Le scénario "Shana a disparu" @ShanaDisparuRetrouvela a pour objectif d'amener le joueur·euse dans une enquête de neuf challenges qui imite la progression d'une investigation numérique. L'histoire commence par la reconstruction du mot de passe Windows de Shana à partir des informations qui se trouvent sur le profil Instagram de la victime. Le challenge suivant est l'exploration de l'historique de navigation pour extraire ses derniers sites consultés. Une fois le site trouvé, un lien caché en texte invisible est inséré sur la page. Le défi suivant consiste à inspecter le code source pour trouver des informations qui vont nous permettre de progresser. Une fois l'information trouvée, le jeu redirige le joueur·euse vers une page où la manipulation de cookie est nécessaire et où il faut modifier la valeur d'une variable de session pour débloquer la page cachée. Ensuite, il s'agit d'un chiffrement de César qu’il faut renverser pour découvrir une date clé, puis l’altération manuelle de la fin d’une URL afin d’accéder à un répertoire non indexé. Le challenge suivant demande une injection SQL qui va permettre de contourner l'authentification et d'obtenir de nouvelles informations, qui se trouvent grâce à l’extraction des coordonnées GPS dissimulées dans les métadonnées EXIF d’une photo.


// === Scénario 2 : "Sauve la Terre de l'arme galactique !" <galacgame>

// Le second scénario que nous retrouvons sur la plateforme "Sauve la Terre de l'arme galactique !" @InitiationAuEthical, utilise les mêmes principes mais dans un univers de science-fiction. Le joueur·euse est plongé·e dans une enquête afin de retrouver les plans d'une arme galactique et ainsi sauver le monde. Dans un premier temps, le joueur·euse exploite la barre de recherche d'un réseau fictif pour obtenir des fragments de conversation. Ensuite, le participant·e va utiliser l’ingénierie sociale pour retrouver des réponses de sécurité, imprudemment divulguées en ligne, ce qui va permettre de retrouver le mot de passe et ainsi d'accéder au profil. Des challenges similaires se retrouvent dans les deux jeux comme la manipulation des cookies, l'ajustement d'un paramètre dans l'URL d'un lien, l'injection SQL afin de contourner un mot de passe, l'utilisation des métadonnées d'une image à l'aide de l'outil exiftool et enfin de la cryptographie. Des challenges supplémentaires ont été ajoutés comme l'utilisation d'une requête WHOIS, qui sert à identifier le propriétaire d'une adresse IPv6 et intercepter son trafic. Pour terminer, le joueur·euse doit réaliser une attaque par bruteforce en codant un petit script Python.


// // === Techniques mobilisées <technologies-utilisees>

// // Les jeux utilisent un ensemble de techniques du hacking éthique : recherche OSINT sur les réseaux sociaux, lecture du code HTML et des CSS pour trouver du contenu dissimulé, modification manuelle des cookies et des paramètres de l'URL afin de détourner la logique d'un site, injection SQL afin de contourner les contrôles d'authentification, extraction et interprétation des métadonnées EXIF d'images, cryptanalyse, rédaction de courts scripts Python, enfin, utilisation des services WHOIS et des requêtes DNS pour cartographier une infrastructure et remonter jusqu'à son propriétaire, le tout dans une histoire narrative progressive.

// // Le participant·e découvre, étape par étape, la méthodologie d'un professionnel de la cybersécurité à travers la chaîne "collecte – exploitation – preuve", où chaque résolution dévoile un indice pour le défi suivant.

// == Analyse critique <positifs-améliorer>
// === Points forts
// Parmi les forces de la plateforme, les enquêtes sont construites afin de suivre une progression graduelle. Chaque épreuve ré-exploite la précédente et favorise un apprentissage différent. La narration permet de maintenir le joueur·euse motivé·e mais le garde dans une optique d'apprentissage.

// En effet, la boîte à outils intégrée, qui contient les fiches pratiques, évite aux débutant·e·s de devoir faire trop de recherches et ainsi leur permet de se focaliser sur le jeu.

// De plus, grâce à un mini IDE Python et un terminal intégré, comme le montre la @ide-img et @terminal-img, le joueur·euse n'a rien besoin d'installer sur sa machine. L'expérience se déroule entièrement sur le navigateur ce qui abaisse la barrière d’entrée, et la variété des techniques abordées offrant un panorama cohérent de la sécurité offensive.
// #figure(
//   image("imgs/ide-interface.png"),
//   caption: [IDE présent sur le jeu "Sauve la Terre de l'arme galactique !", dans le challenge 6],
// )<ide-img>
// #figure(
//   image("imgs/terminal-interface.png"),
//   caption: [Terminal présent sur les 2 jeux, dans les challenges 9 de "Shana a disparu" et 5, 8 dans "Sauve la Terre de l'arme galactique !"],
// )<terminal-img>

// === Axes d'amélioration
// Quelques points mériteraient des améliorations. D’abord, la police VT323-Regular permet de créer une certaine ambiance mais elle est peu lisible, ce qui peut gêner la compréhension et la lecture des consignes.

// La gestion de la fenêtre du jeu pourrait être optimisée, par exemple après la fermeture d’une popup, le joueur·euse se retrouve parfois avec un fond noir sans indication. Il serait utile d’ajouter des repères visuels ou des messages d’aide pour guider l’utilisateur·trice dans la progression, et de mieux intégrer la boîte à outils dès la page d’accueil pour que chacun·e sache où trouver les ressources.

// Le design du site présente parfois des problèmes d’affichage selon la taille de la fenêtre du navigateur, comme le chevauchement d’éléments.

// Le champ pour saisir sa réponse ne précise pas toujours le format exigé. De temps en temps, la consigne affiche un mot mis en gras, qui représente la réponse attendue, mais l’information passe facilement inaperçue ou l’utilisateur·trice ignore toujours le format attendu (un mot-clé, une URL complète, un hash ou une date). Inclure le format attendu avec des exemples, dans l'indice ou dans la consigne, pourrait faciliter la validation du challenge une fois le secret trouvé.

// Ensuite, pour la validation de l'étape, il faut impérativement entrer une réponse valide dans le champ "Réponse" malgré que l'interface visuelle du jeu change en fonction de ce que le joueur·euse à réalisé comme manipulation et du message de félicitations.
// #figure(
//   image("imgs/bug-interface1.png"),
//   caption: [Interface du jeu après la validation d'un challenge],
// )<bug-interface1-imgs>

// Dans la @bug-interface1-imgs, nous pouvons voir que le joueur·euse à bien réussi à trouver la réponse du challenge. Cependant, comme le montre la @bug-interface2-imgs, l'interface de travail ne change pas. Le joueur·euse peut ne pas comprendre ce qu'il doit faire et peut rester bloqué car il ne sait pas ce qui est attendu de lui.

// #figure(
//   image("imgs/bug-interface2.png"),
//   caption: [Interface du jeu bloquée entre deux challenges sans information claire sur la prochaine étape de progression.],
// )<bug-interface2-imgs>

// Le passage d’un challenge au suivant manque parfois de fiabilité, la popup explicative ne s’ouvre pas systématiquement et la barre de progression reste figée. Le participant·e doit donc cliquer sur l'étape suivante pour accéder à la consigne du challenge suivant ainsi que la nouvelle interface de travail.

// Un autre élément d'amélioration serait de réaliser un changement de curseur sur les éléments cliquables (par exemple, en utilisant `cursor: pointer` en CSS) pour permettre au joueur·euse d’identifier les zones interactives. Actuellement, certains éléments interactifs ne sont pas mis en valeur, ce qui peut rendre la navigation moins intuitive.

// Enfin, les indices actuels fournissent, dans un premier temps, un bon point de départ. Cependant, cela peut se révéler insuffisant pour les joueur·euse·s débutant·e·s. La mise en place d'aides graduelles pourraient limiter le risque d'abandon tout en gardant le défi intéressant.


// == Architecture technique <architecture-technique>

// === Vue d'ensemble de l'infrastructure <vue-ensemble>

// La plateforme _CyberGame_ est hébergée sur un serveur web accessible sur le sous domaine `cybergame.heig-vd.ch`. L'architecture repose sur une infrastructure conteneurisée réalisée à l'aide de Docker Compose, ce qui permet une séparation claire des responsabilités entre les différents composants du système.

// #figure(
//   image("schemas/docker_compose.png", width: 95%),
//   caption: [Architecture Docker Compose de la plateforme _CyberGame_],
// )<docker-compose-img>

// La @docker-compose-img montre l'architecture complète de la plateforme. Au sommet de cette infrastructure se trouve Traefik, un reverse proxy moderne qui joue le rôle de point d'entrée unique pour toutes les requêtes entrantes. Traefik écoute sur les ports standards `80` (HTTP) et `443` (HTTPS) et gère automatiquement la terminaison TLS ainsi que le routage vers les services internes.

// Le schéma met en évidence trois services principaux accessibles via Traefik. Le Frontend, accessible sur le port `3001` en interne, représente l'interface utilisateur de la plateforme et communique avec le backend via le protocole HTTP. Le backend, exposé sur le port `3000`, représente la logique de l'application et expose une API REST, qui est détaillée. Cet encadré liste l'ensemble des endpoints disponibles, organisés par domaine fonctionnel. Le troisième service principal, webssh, écoute sur le port `8888` et fournit une interface web permettant l'accès SSH aux environnements d'exercice.

// Le service webssh agit comme une passerelle SSH et permet de se connecter trois conteneurs SSH spécialisés, qui fournissent un accès aux environnements Linux restreints. Le conteneur `ssh-whois` est dédié aux exercices de requêtes WHOIS. Le conteneur ssh-machine fournit des outils d'analyse système. Le conteneur `ssh-galactic-forensic` est utilisé pour les défis d'analyse forensique.

// La persistance des données s'appuie sur deux systèmes de gestion de base de données distincts, représentés en bas du schéma. MongoDB, accessible via le port `27017`, stocke les données critiques de la plateforme, les flags stockés dans le fichier `.env`. MySQL, accessible sur le port `3306`, est exclusivement utilisé pour les exercices d'injection SQL et ne contient aucune donnée critique du système. \
// La séparation en 2 systèmes de gestion de base de données permet d'isoler les données sensibles.

// === Configuration Docker Compose <docker-compose-config>

// Le fichier `docker-compose.yml` (@docker-compose.yml) définit l'ensemble des services nécessaires à l'application et orchestre leur déploiement. Un reverse proxy Traefik gère le TLS et route les requêtes vers trois groupes de services : l'API backend, le site frontend et la passerelle webssh qui sert d'interface vers des machines SSH utilisées pour certains défis.

// Le service Traefik agit comme point d'entrée de la plateforme, qui écoute sur les ports `80` et `443`. Il assure la terminaison TLS et effectue un routage sur des labels Docker. L'entrypoint web redirige automatiquement le trafic HTTP vers HTTPS pour garantir la sécurité des communications. 
// // Le routage s'appuie sur trois règles principales : le frontend est servi sur la racine du domaine, le backend est accessible via le préfixe `/backend` avec un middleware StripPrefix, et le service webssh est routé via les préfixes `/ssh` et `/static`.

// Le code du backend se trouve dans le répertoire `DigitalDay_BACKEND` et constitue l'API REST. Il utilise Node.js Express et intègre les middlewares essentiels. Le service attend la disponibilité de MySQL et MongoDB avant de démarrer.

// Le frontend se trouve dans le répertoire depuis `DigitalDay_APP`, sur le port `3001` et est routé par Traefik sur la racine du domaine. 

// // Le service webssh, basé sur un serveur Python wssh, fournit une interface web pour accéder aux conteneurs SSH internes. Il est routé via les préfixes `/ssh` et `/static` et permet l'accès sécurisé aux machines cibles sans exposition directe sur Internet.

// === Frontend <frontend>

// La structure du frontend montre que chaque défi est développé comme un "mini-site" indépendant dans son propre dossier. Cela permet d'obtenir ainsi une architecture claire et modulaire qui facilite la maintenance et l’ajout de nouveaux niveaux.
// Chaque challenge suit une structure composée de plusieurs éléments, chacun avec un rôle spécifique dans l'expérience pédagogique.

// Le dossier racine du challenge (par exemple `01_windows_login/`, `07_url_modification/`, ...) contient toutes les ressources spécifiques à l'épreuve. Le fichier HTML de lancement (comme `windows_login.html` ou `gallery1.html`, ...) représente la partie interactive visible par le joueur. Ce fichier charge systématiquement plusieurs ressources : un CSS située dans `css/style.css`, avec parfois un script global stocké dans `/js`, ainsi que le header commun comprenant le logo, le compteur de progression et le bouton "Retour". Un élément `div.popup-trigger` est toujours présent pour déclencher l'affichage de la popup d'aide. Le sous-dossier `css/` contient les styles spécifiques au challenge. Le fichier CSS définit l'apparence visuelle (police, arrière-plan, couleurs). Le sous-dossier `img/` stocke les ressources visuelles nécessaires comme les illustrations, les captures d'écran et les images de fond. Par exemple, `background_history.png` sert uniquement visuel du niveau "Browser History". Le fichier `popup.html` présente la popup d'introduction et d'indices.

// Tous les challenges utilisent la même structure pour la popup, c'est-à-dire un titre, le contexte de l'épreuve et un bouton "Commencer le challenge !" pour lancer le défi. En dessus de ce bouton, se trouve aussi le bouton "Indice" qui permet d'obtenir l'indice pour résoudre le challenge.

// Lorsque le joueur·euse arrive sur une page de challenge, une popup s'ouvre automatiquement pour montrer le contexte du défi et expliquer l'objectif.

// L'utilisateur·trice peut ensuite interagir avec la page selon ce qui lui est demandé, cela peut être de fouiller dans l'historique du navigateur, d'inspecter le DOM pour trouver des éléments cachés, de modifier la valeur d'un cookie, ...

// ==== Flux de validation des challenges <flux-validation>

// Quand le joueur·euse pense avoir trouvé la solution, il propose sa réponse dans un champ de saisie sur la page. Cette proposition déclenche un appel vers l'API du serveur pour valider la réponse.

// Si la réponse est correcte, le backend va réaliser la mise à jour de la progression du participant·e dans la base MongoDB et renvoie l'URL du challenge suivant. Côté frontend, le popup de félicitations se ferme automatiquement et le prochain onglet devient accessible dans la barre, ce qui permet au joueur·euse de continuer son parcours. Le backend met à jour les champs `Flag` et `User.flagged` dans la base MongoDB, puis renvoie une réponse `HTTP 200` avec soit le flag, soit l'URL qui mène à la prochaine étape du challenge.

// //Le système de validation assure la communication avec le backend. La majorité des pages envoient une requête fetch POST vers `/api/checkAnswer` (ou vers `/db/...` pour le challenge d'injection SQL). Le corps de la requête au format JSON contient les champs `challengeId` et `answer`. En retour, le serveur renvoie une réponse qui indique si `success:true` avec l'URL du challenge suivant.

// === Cartographie des challenges <cartographie>

// La cartographie des challenges (@annex-config-json) de la plateforme est réalisée à l'aide d'un JSON qui répertorie les différents challenges. Ce fichier permet d'avoir une vue d'ensemble sur les challenges, c'est-à-dire le nombre d'épreuves, leur ordre et l'URL des challenges. De plus, ce fichier permet un contrôle d'intégrité. Si un challenge ne se charge pas, il est facile de vérifier si le lien dans le JSON pointe vers un fichier existant. Enfin, si l'équipe ajoute un nouveau challenge, il suffira d'actualiser le JSON.

// Chaque ligne du tableau ci-dessous, correspond à un challenge spécifique, avec des informations sur le dossier ou le fichier de lancement, la technique ciblée et l'intention pédagogique. Cela permet de visualiser rapidement la structure des jeux et les compétences que chaque challenge vise à développer.

// #table(
//   columns: (auto, 2fr, 2fr, 2fr),
//   align: (center, left, left, left),

//   table.header([*Ordre*], [*Dossier / fichier de lancement*], [*Technique ciblée*], [*Intention pédagogique*]),

//   [0], [*0_Intro* (pas de challenge)], [-], [Mise en contexte],
//   [1],
//   [`01_windows_login/windows_login.html`],
//   [OSINT et mot de passe à partir des réseaux sociaux],
//   [Montrer l’impact de l'exploitation des données personnelles publiquement accessibles],

//   [2],
//   [`02_browser_history/browser_history.html`],
//   [Lecture d’historique],
//   [Comprendre la collecte de preuves côté client],

//   [3], [`03_same_color_text/index-01.html`], [Texte blanc-sur-blanc], [Chercher du contenu caché dans le DOM],
//   [4], [`04_html_comment/comment.html`], [Commentaires HTML], [Repérage d’indices dans la source],
//   [5], [`05_admin_cookie/index.html`], [Manipulation de cookie], [Bypass d’autorisation client-side],
//   [6], [`06_caesar_cipher/cesar_data.html`], [Chiffrement César], [Notions de cryptanalyse papier],
//   [7], [`07_url_modification/gallery1.html`], [Altération de paramètre GET], [URL tampering / directory browsing],
//   [8], [`08_SQL_injection/sql_injection.html`], [Injection SQL], [Contourner une authentification],
//   [9], [`09_image_forensic/index.html`], [EXIF / métadonnées], [OSINT sur images, géolocalisation],
//   [10], [*10_outro*], [-], [Clôture et teasing final],
// )

// La même architecture est appliquée au scénario "Sauve la Terre de l'arme galactique !" @galacgame, avec des défis similaires mais adaptés à un univers de science-fiction.

// === Gestion des données <gestion-donnees>
// MongoDB stocke les données critiques de la plateforme via les modèles Mongoose @MongooseV8191Getting définis dans `db.js` (@db.js). Trois collections principales sont gérées : `Flag` pour les flags hachés en SHA3-256 initialisés depuis les variables d'environnement `CHALL_FLAGS_2020` et `CHALL_FLAGS_2021`, `User` pour les profils utilisateur avec les champs `uuid`, `name`, `surname`, `mail` et un tableau `flagged` pour suivre la progression, et `Visitor` pour les compteurs de visiteurs par heure. Le système d'initialisation automatique calcule le hash SHA3-256 de chaque flag et l'insère s'il n'existe pas déjà. Cette approche assure la persistance des données utilisateur sans exposer les réponses en clair en cas de tentative d'injection SQL. \
// La base MySQL, initialisée via le script `init.sql` (@init.sql), sert exclusivement aux défis d'injection SQL. Elle contient deux tables : `users` avec les champs `ID` et `pass` (mots de passe volontairement stockés en clair), et `posts` pour les fonctionnalités de recherche. Cette base de données ne possède aucune protection pour servir de cible lors d'attaques, isolant ainsi les vulnérabilités sans risquer d'altérer les vrais enregistrements MongoDB.

// === Backend <backend>

// La plateforme est orchestrée par Docker. Traefik sert de reverse proxy, termine le HTTPS et applique des règles de StripPrefix. Les conteneurs principaux incluent le frontend statique, l’API Node.js, MongoDB, MySQL, WebSSH et plusieurs machines cibles accessibles via SSH.

// //La couche serveur repose sur une architecture composée de Node.js, MongoDB et MySQL, guidé par Docker. 

// // ==== Séquence de validation d'un challenge <sequence-validation>

// // Lorsque le joueur·euse soumet une réponse, le frontend envoie une requête POST vers l'API backend. L'API Node reçoit cette requête et procède à la validation. Pour les challenges standards, le système vérifie le hash SHA3-256 de la réponse soumise contre les valeurs stockées dans MongoDB. Pour le challenge d'injection SQL spécifiquement, la requête est exécutée directement sur MySQL.

// // Si la validation réussit, le backend met à jour les champs `Flag` et `User.flagged` dans la base MongoDB, puis renvoie une réponse `HTTP 200` avec soit le flag, soit l'URL qui mène à la prochaine étape du challenge.

// // Côté frontend, la réception de cette réponse positive déclenche l'affichage d'une popup de félicitations et déverrouille automatiquement l'accès à la page suivante, en suivant la configuration définie dans le fichier de mapping JSON (@annex-config-json) qui gère la progression entre les différents challenges.



// ==== Routage et services exposés  <routage-services>

// Traefik agit comme reverse proxy et point d'entrée unique pour tous les services. Il termine automatiquement les connexions HTTPS et applique des middlewares de type StripPrefix pour traiter les requêtes entrantes. Du côté client, le frontend peut appeler directement les endpoints via des préfixes standardisés comme `/backend/...` ou `/ssh/...` sans se préoccuper de la complexité du routage interne.

// Le processus de transformation s'effectue lorsque Traefik reçoit les requêtes avec préfixes, retire automatiquement ces préfixes via les middlewares configurés, puis transmet les requêtes aux services qui reçoivent des chemins sans préfixes. Par exemple, une requête `POST /backend/visitor` devient `POST /visitor` pour le service Express. De même, une requête `GET /ssh/?hostname=sshmachine` devient `GET /?hostname=sshmachine` pour le service wssh, qui se connecte ensuite en interne à `sshmachine:22`.

// Le script JavaScript du frontend communique avec l'API backend via le préfixe `/backend/`, qui est automatiquement retiré par Traefik avant transmission à Express.

// La page d'accueil `index.html` effectue un appel `POST /backend/visitor` pour incrémenter le compteur de visiteurs de la plateforme. La page de connexion `login.html` utilise deux endpoints qui sont `POST /backend/login` pour l'authentification des utilisateurs et `GET /backend/logout` pour la déconnexion. La page de statistiques `statistics.html` utilisent plusieurs endpoints avec `GET /backend/stats/*` pour récupérer les données de progression et de performance.

// Le script `js/main.js` gère les interactions du scénario principal avec deux appels, `POST /backend/2020/flag` pour la validation des réponses et `POST /backend/user` pour la gestion des données utilisateur. Le script `js/galacmain.js` suit la même logique pour le scénario galacgame avec `POST /backend/2021/flag` et `POST /backend/user`.

// Le challenge Windows Login (`challenges/01_windows_login/windows_login.html`) utilise l'endpoint `POST /backend/2020/checkFlag` pour valider les tentatives d'authentification OSINT. Le challenge d'injection SQL (`challenges/08_SQL_injection/sql_injection.html`) communique directement avec `POST /backend/db` pour permettre l'exploitation des vulnérabilités de la base de données.

// Pour les défis qui demandent un accès terminal, l'architecture implémente un système d'iframe qui pointe vers `/ssh?....` Ce flux de données transite par Traefik qui redirige vers le service webssh, qui va établir la connexion avec les conteneurs cibles `sshmachine*` dédiés à chaque type d'exercice. Cette approche permet d'isoler les environnements d'apprentissage tout en maintenant une interface utilisateur cohérente intégrée dans le navigateur.

// === API Express <api-express>

// L'API Express (@index.js) constitue la partie serveur principale de la plateforme _CyberGame_. Elle est structurée autour de plusieurs modules fonctionnels qui gèrent les différents éléments du jeu et d'administration.

// Le système de validation des défis repose sur deux endpoints principaux. L'endpoint `POST /:year/flag` effectue la vérification complète d'un flag soumis par un joueur en procédant au hashage de la réponse proposée avec l'algorithme SHA3-256, puis en comparant ce hash avec les valeurs stockées dans la base MongoDB. En cas de correspondance, le système ajoute automatiquement l'identifiant `<year>_<chall>` au tableau `user.flagged`. Ainsi, le suivi de la progression du joueur est assuré. L'endpoint `POST /:year/checkFlag` vérifie la validité du flag sans modifier la progression.

// Le système de suivi des joueur·euse·s s'appuie sur un middleware de gestion des cookies UUID. Chaque visiteur se voit attribuer automatiquement un identifiant unique généré avec `uuidv4`, ce qui lui permet de suivre sa progression sans nécessiter de création de compte. L'endpoint `POST /user` permet l'enregistrement des informations personnelles (nom, prénom, email) uniquement après validation complète de tous les flags de l'édition courante, ce qui garantit que seuls les participant·e·s ayant terminé le parcours peuvent s'enregistrer. Pour l'administration, l'endpoint `POST /login` gère l'authentification des administrateurs via les variables d'environnement `SHANA_USER` et `SHANA_PASS`. Une fois authentifié, l'administrateur reçoit un cookie JWT authtoken qui lui donne accès aux fonctionnalités statistiques. L'endpoint `GET /logout` permet la déconnexion en supprimant simplement le cookie d'authentification.

// L'accès aux statistiques est protégé par une vérification JWT obligatoire. L'endpoint `GET /stats/getEditions` retourne la liste des années supportées par la plateforme. Les endpoints `GET /stats/visitors`, `GET /stats/finished?year=...` et `GET /stats/flagPerChall?year=...` fournissent le nombre total de visiteurs, le nombre de participant·e·s ayant terminé une édition spécifique, et les statistiques de réussite par challenge.

// //TODO A RELIRE

// Dans un objectif pédagogique, deux endpoints exposent volontairement des vulnérabilités d'injection SQL. L'endpoint `POST /db` exécute directement les requêtes construites par concaténation sur la base MySQL `dday.users`, sans aucune protection contre les injections. De même, `POST /db/search` applique la même logique volontairement fragile pour les recherches sur la table `posts`. Cette architecture permet aux étudiants d'expérimenter les techniques d'injection SQL dans un environnement contrôlé.

// // Spécifiquement conçu pour le défi 2021, les endpoints `GET /pin` et `POST /pin` implémentent un mécanisme de génération et vérification de PIN basé sur un seed dérivé de la minute courante. Ce système temporel ajoute une dimension dynamique au challenge, le PIN étant régénéré automatiquement. En cas de validation réussie, le système retourne un flag issu de la variable d'environnement `CHALL_FLAGS_2021`. Cette architecture modulaire permet à la fois un fonctionnement sécurisé pour les aspects critiques de la plateforme (progression, authentification) tout en exposant délibérément des vulnérabilités dans un cadre pédagogique contrôlé.


// === WebSSH et conteneurs SSH <webssh-conteneurs>

// Le service WebSSH constitue une composante essentielle de l'infrastructure de la plateforme, permettant aux participant·e·s d'accéder à des environnements SSH directement depuis leur navigateur. Cette solution repose sur le serveur wssh développé en Python, qui fournit un terminal web accessible via l'endpoint `/ssh`.

// Le service WebSSH est containerisé via le fichier `Dockerfile_ssh` qui utilise une image Python 3 de base et installe le package `webssh`. Ce conteneur est exposé au travers du reverse proxy Traefik avec les règles de routage appropriées, incluant la gestion des préfixes `/ssh` et `/static` ainsi que l'activation du TLS.

// Au sein du réseau Docker interne, le service WebSSH établit des connexions vers trois types de machines cibles spécialisées, chacune répondant à des objectifs pédagogiques spécifiques. Le conteneur `ssh` représente le conteneur SSH principal basé sur une image Ubuntu 14.04. Cet environnement utilise `rbash` (restricted bash) avec un PATH restreint et met à disposition un ensemble d'outils sélectionnés tels qu'exiftool et ls. Cette configuration permet de créer un environnement d'apprentissage contrôlé où les participant·e·s peuvent explorer des techniques de reconnaissance et d'analyse de fichiers. Le conteneur `sshmachine-whois` est une variante réduite du conteneur SSH standard spécialement conçue pour les défis liés aux requêtes WHOIS. Le conteneur intègre un binaire whois personnalisé et se concentre sur les techniques d'OSINT (Open Source Intelligence) et de reconnaissance réseau. Le conteneur `sshmachine-galactic-forensic` a été développé pour un défi forensique de l'édition 2021 du scénario "Sauve la Terre de l'arme galactique !". Il inclut des outils d'analyse forensique tels que `libimage-exiftool-perl` et contient des fichiers d'investigation spécifiques comme `photo-gallery.jpg`.

// Tous les conteneurs SSH utilisent une configuration similaire basée sur Ubuntu 14.04 avec le serveur OpenSSH et Supervisor pour la gestion des processus. La configuration SSH est modifiée pour permettre l'authentification par mot de passe root (`PermitRootLogin yes`), créant un environnement volontairement vulnérable à des fins pédagogiques. Cette architecture modulaire permet d'isoler chaque type de défi tout en maintenant une interface d'accès unifiée via le terminal web. Les participant·e·s peuvent ainsi accéder à différents environnements d'apprentissage selon les objectifs pédagogiques de chaque challenge, sans nécessiter d'installation locale d'outils spécialisés.


// == Analyse de la sécurité <analyse-sécurité>

// L'architecture de sécurité de la plateforme _CyberGame_ repose, dans un premier temps, sur la séparation entre deux systèmes de gestion de base de données distincts. MongoDB assure la gestion fiable de l'état du jeu, avec les profils utilisateurs, la progression et les données critiques du système, tandis que MySQL est uniquement utilisé pour les exercices d'injection SQL, créant ainsi une surface de vulnérabilité contrôlée et isolée.

// La gestion des variables sensibles s'appuie sur un système d'injection sécurisé via les fichiers d'environnement. Les flags de validation des challenges sont stockés sous forme de hash SHA3-256 dans MongoDB, garantissant qu'aucune réponse n'est exposée en clair dans le système. Cette approche conserve l'aspect pédagogique des exercices tout en permettant de garder un niveau de sécurité pour les données persistantes.

// L'utilisation de Traefik avec la fonctionnalité StripPrefix simplifie le code Express et gère automatiquement les préfixes d'URL publics. Cela réduit les risques d'erreurs de routage et améliore la maintenabilité du code backend.

// Cependant, en examinant plus en détail la plateforme, une vulnérabilité de sécurité a été identifiée. En effet, il est possible d'accéder directement aux différents challenges sans avoir complété les précédents, en utilisant l'URL directe. Par exemple, en accédant à `https://shana.heig-vd.ch/challenges/05_admin_cookie/index.htmll`, le joueur·euse peut directement accéder au challenge de modification des cookies sans avoir validé les étapes précédentes, comme le montre les figures @bug1 et @bug2. Le joueur·euse peut ainsi résoudre un challenge via l'URL directe sans passer par l'interface du jeu.


// #figure(
//   image("imgs/bug-secu1.png"),
//   caption: [Identification de tous les liens pour les différents challenges],
// )<bug1>

// #figure(
//   image("imgs/bug-secu2.png"),
//   caption: [Accès à un challenge sans avoir complété les précédents via l'URL directe],
// )<bug2>

// De plus, il est possible d'accéder à toutes les popups des challenges avec les indices

// #figure(
//   image("imgs/bug-secu3.png"),
//   caption: [Accès à toutes les popups des challenges avec les indices],
// )<bug3>

// Enfin, il est possible de valider un challenge via une modification de requête POST, comme le montre la @bug4. Le joueur·euse peut ainsi envoyer une requête POST vers l'API backend avec le `chall` et la `flag` pour valider un challenge sans passer par l'interface du jeu et sans avoir complété les étapes précédentes.

// #figure(
//   image("imgs/bug-secu4.png"),
//   caption: [Résolution du challenge via une requête POST sans passer par l'interface du jeu],
// )<bug4>
