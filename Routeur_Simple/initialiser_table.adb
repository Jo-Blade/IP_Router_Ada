with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO;              use Ada.Text_IO;
with IP;                       use IP;
with Liste_Chainee;
with Str_Split;



function Initialiser_Table (Fichier : in File_Type) is
    package Split3 is new Str_Split(NbrArgs => 3);
    use Split3;

    package Liste_Chainee_record is new Liste_Chainee(Element => T_Routage_Valeur);
    use Liste_Chainee_record;

    tab : T_TAB; --tableau pour la fonction texte_vers_ip
    table : T_LC; --liste chainee pour le renvoie
    ligne : Unbounded_String;
    elem : T_Routage_Valeur;
begin
    open(Fichier, In_File, "");  --ouverture du fichier
    loop
        Get_Line(fichier, ligne);  --recupération de la ligne courante
        Split(tab,ligne, " ");  --séparation des éléments
        Texte_Vers_IP(elem.Destination, tab(1)); -- transformation en IP et affectation à elem
        Texte_Vers_IP(elem.Masque, tab(2));
        Elem.Interface_Nom := tab(3); -- affectation de l'interface dans la dernière case de elem
        Enregistrer(table, tlem); --enregistrement de elem danss la table
        ligne := ligne + 1;
    exit when End_Of_File(fichier);
    end loop;
    return table;
end Initialiser_Table;
