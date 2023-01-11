with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO;              use Ada.Text_IO;
with Str_Split;


procedure test_split is
    exemple_chaine : constant String := "ceci    est un test";
    exemple_chaine_error : constant String := "ceci est test";
    exemple_chaine_error2 : constant String := "ceci est un mauvais test";

    -- même si on a plusieurs points, ça reste correct car Split
    -- va couper qu’une seule fois sur les points
    exemple_chaine_ip : constant String := "192.....168.0.200";

    package Split4 is
        new Str_Split (NbrArgs => 4);
    use Split4;

    tab : T_TAB;
    correct : T_TAB;
begin
    -- Test Split avec un espace
    Split(tab, To_Unbounded_String(exemple_chaine), ' ');
    correct(1) := To_Unbounded_String("ceci");
    correct(2) := To_Unbounded_String("est");
    correct(3) := To_Unbounded_String("un");
    correct(4) := To_Unbounded_String("test");

    for i in 1..4 loop
        pragma Assert(tab(i)=correct(i));
    end loop;
    
    -- Test des exception
    begin
        Split(tab, To_Unbounded_String(exemple_chaine_error), ' ');
    exception
        when Erreur_Nombre_Arguments =>
            Put_Line("la chaine est erronée, pas assez de mots");
    end;

    begin
        Split(tab, To_Unbounded_String(exemple_chaine_error2), ' ');
    exception
        when Erreur_Nombre_Arguments =>
            Put_Line("la chaine est erronée, trop de mots");
    end;
    

    -- Test avec un point
    Split(tab, To_Unbounded_String(exemple_chaine_ip), '.');
    correct(1) := To_Unbounded_String("192");
    correct(2) := To_Unbounded_String("168");
    correct(3) := To_Unbounded_String("0");
    correct(4) := To_Unbounded_String("200");

    for i in 1..4 loop
        pragma Assert(tab(i)=correct(i));
    end loop;



    Put_Line("");
    Put_Line("");
    Put_Line("##################################################");
    Put_Line("#################### ALL OK ! ####################");
    Put_Line("##################################################");
    Put_Line("");

end test_split;
