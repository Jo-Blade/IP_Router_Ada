with Ada.Text_IO;     use Ada.Text_IO;
with Arbre_Prefixe;

procedure Test_Arbre_Prefixe is
    -- Instanciation du module arbre_prefixe avec 2 préfixes
    type T_Cle is mod 2**5;      -- Les clés de l'arbre seront des entiers
    
    function Lire_Prefixe(Cle : in T_Cle; Indice : in Natural) return Natural is
    begin
        -- Ici, on va à gauche si le bit de différence est un 0, à droite si c'est un 1
        if Natural(Cle and (2**(5 - Indice - 1))) = 0 then
            return 1;
        else
            return 2;
        end if;
    end Lire_Prefixe;

    package Trie_2 is new Arbre_Prefixe(T_Element => Integer, T_Cle => T_Cle, Nombre_Prefixes => 2,
    Lire_Prefixe => Lire_Prefixe);
    use Trie_2;


    -- Définition de Min_Temps_2, qui renvoie le moins "ancien" des 2 arbres entrés en argument
    -- 2 car Nombre_Prefixes = 2
    function Min_Temps_2 (Arbre1 : in T_Trie; Arbre2 : in T_Trie) return Integer is
    begin
        -- On renvoie -1 s'il n'y a pas de racines
        if Est_Vide(Arbre1) and Est_Vide(Arbre2) then
            return -1;
        elsif Est_Vide(Arbre1) then
            return Lire_Donnee_Racine(Arbre2);
        elsif Est_Vide(Arbre2) then
            return Lire_Donnee_Racine(Arbre1);
        elsif Lire_Donnee_Racine(Arbre1) > Lire_Donnee_Racine(Arbre2) then
            return Lire_Donnee_Racine(Arbre2);
        else
            return Lire_Donnee_Racine(Arbre1);
        end if;
    end Min_Temps_2;


    -- Définition de l'ajout d'un élément dans l'arbre
    -- Ici, on dicte la manière de mettre à jour l'arbre après l'ajout d'un élément.
    procedure Ajouter_Element (Arbre : in out T_Trie; Cle : in T_Cle; Temps : in Integer) is
        -- On cherhe à écrire la donnée du plus récent des 2 (2 car Nombre_Prefixes = 2) fils dans la racine.
        -- Ceci permet une bonne suppression si besoin des feuilles et un ordonnement efficace. 
        procedure Mettre_A_Jour(Arbre : in out T_Trie) is
        begin
            if Est_Vide(Arbre) or Est_Feuille(Arbre) then
                Null;
            else
                Ecrire_Donnee_Tete(Arbre, Min_Temps_2(Lire_Ieme_Enfant(Arbre, 1), Lire_Ieme_Enfant(Arbre, 2)));
            end if;
        end Mettre_A_Jour;

        procedure Ajouter_Arbre is new Trie_2.Ajouter (Post_Traitement => Mettre_A_Jour);
    begin
        Ajouter_Arbre (Arbre, Cle, Temps);
    end Ajouter_Element;


    -- Lors du parcours en profondeur de l'arbre, on affiche chaque clé de cellule
    procedure Afficher_Cle (Arbre : in T_Trie) is
        Cle     : constant T_Cle   := Lire_Cle_Racine(Arbre);
        Element : constant Integer := Lire_Donnee_Racine(Arbre);
    begin
        Put(Integer'Image(Integer(Cle)) & " -- " & Integer'Image(Element) & " | ");
    end Afficher_Cle;

    procedure Afficher is new Parcours_Profondeur_Post (Traiter => Afficher_Cle);


    -- Instanciation de Chercher_et_Verifier_Post
    -- Cherche l'élément lié à une clé et le renvoie tout en le modifiant à une nouvelle valeur entrée
    -- en argument.
    procedure Trouver_Et_Actualiser (Donnee : out Integer; Arbre : in out T_Trie; Cle : in T_Cle; T : in Integer) is
        -- Instanciation de Post_Traitement
        -- On écrit la donnée en feuille une fois le parcours terminé
        procedure Post_Traitement (Arbre : in out T_Trie) is
        begin
            if Est_Feuille(Arbre) then
                Ecrire_Donnee_Tete (Arbre, T);
            else
                Ecrire_Donnee_Tete(Arbre, Min_Temps_2(Lire_Ieme_Enfant(Arbre, 1), Lire_Ieme_Enfant(Arbre, 2)));
            end if;
        end Post_Traitement;

        -- Instanciation de Verifier
        -- On vérifie que la clé correspond à la clé à trouver
        function Verifier (A_Cle : in T_Cle; A_Donnee : in Integer) return Boolean is
        begin
            if A_Cle = Cle and A_Donnee >= 0 then
                return True;
            else
                return False;
            end if;
        end Verifier;

        procedure Trouver_Et_Actualiser_Bis is new Chercher_Et_Verifier_Post (Verifier => Verifier, Post_Traitement => Post_Traitement);
    begin
        Trouver_Et_Actualiser_Bis (Donnee, Arbre, Cle);
    end Trouver_Et_Actualiser;


    -- Définition de Supprimer_Plus_Ancien
    -- On supprime la feuille la plus ancienne avant d'appliquer un post traitement pour nettoyer l'arbre
    procedure Supprimer_Plus_Ancien (Arbre : in out T_Trie) is
        -- Instanciation de Selection
        -- Ici, la feuille la plus ancienne à la même donnée que la racine primaire
        -- Il s'agit alors de sélectionner cette feuille
        Min : constant Integer := Lire_Donnee_Racine(Arbre);

        function Selection (Arbre : in T_Trie) return Boolean is
        begin
            return Lire_Donnee_Racine(Arbre) = Min;
        end Selection;

        -- Instanciation de Post_Traitement
        -- On nettoie l'arbre, c'est à dire que l'on supprime les noeuds inutiles (ceux qui n'ont qu'un fils)
        -- tout en gardant la cohérence de l'arbre
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



    -- Variables locales
    Arbre : T_Trie;     -- Arbre du test
    Erreur_Dans_Les_Tests : Exception;  -- Erreur levée lorsqu'un test ne passe pas
    A_Ecrire : constant Integer := 6;    -- Nouvel élément à écrire
    Ancien_Elem : Integer;      -- Element présent avant d'être remplacé
