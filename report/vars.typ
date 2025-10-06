#let language = "fr"

#let studentFirstname = "Camille"
#let studentLastname = "Koestli"

#let confidential = false

#let TBtitle = "Conception d’un nouveau serious game autour du « Ethical hacking » "
#let TBsubtitle = "Extension du jeu « Shana a disparu »"
#let TByear = "2025"
#let TBacademicYears = "2025-26"

#let TBdpt = "Département des Technologies de l'information et de la communication (TIC)"
#let TBfiliere = "Filière Informatique et systèmes de communication"
#let TBorient = "Orientation Sécurité informatique"

#let TBauthor = studentFirstname + " " + studentLastname
#let TBsupervisor = "Sylvain Pasini"
#let TBindustryContact = "Sylvain Pasini"
#let TBindustryName = "Haute-Ecole d'Ingénerie et de Gestion Vaud"
#let TBindustryAddress = [
  Route de Cheseaux 1
  1401 Yverdon-les-Bains
]

#let TBresumePubliable = [
Ce travail est dans la continuité de "Shana a disparu", un jeu pédagogique en ligne visant à initier le public à l'ethical hacking via une narration immersive et des défis techniques. L'objectif est de concevoir et développer un nouveau scénario s'adressant à un large public pour renforcer la sensibilisation aux risques numériques.
Le projet comporte 7 challenges techniques de difficulté progressive intégrés dans "Blackout dans le Centre Hospitalier Horizon Santé". Ce scénario s'inspire d'attaques réelles par ransomware perturbant le fonctionnement d'un hôpital. Le joueur·euse incarne un membre du SOC devant réagir rapidement pour limiter les impacts. Les défis couvrent diverses thématiques, comme l'OSINT et l'analyse forensique d'emails de phishing, l'exploitation web par injection SQL, la gestion des accès et sessions, la cryptographie avec analyse de métadonnées, le reverse engineering de scripts obfusqués, l'exploitation XSS pour détourner un bot, et la défense via l'analyse de logs pour bloquer un attaquant.
L'implémentation s'appuie sur l'architecture existante de CyberGame, un frontend HTML/CSS/JavaScript, un backend Node.js/Express et des bases MongoDB et MySQL. De nouveaux outils enrichissent l'expérience, comme un IDE Python embarqué avec Pyodide, des terminaux SSH interactifs et un bot automatisé qui simule des interactions réalistes. La validation repose sur des tests unitaires Jest et des tests utilisateurs avec des profils variés (débutant à avancé).
Réalisé sur 450 heures, le projet produit un contenu technique, scénarisé et réutilisable, intégré à la plateforme et accessible via navigateur sans installation.
Ce projet démontre le potentiel des serious games pour la formation en cybersécurité, ce qui rend l'apprentissage interactif motivant et accessible à tou·te·s.
]