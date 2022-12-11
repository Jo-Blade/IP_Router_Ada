with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO;              use Ada.Text_IO;
with Str_Split;

with Str2Int;                  use Str2Int;
with Ada.Integer_Text_IO;      use Ada.Integer_Text_IO;

procedure split_exemple is
  exemple_chaine : constant String := "ceci est un test";
  exemple_chaine_error : constant String := "ceci est test";
  exemple_chaine_error2 : constant String := "ceci est un mauvais test";

  exemple_chaine_ip : constant String := "192.168.1.200";

  package Split4 is
    new Str_Split (NbrArgs => 4);
  use Split4;

  tab : T_TAB;

  n : Integer;
begin
  Split(tab, To_Unbounded_String(exemple_chaine), ' ');

  for i in 1..4 loop
    New_Line;
    Put(To_String(tab(i)));
  end loop;

  begin
    Split(tab, To_Unbounded_String(exemple_chaine_error), ' ');
  exception
    when Erreur_Nombre_Arguments =>
      New_Line;
      Put("la chaine est erronée, pas assez de mots");
  end;

  begin
    Split(tab, To_Unbounded_String(exemple_chaine_error2), ' ');
  exception
    when Erreur_Nombre_Arguments =>
      New_Line;
      Put("la chaine est erronée, trop de mots");
  end;

  Split(tab, To_Unbounded_String(exemple_chaine_ip), '.');

  for i in 1..4 loop
    n := Texte_Vers_Entier( To_String(tab(i)) );

    New_Line;
    Put( n );
  end loop;

end split_exemple;
