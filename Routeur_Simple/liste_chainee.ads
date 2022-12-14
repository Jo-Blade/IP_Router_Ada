-- Ce module définit un type Liste_Chainee et les opérations associés

generic
	type T_Element is private;
	
package Liste_Chainee is

	type T_LC is limited private;

	-- Initialiser une Liste_Chainee. Elle est vide.
	procedure Initialiser(Liste: out T_LC) with
		Post => Est_Vide (Liste);


	-- Est-ce qu'une Liste est vide ?
	function Est_Vide (Liste : T_LC) return Boolean;

    -- Ajouter un nouvel élément au début d'une liste.
    procedure Ajouter_Debut (Liste: in out T_LC; Element: T_Element) with
        Post => Taille (Liste) > 0 and then Ieme (Liste, 0) = Element;
        
     -- Retourner le premier élément d'une liste.
     -- Exception : Element_Absent_Error si la liste est vide
    function Premier (Liste: in T_LC) return T_Element;   
        
        
	-- Obtenir le nombre d'éléments d'une Liste. 
	function Taille (Liste : in T_LC) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Liste);

    -- Retourner vrai ssi Element est dans Liste.
    function Est_Present (Liste: in T_LC; Element: in T_Element) return Boolean;

	-- Supprimer un élément dans une Liste.
	procedure Supprimer (Liste : in out T_LC ; Element : in T_Element) with
		Post =>  Taille (Liste) = Taille (Liste)'Old - 1    -- un élément de moins
			and not Est_Present (Liste, Element);           -- l'élément a été supprimée


    -- Insérer un nouvel élément (Nouveau) dans la liste (Liste) après un
    -- élément existant (Element).
    -- Exception : Element_Absent_Error si Element n'est pas dans la liste
    procedure Inserer_Apres (Liste: in out T_LC; Nouveau, Element: in T_Element);

    -- Retourner l'élément à la position Indice dans la Liste.
    -- Le premier élément est à l'indice 0.
    -- Exception : Indice_Error si l'indice n'est pas valide
    function Ieme (Liste: in T_LC; Indice: in Integer) return T_Element;

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
			Suivante : T_LC;
		end record;
    function Cellule_Contenant (Element: T_Element; Liste: in T_LC) return T_LC with
        Post => Cellule_Contenant'Result /= null
        and then Cellule_Contenant'Result.all.Element = Element;
end Liste_Chainee;
