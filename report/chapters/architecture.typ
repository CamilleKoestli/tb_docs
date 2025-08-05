= Architecture de la plateforme _CyberGame_ <architecture>
Ce chapitre présente l'architecture technique de la plateforme _CyberGame_, en détaillant le front-end et back-end, ainsi que les mécanismes de jeu. Il est important de souligner qu'il s'agit d'une analyse de la plateforme de 2020 avant sa restructuration qui a eu lieu en 2025. Cette analyse porte donc sur l’état initial du site, avant l’ajout de nouvelles fonctionnalités, la refonte du design ou l’amélioration de l’expérience utilisateur. 

== Présentation générale <presentation>
Le site web est une plateforme pédagogique créée par le pôle Y-Sécurity de la HEIG-VD. Il a pour objectif d'introduire au ethical hacking et propose actuellement deux scénarios interactifs. La plateforme est donc conçue avec une page d'accueil @InitiationAuEthical qui présente le cadre général. Le premier jeu "Shana a disparu" @ShanaDisparuRetrouvela ainsi qu'un autre scénario "Sauve la Terre de l'arme galactique" @SauveTerreLarme se trouvent sur la plateforme. Pour aider les joueur·euse·euse·s à avancer dans les différents challenges, une boîte à outils et un petit IDE Python ont été développés @InitiationAuEthical.

== Architecture technique <architecture-technique>

La plateforme est hébergée sur un serveur web, accessible via un nom de domaine `heig-vd.ch` avec le sous-domaine `shana`. Le site utilise des technologies web standards telles que HTML, CSS et JavaScript pour l'interface utilisateur.

=== Front-end <front-end>

La structure du front-end montre que chaque épreuve est développée comme un mini-site indépendant dans son propre dossier. Cela permet d'obtenir ainsi une architecture claire et modulaire qui facilite la maintenance et l’ajout de nouveaux niveaux.
Chaque challenge suit une structure composée de plusieurs éléments, chacun avec un rôle spécifique dans l'expérience pédagogique.

Le dossier racine du challenge (par exemple `01_windows_login/`, `07_url_modification/`, ...) contient toutes les ressources spécifiques à l'épreuve.

Le fichier HTML de lancement (comme `windows_login.html` ou `gallery1.html`, ...) représente la partie interactive visible par le joueur. Ce fichier charge systématiquement plusieurs ressources : une feuille de style locale située dans `css/style.css`, jQuery version 1.7.1 accompagné parfois d'un script global stocké dans `/js`, ainsi que le header commun comprenant le logo, le compteur de progression et le bouton "Retour". Un élément `div.popup-trigger` est toujours présent pour déclencher l'affichage de la pop-up d'aide.

Le sous-dossier `css/` contient les styles spécifiques au challenge. La feuille de style définit l'apparence visuelle (police, arrière-plan, couleurs).

Le sous-dossier `img/` stocke les ressources visuelles nécessaires comme les illustrations, les captures d'écran et les images de fond. Par exemple, `background_history.png` sert uniquement visuel du niveau "Browser History".

Le fichier `popup.html` présente la pop-up d'introduction et d'indices. Tous les challenges utilisent la même structure, c'est-à-dire un titre, le contexte de l'épreuve, un rappel du format de réponse attendu et un bouton "Commencer" pour lancer le défi. En dessous, se trouve aussi le bouton "Indice" qui permet d'obtenir l'indice pour résoudre le challenge.

// La logique JavaScript locale gère les interactions spécifiques à chaque challenge. Le code est souvent intégré directement dans la page HTML et se limite à quelques lignes pour gérer des éléments comme un accordéon, la modification dynamique du DOM ou la capture de l'événement Submit. Pour les challenges nécessitant plus de code (comme l'IDE Python), un module JavaScript dédié est placé dans le répertoire /js.

