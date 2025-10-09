= Architecture de la plateforme _CyberGame_ existante <architecture>
Ce chapitre présente l'architecture technique de la plateforme _CyberGame_, en détaillant le frontend et backend, ainsi que les mécanismes de jeu. Il est important de souligner qu'il s'agit d'une analyse de la plateforme de 2020 avant sa restructuration qui aura lieu. Cette analyse porte donc sur l’état initial du site, avant l’ajout de nouvelles fonctionnalités, la refonte du design ou l’amélioration de l’expérience utilisateur.

== Présentation générale <presentation>
Le site web est une plateforme pédagogique créée par le pôle Y-Security de la HEIG-VD. Il a pour objectif d'introduire à l'ethical hacking et propose actuellement deux scénarios interactifs. La plateforme est donc conçue avec une page d'accueil @InitiationAuEthical qui présente le cadre général. Le premier jeu "Shana a disparu" @ShanaDisparuRetrouvela ainsi qu'un autre scénario "Sauve la Terre de l'arme galactique !" @SauveTerreLarme se trouvent sur la plateforme. Pour aider les joueur·euse·s à avancer dans les différents challenges, tout en restant dans son navigateur, une boîte à outils et un petit IDE Python ont été mis en place @InitiationAuEthical.

#figure(
  image("schemas/site_web.png", width: 75%),
  caption: [Schéma de l'architecture globale de la plateforme _CyberGame_],
)<site_web>

== Mécanisme de jeu <mécanisme-de-jeu>

La plateforme _CyberGame_ propose deux parcours structurés sous forme d'histoires progressives qui mettent en œuvre des techniques du hacking éthique. Chacun propose une enquête avec un scénario dont les étapes doivent être validées dans l'ordre afin de pouvoir progresser dans le déroulement de l'enquête.

Le participant·e découvre, étape par étape, la méthodologie d'un professionnel·le de la cybersécurité à travers la chaîne "collecte – exploitation – preuve", où chaque résolution dévoile un indice pour le défi suivant. Chaque challenge reste en surface pour montrer à quoi pourrait ressembler des attaques de grandes envergures qui combinent une suite de failles bien différentes sur des aspects réseau, d'application web, d'analyses de fichier ou de systèmes intégrant de la cryptographie.

=== Scénario 1 : "Shana a disparu" <shana>

Le scénario "Shana a disparu" @ShanaDisparuRetrouvela a pour objectif d'amener le joueur·euse dans une enquête de neuf challenges qui imite la progression d'une investigation numérique. L'histoire commence par la reconstruction du mot de passe Windows de Shana à partir des informations qui se trouvent sur le profil Instagram de la victime. Le challenge suivant est l'exploration de l'historique de navigation pour extraire ses derniers sites consultés. Une fois le site trouvé, un lien caché en texte invisible est inséré sur la page. Le défi suivant consiste à inspecter le code source pour trouver des informations qui vont nous permettre de progresser. Une fois l'information trouvée, le jeu redirige le joueur·euse vers une page où la manipulation de cookie est nécessaire et où il faut modifier la valeur d'une variable de session pour débloquer la page cachée. Ensuite, il s'agit d'un chiffrement de César qu’il faut renverser pour découvrir une date clé, puis l’altération manuelle de la fin d’une URL afin d’accéder à un répertoire non indexé. Le challenge suivant demande une injection SQL qui va permettre de contourner l'authentification et d'obtenir de nouvelles informations, qui se trouvent grâce à l’extraction des coordonnées GPS dissimulées dans les métadonnées EXIF d’une photo.


=== Scénario 2 : "Sauve la Terre de l'arme galactique !" <galacgame>

Le second scénario que nous retrouvons sur la plateforme "Sauve la Terre de l'arme galactique !" @InitiationAuEthical, utilise les mêmes principes mais dans un univers de science-fiction. Le joueur·euse est plongé·e dans une enquête afin de retrouver les plans d'une arme galactique et ainsi sauver le monde. Dans un premier temps, le joueur·euse exploite la barre de recherche d'un réseau fictif pour obtenir des fragments de conversation. Ensuite, le participant·e va utiliser l’ingénierie sociale pour retrouver des réponses de sécurité, imprudemment divulguées en ligne, ce qui va permettre de retrouver le mot de passe et ainsi d'accéder au profil. Des challenges similaires se retrouvent dans les deux jeux comme la manipulation des cookies, l'ajustement d'un paramètre dans l'URL d'un lien, l'injection SQL afin de contourner un mot de passe, l'utilisation des métadonnées d'une image à l'aide de l'outil exiftool et enfin de la cryptographie. Des challenges supplémentaires ont été ajoutés comme l'utilisation d'une requête WHOIS, qui sert à identifier le propriétaire d'une adresse IPv6 et intercepter son trafic. Pour terminer, le joueur·euse doit réaliser une attaque par bruteforce en codant un petit script Python.

