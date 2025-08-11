== Challenge 3 : _Partage Oublié_  <challenge-3>

Pour ce défi, le but est d'exploiter une faille de contrôle d'accès pour accéder à des fichiers sensibles. L'objectif de ce challenge est de sensibiliser les participant·e·s aux risques liés aux partages de fichiers mal configurés. L'absence de filtrage des entrées permet à un attaquant de manipuler les requêtes et d'accéder à des données sensibles sans avoir les autorisations nécessaires.

Le joueur·euse reçoit le message suivant pour introduire le challenge :

"_Vous avez réussi à pénétrer dans le portail des attaquants. En l'explorant, vous trouvez un lien vers un "Dépôt sécurisé". Une faille de contrôle d’accès vous permettrait peut-être de parcourir l’arborescence et d’accéder à des archives confidentielles. Modifiez l’URL du dépôt pour accéder à la racine, explorez les dossiers pour essayer d'accéder à des fichiers sensibles. *Un fichier zip* devrait apparaître dans le dossier._"

Le joueur·euse dispose des éléments suivants pour l'aider :

- Indice 1 : "_Le paramètre `dir=` dans l’URL permet de contrôler l’emplacement affiché._"
- Indice 2 : "_Cherche un dossier archives, puis descends dans les sous-dossiers par année et mois._"
- Indice 3 : "_Le fichier visé porte un nom en fonction de la date (01 = janvier, 02 = février, etc.)._"