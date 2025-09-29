= Architecture de la plateforme _CyberGame_ existante <architecture>
Ce chapitre présente l'architecture technique de la plateforme _CyberGame_, en détaillant le frontend et backend, ainsi que les mécanismes de jeu. Il est important de souligner qu'il s'agit d'une analyse de la plateforme de 2020 avant sa restructuration qui a eu lieu en 2025. Cette analyse porte donc sur l’état initial du site, avant l’ajout de nouvelles fonctionnalités, la refonte du design ou l’amélioration de l’expérience utilisateur.

== Présentation générale <presentation>
Le site web est une plateforme pédagogique créée par le pôle Y-Security de la HEIG-VD. Il a pour objectif d'introduire au ethical hacking et propose actuellement deux scénarios interactifs. La plateforme est donc conçue avec une page d'accueil @InitiationAuEthical qui présente le cadre général. Le premier jeu "Shana a disparu" @ShanaDisparuRetrouvela ainsi qu'un autre scénario "Sauve la Terre de l'arme galactique" @SauveTerreLarme se trouvent sur la plateforme. Pour aider les joueur·euse·s à avancer dans les différents challenges, une boîte à outils et un petit IDE Python ont été développés @InitiationAuEthical.

== Mécanisme de jeu <mécanisme-de-jeu>

La plateforme _CyberGame_ propose deux parcours structurés sous forme d'histoire progressive qui mettent en œuvre des techniques clés du hacking éthiques. Chacun propose une enquête avec un scénario dont les étapes doivent être validées dans l'ordre afin de pouvoir progresser dans le déroulement de l'enquête.

=== Scénario 1 : "Shana a disparu" <shana>

Le scénario "Shana a disparu" @ShanaDisparuRetrouvela a pour objectif d'amener le joueur·euse dans une enquête de neuf challenges successifs qui miment la progression d'une investigation numérique. Pour nous aider à résoudre ces challenges, une petite boîte à outil avec des explications est fournie @InitiationAuEthical. L'histoire commence par la reconstruction du mot de passe Windows de Shana à partir des informations qui se trouvent sur le profil Instagram de la victime. Le challenge suivant est l'exploration de l'historique de navigation pour extraire ses derniers sites consultés. Une fois le site trouvé, un lien caché en texte invisible est inséré sur la page. Le défi suivant consiste à inspecter le code source pour trouver des informations qui vont nous permettre de progresser. Une fois l'information trouvée, le jeu redirige le joueur·euse vers une page où la manipulation de cookie est nécessaire : il faut modifier la valeur d'une variable de session pour débloquer la page cachée. S’ensuit un chiffrement de César qu’il faut renverser pour découvrir une date clé, puis l’altération manuelle de la fin d’une URL afin d’accéder à un répertoire non indexé. Le challenge suivant demande une injection SQL qui va permettre de contourner l'authentification et d'obtenir de nouvelles informations, qui se confirment grâce à l’extraction des coordonnées GPS dissimulées dans les métadonnées EXIF d’une photo. Chaque résolution de challenge permet de dévoiler un indice indispensable au suivant, illustrant la chaîne "collecte – exploitation – preuve" qui est l’approche "typique" d'un hacker éthique.


=== Scénario 2 : "Sauve la Terre de l’arme galactique" <galacgame>

Le second scénario que nous retrouvons sur la plateforme "Sauve la Terre de l'arme galactique" @InitiationAuEthical, utilise les mêmes principes mais dans un univers de science-fiction. Le joueur·euse est plongé·e dans une enquête afin de retrouver les plans d'une arme galactique et ainsi sauver le monde. Dans un premier temps, le joueur·euse exploite la barre de recherche d'un réseau fictif pour obtenir des fragments de conversation. Ensuite, le participant·e va utiliser l’ingénierie sociale pour retrouver des réponses de sécurité, imprudemment divulguées en ligne, ce qui va permettre de retrouver le mot de passe et ainsi accéder au profil. Des challenges similaires se retrouvent dans les deux jeux comme la manipulation des cookies, l'ajustement d'un paramètre `GET` dans l'URL d'un lien, l'injection SQL afin de contourner un mot de passe, l'utilisation des métadonnées d'une image à l'aide de l'outil exiftool et enfin de la cryptographie. Des challenges supplémentaires ont été ajoutés comme l'utilisation d'une requête WHOIS, qui sert à identifier le propriétaire d'une adresse IPv6 et intercepter son trafic. Pour terminer, le joueur·euse doit réaliser une attaque par bruteforce à l'aide d'un petit script Python qu'il doit écrire.


== Techniques mobilisées <technologies-utilisees>

Les jeux utilisent un ensemble de techniques du hacking éthique : recherche OSINT sur les réseaux sociaux ; lecture attentive du code HTML et des feuilles de style pour trouver du contenu dissimulé ; modification manuelle des cookies et des paramètres `GET` afin de détourner la logique d’un site ; injection SQL destinée à contourner les contrôles d’authentification ; extraction et interprétation des métadonnées EXIF d’images ; cryptanalyse (décodage César ou ROT-47) ; rédaction de courts scripts Python pour l’automatisation (attaque par force brute, déchiffrement) ; enfin, utilisation des services WHOIS et des requêtes DNS pour cartographier une infrastructure et remonter jusqu’à son propriétaire, le tout dans une histoire narrative progressive.

