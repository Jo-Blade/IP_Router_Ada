with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Routage; use Routage;
with IP; use IP;

procedure test_routage is
    Erreur_Exception_Non_Levee : Exception;

    Cache : T_Cache;
    Table : T_Table;
    Table2 : T_Table;
    Table3 : T_Table;
    Fichier_Table : File_Type;          -- Fichier où est stockée la table de routage
    Fichier_Table_Bis : File_Type;      --Fichier où est sotocké la table sans route pas défaut
    Fichier_Table_Test : File_Type;     -- Fichier où est stockée la table de test correcte
    IP1 : T_IP;                         --utilisé pour le teste de Troiver_Interface
    IP2 : T_IP;
    Interface_1 : Unbounded_String;
    Interface_2 : Unbounded_String;
    --	F : File_Type;
begin

    Put_Line("début des tests");
    Put_Line("test des fonctions sur la table");

    Put_Line("test de Ajouter_Element, Vider_Table et Est_Vide");
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
    pragma Assert(Est_Vide(Tablle));


    --Tests de Initialiser_Table
    Put_Line("test de Initialiser_Table");
    Open (Fichier_Table, In_File, "table.txt");
    Initialiser_Table(Table2, Fichier_Table);
    Put_Line("print5");
    Afficher_Table(Table2);

    Open(Fichier_Table_Bis, In_File, "table_sans_route_defaut.txt");
    Put_Line("Une ligne de la table doit être ignorée pour cause de masque invalide"); --test d'une exception

    Put_Line("L'erreur Route_De_Base_Inconnue devra être raise");

    begin
        Initialiser_Table(Table3, Fichier_Table_Bis);
        raise Erreur_Exception_Non_Levee;
    exception
        when Route_De_Base_Inconnue =>
            Put_Line("L’exception a bien été soulevée");
    end;



    Vider_Table(Table2);


    --    --Tests de trouver interface
    Put_Line("test de Trouver_Interface");
    Open (Fichier_Table_Test, In_File, "table_de_test.txt");
    Initialiser_Table(Table2, Fichier_Table_Test);
    IP1 := Texte_Vers_IP(To_Unbounded_String("192.169.0.1"));
    Interface_1 := Trouver_Interface(Table2, IP1);
    pragma Assert(Interface_1 = To_Unbounded_String("eth0"));

    IP2 := Texte_Vers_IP(To_Unbounded_String("192.3.0.3"));
    Interface_2 := Trouver_Interface(Table2, IP2);
    pragma Assert(Interface_2 = To_Unbounded_String("eth2"));

    put("La fonction Trouver_Interface fonctionne bien !");
    New_Line;

    Put_Line("Fin des tests sur les Tables"); New_Line;
    Put_Line("---------------------------------------------"); New_Line;
    Put_Line("Debut des tests sur le cache");


    Put_Line("test de Initialiser_Cache_Vide et Est_Vide_Cache");
    Initialiser_Cache_Vide(Cache);
    pragma Assert(Est_Vide_Cache(Cache));
    Put_Line("Initialiser_Cache_Vide et Est_Vide_Cache fonctionnent");


    Put_Line("test de Trouver_Interface_Cache");




    Put_Line("");
    Put_Line("");
    Put_Line("##################################################");
    Put_Line("#################### ALL OK ! ####################");
    Put_Line("##################################################");
    Put_Line("");

end test_routage;
