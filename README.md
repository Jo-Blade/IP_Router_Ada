# Routeur IP en Ada

Le but de ce projet est d'écrire un routeur IP simplifié avec le langage Ada pour le cours de Programmation Impérative.
Je vous conseille de lire les [consignes détaillées](./Cregut_gdrive/pim-1sn-2022-pr-03-sujet.pdf) pour mieux comprendre.

Vous pouvez également lire [le rapport de projet](./pr3/rapport.pdf) pour en savoir plus sur ce qui a été fait.

## Exécuter le projet

Compiler avec `gnatmake -gnata -gnatwa` tous les fichiers source dans les dossier
- Routeur_Simple : code source du routeur sans système de cache
- Routeur_Cache : code source du routeur avec un cache sous forme de liste chainée
- Routeur_LA : code source du routeur avec un cache sous forme d'arbre binaire de recherche

Veuillez vous référer au [manuel utilisateur](./pr3/manuel.pdf) pour plus de détails

## Tests unitaires

L'ensemble des fonctions du projet sont testées par des tests unitaires. Il s'agit de tous les fichiers sources dont le nom commence par `test_<nom_module>.adb`. Un test réussi doit se terminer en affichant "ALL OK" dans le terminal.
