package body Str_Split is

  -- créer un Unbounded_String avec les n premiers caractères
  -- de chaine
  function To_Unbounded_String_N (chaine : in String;
    n : in Integer) return Unbounded_String is

    temp_chaine : String(chaine'First..(chaine'First + n - 1));
  begin

    for i in chaine'First..(chaine'First + n - 1) loop
      temp_chaine(i) := chaine(i);
    end loop;

    return To_Unbounded_String(temp_chaine);
  end To_Unbounded_String_N;


  procedure Split(Tableau : out T_TAB; 
    chaine : in Unbounded_String; c : in Character) is

    buffer : String(1..To_String(chaine)'Length) := (others => ' '); -- conserver l’argument actuel
    i : Integer; -- indice du buffer
    str : constant String := To_String(chaine); -- String classique
    j : Integer; -- indice de la chaine
    n : Integer; -- numéro de l’argument actuel
  begin
    n := 1;
    i := 0;
    j := str'First;
    while j < str'Last loop
      if str(j) = c then

        if n > NbrArgs then
          raise Erreur_Nombre_Arguments;
        else
          Tableau(n) := To_Unbounded_String_N(buffer, i);
          i := 0;
        end if;
        n := n + 1;

      else
        i := i + 1;
        buffer(i) := str(j);
      end if;

      j := j + 1;
    end loop;

    if n = NbrArgs then
      i := i + 1;
      buffer(i) := str(j);
      Tableau(n) := To_Unbounded_String_N(buffer, i);
    else
      raise Erreur_Nombre_Arguments;
    end if;
  end Split;

end Str_Split;
