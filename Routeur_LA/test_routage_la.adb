with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Routage_LA; use Routage_LA;
with IP; use IP;

procedure test_routage_LA is
    --Erreur_Exception_Non_Levee : Exception;

    Table : T_Table;
    Cache : T_Table;
    Interface_Trouvee : Unbounded_String;



    procedure test_Ajouter_Element is
    begin
        put("test de la procedure Ajouter_Element"); New_Line;


        put("print 1"); New_Line;
        Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("0.0.0.0")), Texte_Vers_IP(To_Unbounded_String("0.0.0.0")), To_Unbounded_String("eth2"));
        Afficher_Table(Table); New_Line; New_Line;


        put("print 2"); New_Line;
        Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("147.127.127.0")), Texte_Vers_IP(To_Unbounded_String("255.255.255.0")), To_Unbounded_String("eth0"));
        Afficher_Table(Table); New_Line; New_Line;

        put("print 3"); New_Line;
        Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("147.128.0.0")), Texte_Vers_IP(To_Unbounded_String("255.255.255.0")), To_Unbounded_String("eth1"));
        Afficher_Table(Table); New_Line; New_Line;

        put("print 4"); New_Line;
        Ajouter_Element(Cache, Texte_Vers_IP(To_Unbounded_String("147.0.0.0")), Texte_Vers_IP(To_Unbounded_String("255.192.0.0")), To_Unbounded_String("eth2"));
        Afficher_Table(Cache); New_Line; New_Line;

        put("Fin des tests pour Ajouter_Element."); New_Line;
    end test_Ajouter_Element;


    procedure test_Trouver_Interface_Table is
    begin


        Trouver_Interface_Table(Interface_Trouvee, Table, Texte_Vers_IP(To_Unbounded_String("147.5.5.5"))); New_Line;
        pragma Assert(Interface_Trouvee = To_Unbounded_String("eth2"));
        put("Trouver_Interface_Table fonctionne bien sans cache"); New_line;


        Trouver_Interface_Cache(Interface_Trouvee, Cache, Texte_Vers_IP(To_Unbounded_String("147.5.5.5")));
        pragma Assert(Interface_Trouvee = To_Unbounded_String("eth2"));
        put("Trouver_Interface_Cache foncionne en entier.");
        New_Line;
    end test_Trouver_Interface_Table;

    procedure test_Supprimer_Plus_Ancien is
    begin

        Put_Line("Suppression element plus ancien table");
        Supprimer_Plus_Ancien(Table);
        New_Line;
        Afficher_Table(Table);
        New_Line;
    end test_Supprimer_Plus_Ancien;


    procedure test_Vider_Table is
    begin

        Put("Test de Vider_Table"); New_Line;
        Vider_Table(Table);
        Vider_Table(Cache);
        pragma Assert(Est_Vide(Table));
        pragma Assert(Est_Vide(Cache));
        put("La procédure Vider_Table fonctionn"); New_Line;
        put("La fonction Est_Vide fonctionne"); New_Line;

    end test_Vider_Table;


begin

    Initialiser_Table_Vide(Table);
    Initialiser_Table_Vide(Cache);

    test_Ajouter_Element;
    test_Trouver_Interface_Table;
    test_Supprimer_Plus_Ancien;
    test_Vider_Table;

  New_Line;


  Put_Line("");
  Put_Line("");
  Put_Line("##################################################");
  Put_Line("#################### ALL OK ! ####################");
  Put_Line("##################################################");
  Put_Line("");

end test_routage_LA;