Le participant·e découvre, étape après étape, comment procède un professionnel de la cybersécurité : récolte d'informations, exploitation et utilisation des données et réflexion pour remonter une piste et ainsi atteindre le but.

== Analyse critique <positifs-améliorer>
=== Points forts
Parmi les forces de la plateforme, les enquêtes sont construites afin de suivre une progression graduelle. Chaque épreuve ré-exploite la précédente et favorise un apprentissage. La narration permet de maintenir le joueur·euse motivé·e mais le garde dans une optique d'apprentissage. \
En effet, la boîte à outils intégrée, qui contient les fiches pratiques, évite aux débutant·e·s de devoir faire trop de recherches et ainsi leur permet de se focaliser sur le jeu. \
De plus, grâce à un mini IDE Python et un terminal intégré, comme le montre la @ide-img et @terminal-img, le joueur·euse n'a rien besoin d'installer sur sa machine. L'expérience se déroule entièrement sur le navigateur ce qui abaisse la barrière d’entrée, et la variété des techniques abordées offrant un panorama cohérent de la sécurité offensive.
#figure(
  image("imgs/ide-interface.png"),
  caption: [IDE présent sur le jeu "Sauve la Terre de l'arme galactique", dans le challenge 6],
)<ide-img>
#figure(
  image("imgs/terminal-interface.png"),
  caption: [Terminal présent sur les 2 jeux, dans les challenges 9 de "Shana a disparu" et 5, 8 dans "Sauve la Terre de l'arme galactique"],
)<terminal-img>

=== Axes d'amélioration
Cependant, quelques points mériteraient des améliorations.

D’abord, la police d'écriture utilisée, elle permet de créer une certaine ambiance mais elle est peu lisible, ce qui peut gêner la compréhension et la lecture des consignes.

Un autre élément d'amélioration aurait été de réaliser un changement de curseur sur les éléments cliquables (par exemple, en utilisant `cursor: pointer` en CSS) pour permettre au joueur·euse d’identifier les zones interactives.

Actuellement, certains éléments interactifs ne sont pas mis en valeur, ce qui peut rendre la navigation moins intuitive.

La gestion de la fenêtre du jeu pourrait être optimisée, par exemple après la fermeture d’une pop-up, le joueur·euse se retrouve parfois avec un fond noir sans indication, ce qui peut désorienter. Il serait utile d’ajouter des repères visuels ou des messages d’aide pour guider l’utilisateur·trice dans la progression, et de mieux intégrer la boîte à outils dès la page d’accueil pour que chacun·e sache où trouver les ressources.

Le design du site présente parfois des problèmes d’affichage selon la taille de la fenêtre du navigateur, comme le chevauchement d’éléments.

Le champ dans lequel le joueur·euse doit saisir sa réponse ne précise pas toujours le format exigé ; lorsque la consigne n’affiche qu’un mot mis en gras, qui représente la réponse attendue, l’information passe facilement inaperçue et l’utilisateur·trice ignore s’il doit entrer un mot-clé, une URL complète, un hash ou une date. Le joueur·euse peut avoir du mal à comprendre ce qu'il doit mettre, ce qui peut entraîner de la frustration. Il serait judicieux, par exemple de mettre dans l'indice, le format attendu avec un exemple, ou encore avant les début des challenges, montrer des exemples de formats attendus.

Ensuite, pour la validation de l'étape, il faut impérativement entrer une réponse valide dans le champ "Réponse" malgré que l'interface visuelle du jeu change.
#figure(
  image("imgs/bug-interface1.png"),
  caption: [Interface du jeu après la validation d'un challenge],
)<bug-interface1-imgs>

#figure(
  image("imgs/bug-interface2.png"),
  caption: [Interface du jeu qui ne change pas après la validation d'un challenge et pas de progression dans l'histoire.],
)<bug-interface2-imgs>

Dans la @bug-interface1-imgs, nous pouvons voir que le joueur·euse à bien réussi à trouver la réponse du challenge. Cependant, comme le montre la @bug-interface2-imgs, l'interface de travail ne change pas. Le joueur·euse peut ne pas comprendre ce qu'il doit faire et peut rester bloqué car il ne sait pas ce qui est attendu de lui. \
Le passage d’un challenge au suivant manque parfois de fiabilité : la pop-up explicative ne s’ouvre pas systématiquement et la barre de progression reste figée. Le participant·e doit donc cliquer sur l'étape suivante pour accéder à la consigne du challenge suivant ainsi que le nouvel interface de travail.

Enfin, les indices actuels fournissent, dans un premier temps, un bon point de départ. Cependant, cela peut se révéler insuffisant pour les joueur·euse·s débutant·e·s. La mise en place d'aides graduelles pourraient limiter le risque d'abandon tout en gardant le défi intéressant.


//TODO ajouter schéma et l'expliquer
//TODO a relire et compléter
== Architecture technique <architecture-technique>

