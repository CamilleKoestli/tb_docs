= Scénarios <scenarios>
Ce chapitre présente les différents scénarios que j'ai imaginés pour la plateforme _CyberGame_. L'objectif était de trouver des histoires captivantes et pédagogiques tout en intégrant des éléments de jeu pour travailler les aspects de la cybersécurité. Pour réussir à trouver un scénario adapté, je me suis inspirée de faits réels et de CTF afin d'imaginer les challenges. J'ai donc analysé les mécaniques de jeux et leurs objectifs pédagogiques. J'ai ensuite élaboré trois scénarios, chacun avec ses propres défis et compétences visées tout en restant accessible à tout le monde. Chaque scénario est présenté avec une description détaillée, les compétences travaillées et les étapes pour le résoudre.

#include "scenario-1.typ"
#pagebreak()
#include "scenario-2.typ"
#pagebreak()
#include "scenario-3.typ"
#pagebreak()

== Retour d'expertise <retour-expertise>

Les différents scénarios ont été présentés au pôle Y-Security pour obtenir un retour d'expertise et des recommandations. Dans un premier temps, le pôle a apprécié la diversité des scénarios proposés et la manière dont ils abordent les différents aspects de la cybersécurité. Cependant, le scénario 3 a été jugé trop similaire à l'histoire "Sauve la Terre de l'arme galactique" et trop complexe. Il n'a pas été retenu pour la suite du projet. Le pôle a également souligné l'importance de rendre les scénarios plus accessibles aux débutant·e·s, tout en proposant des défis intéressants pour les utilisateur·trice·s plus expérimenté·e·s. \
Les histoires 1 et 2 ont été jugées pertinentes et intéressantes et les experts ont proposé de les combiner pour créer un scénario plus complet autour du scénario 1 mais aussi avoir plus de challenges, car 5 challenges ne sont pas suffisants pour un scénario complet. \
Enfin, un dernier point a été soulevé concernant le fait qu'il y avait trop de défis offline, c'est-à-dire sans interaction en temps réel avec le système. Il sera donc nécessaire d'y ajouter un défi technique, comme un bot, et donc de revoir la structure des défis pour les rendre plus accessibles et interactifs.


== Scénario définitif : Blackout dans le _Centre Hospitalier Horizon Santé_ <scénario-définitif>
Le scénario définitif retenu est l'histoire 1, intitulé "Blackout dans le _Centre Hospitalier Horizon Santé_", et il combine les challenges des scénarios 1 et 2 ainsi que de nouveaux défis adaptés afin de suivre une évolution cohérente d'une attaque par ransomware. Cette histoire s'inspire de fait réelle qui pourrait arriver dans un hôpital et des étapes simplifiées qu'une équipe de cybersécurité devrait réaliser afin de récupérer les données et de sécuriser l’infrastructure hospitalière.

Ce scénario met en scène une attaque de rançongiciel dans un hôpital, qui entraîne un blackout des systèmes informatiques et des services critiques. Les joueur·euse·s devront résoudre une série de défis techniques et stratégiques en s'infiltrant dans le site des attaquants pour supprimer les dossiers sensibles récoltés et enfin sécuriser les installations de l'hôpital.

