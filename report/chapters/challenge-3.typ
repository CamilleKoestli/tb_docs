== Challenge 3 _Partage Oublié_ : Mauvaise configuration d’accès <ch-3>

=== Description
Sur le portail, un onglet "Gestion des fichiers" mène à `?dir=/shared/`. À cause d'une faille de contrôle d'accès au niveau fichiers (absence de validation sur le paramètre de chemin), n'importe quel·le utilisateur·trice connecté·e peut modifier le paramètre d'URL pour parcourir l'arborescence complète et accéder à des documents confidentiels dans d'autres répertoires\.
Ce challenge permet de montrer au joueur·euse l'importance de la validation des paramètres d'URL et du contrôle d'accès aux ressources sensibles. Il sensibilise aux vulnérabilités de type Directory Traversal qui permettent à un attaquant de contourner les restrictions d'accès aux fichiers en manipulant les paramètres de chemin, sans réaliser d'escalade de privilèges.

Le joueur·euse reçoit le message suivant pour introduire le challenge :
"_Vous avez réussi à pénétrer dans le portail des attaquants. En explorant le site, vous découvrez une section de gestion des fichiers. Vous constatez que l'accès semble restreint et ne montre qu'une partie du système de fichiers. Il pourrait y avoir des failles de sécurité à exploiter pour accéder à davantage de données sensibles. Explorez le système pour trouver *l'archive zip* contenant des informations sur les patients les plus récentes._"

*Étapes pour résoudre le challenge :*
+ Depuis le portail frauduleux, cliquer sur l'onglet "Gestion des fichiers". L'URL contient `?dir=/shared/` et ne montre qu'un dossier limité
+ Modifier l'URL pour aller à la racine (`?dir=/`) et découvrir tous les dossiers disponibles.
+ Explorer les différents dossiers visibles : `public/`, `shared/` et `archives/`
+ Naviguer dans le dossier `archives/` puis dans les sous-dossiers par année (`2025/`) et mois (`audit/`) pour trouver le fichier zip des patients.

*Outils nécessaires* : Les outils pour ce challenge sont un navigateur ou un outil de requête (curl).

*Indices graduels* :
- Le premier indice permet de montrer au joueur·euse que l'URL contient un paramètre `dir=` et qu'il faut essayer d'aller à la racine. "_Le paramètre `dir=` dans l’URL permet de contrôler l’emplacement affiché._"
- Le deuxième indice suggère au joueur d'essayer d'aller à la racine "_Essaie d'aller à la racine avec `?dir=/` puis explore les dossiers disponibles._"
- Le troisième indice précise que le fichier ZIP d’audit est daté de juillet, ce qui correspond au nom `patient_audit_07-12.zip`. Il faut donc chercher dans les sous-dossiers de l’année 2025, puis dans le dossier du mois 07 (juillet), pour trouver le fichier à télécharger. "_Le fichier visé porte un nom en fonction de la date de l'attaque (jour-mois)._"

*Flag attendu* : Le flag `patient_audit_07-12.zip` est un fichier zip qui contient potentiellement tous les dossiers sur les patients ainsi que d'autres éléments.

Ce zip fera l'objet du prochain challenge.

=== Tools
Pour le challenge 3, un outil qui explique ce qu’est l’architecture des dossiers en informatique a été créé. L’idée était de donner aux joueur·euse·s une vision claire de la manière dont les fichiers et dossiers sont organisés, afin qu’ils puissent comprendre la logique de navigation dans un système de fichiers.

J’y explique d’abord la hiérarchie classique selon les différents systèmes d'exploitation avec un dossier racine qui contient d’autres dossiers et fichiers, et la possibilité d’avoir des sous-dossiers imbriqués.

Enfin, j’ai expliqué le concept de chemin (par exemple /documents/rapport.docx), qui permet d’indiquer précisément l’emplacement d’un fichier. Cette explication prépare les joueur·euse·s à manipuler et analyser les chemins de fichiers dans le cadre du challenge, afin de retrouver où sont cachées les informations utiles.