La plateforme est hébergée sur un serveur web, accessible via un nom de domaine `heig-vd.ch` avec le sous-domaine `shana`. Le site utilise des technologies web standards telles que HTML, CSS et JavaScript pour l'interface utilisateur.

=== Frontend <frontend>

La structure du frontend montre que chaque épreuve est développée comme un mini-site indépendant dans son propre dossier. Cela permet d'obtenir ainsi une architecture claire et modulaire qui facilite la maintenance et l’ajout de nouveaux niveaux.
Chaque challenge suit une structure composée de plusieurs éléments, chacun avec un rôle spécifique dans l'expérience pédagogique.

Le dossier racine du challenge (par exemple `01_windows_login/`, `07_url_modification/`, ...) contient toutes les ressources spécifiques à l'épreuve.

Le fichier HTML de lancement (comme `windows_login.html` ou `gallery1.html`, ...) représente la partie interactive visible par le joueur. Ce fichier charge systématiquement plusieurs ressources : une feuille de style locale située dans `css/style.css`, jQuery version 1.7.1 accompagné parfois d'un script global stocké dans `/js`, ainsi que le header commun comprenant le logo, le compteur de progression et le bouton "Retour". Un élément `div.popup-trigger` est toujours présent pour déclencher l'affichage de la pop-up d'aide.

Le sous-dossier `css/` contient les styles spécifiques au challenge. La feuille de style définit l'apparence visuelle (police, arrière-plan, couleurs).

Le sous-dossier `img/` stocke les ressources visuelles nécessaires comme les illustrations, les captures d'écran et les images de fond. Par exemple, `background_history.png` sert uniquement visuel du niveau "Browser History".

Le fichier `popup.html` présente la pop-up d'introduction et d'indices. Tous les challenges utilisent la même structure, c'est-à-dire un titre, le contexte de l'épreuve, un rappel du format de réponse attendu et un bouton "Commencer" pour lancer le défi. En dessous, se trouve aussi le bouton "Indice" qui permet d'obtenir l'indice pour résoudre le challenge.

// La logique JavaScript locale gère les interactions spécifiques à chaque challenge. Le code est souvent intégré directement dans la page HTML et se limite à quelques lignes pour gérer des éléments comme un accordéon, la modification dynamique du DOM ou la capture de l'événement Submit. Pour les challenges nécessitant plus de code (comme l'IDE Python), un module JavaScript dédié est placé dans le répertoire /js.

