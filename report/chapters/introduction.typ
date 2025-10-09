= Introduction <introduction>

== Sensibilisation à la sécurité informatique <sensibilisation-sécurité>
La digitalisation expose, chaque jour, les utilisateur·trice·s aux menaces informatiques. 79% des Européen·ne·s estiment que l'amélioration de la cybersécurité est indispensable @europeancommission.directorategeneralforcommunicationsnetworkscontentandtechnology.DigitalDecade2024, pourtant 52 % ne se sentent pas capables de se protéger suffisamment @wahlEurobarometerEuropeansAttitudes2020. Le phishing représente 36 % des failles de sécurité, avec plus de 3,4 milliards de courriels frauduleux envoyés quotidiennement @spysPhishingStatistics20252025. Les attaques deviennent de plus en plus complexes, les ransomwares ont augmenté de 57,5 % entre novembre 2024 et février 2025 @knowbe4PhishingThreatTrends2025, et les cybercriminels utilisent désormais l'IA pour personnaliser leurs attaques.

De plus, le monde professionnel fait face à une pénurie critique de compétences. En 2024, 67 % des organisations estimaient ne pas disposer des compétences nécessaires pour atteindre leurs objectifs de sécurité @2024ISC2Cybersecurity, et 58 % des incidents majeurs étaient directement liés à un manque de formation @fortinet2024CybersecuritySkills2024.

Face à ces défis, les serious games émergent comme une solution prometteuse. La recherche démontre leur efficacité pour sensibiliser même les personnes sans bagage technique @ngCybersecuritySeriousGames2025. Ces jeux permettent d'apprendre la cryptographie, les réseaux, les scripts et les attaques web dans un environnement sans risque, où expérimenter et faire des erreurs deviennent nécessaire pour un apprentissage @hillComparingSeriousGames2020.

== Enjeu des compétences en cybersécurité <compétences-cybersécurité>

Le secteur fait face à une pénurie importante, plusieurs enquêtes annuelles estiment qu'environ 4,8 millions de professionnels manquent à l'échelle mondiale @2024ISC2Cybersecurity. De plus, 64 % des experts dans le domaine considèrent que le manque de compétences impacte davantage les organisations qu'un simple manque d'effectifs. Cette lacune se traduit directement en incidents avec environ 70 % des failles graves de cybersécurité qui sont dues à des erreurs humaines @fortinetFortinet2024Cybersecurity2024. La formation devient donc une stratégie à considérer, pour les professionnels et pour sensibiliser le grand public aux bonnes pratiques.

== Contexte <contexte>

C'est dans ce contexte que le pôle Y-Security de la HEIG-VD, acteur majeur de la cybersécurité en Suisse romande et en Europe depuis plus de vingt ans @YSecurityHEIGVD, a créé la plateforme _CyberGame_. Son objectif est de rendre accessible au grand public le hacking éthique à travers des serious games narratifs et immersifs. Deux scénarios sont actuellement disponibles @InitiationAuEthical :
- "Shana a disparu" (2020) : une enquête qui initie aux bases du piratage éthique
- "Sauve la Terre de l'arme galactique !" (2021) : une mission interplanétaire qui reprend les mêmes concepts

"Shana a disparu" a rencontré un grand succès. À travers une interface web interactive, les joueur·euse·s résolvent des énigmes techniques pour retrouver la trace d'une jeune femme disparue. Chaque défi est présenté avec des indices progressifs et une boîte à outils pédagogique pour guider l'apprentissage.

#figure(
  image("imgs/shana-interface.png"),
  caption: ["Shana a disparu" - Interface du jeu @ShanaDisparuRetrouvela],
)<shana-interface>

La @shana-interface montre l'interface de navigation. Les joueur·euse·s explorent un site web interactif, inspectent le code source et valident leurs réponses pour progresser dans l'histoire.

#figure(box(stroke: 0.5pt, image("imgs/tools-imgs.png", width: 70%)), caption: [Boite à outils @InformationsOutilsMethodes])<tools-imgs>

La @tools-imgs présente la boîte à outils intégrée qui est composée de guides d'inspection du code, d'analyse des requêtes HTTP, de scripting Python, etc.

#figure(
  image("imgs/galac-interface.png"),
  caption: ["Sauve la Terre de l'arme galactique !" - Interface du jeu @SauveTerreLarme],
)<galac-interface>

Le second scénario (@galac-interface) reprend la même mécanique, mais reste moins populaire du au manque de nouveaux défis techniques et surtout à un manque de réalisme. 


