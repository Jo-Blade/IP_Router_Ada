with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with IP;                        use IP;
with Liste_Chainee;

package Routage is

  type T_Table is limited private;


  -- Initialiser la table de routage avec le fichier dédié
  procedure Initialiser_Table (Table_Routage : out T_Table; Fichier : in File_Type) with
  Pre => Is_Open(Fichier),
  Post => not Est_Vide (Table_Routage);
--  and Contient (Table_Routage, Texte_Vers_IP(To_Unbounded_String("0.0.0.0")), Texte_Vers_IP("0.0.0.0"), "eth0");

  function Trouver_Interface(Table_Routage : in T_Table ; IP : in T_IP) return Unbounded_String;

  --Afficher tous les élément de la table de routage
  procedure Afficher_Table(Table_Routage: in T_Table);

  function Contient(Table_Routage : in T_Table; Adresse : in T_IP) return Boolean;

  function Contient(Table_Routage : in T_Table; Adresse : in T_IP; Masque : in T_IP) return Boolean;

  function Contient(Table_Routage : in T_Table; Adresse : in T_IP; Masque : in T_IP;
    Interface_Nom : in Unbounded_String) return Boolean;

	function Est_Vide (Table_Routage : in T_Table) return Boolean;

  private

  type T_Cellule is
    record
      Adresse : Integer;
      Masque : Integer;
      Interface_Nom : Unbounded_String;
    end record;

  package Table_LC is new Liste_Chainee(T_Element => T_Cellule);
  use Table_LC;

  type T_Table is new T_LC;

end Routage;