== Analyse critique <positifs-améliorer>
=== Points forts
Parmi les forces de la plateforme, les enquêtes sont construites afin de suivre une progression graduelle. Chaque épreuve ré-exploite la précédente et favorise un apprentissage différent. La narration permet de maintenir le joueur·euse motivé·e mais le garde dans une optique d'apprentissage.

En effet, la boîte à outils intégrée, qui contient les fiches pratiques, évite aux débutant·e·s de devoir faire trop de recherches et ainsi leur permet de se focaliser sur le jeu.

De plus, grâce à un mini IDE Python et un terminal intégré, comme le montre les @ide-img et @terminal-img, le joueur·euse n'a rien besoin d'installer sur sa machine. L'expérience se déroule entièrement sur le navigateur, ce qui facilite l'accès au jeu et évite les installations complexes. 

#figure(
  image("imgs/ide-interface.png"),
  caption: [IDE présent sur le jeu "Sauve la Terre de l'arme galactique !", dans le challenge 6],
)<ide-img>
#figure(
  image("imgs/terminal-interface.png"),
  caption: [Terminal présent sur les 2 jeux, dans les challenges 9 de "Shana a disparu" et 5, 8 dans "Sauve la Terre de l'arme galactique !"],
)<terminal-img>

=== Axes d'amélioration
Quelques points mériteraient des améliorations. D’abord, la police VT323-Regular permet de créer une certaine ambiance mais elle est peu lisible, ce qui peut gêner la compréhension et la lecture des consignes.

La gestion de la fenêtre du jeu pourrait être optimisée, par exemple après la fermeture d’une popup, le joueur·euse se retrouve parfois avec un fond noir sans indication. Il serait utile d’ajouter des repères visuels ou des messages d’aide pour guider l’utilisateur·trice dans la progression, et de mieux intégrer la boîte à outils dès la page d’accueil pour que chacun·e sache où trouver les ressources.

Le design du site présente parfois des problèmes d’affichage selon la taille de la fenêtre du navigateur, comme le chevauchement d’éléments.

Le champ pour saisir sa réponse ne précise pas toujours le format exigé. De temps en temps, la consigne affiche un mot mis en gras, qui représente la réponse attendue, mais l’information passe facilement inaperçue ou l’utilisateur·trice ignore toujours le bon format (un mot-clé, une URL complète, un hash ou une date). Inclure le format attendu avec des exemples, dans l'indice ou dans la consigne, pourrait faciliter la validation du challenge une fois le secret trouvé.

Ensuite, pour la validation de l'étape, il faut impérativement entrer une réponse valide dans le champ "Réponse" malgré que l'interface visuelle du jeu change en fonction de ce que le joueur·euse à réalisé comme manipulation et du message de félicitations.
#figure(
  image("imgs/bug-interface1.png"),
  caption: [Interface du jeu après la validation d'un challenge],
)<bug-interface1-imgs>

Dans la @bug-interface1-imgs, nous pouvons voir que le joueur·euse à bien réussi à trouver la réponse du challenge. Cependant, comme le montre la @bug-interface2-imgs, l'interface de travail ne change pas. Le joueur·euse peut ne pas comprendre ce qu'il doit faire et peut rester bloqué car il ne sait pas ce qui est attendu de lui.

#figure(
  image("imgs/bug-interface2.png"),
  caption: [Interface du jeu bloquée entre deux challenges sans information claire sur la prochaine étape de progression.],
)<bug-interface2-imgs>

Le passage d’un challenge au suivant manque parfois de fiabilité, la popup explicative ne s’ouvre pas systématiquement et la barre de progression reste figée. Le participant·e doit donc cliquer sur l'étape suivante pour accéder à la consigne du challenge suivant ainsi que la nouvelle interface de travail.

Un autre élément d'amélioration serait de réaliser un changement de curseur sur les éléments cliquables (par exemple, en utilisant `cursor: pointer` en CSS) pour permettre au joueur·euse d’identifier les zones interactives. Actuellement, certains éléments interactifs ne sont pas mis en valeur, ce qui peut rendre la navigation moins intuitive.

Enfin, les indices actuels fournissent, dans un premier temps, un bon point de départ. Cependant, cela peut se révéler insuffisant pour les joueur·euse·s débutant·e·s. La mise en place d'aides graduelles pourrait limiter le risque d'abandon tout en gardant le défi intéressant.


== Architecture technique <architecture-technique>

=== Vue d'ensemble de l'infrastructure <vue-ensemble>

La plateforme _CyberGame_ est hébergée sur le sous-domaine `cybergame.heig-vd.ch` et repose sur une infrastructure conteneurisée avec Docker Compose (@docker-compose.yml), ce qui permet une séparation claire des responsabilités.

