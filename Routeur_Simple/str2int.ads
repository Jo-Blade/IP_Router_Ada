package Str2Int is

  Erreur_Pas_Un_Entier : Exception;

  -- Convertit un caractère en chiffre
  -- c : caractère à convertir
  -- ex : '8' -> 8
  function Caractere_Vers_Entier (c : Character) return Integer with
    Pre => ('0' <= c) and (c <= '9'),
    Post => (0 <= Caractere_Vers_Entier'Result) and 
      (Caractere_Vers_Entier'Result <= 9);

    -- Convertit une string en un entier
    -- les espaces sont ignorés et respecte le signe
    -- texte : string à convertir
    -- ex : "132" -> 132
    function Texte_Vers_Entier (texte : String) return Integer; 

  end Str2Int;
