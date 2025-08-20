// TODO scénario confus parfois trop détaillé ou pas assez
// fil rouge à revoir

= Scénario définitif et liste des challenges détaillés <scenario-challenges>
Ce chapitre présente les différents challenges du scénario retenu, chacun visant à sensibiliser les participant·e·s à des aspects spécifiques de la sécurité informatique. Chaque challenge suit l'intrigue et est écrit pour être interactif et éducatif. Cela permet aux participant·e·s d'apprendre en pratiquant. \
Chacun des challenges est expliqué plus en détail sur l'implémentation, ce qui est attendu du joueur avec les consignes, les indices et les solutions attendues.

Le scénario définitif retenu est l'histoire 1, intitulé "Blackout dans le _Centre Hospitalier Horizon Santé_", et il combine les challenges des scénarios 1 et 2 ainsi que de nouveaux défis adaptés afin de suivre une évolution cohérente d'une attaque par ransomware. Cette histoire s'inspire de fait réelle qui pourrait arriver dans un hôpital et des étapes simplifiées qu'une équipe de cybersécurité devrait réaliser afin de récupérer les données et de sécuriser l’infrastructure hospitalière.

Ce scénario met en scène une attaque de rançongiciel dans un hôpital, qui entraîne un blackout des systèmes informatiques et des services critiques. Les joueur·euse·s devront résoudre une série de défis techniques et stratégiques en s'infiltrant dans le serveur des attaquants pour supprimer les dossiers sensibles exfiltrés et enfin sécuriser les installations de l'hôpital.

//TODO texte pas clair --> manque des éléments pour comprendre le fil rouge
// schéma
Le joueur·euse reçoit une information comme quoi l'hôpital subit un ransomware. Une mise en contexte est posé ainsi que le rôle qu'il va jouer. Il incarne un membre de l'équipe de sécurité qui doit contenir une cyber-attaque qui bloque le _Centre Hospitalier Horizon Santé_.
Après avoir retrouvé le courriel de phishing à l’origine de l'attaque (#link(<ch-1>)[_Challenge 1 Mail Contagieux_]), il découvre le domaine frauduleux et se lance dans l’exploration du faux portail exploité par les assaillants (#link(<ch-2>)[_Challenge 2 Portail Frauduleux_]). Pour réussir à y pénétrer, il réalise une injection SQL pour ouvrir une première session, mais seulement avec des droits limités : assez pour naviguer, mais pas assez pour supprimer des éléments présents sur les serveurs.\
Sur ce site, il découvre un "Dépôt sécurisé" mal protégé (#link(<ch-3>)[_Challenge 3 Partage Oublié_]) qui révèle une archive patient chiffrée. En inspectant les métadonnées du fichier ZIP, le joueur·euse déchiffre le mot de passe grâce à une empreinte SHA-1 et un peu de bruteforce (#link(<ch-4>)[_Challenge 4 Clé cachée dans les commentaires_]). L’archive libérée contient un script d’automatisation des sauvegardes : après un rapide reverse engineering, des identifiants SSH privilégiés tombent enfin dans ses mains (#link(<ch-5>)[_Challenge 5 Script Mystère_]).\
Ces nouveaux accès ne suffisent toujours pas : la console interne des pirates reste verrouillée derrière une session administrateur. Pour l’obtenir, il faudra tendre un piège XSS à un bot de rançon qui consulte chaque note déposée. Une balise `<script>` postée dans le formulaire permet de capturer le cookie "admin" et de le ré-injecter dans le navigateur (#link(<ch-6>)[_Challenge 6 Cookie Rançon_]). Le bouton « Delete All » peut enfin être cliqué, ce qui va permettre de supprimer tous les fichiers chiffrés et empêchant ainsi les attaquants de poursuivre leur ransomware.\
Enfin, pour s’assurer que l’attaquant ne puisse plus revenir, le joueur·euse devra analyser les logs VPN, repérer l’IP qui tente d’exfiltrer massivement des données et l’inscrire dans la liste noire du pare-feu (#link(<ch-7>)[_Challenge 7 Blocage ciblé_]). Le message final confirme le blocage, les systèmes critiques redémarrent, l’hôpital retrouve la maîtrise de son SI et l’incident est officiellement terminé.

En parcourant ces sept défis, le participant·e permet d'avoir un aperçu sur tout le cycle d’une réponse à incident : OSINT, exploitation Web, contrôle d’accès, cryptanalyse, reverse engineering, escalade de privilèges via XSS, et opérations de défense. Chaque étape montre une bonne pratique de cybersécurité à mettre en œuvre pour protéger les établissements de santé contre les ransomwares.