Le système de validation assure la communication avec le backend. La majorité des pages envoient une requête fetch POST vers `/api/checkAnswer` (ou vers `/db/...` pour le challenge d'injection SQL). Le corps de la requête au format JSON contient les champs `challengeId` et `answer`. En retour, le serveur renvoie une réponse indiquant `success:true` avec l'URL du challenge suivant.

==== Flux type côté client
Lorsque le joueur·euse arrive sur une page de challenge, une pop-up s'ouvre automatiquement pour montrer le contexte du défi et expliquer l'objectif.

Le joueur·euse peut ensuite interagir avec la page selon ce qui lui est demandé : cela peut impliquer de fouiller dans l'historique du navigateur, d'inspecter le DOM pour trouver des éléments cachés, de modifier la valeur d'un cookie, ...

Quand le joueur·euse pense avoir trouvé la solution, il propose sa réponse dans un champ de saisie sur la page. Cette proposition déclenche un appel vers l'API du serveur pour valider la réponse.

Si la réponse est correcte, le backend va réaliser la mise à jour de la progression du joueur·euse dans la base MongoDB et renvoie l'URL du challenge suivant. Côté frontend, le pop-up de félicitations se ferme automatiquement et le prochain onglet devient accessible dans la barre, ce qui permet au joueur·euse de continuer son parcours.

=== Cartographie des challenges <cartographie>

La cartographie des challenges (Annexe@annex-config-json) de la plateforme est réalisée à l'aide d'un tableau JSON qui répertorie les différents challenges, les techniques ciblées et les intentions pédagogiques. Chaque ligne du tableau correspond à un challenge spécifique, avec des informations sur le dossier ou le fichier de lancement, la technique ciblée et l'intention pédagogique. Cela permet de visualiser rapidement la structure des jeux et les compétences que chaque challenge vise à développer.

Ce fichier permet d'avoir une vue d'ensemble sur les challenges, c'est-à-dire combien d'épreuves il y a , dans quel ordre et où se trouve le fichier de lancement de chacun. De plus, ce fichier permet un contrôle d'intégrité. Si la plateforme ne se charge pas, il est facile de vérifier si le lien dans le JSON pointe vers un fichier existant. Pour chaque challenge, on peut tout de suite ouvrir les bons fichiers (HTML / JS / CSS) et identifier la vulnérabilité simulée sans chercher. Enfin, si l'équipe ajoute un nouveau challenge, il suffira d'actualiser le JSON.

#table(
  columns: (auto, 2fr, 2fr, 2fr),
  align: (center, left, left, left),

  table.header([*Ordre*], [*Dossier / fichier de lancement*], [*Technique ciblée*], [*Intention pédagogique*]),

  [0], [*0_Intro* (pas de challenge)], [-], [Mise en contexte],
  [1],
  [`01_windows_login/windows_login.html`],
  [OSINT et mot de passe à partir des réseaux sociaux],
  [Montrer l’impact de l'exploitation des données personnelles publiquement accessibles],

  [2],
  [`02_browser_history/browser_history.html`],
  [Lecture d’historique],
  [Comprendre la collecte de preuves côté client],

  [3], [`03_same_color_text/index-01.html`], [Texte blanc-sur-blanc], [Chercher du contenu caché dans le DOM],
  [4], [`04_html_comment/comment.html`], [Commentaires HTML], [Repérage d’indices dans la source],
  [5], [`05_admin_cookie/index.html`], [Manipulation de cookie], [Bypass d’autorisation client-side],
  [6], [`06_caesar_cipher/cesar_data.html`], [Chiffrement César], [Notions de cryptanalyse papier],
  [7], [`07_url_modification/gallery1.html`], [Altération de paramètre GET], [URL tampering / directory browsing],
  [8], [`08_SQL_injection/sql_injection.html`], [Injection SQL], [Contourner une authentification],
  [9], [`09_image_forensic/index.html`], [EXIF / métadonnées], [OSINT sur images, géolocalisation],
  [10], [*10_outro*], [-], [Clôture et teasing final],
)

La même logique est appliquée au scénario "Sauve la Terre de l'arme galactique" @galacgame, avec des défis similaires mais adaptés à un univers de science-fiction.

=== Backend
La couche serveur repose sur une architecture composée de Node.js, MongoDB et MySQL, le tout orchestré par Docker. Cette infrastructure comprend plusieurs éléments techniques avec des objectifs pédagogiques.

L'environnement Docker Compose déploie un service backend basé sur Node 14, accompagné d'instances MongoDB et MySQL, ainsi que trois petits conteneurs docker-ssh servant de cibles d'attaque. Cette approche permet d'isoler chaque composant et de créer un environnement de test sécurisé pour les exercices d'injection SQL.

L'API Express, écrit dans le fichier `index.js` (Annexe@index.js), intègre les middlewares essentiels comme CORS, body-parser, cookie-parser et JWT pour la gestion des sessions. Elle montre plusieurs endpoints REST tels que `/db`, `/db/search`, `/user` et `/stats`. /*Le point critique réside dans l'utilisation d'un pool MySQL avec des requêtes non sécurisées du type `SELECT * FROM users where ID = '` + `req.body.user` + `'`, illustrant directement l'impact des vulnérabilités d'injection SQL dans le cadre du challenge 08.*/

Les modèles Mongoose, définis dans `db.js` (Annexe@db.js), gèrent trois collections principales : `Flag`, `User` et `Visitor`. Le système d'initialisation automatique calcule un hash SHA-3 256 pour chaque flag déclaré dans les variables d'environnement `CHALL_FLAGS_2020` et `CHALL_FLAGS_2021`, puis l'insère en base s'il n'existe pas déjà. Cette approche assure une gestion persistante des comptes utilisateurs et du système de score sans exposer les réponses en clair.

Enfin, la base MySQL est initialisée via le script `init.sql` (Annexe@init.sql)  avec une table `users` contenant les champs `ID` et `pass` (mots de passe stockés en clair), ainsi qu'une table posts pour les fonctionnalités de recherche et de like. Cette base est volontairement dépourvue de protections (pas d'index, pas de contraintes) pour servir de cible d'apprentissage dans les exercices d'injection de code.

==== Séquence de validation d’un challenge

Lorsque le joueur·euse soumet une réponse, le frontend envoie une requête POST vers l'endpoint `/db` ou `/db/search`. L'API Node reçoit cette requête et exécute directement la requête MySQL sans échappement des caractères. Si la requête retourne au moins une ligne de résultat, la réponse est correcte.

Le backend procède alors à la mise à jour des données en modifiant les champs `Flag` et `User.flagged` dans la base MongoDB. Une fois cette mise à jour effectuée, le serveur renvoie une réponse `HTTP 200` avec soit le flag, soit l'URL qui mène à la prochaine étape du challenge.

Côté frontend, la réception de cette réponse positive déclenche l'affichage d'une pop-up de félicitations et déverrouille automatiquement l'accès à la page suivante, conformément à la configuration définie dans le fichier de mapping JSON (Annexe@annex-config-json) gère la progression entre les différents challenges.

== Infrastructure Docker compose

La couche serveur repose sur Node.js/Express avec MongoDB et MySQL, le tout orchestré par Docker Compose. Un reverse-proxy Traefik termine le TLS et route les requêtes vers trois familles de services : l’API "backend", le site "frontend" et la passerelle "webssh" qui sert d’interface vers de petites machines SSH dédiées à certains défis. Cette séparation permet d’isoler les composants pédagogiques (ex. SQL volontairement vulnérable) sans impacter la persistance "réelle" (progression des joueur·euse·s).

Le fichier `docker-compose.yml` (Annexe@docker-compose.yml) définit l'ensemble des services nécessaires à l'application, y compris le backend et les bases de données. Chaque service est configuré avec des variables d'environnement spécifiques pour garantir un fonctionnement optimal.

