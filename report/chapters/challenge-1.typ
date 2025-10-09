== Challenge 1 _Mail Contagieux_ : OSINT et forensic email<ch-1>

=== Description
Ce premier défi montre au joueur·euse un email de phishing qui serait à l’origine de l’attaque. Il s’agit d’un message piégé, qui aurait été envoyé par le support d’Horizon Santé avec en pièce jointe, un fichier malveillant `planning_salle_op.xlsx`. Le but est d’analyser les en-têtes techniques de cet email pour remonter à son véritable expéditeur et identifier le domaine frauduleux utilisé par les attaquants. \
Ce challenge a pour objectif de sensibiliser aux signes d’un courriel d’hameçonnage.

Voici le message que va recevoir le joueur·euse pour introduire le challenge :
"_Un courriel suspect a été trouvé dans la boîte de réception d'un employé. Les équipes techniques de cybersécurité pensent qu'il pourrait s'agir du point d'entrée des attaquants. Analysez-le pour identifier le *domaine malveillant* utilisé par les attaquants._"

*Étapes pour résoudre le challenge :*
+ Ouvrir le fichier `planning_salle_op.eml` dans l’IDE.
+ Examiner les lignes commençant par `Received:` (du bas vers le haut) afin de trouver l’adresse IP d’origine de l’envoi. Repérer également l’en-tête `Return-Path:` qui contient le domaine de l’expéditeur.
+ Identifier dans la première ligne `Received:` l’IP source et dans le `Return-Path` le nom de domaine utilisé par l’expéditeur.
+ Effectuer une recherche WHOIS sur ce nom de domaine pour vérifier s’il est légitime ou s’il s’agit d’un domaine malveillant créé pour l’attaque.

*Outils nécessaires :* Les outils nécessaires pour ce défi sont un éditeur de texte/IDE pour afficher les en-têtes de l’email, et un service WHOIS/OSINT en ligne pour vérifier le domaine.

*Indices graduels :*
- Le premier indice suggère de se concentrer sur les premiers en-têtes `Received:`. La véritable origine de l’email est souvent dans la ligne la plus basse, car c’est le premier serveur à avoir reçu le message. "_La véritable origine est souvent dans la dernière ligne `Received:`, en bas de la liste._"
- Le second indice indique que l’expéditeur imite le sous-domaine support d’Horizon Santé, mais un détail dans le nom de domaine trahit la fraude. Il faut donc regarder attentivement le domaine après le `@`. "_L’expéditeur imite un sous-domaine du support Horizon Santé, mais un détail dans le nom trahit la fraude._"
- Le troisième indice rappelle de vérifier la réputation du domaine suspect via un service WHOIS/OSINT. On découvre que le domaine ressemble à `horizonsante.com`, mais il a été enregistré récemment et est signalé comme malveillant. "_Vérifie la réputation du domaine suspect sur un service WHOIS/OSINT._"

*Flag attendu :* Le flag serait donc le nom de domaine frauduleux utilisé par l'attaquant `horizonsante-support.com`.

Une fois le sous-domaine identifié, le joueur·euse pourra passer au défi suivant qui sera la cible pour le challenge 2.

=== Techniques et outils

Afin de rendre l’expérience plus pédagogique et d’éviter que les joueur·euse·s soient bloqué·e·s à cause du manque de connaissances, j’ai intégré plusieurs outils explicatifs directement dans le jeu. Ces outils ne donnent pas la solution des challenges, mais apportent les bases nécessaires pour comprendre et progresser.

Chaque outil suit la même logique : apporter un cadre de compréhension pour que les joueur·euse·s puissent se concentrer sur l’investigation et développer leurs compétences d’analyse. Ils permettent ainsi de faire le lien entre la théorie et la pratique des challenges, tout en rendant l’expérience plus accessible et plus formatrice.

Pour le challenge lié aux emails, un outil qui explique les notions importantes a été ajouté, comme qu’est-ce qu’un email de phishing, comment se compose une adresse email et quels sont les éléments techniques que l’on retrouve dans les en-têtes. Cet outil permet au joueur·euse de savoir où chercher les indices dans un message suspect et de mieux interpréter les informations disponibles, sans pour autant lui donner directement la réponse.

Il n'a pas eu besoin d'ajouter d'informations supplémentaires sur le WHOIS, car une base existait déjà dans la plateforme et était suffisante pour ce niveau de challenge.

