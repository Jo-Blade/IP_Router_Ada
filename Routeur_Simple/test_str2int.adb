with Str2Int; use Str2Int;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure test_str2int is
begin
  Put(Caractere_Vers_Entier('8'));
  New_Line;
  Put(Texte_Vers_Entier("132"));
  New_Line;
  Put(Texte_Vers_Entier("+ 132"));
  New_Line;
  Put(Texte_Vers_Entier("- 823"));
  New_Line;

  begin
    Put(Texte_Vers_Entier("8 - 23"));
  exception
    when Erreur_Pas_Un_Entier =>
      Put("8 - 23 n’est pas une chaine valide");
  end;

end test_str2int;
