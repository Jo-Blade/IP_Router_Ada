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

  procedure Ajouter (Arbre : in out T_Trie; Cle : in T_Cle; Temps : in Integer) is
    Min_Temps : Integer;

    procedure Mettre_A_Jour (Arbre : in out T_Trie) is
      Ancien_Temps : Integer;
    begin
      if Est_Vide(Arbre) or Est_Feuille(Arbre) then
        Null;
      else
        Ancien_Temps := Lire_Donnee_Racine(Arbre);

        if Min_Temps = -1 or Ancien_Temps < Min_Temps then
          Min_Temps := Ancien_Temps;
        else
          Null;
        end if;

        Ecrire_Donnee_Tete(Arbre, Min_Temps);
      end if;
      end Mettre_A_Jour;

      procedure Ajouter_Arbre is new Triebin5b.Ajouter (Post_Traitement => Mettre_A_Jour);
      begin
        -- les temps sont des entiers positifs
        Min_Temps := -1;
        Ajouter_Arbre(Arbre, Cle, Temps);
      end Ajouter;

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
        Ajouter(Arbre, 7, 2);
        Ajouter(Arbre, 29, 3);
        Ajouter(Arbre, 21, 4);
        Ajouter(Arbre, 20, 5);
        Afficher(Arbre);

        Vider(Arbre);
      end Test;
