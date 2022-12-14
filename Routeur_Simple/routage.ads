with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with IP;                        use IP;
with Liste_Chainee;

package Routage is

  type T_Table is limited private;


  -- Initialiser la table de routage avec le fichier dédié
  function Initialiser_Table (Fichier : in File_Type) return T_Table; -- with
    --Pre => Est_Present (Fichier),
    --Post => not Est_Vide (Table)
    --and Contient (Table, Texte_Vers_IP("0.0.0.0"), "eth0");


    function Trouver_Interface(Table_Routage : in T_Table ; IP : in T_IP) return Unbounded_String;



    --Afficher tous les élément de la table de routage
    procedure Afficher_Table(Table_Routage: in T_Table);


    private

    type T_Cellule is
      record
        Adresse : Integer;
        Masque : Integer;
        Interface_Nom : Unbounded_String;
      end record;

    package Table_Routage is new Liste_Chainee(T_Element => T_Cellule);
    use Table_Routage;

    type T_Table is new T_LC;

  end Routage;