== Problématique <problématique>

La plateforme _CyberGame_ doit relever plusieurs défis : celui de maintenir l'engagement des utilisateur·trice·s qui ont terminé les scénarios existants, et celui de répondre à la demande croissante du marché pour des compétences techniques plus avancées. Pour continuer à sensibiliser efficacement à la cybersécurité, il est crucial d'offrir de nouveaux défis plus complexes qui approfondissent les techniques d'ethical hacking, tout en préservant l'accessibilité et l'immersion narrative qui ont fait le succès de "Shana a disparu".

La question centrale est donc : #quote("Comment créer une nouvelle histoire immersive et prenante qui intègre plusieurs techniques d'ethical hacking, afin de sensibiliser et former les utilisateur·trice·s de tous les niveaux ? ")

== Motivations et objectifs du projet <motivations>

Le projet vise à développer un nouveau scénario pour la plateforme _CyberGame_ qui réponde à plusieurs objectifs clés.

=== Découvrir et démystifier l'ethical hacking
L'image du "pirate informatique" reste souvent associée à des activités illégales et malveillantes. Ce projet vise à faire découvrir l'ethical hacking au grand public et à démystifier la démarche d'un·e professionnel·le de la sécurité. En mettant les joueur·euse·s dans la peau d'un·e hacker éthique, le scénario permet de comprendre les techniques utilisées dans le but de protéger et non de nuire.

=== Sensibiliser aux dangers et transmettre les bonnes pratiques
À travers son approche immersive, le jeu vise à sensibiliser les gens aux dangers du numérique. Grâce à l'exploitation de vulnérabilités dans un environnement contrôlé, les joueur·euse·s découvrent, de manière implicite, certaines techniques de protection qu'ils peuvent appliquer dans leur vie.

=== Promouvoir la HEIG-VD et son pôle Y-Security
Ce serious game constitue également une sorte de publicité pour la HEIG-VD et son pôle Y-Security. Le projet contribue à faire connaître les formations dans le domaine de la cybersécurité. Il montre aussi l'engagement de la HEIG-VD dans la sensibilisation et la formation.

=== Orienter les jeunes vers la cybersécurité
Enfin, ce projet offre aux jeunes une opportunité de tester et de découvrir la cybersécurité sans avoir forcément beaucoup de connaissances préalables. Le jeu aide les futur·e·s étudiant·e·s à les orienter vers cet avenir professionnel grâce au côté ludique du serious game.

L'objectif global est donc de développer un nouveau scénario pour _CyberGame_ qui intègre des défis de niveau intermédiaire tout en restant accessible aux débutant·e·s, le tout dans une narration captivante. Ce serious game doit sensibiliser le grand public aux enjeux de sécurité informatique tout en étant dans une optique de formation, d'apprentissage et en répondant aussi à ces motivations.

== Solutions existantes <solutions-existantes>
Il existe aussi d'autres solutions similaires dans le domaine de l'ethical hacking, mais plutôt sous la forme de Capture The Flag (CTF) comme "Root Me", "Hack the Box", "TryHackMe", ...; des cyber-ranges qui sont plutôt destinés à des expert·e·s en cybersécurité ; ou encore des formations en ligne comme "SoSafe" qui proposent des cours et des exercices pratiques sur la cybersécurité sans forcément intégrer d'histoire narrative et immersive.

Ces solutions montrent une augmentation de l'intérêt général pour la cybersécurité. Elles utilisent des approches ludiques mais peu combinent une narration et une progression techniques comme le fait "Shana a disparu".

== Approches possibles <solutions-possibles>
Pour proposer une nouvelle expérience qui s'adresse à tout le monde tout en permettant de sensibiliser mais aussi de rester ludique, plusieurs options peuvent être envisagées :
- La première option serait de développer une extension directe du scénario existant avec de nouveaux challenges plus techniques.
- Alors que la deuxième serait de créer un nouveau jeu totalement indépendant avec un nouveau scénario, tout en restant dans le même mode de fonctionnement que le jeu précédent.

L'option choisie est de créer un nouveau scénario qui s'adresse à tout le monde. Ce scénario doit être accessible aux débutant·e·s tout en proposant des défis plus complexes pour les utilisateur·trice·s plus expérimenté·e·s. Il doit également intégrer des éléments narratifs immersifs pour maintenir l'intérêt et la motivation des joueur·euse·s.