Il est important de noter que les challenges pourront être adaptés en fonction des compétences des joueur·e·s et de leur niveau d'expérience lors de l'implémentation du code. Il s'agit que d'une proposition de structure et de contenu pour le scénario. Les défis peuvent être modifiés ou ajustés pour mieux correspondre aux objectifs pédagogiques et aux compétences visées.

Le joueur·euse reçoit une première popup, qui représente le niveau 0, qui correspond l'intrigue générale pour commencer l'histoire : \
"_Le Centre hospitalier Horizon Santé est un grand hôpital universitaire de la région. Il est le centre de référence pour les soins d’urgence, les soins intensifs et les interventions chirurgicales complexes. Il est également un centre de recherche médicale important. Le mardi 12 juillet à 12 h 32, une campagne de phishing ciblée a permis à un groupe de cybercriminels d’infiltrer le réseau. En quelques minutes, un ransomware a chiffré les serveurs cliniques, pris le contrôle du réseau interne et provoqué une blackout des systèmes informatiques. Le groupe électrogène de secours ne dispose plus que de 68 minutes d’autonomie, si rien n’est fait, huit opérations à cœur ouvert devront être interrompues.\
Vous êtes la cellule d’intervention cyber appelée en dernier recours. Votre équipe de cybersécurité vient d’être connectée en urgence au réseau isolé de l’hôpital. Votre mission est de réussir à pénétrer dans le système des attaquants, supprimer les données sensibles qu'ils ont volées sur les patients et les bloquer pour qu'ils ne puissent plus pénétrer dans le système.\
Chaque minute compte, l’avenir des patient·e·s est entre vos mains._"

*Challenges à réaliser*
#table(
  columns: (auto, 1fr, 1fr, 2fr),
  align: (center, left, left, left),

  table.header([*Étape*], [*Nom du challenge*], [*Compétence travaillée*], [*Description du challenge*]),

  [0],
  [[ Introduction]],
  [-],
  [Il s'agit de la genèse avec les informations de l'incident.],

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
  [#link(<ch-4>)[Clé cachée dans les commentaires]],
  [Cryptographie et métadonnées],
  [Trouver un SHA-1 dans le commentaire ZIP, brute-forcer un mot de passe.],

  [5],
  [#link(<ch-5>)[Script Mystère]],
  [Reverse engineering],
  [Décoder des chaînes Base64 cachées dans `backup_sync.py` afin de révéler les identifiants SSH d'un user.],

  [6],
  [#link(<ch-6>)[Cookie Rançon]],
  [XSS et détournement de session],
  [//TODO à changer
  Injecter du JavaScript dans une demande de rançon pour voler le cookie "admin" du bot et supprimer les fichiers volés.],


  [7],
  [#link(<ch-7>)[Blocage ciblé]],
  [Défense et journalisation],
  [Analyser les logs VPN, repérer l’IP la plus bavarde et l’ajouter à la liste noire du pare-feu.],

  [8],
  [[Conclusion]],
  [-],
  [Message de fin et conclusion du scénario.],
)

== Stratégie de complexités des challenges <complexité-challenges>
//TODO a compléter
Il s'agit donc d'une stratégie de complexité croissante, où chaque challenge est conçu pour être accessible à un large public, tout en offrant des défis intéressants pour les utilisateur·trice·s plus expérimenté·e·s.

Pour réaliser la consigne et les indices, la stratégie utilisée est que pour un joueur·euse de niveau avancé·e·s, il doit pouvoir le résoudre sans utiliser les indices, voire seulement le premier. Pour les participant·e·s débutant·e·s, il doit pouvoir le résoudre en utilisant les indices graduels. 

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

"_Mission accomplie !
Vous avez supprimé les fichiers sensibles chiffrés récupérés par les attaquants et bloqué toute tentative d’exfiltration de données. Les systèmes critiques redémarrent progressivement, les opérations en cours peuvent se poursuivre et les patients sont hors de danger.
L’équipe technique a déjà enclenché le plan de remédiation complet, renforcé les défenses réseau et sécurisé les accès sensibles. Les preuves collectées au fil de votre enquête ont été transmises aux autorités pour enclencher les poursuites judiciaires.
Grâce à votre réactivité et vos compétences, le Centre Hospitalier Horizon Santé a retrouvé le contrôle de son système d’information… et un drame a été évité de justesse._"

Le joueur·euse acquière une petite compréhension des enjeux de la cybersécurité dans un environnement hospitalier. Ces challenges permettent de montrer l’importance de la détection rapide des menaces, de l’analyse technique des incidents, de la maîtrise des techniques d’intrusion comme des mesures de défense. Ce scénario permet également d’illustrer comment une attaque informatique peut avoir des conséquences directes sur la possibilité de réaliser des soins et la sécurité des personnes, et pourquoi la cybersécurité est aussi un élément crucial pour les infrastructures de santé.


#pagebreak()

