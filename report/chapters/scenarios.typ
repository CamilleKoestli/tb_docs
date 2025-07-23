= Scénarios <scenarios> 
#include "scenario-1.typ"
#pagebreak()
#include "scenario-2.typ"
#pagebreak()
#include "scenario-3.typ"
#pagebreak()

== Retour d'expertise <retour-expertise>

Les différents scénarios ont été présentés au pôle Y-Security pour obtenir un retour d'expertise et des recommandations. Dans un premier temps, le pôle a apprécié la diversité des scénarios proposés et la manière dont ils abordent les différents aspects de la cybersécurité. Cependant, le scénario 3 a été jugé trop similaire à l'histoire "Sauve la Terre de l'arme galactique" et trop complexe. Il n'a pas été retenu pour la suite du projet. Le pôle a également souligné l'importance de rendre les scénarios plus accessibles aux débutant·e·s, tout en proposant des défis intéressants pour les utilisateur·trice·s plus expérimenté·e·s. \
Les histoires 1 et 2 ont été jugées pertinentes et intéressantes et les experts ont proposé de les combiner pour créer un scénario plus complet autour du scénario 1 mais aussi avoir plus de challenges, car 5 challenges ne sont pas suffisants pour un scénario complet. \
Enfin, un dernier point a été soulevé concernant le fait qu'il y avait trop de défis offline. Il sera donc nécessaire d'y ajouter un défi technique et donc de revoir la structure des défis pour les rendre plus accessibles et interactifs.

== Scénario définitif : Blackout dans le Centre Hospitalier Horizon Santé <scénario-définitif>
Le scénario définitif retenu est l'histoire 1, intitulé "Blackout dans le Centre Hospitalier Horizon Santé", et il combine les challenges des scénarios 1 et 2. Ce scénario met en scène une attaque de ransomware sur un hôpital, entraînant un blackout des systèmes informatiques et des services critiques. Les joueur·euse·s devront résoudre une série de défis techniques et stratégiques pour restaurer les systèmes, protéger les données sensibles et assurer la continuité des soins aux patient·e·s.

=== _Mail Contagieux_ : OSINT et forensic d'email <challenge-1>
Ce premier défi montre au joueur·euse un l’e-mail de phishing qui serait l’origine de l’attaque. Il s’agit d’un message piégé, qui aurait été envoyé par le support d’Horizon Santé, avec en pièce jointe un fichier malveillant `planning_salle_op.xlsx`. Le but est d’analyser les en-têtes techniques de cet e-mail pour remonter à son véritable expéditeur et identifier le domaine frauduleux utilisé par les attaquants. \
Cette étape sensibilise aux signes d’un courriel d’hameçonnage.

*Étapes pour résoudre le challenge : *
  + Ouvrir le fichier `planning_salle_op.eml` dans l’IDE.
  + Examiner les lignes commençant par `Received:` (du bas vers le haut) afin de trouver l’adresse IP d’origine de l’envoi. Repérer également l’en-tête `Return-Path:` qui contient le domaine de l’expéditeur.
  + Identifier dans la première ligne `Received:` l’IP source et dans le `Return-Path` le nom de domaine utilisé par l’expéditeur.
  + Effectuer une recherche `WHOIS` sur ce nom de domaine pour vérifier s’il est légitime ou s’il s’agit d’un domaine malveillant créé pour l’attaque.

*Outils nécessaires :* Les outils nécessaires pour ce défi sont un éditeur de texte/IDE pour afficher les en-têtes de l’e-mail, et un service WHOIS/OSINT en ligne pour vérifier le domaine.

*Indices graduels :*
  - Le premier indice suggère de se concentrer sur les tout premiers en-têtes `Received:`. La véritable origine de l’e-mail est souvent dans la ligne la plus basse, car c’est le premier serveur à avoir reçu le message.
  - Le second indice indique que l’expéditeur imite le sous-domaine support d’Horizon Santé, mais un détail dans le nom de domaine trahit la fraude. Il faut donc regarder attentivement le domaine après le `@`.
  - Le troisième indice rappelle de vérifier la réputation du domaine suspect via un service WHOIS/OSINT. On découvre que le domaine ressemble à `horizonsante.com`, mais il a été enregistré récemment et est signalé comme malveillant.

*Flag attendu :* Le flag serait donc le nom de domaine frauduleux utilisé par l'attaquant `horizonsante-support.com`

