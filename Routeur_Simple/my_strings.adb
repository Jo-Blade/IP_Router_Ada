package body My_Strings is

  function To_Unbounded_String_N (chaine : in String;
    n : in Integer) return Unbounded_String is

    temp_chaine : String(chaine'First..(chaine'First + n - 1));
  begin

    for i in chaine'First..(chaine'First + n - 1) loop
      temp_chaine(i) := chaine(i);
    end loop;

    return To_Unbounded_String(temp_chaine);
  end To_Unbounded_String_N;


  function Caractere_Vers_Entier (c : Character)
    return Integer is
  begin
    return Character'Pos(c) - Character'Pos('0');
  end Caractere_Vers_Entier;


  function Texte_Vers_Entier (texte : String)
    return Integer is
    c : Character;
    signe : Integer;
    s : Integer;
  begin
    signe := 1;
    s := 0;

    for i in texte'First .. texte'Last loop
      c := texte(i);

      case c is
        when ' ' => Null;

        when '+' => 
          if i = texte'First then
            Null;
          else
            raise Erreur_Pas_Un_Entier;
          end if;

        when '-' =>
          if i = texte'First then
            signe := -1;
          else
            raise Erreur_Pas_Un_Entier;
          end if;

        when '0'..'9' =>
          s := s * 10 + signe * Caractere_Vers_Entier(c);

        when others =>
          raise Erreur_Pas_Un_Entier;
      end case;

    end loop;
    return s;

  end Texte_Vers_Entier;


  function Entier_Positif_Vers_Texte (n : Integer)
    return String is
    temp_chaine : constant String := Integer'Image(n);
  begin
    return temp_chaine(2 .. temp_chaine'Last);
  end Entier_Positif_Vers_Texte;

end My_Strings;
