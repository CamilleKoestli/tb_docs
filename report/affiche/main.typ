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

= Contexte et enjeux

Suite au succès du jeu "Shana a disparu" du pôle Y-Security de la HEIG-VD, ce projet développe un nouveau scénario proposant des défis techniques plus avancés tout en restant accessible aux débutants comme aux joueur·euse·s expérimenté·e·s.

= Le scénario "Horizon"
Le Centre Hospitalier Horizon Santé subit une attaque par ransomware. Les attaquants menacent de publier les données des patients. Dans la peau d'un·e expert·e en cybersécurité, le joueur résout sept challenges progressifs (OSINT, exploitation web, cryptographie, reverse engineering, XSS, analyse de logs) pour infiltrer le système des attaquants et supprimer les données volées. L'objectif : sensibiliser aux menaces numériques et transmettre des compétences concrètes.
#image("imgs/terminal.png")


= Implémentation
L'architecture s'appuie sur la plateforme CyberGame orchestrée avec Docker Compose : frontend HTML/CSS/JavaScript, backend Node.js/Express, bases MongoDB et MySQL. Des fonctionnalités enrichissent l'expérience : terminaux SSH interactifs, IDE Python embarqué, et bot Puppeteer vulnérable aux attaques XSS.
#image("imgs/scenario.png")

= Résultats et perspectives

Les tests utilisateurs révèlent des résultats positifs. Les profils avancés apprécient la diversité et la cohérence narrative. Les débutants, malgré certaines difficultés, maintiennent leur motivation et expriment une grande satisfaction. Ce projet démontre le potentiel des serious games pour la formation en cybersécurité et enrichit l'offre du pôle Y-Security.

