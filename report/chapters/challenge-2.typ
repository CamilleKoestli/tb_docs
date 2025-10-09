== Challenge 2 _Portail Frauduleux_ : Exploitation Web (SQL) <ch-2>

=== Description
Le joueur·euse a identifié le domaine frauduleux `horizonsante-support.com`. Ce domaine a été mis en place par les attaquants pour exfiltrer des données. Pour accéder à l’interface et progresser, il faut contourner le formulaire de connexion. Un pare-feu (WAF) a été mis en place et bloque les injections SQL évidentes, c'est-à-dire qu'il refuse par exemple les mots-clés `OR` et les commentaires `--`. Le défi consiste à exploiter une injection SQL malgré ces restrictions, afin de contourner l’authentification et d’accéder au portail des attaquants. Pour passer le contrôle de format du champ email, le joueur·euse doit fournir une adresse email et dans le champ mot de passe et y réaliser l'injection. \
Ce challenge sensibilise aux failles d’injection et montre qu’une protection insuffisante peut être contournée par des techniques simples.

La consigne suivante est donnée aux joueur·euse·s :
"_L'équipe de sécurité a retracé le domaine identifié et découvert qu'il héberge un portail suspect. Il s'agit probablement de l'infrastructure utilisée par les attaquants pour orchestrer leur attaque. Tentez d'y accéder pour y retrouver l'information *`co_<SESSION_ID>`*._"

*Étapes pour résoudre le challenge :*
+ Utiliser une adresse email valide, `support@horizonsante-support.com` , qui se trouve dans le challenge précédent et compléter dans le champ email pour passer le contrôle du mail dans la base de données.
+ Dans le champ `Mot de passe`, réaliser une injection SQL. Cependant, le WAF empêche d'utiliser `' OR 1=1` ou `--`. Il faut faudra donc la modifier un peu pour le contourner avec le mot de passe : `' || 1=1 #`.
+ Valider le formulaire. Une fois la connexion établie, un code de session apparaît.

*Outils nécessaires :* Un navigateur web (avec éventuellement les outils de développement pour observer les requêtes) suffit pour ce défi. Aucune extension spécifique n’est requise, juste la saisie de la charge malveillante dans le formulaire.

*Indices graduels :*
- Le premier indice rappelle qu’il faut utiliser une adresse email valide pour contourner le contrôle du mail invalide. Il est suggéré de récupérer l’adresse email utilisée par les attaquants dans le challenge précédent. "_Retrouvez l’adresse email utilisée par les attaquants dans le challenge précédent avec comme fin `@horizonsante-support.com`_"
- Le second indice suggère que la vulnérabilité ne se trouve pas dans le champ email et donc que l'injection doit se faire dans le mot de passe. "_L’adresse email doit seulement être correcte pour passer la vérification. La véritable vulnérabilité se cache dans le champ mot de passe._"
- Le troisième indice indique que le WAF bloque les mots-clés `OR` et les commentaires `--`, mais qu’il existe d’autres syntaxes SQL pour ces éléments. "_Le WAF (Web Application Firewall) bloque `OR` et les commentaires `--`, mais il existe d’autres syntaxes pour ces opérations..._"


*Flag attendu* : Le flag `co_S3ss10n4Cc3s5` montre que la connexion au site a bien été établie.

Le joueur·euse peut maintenant accéder au site des attaquants.

=== Techniques et outils
Pour ce challenge, une base déjà présente de ce qu'est une injection SQL était déjà présente sur la plateforme. Elle a été donc enrichie pour l'adapter au niveau de difficulté du challenge.

Elle y explique d’abord ce qu’est une injection SQL et comment elle permet de manipuler une requête mal protégée afin d’accéder à des informations sensibles. Ensuite, on y retrouve un exemple concret d’injection (' OR 1=1 --) qui illustre comment un attaquant peut rendre une condition toujours vraie et ainsi contourner l’authentification, afin de permettre au joueur·euse de mieux comprendre la vulnérabilité et le fonctionnement de cette technique.

Une section sur les différentes variantes d’écritures possibles (par exemple écrire OR sous plusieurs formes ou utiliser différents types de commentaires) a été ajoutée. Cette partie est importante, car dans le challenge un WAF est présent et bloque les tentatives les plus évidentes. Le joueur·euse doit donc comprendre qu’il existe plusieurs syntaxes en SQL, ce qui lui permet de contourner la protection.

Enfin, la notion de WAF a été introduite pour que le joueur·euse comprenne pourquoi certaines injections ne fonctionnent pas et pourquoi il doit en tester d’autres.

Cet outil est utile, car il apporte un cadre théorique clair : il prépare le joueur·euse à raisonner comme un attaquant, à tester plusieurs possibilités et à comprendre pourquoi une injection simple peut échouer. 