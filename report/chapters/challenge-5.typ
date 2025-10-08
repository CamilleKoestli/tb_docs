== Challenge 5 _Script Mystère_ : Reverse Engineering <ch-5>

=== Description
Dans l'archive déchiffrée (`patient_audit_07-12.zip`) se trouve `monitor_check_wip.py`. Les pirates y ont dissimulé des informations cruciales sur les vulnérabilités de leur propre système de monitoring, mais les ont cachées par une simple concaténation de caractères encodés. Le but est de reconstituer ces informations pour découvrir où se trouve une faille exploitable dans leur infrastructure.\
Ce challenge permet de sensibiliser à l'importance de la sécurité des scripts et de la nécessité de vérifier les scripts avant de les exécuter. Il montre également comment les attaquants peuvent laisser des traces compromettantes dans leurs propres outils.

Pour ce faire, le participant·e reçoit le message suivant :
"_L'archive est maintenant accessible et contient effectivement toutes les données sensibles des patients. Il faut les supprimer d'urgence, mais vous ne disposez que de droits utilisateurs. En fouillant l'archive, vous tombez sur un script Python suspect (`monitor_check_wip.py`). Analysez-le attentivement : les attaquants y ont peut-être laissé des informations exploitables, notamment une *route* vers une page vulnérable._"

*Étapes pour résoudre le challenge :*
+ Ouvrir le fichier `monitor_check_wip.py` dans l'IDE.
+ Identifier les lignes qui contiennent des chaînes de caractères encodées en Base64.
+ Décoder les chaînes Base64 pour obtenir le login et le mot de passe.
+ Reconstituer l'URL de la page vulnérable en concaténant les fragments décodés dans le bon ordre.

*Outils nécessaires :* Pour ce challenge les outils nécessaires sont un éditeur de texte/IDE pour lire le script, un outil de décodage Base64 (comme CyberChef ou un script Python).

*Indices graduels :*
- Le premier indice rappelle que le script contient des chaînes de caractères encodées en Base64, ce qui signifie qu'il faut les décoder pour obtenir les informations cachées. "_Regarde les chaînes longues terminant par `=` ou `==`, elles devraient te faire penser à un décodage.._"
- Le second indice suggère d'utiliser un outil de décodage Base64 pour faciliter le processus. Il est également suggéré de vérifier les commentaires du script, car ils peuvent contenir des indices sur la manière dont les chaînes sont concaténées. "_Utilise CyberChef ou un petit script Python pour le décodage en Base64._"
- Le troisième indice indique que les chaînes sont concaténées, ce qui signifie qu'il faut les assembler pour obtenir le login et le mot de passe complets. "_Les morceaux décodés doivent être assemblés pour obtenir des informations intéressantes. Attention aux leurres._"


*Flag attendu :* Le flag attendu correspond à l'URL de la page vulnérable reconstituée : `/admin/monitoring/bot_communication_panel_v2`

Une fois cette page découverte, le joueur·euse pourra s'y rendre pour exploiter la vulnérabilité du bot de monitoring des attaquants et escalader ses privilèges vers les droits administrateur.

=== Techniques et outils
Pour analyser les données encodées dans le script, j'ai ajouté un outil expliquant le Base64 et son fonctionnement. J'y explique d'abord ce qu'est le Base64, pourquoi il est utilisé, pour encoder des données binaires en texte lisible, et comment il fonctionne. J'ai inclus des exemples concrets de chaînes encodées et décodées pour illustrer le processus. Un autre point important est d'expliquer comment identifier une chaîne encodée en Base64, en soulignant les caractéristiques typiques comme la présence de caractères spécifiques et les terminaisons par `=` ou `==`.

J'ai ensuite expliqué les différences entre les routes, les liens, les URLs et les endpoints. En effet, pour ce challenge le joueur·euse doit comprendre la différence entre ces notions pour reconstituer correctement l'URL de la page vulnérable. J'ai donné des exemples faciles pour chaque concept, comme un lien HTML dans un navigateur, une route côté serveur (par exemple avec Express/Node), une route côté front (comme dans une SPA avec React Router), et un endpoint d'API en précisant la méthode HTTP utilisée. J'ai aussi abordé les notions de chemins absolus vs relatifs, ainsi que les paramètres et les queries dans les URLs.

Pareil que pour le challenge 4, j'ai complété les informations déjà présentes sur Python. 

