--Lire les paramètres d'execution: Table, Cache, Stat, Fin.--
procedure Lire_Parametre(Commande: in String) with
        Pre => Commande = "Table" or Commande = "Cache" or Commande = "Stat" or Commande = "Fin";
