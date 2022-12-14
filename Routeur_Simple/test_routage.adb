with Text_IO; use Text_IO;
with Initialiser_Table; use Initialiser_Table;
with IP; use IP;

procedure test_routage is
	Table : T_LC;
	F : File_Type;
begin

    --Tests de trouver interface



    --Tests de l'initilsiation de la table
	Create(F, Out_File, "test_initialiser_table", "");
	Put(F, "147.127.127 255.255.255.0 eth0");
	Put(F,"147.128.0.0 255.255.0.0 eth1");
	Put(F,"0.0.0.0 0.0.0.0 eth2");
	Table:= Initialiser_Table(F);
	Pragma Assert(Table.all.Element.Destination=Test_Vers_IP(To_Unbounded_String("147.127.127")));
	Pragma Assert(Table.all.Element.Masque=Test_Vers_IP(To_Unbounded_String("255.255.255.0")));
	Pragma Assert(Table.all.Element.Interface_Nom=Test_Vers_IP(To_Unbounded_String("eth0")));
	Table:= Table.all.Suivant;
	Pragma Assert(Table.all.Element.Destination=Test_Vers_IP(To_Unbounded_String("147.128.0.0")));
	Pragma Assert(Table.all.Element.Masque=Test_Vers_IP(To_Unbounded_String("255.255.0.0")));
	Pragma Assert(Table.all.Element.Interface_Nom=Test_Vers_IP(To_Unbounded_String("eth1")));
	Table:= Table.all.Suivant;
	Pragma Assert(Table.all.Element.Destination=Test_Vers_IP(To_Unbounded_String("0.0.0.0")));
	Pragma Assert(Table.all.Element.Masque=Test_Vers_IP(To_Unbounded_String("0.0.0.0")));
	Pragma Assert(Table.all.Element.Interface_Nom=Test_Vers_IP(To_Unbounded_String("eth2")));
    Close(F);

    --Tests de l'Affichage de la table
    --Visualisation de table et vérification de son contenu
	Create(F, Out_File, "test_initialiser_table", "");
	Put(F, "147.127.127 255.255.255.0 eth0");
	Put(F,"147.128.0.0 255.255.0.0 eth1");
    Put(F,"0.0.0.0 0.0.0.0 eth2");
    Table:= Initialiser_Table(F);
    Afficher_Table(Table);
    Close(F);

end test_routage;