=== Services principaux

Les services principaux définis dans le fichier `docker-compose.yml` incluent :

Le service Traefik agit comme point d'entrée de la plateforme, qui écoute sur les ports `80` et `443`. Il assure la terminaison TLS et effectue un routage sur des labels Docker. L'entrypoint web redirige automatiquement le trafic HTTP vers HTTPS pour garantir la sécurité des communications. Le routage s'appuie sur trois règles principales : le frontend est servi sur la racine du domaine, le backend est accessible via le préfixe `/backend` avec un middleware StripPrefix, et le service webssh est routé via les préfixes `/ssh` et `/static`.

Le service backend est construit à partir du répertoire `DigitalDay_BACKEND` et constitue l'API REST. Il utilise Node.js Express et intègre les middlewares essentiels comme CORS, body-parser, cookie-parser et JWT pour la gestion des sessions. L'API expose plusieurs endpoints importantes : les routes de validation des flags (`/:year/flag, /:year/checkFlag`), la gestion des utilisateurs (`/user`, `/login`, `/logout`), les statistiques administratives (`/stats/*`), et les routes SQL (`/db`, `/db/search`). Le service attend la disponibilité de MySQL et MongoDB avant de démarrer, utilisant un mécanisme de wait-for.

Le frontend, construit depuis `DigitalDay_APP`, est servi par live-server sur le port `3001` et routé par Traefik sur la racine du domaine. Il consomme l'API backend via les appels `/backend/...` et intègre des iframes vers `/ssh/...` pour les défis nécessitant un accès terminal.

Le service webssh, basé sur un serveur Python wssh, fournit une interface web pour accéder aux conteneurs SSH internes. Il est routé via les préfixes `/ssh` et `/static` et permet l'accès sécurisé aux machines cibles sans exposition directe sur Internet.

L'architecture adopte délibérément deux systèmes de gestion de base de données distincts pour séparer les responsabilités et les niveaux de sécurité.
MongoDB stocke les données critiques de la plateforme dans trois collections principales. La collection Flag contient les flags hachés en SHA3-256 initialisés depuis les variables d'environnement `CHALL_FLAGS_2020`, `CHALL_FLAGS_2021` et `CHALL_FLAGS_2025`. La collection `User` gère les profils utilisateur avec les champs `uuid`, `name`, `surname`, `mail` et un tableau `flagged` pour suivre la progression. La collection `Visitor` maintient des compteurs de visiteurs par heure avec les champs `hour_timestamp` et `ctr`. Cette base assure la persistance fiable des données utilisateur et du système de score.
La base MySQL, initialisée via le script `init.sql`, sert exclusivement aux défis d'injection SQL. Elle contient deux tables : `users` avec les champs `ID` et `pass` (mots de passe volontairement stockés en clair), et `posts` pour les fonctionnalités de recherche avec les champs `ID`, `img`, `nameLastname` et `datepost`. Cette base est intentionnellement dépourvue de protections (pas d'index, pas de contraintes d'intégrité) pour servir de cible d'apprentissage dans les exercices d'injection de code.

Les deux DB présentes dans l'architecture du code ont des objectifs bien distincts. MongoDB stocke les données "sérieuses" (profils, progression). Alors que MySql n’est utile que pour le challenge 08 de Shana : l'objectif est d'isoler la DB sans risquer d’altérer les vrais enregistrements Mongo si un étudiant·e pousse l’exploit plus loin.

/*- Traefik (reverse-proxy) — écoute en `:80` et `:443`. L’entrypoint web redirige vers websecure. Le routage s’appuie sur des labels :
  - frontend → règle `${HOST_RULE}` : sert la racine du site.
  - backend → `${HOST_RULE} && PathPrefix('/backend')` + middleware StripPrefix `/backend`.
  - webssh → `${HOST_RULE} && (PathPrefix('/ssh') || PathPrefix('/static'))` + StripPrefix `/ssh`.

- Backend (Node/Express) — image construite à la racine de `DigitalDay_BACKEND`. Variables d’env. pour `MONGO_URI`, et wait-for sur `mysql:3306` et `mongo:27017`. Volumes montés pour le dev (hot-reload). Exposé par Traefik derrière le préfixe `/backend`.

- Frontend (DigitalDay_APP) — image construite depuis `../DigitalDay_APP/Dockerfile`, servi (live-server) sur `:3001`, routé par Traefik sur la racine du domaine ; consomme l’API via `/backend/....`.

- webssh (passerelle SSH web) — basé sur `Dockerfile_ssh` (serveur wssh Python). Routé en `/ssh` (et `/static`) ; tunnelise vers les conteneurs SSH internes.

- Cibles SSH — `sshmachine`, `sshmachine-whois`, `sshmachine-galactic-forensic` : petits conteneurs `openssh-server` outillés (`exiftool`, `whois`, etc.). Non exposés publiquement ; accessibles depuis webssh uniquement.

- mongo — MongoDB (auth root via .env), volume persistant `./mongo:/data/db`.

- mysql — MySQL 5, initialisé par `./mysql/init.sql` (tables utilisées pour les défis SQL).*/


