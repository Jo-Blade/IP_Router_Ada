-- Ce module définit un type Liste_Chainee et les opérations associés

generic
type T_Element is private;

package Liste_Chainee is
    Element_Absent_Error : Exception;
    Indice_Error : Exception;

    type T_LC is limited private;

    -- Initialiser une Liste_Chainee. Elle est vide.
    procedure Initialiser(Liste: out T_LC)
        with Post => Est_Vide (Liste);


    -- Est-ce qu'une Liste est vide ?
    function Est_Vide (Liste : T_LC) return Boolean;

    -- Ajouter un nouvel élément au début d'une liste.
    procedure Ajouter_Debut (Liste: in out T_LC; Element: T_Element) 
        with Post => Taille (Liste) > 0 and then Ieme (Liste, 0) = Element;

    -- Retourner le premier élément d'une liste.
    -- Exception : Element_Absent_Error si la liste est vide
    function Premier (Liste: in T_LC) return T_Element;   


    -- Obtenir le nombre d'éléments d'une Liste. 
    function Taille (Liste : in T_LC) return Integer 
        with Post => Taille'Result >= 0 and (Taille'Result = 0) = Est_Vide (Liste);

    -- Retourner vrai ssi Element est dans Liste.
    function Est_Present (Liste: in T_LC; Element: in T_Element) return Boolean;

    -- Supprimer un élément dans une Liste.
    procedure Supprimer (Liste: in out T_LC; Element: in T_Element);


    -- Insérer un nouvel élément (Nouveau) dans la liste (Liste) après un
    -- élément existant (Element).
    -- Exception : Element_Absent_Error si Element n'est pas dans la liste
    procedure Inserer_Apres (Liste: in out T_LC; Nouveau, Element: in T_Element);

    -- Retourner l'élément à la position Indice dans la Liste.
    -- Le premier élément est à l'indice 0.
    -- Exception : Indice_Error si l'indice n'est pas valide
    function Ieme (Liste: in T_LC; Indice: in Integer) return T_Element;

    -- Supprimer tous les éléments d'une Liste.
    procedure Vider (Liste : in out T_LC) 
        with Post => Est_Vide (Liste);


    -- Appliquer un traitement (Traiter) pour chaque élement d'une Liste.
    generic
        with procedure Traiter (Element : in T_Element);
    procedure Pour_Chaque (Liste : in T_LC);

    -- Ajoute un nouvel élément dans la liste.
    -- Si un élément déja présent vérifie la condition "Selection", cet
    -- élément sera remplacé plutôt que d’en ajouter un nouveau.
    -- Cette fonction s’arrête dès la première fois que la fonction Selection
    -- renvoie True
    generic
        with function Selection (Element : in T_Element) return Boolean;
    procedure Enregistrer (Liste : in out T_LC; Element : in T_ELement);

    -- Si la liste donnée est triée selon l’ordre défini par la fonction Plus_Petit
    -- alors l’élément passé en paramètre est inséré dans la liste de façon à respecter
    -- cet ordre.
    generic
      with function Plus_Petit (a : in T_Element; b : in T_Element) return Boolean;
    procedure Inserer (Liste : in out T_LC; Element : in T_Element);

    -- Trouve le premier élément de la liste vérifiant la condition Selection
    -- et le renvoie à l’utilisateur (sans modifier la liste)
    generic
      with function Selection (Element : in T_Element) return Boolean;
    function Trouver(Liste : in out T_LC) return T_Element;

    -- Trouve le premier élément de la liste vérifiant la condition Selection
    -- puis le supprime de la liste et renvoie sa valeur
    generic
      with function Selection (Element : in T_Element) return Boolean;
    procedure Extraire (Element_Trouve : out T_Element; Liste : in out T_LC);

    private

    type T_Cellule;

    type T_LC is access T_Cellule;

    type T_Cellule is
        record
            Element : T_Element;
            Suivante : T_LC;
        end record;
    
    function Cellule_Contenant (Element: T_Element; Liste: in T_LC) return T_LC 
        with Post => Cellule_Contenant'Result /= null 
                    and then Cellule_Contenant'Result.all.Element = Element;

end Liste_Chainee;
