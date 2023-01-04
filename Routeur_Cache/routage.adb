with Str_Split;

package body Routage is

    procedure Afficher_Table(Table_Routage: in T_Table) is
        procedure Afficher (Cellule : T_Cellule) is
        begin
          Put_Line(To_String(IP_Vers_Texte(Cellule.Adresse) & " " & IP_Vers_Texte(Cellule.Masque) & " " & Cellule.Interface_Nom));
        end Afficher;

        procedure Afficher_Table_Bis is new Pour_Chaque (Traiter => Afficher);
    begin
        Afficher_Table_Bis (T_LC(Table_Routage));
    end Afficher_Table;


    function Est_Vide (Table_Routage : in T_Table) return Boolean is
    begin
        return Table_LC.Est_Vide(T_LC(Table_Routage));
    end Est_Vide;


    procedure Vider_Table (Table_Routage : in out T_Table) is
    begin
        Table_LC.Vider(T_LC(Table_Routage));
    end Vider_Table;


    procedure Initialiser_Table_Vide(Table_Routage : out T_Table) is
    begin
        Initialiser(Table_Routage);
    end Initialiser_Table_Vide;


    procedure Ajouter_Element (Table_Routage : out T_Table; Adresse : in T_IP;
        Masque : in T_IP; Interface_Nom : in Unbounded_String) is

        -- Ici on cherche s'il existe déjà un couple adresse masque dans la table de routage
        function Selection (Cellule : in T_Cellule) return Boolean is
            Test : Boolean;     -- Garde en mémoire le véracité du test voulu
        begin
            if (Cellule.Adresse = Adresse) and (Cellule.Masque = Masque) then
                Test := True;
            else
                Test := False;
            end if;
            return Test;
        end Selection;

        procedure Ajouter_Element_Bis is new Enregistrer(Selection => Selection);

        Nouvelle_Cellule : constant T_Cellule := T_Cellule'(Adresse, Masque, Interface_Nom);    -- Cellule à enregistrer
    begin
        -- On remplace l'élément si le couple adresse masque existe déjà, sinon on l'ajoute en tête de liste
        Ajouter_Element_Bis(T_LC(Table_Routage), Nouvelle_Cellule);
    end Ajouter_Element;


    procedure Initialiser_Table (Table_Routage : out T_Table; Fichier : in File_Type) is   
        -- Instanciation de split avec 3 paramètres de sortie => adresse, masque, interface
        package Split3 is new Str_Split(NbrArgs => 3);
        use Split3;

        Tableau : T_TAB;            -- tableau pour la fonction Texte_Vers_IP
        Ligne : Unbounded_String;   -- ligne courante du fichier
        Element : T_Cellule;        -- Element construit à partir de la ligne courante
        Masque_Valide : Integer;    -- Utilisé pour vérifier si le masque retiré est valide

        Route_Base_Existe : Boolean; -- utilisé pour vérifier que la route par défaut existe bien (a supprimer vu que c’est pas vrai pour les caches)
    begin
      Route_Base_Existe := False;

        loop
            begin
                Ligne := To_Unbounded_String(Get_Line(Fichier));    -- recupération de la ligne courante
                Split(Tableau, Ligne, ' ');                         -- séparation des éléments
                Element.Adresse := Texte_Vers_IP(Tableau(1));       -- transformation en IP et affectation à élément
                Element.Masque := Texte_Vers_IP(Tableau(2));        -- Idem pour le masque
                Masque_Valide := Longueur_IP(Element.Masque);       -- Si le masque n'est pas valide, une exception sera levée dans Longueur_IP
                Masque_Valide := Masque_Valide - Masque_Valide;     -- Permet d'enlever le warning de non-utilisation
                Element.Interface_Nom := Tableau(3);                -- affectation de l'interface dans la dernière case d'élement
                Table_LC.Ajouter_Debut(T_LC(Table_Routage), Element);

                if Element.Adresse = Texte_Vers_IP(To_Unbounded_String("0.0.0.0")) and Element.Masque = Texte_Vers_IP(To_Unbounded_String("0.0.0.0")) then
                  Route_Base_Existe := True;
                else
                  Null;
                end if;
            exception
                    -- On ignore la ligne du fichier et on reprend l'analyse
                when others =>
                    Put_Line("La ligne : '"& To_String(Ligne)& "' est invalide, elle sera ignorée.");
            end;
            exit when End_Of_File(Fichier);
        end loop;
        -- A MODIFIER IMPERATIVEMENT !!!!!!
        -- On peut régler les problèmes d'exceptions en ajoutant un argument en entrée pour différencier le cas table ou cache
        -- une string ou autre par exemple
        if Route_Base_Existe then
            Null;
        else
            Vider_Table (Table_Routage);
            raise Route_De_Base_Inconnue; 
        end if;
    end Initialiser_Table; 


    function Trouver_Interface (Table_Routage : in T_Table; IP : in T_IP) return Unbounded_String is
        -- Variables locales
        Longueur_Max : Integer;                 -- Plus grande longueur de masque
        Interface_Trouve : Unbounded_String;    -- Nom de l'interface vers laquelle sera routé le paquet, "eth0" de base

        -- Définition de la procedure Trouver qui s'appliquera pour chaque élément de la table de routage
        procedure Trouver (Cellule : in T_Cellule) is
            Taille_Masque : Integer;            -- Taille du masque courant
        begin
            Taille_Masque := Longueur_IP(Cellule.Masque);
            if Egalite_IP(IP, Cellule.Adresse, Cellule.Masque) and then (Taille_Masque >= Longueur_Max) then
                Longueur_Max := Taille_Masque;
                Interface_Trouve := Cellule.Interface_Nom;
            else
                Null;
            end if;
        end Trouver;

        procedure Pour_Chaque_Interface is new Pour_Chaque (Traiter => Trouver);

    begin
        -- Instanciation de Pour_Chaque avec Traiter qui prend l'ip et l'élément courant de Table_Routage
        -- On crée une variable """globale""" qui prendra la longueure maximale de masque rencontré (et valide)
        -- Idem pour une variable qui stockera le nom de l'interface
        -- On passe pour chaque élément dans traiter la condition de validité du masque et s'il passe,
        -- on stocke sa longueure et l'interface qui lui est associée
        -- Après le passage de Pour_Chaque, on renvoie l'interface
        --
        -- FAUDRA PAS OUBLIER DE RENVOYER UNE EXCEPTION SI ON NE TROUVE PAS D’INTERFACE (ce qui est censé être
        -- impossible dans le cas du routeur simple car la table contient toujours 0.0.0.0 mais ça sera utile
        -- pour le routeur avec cache)
        Longueur_Max := 0;
        Interface_Trouve := To_Unbounded_String("");
        Pour_Chaque_Interface (T_LC(Table_Routage));
        -- A MODIFIER IMPERATIVEMENT !!!!!!
        -- On peut régler les problèmes d'exceptions en ajoutant un argument en entrée pour différencier le cas table ou cache
        -- une string ou autre par exemple
        if Interface_Trouve = To_Unbounded_String("") then
            raise Interface_Par_Defaut;
        else
            Null;
        end if;
        return Interface_Trouve;
    end Trouver_Interface;

end Routage;
