with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with My_Strings;    use My_Strings;
with Liste_Chainee;



procedure Test_Liste_Chainee is

  package Liste_Chainee_String is
    new Liste_Chainee (T_Element => Unbounded_String);
  use Liste_Chainee_String;

  procedure Afficher_T(T : in T_LC) is
    Texte : Unbounded_String; -- texte qui va recevoir 
    -- tous les éléments de la liste

    procedure Afficher_Element (Donnee : in Unbounded_String) is
    begin
      Texte := Texte & To_Unbounded_String(",") & Donnee;
    end Afficher_Element;

    procedure Afficher is new Pour_Chaque(Traiter => Afficher_Element);
  begin
    Afficher(T);
    Put_Line("[" & To_String(Texte)(2..Length(Texte)) & "]");
  end Afficher_T;

  procedure Tester_Initialiser is
    T : T_LC;
  begin
    Initialiser(T);
    pragma Assert(Est_Vide(T));
    put("Initialiser fonctionne !");
    New_Line;
  end Tester_Initialiser;

  procedure Tester_Est_Vide is
    T : T_LC;
  begin
    Initialiser(T);
    pragma Assert(Est_Vide(T));
    put("Est_Vide fonctionne !");
    New_Line;
  end Tester_Est_Vide;

  procedure Tester_Ajouter_Debut_Premier_Supprimer is
    elem1 : Unbounded_String;
    elem2 : Unbounded_String;
    elem3 : Unbounded_String;
    T : T_LC;
  begin
    elem1 := To_Unbounded_String("1");
    elem2 := To_Unbounded_String("2");
    elem3 := To_Unbounded_String("3");
    Initialiser(T);
    Ajouter_Debut(T,elem1);
    put("Après ajout de l'élément '1'");
    New_Line;
    Afficher_T(T);
    Ajouter_Debut(T,elem2);
    put("Après ajout de l'élément '2'");
    New_Line;
    Afficher_T(T);
    Ajouter_Debut(T,elem3);
    put("Après ajout de l'élément '3'");
    New_Line;
    Afficher_T(T);
    Put("Le premier élément est ");
    put(To_String(Premier(T)));
    New_Line;
    Put("Après suppression de l'élément '3'");
    Supprimer(T, To_Unbounded_String("3"));
    Afficher_T(T);
    Put("Après suppression de l'élément '1'");
    Supprimer(T, To_Unbounded_String("1"));
    Afficher_T(T);
    Put("Après suppression de l'élément '2'");
    Supprimer(T, To_Unbounded_String("2"));
    Afficher_T(T);
  End Tester_Ajouter_Debut_Premier_Supprimer;

  procedure Tester_Taille_Est_Present_Vider is
    T : T_LC;
    elem1 : Unbounded_String;
    elem2 : Unbounded_String;
  begin
    elem1 := To_Unbounded_String("1");
    elem2 := To_Unbounded_String("2");
    Initialiser(T);
    Ajouter_Debut(T,elem1);
    Ajouter_Debut(T,elem2);
    pragma Assert(Taille(T) = 2);
    Put("La fonction Taille fonctionne !");
    New_Line;
    Vider(T);
    pragma Assert(Est_Vide(T));
    Put("La fonction Vider fonctionne bien !");
    New_Line;
  end Tester_Taille_Est_Present_Vider;

  procedure Tester_Inserer_Apres_Ieme is
    T : T_LC;
    elem1 : Unbounded_String;
    elem2 : Unbounded_String;
    elem3 : Unbounded_String;
    elem4 : Unbounded_String;
  begin
    Initialiser(T);
    elem1 := To_Unbounded_String("1");
    elem2 := To_Unbounded_String("2");
    elem3 := To_Unbounded_String("3");
    elem4 := To_Unbounded_String("4");
    Ajouter_Debut(T,elem1);
    Ajouter_Debut(T,elem2);
    Ajouter_Debut(T,elem4);
    -- on insère "3" après "1"
    Inserer_Apres(T, elem3, elem1);
    -- Attention, la fonction Ieme commence à 0 et non 1
    pragma Assert(Ieme(T,1) = To_Unbounded_String("2"));
    Put("La fontion Ieme fonctionne bien !");
    New_Line;
    pragma Assert(Ieme(T, 3) = To_Unbounded_String("3"));
    Put("La fonction Inserer_apres fonctionne bien !");
    New_Line;
  end Tester_Inserer_Apres_Ieme;


  procedure Tester_Inserer_Extraire_Trouver is

    function Plus_Petit(A : in Unbounded_String; B : in Unbounded_String) return Boolean is
    begin
      return (Texte_Vers_Entier(To_String(A)) <= Texte_Vers_Entier(To_String(B)));
    end Plus_Petit;

    procedure Inserer_Element is new Inserer(Plus_Petit => Plus_Petit);

    function Selection(A : in Unbounded_String) return Boolean is
    begin
      return (A = To_Unbounded_String("2"));
    end Selection;

    function Trouver is new Liste_Chainee_String.Trouver(Selection => Selection);
    
    procedure Extraire is new Liste_Chainee_String.Extraire(Selection => Selection);

    T : T_LC;
    elem1 : Unbounded_String;
    elem2 : Unbounded_String;
    elem3 : Unbounded_String;
    elem4 : Unbounded_String;
    elem_trouver : Unbounded_String;

  begin

    elem1 := To_Unbounded_String("1");
    elem2 := To_Unbounded_String("2");
    elem3 := To_Unbounded_String("3");
    elem4 := To_Unbounded_String("4");
    Initialiser(T);

    -- Attention, quand on ajoute au début, ça donne la liste inversée
    Ajouter_Debut(T,elem3);
    Ajouter_Debut(T,elem2);
    Ajouter_Debut(T,elem1);

    Inserer_Element(T, elem4);
    Afficher_T(T);
    -- Attention, la fonction Ieme commence à 0 et non 1
    pragma Assert(Ieme(T,3) = elem4);
    elem_trouver := Trouver(T);
    pragma Assert(elem_trouver = elem2);
    Extraire(elem_trouver, T);
    pragma Assert(elem_trouver = elem2);
  end Tester_Inserer_Extraire_Trouver;




begin
  Tester_Initialiser;
  Tester_Est_Vide;
  Tester_Ajouter_Debut_Premier_Supprimer;
  Tester_Taille_Est_Present_Vider;
  Tester_Inserer_Apres_Ieme;
  Tester_Inserer_Extraire_Trouver;

  Put_Line ("Fin des tests : OK.");
  Put_Line ("******************************************************");
  Put_Line ("RAJOUTER LES TESTS POUR INSERER ET TROUVER ET EXTRAIRE");
  Put_Line ("******************************************************");
end Test_Liste_Chainee;
