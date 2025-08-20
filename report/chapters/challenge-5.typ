== Challenge 5 _Script Mystère_ : Reverse Engineering <ch-5>
Dans l'archive déchiffrée (`patient_audit_07-12.zip`) se trouve `monitor_check_wip.py`. Les pirates y ont dissimulé des informations cruciales sur les vulnérabilités de leur propre système de monitoring, mais les ont cachées par une simple concaténation de caractères encodés. Le but est de reconstituer ces informations pour découvrir où se trouve une faille exploitable dans leur infrastructure.\
Ce challenge permet de sensibiliser à l'importance de la sécurité des scripts et de la nécessité de vérifier les scripts avant de les exécuter. Il montre également comment les attaquants peuvent laisser des traces compromettantes dans leurs propres outils.

Pour ce faire, le participant·e reçoit le message suivant :
"_L'archive est maintenant déverrouillée et vous constatez qu'effectivement elle contient bien toutes les informations sensibles concernant les patients. Il faut les supprimer rapidement. Cependant, vous ne disposez que de droits visiteur et ne pouvez pas accéder au bouton de suppression. En explorant l'archive déverrouillée, vous trouvez un script Python suspect (`monitor_check_wip.py`). En analysant ce script, vous découvrez que les pirates y ont laissé des commentaires sur leur propre système de surveillance. Ces informations révèlent l'existence d'*une page vulnérable* que vous pourrez exploiter pour obtenir les droits administrateur._"

*Étapes pour résoudre le challenge :*
+ Ouvrir le fichier `monitor_check_wip.py` dans l'IDE.
+ Identifier les lignes qui contiennent des chaînes de caractères encodées en Base64.
+ Décoder les chaînes Base64 pour obtenir le login et le mot de passe.
+ Reconstituer l'URL de la page vulnérable en concaténant les fragments décodés dans le bon ordre.

*Outils nécessaires :* Pour ce challenge les outils nécessaires sont un éditeur de texte/IDE pour lire le script, un outil de décodage Base64 (comme CyberChef ou un script Python).

*Indices graduels :*
- Le premier indice rappelle que le script contient des chaînes de caractères encodées en Base64, ce qui signifie qu'il faut les décoder pour obtenir les informations cachées. "_Cherche des chaînes longues terminant par `=` ou `==`._"
- Le second indice indique que les chaînes sont concaténées, ce qui signifie qu'il faut les assembler pour obtenir le login et le mot de passe complets. "_Les morceaux décodés doivent être assemblés pour obtenir des informations intéressantes._"
- Le troisième indice suggère d'utiliser un outil de décodage Base64 pour faciliter le processus. Il est également suggéré de vérifier les commentaires du script, car ils peuvent contenir des indices sur la manière dont les chaînes sont concaténées. "_Utilise CyberChef ou un petit script Python pour le décodage en Base64._"

*Flag attendu :* Le flag attendu correspond à l'URL de la page vulnérable reconstituée : `/admin/monitoring/bot_communication_panel_v2`

Une fois cette page découverte, le joueur·euse pourra s'y rendre pour exploiter la vulnérabilité du bot de monitoring des attaquants et escalader ses privilèges vers les droits administrateur.




