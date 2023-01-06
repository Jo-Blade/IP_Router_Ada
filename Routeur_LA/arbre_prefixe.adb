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


  function Lire_Cle_Racine (Arbre : in T_Trie) return T_Cle is
  begin
    return Arbre.All.Cle;
  end Lire_Cle_Racine;


  procedure Ecrire_Donnee_Tete (Arbre : in out T_Trie; Donnee : in T_Element) is
  begin
    Arbre.All.Element := Donnee;
  end Ecrire_Donnee_Tete;

  function Lire_Ieme_Enfant (Arbre : in T_Trie; i : Natural) return T_Trie is
  begin
    return Arbre.All.Enfants(i);
  end Lire_Ieme_Enfant;

  -- Supprime les noeuds qui ne sont plus nécessaire après suppression
  -- d’autres Noeuds par la fonction supprimer
  procedure Supprimer_Noeud_Inutile (Arbre : in out T_Trie) is
    Arbre_Temporaire : T_Trie;
    Nombre_Fils_Feuilles : Natural;
    Existe_Fils_Intermediare : Boolean;
    i : Natural;
  begin
    i := 1;
    Arbre_Temporaire := Null;
    Nombre_Fils_Feuilles := 0;
    Existe_Fils_Intermediare := False;
    loop
      if Est_Feuille(Arbre.All.Enfants(i)) then
        Arbre_Temporaire := Arbre.All.Enfants(i);
        Nombre_Fils_Feuilles := Nombre_Fils_Feuilles + 1;
      elsif Arbre.All.Enfants(i) /= Null then
        Existe_Fils_Intermediare := True;
      else
        Null;
      end if;
      i := i + 1;
      exit when Existe_Fils_Intermediare or i > Nombre_Prefixes or Nombre_Fils_Feuilles >= 2;
    end loop;

    if not Existe_Fils_Intermediare and Nombre_Fils_Feuilles = 1 then
      Free(Arbre);
      Arbre := Arbre_Temporaire;
    else
      Null;
    end if;
  end Supprimer_Noeud_Inutile;

  procedure Supprimer_Selection (Arbre : in out T_Trie) is
    Est_Selectionne : Boolean;
  begin
    if Arbre = Null then 
      Null;
    else
      Est_Selectionne := Selection(Arbre);
      if not Est_Selectionne then
        Null;
      elsif Est_Feuille(Arbre) then
        Free(Arbre); -- le free en ada met = à null
      else
        for i in 1..Nombre_Prefixes loop
          Supprimer_Selection(Arbre.All.Enfants(i));
        end loop;
        Supprimer_Noeud_Inutile(Arbre);
        Post_Traitement(Arbre);
      end if;
    end if;
  end Supprimer_Selection;

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

  function Trouver (Arbre : in T_Trie; Cle : in T_Cle) return T_Element is

    function Trouver_Profondeur (Arbre : in T_Trie; Profondeur : in Natural) return T_Element is
    begin
      if Arbre = Null then
        raise Element_Absent_Error;
      elsif Est_Feuille(Arbre) then
        if Arbre.All.Cle = Cle then
          return Arbre.All.Element;
        else
          raise Element_Absent_Error;
        end if;
      else
        return Trouver_Profondeur (Arbre.All.Enfants(Lire_Prefixe(Cle, Profondeur)), Profondeur + 1);
      end if;
    end Trouver_Profondeur;
  begin
    return Trouver_Profondeur(Arbre, 0);
  end Trouver;


  procedure Chercher_Et_Verifier_Post (Element_Trouve : out T_Element; Arbre : in out T_Trie; Cle : in T_Cle) is

    procedure Chercher_Profondeur (Arbre : in out T_Trie; Profondeur : in Natural) is
    begin
      if Arbre = Null then
        raise Element_Absent_Error;
      elsif Est_Feuille(Arbre) then
        if Verifier(Arbre.All.Cle, Arbre.All.Element) then
          Element_Trouve := Arbre.All.Element;
          Post_Traitement(Arbre);
        else
          raise Element_Absent_Error;
        end if;
      else
        Chercher_Profondeur(Arbre.All.Enfants(Lire_Prefixe(Cle, Profondeur)), Profondeur + 1);
        Post_Traitement(Arbre);
      end if;
    end Chercher_Profondeur;
  begin
    Chercher_Profondeur(Arbre, 0);
  end Chercher_Et_Verifier_Post;

  procedure Trouver_Selection_Post (Element_Trouve : out T_Element; Arbre : in out T_Trie) is
    Est_Trouve : Boolean;

    procedure Trouver_Selection_Bis (Arbre : in out T_Trie) is
    begin
      if Arbre /= Null and then Selection(Arbre) then
        if Est_Feuille(Arbre) then
          if Est_Trouve then
            Element_Trouve := Choisir(Element_Trouve, Arbre.All.Element);
          else
            Element_Trouve := Arbre.All.Element;
            Est_Trouve := True;
          end if;
          Post_Traitement(Arbre);
        else
          for i in 1..Nombre_Prefixes loop
            Trouver_Selection_Bis(Arbre.All.Enfants(i));
          end loop;
          Post_Traitement(Arbre);
        end if;
      else
        Null;
      end if;
    end Trouver_Selection_Bis;
  begin
    Est_Trouve := False;
    Trouver_Selection_Bis (Arbre);
    if Est_Trouve then
      Null;
    else
      raise Element_Absent_Error;
    end if;
  end Trouver_Selection_Post;


end Arbre_Prefixe;
