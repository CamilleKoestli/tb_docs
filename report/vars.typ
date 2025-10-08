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
Les cyberattaques contre les infrastructures critiques, comme les hôpitaux, se multiplient. Les ransomwares perturbent gravement le fonctionnement des établissements de santé et mettent en danger la vie des patients. Face à ces menaces, la sensibilisation et la formation du personnel deviennent essentielles.

Ce projet s'inscrit dans la continuité du serious game "Shana a disparu", développé par la HEIG-VD pour initier le public à la cybersécurité. L'objectif était de concevoir un nouveau scénario immersif qui permet de faire découvir à un large public les mécanismes d'une cyberattaque et d'apprendre à y réagir de manière ludique et pédagogique.

Le scénario "Intrusion dans le Centre Hospitalier Horizon Santé" a été développé et il est composé 7 challenges techniques de difficulté progressive. Le joueur incarne un membre de l'équipe de sécurité de l'hôpital qui doit réagir rapidement face à une attaque par ransomware. Les défis abordent l'OSINT, l'analyse forensique, l'injection SQL, l'exploitation XSS, le reverse engineering et l'analyse de logs. L'implémentation s'est appuyée sur l'architecture existante (Node.js, MongoDB, MySQL) et a été enrichie avec un IDE Python embarqué, des terminaux SSH interactifs et un bot automatisé. Le projet a nécessité environ 450 heures de développement et a été validé par des tests utilisateurs.

Ce travail démontre l'efficacité des serious games pour rendre la formation en cybersécurité interactive, motivante et accessible à tous, sans installation requise.

]