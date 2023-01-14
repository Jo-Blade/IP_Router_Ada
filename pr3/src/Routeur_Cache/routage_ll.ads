with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with IP;                        use IP;
with Liste_Chainee;

with Routage;


package Routage_LL is

    type T_Table is limited private;

    -- Exceptions
    Route_De_Base_Inconnue : Exception;
    Interface_Par_Defaut : Exception;
    Interface_Non_Trouve : Exception;


    -- Initialiser avec le cache vide
  procedure Initialiser_Table_Vide (Table_Routage : out T_Table) 
    with Post => Est_Vide(Table_Routage);


    -- Vider le cache
    procedure Vider_Table (Table_Routage : in out T_Table) 
      with Post => Est_Vide (Table_Routage);


    -- Trouve l'interface correspondant à une IP dans la table de routage
    procedure Trouver_Interface_Cache (Interface_Nom: out Unbounded_String; Table_Routage : in out T_Table; IP : in T_IP; Politique_Cache : in Unbounded_String);


    -- Afficher tous les élément du cache
    procedure Afficher_Cache(Cache: in T_Table; Politique_Cache : in Unbounded_String);


    -- Renvoie si le cache est vide ou non
    function Est_Vide (Table_Routage : in T_Table) return Boolean;
    

    -- Met à jour le cache en accord avec la politique et la cohérence du cache
    procedure Mise_A_Jour_Cache(Cache : in out T_Table; IP_A_Router : in T_IP; Capacite_Cache : in Integer;
        Politique_Cache : in Unbounded_String; Taille_Cache_Actuelle : in Integer;
        Interface_Nom : in Unbounded_String; Table : in Routage.T_Table);


private

    -- Type des cellules enregistrées dans la liste chainée représentant la table
    type T_Cellule_Cache is
        record
            Adresse : T_IP;
            Masque : T_IP;
            Interface_Nom : Unbounded_String;
            Frequence : Integer;
        end record;


    package Cache_LC is new Liste_Chainee(T_Element => T_Cellule_Cache);
    use Cache_LC;

    type T_Table is new Cache_LC.T_LC;

end Routage_LL;