Le joueur·euse incarne un membre de l'équipe de sécurité qui doit contenir une cyber-attaque qui bloque le _Centre Hospitalier Horizon Santé_.
Après avoir retrouvé le courriel de phishing à l’origine de l'attaque (#link(<ch-1>)[_Challenge 1 Mail Contagieux_]), il découvre le domaine frauduleux et se lance dans l’exploration du faux portail exploité par les assaillants (#link(<ch-2>)[_Challenge 2 Portail Frauduleux_]). Pour réussir à y pénétrer, il réalise une injection SQL pour ouvrir une première session, mais seulement avec des droits limités : assez pour naviguer, mais pas assez pour supprimer des éléments présents sur les serveurs.\
Sur ce site, il découvre un "Dépôt sécurisé" mal protégé (#link(<ch-3>)[_Challenge 3 Partage Oublié_]) qui révèle une archive patient chiffrée. En inspectant les métadonnées du fichier ZIP, le joueur·euse déchiffre le mot de passe grâce à une empreinte SHA-1 et un peu de bruteforce (#link(<ch-4>)[_Challenge 4 Clé cachée dans les commentaires_]). L’archive libérée contient un script d’automatisation des sauvegardes : après un rapide reverse engineering, des identifiants SSH privilégiés tombent enfin dans ses mains (#link(<ch-5>)[_Challenge 5 Script Mystère_]).\
Ces nouveaux accès ne suffisent toujours pas : la console interne des pirates reste verrouillée derrière une session administrateur. Pour l’obtenir, il faudra tendre un piège XSS à un bot de rançon qui consulte chaque note déposée. Une balise `<script>` postée dans le formulaire permet de capturer le cookie "admin" et de le ré-injecter dans le navigateur (#link(<ch-6>)[_Challenge 6 Cookie Rançon_]). Le bouton « Delete All » peut enfin être cliqué, ce qui va permettre de supprimer tous les fichiers chiffrés et empêchant ainsi les attaquants de poursuivre leur ransomware.\
Enfin, pour s’assurer que l’attaquant ne puisse plus revenir, le joueur·euse devra analyser les logs VPN, repérer l’IP qui tente d’exfiltrer massivement des données et l’inscrire dans la liste noire du pare-feu (#link(<ch-7>)[_Challenge 7 Blocage ciblé_]). Le message final confirme le blocage, les systèmes critiques redémarrent, l’hôpital retrouve la maîtrise de son SI et l’incident est officiellement terminé.

En parcourant ces sept défis, le participant·e permet d'avoir un aperçu sur tout le cycle d’une réponse à incident : OSINT, exploitation Web, contrôle d’accès, cryptanalyse, reverse engineering, escalade de privilèges via XSS, et opérations de défense. Chaque étape montre une bonne pratique de cybersécurité à mettre en œuvre pour protéger les établissements de santé contre les ransomwares.

Il est important de noter que les challenges pourront être adaptés en fonction des compétences des joueur·e·s et de leur niveau d'expérience lors de l'implémentation du code. Il s'agit que d'une proposition de structure et de contenu pour le scénario. Les défis peuvent être modifiés ou ajustés pour mieux correspondre aux objectifs pédagogiques et aux compétences visées.

