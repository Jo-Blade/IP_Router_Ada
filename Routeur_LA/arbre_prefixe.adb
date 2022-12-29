with Ada.Unchecked_Deallocation;

package body Arbre_Prefixe is
  procedure Free is
    new Ada.Unchecked_Deallocation (Object => T_Noeud, Name => T_Trie);

  procedure Initialiser (Arbre : out T_Trie) is
  begin
    Arbre := Null;
  end Initialiser;

  procedure Vider (Arbre : in out T_Trie) is
  begin
    if Arbre = Null then
      Null;
    else
      for i in 1..Nombre_Prefixes loop
        Vider (Arbre.All.Enfants(i));
      end loop;
      Free(Arbre);
    end if;
  end Vider;

  function Est_Vide (Arbre : in T_Trie) return Boolean is
  begin
    return Arbre = Null;
  end Est_Vide;

  function Est_Feuille (Arbre : in T_Trie) return Boolean is
    Test : Boolean;
    i : Natural;
  begin
    if Arbre = Null then
      return False;
    else
      i := 1;
      loop
        Test := Arbre.All.Enfants(i) = Null;
        i := i + 1;
        exit when not Test or i > Nombre_Prefixes;
      end loop;
      return Test;
    end if;
  end Est_Feuille;

  procedure Ajouter (Arbre : in out T_Trie; Cle : in T_Cle; Element : in T_Element) is
    procedure Ajouter_Profondeur (Arbre : in out T_Trie; Cle : in T_Cle; Element : in T_Element; Profondeur : in Natural) is
    begin
      if Arbre = Null then
        Arbre := new T_Noeud;
        Arbre.All.Cle := Cle;
        Arbre.All.Element := Element;
        Post_Traitement(Arbre);
      elsif Est_Feuille(Arbre) then
        Ajouter_Profondeur(Arbre.All.Enfants(Lire_Prefixe(Cle, Profondeur)), Cle, Element, Profondeur + 1);
        Ajouter_Profondeur(Arbre, Arbre.All.Cle, Arbre.All.Element, Profondeur);
        Post_Traitement(Arbre);
      else
        Ajouter_Profondeur(Arbre.All.Enfants(Lire_Prefixe(Cle, Profondeur)), Cle, Element, Profondeur + 1);
        Post_Traitement(Arbre);
      end if;
    end Ajouter_Profondeur;

  begin
    Ajouter_Profondeur (Arbre, Cle, Element, 0);
  end Ajouter;

  function Lire_Donnee_Racine (Arbre : in T_Trie) return T_Element is
  begin
    return Arbre.All.Element;
  end Lire_Donnee_Racine;

  procedure Ecrire_Donnee_Tete (Arbre : in out T_Trie; Donnee : in T_Element) is
  begin
    Arbre.All.Element := Donnee;
  end Ecrire_Donnee_Tete;

  --procedure Supprimer (Arbre : in out T_Trie);

  --procedure Trouver (Element : out T_Element; Arbre : in T_Trie; Cle : in T_Cle);

  procedure Parcours_Profondeur_Post (Arbre : in T_Trie) is
  begin
    if Arbre = Null then
      Null;
    else
      for i in 1..Nombre_Prefixes loop
        Parcours_Profondeur_Post(Arbre.All.Enfants(i));
      end loop;
      Traiter(Arbre.All.Cle, Arbre.All.Element);
    end if;
  end Parcours_Profondeur_Post;

end Arbre_Prefixe;