Une fois le sous-domaine identifié, le joueur·euse pourra passer au défi suivant qui sera la cible pour le challenge 2.

=== _Portail VPN Fantôme_ : Exploitation Web (SQL) <challenge-2>
Le joueur·euse a identifié le domaine frauduleux `horizonsante-support.com` et découvre qu’il héberge un faux portail VPN de l’hôpital `https://vpn.horizonsante-support.com`. Ce portail a été mis en place par les attaquants pour exfiltrer des données sous la forme d'un site légitime. Pour accéder à l’interface et progresser, il faut contourner le formulaire de connexion. Un pare-feu (WAF) a été mis en place et bloque les injections SQL évidentes, c'est-à-dire qu'il refuse par exemple les mots-clés `OR` et les commentaire `--`. Le défi consiste à exploiter une injection SQL malgré ces restrictions, afin de contourner l’authentification et d’accéder au portail des attaquants. Pour passer le contrôle de format du champ email, le joueur doit fournir une adresse e-mail valide et réaliste d’un employé de l’hôpital. Étant donné que le portail factice est conçu pour piéger les employés, il attend une adresse de l’hôpital Horizon Santé (domaine `@horizonsante.com`). Par exemple, une adresse au format `prenom.nom@horizonsante.com` correspond au schéma utilisé par de nombreuses organisations et semble crédible.\
Ce challenge sensibilise aux failles d’injection et montre qu’une protection insuffisante peut être contournée par des techniques simples.

*Étapes pour résoudre le challenge :*
  + Utiliser une adresse e-mail valide, `alice.durand@horizonsante.com`, qu'il récupère dans le challenge précédant et compléter dans le champ `Email` pour passer le contrôle de format.
  + Dans le champ `Mot de passe`, réaliser une injection SQL. Cependant, le WAF empêche d'utiliser `' OR 1=1` ou `--`. Il faut faudra donc la modifier un peu pour le contourner avec le mot de passe : `' O/**/R 1=1 #`.
  + Valider le formulaire. Une fois la connexion établie, un code de session apparaît.

*Outils nécessaires :* Un navigateur web (avec éventuellement les outils de développement pour observer les requêtes) suffisent pour ce défi. Aucune extension spécifique n’est requise, juste la saisie de la charge malveillante dans le formulaire.

*Indices graduels :*
  - Indice 1 : Il faut utiliser une adresse e-mail valide pour passer le contrôle de format. Pense à utiliser un format d’adresse plausible, comme `prenom.nom@horizonsante.com`, que tu peux retrouver dans le challenge précédant.
  - Indice 2 : Le pare-feu bloque le mot `OR` en toutes lettres et interdit `--` mais il existe d'autres syntaxes SQL pour les commentaires.
  - Indice 3 : Combine l’astuce du commentaire au milieu de `OR` et le commentaire en fin de requête.

*Flag attendu* : Le flag `HZ-7XG4` est le code de session généré par le portail VPN une fois la connexion réussie. Il permet d'accéder aux ressources du faux portail.

Le joueur·euse peut maintenant accéder au faux portail VPN des attaquants, où il découvrira un bouton "Télécharger le rapport du jour" qui de télécharger le rapport du jour. Ce sera le point de départ du défi suivant.

=== _Sauvegarde Détournée_ : Web Path Traversal <challenge-3>
Une fois connecté·e au portail malveillant, le joueur·euse voit une section `Documents` dont le bouton "Télécharger le rapport du jour" renvoie toujours un fichier PDF, par exemple `rapport-2022-07-14.pdf`. Les attaquants s’en servent pour héberger ou faire transiter des informations sensibles déjà volées. Le but de ce défi est de découvrir si d’autres fichiers, invisibles dans l’interface, se cachent derrière ce mécanisme et d’en récupérer un pour évaluer l’ampleur de la fuite. En inspectant le code HTML le joueur·euse constatera que le nom de fichier transmis au script de téléchargement n’est pas réellement contrôlé : seule l’extension `.pdf` est vérifiée. En exploitant cette validation et en effectuant une traversée de répertoires (`../`), il pourra sortir du dossier public, atteindre le répertoire caché `/priv/` et télécharger l’archive `hx_srv_full_0712.tar.gz`, contenant la sauvegarde complète dérobée par les attaquants.\
Ce challenge sensibilise ainsi à la mauvaise validation des entrées utilisateur et aux failles de type path traversal, qui permettent d’accéder à des fichiers sensibles en contournant les restrictions d’accès.