*Challenges à réaliser*
#table(
  columns: (auto, 1fr, 1fr, 2fr),
  align: (center, left, left, left),

  table.header([*Étape*], [*Nom du challenge*], [*Compétence travaillée*], [*Description du challenge*]),

  [1],
  [#link(<ch-1>)[Mail Contagieux]],
  [OSINT et forensic e-mail],
  [Analyser les en-têtes d’un e-mail de phishing pour identifier le domaine frauduleux utilisé par l’attaquant.],

  [2],
  [#link(<ch-2>)[Portail Frauduleux]],
  [Exploitation Web (SQL)],
  [Contourner un formulaire de connexion malgré un WAF basique pour accéder au faux site des pirates.],

  [3],
  [#link(<ch-3>)[Partage Oublié]],
  [Contrôle d’accès],
  [Explorer un dépôt mal configuré pour accéder à l’archive confidentielle.],

  [4],
  [#link(<ch-4>)[Clé cachée dans les commentaires]],
  [Cryptographie et métadonnées],
  [Trouver un SHA-1 dans le commentaire ZIP, brute-forcer un mot de passe.],

  [5],
  [#link(<ch-5>)[Script Mystère]],
  [Reverse engineering],
  [Décoder des chaînes Base64 cachées dans `backup_sync.py` afin de révéler les identifiants SSH d'un user.],

  [6],
  [#link(<ch-6>)[Cookie Rançon]],
  [XSS et détournement de session],
  [Injecter du JavaScript dans une demande de rançon pour voler le cookie "admin" du bot et supprimer les fichiers volés.],


  [7],
  [#link(<ch-7>)[Blocage ciblé]],
  [Défense et journalisation],
  [Analyser les logs VPN, repérer l’IP la plus bavarde et l’ajouter à la liste noire du pare-feu.],
)

=== _Mail Contagieux_ : OSINT et forensic email <ch-1>
Ce premier défi montre au joueur·euse un l’e-mail de phishing qui serait l’origine de l’attaque. Il s’agit d’un message piégé, qui aurait été envoyé par le support d’Horizon Santé, avec en pièce jointe un fichier malveillant `planning_salle_op.xlsx`. Le but est d’analyser les en-têtes techniques de cet e-mail pour remonter à son véritable expéditeur et identifier le domaine frauduleux utilisé par les attaquants. \
Ce challenge a pour objectif de sensibiliser aux signes d’un courriel d’hameçonnage.

*Étapes pour résoudre le challenge :*
+ Ouvrir le fichier `planning_salle_op.eml` dans l’IDE.
+ Examiner les lignes commençant par `Received:` (du bas vers le haut) afin de trouver l’adresse IP d’origine de l’envoi. Repérer également l’en-tête `Return-Path:` qui contient le domaine de l’expéditeur.
+ Identifier dans la première ligne `Received:` l’IP source et dans le `Return-Path` le nom de domaine utilisé par l’expéditeur.
+ Effectuer une recherche WHOIS sur ce nom de domaine pour vérifier s’il est légitime ou s’il s’agit d’un domaine malveillant créé pour l’attaque.

*Outils nécessaires :* Les outils nécessaires pour ce défi sont un éditeur de texte/IDE pour afficher les en-têtes de l’e-mail, et un service WHOIS/OSINT en ligne pour vérifier le domaine.

*Indices graduels :*
- Le premier indice suggère de se concentrer sur les tout premiers en-têtes `Received:`. La véritable origine de l’e-mail est souvent dans la ligne la plus basse, car c’est le premier serveur à avoir reçu le message.
- Le second indice indique que l’expéditeur imite le sous-domaine support d’Horizon Santé, mais un détail dans le nom de domaine trahit la fraude. Il faut donc regarder attentivement le domaine après le `@`.
- Le troisième indice rappelle de vérifier la réputation du domaine suspect via un service WHOIS/OSINT. On découvre que le domaine ressemble à `horizonsante.com`, mais il a été enregistré récemment et est signalé comme malveillant.

*Flag attendu :* Le flag serait donc le nom de domaine frauduleux utilisé par l'attaquant `horizonsante-support.com`.

Une fois le sous-domaine identifié, le joueur·euse pourra passer au défi suivant qui sera la cible pour le challenge 2.


=== _Portail Frauduleux_ : Exploitation Web (SQL) <ch-2>
Le joueur·euse a identifié le domaine frauduleux `horizonsante-support.com`. Ce sous-domaine a été mis en place par les attaquants pour exfiltrer des données sous la forme d'un site légitime. Pour accéder à l’interface et progresser, il faut contourner le formulaire de connexion. Un pare-feu (WAF) a été mis en place et bloque les injections SQL évidentes, c'est-à-dire qu'il refuse par exemple les mots-clés `OR` et les commentaire `--`. Le défi consiste à exploiter une injection SQL malgré ces restrictions, afin de contourner l’authentification et d’accéder au portail des attaquants. Pour passer le contrôle de format du champ email, le joueur doit fournir une adresse e-mail valide et réaliste d’un employé de l’hôpital. Étant donné que le portail factice est conçu pour piéger les employés, il attend une adresse de l’hôpital Horizon Santé (domaine `@horizonsante.com`). Par exemple, une adresse au format `prenom.nom@horizonsante.com` correspond au schéma utilisé par de nombreuses organisations et semble crédible.\
Ce challenge sensibilise aux failles d’injection et montre qu’une protection insuffisante peut être contournée par des techniques simples.

*Étapes pour résoudre le challenge :*
+ Utiliser une adresse e-mail valide, `alice.durand@horizonsante.com`, qu'il récupère dans le challenge précédant et compléter dans le champ `Email` pour passer le contrôle de format.
+ Dans le champ `Mot de passe`, réaliser une injection SQL. Cependant, le WAF empêche d'utiliser `' OR 1=1` ou `--`. Il faut faudra donc la modifier un peu pour le contourner avec le mot de passe : `' O/**/R 1=1 #`.
+ Valider le formulaire. Une fois la connexion établie, un code de session apparaît.

*Outils nécessaires :* Un navigateur web (avec éventuellement les outils de développement pour observer les requêtes) suffit pour ce défi. Aucune extension spécifique n’est requise, juste la saisie de la charge malveillante dans le formulaire.

*Indices graduels :*
- Le premier indice rappelle qu’il faut utiliser une adresse e-mail valide pour passer le contrôle de format. Il est suggéré d’utiliser un format plausible, comme `prenom.nom@horizonsante.com`, qui est à retrouver dans le challenge précédant.
- Le second indice indique que le WAF bloque les mots-clés `OR` et les commentaires `--`, mais qu’il existe d’autres syntaxes SQL pour les commentaires.
- Le troisième indice suggère de combiner l’astuce du commentaire au milieu de `OR` et le commentaire en fin de requête.

*Flag attendu* : Le flag `co_<SESSION_ID>` montre que la connexion au site a bien été établie.

Le joueur·euse peut maintenant accéder au site des attaquants.


=== _Partage Oublié_ : Mauvaise configuration d’accès <ch-3>
Sur le portail, un lien "Dépôt sécurisé" mène à `https://files.horizonsante-support.com/?dir=/`. À cause d’un contrôle d’accès mal configuré (absence de filtre sur le chemin), n’importe quel·le utilisateur·trice en "lecture seule" peut parcourir l’arbre et récupérer des documents confidentiels.\
Ce challenge permet de montrer au joueur·euse l’importance de la sécurisation des accès aux ressources sensibles et de la validation des paramètres d’URL. Il sensibilise aux risques liés à une mauvaise configuration des droits d’accès et à l’absence de filtrage sur les chemins, qui peuvent permettre à un attaquant de parcourir l’arborescence et d’accéder à des fichiers confidentiels sans autorisation.

*Étapes pour résoudre le challenge :*
+ Depuis le portail frauduleux, ouvrir l’onglet Ressources, puis "Dépôt sécurisé".
+ Modifier l’URL pour lister la racine (`/?dir=/`).
+ Descendre jusqu’à `/archives/audit/2025/` et télécharger `patient_audit_1207.zip`.

*Outils nécessaires* : Les outils pour ce challenge sont un navigateur ou un outil de requête (curl).

*Indices graduels* :
- Le premier indice permet de montrer au joueur·euse que l'URL contient un paramètre `dir=` et qu'il faut essayer d'aller à la racine.
- Le deuxième indice suggère d’explorer les sous-dossiers à la racine, en particulier ceux qui ressemblent à des archives ou des sauvegardes. Il faut chercher un dossier nommé `archives` puis descendre dans les sous-dossiers par année et mois pour trouver le fichier d’audit.
- Le troisième indice précise que le fichier ZIP d’audit est daté de juillet, ce qui correspond au nom `patient_audit_1207.zip`. Il faut donc chercher dans les sous-dossiers de l’année 2025, puis dans le dossier du mois 07 (juillet), pour trouver le fichier à télécharger.

*Flag attendu* : Le flag `patient_audit_1207.zip` est un fichier zip qui contient potentiellement tous les dossiers sur les patients ainsi que d'autres éléments.

Ce zip fera l'objet du prochain challenge.

=== _Clé cachée dans les commentaires_ : Cryptographie et métadonnées <ch-4>
Le joueur·euse a maintenant accès à l'archive `patient_audit_1207.zip` mais le problème est qu'il est verrouillé. Le joueur·euse doit trouver le mot de passe pour déverrouiller ce zip. En inspectant les métadonnées du ZIP, le joueur·euse découvre un commentaire contenant seulement une empreinte SHA-1 : `f7fde1c3f044a2c3002e63e1b6c3f432b43936d0`.\
Première solution: utiliser un site comme CrackStation pour trouver le mot de passe correspondant à cette empreinte SHA-1.\
Deuxième solution : Les experts Blue Team ont remarqué que les pirates utilisent toujours un mot de passe de la forme : `horizon<nombre>` où `<nombre>` varie de 0 à 99 (par exemple horizon1).\
Ce challenge montre l'importance de la cryptographie et de la gestion des mots de passe, ainsi que la nécessité de vérifier les métadonnées des fichiers.

*Étapes pour résoudre le challenge :*
+ Lister les métadonnées du zip avec `zipinfo patient_audit_1207.zip` ou sur Windows en utilisant l'explorateur de fichiers.
+ Trouver le commentaire contenant l'empreinte SHA-1
+ Aller sur le site CrackStation ou utiliser un script Python pour générer les mots de passe possibles de la forme `horizon<nombre>` et vérifier si l'un d'eux correspond à l'empreinte SHA-1 ou utiliser CyberChef pour générer les mots de passe et vérifier l'empreinte.
+ Une fois le mot de passe trouvé, déverrouiller le zip.

*Outils nécessaires :* Pour résoudre ce challenge, il faudra un éditeur de texte pour lire les métadonnées, CrackStation ou un script Python ou CyberChef pour générer les mots de passe et vérifier l'empreinte SHA-1.

*Indices graduels :*
- Le premier indice suggère de regarder les métadonnées du zip, car elles peuvent contenir des informations utiles.
- Le second indice indique que le commentaire contient une empreinte SHA-1, ce qui signifie qu'il faut trouver le mot de passe qui correspond à cette empreinte.
- Le troisième indice rappelle que les mots de passe ont une structure spécifique, ce qui peut aider à les générer. Le joueur·euse peut se rendre sur CrackStation pour y entrer le hash ou il peut créer un script Python pour générer les mots de passe de la forme `horizon<nombre>` où `<nombre>` varie de 0 à 99. Il peut ensuite comparer leur empreinte SHA-1 avec celle du commentaire ou utiliser CyberChef pour générer les mots de passe et vérifier l'empreinte.

*Flag attendu :* Le flag attendu est le mot de passe du zip, qui est `horizon42`.

Ce mot de passe permet de déverrouiller le zip et d'accéder au contenu du fichier `hx_dropper.ps1`.

=== _Script Mystère_ : Reverse Engineering <ch-5> 
Dans l’archive déchiffrée (`patient_audit_1207.zip`) se trouve `tools/backup_sync.py`.
Les pirates y ont laissé un compte SSH à privilèges "support-user" mais l’ont caché par une simple concaténation de caractères. Le but est de reconstituer le login et le mot de passe clair.\
Ce challenge permet de sensibiliser à l'importance de la sécurité des scripts et de la nécessité de vérifier les scripts avant de les exécuter. Il montre également comment les attaquants peuvent masquer des informations sensibles dans des scripts apparemment innocents.

*Étapes pour résoudre le challenge :*
+ Ouvrir le fichier `backup_sync.py` dans l'IDE.
+ Identifier les lignes qui contiennent des chaînes de caractères encodées en Base64.
+ Décoder les chaînes Base64 pour obtenir le login et le mot de passe.
+ Concaténer les parties pour reconstituer le login et le mot de passe.

*Outils nécessaires :* Pour ce challenge les outils nécessaires sont un éditeur de texte/IDE pour lire le script, un outil de décodage Base64 (comme CyberChef ou un script Python).

*Indices graduels :*
- Le premier indice rappelle que le script contient des chaînes de caractères encodées en Base64, ce qui signifie qu'il faut les décoder pour obtenir les informations cachées.
- Le second indice indique que les chaînes sont concaténées, ce qui signifie qu'il faut les assembler pour obtenir le login et le mot de passe complets.
- Le troisième indice suggère d'utiliser un outil de décodage Base64 pour faciliter le processus. Il est également suggéré de vérifier les commentaires du script, car ils peuvent contenir des indices sur la manière dont les chaînes sont concaténées.

*Flag attendu :* Le flag attendu le mot de passe du compte SSH, qui est `p@ssw0rd_V3rY_B@d`.

Une fois connecté au compte, le joueur·euse obtient des droits supplémentaires et peut accéder à la plateforme des attaquants.

=== _Cookie Rançon_ : Mauvaise gestion des sessions <ch-6>
Le joueur·euse doit intercepter le cookie de session "admin" utilisé par un bot qui consulte automatiquement chaque demande de rançon. Pour cela, il doit exploiter une faille XSS afin de voler ce cookie lorsque le bot visite la page. Ensuite, il devra injecter ce cookie dans son propre navigateur pour obtenir les droits administrateur et ainsi accéder à la fonctionnalité de suppression, ce qui lui permettra de supprimer définitivement les fichiers sur le serveur des attaquants.\
Ce challenge montre l'importance de la gestion des sessions et de la sécurité des cookies. Il sensibilise aux risques liés à la manipulation des cookies de session et à la nécessité de sécuriser les sessions utilisateur.

*Étapes pour résoudre le challenge :*
+ Tester l'injection XSS dans le champ Message : `<script>alert(1)</script>`.
+ Exfiltrer le cookie de session "admin" en utilisant une injection XSS dans le champ Message du chat : `<script>fetch('/collect?c='+encodeURIComponent(document.cookie))</script>` et attendre que le bot ouvre la demande.
+ Récupérer le cookie volé `admin_session=<COOKIE_VALUE>`
+ Ouvrir les outils de développement du navigateur, aller dans l'onglet Application, puis dans la section Cookies.
+ Coller le cookie volé dans le champ de saisie du cookie de session.
+ Une fois le cookie injecté, recharger la page pour obtenir les droits administrateur et supprimer les fichiers.
+ Le serveur affiche un message de confirmation `ALL_FILES_DELETED` indiquant que tous les fichiers ont été supprimés.

*Outils nécessaires :* Un navigateur web avec les outils de développement pour intercepter et manipuler les cookies, ainsi qu'un éditeur de texte pour écrire le script XSS.

*Indices graduels :*
- Le premier indice expliquer que les balises HTML ne sont pas échappées dans le champ Message, ce qui permet d'injecter du code JavaScript.
- Le deuxième indice indique que le bot ouvre automatiquement les demandes de rançon, ce qui signifie que le joueur·euse peut exploiter cette fonctionnalité pour voler le cookie de session.
- Le troisième indice rappelle que le cookie de session "admin" est nécessaire pour accéder aux fonctionnalités administratives du portail. Il est donc crucial de le voler pour pouvoir supprimer les fichiers.


*Flag attendu* : la réponse du serveur `ALL_FILES_DELETED`, ce qui montre au joueur·euse que tous les fichiers ont été supprimés avec succès. 

Une fois les fichiers supprimés, le joueur·euse peut passer au défi suivant pour bloquer l'attaquant.


=== _Blocage ciblé_ : Défense et journalisation <ch-7>
Maintenant que les fichiers sont supprimés du côté des attaquants, le joueur·euse doit identifier l’adresse IP de la machine de l’attaquant pour le bloquer. Le joueur·euse doit donc s'assurer qu'aucune connexion sortante ne continue d'envoyer des données. Un flux a été repéré : la même adresse IP externe a émis des milliers de requêtes vers le portail VPN de l’hôpital au cours du dernier quart d’heure (tentative d’exfiltration massive). Le joueur·euse doit donc trouver le fichier de log contenant ces requêtes, identifier l’IP la plus présente (c’est l’attaquant) et ajouter cette IP à la liste noire du pare-feu interne. Une fois l’IP bloquée, le joueur·euse recevra un message de confirmation `BLK_185-225-123-77_OK` indiquant que le blocage a été effectué avec succès.\
Ce challenge montre l'importance de la surveillance des logs et de la gestion des adresses IP suspectes pour prévenir les attaques.

*Étapes pour résoudre le challenge :*
+ Depuis le portail IT interne `https://intra.horizonsante.com/it/`	, aller dans le menu de gauche "Outils SOC".
+ Cliquer sur "Logs & Diagnostics", puis sur "VPN Access" , ce qui fait apparaître une liste de fichiers.
+ Ouvrir le fichier log le plus récent `vpn_access_2025-07-17.log` dans un éditeur de texte. Chaque ligne commence par l’IP source.
+ Repérer l’adresse IP qui apparaît le plus souvent `185.225.123.77`	qui est donc la machine de l’attaquant.
+ Dans le menu de gauche, cliquer sur "Pare-feu", puis sur "Liste noire".
+ Dans un formulaire, entrer l’adresse IP `185.225.123.77`.
+ Le système affiche un bandeau vert avec le message `BLK_185-225-123-77_OK`.

*Outils nécessaires* : Les outils nécessaire pour résoudre ce challenge sont un navigateur web et un éditeur de texte pour lire le fichier log.

*Indices graduels :*
- Le premier indice rappelle que le menu "Logs & Diagnostics" contient tous les journaux, cherche celui qui mentionne "VPN Access".
- Le deuxième indice indique que dans le fichier, chaque entrée commence par l’IP source. Cela signifie qu'il faut chercher les lignes qui commencent par une adresse IP.
- Le troisième indice suggère de bloquer l’IP trouvée dans le pare-feu.

*Flag attendu :* Le flag attendu est le message `BLK_185-225-123-77_OK` qui confirme que l’adresse IP de l’attaquant a été bloquée avec succès. Cela permet de sécuriser le réseau et d'empêcher toute nouvelle tentative d'exfiltration de données.

Le joueur·euse a réussi à bloquer l'attaquant et à sécuriser le réseau de l'hôpital. La deuxième vague n'aura donc pas lieu et le joueur·euse reçoit pour conclure l'aventure.
