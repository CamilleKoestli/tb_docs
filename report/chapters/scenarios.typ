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
  [#link(<ch-2>)[Portail VPN Fantôme]],
  [Exploitation Web (SQL)],
  [Contourner un formulaire de connexion malgré un WAF basique pour accéder au faux VPN des pirates.],

  [3],
  [#link(<ch-3>)[Archives compromises]],
  [Web Path Traversal],
  [Exploiter un paramètre d’URL mal filtré pour remonter dans l’arborescence et récupérer l’archive volée.],

  [4],
  [#link(<ch-4>)[Clé cachée dans les commentaires]],
  [Cryptographie et métadonnées],
  [Trouver un SHA-1 dans le commentaire ZIP, brute-forcer un mot de passe.],

  [5],
  [#link(<ch-5>)[Script d’infection]],
  [Reverse Engineering],
  [Décoder une chaîne Base64 dans un script PowerShell pour révéler l’URL du serveur C2.],

  [6],
  [#link(<ch-6>)[Chat KO]],
  [Exploitation Web (XSS)],
  [Injecter un script XSS dans le chat admin du C2 pour bloquer le bot et mettre le serveur hors ligne.],

  [7],
  [#link(<ch-7>)[Blocage ciblé]],
  [Défense et journalisation],
  [Analyser les logs VPN, repérer l’IP la plus bavarde et l’ajouter à la liste noire du pare-feu.],
)


== Scénario définitif : Blackout dans le Centre Hospitalier Horizon Santé <scénario-définitif>
Le scénario définitif retenu est l'histoire 1, intitulé "Blackout dans le Centre Hospitalier Horizon Santé", et il combine les challenges des scénarios 1 et 2. Ce scénario met en scène une attaque de ransomware sur un hôpital, qui entraîne un blackout des systèmes informatiques et des services critiques. Les joueur·euse·s devront résoudre une série de défis techniques et stratégiques pour restaurer les systèmes, protéger les données sensibles et assurer la continuité des soins aux patient·e·s.

Le joueur·euse incarne un membre de l'équipe de cybersécurité de l'hôpital, qui doit faire face à une attaque de ransomware. Le scénario commence par une enquête sur un e-mail de phishing qui a permis aux attaquants de pénétrer le réseau de l'hôpital. Une fois le domaine falsifié identifié, le joueur·euse doit réussir à infiltrer un faux portail VPN mis en place par les attaquants pour exfiltrer des données.\
En explorant ce portail, le joueur·euse découvre que les pirates ont déjà volé des archives contenant des données patients sensibles. L'analyse de ces fichiers révèle la présence d'un script malveillant obfusqué qui a servi à établir la connexion avec le serveur de commande et contrôle des attaquants.\
Après avoir décodé ce script et identifié l'infrastructure C2, le joueur·euse doit neutraliser le serveur distant en exploitant une faille de sécurité. Pour terminer, il doit réaliser une analyse des logs du réseau de l'hôpital pour identifier l'adresse IP source de l'attaque et la bloquer définitivement dans le pare-feu, pour empêcher toute nouvelle tentative d'exfiltration.\
Cette progression permet au joueur·euse de vivre une investigation complète, depuis la détection initiale jusqu'à la neutralisation de la menace, en passant par l'analyse forensique et l'exploitation de vulnérabilités.

Il est important de noter que les challenges pourront être adaptés en fonction des compétences des joueur·e·s et de leur niveau d'expérience lors de l'implémentation du code. Il s'agit que d'une proposition de structure et de contenu pour le scénario. Les défis peuvent être modifiés ou ajustés pour mieux correspondre aux objectifs pédagogiques et aux compétences visées.

=== _Mail Contagieux_ : OSINT et forensic email <ch-1>
Ce premier défi montre au joueur·euse un l’e-mail de phishing qui serait l’origine de l’attaque. Il s’agit d’un message piégé, qui aurait été envoyé par le support d’Horizon Santé, avec en pièce jointe un fichier malveillant `planning_salle_op.xlsx`. Le but est d’analyser les en-têtes techniques de cet e-mail pour remonter à son véritable expéditeur et identifier le domaine frauduleux utilisé par les attaquants. \
Ce challenge a pour objectif de sensibiliser aux signes d’un courriel d’hameçonnage.

*Étapes pour résoudre le challenge :*
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


===_Portail VPN Fantôme_ : Exploitation Web (SQL) <ch-2>
Le joueur·euse a identifié le domaine frauduleux `horizonsante-support.com` et découvre qu’il héberge un faux portail VPN de l’hôpital `https://vpn.horizonsante-support.com`. Ce portail a été mis en place par les attaquants pour exfiltrer des données sous la forme d'un site légitime. Pour accéder à l’interface et progresser, il faut contourner le formulaire de connexion. Un pare-feu (WAF) a été mis en place et bloque les injections SQL évidentes, c'est-à-dire qu'il refuse par exemple les mots-clés `OR` et les commentaire `--`. Le défi consiste à exploiter une injection SQL malgré ces restrictions, afin de contourner l’authentification et d’accéder au portail des attaquants. Pour passer le contrôle de format du champ email, le joueur doit fournir une adresse e-mail valide et réaliste d’un employé de l’hôpital. Étant donné que le portail factice est conçu pour piéger les employés, il attend une adresse de l’hôpital Horizon Santé (domaine `@horizonsante.com`). Par exemple, une adresse au format `prenom.nom@horizonsante.com` correspond au schéma utilisé par de nombreuses organisations et semble crédible.\
Ce challenge sensibilise aux failles d’injection et montre qu’une protection insuffisante peut être contournée par des techniques simples.

*Étapes pour résoudre le challenge :*
+ Utiliser une adresse e-mail valide, `alice.durand@horizonsante.com`, qu'il récupère dans le challenge précédant et compléter dans le champ `Email` pour passer le contrôle de format.
+ Dans le champ `Mot de passe`, réaliser une injection SQL. Cependant, le WAF empêche d'utiliser `' OR 1=1` ou `--`. Il faut faudra donc la modifier un peu pour le contourner avec le mot de passe : `' O/**/R 1=1 #`.
+ Valider le formulaire. Une fois la connexion établie, un code de session apparaît.

*Outils nécessaires :* Un navigateur web (avec éventuellement les outils de développement pour observer les requêtes) suffisent pour ce défi. Aucune extension spécifique n’est requise, juste la saisie de la charge malveillante dans le formulaire.

*Indices graduels :*
- Le premier indice rappelle qu’il faut utiliser une adresse e-mail valide pour passer le contrôle de format. Il est suggéré d’utiliser un format plausible, comme `prenom.nom@horizonsante.com`, qui est à retrouver dans le challenge précédant.
- Le second indice indique que le WAF bloque les mots-clés `OR` et les commentaires `--`, mais qu’il existe d’autres syntaxes SQL pour les commentaires.
- Le troisième indice suggère de combiner l’astuce du commentaire au milieu de `OR` et le commentaire en fin de requête.

*Flag attendu* : Le flag `HZ-7XG4` est le code de session généré par le portail VPN une fois la connexion réussie. Il permet d'accéder aux ressources du faux portail.

Le joueur·euse peut maintenant accéder au faux portail VPN des attaquants, où il découvrira un bouton "Télécharger le rapport du jour" qui de télécharger le rapport du jour. Ce sera le point de départ du défi suivant.


=== Partage Oublié : Mauvaise configuration d’accès <ch-3>

Compétence travaillée : contrôle d’accès mal configuré, découverte d’URL
Description du challenge

Le faux portail VPN comporte un bouton « Mes documents ».
Pour les comptes de rôle reader, cette page ne montre qu’un seul PDF du jour.
Mais l’administrateur des pirates a laissé le répertoire /files/archives/ entièrement listable sur le serveur : aucune authentification n’est exigée si l’on connaît l’URL exacte.

L’objectif est de profiter de cette exposition directe — index Apache activé, pas de fichier index.html — pour découvrir et télécharger l’archive hx_srv_full_0712.tar.gz qui contient les données patients volées.

    Ce défi sensibilise à l’impact d’un simple répertoire web mal protégé : pas de vulnérabilité de code, seulement un oubli de configuration (« directory listing »).

Étapes pour résoudre le challenge

    Depuis la page « Mes documents », ouvrir les DevTools → onglet Network.

    Observer que le PDF vient de l’URL

https://vpn.horizonsante-support.com/files/reports/rapport-2025-07-15.pdf

Supprimer rapport-2025-07-15.pdf dans la barre d’adresse et valider l’URL répertoire

https://vpn.horizonsante-support.com/files/reports/

→ un index of s’affiche ; on en déduit que le serveur liste les dossiers parents.

Remonter d’un niveau :

    https://vpn.horizonsante-support.com/files/

    Le dossier archives apparaît.

    Cliquer sur archives puis télécharger hx_srv_full_0712.tar.gz.

    Décompresser l’archive ; trouver patient_audit_0712.xlsx (preuve de la fuite) et hx_dropper.zip pour le challenge suivant.

Outils nécessaires

    Navigateur web (DevTools pour voir l’URL)

    Outil de décompression .tar.gz (7-Zip, tar xzf, …)

Indices graduels

    Indice 1 : Le lien « Mes documents » pointe vers /files/reports/…. Essaie de retirer le nom du fichier pour voir le répertoire.

    Indice 2 : Si l’index Apache est visible, les dossiers parents le sont souvent aussi. Remonte d’un niveau dans l’URL.

    Indice 3 : Le dossier archives contient l’archive hx_srv_full_0712.tar.gz ; télécharge-la et décompresse-la.

FLAG attendu : patient_audit_0712.zip

(Présence de ce tableur dans l’archive prouve que l’accès non protégé a été exploité avec succès.)


=== _Clé cachée dans les commentaires_ : Cryptographie et métadonnées <ch-4>
Le joueur·euse a maintenant accès à l'archive `patient_audit_0712.zip` mais le problème est qu'il est verrouillé. Le joueur·euse doit trouver le mot de passe pour déverrouiller ce zip. En inspectant les métadonnées du ZIP, le joueur·euse découvre un commentaire contenant seulement une empreinte SHA-1 : `f7fde1c3f044a2c3002e63e1b6c3f432b43936d0`\
Les experts Blue Team ont remarqué que les pirates utilisent toujours un mot de passe de la forme : `horizon<nombre>` où `<nombre>` varie de 0 à 99 (par exemple horizon1).\
Ce challenge montre l'importance de la cryptographie et de la gestion des mots de passe, ainsi que la nécessité de vérifier les métadonnées des fichiers.

*Étapes pour résoudre le challenge :*
+ Lister les métadonnées du zip avec `zipinfo hx_dropper.zip` ou sur Windows en utilisant l'explorateur de fichiers.
+ Trouver le commentaire contenant l'empreinte SHA-1
+ Utiliser un script Python pour générer les mots de passe possibles de la forme `horizon<nombre>` et vérifier si l'un d'eux correspond à l'empreinte SHA-1 ou utiliser CyberChef pour générer les mots de passe et vérifier l'empreinte.
+ Une fois le mot de passe trouvé, déverrouiller le zip.

*Outils nécessaires :* Un éditeur de texte pour lire les métadonnées, un script Python ou CyberChef pour générer les mots de passe et vérifier l'empreinte SHA-1.

*Indices graduels :*
- Le premier indice suggère de regarder les métadonnées du zip, car elles peuvent contenir des informations utiles.
- Le second indice indique que le commentaire contient une empreinte SHA-1, ce qui signifie qu'il faut trouver le mot de passe qui correspond à cette empreinte.
- Le troisième indice rappelle que les mots de passe ont une structure spécifique, ce qui peut aider à les générer. Il est suggéré de se concentrer sur les mots de passe de la forme `horizon<nombre>` où `<nombre>` varie de 0 à 99. Avec un script Python, on peut générer les mots de passe possibles et comparer leur empreinte SHA-1 avec celle du commentaire ou utiliser CyberChef pour générer les mots de passe et vérifier l'empreinte.

*Flag attendu :* Le flag attendu est le mot de passe du zip, qui est `horizon42`.

Ce mot de passe permet de déverrouiller le zip et d'accéder au contenu du fichier `hx_dropper.ps1`.

===
// _Script d’infection_ : Reverse Engineering <ch-5>
// Le fichier `hx_dropper.ps1` est un script PowerShell. Ce script a servi à l’attaquant pour établir une connexion vers son serveur de commande et contrôle (C2) et déployer le ransomware. Cependant, il paraît brouillé, mais en réalité il contient juste une longue ligne du type :
// ```powershell
// $payload = "SQBFAE0ARAB...=="
// [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($payload))
// ```
// Le joueur doit copier la chaîne Base64, la décoder, et lire l’URL. Il s'agit d'un challenge de dé-obfuscation pour extraire l'URL du serveur C2 utilisé par les attaquants. \
// Ce challenge montre comment les attaquants camouflent leurs logiciels malveillants et comment analyser un code malveillant pour y trouver des indices.

// *Étapes pour résoudre le challenge :*
// + Ouvrir `hx_dropper.ps1` dans n’importe quel éditeur.
// + Repérer la chaîne Base64 (se termine par `==`).
// + Coller la chaîne dans CyberChef : opération "From Base64".
// + Lire la sortie : le texte affiche `https://c2.hz-cloud.net/api`.

// *Outils nécessaires* : Pour ce challenge, le joueur·euse peut utiliser CyberChef ou tout décodeur Base64 en ligne.

// *Indices graduels*
// - Le premier indice suggère de se concentrer sur les lignes qui se terminent par `=` ou `==`, car elles sont souvent du Base64.
// - Le deuxième indice indique que la chaîne Base64 est utilisée pour masquer l’URL du serveur C2. Il faut donc la décoder pour la révéler. Pour cela, on peut utiliser CyberChef ou un décodeur Base64 en ligne.
// - Le troisième indice rappelle que le résultat du décodage contiendra l’URL complète du C2 en clair.

// *Flag attendu :* Le flag de ce challenge est donc le serveur C2 `https://c2.hz-cloud.net/api` qui a été utilisé par les attaquants pour déployer le ransomware.

// Le joueur·euse sera envoyé sur le serveur pour la suite du défi.


=== 
// _Chat KO_ : Exploitation Web (XSS) <ch-6>
// Sur la console du serveur C2, la page `/admin/chat.php` affiche un forum interne. Les messages postés postés sont échappés mais le champs Pseudo est restitué tels quels sans échapper les caractère. Un bot-admin lit la page en continu, si du JavaScript s’exécute dans son navigateur, son interface se bloque et le serveur passe automatiquement en mode "hors ligne". Le défi consiste à injecter un script XSS dans le champ pseudo pour faire planter le bot. À la première exécution, le serveur affiche alors le code `C2_OFFLINE`.\
// Ce challenge illustre la gravité d’une entrée utilisateur non échappée : une simple balise suffit à neutraliser un service entier.

// *Étapes pour résoudre le challenge :*
// + Aller à la page : `https://c2.hz-cloud.net/admin/chat.php`.
// + Dans le champ Pseudo, taper d’abord un test : `<b>test</b>` et valider. Le mot test apparaît en gras, ce qui est une preuve que le HTML n’est pas échappé.
// + Remplacer par le payload JavaScript :
//   ```html
//   <script>document.body.innerHTML='C2 KO';</script>
//   ```
// + Dès que le bot recharge le chat (quelques secondes), le script s’exécute dans sa session et tout le DOM est remplacé par `C2 KO`.
// + Le serveur détecte l’erreur d’interface et renvoie dans la bannière de statut le message-code.

// *Outils nécessaires* : Ici, seul le navigateur est nécessaire.

// *Indices graduels*
// - Le premier indice rappelle que le champ Pseudo affiche le texte sans l’échapper, donc il est possible d’y insérer du HTML.
// - Le second indice indique que si le HTML passe, un `<script>…</script>` s’exécutera aussi. Cela signifie que le joueur·euse peut injecter du JavaScript dans le champ Pseudo.
// - Le troisième indice suggère de remplacer le contenu de la page par `document.body.innerHTML=` pour faire planter la console. Cela permet de neutraliser le bot en remplaçant tout le contenu de la page par un message d’erreur.

// *Flag attendu* : Le flag est donc le code `C2_OFFLINE` qui est renvoyé par le serveur pour indiquer que le C2 est hors ligne.

// Une fois le C2 hors ligne, le joueur·euse est envoyé sur le portail interne de l'hôpital pour le challenge suivant et ainsi bloquer l'attaquant.


=== _Blocage ciblé_ : Défense et journalisation <ch-7>
Maintenant que les fichiers sont supprimés du côté des attaquants, le joueur·euse doit identifier l’adresse IP de la machine de l’attaquant pour le bloquer. Le joueur·euse doit donc s'assurer qu'aucune connexion sortante ne continue d'envoyer des données. Un flux a été repéré : la même adresse IP externe a émis des milliers de requêtes vers le portail VPN de l’hôpital au cours du dernier quart d’heure (tentative d’exfiltration massive). Le joueur·euse doit donc trouver le fichier de log contenant ces requêtes, identifier l’IP la plus présente (c’est l’attaquant) et ajouter cette IP à la liste noire du pare-feu interne. Une fois l’IP bloquée, le joueur·euse recevra un message de confirmation `PATCH_OK` indiquant que le blocage a été effectué avec succès.\
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




    Dans un premier temps, le joueur analyse un e-mail de phishing afin d’identifier un sous-domaine. 
    Pas forcément un sous-domaine ? Comme tu veux, mais oui guessing de sous-domain why not !
    Une fois le sous-domaine trouvé, il doit s’y infiltrer via une injection SQL.
    Sur une plateforme trouvée, il doit se loguer sur une plateforme d'accès à des fichiers. Par contre fait attention à ce que le user ne puisse pas effectuer d'actions sur la DB autre que accéder à la plateforme en mode "lecteur". Le problème d'une injection SQL à cette étape est que c'est une vuln qui ouvre beaucoup d'attaques, donc un peu trop ouverte peut être si tôt dans le challenge. Le but ici est d'accéder à la plateforme avec des droits simples.
    Une fois à l’intérieur, il modifie les droits d’accès pour obtenir l’accès aux dossiers volés.
    Il me semble qu'on avait parlé plus de mauvais accès configuré, ce sera plus simple pour toi. Modifier les accès devient technique. Comme tu veux. Il a accès à rien d'autre.
    Il identifie ensuite le bon dossier et doit le déchiffrer pour vérifier qu’il contient bien les informations des patients.
    Exact.
    Ensuite, il modifie les cookies pour pouvoir supprimer le dossier.
    Non il se login avec un compte volé avec des droits supplémentaire à ceux récupéré lors de injection SQL. Peu importe la manière mais je mettrais soit à l'intérieur du dossier déchiffré des login SSH obfusqué (D'où le reverse?) qui permettent peut être de se connecter, ou un vol de cookie via un formulaire de rançon ?
    Dans tous les cas, il vole le cookie avec des droits++. 
    Tu peux peut être faire ça en deux étapes ? Sinon il y a que 6 challenges et ça fait court. (Dont des très simples)
    Enfin, il sécurise le réseau de l’hôpital en inscrivant l’adresse IP de l’attaquant dans le pare-feu.
    Ok

