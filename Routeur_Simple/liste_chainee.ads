-- Ce module définit un type Liste_Chainee et les opérations associés

generic
	type T_Element is private;
	type T_Donnee is private;
	
package Liste_Chainee is

	type T_LC is limited private;

	-- Initialiser une Liste_Chainee. Elle est vide.
	procedure Initialiser(Liste: out T_LC) with
		Post => Est_Vide (Liste);


	-- Est-ce qu'une Liste est vide ?
	function Est_Vide (Liste : T_LC) return Boolean;


	-- Obtenir le nombre d'éléments d'une Liste. 
	function Taille (Liste : in T_LC) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Liste);


	-- Enregistrer un élément dans une Liste.
	procedure Enregistrer (Liste : in out T_LC ; Element : in T_Element ; Donnee : in T_Donnee) with
		Post => Est_Present (Liste, Element)                -- élémen insérée

	-- Supprimer un élément dans une Liste.
	procedure Supprimer (Liste : in out T_LC ; Element : in T_Element) with
		Post =>  Taille (Liste) = Taille (Liste)'Old - 1    -- un élément de moins
			and not Est_Present (Liste, Element);           -- l'élément a été supprimée


	-- Savoir si un Element est présent dans une Liste.
	function Est_Present (Liste : in T_LC ; Element : in T_Element) return Boolean;


	-- Obtenir la donnée associée à un Element dans la Liste.
	function La_Donnee (Liste : in T_LC ; Element : in T_Element) return T_Donnee;


	-- Supprimer tous les éléments d'une Liste.
	procedure Vider (Liste : in out T_LC) with
		Post => Est_Vide (Liste);


	-- Appliquer un traitement (Traiter) pour chaque élement d'une Liste.
	generic
		with procedure Traiter (Element : in T_Element);
	procedure Pour_Chaque (Liste : in T_LC);

private

	type T_Cellule;

	type T_LC is access T_Cellule;

	type T_Cellule is
		record
			Element : T_Element;
			Suivant : T_LC;
		end record;

end Liste_Chainee;
