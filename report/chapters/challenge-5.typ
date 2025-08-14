== Challenge 5 _Script Mystère_ : Reverse Engineering <ch-5> 

Dans l’archive déchiffrée (`patient_audit_1207.zip`) se trouve `tools/backup_sync.py`.
Les pirates y ont laissé un compte SSH à privilèges "support-user" mais l’ont caché par une simple concaténation de caractères. Le but est de reconstituer le login et le mot de passe clair.\
Ce challenge permet de sensibiliser à l'importance de la sécurité des scripts et de la nécessité de vérifier les scripts avant de les exécuter. Il montre également comment les attaquants peuvent masquer des informations sensibles dans des scripts apparemment innocents.

Pour ce faire, le participant·e reçoit le message suivant :
"_L'archive est maintenant déverrouillée et vous constatez qu'effectivement elle contient bien toutes les informations sensibles concernant les patients. Il faut la supprimer rapidement. Cependant, vous ne disposez pas des droits administrateurs suffisants pour la supprimer. En explorant l’archive déverrouillée, vous trouvez un script Python suspect (`backup_sync.py`). Les pirates y auraient potentiellement caché des identifiants SSH et *un mot de passe* qu'il faudra fournir._"

*Étapes pour résoudre le challenge :*
+ Ouvrir le fichier `backup_sync.py` dans l'IDE.
+ Identifier les lignes qui contiennent des chaînes de caractères encodées en Base64.
+ Décoder les chaînes Base64 pour obtenir le login et le mot de passe.
+ Concaténer les parties pour reconstituer le login et le mot de passe.

*Outils nécessaires :* Pour ce challenge les outils nécessaires sont un éditeur de texte/IDE pour lire le script, un outil de décodage Base64 (comme CyberChef ou un script Python).

*Indices graduels :*
- Le premier indice rappelle que le script contient des chaînes de caractères encodées en Base64, ce qui signifie qu'il faut les décoder pour obtenir les informations cachées. "_Cherche des chaînes longues terminant par `=` ou `==`._"
- Le second indice indique que les chaînes sont concaténées, ce qui signifie qu'il faut les assembler pour obtenir le login et le mot de passe complets. "_Les morceaux décodés doivent être assemblés pour obtenir des informations intéressantes._"
- Le troisième indice suggère d'utiliser un outil de décodage Base64 pour faciliter le processus. Il est également suggéré de vérifier les commentaires du script, car ils peuvent contenir des indices sur la manière dont les chaînes sont concaténées. "_Utilise CyberChef ou un petit script Python pour le décodage en Base64._"

*Flag attendu :* Le flag attendu le mot de passe du compte SSH, qui est `p@ssw0rd_V3rY_B@d`.

Une fois connecté au compte, le joueur·euse obtient des droits supplémentaires et peut accéder à la plateforme des attaquants.




