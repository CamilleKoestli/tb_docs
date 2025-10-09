== Challenge 6 _Cookie Admin_ : Mauvaise gestion des sessions <ch-6>

=== Description
Le joueur·euse a découvert l'existence d'une page vulnérable dans le système des attaquants. Cette page contient un chatbot de monitoring que les pirates sont en train de développer pour automatiser leur surveillance, mais qui contient des vulnérabilités selon les informations trouvées dans le script précédent. Ce chatbot possède des privilèges administrateur et le défi consiste à l'exploiter pour voler son cookie de session admin et obtenir les droits de suppression des données volées.\
Ce challenge permet de sensibiliser aux vulnérabilités XSS et à l'importance de la sécurisation des bots automatisés. Il montre comment les systèmes de surveillance en développement peuvent être détournés par des attaquants pour escalader leurs privilèges. Il met également en évidence les risques liés à la sécurité des cookies de session et l'importance de leur protection contre le vol et la manipulation, notamment par l'utilisation d'attributs de sécurité appropriés (HttpOnly, Secure, SameSite).

Pour ce faire, le participant·e reçoit le message suivant :
"_Les commentaires dans le script vous ont révélé l'existence de la page cachée `/admin/monitoring/bot_communication_panel_v2`. Vous y découvrez un chatbot que les attaquants sont en train de développer. Selon les informations trouvées précédemment, ce bot contient des vulnérabilités exploitables. De plus, comme il est conçu pour surveiller l'ensemble du portail, il possède probablement des privilèges administrateur élevés. Exploitez ces failles pour obtenir les droits nécessaires, supprimer définitivement les fichiers volés et obtenir un *message de confirmation*._"

*Étapes pour résoudre le challenge :*
+ Tester l'injection XSS dans le champ Message : `<script>alert(1)</script>`.
+ Exfiltrer le cookie de session "admin" en utilisant une injection XSS dans le champ Message du chat via une payload comme par exemple: \ `<script>fetch('/?cookie='+document.cookie)</script>` \ ou encore `<script>console.log('Cookies admin:', document.cookie);</script>` \ et attendre que le bot ouvre la demande.
+ Récupérer le cookie volé `admin_session=ADM1N_53551ON_TOKEN25`
+ Ouvrir les outils de développement du navigateur, aller dans l'onglet Stockage, puis dans la section Cookies.
+ Coller le cookie volé dans le champ de saisie du cookie de session.
+ Une fois le cookie injecté, le joueur·euse est renvoyé sur la page avec les fichiers sensibles pour les supprimer.
+ Le serveur affiche un message de confirmation `all_files_deleted` indiquant que tous les fichiers ont été supprimés.

*Outils nécessaires :* Un navigateur web avec les outils de développement pour intercepter et manipuler les cookies, ainsi qu'un éditeur de texte pour écrire le script XSS.

*Indices graduels :*
- Le premier indice explique que les balises HTML ne sont pas échappées dans le champ Message, ce qui permet d'injecter du code JavaScript. "_Les champs du formulaire ne filtrent pas correctement le code HTML, les balises HTML ne sont pas échappées, vous pouvez exécuter du JavaScript._"
- Le second indice suggère le type d'attaque à utiliser. "_Injecte du JavaScript malveillant dans un message pour voler les cookies quand le chatbot le traite._"
- Le troisième indice explique la récupération du cookie. "_Une fois le cookie récupéré, utilise F12, Application, puis Cookies pour remplacer ta session par celle du bot admin._"

*Flag attendu* : la réponse du serveur `all_files_deleted`, ce qui montre au joueur·euse que tous les fichiers ont été supprimés avec succès.

Une fois les fichiers supprimés, le joueur·euse a réussi à neutraliser une partie importante de l'attaque en empêchant les cybercriminels d'exploiter les données sensibles des volées des patients. Le joueur·euse peut passer au défi suivant pour bloquer l'attaquant.

=== Techniques et outils

Pour ce challenge, un outil explique les vulnérabilités XSS et comment elles peuvent être exploitées pour voler des cookies de session. Cette section y explique les différents éléments qui vont composer une attaque XSS, comme la notion de fonction, de balises et d'éléments pour accéder au contenu de la page. Elle y inclut aussi un exemple concret d'attaques XSS, afin que le joueur·euse puisse comprendre comment fonctionne cette vulnérabilité, comment elle est structurée et comment elle peut être exploitée pour voler des cookies de session.

De même que le challenge 5, l'outil d'explication des routes, liens, URLs et endpoints a été complété afin d'y inclure des informations supplémentaires et comprendre comment les attaquants peuvent structurer leurs applications web.