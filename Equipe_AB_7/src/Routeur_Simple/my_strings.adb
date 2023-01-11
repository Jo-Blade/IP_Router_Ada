package body My_Strings is

    function To_Unbounded_String_N (Chaine : in String; n : in Integer) return Unbounded_String is
        Temp_Chaine : String(Chaine'First..(Chaine'First + n - 1));     -- Chaine temporaire
    begin
        for i in Chaine'First..(Chaine'First + n - 1) loop
            Temp_Chaine(i) := Chaine(i);
        end loop;

        return To_Unbounded_String(Temp_Chaine);
    end To_Unbounded_String_N;


    function Caractere_Vers_Entier (c : Character) return Integer is
    begin
        return Character'Pos(c) - Character'Pos('0');
    end Caractere_Vers_Entier;


    function Texte_Vers_Entier (Texte : String) return Integer is
        Caractere : Character;      -- caractère courant de la Chaine
        Signe : Integer;            -- signe de l'entier
        Entier : Integer;           -- entier: 1 positif, -1 négatif
    begin
        Signe := 1;
        Entier := 0;

        for i in Texte'First .. Texte'Last loop
            Caractere := Texte(i);

            case Caractere is
                when ' ' => Null;

                when '+' => 
                    if i = Texte'First then
                        Null;
                    else
                        raise Erreur_Pas_Un_Entier;
                    end if;

                when '-' =>
                    if i = Texte'First then
                        Signe := -1;
                    else
                        raise Erreur_Pas_Un_Entier;
                    end if;

                when '0'..'9' =>
                    Entier := Entier * 10 + Signe * Caractere_Vers_Entier(Caractere);

                when others =>
                    raise Erreur_Pas_Un_Entier;
            end case;

        end loop;
        return Entier;

    end Texte_Vers_Entier;


    function Entier_Positif_Vers_Texte (n : Integer) return String is
        Temp_Chaine : constant String := Integer'Image(n);  -- Chaine temporaire
    begin
        return Temp_Chaine(2 .. Temp_Chaine'Last);
    end Entier_Positif_Vers_Texte;

end My_Strings;
