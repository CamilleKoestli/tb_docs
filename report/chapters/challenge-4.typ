== Challenge 4 _Clé cachée_ : Cryptographie et métadonnées <ch-4>

=== Description
Le joueur·euse a maintenant accès à l'archive `patient_audit_07-12.zip` mais le problème est qu'il est verrouillé. Le joueur·euse doit trouver le mot de passe pour déverrouiller ce zip. En inspectant les métadonnées du ZIP, le joueur·euse découvre un commentaire contenant seulement une empreinte SHA-1 : `f7fde1c3f044a2c3002e63e1b6c3f432b43936d0`.\
Première solution: utiliser un site comme CrackStation pour trouver le mot de passe correspondant à cette empreinte SHA-1.\
Deuxième solution : Les experts Blue Team ont remarqué que les pirates utilisent toujours un mot de passe de la forme : `horizon<nombre>` où `<nombre>` varie de 0 à 99 (par exemple horizon1).\
Ce challenge montre l'importance de la cryptographie et de la gestion des mots de passe, ainsi que la nécessité de vérifier les métadonnées des fichiers.

Le participant·e obtient le message suivant pour débuter le challenge :
"_Vous avez réussi à accéder à l'archive `patient_audit_07-12.zip`. En l'analysant, vous remarquez qu'elle contient des fichiers de sauvegarde, qui pourraient être utiles pour votre enquête. Cependant, le dossier est protégé par un mot de passe. Essayez d'analyser le fichier pour découvrir des informations pour trouver le mot de passe qui vous permettra de l'extraire. Les experts Blue Team ont remarqué que la structure des mots de passe des pirates suit un schéma particulier : `*horizon<nombre>*`._"

*Étapes pour résoudre le challenge :*
+ Lister les métadonnées du zip avec `zipinfo -z patient_audit_07-12.zip` ou sur Windows en utilisant l'explorateur de fichiers.
+ Trouver le commentaire contenant l'empreinte SHA-1
+ Aller sur le site CrackStation ou utiliser un script Python pour générer les mots de passe possibles de la forme `horizon<nombre>` et vérifier si l'un d'eux correspond à l'empreinte SHA-1 ou utiliser CyberChef pour générer les mots de passe et vérifier l'empreinte.
+ Une fois le mot de passe trouvé, déverrouiller le zip.

*Outils nécessaires :* Pour résoudre ce challenge, il faudra un éditeur de texte pour lire les métadonnées, CrackStation ou un script Python ou CyberChef pour générer les mots de passe et vérifier l'empreinte SHA-1.

*Indices graduels :*
- Le premier indice suggère de regarder les métadonnées du zip, car elles peuvent contenir des informations utiles. "_Utilise `zipinfo` ou un explorateur de fichiers pour lire les métadonnées._"
- Le second indice indique que le hash se trouve dans les commentaires et que l'empreinte est un SHA-1, ce qui signifie qu'il faut trouver le mot de passe qui correspond à cette empreinte. "_Grâce à une commande `zipinfo`, regarde les commentaires. Le commentaire qui contient le mot de passe est une empreinte SHA-1._"
- Le troisième indice rappelle que les mots de passe ont une structure spécifique, ce qui peut aider à les générer. Le joueur·euse peut se rendre sur CrackStation pour y entrer le hash ou il peut créer un script Python pour générer les mots de passe de la forme `horizon<nombre>` où `<nombre>` varie de 0 à 99. Il peut ensuite comparer leur empreinte SHA-1 avec celle du commentaire ou utiliser CyberChef pour générer les mots de passe et vérifier l'empreinte. "_Le mot de passe est de la forme `horizon<nombre>` (0 à 99), compare l'empreinte SHA-1 avec les mots de passe potentiels grâce à un petit script Python ou bien un outil comme CyberChef._"

*Flag attendu :* Le flag attendu est le mot de passe du zip, qui est `horizon42`.

Ce mot de passe permet de déverrouiller le zip et d'accéder au contenu du fichier `monitor_check_wip.py`.

===  Tools
//TODO