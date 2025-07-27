= Architecture de la plateforme _CyberGame_ <architecture>

== Présentation générale <presentation>
Le site web est une plateforme pédagogique créée par le pôle Y-Sécurity de la HEIG-VD. Il a pour objectif d'introduire au ethical hacking et propose actuellement deux scénarios interactifs. La plateforme est donc conçue avec une page d'accueil @InitiationAuEthical qui présente le cadre général. Le premier jeu "Shana a disparu" @ShanaDisparuRetrouvela ainsi qu'un autre scénario "Sauve la Terre de l'arme galactique" @SauveTerreLarme se trouvent sur la plateforme. Pour aider les joueur·euse·euse·s à avancer dans les différents challenges, une boîte à outils et un petit IDE Python ont été développés @InitiationAuEthical.

== Architecture technique <architecture-technique>

=== Front-end <front-end>
La plateforme est hébergée sur un serveur web, accessible via un nom de domaine `heig-vd.ch` avec le sous-domaine `shana`. Le site utilise des technologies web standards telles que HTML, CSS et JavaScript pour l'interface utilisateur.

=== Cartographie automatique <cartographie-automatique>
// TODO pourquoi elle est automatique et préciser que c'est pour Shana

La cartographie automatique de la plateforme est réalisée à l'aide d'un tableau qui répertorie les différents challenges, les techniques ciblées et les intentions pédagogiques. Chaque ligne du tableau correspond à un challenge spécifique, avec des informations sur le dossier ou le fichier de lancement, la technique ciblée et l'intention pédagogique. Cela permet de visualiser rapidement la structure des jeux et les compétences que chaque challenge vise à développer.

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

// Mapping JSON de niveau 1.

La même logique est appliquée au scénario "Sauve la Terre de l'arme galactique" @galacgame, avec des défis similaires mais adaptés à un univers de science-fiction.

// TODO === Back-end


== Mécanisme de jeu <mécanisme-de-jeu>

La plateforme CyberGame propose deux parcours structurés sous forme d'histoire progressive qui mettent en œuvre des techniques clés du hacking éthiques. Chacun propose une enquête avec un scénario dont les étapes doivent être validées dans l'ordre afin de pouvoir progresser dans le déroulement de l'enquête.

=== Scénario 1 : "Shana a disparu" <shana>

Le scénario "Shana a disparu" @ShanaDisparuRetrouvela a pour objectif d'amener le joueur·euse·e dans une enquête de neuf challenges successifs qui miment la progression d'une investigation numérique. Pour nous aider à résoudre ces challenges, une petite boîte à outil avec des explications est fournie @InitiationAuEthical. L'histoire commence par la reconstruction du mot de passe Windows de Shana à partir des informations qui se trouvent sur le profil Instagram de la victime. Le challenge suivant est l'exploration de l'historique de navigation pour extraire ses derniers sites consultés. Une fois le site trouvé, un lien caché en texte invisible est inséré sur la page. Le défi suivant consiste à inspecter le code source pour trouver des informations qui vont nous permettre de progresser. Une fois l'information trouvée, le jeu redirige le joueur·euse vers une page où la manipulation de cookie est nécessaire : il faut modifier la valeur d'une variable de session pour débloquer la page cachée. S’ensuit un chiffrement de César qu’il faut renverser pour découvrir une date clé, puis l’altération manuelle de la fin d’une URL afin d’accéder à un répertoire non indexé. Le challenge suivant demande une injection SQL qui va permettre de contourner l'authentification et d'obtenir de nouvelles informations, qui se confirment grâce à l’extraction des coordonnées GPS dissimulées dans les métadonnées EXIF d’une photo. Chaque résolution de challenge permet de dévoiler un indice indispensable au suivant, illustrant la chaîne "collecte – exploitation – preuve" qui est l’approche "typique" d'un hacker éthique.


=== Scénario 2 : "Sauve la Terre de l’arme galactique" <galacgame>

