= Planification <planification>
== Planification initiale <planification-initiale>

//TODO A CHANGER

#table(
  columns: (auto, auto, auto, auto),
  inset: 6pt,
  align: horizon,
  stroke: 0.4pt,
  table.header(
    [*Étape*], [*Durée estimée*], [*Période*], [*Informations*],
  ),

  [1. Analyse du scénario existant], [20 h], [07 – 09 août 2025], [
    Étude des mécaniques des deux jeux, inventaire des technologies,
    analyse critique, analyse de l’architecture CyberGame.
  ],

  [2. Recherche et écriture du scénario], [45 h], [10 – 16 août 2025], [
    Inspirations CTF / serious games, sélection d’outils, méthodes pédagogiques,
    élaboration du scénario retenu.
  ],

  
 )

#block[
#figure(
  align(center)[#table(
  columns: (auto, auto, auto, auto),
  inset: 6pt,
  align: horizon,
  stroke: 0.4pt,
  table.header(
    [*Étape*], [*Durée estimée*], [*Période*], [*Informations*],
  ),



  [3. Conception et développement des challenges], [280 h],
  [17 août – 03 septembre 2025], [
    Définition des thématiques (XSS, RE, stéganographie, …), conception de
    5 – 10 challenges, développement des services, ajout éventuel d’un bot,
    clarification des consignes.
  ],

  [4. Intégration dans la plateforme CyberGame], [30 h],
  [04 – 08 septembre 2025], [
    Adaptation des contenus et déploiement au format CyberGame.
  ],

  [5. Tests et validation], [40 h], [09 – 15 septembre 2025], [
    Tests unitaires et utilisateurs, ajustement de la difficulté,
    corrections de bugs & incohérences.
  ],

  [6. Documentation technique et pédagogique], [35 h],
  [16 septembre – 06 octobre 2025], [
    Documentation par challenge (objectifs, indices, solutions), rédaction du
    scénario global, description des choix techniques, rapports de tests.
  ],

 )],
  caption: [Planification initiale],
  kind: table
  )
]