*Étapes pour résoudre le challenge :*
+ Ouvrir les DevTools dans Réseau, cliquer sur le bouton, et observer l’URL : `download.php?doc=rapport-2022-07-14.pdf`, cela confirme que le fichier est passé en clair dans le paramètre doc.
+	Changer doc avec un autre nom PDF `test.pdf`et déduire que seule l’extension est vérifiée
+	Lire le code source repérer le commentaire :
  ```html
<!-- TODO: restreindre /priv/ -->
```	Découvrir l’emplacement du répertoire protégé
+ Trouver le chemin relatif `download.php?doc=../priv/`	
+ Trouver dans le dossier : le script PowerShell `hx_dropper.ps1` et l’archive `hx_srv_full_0712.tar.gz` 
+ Ouvrir localement, constater les dossiers patients et donc le flag.

*Outils nécessaires :* Les outils nécessaires pour résoudre ce challenge sont un navigateur web, l'utilisation des DevTools pour explorer le code HTML et éventuellement un éditeur de texte pour consulter le contenu du fichier manifest JSON.

*Indices graduels :*
  - Indice 1 : Observation réseau, dans les DevTools, la requête lancée par le bouton se présente toujours sous la forme `download.php?doc=<nom>.pdf`.
  - Indice 2 : Le code source de la page contient un commentaire développeur pour trouver un dossier caché.
  - Indice 3 : En ajoutant la séquence ../ au paramètre doc, il devient possible de remonter dans l’arborescence depuis docs/ vers /priv/ et ainsi retrouver l'archive de sauvegarde.

*Flag attendu :* Le flag attendu est le nom de l’archive de sauvegarde récupérée, `hx_srv_full_0712.tar.gz`. Ce fichier contient les données volées par les attaquants. Le répertoire contient des informations sensibles, y un script `hx_dropper.ps1` qui fera l'objet du prochain challenge.

=== _Script d’Infection_ : Reverse Engineering (PowerShell) <challenge-4>
Dans l’archive de données exfiltrées, le joueur·euse découvre un script PowerShell obfusqué nommé hx_dropper.ps1. Ce script a servi à l’attaquant pour établir une connexion vers son serveur de commande et contrôle (C2) et déployer le ransomware. Le code est volontairement illisible : variables nommées avec une seule lettre, longue chaîne de caractères codée, etc. Le défi consiste à dé-obfusquer ce script afin d’en extraire une information cruciale : l’URL du serveur C2 utilisé par les pirates. Concrètement, il faudra reconnaître une chaîne encodée en Base64 puis la décoder, et appliquer une opération XOR pour révéler le contenu en clair. Ce challenge montre comment les attaquants camouflent leurs logiciels malveillants et comment analyser un code malveillant pour y trouver des indices.

*Étapes pour résoudre le challenge :*

  + Ouvrir le fichier hx_dropper.ps1 dans un éditeur de code. Repérer dans le script une très longue chaîne de caractères suspecte (par exemple une suite de caractères alphabétiques et numériques se terminant par = ou ==). Ceci indique généralement un contenu encodé en Base64.
  + Extraire cette chaîne Base64 et la décoder. On peut utiliser un script Python, CyberChef ou un autre outil de décodage Base64. Le résultat ne sera pas encore lisible, ce sera une série d’octets apparemment aléatoires.
  + Observer le motif des octets décodés. On remarque qu’ils semblent tous avoir une valeur commune (par exemple de nombreux bytes 0x20 apparaissent, ce qui correspond au caractère espace en ASCII). C’est un indice qu’un XOR a été appliqué avec une certaine valeur. Ici, la présence récurrente de 0x20 suggère que chaque byte en clair a été combiné avec 0x20.
  + Appliquer un XOR 0x20 sur chaque byte du résultat décodé pour annuler l’obfuscation. En pratique, il s’agit de prendre chaque byte obtenu et de le XORer (opération OU exclusif) avec la valeur hexadécimale 20.
  + Après ce XOR, le texte en clair apparaît. Lire le résultat : on doit y voir notamment une URL complète commençant par https://. C’est l’adresse du serveur de commande et contrôle des attaquants (par exemple https://c2.hz-cloud.net/api). Noter cette URL pour la suite de l’enquête.