Le second scénario que nous retrouvons sur la plateforme "Sauve la Terre de l'arme galactique" @InitiationAuEthical, utilise les mêmes principes mais dans un univers de science-fiction. Le joueur·euse est plongé·e dans une enquête afin de retrouver les plans d'une arme galactique et ainsi sauver le monde. Dans un premier temps, le joueur·euse exploite la barre de recherche d'un réseau fictif pour obtenir des fragments de conversation. Ensuite, le participant·e va utiliser l’ingénierie sociale pour retrouver des réponses de sécurité, imprudemment divulguées en ligne, ce qui va permettre de retrouver le mot de passe et ainsi accéder au profil. Des challenges similaires se retrouvent dans les deux jeux comme la manipulation des cookies, l'ajustement d'un paramètre `GET` dans l'URL d'un lien, l'injection SQL afin de contourner un mot de passe, l'utilisation des métadonnées d'une image à l'aide de l'outil exiftool et enfin de la cryptographie. Des challenges supplémentaires ont été ajoutés comme l'utilisation d'une requête WHOIS, qui sert à identifier le propriétaire d'une adresse IPv6 et intercepter son trafic. Pour terminer, le joueur·euse doit réaliser une attaque par bruteforce à l'aide d'un petit script Python qu'il doit écrire.


== Techniques mobilisées <technologies-utilisees>

Les jeux utilisent un ensemble de techniques du hacking éthique : recherche OSINT sur les réseaux sociaux ; lecture attentive du code HTML et des feuilles de style pour trouver du contenu dissimulé ; modification manuelle des cookies et des paramètres `GET` afin de détourner la logique d’un site ; injection SQL destinée à contourner les contrôles d’authentification ; extraction et interprétation des métadonnées EXIF d’images ; cryptanalyse (décodage César ou ROT-47) ; rédaction de courts scripts Python pour l’automatisation (attaque par force brute, déchiffrement) ; enfin, utilisation des services WHOIS et des requêtes DNS pour cartographier une infrastructure et remonter jusqu’à son propriétaire, le tout dans une histoire narrative progressive.

Le participant·e découvre, étape après étape, comment procède un professionnel de la cybersécurité : récolte d'informations, exploitation et utilisation des données et réflexion pour remonter une piste et ainsi atteindre le but.

=== Analyse critique <positifs-améliorer>

Parmi les forces de la plateforme, les enquêtes sont construites afin de suivre une progression graduelle. Chaque épreuve ré-exploite la précédente et favorise un apprentissage. La narration permet de maintenir le joueur·euse motivé·e mais le garde dans une optique d'apprentissage. \
En effet, la boîte à outils intégrée, qui contient les fiches pratiques, évite aux débutant·e·s de devoir faire trop de recherches et ainsi leur permet de se focaliser sur le jeu. \
De plus, grâce à un mini IDE Python et un terminal intégré, le joueur·euse n'a rien besoin d'installer sur sa machine. L'expérience se déroule entièrement sur le navigateur ce qui abaisse la barrière d’entrée, et la variété des techniques abordées offrant un panorama cohérent de la sécurité offensive.

Cependant, quelques points mériteraient des améliorations. D’abord, le champ dans lequel le joueur·euse doit saisir sa réponse ne précise pas toujours le format exigé ; lorsque la consigne n’affiche qu’un mot mis en gras, qui représente la réponse attendue, l’information passe facilement inaperçue et l’utilisateur·trice ignore s’il doit entrer un mot-clé, une URL complète, un hash ou une date. Le joueur·euse peut avoir du mal à comprendre ce qu'il doit mettre, ce qui peut entraîner de la frustration. Il serait judicieux, par exemple de mettre dans l'indice, le format attendu avec un exemple, ou encore avant les début des challenges, montrer des exemples de formats attendus. \
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
// j'ai aussi d'autres points relou comme proposition d'ajout ou de complément
// de ce qui est déjà écrit
// - police de caractère a une ambiance sympa mais peu lisible
// - gestion de la fenêtre du jeu un peu mal géré (on scroll
// et on a juste le fond noir). 
// - pas de changement de type de curseur sur les éléments cliquables (en css cursor:pointer je crois)
// (notamment les ronds pour switcher de challenges, du coup on sait pas immédiatement que c'est cliquable)
// - une fois la popup de texte fermée ya un fond noir et on est paumé
// - si on est paumé, on a pas eu linfo des outils -> 
//   pas de mention des outils dans la page d'accueil (de shana en tous cas)
// - design général peu soigné (input par dessus menu,


// TODO == Analyse de la sécurité <analyse-sécurité>

