= Architecture de la plateforme CyberGame <architecture>

== Présentation générale <presentation>
Le site web est une plateforme pédagogique créée par le pôle Y-Sécurity de la Haute École d’Ingénierie et de Gestion de Vaud. Elle a pour objectif d'introduire au ethical hacking et propose actuellement deux scénarios interactifs. La plateforme est donc conçu avec une page d'accueil @noauthor_initiation_nodate qui présente le cadre général. Le premier jeu "Shana a disparu" est accessible @noauthor_shana_nodate ainsi qu'un autre scénario "Sauve la Terre de l'arme galactique" @noauthor_sauve_nodate se trouve sur la plateforme. Pour aider les joueurs à avancer dans les différents challenges, une boîte à outils et un petit IDE Python ont été développé @noauthor_initiation_nodate.

== Architecture technique <architecture-technique>


== Mécanisme de jeu <mécanisme-de-jeu>

La plateforme CyberGame propose deux parcours structurés sous forme d'histoire progressive qui mettent en œuvre des techniques clés du hacking étiques. Chacun propose une enquête avec un scénario dont les étapes doivent être validé dans l'ordre afin que le joueur puisse progresser dans le déroulement de l'enquête.

=== Scénario 1 : "Shana a disparu" <shana>

Dans le scénario "Shana a disparu" @noauthor_shana_nodate a pour objectif d'amener le joueur dans une enquête de neuf challenges successifs qui miment la progression d'une investigation numérique. Pour nous aider à résoudre ces challenges, une petite boîte à outil avec des explications est fournie @noauthor_initiation_nodate. L'histoire commence par la reconstruction du mot de passe Windows de Shana à partir des informations qui se trouve sur le profil Instagram de la victime. Le challenge suivant est l'exploration de l'historique de navigation pour extraire ses derniers sites consultés. Une fois le site trouvé, un lien caché en texte invisible y est inséré sur la page. Le défi suivant consiste à inspecter le code source pour y trouver des informations qui vont nous permettent de progresser. Une fois l'information trouvée, le jeu redirige le joueur vers une page où la manipulation de cookie est nécessaire : le joueur doit y modifier la valeur d'une variable de session pour ainsi débloquer la page cachée. S’ensuit un chiffrement de césar qu’il faut renverser pour découvrir une date clé, puis l’altération manuelle de la fin d’une URL afin d’accéder à un répertoire non indexé. Le challenge suivant demande une injection SQL qui va permettre de contourner l'authentification et d'obtenir de nouvelles informations, qui se confirment grâce à l’extraction des coordonnées GPS dissimulées dans les métadonnées EXIF d’une photo. Chaque résolution de challenge permet de dévoiler un indice indispensable au suivant, illustrant la chaîne "collecte – exploitation – preuve" qui est l’approche "typique" d'un hacker éthique.


=== Scénario 2 : "Sauve la Terre de l’arme galactique" <galacgame>

Le second scénario que nous retrouvons sur la plateforme "Sauve la Terre de l'arme galactique" @noauthor_initiation_nodate, utilise les mêmes principes que le premier scénario mais dans un univers de science-fiction. Le joueur est plongé dans une enquête afin de retrouver les plans d'une arme galactique et ainsi sauver le monde. Dans un premier temps, le joueur exploite la barre de recherche d'un réseau fictif pour dégoter des fragments de conversation. Ensuite, le participant·e va utiliser de l’ingénierie sociale vont permettre de retrouver des réponses de sécurité, imprudemment divulguées en ligne, ce qui va permettre de retrouver le mot de passe et ainsi accéder au profil. Des challenges similaires se retrouvent dans les deux jeux comme la manipulation des cookies, l'ajustement d'un paramètre GET dans l'URL d'un lien, l'injection SQL afin de contourner un mot de passe, l'utilisation des métadonnées d'une images à l'aide de l'outil exiftool et enfin de la cryptographie. Des challenges supplémentaires ont été ajouté comme l'utilisation d'une requête WHOIS, qui sert à identifier le propriétaire d'une adresse IPv6 et intercepter son trafic et pour terminer le joueur doit réaliser attaque par bruteforce à l'aide d'un petit script Python qu'il doit écrire.


== Techniques mobilisées <technologies-utilisees>

Les jeux utilisent un ensemble de techniques du hacking éthique : recherche OSINT sur les réseaux sociaux ; lecture attentive du code HTML et des feuilles de style pour y déceler du contenu dissimulé ; modification manuelle des cookies et des paramètres GET afin de détourner la logique d’un site ; injection SQL destinée à contourner les contrôles d’authentification ; extraction et interprétation des métadonnées EXIF d’images ; cryptanalyse élémentaire (décodage César ou ROT-47) ; rédaction de courts scripts Python pour l’automatisation (attaque par force brute, déchiffrement) ; enfin, utilisation des services WHOIS et des requêtes DNS pour cartographier une infrastructure et remonter jusqu’à son propriétaire, le tout dans une histoire narrative progressive. 

Le participant·e découvre étape après étape, comment un professionnel de la cybersécurité, c'est-à-dire récolte d'informations, exploitation et utilisation des informations, combine curiosité, méthode et réflexion pour remontrer une piste et ainsi obtenir ce qu'il souhaite.

=== Analyse critique <positifs-améliorer>

Parmi les forces de la plateforme, les enquêtes sont construites afin de suivre une progression graduelle et une nouvelle technique. Chaque épreuve ré-exploite la précédente et favorise un apprentissage. La narration permet de maintenir le joueur·euse motivé mais le garde dans une optique d'apprentissage. \
En effet, grâce à la boîte à outils intégrées, qui contient les fiches pratiques, cela évite aux débutants de devoir faire trop de recherche et ainsi de focaliser sur le jeu. \
De plus, grâce à un mini IDE Python et un terminal intégré, le joueur·euse n'a rien besoin d'installer sur sa machine. L'expérience se déroule entièrement sur le navigateur ce qui abaisse la barrière d’entrée, et la variété des techniques abordées offre un panorama cohérent de la sécurité offensive.

Cependant, quelques points mériteraient toutefois des améliorations. D’abord, le champ dans lequel le joueur·euse doit saisir sa réponse ne précise pas toujours le format exigé ; lorsque la consigne n’affiche qu’un mot mis en gras, l’information passe facilement inaperçue et l’utilisateur·trice ignore s’il doit entrer un mot-clé, une URL complète, un hash ou une date. Le joueur·euse peut avoir du mal à comprendre ce qu'il doit mettre, ce qui peut entraîner de la frustration. Il serait judicieux, par exemple de mettre dans l'indice, le format attendu avec un exemple. \
Ensuite Pour la validation de l'étape, il faut impérativement entré une réponse valide valide dans le champ "Réponse" malgré que l'interface visuelle du jeu change (en particulier lors du changement des cookies). Le joueur·euse peut ne pas comprendre ce qu'il doit faire et peut rester bloquer car il ne sait pas ce qui est attendu de lui. \
Le passage d’un challenge au suivant manque parfois de fiabilité : la pop-up explicative ne s’ouvre pas systématiquement et la barre de progression reste figée. Le participant·e doit donc cliquer sur l'étape suivante et ainsi obtenir les informations de son challenge ainsi que le nouvel interface de travail. \
Enfin, les indices actuels fournissent, dans un premier temps, un bon point de départ. Cependant, cela peut se révéler insuffisant pour les joueur·euse·s débutants. La mise en place d'aides graduelles pourraient limiter le risque d'abandon tout en gardant le défi intéressant.


== Analyse de la sécurité <analyse-sécurité>

