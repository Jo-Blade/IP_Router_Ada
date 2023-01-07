with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with IP;                        use IP;
with Liste_Chainee;


package Routage is

    type T_Table is limited private;
    type T_Cache is limited private;

    -- Exceptions
    Route_De_Base_Inconnue : Exception;
    Interface_Par_Defaut : Exception;
    Route_Pas_Dans_Cache : Exception;


    -- Initialiser avec la table de routage vide
    procedure Initialiser_Table_Vide (Table_Routage : out T_Table) 
        with Post => Est_Vide(Table_Routage);


    -- Initialiser avec le cache vide
    procedure Initialiser_Cache_Vide (Cache : out T_Cache) 
        with Post => Est_Vide_Cache(Cache);


    -- Vider la table de routage
    procedure Vider_Table (Table_Routage : in out T_Table) 
        with Post => Est_Vide (Table_Routage);


    -- Vider le cache
    procedure Vider_Cache (Cache : in out T_Cache) 
        with Post => Est_Vide_Cache (Cache);


    -- Ajouter une interface dans la table de routage
    -- Modifie l’interface existante si elle existe déjà
    procedure Ajouter_Element (Table_Routage : in out T_Table; Adresse : in T_IP; Masque : in T_IP; Interface_Nom : in Unbounded_String);


    -- Initialiser la table de routage avec le fichier dédié
    procedure Initialiser_Table (Table_Routage : out T_Table; Fichier : in File_Type) 
        with Pre => Is_Open(Fichier),
        Post => not Est_Vide (Table_Routage);


    -- Trouve l'interface correspondant à une IP dans la table de routage
    function Trouver_Interface(Table_Routage : in T_Table ; IP : in T_IP) return Unbounded_String;


    -- Trouve l'interface correspondant à une IP dans la table de routage
    function Trouver_Interface_Cache (Cache : in out T_Cache; IP : in T_IP; Politique_Cache : in Unbounded_String) return Unbounded_String;


    -- Afficher tous les élément de la table de routage
    procedure Afficher_Table(Table_Routage: in T_Table);


    -- Afficher tous les élément du cache
    procedure Afficher_Cache(Cache: in T_Cache; Politique_Cache : in Unbounded_String);


    -- Renvoie si le cache est vide ou non
    function Est_Vide_Cache (Cache : in T_Cache) return Boolean;
    

    -- Renvoie si la table est vide ou non
    function Est_Vide (Table_Routage : in T_Table) return Boolean;

    
    -- Met à jour le cache en accord avec la politique et la cohérence du cache
    procedure Mise_A_Jour_Cache(Cache : in out T_Cache; IP_A_Router : in T_IP; Capacite_Cache : in Integer;
        Politique_Cache : in Unbounded_String; Taille_Cache_Actuelle : in Integer;
        Interface_Nom : in Unbounded_String; Table : in T_Table);


private

    -- Type des cellules enregistrées dans la liste chainée représentant la table
    type T_Cellule is
        record
            Adresse : T_IP;
            Masque : T_IP;
            Interface_Nom : Unbounded_String;
        end record;

    type T_Cellule_Cache is
        record
            Adresse : T_IP;
            Masque : T_IP;
            Interface_Nom : Unbounded_String;
            Frequence : Integer;
        end record;

    package Table_LC is new Liste_Chainee(T_Element => T_Cellule);

    type T_Table is new Table_LC.T_LC;


    package Cache_LC is new Liste_Chainee(T_Element => T_Cellule_Cache);
    use Cache_LC;

    type T_Cache is new Cache_LC.T_LC;

end Routage;
