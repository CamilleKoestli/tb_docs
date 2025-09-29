= Cahier des charges <cahier-des-charges>
== Contexte <contexte>
_CyberGame_ est une plateforme de serious game développée initialement par le pôle Y-Security de la HEIG-VD. Le pôle Y-Security est reconnu comme un acteur majeur en cybersécurité en Suisse romande. Il a pour mission de former, sensibiliser et accompagner différents publics autour des enjeux de sécurité informatique, grâce à la recherche appliquée, la formation et la mise en place d’outils innovants.

La plateforme _CyberGame_ vise à rendre l’apprentissage de la cybersécurité ludique et accessible à tous, à travers des scénarios interactifs et progressifs. Le jeu « Shana a disparu » est un exemple phare : il propose une initiation au ethical hacking, combinant narration immersive et challenges techniques pour faire découvrir les bases de la cybersécurité.

Ce jeu a rencontré un grand succès auprès d’un large public.

=== Problématique <problématique>
Le succès de "Shana a disparu", créé en 2020, a conduit de nombreuses personnes à le terminer entièrement. Un second scénario, Galac game, a été mis en place en 2021 mais a remporté un plus faible succès.

Le public étant de plus en plus curieux et averti sur ce sujet, il devient nécessaire de développer un nouveau scénario afin de répondre à la demande notamment en proposant une histoire qui techniquement amène le participant à un plus haut niveau de compétences.

L’objectif est donc d’intégrer des défis techniquement plus avancés, tout en conservant l’approche narrative immersive qui fait l’intérêt et l’originalité du "serious game".

Cette nouvelle histoire s’adressera donc à des participant·e·s ayant résolu le premier niveau scénario (Shana) ou ayant quelques connaissances de base en sécurité informatique.

=== Solutions existantes <solutions-existantes>
Il existe aussi d'autres solutions similaires dans le domaine de l'ethical hacking, mais plutôt sous la forme de Capture The Flag (CTF) comme "Root Me", "Hack the Box", "TryHackMe", ...; des cyber-ranges qui sont plutôt destinés à des expert·e·s en cybersécurité ; ou encore des formations en ligne comme "SoSafe" qui proposent des cours et des exercices pratiques sur la cybersécurité sans forcément intégrer d'histoire narrative et immersive.

Ces solutions montrent une augmentation de l'intérêt général pour la cybersécurité. Elles utilisent des approches ludiques mais peu combinent une narration et une progression techniques comme le fait "Shana a disparu".

=== Approches possibles <solutions-possibles>
Pour proposer une nouvelle expérience qui s'adresse à tout le monde tout en permettant de sensibiliser mais aussi de rester ludique, plusieurs options peuvent être envisagées :
- La première option serait de développer une extension directe du scénario existant avec de nouveaux challenges plus techniques.
- Alors que la deuxième serait de créer un nouveau jeu totalement indépendant avec un nouveau scénario, tout en restant dans la même idée que le jeu précédent.

L'option choisie est de créer un nouveau scénario qui s'adresse à tout le monde. Ce scénario doit être accessible aux débutant·e·s tout en proposant des défis plus complexes pour les utilisateur·trice·s plus expérimenté·e·s. Il doit également intégrer des éléments narratifs immersifs pour maintenir l'intérêt et la motivation des joueur·euse·s.

=== Objectifs <objectifs>
Le cahier des charges va permettre d’encadrer la conception d’un scénario immersif dans le domaine de la cybersécurité. L’objectif sera de produire une nouvelle expérience ludique tout en intégrant une approche de sensibilisation.

- Concevoir un nouveau scénario :
  - Créer une histoire captivante, qui peut être une suite de Shana ou une intrigue totalement nouvelle.
  - Proposer des niveaux plus complexes que les scénarios existants.
  - Inclure 5 à 10 challenges de difficultés progressives.
  - Imaginer les épreuves en réfléchissant au côté sensibilisation et notamment aux messages que le participant·e en tirera.
  - Introduire les nouveaux concepts techniques et pédagogiques correspondants.
- Thématiques techniques :
  - Couvrir plusieurs aspects de la cybersécurité comme l'exploitation web, escalade de privilèges, reverse engineering, forensic, etc.
  - Intégrer un robot interactif pour simuler le comportement d’utilisateur·trice·s vulnérables (ex. clics sur une XSS).
  - Intégrer tous les challenges dans une narration immersive et cohérente, fidèle à l’esprit du projet.
- Développer le nouveau serious game :
  - Il doit être intégré dans la plateforme _CyberGame_ existante, tant sur la forme, que sur le contenu des technologies utilisées.
  - Inclure le scénario complet, les étapes du jeu, les mécaniques interactives, ainsi que les apports techniques et pédagogiques nécessaires.
  - Gérer les parties backend nécessaires.
  - Garantir la sécurité de l’infrastructure et du contenu.
- Réaliser des tests utilisateur·trice·s et appliquer les correctifs nécessaires pour assurer une expérience optimale.

=== Livrables <livrables>
Les livrables seront les suivants :
- Plateforme _CyberGame_ mise à jour, incluant l’ensemble du nouveau scénario opérationnel.
- Un rapport complet, comprenant :
  - Des propositions de scénarios, avec motivation du scénario retenu.
  - La documentation détaillée du scénario retenu, incluant la liste complète des challenges.
  - La documentation de la plateforme _CyberGame_, incluant la description de l’existant et des évolutions apportées, ainsi que l’explication et justification des choix techniques.
  - Une analyse de la sécurité de la plateforme.
  - Les tests fonctionnels réalisés.
  - Les tests utilisateur·trice·s réalisés : méthodologie, résultats, retours collectés, et correctifs appliqués.

=== Planification <planification>
Le travail se déroule entre le 7 juillet et le 10 octobre 2025, pour un total de 450h :
- Du 7 juillet au 15 septembre : travail à temps plein (~45h/semaine).
- Du 16 septembre au 10 octobre : travail à temps partiel (~12–13h/semaine).
Le rendu intermédiaire est prévu pour la date du 31 juillet 2025, le rendu final est fixé au 10 octobre 2025, enfin, la défense devra être fixée après le 13 février 2026.


