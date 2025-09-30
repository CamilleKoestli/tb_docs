= Introduction <introduction>

== Sensibilisation à la sécurité informatique <sensibilisation-sécurité>
La digitalisation expose chaque jour davantage les utilisateur·trice·s aux cybermenaces. En Europe, 79 % estiment que l'amélioration de la cybersécurité est indispensable @europeancommission.directorategeneralforcommunicationsnetworkscontentandtechnology.DigitalDecade2024, pourtant 52 % ne se sentent pas capables de se protéger suffisamment @wahlEurobarometerEuropeansAttitudes2020. Le phishing représente aujourd'hui 36 % des failles de sécurité, avec plus de 3,4 milliards de courriels frauduleux envoyés quotidiennement @spysPhishingStatistics20252025. Les attaques se sophistiquent : les ransomwares ont bondi de 57,5 % entre novembre 2024 et février 2025 @knowbe4PhishingThreatTrends2025, et les cybercriminels exploitent désormais l'IA pour personnaliser leurs attaques.

Parallèlement, le monde professionnel fait face à une pénurie critique de compétences. En 2024, 67 % des organisations estiment ne pas disposer des compétences nécessaires pour atteindre leurs objectifs de sécurité @2024ISC2Cybersecurity, et 58 % des incidents majeurs sont directement liés à un manque de formation @fortinet2024CybersecuritySkills2024.

Face à ce double défi — vulnérabilité des utilisateur·trice·s et manque de compétences — les serious games émergent comme une solution prometteuse. La recherche démontre leur efficacité pour sensibiliser même les personnes sans bagage technique @ngCybersecuritySeriousGames2025. Ces jeux permettent d'apprendre la cryptographie, les réseaux, les scripts et les attaques web dans un environnement sans risque, où l'expérimentation et l'erreur deviennent des leviers d'apprentissage @hillComparingSeriousGames2020.

== Contexte <contexte>

C'est dans ce contexte que le pôle Y-Security de la HEIG-VD, acteur majeur de la cybersécurité en Suisse romande depuis plus de vingt ans @YSecurityHEIGVD, a créé la plateforme _CyberGame_. Son objectif : démocratiser le hacking éthique à travers des serious games narratifs et immersifs. Deux scénarios sont actuellement disponibles @InitiationAuEthical :
- "Shana a disparu" (2020) : une enquête initiant aux bases du piratage éthique
- "Sauve la Terre de l'arme galactique !" (2021) : une mission interplanétaire reprenant les mêmes concepts

"Shana a disparu" a rencontré un franc succès. À travers une interface web interactive, les joueur·euse·s résolvent des énigmes techniques pour retrouver la trace d'une jeune femme disparue. Chaque défi est présenté avec des indices progressifs et une boîte à outils pédagogique pour guider l'apprentissage.

#figure(
  image("imgs/shana-interface.png"),
  caption: ["Shana a disparu" - Interface du jeu @ShanaDisparuRetrouvela],
)<shana-interface>

La @shana-interface montre l'interface de navigation et de résolution des défis. Les joueur·euse·s explorent un site web interactif, inspectent le code source et valident leurs réponses pour progresser dans l'histoire.

#figure(image("imgs/tools-imgs.png"), caption: [Boite à outils @InformationsOutilsMethodes])<tools-imgs>

La @tools-imgs présente la boîte à outils intégrée : guides d'inspection du code, d'analyse des requêtes HTTP, de scripting Python, etc.

#figure(
  image("imgs/galac-interface.png"),
  caption: ["Sauve la Terre de l'arme galactique !" - Interface du jeu @SauveTerreLarme],
)<galac-interface>

Le second scénario (@galac-interface) reprend la même mécanique, mais reste moins populaire faute de nouveaux défis techniques. Le succès de "Shana a disparu" a atteint ses limites : la majorité des participant·e·s l'ont terminé et maîtrisent désormais les bases.

== Problématique <problématique>

La plateforme _CyberGame_ doit aujourd'hui relever un double défi : maintenir l'engagement des utilisateur·trice·s ayant terminé les scénarios existants, et répondre à la demande croissante du marché pour des compétences techniques plus avancées. Pour continuer à sensibiliser efficacement à la cybersécurité, il est crucial d'offrir de nouveaux défis plus complexes qui approfondissent les techniques d'ethical hacking, tout en préservant l'accessibilité et l'immersion narrative qui ont fait le succès de "Shana a disparu".

La question centrale est donc : #quote("Comment créer une nouvelle expérience immersive qui élève le niveau technique tout en restant accessible et motivante pour tous les publics ?")

Ce travail de Bachelor vise à développer un nouveau scénario pour _CyberGame_ qui intègre des défis de niveau intermédiaire à avancé — exploitation de vulnérabilités web, cryptographie appliquée, analyse réseau — dans une narration captivante. L'objectif : former la prochaine génération de professionnel·le·s de la cybersécurité tout en sensibilisant le grand public aux enjeux de sécurité informatique.
