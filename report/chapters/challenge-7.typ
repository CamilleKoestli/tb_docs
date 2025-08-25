== Challenge 7 _Blocage ciblé_ : Défense et journalisation <ch-7>

Maintenant que les fichiers sont supprimés du côté des attaquants, le joueur·euse doit identifier l’adresse IP de la machine de l’attaquant pour le bloquer. Le joueur·euse doit donc s'assurer qu'aucune connexion sortante ne continue d'envoyer des données. Un flux a été repéré : la même adresse IP externe a émis des milliers de requêtes vers le portail VPN de l’hôpital au cours du dernier quart d’heure (tentative d’exfiltration massive). Le joueur·euse doit donc trouver le fichier de log contenant ces requêtes, identifier l’IP la plus présente (c’est l’attaquant) et ajouter cette IP à la liste noire du pare-feu interne. Une fois l’IP bloquée, le joueur·euse recevra un message de confirmation `blk_185-225-123-77_ok` indiquant que le blocage a été effectué avec succès.\
Ce challenge montre l'importance de la surveillance des logs et de la gestion des adresses IP suspectes pour prévenir les attaques.

Le message suivant s'affiche :
"_Le bot des pirates a été piégé et les fichiers sensibles ont été supprimés. Cependant un attaquant continue de tenter d’exfiltrer des données via le VPN. Il faut l’identifier et le bloquer immédiatement en l'ajoutant dans le pare-feu. Une fois dans la liste noire du pare-feu, *un message* devrait vous le confirmer._"

*Étapes pour résoudre le challenge :*
+ Depuis le portail IT interne `https://intra.horizonsante.com/it/`	, aller dans le menu de gauche "Outils SOC".
+ Cliquer sur "Logs & Diagnostics", puis sur "VPN Access" , ce qui fait apparaître une liste de fichiers.
+ Ouvrir le fichier log le plus récent `vpn_access_2025-07-17.log` dans un éditeur de texte. Chaque ligne commence par l’IP source.
+ Repérer l’adresse IP qui apparaît le plus souvent `185.225.123.77`	qui est donc la machine de l’attaquant.
+ Dans le menu de gauche, cliquer sur "Pare-feu", puis sur "Liste noire".
+ Dans un formulaire, entrer l’adresse IP `185.225.123.77`.
+ Le système affiche un bandeau vert avec le message `blk_185-225-123-77_ok`.

*Outils nécessaires* : Les outils nécessaire pour résoudre ce challenge sont un navigateur web et un éditeur de texte pour lire le fichier log.

*Indices graduels :*
- Le premier indice rappelle que le menu "Logs & Diagnostics" contient tous les journaux, cherche celui qui mentionne "VPN Access". "_Le menu "Logs & Diagnostics" contient les journaux VPN, c'est ici que vous pourrez trouver des informations sur les connexions en cours._"
- Le deuxième indice indique que dans le fichier, chaque entrée commence par l’IP source. Cela signifie qu'il faut chercher les lignes qui commencent par une adresse IP. "_Les IPs apparaissent au début de chaque ligne du fichier log._"
- Le troisième indice suggère de bloquer l’IP trouvée dans le pare-feu. "_Bloquez l’IP trouvée via le formulaire de la "Liste noire"._"

*Flag attendu :* Le flag attendu est le message `blk_185-225-123-77_ok` qui confirme que l’adresse IP de l’attaquant a été bloquée avec succès. Cela permet de sécuriser le réseau et d'empêcher toute nouvelle tentative d'exfiltration de données.
