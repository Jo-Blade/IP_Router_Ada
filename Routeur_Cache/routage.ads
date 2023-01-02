with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with IP;                        use IP;
with Liste_Chainee;


package Routage is

    type T_Table is limited private;

    -- Exceptions
    Route_De_Base_Inconnue : Exception;
    Interface_Par_Defaut : Exception;


    -- Initialiser avec la table de routage vide
    procedure Initialiser_Table_Vide (Table_Routage : out T_Table) 
        with Post => Est_Vide(Table_Routage);


    -- Vider la table de routage
    procedure Vider_Table (Table_Routage : in out T_Table) 
        with Post => Est_Vide (Table_Routage);


    -- Ajouter une interface dans la table de routage
    -- Modifie l’interface existante si elle existe déjà
    procedure Ajouter_Element (Table_Routage : out T_Table; Adresse : in T_IP; Masque : in T_IP; Interface_Nom : in Unbounded_String);


    -- Initialiser la table de routage avec le fichier dédié
    procedure Initialiser_Table (Table_Routage : out T_Table; Fichier : in File_Type) 
        with Pre => Is_Open(Fichier),
        Post => not Est_Vide (Table_Routage);


    -- Trouve l'interface correspondant à une IP dans la table de routage
    function Trouver_Interface(Table_Routage : in T_Table ; IP : in T_IP) return Unbounded_String;


    -- Afficher tous les élément de la table de routage
    procedure Afficher_Table(Table_Routage: in T_Table);


    -- Renvoie si la table est vide ou non
    function Est_Vide (Table_Routage : in T_Table) return Boolean;

    private

    -- Type des cellules enregistrées dans la liste chainée représentant la table
    type T_Cellule is
        record
            Adresse : T_IP;
            Masque : T_IP;
            Interface_Nom : Unbounded_String;
        end record;

    package Table_LC is new Liste_Chainee(T_Element => T_Cellule);
    use Table_LC;

    type T_Table is new T_LC;


end Routage;