begin
    Put_Line("Initialisation de l'arbre");
    Initialiser(Arbre);

    New_Line;
    Put_Line("Vidage de l'arbre vide, après test de Est_Vide sur celui-ci");
    if Est_Vide(Arbre) then
        Vider(Arbre);
    else
        raise Erreur_Dans_Les_Tests;
    end if;

    New_Line;
    Put_Line("Ajout d'élement dans l'arbre");
    Initialiser(Arbre);
    Ajouter_Element(Arbre, 2, 1);

    New_Line;
    Put_Line("Test si l'arbre est une feuille ");
    if Est_Feuille(Arbre) then
        Null;
    else
        raise Erreur_Dans_Les_Tests;
    end if;

    New_Line;
    Put_Line("Affichage de l'arbre, on est sensé obtenir :   2 -- 1 |");
    Afficher(Arbre);
    New_Line;

    New_Line;
    Put_Line("Nouvel affichage, on est sensé obtenir :");
    Put_Line(" 2 --  1 |  7 --  4 |  7 --  1 |  2 --  1 |  20 --  5 |  21 --  2 |  21 --  2 |  20 --  2 |  21 --  2 |  29 --  3 |  21 --  2 |  2 --  1 |");
    Ajouter_Element(Arbre, 21, 2);
    Ajouter_Element(Arbre, 29, 3);
    Ajouter_Element(Arbre, 7, 4);
    Ajouter_Element(Arbre, 20, 5);
    Afficher(Arbre);
    New_Line;

    New_Line;
    Put_Line("Trouver un élément dans l'arbre à l'aide d'une clé");
    if Trouver(Arbre, 29) = 3 and Trouver(Arbre, 21) = 2 then
        Null;
    else
        raise Erreur_Dans_Les_Tests;
    end if;

    New_Line;
    Put_Line("On trouve un élément et actualise l'arbre");
    Put_Line("Abre avant éxecution :");
    Afficher(Arbre);
    New_Line;
    Trouver_Et_Actualiser(Ancien_Elem, Arbre, 7, A_Ecrire);
    Put_Line("Abre après éxecution :");
    Afficher(Arbre);
    New_Line;
    if Trouver(Arbre, 7) = 6 then
        Null;
    else
        raise Erreur_Dans_Les_Tests;
    end if;

    New_Line;
    Put_Line("Suppression du plus ancien élément de l'arbre");
    Put_Line("Abre avant éxecution :");
    Afficher(Arbre);
    New_Line;
    Supprimer_Plus_Ancien(Arbre);
    Put_Line("Abre après éxecution :");
    Afficher(Arbre);
    New_Line;
    begin
        Put(Integer'Image(Trouver(Arbre, 2)));
    exception when Element_Absent_Error => Put_Line("Element bien retiré");
    end;


    New_Line;
    Put_Line("Vidage de l'arbre non vide");
    Vider(Arbre);

    Put_Line("");
    Put_Line("");
    Put_Line("##################################################");
    Put_Line("#################### ALL OK ! ####################");
    Put_Line("##################################################");
    Put_Line("");
exception
    when Erreur_Dans_Les_Tests => 
        Put_Line("");
        Put_Line("######################################################");
        Put_Line("#################### TEST ECHOUE  ####################");
        Put_Line("######################################################");
        Put_Line("");
end Test_Arbre_Prefixe;
