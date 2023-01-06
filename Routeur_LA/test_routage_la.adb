with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Routage_LA; use Routage_LA;
with IP; use IP;

procedure test_routage_LA is
    --Erreur_Exception_Non_Levee : Exception;

    Table : T_Table;
    Cache : T_Table;
    Interface_Trouvee : Unbounded_String;
begin
  Initialiser_Table_Vide(Table);
  Initialiser_Table_Vide(Cache);

  Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("0.0.0.0")), Texte_Vers_IP(To_Unbounded_String("0.0.0.0")), To_Unbounded_String("eth2"));
  Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("147.127.127.0")), Texte_Vers_IP(To_Unbounded_String("255.255.255.0")), To_Unbounded_String("eth0"));
  Ajouter_Element(Table, Texte_Vers_IP(To_Unbounded_String("147.128.0.0")), Texte_Vers_IP(To_Unbounded_String("255.255.255.0")), To_Unbounded_String("eth1"));

  Ajouter_Element(Cache, Texte_Vers_IP(To_Unbounded_String("147.0.0.0")), Texte_Vers_IP(To_Unbounded_String("255.192.0.0")), To_Unbounded_String("eth2"));

  New_Line;
  Afficher_Table(Table);
  New_Line;
  New_Line;
  Afficher_Table(Cache);
  New_Line;

  Trouver_Interface_Table(Interface_Trouvee, Table, Texte_Vers_IP(To_Unbounded_String("147.5.5.5")));
  New_Line;
  Put_Line(To_String(Interface_Trouvee));
  New_Line;
  Afficher_Table(Table);
  New_Line;

  Put_Line("Dans le cas du cache");
  Trouver_Interface_Cache(Interface_Trouvee, Cache, Texte_Vers_IP(To_Unbounded_String("147.5.5.5")));
  Put_Line(To_String(Interface_Trouvee));
  New_Line;
  Afficher_Table(Cache);
  New_Line;

  Put_Line("Suppression element plus ancien table");
  Supprimer_Plus_Ancien(Table);
  New_Line;
  Afficher_Table(Table);
  New_Line;

  Vider_Table(Table);
  Vider_Table(Cache);

  New_Line;


  Put_Line("");
  Put_Line("");
  Put_Line("##################################################");
  Put_Line("#################### ALL OK ! ####################");
  Put_Line("##################################################");
  Put_Line("");

end test_routage_LA;
