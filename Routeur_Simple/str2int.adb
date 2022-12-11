package body Str2Int is

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

end Str2Int;
