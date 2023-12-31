with Ada.Text_IO; use Ada.Text_IO;

package body Routage_LA is
    Id_Global : Natural := 0;

    function Lire_Prefixe (Cle : in T_IP; Indice : in Natural) return Natural is
    begin
        return Lire_Bit(Cle, Indice + 1) + 1;
    end Lire_Prefixe;

    procedure Afficher_Table(Table_Routage: in T_Table) is
        procedure Afficher_Noeud (Arbre : in T_Trie) is
            Adresse       : constant Unbounded_String := IP_Vers_Texte(Lire_Cle_Racine(Arbre));
            Masque        : constant Unbounded_String := IP_Vers_Texte(Lire_Donnee_Racine(Arbre).Masque);
            Interface_Nom : constant Unbounded_String := Lire_Donnee_Racine(Arbre).Interface_Nom;
            Id            : constant Natural          := Lire_Donnee_Racine(Arbre).Id;
        begin
            --Put(To_String(Adresse) & " -- " & To_String(Masque) & " -- " & To_String(Cellule.Interface_Nom)
            --& Natural'Image(Cellule.Id) & " | ");

            if Est_Feuille(Arbre) then
                Put_Line(To_String(Adresse) & " " & To_String(Masque) & " " & To_String(Interface_Nom) & " " & Natural'Image(Id));
            else
                Null;
            end if;
        end Afficher_Noeud;


        procedure Afficher_Table_Bis is new Parcours_Profondeur_Post (Traiter => Afficher_Noeud);
    begin
        --Put_Line("Représentation Post-Fixée de l’arbre :");
        Afficher_Table_Bis (T_Trie(Table_Routage));
        New_Line;
    end Afficher_Table;


    function Est_Vide (Table_Routage : in T_Table) return Boolean is
    begin
        return Trie_LA.Est_Vide(T_Trie(Table_Routage));
    end Est_Vide;


    procedure Vider_Table (Table_Routage : in out T_Table) is
    begin
        Vider(T_Trie(Table_Routage));
    end Vider_Table;


    procedure Initialiser_Table_Vide(Table_Routage : out T_Table) is
    begin
        Initialiser(Table_Routage);
    end Initialiser_Table_Vide;


    -- retourne -1 si les 2 sont null
    function Min_Temps_2 (Arbre1 : in T_Trie; Arbre2 : in T_Trie) return Integer is
    begin
        if Est_Vide(Arbre1) and Est_Vide(Arbre2) then
            return -1;
        elsif Est_Vide(Arbre1) then
            return Lire_Donnee_Racine(Arbre2).Id;
        elsif Est_Vide(Arbre2) then
            return Lire_Donnee_Racine(Arbre1).Id;
        elsif Lire_Donnee_Racine(Arbre1).Id < Lire_Donnee_Racine(Arbre2).Id then
            return Lire_Donnee_Racine(Arbre1).Id;
        else
            return Lire_Donnee_Racine(Arbre2).Id;
        end if;
    end Min_Temps_2;


    procedure Trouver_Interface_Cache (Interface_Nom: out Unbounded_String; Table_Routage : in out T_Table; IP : in T_IP; Politique_Cache : in Unbounded_String) is

        procedure Post_Traitement(Arbre : in out T_Trie) is
            Cellule_A_Modifier : T_Cellule;
        begin
            if Est_Feuille(Arbre) then

                if Politique_Cache = To_Unbounded_String("LRU") then

                    Cellule_A_Modifier := Lire_Donnee_Racine(Arbre);
                    Cellule_A_Modifier.Id := Id_Global + 1;
                    Ecrire_Donnee_Tete (Arbre, Cellule_A_Modifier);
                    Id_Global := Id_Global + 1;

                elsif Politique_Cache = To_Unbounded_String("LFU") then

                    Cellule_A_Modifier := Lire_Donnee_Racine(Arbre);
                    Cellule_A_Modifier.Id := Cellule_A_Modifier.Id + 1;
                    Ecrire_Donnee_Tete (Arbre, Cellule_A_Modifier);

                else
                    Null;
                end if;

            else
                Cellule_A_Modifier := Lire_Donnee_Racine(Arbre);
                Cellule_A_Modifier.Id := Min_Temps_2(Lire_Ieme_Enfant(Arbre, 1), Lire_Ieme_Enfant(Arbre, 2));
                Ecrire_Donnee_Tete(Arbre, Cellule_A_Modifier);
            end if;
        end Post_Traitement;

        function Verifier (Adresse_A_Verifier : in T_IP; Cellule_A_Verifier : in T_Cellule) return Boolean is
        begin
            if Egalite_IP(IP, Adresse_A_Verifier, Cellule_A_Verifier.Masque) then
                return True;
            else
                return False;
            end if;
        end Verifier;

        procedure Trouver_Et_Actualiser is new Chercher_Et_Verifier_Post (Verifier => Verifier, Post_Traitement => Post_Traitement);

        Cellule_Trouvee : T_Cellule;
    begin
        Trouver_Et_Actualiser (Cellule_Trouvee, T_Trie(Table_Routage), IP);
        Interface_Nom := Cellule_Trouvee.Interface_Nom;
    exception
        when Element_Absent_Error => raise Interface_Non_Trouve;
    end Trouver_Interface_Cache;




    procedure Trouver_Interface_Table (Interface_Nom: out Unbounded_String; Table_Routage : in out T_Table; IP : in T_IP) is

        procedure Post_Traitement(Arbre : in out T_Trie) is
            Cellule_A_Modifier : T_Cellule;
        begin
            if Est_Feuille(Arbre) then
                Cellule_A_Modifier := Lire_Donnee_Racine(Arbre);
                Cellule_A_Modifier.Id := Id_Global + 1;
                Ecrire_Donnee_Tete (Arbre, Cellule_A_Modifier);
                Id_Global := Id_Global + 1;
            else
                Cellule_A_Modifier := Lire_Donnee_Racine(Arbre);
                Cellule_A_Modifier.Id := Min_Temps_2(Lire_Ieme_Enfant(Arbre, 1), Lire_Ieme_Enfant(Arbre, 2));
                Ecrire_Donnee_Tete(Arbre, Cellule_A_Modifier);
            end if;
        end Post_Traitement;

        function Selection (Arbre : in T_Trie) return Boolean is
            Cellule_A_Verifier : constant T_Cellule := Lire_Donnee_Racine(Arbre);
            Adresse_A_Verifier : constant T_IP := Lire_Cle_Racine(Arbre);
        begin
            if not Est_Feuille(Arbre) or Egalite_IP(IP, Adresse_A_Verifier, Cellule_A_Verifier.Masque) then
                return True;
            else
                return False;
            end if;
        end Selection;

        function Choisir (Element1 : in T_Cellule; Element2 : in T_Cellule) return T_Cellule is
        begin
            if Longueur_IP(Element1.Masque) > Longueur_IP(Element2.Masque) then
                return Element1;
            else
                return Element2;
            end if;
        end Choisir;

        procedure Trouver_Et_Actualiser is new Trouver_Selection_Post(Selection => Selection, Post_Traitement => Post_Traitement, Choisir => Choisir);

        Cellule_Trouvee : T_Cellule;
    begin
        Trouver_Et_Actualiser (Cellule_Trouvee, T_Trie(Table_Routage));
        Interface_Nom := Cellule_Trouvee.Interface_Nom;
    exception
        when Element_Absent_Error => raise Interface_Non_Trouve;
    end Trouver_Interface_Table;




    procedure Mise_A_Jour_Cache(Cache : in out T_Table; IP_A_Router : in T_IP; Capacite_Cache : in Integer;
        Politique_Cache : in Unbounded_String; Taille_Cache_Actuelle : in Integer;
        Interface_Nom : in Unbounded_String; Table : in Routage.T_Table) is

        Masque_Max : T_IP;
        Min_Id : Natural;
        Premier_Trouve : Boolean;

        function Selection_Premier_Min (Arbre : in T_Trie) return Boolean is
            Test : constant Boolean := Premier_Trouve and Lire_Donnee_Racine(Arbre).Id = Min_Id;
        begin
            if Test and Est_Feuille(Arbre) then
                Premier_Trouve := False;
            else
                Null;
            end if;
            return Test;
        end Selection_Premier_Min;


        procedure Mettre_A_Jour (Arbre : in out T_Trie) is
            Cellule_A_Modifier : T_Cellule;
        begin
            if Est_Vide(Arbre) or Est_Feuille(Arbre) then
                Null;
            else
                Cellule_A_Modifier := Lire_Donnee_Racine(Arbre);
                Cellule_A_Modifier.Id := Min_Temps_2(Lire_Ieme_Enfant(Arbre, 1), Lire_Ieme_Enfant(Arbre, 2));
                Ecrire_Donnee_Tete(Arbre, Cellule_A_Modifier);
            end if;
        end Mettre_A_Jour;

        procedure Ajouter_Arbre is new Ajouter (Post_Traitement => Mettre_A_Jour);

        procedure Supprimer_Premier_Min is new Supprimer_Selection(Selection => Selection_Premier_Min, Post_Traitement => Mettre_A_Jour);

    begin
        if Capacite_Cache = 0 then
            Null;
        else
            -- On cherche le masque le plus long qui discrimine la route
            Masque_Max := Routage.Determiner_Masque_Cache(Table, IP_A_Router);

            if Taille_Cache_Actuelle < Capacite_Cache then
                Null;
            else
                Premier_Trouve := True;
                Min_Id := Lire_Donnee_Racine(Cache).Id;
                Supprimer_Premier_Min(T_Trie(Cache));
            end if;

            if (Politique_Cache = To_Unbounded_String("FIFO")) or (Politique_Cache = To_Unbounded_String("LRU")) then
                Ajouter_Arbre(T_Trie(Cache), IP_A_Router, T_Cellule'(Masque_Max, Interface_Nom, Id_Global + 1));
                Id_Global := Id_Global + 1;
            else
                Ajouter_Arbre(T_Trie(Cache), IP_A_Router, T_Cellule'(Masque_Max, Interface_Nom, 1));
            end if;
        end if;
    end Mise_A_Jour_Cache;

end Routage_LA;
