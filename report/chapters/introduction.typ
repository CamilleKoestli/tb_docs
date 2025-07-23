
= Introduction <introduction>

== Sensibilisation à la sécurité informatique <sensibilisation-sécurité>
De nos jours, la digitalisation croissante de notre quotidien, que ce soit au niveau administratif, paiements, télé-travail, ... expose les utilisateur·trice·s à de nombreux risques en matière de sécurité informatique. Dans l'article de _The Digital Decade_ les Européen·ne·s sont de plus en plus préoccupé·e·s par la sécurité de leurs données personnelles et de leur vie privée en ligne et 79% estiment  que "l'amélioration de la cybersécurité et de la protection des données [...]" est indispensable pour pouvoir profiter sans souci des services numériques @europeancommission.directorategeneralforcommunicationsnetworkscontentandtechnology.DigitalDecade2024.\ 
De plus, l'étude réalisée par _Wahl_ montre que 52% des répondants Européen·ne·s estiment ne pas être en mesure de se protéger suffisamment contre la cybercriminalité. Mais, en contrepartie, 52% des personnes interrogées déclarent qu'il y a une augmentation de la sensibilisation à la cybersécurité @wahlEurobarometerEuropeansAttitudes2020. En complément, le rapport publié par l'ENISA (Agence européenne de cybersécurité) met en évidence une baisse de la confiance des citoyen·ne·s dans leurs capacités à se protéger contre les menaces et met en évidence "une faible connaissance des mécanismes de signalement des cybercrimes" @europeanunionagencyforcybersecurityenisa2024ReportState2024. 

Le risque principal que les utilisateur·trice·s courent, est d'être la cible d'attaques, telles que le phishing, les ransomwares ou les logiciels malveillants. Aujourd'hui, les cybercriminels vont plus loin que l'exploitation des technologies mais tirent aussi profit ses failles humaines à travers du social engineering par des attaques personnalisées utilisant l'IA @spysPhishingStatistics20252025. En 2027, nous estimons qu'il y aura une augmentation de 17% des attaques utilisant l'IA @spysPhishingStatistics20252025. Le nombre de courriels frauduleux envoyés par jour dépassent les 3,4 milliards, ce qui représente 36 % des brèches de sécurité et 94 % des infections par maliciel @spysPhishingStatistics20252025. Les campagnes de phishing se sont intensifiées, avec une augmentation de 57,5 % des attaques par ransomwares entre novembre 2024 et février 2025 @knowbe4PhishingThreatTrends2025.

De plus, dans le monde entrepreneurial, il y a une forte croissance de la demande concernant les compétences en cybersécurité. En 2024, plus de deux tiers des professionnel·le·s européens déclaraient un environnement de menaces "plus stressant que jamais" et 61 % signalaient un sous-effectif dans leurs équipes @santiniEuropeanOutlookISACA.

Le rapport mondial ISC2 2024 confirme cette augmentation : 67 % des organisations estiment ne pas disposer du nombre ou des compétences nécessaires pour atteindre les objectifs de sécurité @2024ISC2Cybersecurity.

Selon l’étude de Fortinet 2024, 58 % des incidents majeurs seraient directement liés à un manque de savoir-faire technique ou de formation du personnel @fortinet2024CybersecuritySkills2024.

Face à ce manque, il est essentiel de former rapidement les jeunes mais aussi le grand public. La recherche montre l'efficacité des approches plus ludiques pour des apprentissages. Une revue conclue que les serious games sont un moyen efficace pour sensibiliser les utilisateur·trice·s dépourvu·e·s de bagage technique @ngCybersecuritySeriousGames2025.
Les serious games sont une méthode reconnue pour permettre d'engager, de motiver et de favoriser cet apprentissage. Des travaux de recherche montrent qu’ils permettent de découvrir beaucoup de techniques et de notions (cryptographie, réseau, scripts, attaque Web) tout en offrant un environnement sans risque. L’utilisateur·trice peut expérimenter et apprendre de ses erreurs @hillComparingSeriousGames2020. C'est là que le pôle Y-Security de la HEIG-VD intervient et décide de se pencher sur les serious games pour sensibiliser et former le grand public à la cybersécurité.

== Contexte <contexte>

Depuis plus de vingt ans, la HEIG-VD est un acteur majeur en cybersécurité en Suisse romande et en Europe. Le pôle Y-Security de la HEIG-VD est reconnu pour sa recherche appliquée, sa formation et son accompagnement dans le domaine de la sécurité informatique. Il regroupe une douzaine d'expert·e·s et un réseau industriel suisse et européen, ce qui en fait un véritable "écosystème" pour la formation et l'innovation en Suisse romande @YSecurityHEIGVD.