*Outils nécessaires :* Un éditeur de texte pour visualiser le script, et un outil de déobfuscation tel qu’un interpréteur Python (pour effectuer les décodages et XOR) ou l’outil en ligne CyberChef (qui permet d’enchaîner Base64 decode puis XOR).

*Indices graduels :*
  - Indice 1 : Une chaîne très longue remplie de caractères apparemment aléatoires (et se terminant par =) est sans doute du Base64. C’est souvent utilisé pour cacher du texte lisible.
  - Indice 2 : Après avoir décodé la Base64, si le résultat reste illisible, regarde la valeur hexadécimale qui revient fréquemment. Beaucoup de 20 hexadécimaux ? Le 0x20 est le code ASCII pour l’espace – cela suggère un masquage par XOR 0x20.
  - Indice 3 : Applique un XOR 0x20 sur chaque caractère décodé. Astuce : XOR agit comme un interrupteur, refaire XOR avec la même valeur annule l’effet. Une fois l’opération faite, le texte se révélera. Tu devrais y voir l’URL du serveur C2 des pirates en toutes lettres.

*Flag attendu :* c2.hz-cloud.net
(le nom de domaine du serveur de commande et contrôle extrait du script)

=== _Console Piégée_ : Exploitation Web (XSS) <challenge-5>
Armé·e de l’URL du serveur C2 (c2.hz-cloud.net), le joueur·euse passe à une phase de « hack back » : il va exploiter à son tour une faiblesse sur le serveur des attaquants. Ce défi introduit une faille de Cross-Site Scripting (XSS). Le serveur des pirates comporte une interface web (par exemple une console d’administration ou un module de chat/support) vulnérable à une injection de script. Le principe est de réussir à y injecter du code JavaScript malveillant de sorte que, lorsqu’un utilisateur ayant des privilèges (en l’occurrence, l’attaquant ou un robot admin) verra ce contenu, le script s’exécute dans son navigateur. Pour simuler cela, un robot interactif jouera le rôle de la victime en venant automatiquement charger la page piégée. L’objectif est d’obtenir, grâce à cette XSS, une donnée sensible du serveur pirate – par exemple le fameux fichier de configuration chiffré contenant des informations critiques. \
Ce challenge montre comment une simple faille XSS peut être utilisée pour retourner la situation et pourquoi il est crucial de corriger ce type de vulnérabilité.

*Étapes pour résoudre le challenge :*
  + Accéder à l’interface web du serveur C2 (naviguer sur l’URL découverte). Rechercher une fonctionnalité où du texte saisi par un utilisateur pourrait être affiché (par exemple, un formulaire de commentaire, un champ de saisie de pseudo, ou un système de tickets/support).
  + Tester l’injection d’un code HTML simple pour vérifier la vulnérabilité. Par exemple, entrer `<script>alert(1)</script>` dans un champ texte et voir si un message s’affiche ou si le code est filtré. Le WAF des attaquants pourrait filtrer le mot script.
  + Contourner d’éventuels filtres en obfusquant légèrement le payload XSS. Par exemple, utiliser une syntaxe alternative comme `<img src=x onerror=alert(1)>` qui exécute du JavaScript sans utiliser le mot “script”. Le but est d’insérer un script qui se déclenchera à la consultation.
  + Inclure dans le payload un mécanisme pour exfiltrer des données du contexte administrateur. Par exemple, un script qui envoie le contenu d’un fichier sensible (ici le fichier de config chiffré vault.cfg.enc) ou le cookie de session de l’admin vers un serveur ou simplement l’affiche. (Dans le cadre du jeu, le robot admin transmettra directement la donnée cible au joueur une fois piégé.)
  + Soumettre le contenu malveillant et attendre que le robot administrateur vienne charger la page. Ce robot simulateur d’utilisateur déclenchera le JavaScript injecté.
  + Dès que le script XSS s’exécute, récupérer les informations exfiltrées. Dans notre cas, le joueur·euse obtiendra en retour une chaîne encodée correspondant au fichier de configuration secret volé sur le serveur des attaquants.

*Outils nécessaires :* Un navigateur web pour injecter le contenu. Des connaissances basiques en HTML/JS sont utiles pour formuler le payload XSS. Aucun outil additionnel n’est requis, si ce n’est éventuellement un intercepteur HTTP (comme Burp) pour peaufiner la requête, mais ce n’est pas obligatoire ici.

