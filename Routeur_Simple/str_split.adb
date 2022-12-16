with My_Strings;      use My_Strings;

package body Str_Split is

    procedure Split(Tableau : out T_TAB; Chaine : in Unbounded_String; Caractere : in Character) is
        Buffer : String(1..To_String(Chaine)'Length) := (others => ' ');    -- conserver l’argument actuel
        i : Integer;                                                        -- indice du Buffer
        Chaine_Str : constant String := To_String(Chaine);                  -- String classique
        j : Integer;                                                        -- indice de la Chaine
        n : Integer;                                                        -- numéro de l’argument actuel
    begin
        n := 1;
        i := 0;
        j := Chaine_Str'First;
        while j < Chaine_Str'Last loop
            if Chaine_Str(j) = Caractere then

                if (i = 0) then
                    Null;
                else
                    if n > NbrArgs then
                        raise Erreur_Nombre_Arguments;
                    else
                        Tableau(n) := To_Unbounded_String_N(Buffer, i);
                        i := 0;
                    end if;
                    n := n + 1;
                end if;

            else
                i := i + 1;
                Buffer(i) := Chaine_Str(j);
            end if;

            j := j + 1;
        end loop;

        if n = NbrArgs then
            i := i + 1;
            Buffer(i) := Chaine_Str(j);
            Tableau(n) := To_Unbounded_String_N(Buffer, i);
        else
            raise Erreur_Nombre_Arguments;
        end if;
    end Split;

end Str_Split;
