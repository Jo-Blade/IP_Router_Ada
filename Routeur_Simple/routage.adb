with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Liste_Chainee;

package body Routage is
    
    package LC_bis is new Liste_Chainee( T_Element => Unbounded_String);
    use LC_bis;

    procedure Afficher(Element : Unbounded_String) is
    begin
        put(To_String(Element));
        New_Line;
    end Afficher;

    procedure Afficher_Table is new Pour_Chaque(Traiter => Afficher);
    
    
    
    
    -- function Initialiser_Table (Fichier : in File_Type) return T_LC is
    --     Table_Routage : T_LC;
    -- begin
    --     return Table_Routage;
    -- end Initialiser_Table;


    function Trouver_Interface (Table_Routage : in T_LC; IP : in T_IP) return Unbounded_String is
    begin
        return To_Unbounded_String("");
        -- Instanciation de Pour_Chaque avec Traiter qui prend l'ip et l'élément courant de Table_Routage
        -- On crée une variable """globale""" qui prendra la longueure maximale de masque rencontré (et valide)
        -- Idem pour une variable qui stockera le nom de l'interface
        -- On passe pour chaque élément dans traiter la condition de validité du masque et s'il passe,
        -- on stocke sa longueure et l'interface qui lui est associée
        -- Après le passage de Pour_Chaque, on renvoie l'interface
        --
        -- FAUDRA PAS OUBLIER DE RENVOYER UNE EXCEPTION SI ON NE TROUVE PAS D’INTERFACE (ce qui est censé être
        -- impossible dans le cas du routeur simple car la table contient toujours 0.0.0.0 mais ça sera utile
        -- pour le routeur avec cache)
        --
        -- il faut prendre en compte l’exception Erreur_Masque_Invalide levée dans Longueur_IP
        -- dans le code de la fonction Traiter 
        -- en affichant un message d’erreur: 
        -- "Le masque <adresse_du_masque> n’est pas un masque valide, l’interface <nom_interface> sera ignorée"
        -- et ignorer cette ligne de la table
    end Trouver_Interface;



end Routage;
