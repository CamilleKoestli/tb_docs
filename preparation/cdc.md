# Cahier des charges

## Contexte

_CyberGame_ est une plateforme de serious game développée initialement par le pôle Y-Security de la HEIG-VD.
Le pôle Y-Security est reconnu comme un acteur majeur de la cybersécurité en Suisse romande. Il a pour mission de former, sensibiliser et accompagner différents publics autour des enjeux de sécurité informatique, grâce à la recherche appliquée, la formation et la mise en place d’outils innovants.

La plateforme _CyberGame_ vise à rendre l’apprentissage de la cybersécurité ludique et accessible à tou·te·s, à travers des scénarios interactifs et progressifs.
Le jeu "Shana a disparu" est un exemple phare : il propose une initiation au ethical hacking, combinant narration immersive et challenges techniques pour faire découvrir les bases de la cybersécurité.

Le jeu a eu un grand succès, ce qui fait que de nombreuses personnes l’ont déjà terminé. Ce projet vise donc à développer une extension du scénario existant ou à créer un tout autre scénario. Le but est d’intégrer de nouveaux défis de niveau plus avancé, tout en gardant cette idée d’approche narrative immersive qui a fait l’intérêt du projet.

Cette nouvelle histoire s’adressera donc à des participant·e·s ayant quelques connaissances de base en sécurité informatique.

### Problématique

Le succès de "Shana a disparu" , créé en 2020, a conduit de nombreuses personnes à le terminer entièrement. Un second scénario, "Galac game", a été mis en place en 2021 mais a remporté un succès plus faible.

Le public étant de plus en plus curieux et averti sur ce sujet, il devient nécessaire de développer un nouveau scénario afin de répondre à la demande, notamment en proposant une histoire qui, techniquement, amène le participant·e à un plus haut niveau de compétences.

L’objectif est donc d’intégrer des défis techniquement plus avancés, tout en conservant l’approche narrative immersive qui fait l’intérêt et l’originalité du "serious game".

Cette nouvelle histoire s’adressera donc à des participant·e·s ayant résolu le premier niveau scénario (Shana) ou ayant quelques connaissances de base en sécurité informatique.

Comment créer une nouvelle histoire immersive et prenante qui intègre plusieurs techniques d’ethical hacking, afin de sensibiliser et former les utilisateur·trice·s de tous les niveaux ?

### Solutions existantes

A ce jour, seul le projet "Shana a disparu" a été développé par la HEIG-VD qui a pour objectif d'initier et de sensibiliser à la cybersécurité grâce à des énigmes progressives intégrées dans une narration interactive et qui a connu un certain succès. Un autre scénario "Sauve la Terre de l'arme galactique", avec des challenges plutôt similaires, a été mis en place en 2021 mais a remporté beaucoup moins de succès. Ce projet s'appuie sur des techniques de base comme l'inspection de sites web, l'analyse de métadonnées, ...

Il existe aussi d'autres solutions similaires dans le domaine de l'ethical hacking, mais plutôt sous la forme de Capture The Flag (CTF) comme "Root Me", "Hack the Box", "TryHackMe", ...; des cyber-ranges qui sont plutôt destinés à des expert·e·s en cybersécurité ; ou encore des formations en ligne comme "SoSafe" qui proposent des cours et des exercices pratiques sur la cybersécurité sans forcément intégrer d'histoire narrative et immersive.

Ces solutions montrent une augmentation de l'intérêt général pour la cybersécurité. Elles utilisent des approches ludiques mais peu combinent une narration et une progression techniques comme le fait "Shana a disparu".

### Solutions possibles

Pour proposer une nouvelle expérience qui s'adresse à tout le monde tout en permettant de sensibiliser mais aussi de rester ludique, plusieurs options peuvent être envisagées :

- La première option serait de développer une extension directe du scénario existant avec de nouveaux challenges plus techniques.
- Alors que la deuxième serait de créer un nouveau jeu totalement indépendant avec un nouveau scénario, tout en restant dans la même idée que le jeu précédent.

L'option choisie est de créer un nouveau scénario qui s'adresse à tout le monde. Ce scénario doit être accessible aux débutant·e·s tout en proposant des défis plus complexes pour les utilisateur·trice·s plus expérimenté·e·s. Il doit également intégrer des éléments narratifs immersifs pour maintenir l'intérêt et la motivation des joueur·euse·s.

### Objectifs

Le cahier des charges va permettre d’encadrer la conception d’un scénario immersif dans le domaine de la cybersécurité. L’objectif sera de produire une nouvelle expérience ludique tout en intégrant une approche de sensibilisation.

