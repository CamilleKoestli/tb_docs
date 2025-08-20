== Challenge 2 _Portail Frauduleux_ : Exploitation Web (SQL) <ch-2>

Le joueur·euse a identifié le domaine frauduleux `horizonsante-support.com`. Ce sous-domaine a été mis en place par les attaquants pour exfiltrer des données sous la forme d'un site légitime et éviter d'attirer trop rapidement les soupçons. Pour accéder à l’interface et progresser, il faut contourner le formulaire de connexion. Un pare-feu (WAF) a été mis en place et bloque les injections SQL évidentes, c'est-à-dire qu'il refuse par exemple les mots-clés `OR` et les commentaire `--`. Le défi consiste à exploiter une injection SQL malgré ces restrictions, afin de contourner l’authentification et d’accéder au portail des attaquants. Pour passer le contrôle de format du champ email, le joueur doit fournir une adresse e-mail valide et réaliste d’un employé de l’hôpital. Le joueur·euse devra utiliser l'adresse mail utilisée par les attaquants dans le challenge précédent afin de contourner le WAF.\
Ce challenge sensibilise aux failles d’injection et montre qu’une protection insuffisante peut être contournée par des techniques simples.

La consigne suivante est donnée aux joueur·euses :
"_Vous avez identifié le domaine pirate hébergeant un faux portail. C’est ici que les données volées sont exfiltrées et ressemble à l'interface d'un site légitime pour éviter d'attirer trop rapidement les soupçons. Connectez-vous au portail en utilisant une adresse e-mail valide du domaine `@horizonsante-support.com`. Un WAF basique protège la connexion, mais il est mal configuré. Une fois connecté·e, l'information *`co_<SESSION_ID>`* vous sera accessible._"

*Étapes pour résoudre le challenge :*
+ Utiliser une adresse e-mail valide, `h4ck3r_team@horizonsante-support.com`, qu'il se trouve dans le challenge précédant et compléter dans le champ `Email` pour passer le contrôle de format.
+ Dans le champ `Mot de passe`, réaliser une injection SQL. Cependant, le WAF empêche d'utiliser `' OR 1=1` ou `--`. Il faut faudra donc la modifier un peu pour le contourner avec le mot de passe : `' O/**/R 1=1 #`.
+ Valider le formulaire. Une fois la connexion établie, un code de session apparaît.

*Outils nécessaires :* Un navigateur web (avec éventuellement les outils de développement pour observer les requêtes) suffit pour ce défi. Aucune extension spécifique n’est requise, juste la saisie de la charge malveillante dans le formulaire.

*Indices graduels :*
- Le premier indice rappelle qu’il faut utiliser une adresse e-mail valide pour passer le contrôle de format. Il est suggéré de récupérer l'adresse email utilisée par les attaquants dans le challenge précédant. "_Retrouver l'adresse email utilisée par les attaquants dans le challenge précédent._"
- Le second indice indique que le WAF bloque les mots-clés `OR` et les commentaires `--`, mais qu’il existe d’autres syntaxes SQL pour les commentaires. "_Le WAF bloque `OR` et les commentaires `--`, mais il existe d’autres syntaxes pour ces opérations._"
- Le troisième indice suggère de combiner l’astuce du commentaire au milieu de `OR` et le commentaire en fin de requête. "_Essaie de couper le mot-clé `OR` avec un commentaire `/**/` et termine par un commentaire `#`._"

*Flag attendu* : Le flag `co_S3ss10n4Cc3s5` montre que la connexion au site a bien été établie.

Le joueur·euse peut maintenant accéder au site des attaquants.
