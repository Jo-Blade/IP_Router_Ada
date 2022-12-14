with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Liste_Chainee;

package Routage is

  -- CE TYPE DEVRAIT ÊTRE DÉFINI EN LIMITED PRIVATE
    type T_Routage_Valeur is record
        Adresse : Integer;
        Masque : Integer;
        Interface_Nom : String;
        end record;


    -- CE PACKAGE DEVRAIT ÊTRE INSTANTIÉ DANS LE BLOC PRIVATE
    package Table_Routage is new Liste_Chainee(T_Element => T_Routage_Valeur);

    -- Initialiser la table de routage avec le fichier dédié
    function Initialiser_Table (Fichier : in File_Type) return T_LC with
        Pre => Est_Present (Fichier)
        Post => not Est_Vide (Table)
            and Contient (Table, Texte_Vers_IP("0.0.0.0"), "eth0");
    
    
    function Trouver_Interface(Table_Routage : in T_LC ; IP : in T_IP) return Unbounded_String;
    
    
    
    --Afficher tous les élément de la table de routage
    procedure Afficher_Table(Table_Routage: in T_LC);
    
    
end Routage;
