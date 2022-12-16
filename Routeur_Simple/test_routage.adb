with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Routage; use Routage;
with IP; use IP;

procedure test_routage is
	Table : T_Table;
	Table2 : T_Table;
    Fichier_Table : File_Type;          -- Fichier où est stockée la table de routage
    IP1 : T_IP;                         --utilisé pour le teste de Troiver_Interface
    IP2 : T_IP;
    Interface_1 : Unbounded_String;
    Interface_2 : Unbounded_String;
--	F : File_Type;
begin
  Put_Line("début des tests");
  Put_Line("print1");
  Afficher_Table(Table);

  Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("192.168.1.200")),
  Texte_Vers_IP(To_Unbounded_String("255.255.255.0")), To_Unbounded_String("eth0"));
  Put_Line("print2");
  Afficher_Table(Table);

  Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("192.168.1.200")),
  Texte_Vers_IP(To_Unbounded_String("255.255.0.0")), To_Unbounded_String("eth0"));
  Put_Line("print3");
  Afficher_Table(Table);
--

  Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("192.168.1.200")),
  Texte_Vers_IP(To_Unbounded_String("255.255.255.0")), To_Unbounded_String("eth1"));
  Put_Line("print4");
  Afficher_Table(Table);

  Vider_Table(Table);

  Open (Fichier_Table, In_File, "input.txt");
  Initialiser_Table(Table2, Fichier_Table);
  Put_Line("print5");
  Afficher_Table(Table2);

  Put_Line("print6");
  Put_Line(To_String(Trouver_Interface(Table2, Texte_Vers_IP(To_Unbounded_String("192.169.2.20")))));

  Put_Line("print6");
  Put_Line(To_String(Trouver_Interface(Table2, Texte_Vers_IP(To_Unbounded_String("12.169.10.20")))));

  Vider_Table(Table2);
--
--
--    --Tests de trouver interface

    Open(Fichier_Table, In_File, "table.txt");
    Initialiser_Table(Table2, Fichier_Table);
    IP1 := Texte_Vers_IP(To_Unbounded_String("192.169.0.1"));
    Interface_1 := Trouver_Interface(Table2, IP1);
    pragma Assert(Interface_1 = To_Unbounded_String("eth0"));

    IP2 := Texte_Vers_IP(To_Unbounded_String("192.3.0.3"));
    Interface_2 := Trouver_Interface(Table2, IP2);
    pragma Assert(Interface_2 = To_Unbounded_String("eth2"));

    put("La fonction Trouver_Interface fonctionne bien !");
    New_Line;




--    --Tests de l'initilsiation de la table
--	Create(F, Out_File, "test_initialiser_table", "");
--	Put(F, "147.127.127 255.255.255.0 eth0");
--	Put(F,"147.128.0.0 255.255.0.0 eth1");
--	Put(F,"0.0.0.0 0.0.0.0 eth2");
--	Table:= Initialiser_Table(F);
--	Pragma Assert(Table.all.Element.Destination=Test_Vers_IP(To_Unbounded_String("147.127.127")));
--	Pragma Assert(Table.all.Element.Masque=Test_Vers_IP(To_Unbounded_String("255.255.255.0")));
--	Pragma Assert(Table.all.Element.Interface_Nom=Test_Vers_IP(To_Unbounded_String("eth0")));
--	Table:= Table.all.Suivant;
--	Pragma Assert(Table.all.Element.Destination=Test_Vers_IP(To_Unbounded_String("147.128.0.0")));
--	Pragma Assert(Table.all.Element.Masque=Test_Vers_IP(To_Unbounded_String("255.255.0.0")));
--	Pragma Assert(Table.all.Element.Interface_Nom=Test_Vers_IP(To_Unbounded_String("eth1")));
--	Table:= Table.all.Suivant;
--	Pragma Assert(Table.all.Element.Destination=Test_Vers_IP(To_Unbounded_String("0.0.0.0")));
--	Pragma Assert(Table.all.Element.Masque=Test_Vers_IP(To_Unbounded_String("0.0.0.0")));
--	Pragma Assert(Table.all.Element.Interface_Nom=Test_Vers_IP(To_Unbounded_String("eth2")));
--    Close(F);
--
--    --Tests de l'Affichage de la table
--    --Visualisation de table et vérification de son contenu
--	Create(F, Out_File, "test_initialiser_table", "");
--	Put(F, "147.127.127 255.255.255.0 eth0");
--	Put(F,"147.128.0.0 255.255.0.0 eth1");
--    Put(F,"0.0.0.0 0.0.0.0 eth2");
--    Table:= Initialiser_Table(F);
--    Afficher_Table(Table);
--    Close(F);
--
end test_routage;
