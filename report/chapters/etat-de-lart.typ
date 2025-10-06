= État de l'art <etatdelart>

Ce chapitre a pour objectif d'analyser les approches existantes de formation en cybersécurité pour identifier la place que pourraient avoir les serious games narratifs comme _CyberGame_. 

== Différentes classes de plateformes existantes <écosystèmes-existants>

Actuellement, les différents outils de formations en cybersécurité se structurent autour de différentes catégories d'outils, chacune répondant à des besoins et publics différents : 
- Les cyber-ranges pour réaliser un entraînement professionnel.
- Les plateformes CTF (Hack The Box @HackBox1, TryHackMe @TryHackMeSimpleCTF, RootMe @RootMePlateforme) pour faire de la pratique.
- Les outils de sensibilisation en entreprise.
- Les cours, formations avec des exercices pratiques ou des laboratoires.
- Les serious games narratifs pour sensibiliser et former à la cybersécurité.
Il est important de comprendre leurs forces et limites afin d'avoir un premier aperçu de l'intérêt des serious games.

=== Cyber-ranges académiques et industriels <cyber-ranges>
Les cyber-ranges (@cyber-range-imgs) sont des environnements simulés utilisés par les institutions et entreprises pour l'entraînement professionnel avancé @WhatCyberRange. Ils reproduisent des infrastructures réalistes où les équipes Blue Team testent leurs défenses, identifient des vulnérabilités et protègent le système dans un environnement sans risque @QuestceQuunCyber2024.

#figure(image("imgs/cyber-range.png"), caption: [Schéma d'un cyber-range @WhatCyberRange])<cyber-range-imgs>

Les limites de ces plateformes sont qu'elles ciblent exclusivement des professionnel·le·s expérimenté·e·s et restent inaccessibles au grand public, du à leur complexité et à leur coût. Elles ne répondent pas à l'objectif de sensibilisation large visé par _CyberGame_.


=== Plateformes CTF (Capture The Flag) <plateformes-ctf>
Les CTF proposent des défis techniques isolés organisés par catégorie (@rootme-challenge-imgs). Ils sont utilisées lors de compétitions ou comme ressources pédagogiques, ces plateformes (Hack The Box, TryHackMe, RootMe) permettent aux participant·e·s de capturer des "flags" cachés dans des systèmes vulnérables @CTFHackingGuide.

#figure(image("imgs/rootme-challenge.png"), caption: [Page des challenges de RootMe @RootMePlateforme])<rootme-challenge-imgs>

Le problème de ce genre de dispositif est qu'il s'agit d'une approche très technique et segmentée, où chaque défi est indépendant et ne s'inscrit pas dans une progression narrative. De plus, les participant·e·s doivent souvent avoir une base technique solide pour aborder les défis, ce qui peut décourager les débutant·e·s.

=== Outils de sensibilisation en entreprise <outils-sensibilisation>
Les formations en ligne, ateliers pratiques et simulations d'attaques (ex. SoSafe @SensibilisationCybersecuriteGestion2022) visent à sensibiliser les collaborateur·trice·s aux menaces courantes, comme le phishing, ingénierie sociale, gestion des mots de passe, ...

Souvent théoriques et peu immersifs, ces outils proposent un apprentissage avec peu de pratique. Leur accès payant et leur ciblage corporate restreignent leur portée au grand public. Ils manquent la dimension ludique qui caractérisent les serious games.

=== Serious games narratifs en cybersécurité <serious-games>
Les serious games utilisent la mécanique ludique pour enseigner des concepts complexes. Définis par _Zyda_ comme #quote("un concours intellectuel, joué sur ordinateur selon des règles spécifiques, qui utilise le divertissement pour atteindre des objectifs de formation, d'éducation, de santé, de politique publique ou de communication stratégique") @zydaVisualSimulationVirtual2005 (p.26, citation traduite), ils combinent engagement actif, narration immersive et apprentissage par l'expérimentation — permettant aux joueur·euse·s de prendre des décisions et d'observer leurs conséquences dans un environnement sécurisé.

Bien qu'efficaces pour la sensibilisation, la majorité des serious games en cybersécurité ciblent des utilisateur·trice·s avancé·e·s et privilégient les aspects techniques (piratage, architectures réseau) au détriment des dimensions humaines @ngCybersecuritySeriousGames2025. De plus, la plupart sont anglophones et payants (UrbanGaming @SeriousGameSecurite, Shirudo @ShirudoSeriousGame, Cyber Wargame @CyberWargameSerious), ce qui limite leur accessibilité au grand public.

== Plateforme _CyberGame_ <place-cybergame>
La plateforme _Cybergame_ proposé par le groupe Y-Security se distingue en proposant des scénarios gratuits, en français, combinant accessibilité pour les débutant·e·s et progression technique. Le défi est désormais d'élargir l'offre avec un nouveau scénario plus avancé, tout en préservant la narration immersive qui a fait le succès de "Shana a disparu".
