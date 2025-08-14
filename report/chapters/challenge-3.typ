== Challenge 3 _Partage Oublié_ : Mauvaise configuration d’accès <ch-3>

=== _Partage Oublié_ 
Sur le portail, un lien "Dépôt sécurisé" mène à `https://files.horizonsante-support.com/?dir=/`. À cause d’un contrôle d’accès mal configuré (absence de filtre sur le chemin), n’importe quel·le utilisateur·trice en "lecture seule" peut parcourir l’arbre et récupérer des documents confidentiels.\
Ce challenge permet de montrer au joueur·euse l’importance de la sécurisation des accès aux ressources sensibles et de la validation des paramètres d’URL. Il sensibilise aux risques liés à une mauvaise configuration des droits d’accès et à l’absence de filtrage sur les chemins, qui peuvent permettre à un attaquant de parcourir l’arborescence et d’accéder à des fichiers confidentiels sans autorisation.

Le joueur·euse reçoit le message suivant pour introduire le challenge :
"_Vous avez réussi à pénétrer dans le portail des attaquants. En l'explorant, vous trouvez un lien vers un "Dépôt sécurisé". Une faille de contrôle d’accès vous permettrait peut-être de parcourir l’arborescence et d’accéder à des archives confidentielles. Modifiez l’URL du dépôt pour accéder à la racine, explorez les dossiers pour essayer d'accéder à des fichiers sensibles. *Un fichier zip* devrait apparaître dans le dossier._"

*Étapes pour résoudre le challenge :*
+ Depuis le portail frauduleux, ouvrir l’onglet Ressources, puis "Dépôt sécurisé".
+ Modifier l’URL pour lister la racine (`/?dir=/`).
+ Descendre jusqu’à `/archives/audit/2025/` et télécharger `patient_audit_1207.zip`.

*Outils nécessaires* : Les outils pour ce challenge sont un navigateur ou un outil de requête (curl).

*Indices graduels* :
- Le premier indice permet de montrer au joueur·euse que l'URL contient un paramètre `dir=` et qu'il faut essayer d'aller à la racine. "_Le paramètre `dir=` dans l’URL permet de contrôler l’emplacement affiché._"
- Le deuxième indice suggère d’explorer les sous-dossiers à la racine, en particulier ceux qui ressemblent à des archives ou des sauvegardes. Il faut chercher un dossier nommé `archives` puis descendre dans les sous-dossiers par année et mois pour trouver le fichier d’audit. "_Cherche un dossier archives, puis descends dans les sous-dossiers par année et mois._"
- Le troisième indice précise que le fichier ZIP d’audit est daté de juillet, ce qui correspond au nom `patient_audit_1207.zip`. Il faut donc chercher dans les sous-dossiers de l’année 2025, puis dans le dossier du mois 07 (juillet), pour trouver le fichier à télécharger. "_Le fichier visé porte un nom en fonction de la date de l'attaque (01 = janvier, 02 = février, etc.)._"

*Flag attendu* : Le flag `patient_audit_1207.zip` est un fichier zip qui contient potentiellement tous les dossiers sur les patients ainsi que d'autres éléments.

Ce zip fera l'objet du prochain challenge.