*Indices graduels :*
  - Indice 1 : Cherche une zone du site du C2 où tu peux poster du contenu (commentaire, message, profil). C’est souvent là que les XSS stockées se nichent.
  - Indice 2 : Si le mot `<script>` est bloqué, songe à d’autres balises pouvant exécuter du JS. Une balise image avec un onerror, ou une balise `<svg>` avec un script inclus, peuvent fonctionner tout en contournant des filtres basiques.
  - Indice 3 : Pour prouver l’impact, ton script doit extraire quelque chose de sensible. Pourquoi pas le contenu d’un fichier ou un cookie admin ? Dans ce scénario, tu peux directement viser le fichier vault.cfg.enc. Utilise un XHR/fetch pour l’obtenir et l’envoyer vers toi, ou toute autre méthode d’exfiltration. Une fois ta charge injectée, patiente : un bot “admin” passera la voir dans la minute, et si tout est en place tu recevras la donnée visée (sous forme d’une chaîne encodée).

*Flag attendu :* vault_cfg_md5=5f2d7c3a
(empreinte MD5 indicative prouvant que le fichier de config chiffré du C2 a été capturé)

=== _Coffre-Fort Chiffré_ : Cryptographie TODO A CHANGER <challenge-6>
Le joueur·euse possède maintenant le contenu du fichier de configuration du ransomware (vault.cfg.enc) récupéré grâce à l’étape précédente, cependant celui-ci est chiffré. Ce fichier contient des informations cruciales, notamment le mot de passe administrateur du ransomware. L’attaquant a utilisé un chiffrement par XOR avec une clé répétitive pour masquer ces données. La bonne nouvelle, c’est qu’on connaît probablement un morceau du texte en clair attendu, ce qui va permettre de retrouver la clé par analyse de texte clair connu (known-plaintext). En effet, beaucoup de fichiers de configuration commencent par une entête reconnaissable (par exemple CFG=). Ce défi consiste à décoder le fichier en retrouvant la clé XOR utilisée, puis à dévoiler le contenu en clair du fichier, dont le mot de passe administrateur qui servira à neutraliser le ransomware. Ce challenge démontre une méthode de cryptanalyse simple adaptée aux erreurs courantes des attaquants.

*Étapes pour résoudre le challenge :*
  + Examiner le fichier chiffré vault.cfg.enc (fourni sous forme binaire ou hexadécimale). Chercher un motif qui pourrait correspondre à un texte clair connu. Par exemple, si on suspecte que le fichier contient des paramètres, il pourrait débuter par CFG= en ASCII.
  + Vérifier cette hypothèse en XORant les premiers octets chiffrés avec les caractères attendus (CFG=). Si le texte original commence bien ainsi, le résultat de cette opération donnera la clé XOR répétée utilisée.
  + Une fois la clé déduite (par exemple une suite de 3 ou 6 octets déterminés), appliquer cette clé XOR sur l’ensemble du fichier chiffré pour le décrypter intégralement. On peut écrire un petit script, utiliser CyberChef, ou même le faire manuellement sur les premiers bytes pour vérifier.
  + Lire le contenu déchiffré. Parmi les lignes en clair, identifier le champ du mot de passe administrateur. Par exemple, on devrait voir une ligne du type `ADMIN_PASS=<mot_de_passe>`.
  + Extraire le mot de passe administrateur du ransomware découvert dans le fichier. C’est la donnée clé qui permettra d’accéder aux fonctions d’administration du malware lors du dernier défi.

*Outils nécessaires :* Un éditeur hexadécimal ou un outil de conversion (le fichier peut être fourni en hex/base64). CyberChef est très utile ici : on peut y appliquer un XOR brut en connaissant un bout du plaintext. Sinon, un script Python peut aussi faire l’affaire pour automatiser le XOR sur tout le fichier.

