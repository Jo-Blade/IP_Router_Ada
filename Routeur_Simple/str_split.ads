with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;

generic
  NbrArgs : Integer;

package Str_Split is
  type T_TAB is array (1..NbrArgs) of Unbounded_String;

  -- la chaine ne contient pas NbrArgs sous 
  -- chaînes après le split sur c
  -- (la chaîne est probablement incorrecte)
  Erreur_Nombre_Arguments : Exception;

  -- Permet de couper une chaine sur le caractère c
  -- et remplit un tableau de NbrArgs éléments.
  --
  -- si on a plusieurs fois c d’affilé dans la chaine,
  -- on ne coupe qu’une seule fois.
  --
  -- exception si pas le bon nombre d’arguments
  -- dans la chaine
  -- Tableau : Tableau où on récupère les élements découpés
  -- chaine : chaine de caractères à découper
  -- c : caractère sur lequel on doit découper
  procedure Split(Tableau : out T_TAB; 
    chaine : in Unbounded_String; c : in Character);

end Str_Split;