=== Routage et intégration Traefik

Le routage repose sur Traefik v2.10 qui agit comme reverse proxy et point d'entrée unique pour tous les services. Cette configuration permet une gestion centralisée du HTTPS et l'application de middlewares de transformation des requêtes.Configuration du routage Traefik termine automatiquement les connexions HTTPS et applique des middlewares de type StripPrefix pour traiter les requêtes entrantes. Du côté client, le frontend peut appeler directement les endpoints via des préfixes standardisés comme `/backend/...` ou `/ssh/...` sans se préoccuper de la complexité du routage interne.Le processus de transformation s'effectue de la manière suivante : Traefik reçoit les requêtes avec préfixes, retire automatiquement ces préfixes via les middlewares configurés, puis transmet les requêtes aux services backend qui reçoivent des chemins "nus" sans préfixes.Exemples de transformation : Une requête `POST /backend/visitor` devient `POST /visitor` pour le service Express
Une requête `GET /ssh/?hostname=sshmachine` devient `GET /?hostname=sshmachine` pour le service wssh, qui se connecte ensuite en interne à `sshmachine:22`

/*Traefik termine le HTTPS et applique les middlewares de StripPrefix. Côté client, le frontend appelle simplement `/backend/...` ou `/ssh/....` Traefik retire le préfixe et transmet à Express (ou à wssh) qui voit des chemins « nus ».

Exemple : `POST /backend/visitor` → Express `/visitor`.

Exemple : `GET /ssh/?hostname=sshmachine` → wssh se connecte en interne à `sshmachine:22`.*/

=== Cartographie des routes et services

Routage des appels API frontend
L'architecture de communication entre le frontend et le backend s'articule autour d'un système de routage centralisé. Les écrans et scripts JavaScript du frontend communiquent avec l'API backend via le préfixe `/backend/`, qui est automatiquement retiré par Traefik avant transmission à Express.

Routage principal des pages :
La page d'accueil index.html effectue un appel `POST /backend/visitor` pour incrémenter le compteur de visiteurs de la plateforme.
La page de connexion `login.html` utilise deux endpoints : `POST /backend/login` pour l'authentification des utilisateurs et `GET /backend/logout` pour la déconnexion.
La page de statistiques statistics.html interroge plusieurs endpoints via `GET /backend/stats/*` pour récupérer les données de progression et de performance.

Scripts JavaScript globaux :
Le script `js/main.js` gère les interactions du scénario principal avec deux appels principaux : `POST /backend/2020/flag` pour la validation des réponses et `POST /backend/user` pour la gestion des données utilisateur. Le script `js/galacmain.js` suit la même logique pour le scénario galactique avec `POST /backend/2021/flag` et `POST /backend/user`.

Challenges spécifiques :
Le challenge Windows Login (`challenges/01_windows_login/windows_login.html`) utilise l'endpoint `POST /backend/2020/checkFlag` pour valider les tentatives d'authentification OSINT. Le challenge d'injection SQL (`challenges/08_SQL_injection/sql_injection.html`) communique directement avec `POST /backend/db` pour permettre l'exploitation des vulnérabilités de base de données.

Gestion des défis terminal
Pour les défis nécessitant un accès terminal, l'architecture implémente un système d'iframe pointant vers `/ssh?....` Ce flux de données transite par Traefik qui redirige vers le service webssh, lequel établit la connexion avec les conteneurs cibles `sshmachine*` dédiés à chaque type d'exercice. Cette approche permet d'isoler les environnements d'apprentissage tout en maintenant une interface utilisateur cohérente intégrée dans le navigateur.

// Les écrans/JS du frontend appellent l’API via `/backend/...` (le préfixe est retiré avant Express) :

// - index.html → `POST /backend/visitor` (compteur visiteurs).
// - login.html → `POST /backend/login`, `GET /backend/logout`.
// - statistics.html → `GET /backend/stats/*`.
// - js/main.js → `POST /backend/2020/flag`, `POST /backend/user`.
// - js/galacmain.js → `POST /backend/2021/flag`, `POST /backend/user`.
// - challenges/01_windows_login/windows_login.html → `POST /backend/2020/checkFlag`.
// - challenges/08_SQL_injection/sql_injection.html → `POST /backend/db`.
// Pour les défis « terminal », les pages embarquent un iframe vers `/ssh?...` (Traefik → webssh → conteneur `sshmachine*`).

=== API Express (Annexe@index.js)

L'API Express constitue la couche serveur principale de la plateforme _CyberGame_ . Elle est structurée autour de plusieurs modules fonctionnels qui gèrent les différents aspects du système de jeu et d'administration.

Gestion des flags et progression
Le système de validation des défis repose sur deux endpoints principaux. L'endpoint `POST /:year/flag` effectue la vérification complète d'un flag soumis par un joueur. Il procède au hashage de la réponse proposée avec l'algorithme SHA3-256, puis compare ce hash avec les valeurs stockées dans la base MongoDB. En cas de correspondance, le système ajoute automatiquement l'identifiant `<year>_<chall>` au tableau `user.flagged`, permettant ainsi le suivi de la progression du joueur. L'endpoint `POST /:year/checkFlag` offre une variante qui se contente de vérifier la validité du flag sans modifier la progression, utile pour les vérifications intermédiaires.

