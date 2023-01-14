with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;

package My_Strings is

    Erreur_Pas_Un_Entier : Exception;

    -- créer un Unbounded_String avec les n premiers caractères
    -- de chaine
    function To_Unbounded_String_N (chaine : in String; n : in Integer) return Unbounded_String 
    with Pre => (n <= chaine'Length);

    -- Convertit un caractère en chiffre
    -- c : caractère à convertir
    -- ex : '8' -> 8
    function Caractere_Vers_Entier (c : in Character) return Integer 
    with Pre => ('0' <= c) and (c <= '9'),
    Post => (0 <= Caractere_Vers_Entier'Result) and 
        (Caractere_Vers_Entier'Result <= 9);

    -- Convertit une string en un entier
    -- les espaces sont ignorés et respecte le signe
    -- texte : string à convertir
    -- ex : "132" -> 132
    function Texte_Vers_Entier (texte : in String) return Integer; 

    -- Convertit un entier positif en texte
    -- sans rajouter d’espace avant ou après le nombre
    -- n : entier à convertir
    function Entier_Positif_Vers_Texte (n : in Integer) return String
    with Pre => (n >= 0);

end My_Strings;
