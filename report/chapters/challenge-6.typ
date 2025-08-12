== Challenge 6 : _Cookie Rançon_ <challenge-6>

L'objectif de ce challenge est de piéger un bot automatisé des attaquants pour récupérer un cookie de session administrateur. Le participant·e doit injecter un script malveillant dans un formulaire de demande de rançon, ce qui lui permettra d'intercepter le cookie de session administrateur et d'utiliser ses droits pour supprimer tous les fichiers chiffrés. Il permet de sensibiliser l'utilisateur·trice aux risques liés à la sécurité des applications web, en particulier sur la manipulation des cookies.

Pour ce défi, le participant·e voit ce message :

"_Les identifiants que vous avez récupérés vous donnent accès à la console interne des pirates… mais pas aux fonctions critiques. Le bouton "Delete All" reste grisé, seuls les administrateurs peuvent l’utiliser. Les attaquants ont mis en place un bot automatisé qui visite chaque nouvelle demande de rançon laissée sur le portail. Si vous parvenez à injecter un script malveillant dans ce formulaire, vous pourrez piéger le bot, intercepter son cookie de session administrateur, puis l’utiliser pour usurper ses droits et supprimer tous les fichiers chiffrés. Une fois les fichiers supprimer, *un message de confirmation* devrait apparaître pour le confirmer_"

Les indices suivants sont disponibles pour aider le participant·e :

- Indice 1 : "_Les champs du formulaire ne filtrent pas correctement le code HTML, les balises HTML ne sont pas échappées, vous pouvez exécuter du JavaScript._"
- Indice 2 : "_Le bot ouvre toutes les demandes, il exécutera donc votre script lors de sa lecture._"
- Indice 3 : "_Le cookie `admin` permet d’activer le bouton "Delete All"._"