= Scénario définitif et liste des challenges détaillés <scenario-challenges>
Le scénario définitif retenu est l'histoire 1, intitulé "Blackout dans le _Centre Hospitalier Horizon Santé_", et il combine les challenges des scénarios 1 et 2 ainsi que de nouveaux défis adaptés afin de suivre une évolution cohérente d'une attaque par ransomware. Cette histoire s'inspire de faits réels qui pourraient arriver dans un hôpital et des étapes simplifiées qu'une équipe de cybersécurité devrait réaliser afin de récupérer les données et sécuriser l’infrastructure hospitalière.

Le scénario retenu, dans son ensemble inclue le détail des challenges, chacun visant à sensibiliser les participant·e·s à des aspects spécifiques de la sécurité informatique. Chaque challenge suit l'intrigue et est écrit pour être interactif et éducatif. Cela permet aux participant·e·s d'apprendre en pratiquant. \
Chacun des challenges est expliqué plus en détail sur l'implémentation, ce qui est attendu du joueur·euse avec les consignes, les indices et les solutions attendues.

Le titre a du être remanié pour coller avec le scénario de l'histoire et donc porte le nom "Intrusion dans le _Centre Hospitalier Horizon Santé_". De ce fait, les anciens noms "Blackout" ont été remplacés par "Intrusion".

*Fil rouge du scénario*