Pour rendre plus accessible la pratique du hacking éthique, le pôle a donc créé une plateforme "CyberGame" et décide de se pencher sur les serious game. L'objectif de ces serious games est de sensibiliser et former les utilisateur·trice·s aux bases de la cybersécurité, en leur permettant de découvrir les techniques d'ethical hacking grâce à une approche narrative immersive. Ces jeux sont destinés à un large public, allant des débutant·e·s aux personnes ayant déjà des connaissances en sécurité informatique.
Il propose actuellement deux scénarios en ligne sur cette thématique @InitiationAuEthical:
- "Shana a disparu" (2020) : une enquête qui vise à retrouver Shana et qui initie les débutant·e·s aux bases du piratage éthique.
- "Sauve la Terre de l'arme galactique" (2021) : une mission interplanétaire qui a pour objectif se récupérer des plans d'une arme galactique.

"Shana a disparu"  nous raconte l'histoire d'une jeune femme qui a disparu et dont il faut retrouver la trace. Le joueur·euse doit résoudre des énigmes et des défis techniques pour progresser dans l'histoire et découvrir ce qui est arrivé à Shana. Le jeu est conçu pour être accessible aux débutant·e·s, tout en offrant des défis intéressants pour les joueur·euse·s plus expérimenté·e·s. L'interface se présente sous la forme d'un site web interactif, où les joueur·euse·s peuvent naviguer entre différentes pages, résoudre des énigmes et interagir avec des éléments du jeu.

#figure(
  image("imgs/shana-interface.png"),
  caption: ["Shana a disparu" - Interface du jeu @ShanaDisparuRetrouvela],
)<shana-interface>

La @shana-interface permet de voir la plateforme "CyberGame" et la construction de l'interface pour le joueur·euse. L'utilisateur·trice peut naviguer d'un défi à l'autre grâce à la barre de navigation en haut de la page. Chaque challenge est présenté à travers une page dédiée avec une description du défi, des indices ainsi qu'un bouton afin de démarrer le challenge. Une fois le défi lancé, il peut explorer le site web, inspecter les éléments, analyser le code source, ... 
Une fois le défi résolu, il devra remplir le champ `Valider l'étape !` avec la réponse correcte pour passer à l'étape suivante. 

Pour aider le joueur·euse, dans la pop-up de description du défi, il y a un bouton `Indice` qui permet d'afficher un indice pour l'aider à résoudre le défi. De plus, sur le site web, nous retrouvons aussi une boîte à outils.
#figure(
  image("imgs/tools-imgs.png"),
  caption: [Boite à outils @InformationsOutilsMethodes],
)<tools-imgs>

Cette @tools-imgs permet de mettre en évidence la boîte à outils présente sur le site web. Elle aide les joueur·euse·s à trouver les outils nécessaires pour résoudre les défis. Par exemple, un outil pour inspecter le code source, un autre pour analyser les requêtes HTTP, ou comment écrire un petit script en Python.

En ce qui concerne le second scénario, "Sauve la Terre de l'arme galactique", il s'agit d'une mission interplanétaire où le joueur·euse doit récupérer des plans d'une arme galactique. Il reprend les mêmes bases que le premier scénario, comme le montre la @galac-interface, avec la même interface et les mêmes mécaniques de jeu. Cependant, il est moins populaire que le premier scénario, car il ne propose pas de nouveaux défis techniques et reste dans la même idée que le premier scénario.
#figure(
  image("imgs/galac-interface.png"),
  caption: ["Sauve la Terre de l'arme galactique" - Interface du jeu @SauveTerreLarme],
)<galac-interface>

Grâce à leur narration immersive et leurs défis, ces jeux, en particulier "Shana a disparu" ont rencontré un grand succès auprès du public. Cependant, la majorité des participant·e·s les ont déjà terminés.

== Problématique <problématique>

Le succès de "Shana a disparu" a atteint ses limites, beaucoup de personnes ont actuellement terminé ce jeu, et la plupart des joueur·euse·s maîtrisent déjà certaines bases, d'autant plus que le jeu "Sauve la Terre de l'arme galactique", reprend les mêmes bases que le premier scénario. Afin de pousser les utilisateur·trice·s à continuer à pratiquer et approfondir ces sujets, il est essentiel d'élargir et de réaliser des challenges plus complexes. De plus, le monde du travail demande des profils capables de gérer des menaces plus sophistiquées. La plateforme doit donc évoluer afin de proposer une nouvelle histoire immersive plus difficile tout en maintenant la motivation et en introduisant des nouveaux défis plus techniques de niveau intermédiaire à avancé.

La question est donc : #quote("Comment créer une nouvelle histoire immersive et prenante qui mêle les techniques d’ethical hacking, afin de sensibiliser et former les utilisateur·trice·s de tous les niveaux ?")

L'objectif de ce travail de Bachelor est de répondre à cette question en développant un nouveau scénario pour la plateforme "CyberGame". Ce scénario doit être accessible aux débutant·e·s tout en proposant des défis plus complexes pour les utilisateur·trice·s plus expérimenté·e·s. Il doit également intégrer des éléments narratifs immersifs pour maintenir l'intérêt et la motivation des joueur·euse·s.
