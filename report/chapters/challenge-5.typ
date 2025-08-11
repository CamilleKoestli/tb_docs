== Challenge 5 : _Script Mystère_ <challenge-5>

Dans le challenge suivant, le participant·e doit analyser un script Python suspect pour découvrir des informations sensibles. Ici, il met en évidence l'importance de l'analyse des scripts et de la recherche de données sensibles dissimulées. Il est crucial de prêter attention aux détails et ne de pas laisser passer d'informations importantes. Ce challenge permet aussi de montrer comment des informations sensibles peuvent être cachées dans des scripts apparemment innocents.

Pour ce faire, le participant·e reçoit le message suivant :

"_L'archive est maintenant déverrouillée et vous constatez qu'effectivement elle contient bien toutes les informations sensibles concernant les patients. Il faut la supprimer rapidement. Cependant, vous ne disposez pas des droits administrateurs suffisants pour la supprimer. En explorant l’archive déverrouillée, vous trouvez un script Python suspect (`backup_sync.py`). Les pirates y auraient potentiellement caché des identifiants SSH et *un mot de passe* qu'il faudra fournir._"

Voici les indices à sa disposition : 

- Indice 1 : "_Cherche des chaînes longues terminant par `=` ou `==`._"
- Indice 2 : "_Les morceaux décodés doivent être assemblés pour obtenir des informations intéressantes._"
- Indice 3 : "_Utilise CyberChef ou un petit script Python pour le décodage en Base64._"