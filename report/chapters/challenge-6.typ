== Challenge 6 _Cookie Admin_ : Mauvaise gestion des sessions <ch-6>

=== Description
Le joueur·euse a découvert l'existence d'une page vulnérable dans le système des attaquants. Cette page contient un chatbot de monitoring que les pirates sont en train de développer pour automatiser leur surveillance, mais qui contient des vulnérabilités selon les informations trouvées dans le script précédent. Ce chatbot possède des privilèges administrateur et le défi consiste à l'exploiter pour voler son cookie de session admin et obtenir les droits de suppression des données volées.\
Ce challenge permet de sensibiliser aux vulnérabilités XSS et à l'importance de la sécurisation des bots automatisés. Il montre comment les systèmes de surveillance en développement peuvent être détournés par des attaquants pour escalader leurs privilèges. Il met également en évidence les risques liés à la sécurité des cookies de session et l'importance de leur protection contre le vol et la manipulation, notamment par l'utilisation d'attributs de sécurité appropriés (HttpOnly, Secure, SameSite).

Pour ce faire, le participant·e reçoit le message suivant :
"_Grâce aux informations trouvées dans le script, vous avez découvert l'existence de la page `/admin/monitoring/bot_communication_panel_v2`. En vous rendant sur cette page, vous constatez qu'elle contient un chatbot que les attaquants sont en train de développer. Selon les commentaires trouvés dans le script précédent, ce chatbot contient des vulnérabilités exploitables. Le bot possède des privilèges administrateur pour pouvoir accéder à toutes les sections du portail. Vous devez exploiter ces vulnérabilités pour obtenir les droits nécessaires. Récupère les cookies et modifie les pour obtenir des droits supplémentaires. Une fois les droits obtenus, vous serez redirigé vers la page de suppression des fichiers volés, supprimés les et *un message de confirmation* apparaîtra._"

*Étapes pour résoudre le challenge :*
+ Tester l'injection XSS dans le champ Message : `<script>alert(1)</script>`.
+ Exfiltrer le cookie de session "admin" en utilisant une injection XSS dans le champ Message du chat via une payload comme par exemple: `<script>fetch('/?cookie='+document.cookie)</script>` ou encore `<script>console.log('Cookies admin:', document.cookie);</script>` et attendre que le bot ouvre la demande.
+ Récupérer le cookie volé `admin_session=ADM1N_53551ON_TOKEN25`
+ Ouvrir les outils de développement du navigateur, aller dans l'onglet Stockage, puis dans la section Cookies.
+ Coller le cookie volé dans le champ de saisie du cookie de session.
+ Une fois le cookie injecté, le joueur·euse est renvoyé sur la page avec les fichiers sensibles pour les supprimer.
+ Le serveur affiche un message de confirmation `all_files_deleted` indiquant que tous les fichiers ont été supprimés.

*Outils nécessaires :* Un navigateur web avec les outils de développement pour intercepter et manipuler les cookies, ainsi qu'un éditeur de texte pour écrire le script XSS.

*Indices graduels :*
- Le premier indice expliquer que les balises HTML ne sont pas échappées dans le champ Message, ce qui permet d'injecter du code JavaScript. "_Les champs du formulaire ne filtrent pas correctement le code HTML, les balises HTML ne sont pas échappées, vous pouvez exécuter du JavaScript._"
- Le second indice suggère le type d'attaque à utiliser. "_Injecte du JavaScript malveillant dans un message pour voler les cookies quand le chatbot le traite._"
- Le troisième indice explique la récupération du cookie. "_Une fois le cookie récupéré, utilise F12, Application, puis Cookies pour remplacer ta session par celle du bot admin._"

*Flag attendu* : la réponse du serveur `all_files_deleted`, ce qui montre au joueur·euse que tous les fichiers ont été supprimés avec succès.

Une fois les fichiers supprimés, le joueur·euse a réussi à neutraliser une partie importante de l'attaque en empêchant les cybercriminels d'exploiter les données sensibles des patients volées. Le joueur·euse peut passer au défi suivant pour bloquer l'attaquant.

=== Tools
//TODO

Qu'est-ce que l'injection XSS ?
Quelques fonctions utiles en JavaScript
Balises souvent utilisées dans des exemples XSS
Exemples de déclencheurs d’événements
Accéder au contenu de la page (DOM)
Exemple complet d’injection XSS
Explications en vidéo !

Ajout d'informations sur les routes les liens les urls et endpoints
C’est quoi la différence ?
Exemples rapides
  Lien HTML (navigateur)
  Route côté serveur (Express / Node)
  Route côté front (ex. SPA React Router)
  Endpoint d’API (quelle méthode ?)
Chemins : absolus vs relatifs
Paramètres & query