*Indices graduels :*
  - Indice 1 : Réfléchis à ce à quoi pourrait ressembler le contenu en clair. S’il s’agit d’un fichier de config, une signature du style CFG= ou même des accolades/brackets typiques en début de fichier sont probables.
  - Indice 2 : Une attaque known-plaintext consiste à utiliser un morceau de texte clair supposé pour déduire la clé. Essaie de XOR les premiers bytes du fichier avec CFG= (en hexadécimal ça donne 43 46 47 3D) et observe le résultat. Tu obtiens une suite de quelques octets : c’est très certainement la clé XOR répétée.
  - Indice 3 : Applique ensuite cette clé sur l’ensemble des données chiffrées (la clé tourne en boucle sur tout le fichier). Le contenu va devenir lisible. Parcours le texte obtenu : le mot de passe admin du ransomware apparaît en toutes lettres après ADMIN_PASS=. C’est cette valeur dont tu as besoin.

Flag attendu : `Aur0raVital@2025`
(mot de passe administrateur du ransomware découvert dans le fichier config)

=== Kill-Switch – Stéganographie / Analyse finale *TODO A CHANGER ?* <challenge-7>
Description du challenge : Le dernier défi consiste à neutraliser l’attaque en cours. Grâce au mot de passe administrateur, le joueur·euse peut désormais accéder aux ressources cachées du ransomware. On lui indique qu’un “kill-switch” – un code secret permettant de désactiver le ransomware – a été dissimulé par précaution dans une image médicale. En effet, les attaquants ont caché cette clé d’arrêt dans un fichier image (thorax_xray.png) stocké dans les serveurs de l’hôpital, probablement pour s’assurer une porte de sortie. Le but est d’extraire ce message secret de l’image. Le joueur·euse découvre ainsi la technique de la stéganographie, où des données peuvent être enfouies dans un fichier anodin (ici une radiographie) sans que cela soit visible à l’œil nu. Une fois le code extrait, il pourra être entré dans la console d’urgence de l’hôpital pour arrêter immédiatement le ransomware et rétablir les services vitaux.

Étapes pour résoudre le challenge :

    Récupérer le fichier image suspect thorax_xray.png. Noter sa taille inhabituellement grande (plusieurs mégaoctets pour une simple image PNG en niveau de gris), indice qu’il contient des données cachées.

    Tenter d’extraire les données cachées. Pour cela, utiliser des outils de stéganographie. Par exemple, binwalk (avec l’option -e) peut détecter et extraire des fichiers imbriqués dans l’image (archives, blobs...). Alternativement, steghide peut être utilisé pour extraire un message caché dans une image, s’il a été inséré par ce moyen.

    Fournir le mot de passe administrateur (`Aur0raVital@2025`, obtenu à l’étape précédente) si l’outil d’extraction le demande. En effet, si les données ont été cachées avec un mot de passe, celui-ci sera requis pour les révéler.

    Une fois l’extraction effectuée, un fichier texte apparaît (par exemple kill_switch.txt ou hidden.conf). L’ouvrir pour lire son contenu.

    Repérer dans ce fichier la chaîne de caractères correspondant au kill-switch du ransomware. Ce code, généralement unique, est la “clé d’arrêt d’urgence” fournie par les développeurs du malware. Il suffit de l’avoir pour stopper net l’attaque.

Outils nécessaires : Des outils d’analyse de fichiers/stéganographie comme binwalk (pour détecter des données cachées dans un fichier binaire) ou steghide (pour extraire un message caché d’une image en fournissant le mot de passe). À défaut, un simple examen en hexadécimal ou l’utilisation de la commande strings sur le fichier image peut parfois révéler du texte en clair caché en fin de fichier.

Indices graduels :

    Indice 1 : Le fichier image occupe plus de 15 Mo, ce qui est énorme pour une radiographie en PNG. Cela suggère fortement la présence de données additionnelles cachées à l’intérieur (on parle de stéganographie ou de fichiers imbriqués).

    Indice 2 : Utilise binwalk avec l’option d’extraction sur l’image. Tu devrais voir qu’après les données PNG, un autre bloc de données est présent (potentiellement une archive ou un contenu steganographique). Steghide est également une bonne piste : essaie la commande steghide extract -sf thorax_xray.png.

    Indice 3 : Lorsque l’outil te le demande, entre le mot de passe admin `Aur0raVital@2025` pour déverrouiller le contenu. L’extraction devrait alors sortir un fichier texte caché. Ouvre-le : il contient la chaîne du kill-switch. C’est cette chaîne qu’il faudra fournir pour stopper le ransomware.

Flag attendu : HZ_SECOND_STOP
(code kill-switch à entrer pour neutraliser la seconde vague de l’attaque)