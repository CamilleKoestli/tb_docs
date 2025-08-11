== Challenge 4 : _Clé cachée dans les commentaires_  <challenge-4>

Ce défi vise à sensibiliser les participant·e·s à l'importance de la sécurité des fichiers et à la nécessité d'analyser les métadonnées des fichiers pour détecter d'éventuelles failles de sécurité. De plus, il met en évidence l'importance de la cryptographie et de la gestion des mots de passe.

Le participant·e obtient le message suivant pour débuter le challenge :

"_Vous avez réussi à accéder à l'archive `patient_audit_1207.zip`. En l'analysant, vous remarquez qu'elle contient des fichiers de sauvegarde, qui pourraient être utiles pour votre enquête. Cependant, le dossier est protégé par un mot de passe. Essayez d'analyser le fichier pour découvrir des informations pour trouver le mot de passe qui vous permettra de l'extraire. Les experts Blue Team ont remarqué que la structure des mots de passe des pirates suit un schéma particulier : `*horizon<nombre>*`._"

Voici les éléments à sa disposition pour l'aider :

- Indice 1 : "_Utilise `zipinfo` ou un explorateur de fichiers pour lire les métadonnées._"
- Indice 2 : "_Le commentaire qui contient le mot de passe est une empreinte SHA-1._"
- Indice 3 : "_Le mot de passe est de la forme `horizon<nombre>` (0 à 99), compare l'empreinte SHA-1 avec les mots de passe potentiels grâce à un petit script Python ou bien un outil comme CyberChef._"