Le système de validation assure la communication avec le back-end. La majorité des pages envoient une requête fetch POST vers `/api/checkAnswer` (ou vers `/db/...` pour le challenge d'injection SQL). Le corps de la requête au format JSON contient les champs `challengeId` et `answer`. En retour, le serveur renvoie une réponse indiquant `success:true` avec l'URL du challenge suivant.

==== Flux type côté client
Lorsque le joueur arrive sur une page de challenge, une pop-up s'ouvre automatiquement pour montrer le contexte du défi et expliquer l'objectif.

Le joueur·euse peut ensuite interagir avec la page selon ce qui lui est demandé : cela peut impliquer de fouiller dans l'historique du navigateur, d'inspecter le DOM pour trouver des éléments cachés, de modifier la valeur d'un cookie, ...

Quand le joueur·euse pense avoir trouvé la solution, il propose sa réponse dans un champ de saisie sur la page. Cette proposition déclenche un appel vers l'API du serveur pour valider la réponse.

Si la réponse est correcte, le back-end va réaliser la mise à jour de la progression du joueur·euse dans la base MongoDB et renvoie l'URL du challenge suivant. Côté front-end, le pop-up de félicitations se ferme automatiquement et le prochain onglet devient accessible dans la barre, ce qui permet au joueur·euse de continuer son parcours.

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
  [OSINT + mot de passe à partir des réseaux sociaux],
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

=== Back-end
La couche serveur repose sur une architecture composée de Node.js, MongoDB et MySQL, le tout orchestré par Docker. Cette infrastructure comprend plusieurs éléments techniques avec des objectifs pédagogiques.

L'environnement Docker Compose déploie un service back-end basé sur Node 14, accompagné d'instances MongoDB et MySQL, ainsi que trois petits conteneurs docker-ssh servant de cibles d'attaque. Cette approche permet d'isoler chaque composant et de créer un environnement de test sécurisé pour les exercices d'injection SQL.

L'API Express, écrit dans le fichier `index.js` (Annexe@index.js), intègre les middlewares essentiels comme CORS, body-parser, cookie-parser et JWT pour la gestion des sessions. Elle montre plusieurs endpoints REST tels que `/db`, `/db/search`, `/user` et `/stats`. /*Le point critique réside dans l'utilisation d'un pool MySQL avec des requêtes non sécurisées du type `SELECT * FROM users where ID = '` + `req.body.user` + `'`, illustrant directement l'impact des vulnérabilités d'injection SQL dans le cadre du challenge 08.*/

Les modèles Mongoose, définis dans `db.js` (Annexe@db.js), gèrent trois collections principales : `Flag`, `User` et `Visitor`. Le système d'initialisation automatique calcule un hash SHA-3 256 pour chaque flag déclaré dans les variables d'environnement `CHALL_FLAGS_2020` et `CHALL_FLAGS_2021`, puis l'insère en base s'il n'existe pas déjà. Cette approche assure une gestion persistante des comptes utilisateurs et du système de score sans exposer les réponses en clair.

Enfin, la base MySQL est initialisée via le script `init.sql` (Annexe@init.sql)  avec une table `users` contenant les champs `ID` et `pass` (mots de passe stockés en clair), ainsi qu'une table posts pour les fonctionnalités de recherche et de like. Cette base est volontairement dépourvue de protections (pas d'index, pas de contraintes) pour servir de cible d'apprentissage dans les exercices d'injection de code.

==== Séquence de validation d’un challenge

Lorsque le joueur soumet une réponse, le front-end envoie une requête POST vers l'endpoint `/db` ou `/db/search`. L'API Node reçoit cette requête et exécute directement la requête MySQL sans échappement des caractères. Si la requête retourne au moins une ligne de résultat, la réponse est correcte.

Le back-end procède alors à la mise à jour des données en modifiant les champs `Flag` et `User.flagged` dans la base MongoDB. Une fois cette mise à jour effectuée, le serveur renvoie une réponse `HTTP 200` avec soit le flag, soit l'URL qui mène à la prochaine étape du challenge.

Côté front-end, la réception de cette réponse positive déclenche l'affichage d'une pop-up de félicitations et déverrouille automatiquement l'accès à la page suivante, conformément à la configuration définie dans le fichier de mapping JSON (Annexe@annex-config-json) gère la progression entre les différents challenges.

==== Pourquoi utiliser deux SGBD ?

Les deux DB présentent dans l'architecture du code ont des objectifs bien distincts. MongoDB stocke les données « sérieuses » (profils, progression). Alors que MySql n’est utile que pour le challenge 08 : on isole ainsi la faille sans risquer d’altérer les vrais enregistrements Mongo si un étudiant·e pousse l’exploit plus loin.

== Mécanisme de jeu <mécanisme-de-jeu>

La plateforme CyberGame propose deux parcours structurés sous forme d'histoire progressive qui mettent en œuvre des techniques clés du hacking éthiques. Chacun propose une enquête avec un scénario dont les étapes doivent être validées dans l'ordre afin de pouvoir progresser dans le déroulement de l'enquête.

=== Scénario 1 : "Shana a disparu" <shana>

