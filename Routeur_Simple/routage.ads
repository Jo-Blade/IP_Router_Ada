with Liste_Chainee;

package Routage is

type T_Routage_Valeur is record
    Destination : Integer;
    Masque : Integer;
    Interface_Nom : String;
    end record;


    package Table_Routage is new Liste_Chainee(T_Element => T_Routage_Valeur)

-- Initialiser la table de routage avec le fichier dédié
function Initialiser_Table (Fichier : in File_Type) return T_LC with
    Pre => Est_Present (Fichier);
    Post => not Est_Vide (Table)
        and Contient (Table, Texte_Vers_IP("0.0.0.0"), "eth0");





function Trouver_Interface(Table_Routage: T_LC ; IP: T_IP) return Unbounded_String;



end Routage;