- Concevoir un nouveau scénario :
  - Créer une histoire captivante, qui peut être une suite de Shana ou une intrigue totalement nouvelle.
  - Proposer des niveaux plus complexes que les scénarios existants.
  - Inclure 5 à 10 challenges de difficultés progressives.
  - Imaginer les épreuves en réfléchissant au côté sensibilisation et notamment aux messages que le participant·e en tirera
  - Introduire les nouveaux concepts techniques et pédagogiques correspondants
- Thématiques techniques :
  - Couvrir plusieurs aspects de la cybersécurité comme l'exploitation web, escalade de privilèges, reverse engineering, forensic, etc.
  - Si nécessaire, intégrer un robot interactif pour simuler le comportement d’utilisateur·trice·s vulnérables (ex. clics sur une XSS).
  - Intégrer tous les challenges dans une narration immersive et cohérente, fidèle à l’esprit du projet.
- Développer le nouveau serious game :
  - Il doit être intégré dans la plateforme _CyberGame_ existante, tant sur la forme, que sur le contenu des technologies utilisées.
  - Inclure le scénario complet, les étapes du jeu, les mécaniques interactives, ainsi que les apports techniques et pédagogiques nécessaires.
  - Gérer les parties backend nécessaires.
  - Garantir la sécurité de l’infrastructure et du contenu.
- Réaliser des tests utilisateur·trice·s et appliquer les correctifs nécessaires pour assurer une expérience optimale.

### Livrables

Les livrables seront les suivants :

- Plateforme _CyberGame_ mise à jour, incluant l’ensemble du nouveau scénario opérationnel.
- Un rapport complet, comprenant :
  - Des propositions de scénarios, avec motivation du scénario retenu.
  - La documentation détaillée du scénario retenu, incluant la liste complète des challenges.
  - La documentation de la plateforme _CyberGame_, incluant la description de l’existant et des évolutions apportées, ainsi que l’explication et justification des choix techniques.
  - Une analyse de la sécurité de la plateforme.
  - Les tests fonctionnels réalisés.
  - Les tests utilisateur·trice·s réalisés : méthodologie, résultats, retours collectés, et correctifs appliqués.

### Planification

Le travail se déroule entre le 7 juillet et le 8 octobre 2025, pour un total de 450h :

- Du 7 juillet au 15 septembre : travail à temps plein (~45h/semaine)
- Du 16 septembre au 8 octobre : travail à temps partiel (~12–13h/semaine)

Le rendu intermédiaire est prévu pour la date du 31 juillet 2025, le rendu final est fixé au 8 octobre 2025, enfin, la défense devra être fixée après le 13 février 2026.

### Décomposition des tâches

1. Analyse du scénario existant : _07.07.2025 – 09.07.2025_
    - Étudier les mécaniques de jeu et les défis utilisés dans "Shana a disparu".
    - Identifier les technologies utilisées et les types de challenges (web, forensic, …).
    - Évaluer les points positifs et les points à améliorer du scénario actuel.
    - Étudier l’architecture de la plateforme _CyberGame_.
2. Recherche et écriture du scénario : _10.07.2025 – 23.07.2025_
    - S’inspirer de CTF, serious games et projets similaires pour la structure et le contenu des défis.
    - Identifier les outils et environnements de développement.
    - Identifier les bonnes méthodes pédagogiques adaptées à la sensibilisation à la cybersécurité à travers un jeu interactif.
    - Élaborer plusieurs scénarios, puis détailler celui qui a été retenu.
3. Conception et développement des challenges : _24.08.2025 – 03.09.2025_
    - Définir les thématiques techniques abordées et les attaques à réaliser (XSS, reverse engineering, stéganographie, ...).
    - Concevoir entre 5 et 10 challenges.
    - Développer les services ou environnements nécessaires.
    - Ajouter un bot interactif pour simuler certaines interactions ou attaques.
    - S’assurer de la clarté des consignes et de la logique de chaque challenge.
4. Intégration dans la plateforme _CyberGame_ : _04.09.2025 – 09.09.2025_
    - Adapter les contenus au format de _CyberGame_.
5. Tests et validation : _10.09.2025 – 19.09.2025_
    - Réaliser des tests unitaires pour chaque challenge.
    - Réaliser des tests utilisateur·trice·s et faire tester les défis par d’autres personnes pour ajuster la difficulté.
    - Corriger les éventuels bugs ou incohérences.
6. Documentation technique et pédagogique :  _20.09.2025 – 08.10.2025_
    - Documenter chaque challenge : objectif, compétences visées, indices, solutions, pièges courants.
    - Rédiger la documentation du scénario.
    - Décrire les choix techniques et les modifications apportées à la plateforme.
    - Documenter les tests.