#figure(
  image("schemas/docker_compose.png"),
  caption: [Architecture Docker Compose de la plateforme _CyberGame_],
)<docker-compose-img>

Le fichier `docker-compose.yml` (@docker-compose.yml) définit l'ensemble des services nécessaires à l'application et orchestre leur déploiement. La @docker-compose-img présente l'architecture complète. Traefik (ports `80`/`443`) assure la terminaison TLS et route les requêtes vers trois services principaux : le frontend (port `3001`, répertoire `DigitalDay_APP`), le backend (port `3000`, répertoire `DigitalDay_BACKEND`, API Node.js Express), et webssh (port `8888`, serveur Python wssh). Le service webssh agit comme une passerelle SSH et permet de se connecter aux trois conteneurs SSH spécialisés : `ssh-whois` (requêtes WHOIS), `ssh-machine` (analyse système), et `ssh-galactic-forensic` (forensique). La persistance repose sur MongoDB (port `27017`, données critiques) et MySQL (port `3306`, exercices d'injection SQL isolés).

=== Frontend <frontend>

Chaque challenge est développé comme un "mini-site" indépendant dans son propre dossier (ex: `01_windows_login/`, `07_url_modification/`). La structure type est un fichier HTML de lancement chargeant `css/style.css`, des scripts globaux dans `/js`, un header commun (logo, progression, bouton retour), `popup.html` pour introduction avec les indices, et un dossier `img/` pour les ressources visuelles.

Lorsque le joueur·euse arrive sur un challenge, une popup s'ouvre avec le contexte et un bouton "Commencer le challenge !". Un bouton "Indice" est disponible pour obtenir de l'aide.

==== Flux de validation <flux-validation>

Le joueur·euse soumet sa réponse via un champ de saisie, déclenchant un appel API vers le backend. Si correcte, le backend met à jour `User.flagged` dans MongoDB et renvoie l'URL du challenge suivant (HTTP 200). Le frontend ferme la popup de félicitations et déverrouille l'onglet suivant.

=== Cartographie des challenges <cartographie>

Un fichier JSON (@annex-config-json) répertorie tous les challenges (nombre, ordre, URLs). Il assure le contrôle d'intégrité et facilite l'ajout de nouveaux défis.

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

La même architecture est appliquée au scénario "Sauve la Terre de l'arme galactique !" @galacgame, avec des défis similaires mais adaptés à un univers de science-fiction.

=== Gestion des données <gestion-donnees>
MongoDB stocke les données critiques de la plateforme via les modèles Mongoose @MongooseV8191Getting définis dans `db.js` (@db.js). Trois collections principales sont gérées : `Flag` pour les flags hachés en SHA3-256 initialisés depuis les variables d'environnement `CHALL_FLAGS_2020` et `CHALL_FLAGS_2021`, `User` pour les profils utilisateur avec les champs `uuid`, `name`, `surname`, `mail` et un tableau `flagged` pour suivre la progression, et `Visitor` pour les compteurs de visiteurs par heure. Le système d'initialisation automatique calcule le hash SHA3-256 de chaque flag et l'insère s'il n'existe pas déjà. Cette approche assure la persistance des données utilisateur sans exposer les réponses en clair en cas de tentative d'injection SQL. \
La base MySQL, initialisée via le script `init.sql` (@init.sql), sert exclusivement aux défis d'injection SQL. Elle contient deux tables : `users` avec les champs `ID` et `pass` (mots de passe volontairement stockés en clair), et `posts` pour les fonctionnalités de recherche. Cette base de données ne possède aucune protection pour servir de cible lors d'attaques, isolant ainsi les vulnérabilités sans risquer d'altérer les vrais enregistrements MongoDB.

=== Backend <backend>

==== Routage <routage-services>

Traefik agit comme un reverse proxy et d'entrée unique pour les services. Il retire les préfixes via StripPrefix avant de transmettre aux services. Exemple : `POST /backend/visitor` devient `POST /visitor` pour Express ou `GET /ssh/?hostname=sshmachine` devient `GET /?hostname=sshmachine` pour wssh.

La page d'accueil `index.html` effectue un appel `POST /backend/visitor` pour incrémenter le compteur de visiteurs de la plateforme. La page de connexion `login.html` utilise deux endpoints qui sont `POST /backend/login` pour l'authentification des utilisateurs et `GET /backend/logout` pour la déconnexion. La page de statistiques `statistics.html` utilisent plusieurs endpoints avec `GET /backend/stats/*` pour récupérer les données de progression et de performance.

Le script `js/main.js` gère les interactions du scénario principal avec deux appels, `POST /backend/2020/flag` pour la validation des réponses et `POST /backend/user` pour la gestion des données utilisateur. Le script `js/galacmain.js` suit la même logique pour le scénario galacgame avec `POST /backend/2021/flag` et `POST /backend/user`.