Le joueur·euse reçoit une information expliquant que l'hôpital subit une attaque par ransomware. Une mise en contexte est posée ainsi que le rôle qu'il va jouer : il incarne un membre de l'équipe cybersécurité de l'hôpital qui intervient pour contenir l'attaque et supprimer les données volées par les cybercriminels au Centre Hospitalier Horizon Santé (Challenge 0 Intro).\
Après avoir retrouvé l'email de phishing à l'origine de l'attaque (#link(<ch-1>)[Challenge 1 Mail Contagieux]), il découvre le domaine frauduleux et se lance dans son exploration. Il y découvre un portail sûrement d'exfiltration mise en place par les assaillants (#link(<ch-2>)[Challenge 2 Portail Frauduleux]). Pour réussir à y pénétrer, il réalise une injection SQL pour contourner l'authentification et ouvrir une première session, mais seulement avec des droits utilisateur.
Sur ce portail, il découvre un "Dépôt sécurisé" qui ne contient aucune donnée pertinente. Grâce à une mauvaise configuration des permissions sur les répertoires, il parvient à accéder à une archive chiffrée qui contient potentiellement des informations intéressantes (#link(<ch-3>)[Challenge 3 Partage Oublié]). En inspectant les métadonnées du fichier ZIP, le joueur·euse déchiffre le mot de passe grâce à une empreinte SHA-1 laissée dans les commentaires par les attaquants et grâce à un peu de bruteforce (#link(<ch-4>)[Challenge 4 Clé cachée]). Une fois le dossier dézippé, le joueur·euse découvre les fichiers sensibles de l'hôpital. Cependant, étant un simple utilisateur, il n'a pas les droits nécessaires pour supprimer ces données. L'archive contient aussi un script de monitoring d'un bot administrateur en développement. Grâce à du reverse engineering de ce script (#link(<ch-5>)[Challenge 5 Script Mystère]), il découvre l'existence de la page du bot en développement que les pirates utilisent pour surveiller leur infrastructure. Grâce aux informations présente sur la page et à une zone de texte, le joueur·euse peut déduire que le bot est vulnérable à une attaque XSS.
Pour obtenir les droits administrateur nécessaires à la suppression des données, il faudra donc exploiter les vulnérabilités de ce chatbot via cette attaque. Une payload injectée dans le chat permet de capturer le cookie "admin" du bot et de le mettre dans le navigateur (#link(<ch-6>)[Challenge 6 Cookie Admin]). Le bouton "Supprimer" peut enfin être cliqué, ce qui va permettre de supprimer tous les fichiers volés et empêcher ainsi les attaquants de poursuivre leur chantage.\
Enfin, pour s'assurer que l'attaquant ne puisse plus attaquer à nouveau, le joueur·euse devra analyser les logs VPN de l'hôpital, repérer l'IP qui tente d'exfiltrer massivement des données et l'inscrire dans la liste noire du pare-feu de l'hôpital (#link(<ch-7>)[Challenge 7 Blocage ciblé]). Le message final confirme le blocage et l'incident est officiellement terminé.\
Pour terminer, le joueur·euse reçoit un message de fin qui conclut l'aventure (Challenge 8 Outro).

En parcourant ces sept défis, le participant·e permet d'avoir un aperçu sur tout le cycle d’une réponse à incident : OSINT, exploitation Web, contrôle d’accès, cryptanalyse, reverse engineering, escalade de privilèges via XSS, et opérations de défense. Chaque étape montre une bonne pratique de cybersécurité à mettre en œuvre pour protéger les établissements de santé contre les ransomwares.

#figure(
  image("schemas/scenario.png"),
  caption: [Schéma récapitulatif du scénario "Intrusion dans le Centre Hospitalier Horizon Santé"],
)<site_web>

Il est important de noter que les challenges pourront être adaptés en fonction des compétences des joueur·euse·s et de leur niveau d'expérience lors de l'implémentation du code. Il s'agit que d'une proposition de structure et de contenu pour le scénario. Les défis peuvent être modifiés ou ajustés pour mieux correspondre aux objectifs pédagogiques et aux compétences visées.

*Challenges à réaliser*
#table(
  columns: (auto, 1fr, 1fr, 2fr),
  align: (center, left, left, left),

  table.header([*Étape*], [*Nom du challenge*], [*Compétence travaillée*], [*Description du challenge*]),

  [0], [Introduction], [-], [Il s'agit de la genèse avec les informations de l'incident.],

  [1],
  [#link(<ch-1>)[Mail Contagieux]],
  [OSINT et forensic e-mail],
  [Analyser les en-têtes d’un e-mail de phishing pour identifier le domaine frauduleux utilisé par l’attaquant.],

  [2],
  [#link(<ch-2>)[Portail Frauduleux]],
  [Exploitation Web (SQL)],
  [Contourner un formulaire de connexion malgré un WAF basique pour accéder au serveur des pirates.],

  [3],
  [#link(<ch-3>)[Partage Oublié]],
  [Contrôle d’accès],
  [Explorer un dépôt mal configuré pour accéder à l’archive confidentielle.],

  [4],
  [#link(<ch-4>)[Clé cachée]],
  [Cryptographie et métadonnées],
  [Trouver un SHA-1 dans le commentaire ZIP, brute-forcer un mot de passe.],

  [5],
  [#link(<ch-5>)[Script Mystère]],
  [Reverse engineering],
  [Décoder des chaînes Base64 cachées dans `monitor_check_wip.py` afin de révéler une page vulnérable.],

  [6],
  [#link(<ch-6>)[Cookie Admin]],
  [XSS et détournement de session],
  [Injecter du JavaScript dans un chatbot pour voler le cookie de session admin et supprimer les données volées.],

  [7],
  [#link(<ch-7>)[Blocage ciblé]],
  [Défense et journalisation],
  [Analyser les logs VPN, repérer l’IP la plus bavarde et l’ajouter à la liste noire du pare-feu.],

  [8], [Conclusion], [-], [Message de fin et conclusion du scénario.],
)

*Stratégie de complexités des challenges* <complexité-challenges>

La conception des consignes et des indices s’appuie sur une logique adaptée aux différents niveaux de compétence. Un·e participant·e avancé·e doit pouvoir résoudre les défis sans utiliser les indices, ou au maximum en consultant le premier. À l’inverse, les débutant·e·s peuvent recourir à l'ensemble des indices graduels, ce qui devrait leur permettre d’avancer pas à pas et de parvenir malgré tout à la résolution du challenge.

Il s’agit d’une progression à difficulté croissante où chaque challenge est conçu pour rester accessible au plus grand nombre, tout en offrant des défis intéressants pour les utilisateur·trice·s plus expérimenté·e·s.

*Introduction pour le joueur·euse*

Le joueur·euse reçoit une première popup, qui représente le niveau 0, qui correspond l'intrigue générale pour commencer l'histoire : \
"_Vous faites partie d'une équipe d'intervention en cybersécurité mandatée par l'Hôpital Horizon Santé. En arrivant sur place ce mardi 12 juillet 2025 à 12h32, vous découvrez l'établissement en état de crise : une demande de rançon vient d'être reçue.\
Le Centre hospitalier Horizon Santé est un grand hôpital universitaire de la région, centre de référence pour les soins d'urgence, les soins intensifs et les interventions chirurgicales complexes. C'est également un important centre de recherche médicale.\
Les premiers éléments de l'enquête révèlent qu'un groupe de cybercriminels a réussi à infiltrer le réseau de l'hôpital. Un ransomware a exfiltré les données sensibles de tous les patients et les attaquants menacent maintenant de les divulguer publiquement.\
Votre mission est de pénétrer dans le système des attaquants, supprimer les données sensibles qu'ils ont volées et les bloquer définitivement pour qu'ils ne puissent plus accéder au réseau de l'hôpital._"


#pagebreak()
#include "challenge-1.typ"
#pagebreak()
#include "challenge-2.typ"
#pagebreak()
#include "challenge-3.typ"
#pagebreak()
#include "challenge-4.typ"
#pagebreak()
#include "challenge-5.typ"
#pagebreak()
#include "challenge-6.typ"
#pagebreak()
#include "challenge-7.typ"

Le joueur·euse a réussi à bloquer l'attaquant et à sécuriser le réseau de l'hôpital. La deuxième vague n'aura donc pas lieu et le joueur·euse reçoit pour conclure l'aventure.

Une fois à la fin du challenge 7, une dernière popup, qui est le niveau 8, apparaît pour conclure l'aventure :

"_Mission accomplie !\
Vous avez supprimé les fichiers sensibles chiffrés récupérés par les attaquants et bloqué toute tentative d’exfiltration de données. Les données des patient·e·s sont désormais en sécurité.\
L’équipe technique a déjà enclenché le plan de remédiation complet, renforcé les défenses réseau et sécurisé les accès sensibles. Les preuves collectées au fil de votre enquête ont été transmises aux autorités pour enclencher les poursuites judiciaires.\
Grâce à votre réactivité et vos compétences, le Centre Hospitalier Horizon Santé a pu sécuriser ses données sensibles... et un drame a été évité de justesse._"

Le joueur·euse acquière une petite compréhension des enjeux de la cybersécurité dans un environnement hospitalier. Ces challenges permettent de montrer l’importance de la détection rapide des menaces, de l’analyse technique des incidents, de la maîtrise des techniques d’intrusion comme des mesures de défense. Ce scénario permet également d’illustrer comment une attaque informatique peut avoir des conséquences directes sur la possibilité de réaliser des soins et la sécurité des personnes, et pourquoi la cybersécurité est aussi un élément crucial pour les infrastructures de santé.
