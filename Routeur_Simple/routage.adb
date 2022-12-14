with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO;               use Ada.Text_IO;
with IP;                        use IP;
with Ada.Exceptions;            use Ada.Exceptions;
with Liste_Chainee;
with Str_Split;

package body Routage is
    
    procedure Afficher_Table (Element : Unbounded_String) is
    begin
        put(To_String(Element));
        New_Line;
    end Afficher_Table;

    procedure Afficher_Table is new Pour_Chaque (Traiter => Afficher_Table);
    

    function Contient(Table_Routage : in T_Table; Adresse : in T_IP; Masque : in T_IP;
        Interface_Nom : in Unbounded_String) return Boolean is
    begin
        return True;
    end Contient;


    function Est_Vide (Table_Routage : in T_Table) return Boolean is
    begin
        return Table_Routage = Null;
    end Est_Vide;


    procedure Initialiser_Table (Table_Routage : out T_Table; Fichier : in File_Type) is
        Table_Routage : T_Table;
    begin
         return Initialiser(Table_Routage);
    end Initialiser_Table; 


    function Trouver_Interface (Table_Routage : in T_Table; IP : in T_IP) return Unbounded_String is
        -- Variables locales
        Longueur_Max : Integer;              -- Plus grande longueur de masque
        Interface_Nom : Unbounded_String;    -- Nom de l'interface vers laquelle sera routé le paquet, "eth0" de base

        -- Définition de la procedure Trouver qui s'appliquera pour chaque élément de la table de routage
        procedure Trouver (Element : T_Cellule) is
            Taille_Masque : Integer;    -- Taille du masque courant
        begin
            Taille_Masque := Longueur_IP(Element.Masque);
            if Egalite_IP(IP, Element.Adresse, Element.Masque) and then (Taille_Masque > Longueur_Max) then
                Longueur_Max := Taille_Masque;
                Interface_Nom := Element.Interface_Nom;
            else
                Null;
            end if;
            if Longueur_Max = 0 then
                raise Interface_Par_Defaut;
            else
                Null;
            end if;
        end Trouver;

        procedure Pour_Chaque_Interface is new Pour_Chaque (Traiter => Trouver);

    begin
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
        Longueur_Max := 0;
        Interface_Nom := To_Unbounded_String("eth0");
        Pour_Chaque_Interface (Table_Routage);
        return Interface_Nom;
    end Trouver_Interface;



end Routage;
