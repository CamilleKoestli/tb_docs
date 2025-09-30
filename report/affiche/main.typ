/*
 Vars
*/
#import "../vars.typ": *

/*
 Includes
*/
#import "template/affiche.typ": affiche
#show: affiche.with(
  title: TBtitle, 
  dpt: "ISC",
  filiere_short: "ISC",
  filiere_long: TBfiliere,
  orientation: "ISCS",
  author: TBauthor,
  supervisor: TBsupervisor,
  industryContact: TBindustryContact,
  industryName: TBindustryName,
)

// = Contexte
// #lorem(100)

// = Objectifs
// #lorem(150)

// = Résultats
// #lorem(50)

// #lorem(50)

// = Conclusion
// #lorem(100)
// 

//TODO à terminer
= Contexte et enjeux

Le jeu pédagogique *"Shana a disparu"*, développé par le pôle Y-Security de la HEIG-VD, a rencontré un grand succès auprès du public en proposant une initiation au ethical hacking grâce à une histoire immersive. Cependant, la majorité des participant·e·s ayant terminé ce scénario, il devient nécessaire de développer un nouveau jeu proposant des défis techniques plus avancés tout en maintenant l'accessibilité aux débutants. Ce projet vise à créer un nouveau scénario sur la plateforme _CyberGame_, *"Blackout dans le Centre Hospitalier Horizon Santé"*, qui plonge les joueur·euse·s dans une situation de crise réelle, tout en leur permettant d'acquérir des compétences pratiques en cybersécurité.

// La sensibilisation aux risques numériques est devenue un enjeu majeur dans notre société, où les cyberattaques se multiplient et touchent aussi bien les particuliers que les organisations. Pour répondre à ce défi, les serious games offrent une approche innovante et motivante, permettant d’apprendre la cybersécurité par la pratique à travers des situations réalistes. Ce projet s’inscrit dans la continuité du jeu pédagogique *"Shana a disparu"* et vise à développer un nouveau scénario d’ethical hacking, intégré à la plateforme _CyberGame_, afin de toucher un public encore plus large.

= Le scénario "Blackout"
L’objectif principal du projet est de concevoir et de développer un scénario original combinant narration immersive et défis techniques progressifs. Le nouveau scénario plonge le joueur dans une situation de crise inspirée d'incidents réels. Le Centre Hospitalier Horizon Santé subit une attaque par ransomware qui paralyse ses systèmes informatiques et met en danger la vie de patients en salle d'opération. Dans la peau d'un membre de l'équipe de cybersécurité, le joueur doit résoudre sept challenges techniques progressifs pour infiltrer le système des attaquants, supprimer les données sensibles volées des patients et bloquer toute nouvelle tentative d'intrusion. Chaque étape aborde une thématique de la cybersécurité, comme l’OSINT, l’exploitation web, l'exploitation de failles de contrôle d'accès, la cryptographie, le reverse engineering, une attaque XSS ou encore la défense et l’analyse des logs. L’objectif est à la fois pédagogique et pratique : sensibiliser aux menaces numériques tout en transmettant des compétences concrètes.

Le parcours couvre l'analyse forensique d'emails de phishing, l'injection SQL pour contourner un portail frauduleux, l'exploitation de failles de contrôle d'accès, la cryptanalyse de fichiers protégés, le reverse engineering de scripts obfusqués, une attaque XSS pour détourner un bot administrateur, et enfin l'analyse de logs pour identifier et bloquer l'attaquant.

= Objectifs
Le joueur ou la joueuse est placé·e dans un contexte de crise, celui d’un hôpital victime d’une attaque par ransomware, et doit résoudre une série de sept challenges pour identifier l’attaquant, analyser les indices, exploiter des vulnérabilités et finalement mettre en place des contre-mesures. Chaque étape aborde une thématique clé de la cybersécurité, comme l’OSINT, l’exploitation web, la cryptographie, le reverse engineering ou encore la défense et l’analyse des journaux. L’objectif est à la fois pédagogique et pratique : sensibiliser aux menaces numériques tout en transmettant des compétences concrètes.

= Résultats
Le projet a permis de produire un serious game scénarisé, réutilisable et intégré de manière fluide à la plateforme existante. L’architecture technique repose sur une stack robuste combinant un frontend interactif, un backend basé sur Express, une gestion centralisée via Docker et Traefik, ainsi que des outils spécifiques comme un bot Puppeteer pour certains challenges. Les tests unitaires réalisés avec Jest ont garanti la fiabilité des composants, tandis que les tests utilisateurs ont permis d’identifier les points forts et les aspects à améliorer. Les retours ont souligné la richesse de l’immersion, la cohérence de l’histoire et la pertinence des thématiques choisies, tout en mettant en lumière la nécessité de simplifier certains indices et d’ajuster la difficulté pour les débutants.

= Implémentation et validation

L'implémentation s'appuie sur l'architecture existante de la plateforme CyberGame avec un frontend développé en HTML, CSS et JavaScript utilisant le framework Phaser, un backend Node.js avec Express, et des bases de données MongoDB et MySQL orchestrées par Docker. Plusieurs innovations techniques enrichissent l'expérience pédagogique, notamment un IDE Python embarqué fonctionnant avec Pyodide permettant d'exécuter du code directement dans le navigateur, des terminaux SSH interactifs pour accéder à des environnements isolés, et un système de bot automatisé simulant des interactions réalistes pour le challenge XSS. La validation des réponses repose sur un système sécurisé utilisant des hash SHA3-256 stockés côté serveur. Le projet a nécessité 445 heures de développement et a été validé par des tests unitaires avec Jest ainsi que des tests utilisateurs impliquant des profils variés, du débutant complet au joueur avancé en cybersécurité.

= Impact et perspectives

Les tests utilisateurs révèlent des résultats encourageants adaptés aux différents niveaux de compétence. Les profils avancés ont apprécié la diversité technique des challenges et la cohérence narrative, progressant de manière fluide à travers le scénario. Les débutants, bien que confrontés à des difficultés sur certains challenges techniques, ont maintenu leur motivation et exprimé une grande satisfaction lors de la résolution des défis. Ce projet démontre le potentiel des serious games comme outil de formation accessible en cybersécurité, combinant narration immersive et apprentissage technique concret dans un environnement sans risque. L'approche ludique répond aux besoins croissants de sensibilisation aux risques numériques tout en préparant les futurs professionnels du domaine. Le scénario développé constitue une base solide pour de futures évolutions et enrichit l'offre pédagogique du pôle Y-Security.
Ce projet démontre le potentiel des serious games comme outil de formation et de sensibilisation en cybersécurité. En proposant un scénario réaliste et engageant, il permet aux joueur·euse·s d’apprendre en expérimentant directement les mécanismes d’attaque et de défense. La diversité des challenges assure une couverture complète des compétences de base à intermédiaires, rendant l’expérience accessible mais exigeante. À l’avenir, la plateforme pourra être enrichie par de nouveaux scénarios, des outils de suivi plus poussés et des fonctionnalités renforçant l’accessibilité. Ainsi, ce travail pose les bases d’un dispositif durable, évolutif et adapté à un public varié.
