Vous trouverez ici les commandes à réaliser et les fichiers à lancer pour tester les modules et fonctions du routeur simple.

Pour le module ip:
- Lancer le fichier test_ip.adb

Pour le module str_split:
- Lancer le fichier test_split.adb

Pour le module my_string:
- Lancer le fichier test_my_string.adb

Pour le module liste_chainee:
- Lancer le fichier test_liste_chainee.adb

Pour le module routage:
- Lancer test_routage.adb

Pour le module routeur_simple:
Taper les instructions suivantes dans la ligne de commande:

- Test de l'affichage des caractèristiques:
./routeur_simple -s -- les statistiques sont affichées
./routeur_simple -S --les statistiques ne sont pas affichées

- Test du fichier contenant les routes de la table de routage:
./routeur_simple -t table.txt --le test passe
./routeur_simple -t -- le test ne passe pas et lève l'erreur Erreur_Dernier_Argument
		   -- le message suivant apparait: "Le dernier argument est incorrect, il sera 
			ignoré."

- Test du fichier contenant les paquets à router:
./routeur_simple -p paquets.txt --le test passe
./routeur_simple -p -- le test ne passe pas et lève l'erreur Erreur_Dernier_Argument
		   -- le message suivant apparait: "Le dernier argument est incorrect, il sera 
			ignoré."

- Test du fichier contenant les résultats:
./routeur_simple -r resultats.txt --le test passe
./routeur_simple -r -- le test ne passe pas et lève l'erreur Erreur_Dernier_Argument
		   -- le message suivant apparait: "Le dernier argument est incorrect, il sera 
			ignoré."

- Test du paramètre inconnu:
./routeur_simple -j -- le test ne passe pas et lève l'erreur Parametre_Inconnu
		   --le message suivant apparaît: "Le (numero_paramètre) ème paramètre en entrée est
		     inconnu il sera ignoré."

- Test du nom de fichier inexistant:
./routeur_simple -t tableau.txt -- le test ne passe pas et lève l'erreur Name_Error
			   --le message suivant apparaît: "Le fichier tableau.txt n'existe pas. 
				Cette erreur est fatale."

./routeur_simple -p tableau.txt -- le test ne passe pas et lève l'erreur Name_Error
			   --le message suivant apparaît: "Le fichier tableau.txt n'existe pas. 
				Cette erreur est fatale."

- Test avec plusieurs paramètres
./routeur_simple -p -r exemple.txt -- le fichier de contenant les paquets sera -r
				 -- le test lève l'erreur Parametre_Inconnu
				 -- le message suivant apparaît: "Le (numero_paramètre) ème 		
					paramètre en entrée est inconnu il sera ignoré."

./routeur_simple -s -S -t -r exemple.txt -- les statistiques ne seront pas affichées car c'est le 	
					dernier élément de la ligne de commande qui est gardée
				       -- le fichier contenant la table sera -r
				       -- le message suivant apparaît: "Le (numero_paramètre) ème 		
					paramètre en entrée est inconnu il sera ignoré."
					
				       -- -- le message suivant apparaît: "Le (numero_paramètre) 
					ème paramètre en entrée est inconnu il sera ignoré."

./routeur_simple -t table.txt -r resultats.txt -p paquets.txt -- par défaut les statistiques vont 
								s'afficher
							   -- le test passe car tous les fichiers
								existent 