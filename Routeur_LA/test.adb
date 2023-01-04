with Ada.Text_IO;     use Ada.Text_IO;
with Arbre_Prefixe;

procedure Test is
  type T_Cle is mod 2**5;

  function Lire_Prefixe (Cle : in T_Cle; Indice : in Natural) return Natural is
  begin
    if Natural(Cle and (2**(4 - Indice))) = 0 then
      return 1;
    else
      return 2;
    end if;
  end Lire_Prefixe;

  package Triebin5b is new Arbre_Prefixe(T_Element => Integer, T_Cle => T_Cle, Nombre_Prefixes => 2,
  Lire_Prefixe => Lire_Prefixe);
  use Triebin5b;

  Arbre : T_Trie;

  procedure Afficher_Cle (Cle : T_Cle; Element : Integer) is
  begin
    Put(Integer'Image(Integer(Cle)) & " -- " & Integer'Image(Element) & " | ");
  end Afficher_Cle;

  procedure Afficher is new Parcours_Profondeur_Post (Traiter => Afficher_Cle);

  -- retourne -1 si les 2 sont null
  function Min_Temps_2 (Arbre1 : in T_Trie; Arbre2 : in T_Trie) return Integer is
  begin
    if Est_Vide(Arbre1) and Est_Vide(Arbre2) then
      return -1;
    elsif Est_Vide(Arbre1) then
      return Lire_Donnee_Racine(Arbre2);
    elsif Est_Vide(Arbre2) then
      return Lire_Donnee_Racine(Arbre1);
    elsif Lire_Donnee_Racine(Arbre1) < Lire_Donnee_Racine(Arbre2) then
      return Lire_Donnee_Racine(Arbre1);
    else
      return Lire_Donnee_Racine(Arbre2);
    end if;
  end Min_Temps_2;

  procedure Ajouter (Arbre : in out T_Trie; Cle : in T_Cle; Temps : in Integer) is

    procedure Mettre_A_Jour (Arbre : in out T_Trie) is
    begin
      if Est_Vide(Arbre) or Est_Feuille(Arbre) then
        Null;
      else
        Ecrire_Donnee_Tete(Arbre, Min_Temps_2(Lire_Ieme_Enfant(Arbre, 1), Lire_Ieme_Enfant(Arbre, 2)));
      end if;
      end Mettre_A_Jour;

      procedure Ajouter_Arbre is new Triebin5b.Ajouter (Post_Traitement => Mettre_A_Jour);
      begin
        -- les temps sont des entiers positifs
        Ajouter_Arbre(Arbre, Cle, Temps);
      end Ajouter;


      procedure Supprimer_Plus_Ancien (Arbre : in out T_Trie) is
        Min : constant Integer := Lire_Donnee_Racine(Arbre);

        function Selection (Arbre : in T_Trie) return Boolean is
        begin
          return Lire_Donnee_Racine(Arbre) = Min;
        end Selection;

        procedure Post_Traitement(Arbre : in out T_Trie) is
        begin
          if Lire_Donnee_Racine(Arbre) = Min then
            Ecrire_Donnee_Tete(Arbre, Min_Temps_2(Lire_Ieme_Enfant(Arbre, 1), Lire_Ieme_Enfant(Arbre, 2)));
          else
            Null;
          end if;
        end Post_Traitement;

        procedure Supprimer_bis is new Supprimer_Selection(Selection => Selection, Post_Traitement => Post_Traitement);
      begin
        Supprimer_bis(Arbre);
      end Supprimer_Plus_Ancien;

      procedure Trouver_Et_Actualiser (Donnee : out Integer; Arbre : in out T_Trie; Cle : in T_Cle; T : in Integer) is

        procedure Post_Traitement(Arbre : in out T_Trie) is
        begin
          if Est_Feuille(Arbre) then
            Ecrire_Donnee_Tete (Arbre, T);
          else
            Ecrire_Donnee_Tete(Arbre, Min_Temps_2(Lire_Ieme_Enfant(Arbre, 1), Lire_Ieme_Enfant(Arbre, 2)));
          end if;
        end Post_Traitement;

        procedure Trouver_Et_Actualiser_Bis is new Trouver_Post (Post_Traitement => Post_Traitement);
      begin
        Trouver_Et_Actualiser_Bis (Donnee, Arbre, Cle);
      end Trouver_Et_Actualiser;

      A : Integer;
      begin
        Initialiser(Arbre);
        if not Est_Feuille(Arbre) then
          Put("test0");
          New_Line;
        end if;
        Ajouter(Arbre, 2, 1);
        if Est_Feuille(Arbre) then
          Put("test1");
          New_Line;
        end if;
        Ajouter(Arbre, 21, 2);
        Ajouter(Arbre, 29, 3);
        Ajouter(Arbre, 7, 4);
        Ajouter(Arbre, 20, 5);
        Afficher(Arbre);

        New_Line;
        New_Line;
        Put_Line(Integer'Image(Trouver(Arbre, 7)));
        Put_Line(Integer'Image(Trouver(Arbre, 20)));
        New_Line;

        
        Put_Line("trouver et actualiser");
        Afficher(Arbre);
        Put_Line(Integer'Image(Trouver(Arbre, 2)));
        Trouver_Et_Actualiser(A, Arbre, 2, 6);
        Put_Line(Integer'Image(A));
        Put_Line(Integer'Image(Trouver(Arbre, 2)));
        Afficher(Arbre);

        Supprimer_Plus_Ancien(Arbre);
        Put_Line(Integer'Image(Trouver(Arbre, 20)));
        Supprimer_Plus_Ancien(Arbre);
        begin
          Put_Line(Integer'Image(Trouver(Arbre, 20)));
          Pragma Assert(1 = 2);
        exception
          when Cle_Absente =>
            Put_Line("L’exception est bien levée");
        end;
        Put_Line(Integer'Image(Trouver(Arbre, 29)));
        Supprimer_Plus_Ancien(Arbre);
        Put_Line(Integer'Image(Trouver(Arbre, 7)));
        Supprimer_Plus_Ancien(Arbre);
        New_Line;
        Afficher(Arbre);

        Vider(Arbre);
      end Test;
