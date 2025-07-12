= Scénarios <scenarios> 

== Scénario réaliste : Blackout dans le Centre Hospitalier Horizon Santé <scénario-1>
Le Centre hospitalier Horizon Santé tourne sur groupe électrogène depuis trois heures : un ransomware a chiffré les serveurs cliniques, puis a sauté la barrière réseau et mis hors service le réseau électrique qui alimente le bloc opératoire. Le générateur de secours n’a plus que 68 minutes d’autonomie. Si rien n’est fait, huit opérations à cœur ouvert devront être interrompues.
Votre équipe vient d’être branchée en urgence sur le réseau isolé de l’hôpital. Votre mission : remettre les services vitaux en ligne avant la fin du compte à rebours et bloquer la seconde vague annoncée par les attaquants.

*Défis proposés et compétences travaillées*
+ Phish & Tell	OSINT + forensic e-mail	: Inspectez l’e-mail « planning_salle_op.xlsx »·.eml. • Récupérez le domaine du lien piégé, le hash SHA-256 de la pièce jointe, et l’IP C2 dissimulée dans l’image SVG. (Outils conseillés : header analysis, VirusTotal, CyberChef)
+ ICU Recon	Segmentation réseau / ICS	: L’OT de l’unité de soins intensifs est mal cloisonné. Scannez le segment 10.42.0.0/24, repérez le PLC vulnérable (port 502/Modbus), puis basculez-le dans le VLAN « quarantine » grâce au switch WebUI.
+ KillDisk Lite	Reverse-engineering léger	: Le binaire killdisk_lite.exe (32 bits) chiffre les logs. Localisez la clé XOR sur 1 octet (indice : pattern 0xAB) et écrivez un mini-script pour restaurer un fichier test.
+ Vitals DB Leak	Exploitation Web	: Le portail /vitals/report.php?id=… est vulnérable. Trouvez une UNION SELECT simple qui affiche le mot de passe du compte operator sans casser l’interface.
+ Rapid-Rules	Hardening & réponse incident :	Un micro-pare-feu (UFW) protège le trafic OT ↔ IT. Glisser-déposer les règles dans la bonne ordre pour : 1. bloquer l’IP C2 trouvée en \#1, 2. autoriser le VLAN quarantine, 3. laisser passer le flux HTTPS du portail remis en service. Capturez la sortie ufw status comme preuve.

Inspiration : hausse des rançongiciels sur les hôpitaux et leurs effets létaux, incidents Ukraine 2015 sur le réseau électrique, typologie des attaques sur infrastructures critiques.
- https://www.ibm.com/think/insights/when-ransomware-kills-attacks-on-healthcare-facilities
- https://www.cisa.gov/news-events/ics-alerts/ir-alert-h-16-056-01
- https://www.mailinblack.com/ressources/glossaire/quest-ce-quune-cyberattaque/

== Scénario aventurier : Opération "CipherFox" - Infiltration <scénario-2>

Vous êtes un espion, l’agent CipherFox, et vous travaillez sous couverture. Déguisé en consultant en fusions-acquisitions, tu occupes la suite 1903 d’un palace à Genève. Votre mission : Voler les plans de KeyWave Systems : clé matérielle FIDO2 + déverrouillage biométrique qui pourrait tuer les mots de passe classiques. Sa valeur estimée est de plusieurs millions. 
Le plan d’exfiltration se déroule en cinq étapes ; chacun correspond à un "challenge" que vous devrez résoudre  pour mener à bien la mission sans attirer l’attention de l'équipe de sécurité (SOC) de l’entreprise.

*Défis proposés et compétences travaillées*
+ Selfie compromettant	OSINT & métadonnées	: Poster discrètement un selfie sur LinkedIn pour prouver à votre officier traitant que vous êtes bien sur zone. Validez : extrayez vous-même les coordonnées GPS dans les EXIF afin de confirmer le “point de drop”.
+ Hotspot piégé	Wi-Fi / cryptanalyse :	Le réseau invité de l’hôtel sert de passerelle idéale. À partir du .pcap du handshake WPA, brute-force (liste de 1 000 mots) le mot de passe ; vous pourrez ensuite acheminer vos données chiffrées via ce hotspot.
+ Mise à jour fantôme	Reverse-engineering léger	: Préparez le faux update Adobe signé avec un certificat volé. Avant diffusion, vérifiez la clé XOR (1 octet) et décodez l’URL C2 cachée en section .rdata ; c’est votre canal de commande. 
+ SMS Pegasus	Forensic mobile :	Vous avez subtilisé une sauvegarde iPhone du PDG. Repérez dans l’archive le lien “zero-click” Pegasus ; notez le domaine et le CVE utilisés : ils serviront à surveiller ses messages chiffrés. 
+ JWT aux hormones	Web & crypto applicative :	Dans le portail R&D de Stellarys, un token JWT HS256 est protégé par la clé trop simple “stellarys2025”. Altérez la charge utile pour passer role=admin et révéler le véritable nom de couverture de l’agent qui protège le dépôt de données.

- https://www.kaspersky.com/blog/the-dark-story-of-darkhotel/15022/?utm_source=chatgpt.com
- https://www.wired.com/2014/11/darkhotel-malware/?utm_source=chatgpt.com
- https://en.wikipedia.org/wiki/Pegasus_%28spyware%29?utm_source=chatgpt.com

== Scénario science-fiction : Orbital Shield <scénario-3>

L’Acheron est un transport spatial pirate opérant dans la Ceinture de Kuiper. Son équipage t’a enlevé parce qu’ils connaissent ta réputation : ils veulent que tu craques le noyau de sécurité d’OrbitalBank, la banque décentralisée qui garde les coffres‐forts crypto de la Fédération. Plutôt que de collaborer, tu décides d'essayer de te sauver. Le seul moyen de quitter l’Acheron est une navette de secours verrouillée au pont C. Pour l’atteindre, tu dois d’abord ouvrir chaque compartiment en détournant les systèmes du vaisseau.

*Défis proposés et compétences travaillées*
+ Crypto-Cuffs	Radio & crypto sans-fil	: Tes menottes “smart cuffs” parlent en LoRa. Sniffe le trafic avec le module SDR intégré à la cellule, récupère le nonce de chiffrement et rejoue la trame “release”.
+ Écho du SAS	Exploit web embarqué	: La porte du couloir est pilotée par une page React servie sur http://172.30.0.5:8080. Elle a un champ ship_id vulnérable à l’injection NoSQL. Filtre‐le pour obtenir access=tech.
+ Drone désossé	Reverse-engineering ARM	: Un droïde de maintenance patrouille le couloir. Télécharge son firmware (drn_v2.4.bin), trouve la fonction patrol_area() et patches‐la pour qu’il ignore ta balise RFID. Reflash via le port JTAG exposé.
+ Tempête ionique	Blue teaming in situ	: Les pirates surveillent le réseau CAN du vaisseau. Déploie Suricata sur un Raspberry dissimulé, écris une règle qui isole tous les paquets contenant la signature 0xBAADF00D (balises de poursuite).
+ Navette fantôme	Crypto & automatisation	: Le tableau de bord de la navette exige un token JWT signé par la CA interne “AcheronCA”. Forge un JWT HS256, clé récupérée dans /etc/ssl/private/master.key (trouvée via le drone). Change role en pilot, lance la séquence d’éjection et mets le cap sur le portail de saut le plus proche.

== Scénario retenu <scénario-retenu>
