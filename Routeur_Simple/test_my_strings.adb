with My_Strings; use My_Strings;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;

procedure test_my_strings is
    Entier : Integer;
begin
    --Test To_Unbounded_String_N
    Pragma Assert(To_Unbounded_String("test_test") = To_Unbounded_String_N("test_testhvbivisydbviub", 9));
    Pragma Assert(To_Unbounded_String_N("test", 4) = To_Unbounded_String("test"));
    
    -- Test Caractere_Vers_Entier
    pragma Assert(Caractere_Vers_Entier('8')=8);
    

    -- Tests Texte_Vers_Entier
    pragma Assert(Texte_Vers_Entier("8") = 8);
    pragma Assert(Texte_Vers_Entier("132")=132);
    pragma Assert(Texte_Vers_Entier("+126")=126);
    pragma Assert(Texte_Vers_Entier("- 26")=-26);
    begin
        Entier := Texte_Vers_Entier("8 - 23");  -- Doit lever l'exception Erreur_Pas_Un_Entier
        Put(Entier);
    exception
        when Erreur_Pas_Un_Entier =>
            Put("8 - 23 n’est pas une chaine valide");
    end;

    
    -- Tests Entier_Positif_Vers_Texte
    pragma Assert(Entier_Positif_Vers_Texte(124)="124");
    pragma Assert(Entier_Positif_Vers_Texte(0)="0");


    Put_Line("");
    Put_Line("");
    Put_Line("##################################################");
    Put_Line("#################### ALL OK ! ####################");
    Put_Line("##################################################");
    Put_Line("");

end test_my_strings;