Le scénario "Shana a disparu" @ShanaDisparuRetrouvela a pour objectif d'amener le joueur·euse·e dans une enquête de neuf challenges successifs qui miment la progression d'une investigation numérique. Pour nous aider à résoudre ces challenges, une petite boîte à outil avec des explications est fournie @InitiationAuEthical. L'histoire commence par la reconstruction du mot de passe Windows de Shana à partir des informations qui se trouvent sur le profil Instagram de la victime. Le challenge suivant est l'exploration de l'historique de navigation pour extraire ses derniers sites consultés. Une fois le site trouvé, un lien caché en texte invisible est inséré sur la page. Le défi suivant consiste à inspecter le code source pour trouver des informations qui vont nous permettre de progresser. Une fois l'information trouvée, le jeu redirige le joueur·euse vers une page où la manipulation de cookie est nécessaire : il faut modifier la valeur d'une variable de session pour débloquer la page cachée. S’ensuit un chiffrement de César qu’il faut renverser pour découvrir une date clé, puis l’altération manuelle de la fin d’une URL afin d’accéder à un répertoire non indexé. Le challenge suivant demande une injection SQL qui va permettre de contourner l'authentification et d'obtenir de nouvelles informations, qui se confirment grâce à l’extraction des coordonnées GPS dissimulées dans les métadonnées EXIF d’une photo. Chaque résolution de challenge permet de dévoiler un indice indispensable au suivant, illustrant la chaîne "collecte – exploitation – preuve" qui est l’approche "typique" d'un hacker éthique.


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
  caption: [IDE présent sur la plateforme],
)<ide-img>
#figure(
  image("imgs/terminal-interface.png"),
  caption: [Terminal présent sur la plateforme],
)<terminal-img>

=== Axes d'amélioration
Cependant, quelques points mériteraient des améliorations. D’abord, la police d'écriture utilisée, elle permet de créer une certaine ambiance mais elle est peu lisible, ce qui peut gêner la compréhension et la lecture des consignes. Un autre élément d'amélioration aurait été de réaliser un changement de curseur sur les éléments cliquables (par exemple, en utilisant `cursor: pointer` en CSS) pour permettre au joueur·euse d’identifier les zones interactives. Actuellement, certains éléments interactifs ne sont pas mis en valeur, ce qui peut rendre la navigation moins intuitive. La gestion de la fenêtre du jeu pourrait être optimisée, par exemple après la fermeture d’une pop-up, le joueur·euse se retrouve parfois avec un fond noir sans indication, ce qui peut désorienter. Il serait utile d’ajouter des repères visuels ou des messages d’aide pour guider l’utilisateur·trice dans la progression, et de mieux intégrer la boîte à outils dès la page d’accueil pour que chacun·e sache où trouver les ressources. Le design du site présente parfois des problèmes d’affichage selon la taille de la fenêtre du navigateur, comme le chevauchement d’éléments.
Le champ dans lequel le joueur·euse doit saisir sa réponse ne précise pas toujours le format exigé ; lorsque la consigne n’affiche qu’un mot mis en gras, qui représente la réponse attendue, l’information passe facilement inaperçue et l’utilisateur·trice ignore s’il doit entrer un mot-clé, une URL complète, un hash ou une date. Le joueur·euse peut avoir du mal à comprendre ce qu'il doit mettre, ce qui peut entraîner de la frustration. Il serait judicieux, par exemple de mettre dans l'indice, le format attendu avec un exemple, ou encore avant les début des challenges, montrer des exemples de formats attendus. \
Ensuite, pour la validation de l'étape, il faut impérativement entrer une réponse valide dans le champ "Réponse" malgré que l'interface visuelle du jeu change.
#figure(
  image("imgs/bug-interface1.png"),
  caption: [Interface du jeu après la validation d'un challenge],
)<bug-interface1-imgs>

 #figure(
  image("imgs/bug-interface2.png"),
  caption: [Interface du jeu qui ne change pas après la validation d'un challenge et pas de progression dans l'histoire.],
)<bug-interface2-imgs>
\
Dans la @bug-interface1-imgs, nous pouvons voir que le joueur·euse à bien réussi à trouver la réponse du challenge. Cependant, comme le montre la @bug-interface2-imgs, l'interface de travail ne change pas. Le joueur·euse peut ne pas comprendre ce qu'il doit faire et peut rester bloquer car il ne sait pas ce qui est attendu de lui. \
Le passage d’un challenge au suivant manque parfois de fiabilité : la pop-up explicative ne s’ouvre pas systématiquement et la barre de progression reste figée. Le participant·e doit donc cliquer sur l'étape suivante pour accéder à la consigne du challenge suivant ainsi que le nouvel interface de travail. \
Enfin, les indices actuels fournissent, dans un premier temps, un bon point de départ. Cependant, cela peut se révéler insuffisant pour les joueur·euse·s débutant·e·s. La mise en place d'aides graduelles pourraient limiter le risque d'abandon tout en gardant le défi intéressant.


// TODO 
== Analyse de la sécurité <analyse-sécurité>

