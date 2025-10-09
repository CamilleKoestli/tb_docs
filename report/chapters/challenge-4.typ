== Challenge 4 _Clé cachée_ : Cryptographie et métadonnées <ch-4>

=== Description
Le joueur·euse a maintenant accès à l'archive `patient_audit_07-12.zip` mais le problème est qu'il est verrouillé. Le joueur·euse doit trouver le mot de passe pour déverrouiller ce zip. En inspectant les métadonnées du ZIP, le joueur·euse découvre un commentaire contenant seulement une empreinte SHA-1 : `f7fde1c3f044a2c3002e63e1b6c3f432b43936d0`.\
Première solution: utiliser un site comme CrackStation pour trouver le mot de passe correspondant à cette empreinte SHA-1.\
Deuxième solution : réussir à faire un code python qui va hasher toutes les variations de horizon<nombre> pour trouver celle qui correspond à l'empreinte SHA-1.\
Ce challenge montre l'importance de la cryptographie et de la gestion des mots de passe, ainsi que la nécessité de vérifier les métadonnées des fichiers.

Le participant·e obtient le message suivant pour débuter le challenge :
"_Vous avez découvert l'archive *patient_audit_07-12.zip*, mais elle est protégée par un mot de passe. Analysez le fichier pour trouver des indices qui vous permettront de le déverrouiller. Le mot de passe recherché commence par *`horizon<nombre>`*._"

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

===  Techniques et outils
Dans un premier temps, il est important de comprendre le fonctionnement et l'utilisation de zipinfo, afin d'obtenir des informations détaillées sur le contenu d’une archive ZIP. J’ai détaillé son utilisation pour permettre aux joueur·euse·s d'analyser une archive pour identifier des éléments dissimulés. Certaines options sont nécessaires afin de trouver  des métadonnées cachées comme les commentaires.

Le second outil présente la notion de hash et son fonctionnement. J'explique comment les hashes sont générés et utilisés pour la sécurité des mots de passe. Un exemple concret en Python pour montrer comment générer différents types de hashes (MD5, SHA-1, SHA-256) est également inclus. Cet outil est utile car, dans le challenge, les joueur·euse·s font face à un mot de passe protégé par un hash. Il est donc important de comprendre ce concept pour leur permettre de savoir comment l’aborder, soit en le comparant à une base de données de hashes connus, soit en essayant de casser le hash à l'aide d'un script.

Enfin, les informations déjà présentes sur Python ont été complétées. En effet, la plateforme présentait une autre forme de Python, plus simplifiée. Cependant, il ne m'était pas possible de l'utiliser  pour le challenge 4 et 5, car il n'était pas possible d'importer des bibliothèques externes. J'ai donc complété les sections déjà présentes avec la syntaxe de ce langage.