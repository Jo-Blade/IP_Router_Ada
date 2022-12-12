with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO;              use Ada.Text_IO;
with IP;                       use IP;
with Liste_Chainee;
with Str_Split;



function Initialiser_Table (Fichier : in File_Type) is
    package Split3 is
    new Str_Split (NbrArgs => 3);
    use Split3;

    package Liste_Chainee_record is new Liste_Chainee(Element => T_Valeur);
    use Liste_Chainee_record;
    Tab : T_TAB;
    Table : T_LC;
    Ligne : Unbounded_String;
    Elem : T_Valeur;
begin
    open(Fichier, In_File, "");
    loop
        Get_Line(Fichier, Ligne);
        Split(Tab,Ligne, " ");
        Texte_Vers_IP(Elem.Destination, Tab(1));
        Texte_Vers_IP(Elem.Masque, Tab(2));
        Elem.Interface_Nom := Tab(3);
        Enregistrer(Table, Elem);
    exit loop when End_Of_File(Fichier);


end Initialiser_Table;
