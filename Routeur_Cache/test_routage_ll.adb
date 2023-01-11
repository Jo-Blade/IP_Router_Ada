with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Routage_LL; use Routage_LL;
with IP; use IP;
with Routage; use Routage;

procedure test_routage_LL is

    Table : Routage.T_Table;
    Cache : Routage_LL.T_Table;
    Interface_Trouvee : Unbounded_String;



    procedure test_Mise_A_Jour_Cache_LRU is
    begin
        put("test de la procedure Mise_A_Jour_Cache_LRU"); New_Line;


        put("print Remplissage de la table de routage, Etape 1"); New_Line;
        Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("0.0.0.0")), Texte_Vers_IP(To_Unbounded_String("0.0.0.0")), To_Unbounded_String("eth2"));
        Afficher_Table(Table); New_Line; New_Line;


        put("Etape 2"); New_Line;
        Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("147.127.127.0")), Texte_Vers_IP(To_Unbounded_String("255.255.255.0")), To_Unbounded_String("eth0"));
        Afficher_Table(Table); New_Line; New_Line;

        put("Etape 3"); New_Line;
        Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("147.128.0.0")), Texte_Vers_IP(To_Unbounded_String("255.255.255.0")), To_Unbounded_String("eth1"));
        Afficher_Table(Table); New_Line; New_Line;

        put("Remplissage de cache"); New_Line;
        put("Etape 1"); New_Line;
        Mise_A_Jour_Cache(Cache, Texte_Vers_IP(To_Unbounded_String("147.127.127.8")) ,3, To_Unbounded_String("LFU"),0,  To_Unbounded_String("eth2"), Table);
        Afficher_Cache(Cache, To_Unbounded_String("LFU")); New_Line; New_Line;

        put("Etape 2"); New_Line;
        Mise_A_Jour_Cache(Cache, Texte_Vers_IP(To_Unbounded_String("147.127.127.5")) ,3, To_Unbounded_String("LFU"),2,  To_Unbounded_String("eth3"), Table);
        Afficher_Cache(Cache, To_Unbounded_String("LFU")); New_Line; New_Line;

        put("Etape 3"); New_Line;
        Mise_A_Jour_Cache(Cache, Texte_Vers_IP(To_Unbounded_String("147.128.10.10")) ,3, To_Unbounded_String("LFU"),1,  To_Unbounded_String("eth1"), Table);
        Afficher_Cache(Cache, To_Unbounded_String("LFU")); New_Line; New_Line;


        Trouver_Interface_Cache(Interface_Trouvee, Cache, Texte_Vers_IP(To_Unbounded_String("147.127.127.8")), To_Unbounded_String("LFU"));
        Trouver_Interface_Cache(Interface_Trouvee, Cache, Texte_Vers_IP(To_Unbounded_String("147.127.127.5")), To_Unbounded_String("LFU"));

        put("Etape 4: Depassement de la taille max du cache et suppression de l'élément d'interface 'eth1' "); New_Line;
        Mise_A_Jour_Cache(Cache, Texte_Vers_IP(To_Unbounded_String("147.127.10.8")) ,3, To_Unbounded_String("LFU"),3,  To_Unbounded_String("eth3"), Table);
        Afficher_Cache(Cache, To_Unbounded_String("LFU")); New_Line; New_Line;


        Trouver_Interface_Cache(Interface_Trouvee, Cache, Texte_Vers_IP(To_Unbounded_String("147.128.10.10")), To_Unbounded_String("LFU"));

        put("Fin des tests pour Ajouter_Element et Mise_A_Jour_Cache en politique LFU."); New_Line;

    exception
        when INTERFACE_NON_TROUVE =>
            put("L'élément le moins utilisé du cache a bien été supprimé");
    end test_Mise_A_Jour_Cache_LRU;




    procedure test_Mise_A_Jour_Cache_FIFO is
    begin
        put("test de la procedure Mise_A_Jour_Cache_FIFO"); New_Line;




        put("Remplissage de cache"); New_Line;
        put("Etape 1"); New_Line;
        Mise_A_Jour_Cache(Cache, Texte_Vers_IP(To_Unbounded_String("147.127.127.8")) ,3, To_Unbounded_String("FIFO"),0,  To_Unbounded_String("eth2"), Table);
        Afficher_Cache(Cache, To_Unbounded_String("FIFO")); New_Line; New_Line;

        put("Etape 2"); New_Line;
        Mise_A_Jour_Cache(Cache, Texte_Vers_IP(To_Unbounded_String("147.127.127.5")) ,3, To_Unbounded_String("FIFO"),2,  To_Unbounded_String("eth3"), Table);
        Afficher_Cache(Cache, To_Unbounded_String("FIFO")); New_Line; New_Line;

        put("Etape 3"); New_Line;
        Mise_A_Jour_Cache(Cache, Texte_Vers_IP(To_Unbounded_String("147.128.10.10")) ,3, To_Unbounded_String("FIFO"),1,  To_Unbounded_String("eth1"), Table);
        Afficher_Cache(Cache, To_Unbounded_String("FIFO")); New_Line; New_Line;



        put("Etape 4: Depassement de la taille max du cache et suppression de l'élément d'interface 'eth2' "); New_Line;
        Mise_A_Jour_Cache(Cache, Texte_Vers_IP(To_Unbounded_String("147.127.10.8")) ,3, To_Unbounded_String("FIFO"),3,  To_Unbounded_String("eth3"), Table);
        Afficher_Cache(Cache, To_Unbounded_String("FIFO")); New_Line; New_Line;


        Trouver_Interface_Cache(Interface_Trouvee, Cache, Texte_Vers_IP(To_Unbounded_String("147.127.127.8")), To_Unbounded_String("FIFO"));

        put("Fin des tests pour Ajouter_Element et Mise_A_Jour_Cache en politique FIFO."); New_Line;

    exception
        when INTERFACE_NON_TROUVE =>
            put("L'élément le moins utilisé du cache a bien été supprimé");
    end test_Mise_A_Jour_Cache_FIFO;


    procedure test_Trouver_Interface_Cache is
    begin

        put("Début des tests de Trouver_Interface_Cache"); New_Line;
        Trouver_Interface_Cache(Interface_Trouvee, Cache, Texte_Vers_IP(To_Unbounded_String("147.127.127.8")), To_Unbounded_String("LFU"));
        pragma Assert(Interface_Trouvee = To_Unbounded_String("eth2"));
        put("Trouver_Interface_Cache foncionne bien.");
        New_Line;



    end test_Trouver_Interface_Cache;


begin

    Initialiser_Table_Vide(Table);
    Initialiser_Table_Vide(Cache);

    test_Mise_A_Jour_Cache_FIFO;
    test_Mise_A_Jour_Cache_LRU;
    test_Trouver_Interface_Cache;

    New_Line;
    Vider_Table(Table);
    Vider_Table(Cache);


  Put_Line("");
  Put_Line("");
  Put_Line("##################################################");
  Put_Line("#################### ALL OK ! ####################");
  Put_Line("##################################################");
  Put_Line("");

end test_routage_LL;