Gestion des utilisateurs et sessions
Le système de suivi des joueur·euse·s s'appuie sur un middleware de gestion des cookies UUID. Chaque visiteur se voit attribuer automatiquement un identifiant unique généré avec `uuidv4`, permettant de suivre sa progression sans nécessiter de création de compte préalable. L'endpoint `POST /user` permet l'enregistrement des informations personnelles (nom, prénom, email) uniquement après validation complète de tous les flags de l'édition courante, garantissant ainsi que seuls les participants ayant terminé le parcours peuvent s'enregistrer.Pour l'administration, l'endpoint `POST /login` gère l'authentification des administrateurs via les variables d'environnement `SHANA_USER` et `SHANA_PASS`. Une fois authentifié, l'administrateur reçoit un cookie JWT authtoken lui donnant accès aux fonctionnalités statistiques. L'endpoint `GET /logout` permet la déconnexion en supprimant simplement le cookie d'authentification.

Module statistiques
L'accès aux statistiques est protégé par une vérification JWT obligatoire. L'endpoint `GET /stats/getEditions` retourne la liste des années supportées par la plateforme. Les endpoints `GET /stats/visitors`, `GET /stats/finished?year=...` et `GET /stats/flagPerChall?year=...` fournissent respectivement le nombre total de visiteurs, le nombre de participants ayant terminé une édition spécifique, et les statistiques de réussite par challenge, le tout grâce à des agrégations MongoDB optimisées.

Comptabilisation des visiteurs
L'endpoint `POST /visitor` maintient un système de comptage granulaire en incrémentant un compteur par heure dans la collection `Visitor`. Cette approche permet d'obtenir des statistiques de fréquentation précises sur la plateforme.

Interface SQL vulnérable
Dans un objectif pédagogique, deux endpoints exposent volontairement des vulnérabilités d'injection SQL. L'endpoint `POST /db` exécute directement les requêtes construites par concaténation sur la base MySQL `dday.users`, sans aucune protection contre les injections. De même, `POST /db/search` applique la même logique volontairement fragile pour les recherches sur la table `posts`. Cette architecture permet aux étudiants d'expérimenter les techniques d'injection SQL dans un environnement contrôlé.

Système PIN temporel
Spécifiquement conçu pour le défi 2021, les endpoints `GET /pin` et `POST /pin` implémentent un mécanisme de génération et vérification de PIN basé sur un seed dérivé de la minute courante. Ce système temporel ajoute une dimension dynamique au challenge, le PIN étant régénéré automatiquement. En cas de validation réussie, le système retourne un flag issu de la variable d'environnement `CHALL_FLAGS_2021`.Cette architecture modulaire permet à la fois un fonctionnement sécurisé pour les aspects critiques de la plateforme (progression, authentification) tout en exposant délibérément des vulnérabilités dans un cadre pédagogique contrôlé.

// - Flags & progression
//   - `POST /:year/flag` : vérifie un flag (SHA3-256 vs base Mongo) puis ajoute `<year>_<chall>` à `user.flagged`.
//   - `POST /:year/checkFlag` : variante « vérifie-seulement ».
// - Utilisateur & session
//   - Middleware cookie uuid (créé/validé avec uuidv4) pour suivre un joueur sans compte.
//   - `POST /user` : enregistre nom/prénom/mail une fois tous les flags de l’édition courante validés.
//   - `POST /login` : login admin statistiques (env SHANA_USER/SHANA_PASS) → cookie JWT authtoken.
//   - `GET /logout` : suppression du cookie.
// - Statistiques (JWT requis)
//   - `GET /stats/getEditions` → années supportées.
//   - `GET /stats/visitors`, `GET /stats/finished?year=...`, `GET /stats/flagPerChall?year=...` → agrégations Mongo.
// - Visiteurs
//   - `POST /visitor` : incrémente un compteur « par heure » (document Visitor).
// - SQL (défis)
//   - `POST /db` : exécute une requête construite par concaténation (vulnérable exprès) sur MySQL dday.users.
//   - `POST /db/search` : recherche sur posts (même logique volontairement fragile).
// - PIN (défi 2021)
//   - `GET /pin` & `POST /pin` : génération/vérif d’un PIN dérivé d’un seed minute courante ; retourne un flag CHALL_FLAGS_2021 si OK.


=== WebSSH et conteneurs SSH

Le service WebSSH constitue une composante essentielle de l'infrastructure de la plateforme, permettant aux participants d'accéder à des environnements SSH directement depuis leur navigateur. Cette solution repose sur le serveur wssh développé en Python, qui fournit un terminal web accessible via l'endpoint `/ssh`.

Architecture du service WebSSH
Le service WebSSH est containerisé via le fichier `Dockerfile_ssh` qui utilise une image Python 3 de base et installe le package `webssh`. Ce conteneur est exposé au travers du reverse proxy Traefik avec les règles de routage appropriées, incluant la gestion des préfixes `/ssh` et `/static` ainsi que l'activation du TLS.

