== Challenge 6 _Cookie Rançon_ : Mauvaise gestion des sessions <ch-6>

Le joueur·euse doit intercepter le cookie de session "admin" utilisé par un bot qui consulte automatiquement chaque demande de rançon. Pour cela, il doit exploiter une faille XSS afin de voler ce cookie lorsque le bot visite la page. Ensuite, il devra injecter ce cookie dans son propre navigateur pour obtenir les droits administrateur et ainsi accéder à la fonctionnalité de suppression, ce qui lui permettra de supprimer définitivement les fichiers sur le serveur des attaquants.\
Ce challenge montre l'importance de la gestion des sessions et de la sécurité des cookies. Il sensibilise aux risques liés à la manipulation des cookies de session et à la nécessité de sécuriser les sessions utilisateur.

Pour ce défi, le participant·e voit ce message :
"_Les identifiants que vous avez récupérés vous donnent accès à la console interne des pirates… mais pas aux fonctions critiques. Le bouton "Delete All" reste grisé, seuls les administrateurs peuvent l’utiliser. Les attaquants ont mis en place un bot automatisé qui visite chaque nouvelle demande de rançon laissée sur le portail. Si vous parvenez à injecter un script malveillant dans ce formulaire, vous pourrez piéger le bot, intercepter son cookie de session administrateur, puis l’utiliser pour usurper ses droits et supprimer tous les fichiers chiffrés. Une fois les fichiers supprimer, *un message de confirmation* devrait apparaître pour le confirmer_"

*Étapes pour résoudre le challenge :*
+ Tester l'injection XSS dans le champ Message : `<script>alert(1)</script>`.
+ Exfiltrer le cookie de session "admin" en utilisant une injection XSS dans le champ Message du chat : `<script>fetch('/collect?c='+encodeURIComponent(document.cookie))</script>` et attendre que le bot ouvre la demande.
+ Récupérer le cookie volé `admin_session=<COOKIE_VALUE>`
+ Ouvrir les outils de développement du navigateur, aller dans l'onglet Application, puis dans la section Cookies.
+ Coller le cookie volé dans le champ de saisie du cookie de session.
+ Une fois le cookie injecté, recharger la page pour obtenir les droits administrateur et supprimer les fichiers.
+ Le serveur affiche un message de confirmation `ALL_FILES_DELETED` indiquant que tous les fichiers ont été supprimés.

*Outils nécessaires :* Un navigateur web avec les outils de développement pour intercepter et manipuler les cookies, ainsi qu'un éditeur de texte pour écrire le script XSS.

*Indices graduels :*
- Le premier indice expliquer que les balises HTML ne sont pas échappées dans le champ Message, ce qui permet d'injecter du code JavaScript. "_Les champs du formulaire ne filtrent pas correctement le code HTML, les balises HTML ne sont pas échappées, vous pouvez exécuter du JavaScript._"
- Le deuxième indice indique que le bot ouvre automatiquement les demandes de rançon, ce qui signifie que le joueur·euse peut exploiter cette fonctionnalité pour voler le cookie de session. "_Le bot ouvre toutes les demandes, il exécutera donc votre script lors de sa lecture._"
- Le troisième indice rappelle que le cookie de session "admin" est nécessaire pour accéder aux fonctionnalités administratives du portail. Il est donc crucial de le voler pour pouvoir supprimer les fichiers. "_Le cookie `admin` permet d’activer le bouton "Delete All"._"

*Flag attendu* : la réponse du serveur `ALL_FILES_DELETED`, ce qui montre au joueur·euse que tous les fichiers ont été supprimés avec succès. 

Une fois les fichiers supprimés, le joueur·euse peut passer au défi suivant pour bloquer l'attaquant.
