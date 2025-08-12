== Challenge 2 : _Portail Frauduleux_  <challenge-2>

Ce challenge vise à sensibiliser les participants aux risques liés aux faux portails de connexion. Dans ce défi, les participant·e·s devront identifier et exploiter un faux portail de connexion pour accéder à des données sensibles grâce à une injection SQL.

La consigne suivante est donnée aux joueur·euses :

"_Vous avez identifié le domaine pirate hébergeant un faux portail VPN. C’est ici que les données volées transitent. Connectez-vous au portail en utilisant une adresse e-mail valide du domaine `@horizonsante.com`. Un WAF basique protège la connexion, mais il est mal configuré. Une fois connecté·e, l'information *`co_<SESSION_ID>`* vous sera accessible._"

Voici les indices disponibles pour les utilisateur·trice·s :

- Indice 1 : "_Utilise une adresse e-mail au format crédible, par exemple `prenom.nom@horizonsante.com`, que tu peux retrouver dans le challenge précédant._"
- Indice 2 : "_Le WAF bloque `OR` et les commentaires `--`, mais il existe d’autres syntaxes pour ces opérations._"
- Indice 3 : "_Essaie de couper le mot-clé `OR` avec un commentaire `/**/` et termine par un commentaire `#`._"