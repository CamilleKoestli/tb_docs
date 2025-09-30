= État de l'art <etatdelart>

Ce chapitre analyse les approches existantes de formation en cybersécurité — des cyber-ranges professionnels aux CTF techniques — pour identifier le positionnement unique des serious games narratifs comme _CyberGame_. Il établit le contexte académique et industriel qui justifie le développement d'un nouveau scénario accessible mais techniquement approfondi.

== Enjeu des compétences en cybersécurité <compétences-cybersécurité>

Le secteur fait face à une pénurie critique : 4,8 millions de professionnels manquent à l'échelle mondiale @2024ISC2Cybersecurity. Plus préoccupant encore, 64 % des experts considèrent que le déficit de compétences impacte davantage les organisations qu'un simple manque d'effectifs. Cette lacune se traduit directement en incidents : 70 % des failles graves de cybersécurité résultent d'erreurs humaines @fortinetFortinet2024Cybersecurity2024. La formation devient donc un levier stratégique, tant pour les professionnels que pour sensibiliser le grand public aux bonnes pratiques.

== Panorama des approches de formation <écosystèmes-existants>

L'écosystème de formation en cybersécurité se structure autour de quatre grandes catégories d'outils, chacune répondant à des besoins et publics différents : les cyber-ranges pour l'entraînement professionnel avancé, les plateformes CTF (Hack The Box @HackBox1, TryHackMe @TryHackMeSimpleCTF, RootMe @RootMePlateforme) pour la pratique technique, les outils de sensibilisation en entreprise, et les serious games narratifs. Comprendre leurs forces et limites permet de positionner _CyberGame_ dans ce paysage.

=== Cyber-ranges académiques et industriels <cyber-ranges>
Les cyber-ranges (@cyber-range-imgs) sont des environnements simulés utilisés par les institutions et entreprises pour l'entraînement professionnel avancé @WhatCyberRange. Ils reproduisent des infrastructures réalistes où les équipes Blue Team testent leurs défenses, identifient des vulnérabilités et pratiquent la réponse à incident dans un environnement sans risque @QuestceQuunCyber2024.

#figure(image("imgs/cyber-range.png"), caption: [Schéma d'un cyber-range @WhatCyberRange])<cyber-range-imgs>

*Limite* : Ces plateformes ciblent exclusivement des professionnel·le·s expérimenté·e·s et restent inaccessibles au grand public, tant par leur complexité que par leur coût. Elles ne répondent pas à l'objectif de sensibilisation large visé par _CyberGame_.


=== Plateformes CTF (Capture The Flag) <plateformes-ctf>
Les CTF proposent des défis techniques isolés — cryptographie, exploitation de vulnérabilités, forensics — organisés par catégorie (@rootme-challenge-imgs). Utilisées en compétition ou comme ressources pédagogiques, ces plateformes (Hack The Box, TryHackMe, RootMe) permettent aux participant·e·s de capturer des "flags" cachés dans des systèmes vulnérables @CTFHackingGuide.

#figure(image("imgs/rootme-challenge.png"), caption: [Page des challenges de RootMe @RootMePlateforme])<rootme-challenge-imgs>

*Limite* : L'approche segmentée et technique exige des prérequis solides et ne favorise pas la progression narrative. L'absence de fil conducteur immersif rend ces plateformes moins adaptées à la sensibilisation d'un public débutant ou non-technique.

=== Outils de sensibilisation en entreprise <outils-sensibilisation>
Les formations en ligne, ateliers pratiques et simulations d'attaques (ex. SoSafe @SensibilisationCybersecuriteGestion2022) visent à sensibiliser les collaborateur·trice·s aux menaces courantes — phishing, ingénierie sociale, gestion des mots de passe.

*Limite* : Souvent théoriques et peu immersifs, ces outils proposent un apprentissage passif. Leur accès payant et leur ciblage corporate restreignent leur portée au grand public. Ils manquent de l'engagement actif et de la dimension ludique qui caractérisent les serious games.

=== Serious games narratifs en cybersécurité <serious-games>
Les serious games utilisent la mécanique ludique pour enseigner des concepts complexes. Définis par _Zyda_ comme #quote("un concours intellectuel, joué sur ordinateur selon des règles spécifiques, qui utilise le divertissement pour atteindre des objectifs de formation, d'éducation, de santé, de politique publique ou de communication stratégique") @zydaVisualSimulationVirtual2005 (p.26, citation traduite), ils combinent engagement actif, narration immersive et apprentissage par l'expérimentation — permettant aux joueur·euse·s de prendre des décisions et d'observer leurs conséquences dans un environnement sécurisé.

*Potentiel et lacunes* : Bien qu'efficaces pour la sensibilisation, la majorité des serious games en cybersécurité ciblent des utilisateur·trice·s avancé·e·s et privilégient les aspects techniques (piratage, architectures réseau) au détriment des dimensions humaines @ngCybersecuritySeriousGames2025. De plus, la plupart sont anglophones et payants (UrbanGaming @SeriousGameSecurite, Shirudo @ShirudoSeriousGame, Cyber Wargame @CyberWargameSerious), limitant leur accessibilité au grand public francophone.

*Positionnement de CyberGame* : La plateforme Y-Security se distingue en proposant des scénarios gratuits, en français, combinant accessibilité pour les débutant·e·s et progression technique. Le défi est désormais d'élargir l'offre avec un nouveau scénario plus avancé, tout en préservant la narration immersive qui a fait le succès de "Shana a disparu".