Le challenge Windows Login (`challenges/01_windows_login/windows_login.html`) utilise l'endpoint `POST /backend/2020/checkFlag` pour valider les tentatives d'authentification OSINT. Le challenge d'injection SQL (`challenges/08_SQL_injection/sql_injection.html`) communique directement avec `POST /backend/db` pour permettre l'exploitation des vulnérabilités de la base de données.

Les défis qui ont besoin d'un terminal utilisent des iframes qui pointent vers `/ssh?...`, routées par Traefik vers webssh puis vers les conteneurs `sshmachine*`.

// Principaux endpoints frontend :
// - `index.html` : `POST /backend/visitor` (compteur)
// - `login.html` : `POST /backend/login`, `GET /backend/logout`
// - `statistics.html` : `GET /backend/stats/*`
// - `js/main.js` : `POST /backend/2020/flag` (validation), `POST /backend/user`
// - `js/galacmain.js` : `POST /backend/2021/flag`, `POST /backend/user`
// - `challenges/08_SQL_injection/` : `POST /backend/db`



==== API Express <api-express>

L'API Express (@index.js) gère la logique serveur via plusieurs modules fonctionnels :
#pagebreak()
*Validation des défis* :
- `POST /:year/flag` : hash SHA3-256 de la réponse, comparaison avec MongoDB, ajout à `user.flagged`
- `POST /:year/checkFlag` : validation sans mise à jour de progression

*Suivi utilisateur* :
- Middleware cookies UUID (`uuidv4`) pour suivi sans compte
- `POST /user` : enregistrement (nom, prénom, email) après complétion totale
- `POST /login` : authentification admin (env vars `SHANA_USER`/`SHANA_PASS`), cookie JWT
- `GET /logout` : suppression cookie

*Statistiques* (protégées JWT) :
- `GET /stats/getEditions`, `GET /stats/visitors`, `GET /stats/finished?year=...`, `GET /stats/flagPerChall?year=...`

*Endpoints vulnérables (pédagogiques)* :
- `POST /db`, `POST /db/search` : injection SQL volontaire sur MySQL `dday.users` et `posts`


=== Webssh et conteneurs SSH <webssh-conteneurs>

Webssh fournit un terminal web via `/ssh`. Trois conteneurs cibles SSH sont disponibles, chacun avec des outils spécifiques pour les défis :
- `ssh` : `rbash` restreint, outils (exiftool, ls)
- `sshmachine-whois` : binaire whois personnalisé, OSINT
- `sshmachine-galactic-forensic` : `libimage-exiftool-perl`, fichiers forensiques (`photo-gallery.jpg`)


== Analyse de la sécurité <analyse-sécurité>

L'architecture de sécurité de la plateforme _CyberGame_ repose, dans un premier temps, sur la séparation entre deux systèmes de gestion de base de données distincts, créant ainsi une surface de vulnérabilité contrôlée et isolée.

La gestion des variables sensibles s'appuie sur un système d'injection sécurisé via les fichiers d'environnement. Les flags de validation des challenges sont stockés sous forme de hash SHA3-256 dans MongoDB, garantissant qu'aucune réponse n'est exposée en clair. Cette approche conserve l'aspect pédagogique des exercices tout en permettant de garder un niveau de sécurité pour les données persistantes.

Cependant, en examinant plus en détail la plateforme, une vulnérabilité de sécurité a été identifiée. En effet, il est possible d'accéder directement aux différents challenges sans avoir complété les précédents, en utilisant l'URL directe. Par exemple, en accédant à `https://shana.heig-vd.ch/challenges/05_admin_cookie/index.html`, le joueur·euse peut directement accéder au challenge de modification des cookies sans avoir validé les étapes précédentes, comme le montre les @bug1 et @bug2. Le joueur·euse peut ainsi résoudre un challenge via l'URL directe sans passer par l'interface du jeu.


#figure(
  image("imgs/bug-secu1.png"),
  caption: [Identification de tous les liens pour les différents challenges],
)<bug1>

#figure(
  image("imgs/bug-secu2.png"),
  caption: [Accès à un challenge sans avoir complété les précédents via l'URL directe],
)<bug2>

De plus, il est possible d'accéder à toutes les popups des challenges avec les indices

#figure(
  image("imgs/bug-secu3.png"),
  caption: [Accès à toutes les popups des challenges avec les indices],
)<bug3>

Enfin, il est possible de valider un challenge via une modification de requête POST, comme le montre la @bug4. Le joueur·euse peut ainsi envoyer une requête POST vers l'API backend avec le `chall` et la `flag` pour valider un challenge sans passer par l'interface du jeu et sans avoir complété les étapes précédentes.

#figure(
  image("imgs/bug-secu4.png"),
  caption: [Résolution du challenge via une requête POST sans passer par l'interface du jeu],
)<bug4>
