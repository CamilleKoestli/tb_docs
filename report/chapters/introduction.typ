= Introduction <introduction>

== Sensibilisation à la sécurité informatique <sensibilisation-sécurité>
La digitalisation expose, chaque jour, les utilisateur·trice·s aux menaces informatiques. 79% des Européen·ne·s estiment que l'amélioration de la cybersécurité est indispensable @europeancommission.directorategeneralforcommunicationsnetworkscontentandtechnology.DigitalDecade2024, pourtant 52 % ne se sentent pas capables de se protéger suffisamment @wahlEurobarometerEuropeansAttitudes2020. Le phishing représente 36 % des failles de sécurité, avec plus de 3,4 milliards de courriels frauduleux envoyés quotidiennement @spysPhishingStatistics20252025. Les attaques deviennent de plus en plus complexes, les ransomwares ont augmenté de 57,5 % entre novembre 2024 et février 2025 @knowbe4PhishingThreatTrends2025, et les cybercriminels utilisent désormais l'IA pour personnaliser leurs attaques.

De plus, le monde professionnel fait face à une pénurie critique de compétences. En 2024, 67 % des organisations estiment ne pas disposer des compétences nécessaires pour atteindre leurs objectifs de sécurité @2024ISC2Cybersecurity, et 58 % des incidents majeurs sont directement liés à un manque de formation @fortinet2024CybersecuritySkills2024.

Face à ces défis, les serious games émergent comme une solution prometteuse. La recherche démontre leur efficacité pour sensibiliser même les personnes sans bagage technique @ngCybersecuritySeriousGames2025. Ces jeux permettent d'apprendre la cryptographie, les réseaux, les scripts et les attaques web dans un environnement sans risque, où expérimenter et faire des erreurs deviennent nécessaire pour un apprentissage @hillComparingSeriousGames2020.

== Contexte <contexte>

C'est dans ce contexte que le pôle Y-Security de la HEIG-VD, acteur majeur de la cybersécurité en Suisse romande et en Europe depuis plus de vingt ans @YSecurityHEIGVD, a créé la plateforme _CyberGame_. Son objectif est de rendre accessible le hacking éthique à travers des serious games narratifs et immersifs. Deux scénarios sont actuellement disponibles @InitiationAuEthical :
- "Shana a disparu" (2020) : une enquête qui initie aux bases du piratage éthique
- "Sauve la Terre de l'arme galactique !" (2021) : une mission interplanétaire qui reprend les mêmes concepts

"Shana a disparu" a rencontré un grand succès. À travers une interface web interactive, les joueur·euse·s résolvent des énigmes techniques pour retrouver la trace d'une jeune femme disparue. Chaque défi est présenté avec des indices progressifs et une boîte à outils pédagogique pour guider l'apprentissage.

#figure(
  image("imgs/shana-interface.png"),
  caption: ["Shana a disparu" - Interface du jeu @ShanaDisparuRetrouvela],
)<shana-interface>

La @shana-interface montre l'interface de navigation. Les joueur·euse·s explorent un site web interactif, inspectent le code source et valident leurs réponses pour progresser dans l'histoire.

#figure(image("imgs/tools-imgs.png"), caption: [Boite à outils @InformationsOutilsMethodes])<tools-imgs>

La @tools-imgs présente la boîte à outils intégrée qui est composée de guides d'inspection du code, d'analyse des requêtes HTTP, de scripting Python, etc.

#figure(
  image("imgs/galac-interface.png"),
  caption: ["Sauve la Terre de l'arme galactique !" - Interface du jeu @SauveTerreLarme],
)<galac-interface>

Le second scénario (@galac-interface) reprend la même mécanique, mais reste moins populaire du au manque de nouveaux défis techniques. 

== Problématique <problématique>

La plateforme _CyberGame_ doit relever plusieurs défis : celui de maintenir l'engagement des utilisateur·trice·s qui ont terminé les scénarios existants, et celui de répondre à la demande croissante du marché pour des compétences techniques plus avancées. Pour continuer à sensibiliser efficacement à la cybersécurité, il est crucial d'offrir de nouveaux défis plus complexes qui approfondissent les techniques d'ethical hacking, tout en préservant l'accessibilité et l'immersion narrative qui ont fait le succès de "Shana a disparu".

La question centrale est donc : #quote("Comment créer une nouvelle histoire immersive et prenante qui intègre plusieurs techniques d’ethical hacking, afin de sensibiliser et former les utilisateur·trice·s de tous les niveaux ? ")

Ce travail de Bachelor vise à développer un nouveau scénario pour _CyberGame_ qui intègre des défis de niveau intermédiaire mais qui est aussi accessible aux débutant·e·s dans une narration captivante. L'objectif est de sensibiliser le grand public aux enjeux de sécurité informatique tout en étant dans une optique de formation et d'apprentissage.
