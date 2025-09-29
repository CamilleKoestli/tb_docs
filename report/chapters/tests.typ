= Tests <tests>

#include "tests-unitaires.typ"
#pagebreak()
#include "tests-utilisateurs.typ"
#pagebreak()

== Résultats et bilan des tests <resultats-bilan-tests>
Le test progressif avec l’alpha testeur a permis de valider assez rapidement la solidité technique de chaque challenge et de corriger des incohérences de l'histoire ou des bugs de développement. Les premiers retours ont permis d'ajuster les indices, de clarifier certaines étapes et de rendre le jeu plus accessible aux débutant·e·s.

Par la suite, les tests finaux ont révélé des différences assez importantes dans l'expérience utilisateur selon le niveau de compétence des participant·e·s. Les personnes avec des connaissances avancées en informatique ont généralement progressé de manière fluide à travers les premiers challenges, sans vraiment utilisé les indices. Ils ont confirmé l’intérêt du scénario et la pertinence technique des défis. Tandis que les participant·e·s débutant·e·s ont rencontré beaucoup plus de blocages, notamment dans la compréhension du vocabulaire technique, des concepts de base et du coup le format de réponse attendu mais aussi sur le manque de clarté sur les indices et ce qui était.

De manière générale, les tests montrent que le scénario est accessible à des débutants motivés tout en étant amusant pour des profils plus avancés. L’équilibre entre narration et des techniques à utilisées ont été jugé satisfaisant.

=== Performance par niveau de compétence
Pour mieux analyser les résultats, les participant·e·s ont été regroupé·e·s en deux catégories selon leur niveau de compétence en informatique : avancé·e·s et débutant·e·s. 

Les joueur·euse·s avancé·e·s avaient une bonne maîtrise des concepts de base en programmation et en sécurité informatique. Ils ont été très rapidement autonomes dans la résolution des challenges. Des principales observations ont pu être faites : le temps de résolution était généralement inférieur aux estimations initiales, l'utilisation des indices était limitée, car ils préféraient explorer par eux-mêmes et trouver la solution et enfin une grande appréciation au niveau de l'aspect narratif qui a permis de développer les compétences techniques tout en restant motivé.

En ce qui concerne les joueur·euse·s débutant·e·s, ils n'avaient aucune connaissances en programmation et très peu, de manière générale, en informatique. Leur expérience a été plus variée et a mis en lumière plusieurs points d'amélioration possibles. Ces testeurs·euses ont montré un parcours plus contrasté : ils avaient besoin de plus de temps pour comprendre les consignes et les concepts de base et donc d'aller régulièrement dans la boîte à outils, ils ont eu recours aux indices et les ont utilisé, à chaque fois tous, un besoin beaucoup plus grand de temps pour réaliser les challenges plus techniques, en particulier les challenges 2, 4,5 et 6. Malgré les difficultés rencontrées, ils ont exprimé une grande satisfaction lorsqu'ils réussissaient à résoudre un challenge, ce qui leur a permis de rester motivé et de progresser.

En ce qui concerne les joueur·euse·s débutant·e·s, sans connaissances en programmation et avec seulement des bases limitées en informatique, leur expérience a été plus variée et a mis en lumière plusieurs points d'amélioration possibles. Ces testeurs·euses ont montré un parcours plus contrasté : ils ont eu besoin de davantage de temps pour comprendre les consignes et les concepts fondamentaux, ce qui fait qu'ils ont consulté régulièrement la boîte à outils. Ils ont systématiquement utilisé tous les indices disponibles et ont particulièrement eu des difficultés lors des challenges les plus techniques, notamment les challenges 2, 4, 5 et 6.
Malgré les difficultés rencontrées, ils ont exprimé une grande satisfaction lorsqu'ils réussissaient à résoudre un challenge, ce qui leur a permis de rester motivé et de progresser, même après plusieurs essais.

=== Points forts identifiés
Plusieurs aspects du projet ont été particulièrement appréciés par les participant·e·s, quel que soit leur niveau de compétence.

Dans un premier temps, le scénario et la narration. L'immersion narrative a été appréciée par tout le monde et a permis de contextualiser les défis techniques. La progression de l'histoire maintient la motivation des joueur·euse·s et les éléments de storytelling facilitent la mémorisation des concepts abordés.

Ensuite, la diversité des challenges. La variété des types de défis (exploitation de vulnérabilités web, analyse de fichiers, reverse engineering, etc.) a été appréciée pour maintenir l'intérêt et découvrir un large champ de compétences en cybersécurité, que ce soit au niveau de l'attaque mais aussi à l'aide d'un challenge défensif.

Enfin, la plateforme technique. L'utilisation de ngrok a permis des tests à distance sans friction technique majeure et sans avoir à forcer les participant·e·s à se déplacer. Aucun gros problème de stabilité n'a été rencontré durant les sessions. L'interface utilisateur a été jugée claire et intuitive, facilitant la navigation entre les différents challenges. Enfin, un dernier élément relevé par tous les participant·e·s est la simplicité d’utilisation grâce à l’accès direct grâce à un navigateur, sans installation supplémentaire de logiciel. Cela a contribué à rendre l’expérience plus accessible et à réduire les obstacles techniques.

=== Points faibles et pistes d'amélioration <faibles-amelioration>

Concernant les points faibles, plusieurs aspects ont été identifiés et pourraient être améliorés par la suite.

Le premier point concerne les indices et consignes. Certains indices ont été jugés pas assez compréhensibles, ce qui rendait la compréhension difficile pour certain·e·s ou au contraire trop explicites et du coup trop facile. Le vocabulaire technique dans certaines consignes a aussi été un obstacle pour les débutant·e·s. Les joueur·euse·s devaient régulièrement trouver les informations dans la boîte à outils, ce qui a parfois interrompu le flux de jeu. Un dernier éléments souligné par les participant·e·s a été aussi la boîte à outils, qui était jugée très dense et complexe, rendant la recherche d'informations plus difficile.

Ensuite, la difficulté de certains challenges. Quelques défis ont été trop complexes pour les débutant·e·s, en particulier ceux qui demandent des connaissances spécifiques en programmation ou en sécurité informatique. Des blocages assez longs ont été remarqués sur ces challenges spécifiques, et mon intervention a été nécessaire. Un meilleur équilibrage de la difficulté pourrait être envisagé pour rendre l'expérience plus fluide.

Des améliorations ont été apportées lors de la réalisation des tests, en reformulant certaines consignes, en ajustant la difficulté de certains challenges et en complétant les indices pour les rendre plus utiles et pertinents. Cependant, il reste encore des pistes d'amélioration à explorer.

Plusieurs pistes d’amélioration ont été identifiées pour les améliorations du jeu mais aussi de la plateforme. L’ajout de fonctionnalités de suivi des progrès des joueurs pourrait leur permettre de voir une meilleure progression sur les jeux. La boîte à outils pourrait également être simplifiée et mieux intégrée pour faciliter la recherche d'informations, par exemple en mettant directement l'accès aux informations précises dans la consigne ou dans le défi. Lors du tests, tous les indices étaient visibles, il faudrait les cacher pour qu'ils soient visibles au fur et à mesure des besoins. Enfin, la mise en place d’un système de feedback continu permettrait de recueillir des retours en temps réel et d’ajuster le scénario de manière plus dynamique.