Au sein du réseau Docker interne, le service WebSSH établit des connexions vers trois types de machines cibles spécialisées, chacune répondant à des objectifs pédagogiques spécifiques :
- `ssh` : Il s'agit du conteneur SSH principal basé sur une image Ubuntu 14.04. Cet environnement utilise `rbash` (restricted bash) avec un PATH restreint et met à disposition un ensemble d'outils sélectionnés tels qu'exiftool et ls. Cette configuration permet de créer un environnement d'apprentissage contrôlé où les participants peuvent explorer des techniques de reconnaissance et d'analyse de fichiers.
- `sshmachine-whois` : Cette variante réduite du conteneur SSH standard est spécialement conçue pour les défis liés aux requêtes WHOIS. Le conteneur intègre un binaire whois personnalisé et se concentre sur les techniques d'OSINT (Open Source Intelligence) et de reconnaissance réseau.
- `sshmachine-galactic-forensic` : Ce conteneur spécialisé a été développé pour un défi forensique de l'édition 2021 du scénario "Sauve la Terre de l'arme galactique". Il inclut des outils d'analyse forensique tels que `libimage-exiftool-perl` et contient des fichiers d'investigation spécifiques comme `photo-gallery.jpg`. Si le dossier source n'est pas disponible, un Dockerfile minimal doit être créé incluant les outils essentiels : file, strings, binwalk, exiftool, less et grep.

Configuration technique
Tous les conteneurs SSH utilisent une configuration similaire basée sur Ubuntu 14.04 avec le serveur OpenSSH et Supervisor pour la gestion des processus. La configuration SSH est modifiée pour permettre l'authentification par mot de passe root (`PermitRootLogin yes`), créant un environnement volontairement vulnérable à des fins pédagogiques.Cette architecture modulaire permet d'isoler chaque type de défi tout en maintenant une interface d'accès unifiée via le terminal web. Les participants peuvent ainsi accéder à différents environnements d'apprentissage selon les objectifs pédagogiques de chaque challenge, sans nécessiter d'installation locale d'outils spécialisés.

// Le service webssh (wssh Python) fournit un terminal web, exposé en /ssh. À l’intérieur du réseau Docker, il ouvre des sessions vers les machines cibles :

// sshmachine : image Ubuntu + rbash, PATH restreint et quelques outils (exiftool, ls…).

// sshmachine-whois : variante réduite pour le défi WHOIS.

// sshmachine-galactic-forensic : conteneur spécialisé pour un défi forensic 2021 (référencé dans compose ; si le dossier manque, prévoir un Dockerfile minimal avec file, strings, binwalk, exiftool, less, grep).


== Analyse de la sécurité <analyse-sécurité>
L'architecture de sécurité de la plateforme _CyberGame_ repose sur une approche de séparation stricte des responsabilités entre deux systèmes de gestion de base de données distincts. MongoDB assure la gestion fiable de l'état du jeu, incluant les profils utilisateurs, la progression et les données critiques du système, tandis que MySQL est uniquement utilisé pour les exercices d'injection SQL, créant ainsi une surface de vulnérabilité contrôlée et isolée.

La gestion des variables sensibles s'appuie sur un système d'injection sécurisé via les fichiers d'environnement (.env). Les flags de validation des challenges sont stockés sous forme de hash SHA-3 256 dans MongoDB, garantissant qu'aucune réponse n'est exposée en clair dans le système principal. Cette approche préserve l'intégrité pédagogique des exercices tout en maintenant un niveau de sécurité approprié pour les données persistantes.

L'architecture présente volontairement des vulnérabilités dans les routes SQL qui utilisent des concaténations de chaînes sans échappement, permettant ainsi l'apprentissage pratique des techniques d'injection. Cette faiblesse intentionnelle est circonscrite à MySQL et ne compromet pas l'intégrité des données MongoDB grâce à la séparation architecturale stricte. Les étudiants peuvent ainsi explorer les failles d'injection SQL sans risquer d'altérer les vrais enregistrements du système.

L'utilisation de Traefik avec la fonctionnalité StripPrefix simplifie considérablement le code applicatif Express en gérant automatiquement les préfixes d'URL publics.

Cette approche permet au serveur d'application de se concentrer sur la logique métier sans avoir à gérer la complexité du routage externe, améliorant ainsi la maintenabilité et la sécurité du code.Cette architecture bicéphale offre un environnement d'apprentissage sécurisé où les vulnérabilités pédagogiques restent confinées à leur domaine d'application spécifique, préservant l'intégrité globale du système tout en offrant une expérience d'apprentissage authentique aux utilisateurs.

// Deux SGBD par design : Mongo pour l’état du jeu (fiable), MySQL uniquement pour les défis (surface de vulnérabilité contrôlée).

// Les variables sensibles (flags, identifiants) sont injectées via .env et hachées pour les flags côté Mongo.

// Les routes SQL gardent volontairement des concaténations de chaînes pour illustrer l’injection ; cette faiblesse ne menace pas Mongo grâce à la séparation.

// Traefik + StripPrefix simplifient le code applicatif (Express n’a pas à connaître les préfixes publics).

