with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Liste_Chainee;



procedure Test_Liste_Chainee is

	package Liste_Chainee_String is
		new Liste_Chainee (T_Element => Unbounded_String);
    use Liste_Chainee_String;

    procedure Afficher_T(T : in T_LC) is
    begin
        while not T.all.Suivant = Null loop
            put(To_Unbounded_String(T.all.Element));
            New_Line;
            T := T.all.Suivant;
        end loop;
    end Afficher_T;

    procedure Tester_Initiialiser is
        T : T_LC;
    begin
        Initialiser(T);
        pragma Assert(T = Null);
        put("Initialiser fonctionne !");
        New_Line;
    end Tester_Initiialiser;

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
        pragma Assert(T = Null);
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
        Inserer_Apres(T, elem3, elem4);
        pragma Assert(Ieme(T,2) = To_Unbounded_String("2"));
        Put("La fontion Ieme fonctionne bien !");
        New_Line;
        pragma Assert(Ieme(3) = To_Unbounded_String("3"));
        Put("La fonction Inserer_apres fonctionne bien !");
        New_Line;
    end Tester_Inserer_Apres_Ieme;






begin
    Tester_Initiialiser;
    Tester_Ajouter_Debut_Premier_Supprimer;
    Tester_Taille_Est_Present_Vider;
    Tester_Inserer_Apres_Ieme;

	Put_Line ("Fin des tests : OK.");
end Test_Liste_Chainee;
