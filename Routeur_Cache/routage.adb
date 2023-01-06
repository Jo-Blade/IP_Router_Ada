with Str_Split;

package body Routage is

    procedure Afficher_Table(Table_Routage: in T_Table) is
        procedure Afficher (Cellule : T_Cellule) is
        begin
          Put_Line(To_String(IP_Vers_Texte(Cellule.Adresse) & " " & IP_Vers_Texte(Cellule.Masque) & " " & Cellule.Interface_Nom));
        end Afficher;

    procedure Afficher_Table_Bis is new Table_LC.Pour_Chaque (Traiter => Afficher);
    begin
        Afficher_Table_Bis (Table_LC.T_LC(Table_Routage));
    end Afficher_Table;


    function Est_Vide_Cache (Cache : in T_Cache) return Boolean is
    begin
        return Cache_LC.Est_Vide(Cache_LC.T_LC(Cache));
    end Est_Vide_Cache;


    function Est_Vide (Table_Routage : in T_Table) return Boolean is
    begin
        return Table_LC.Est_Vide(Table_LC.T_LC(Table_Routage));
    end Est_Vide;


    procedure Vider_Cache (Cache : in out T_Cache) is
    begin
        Cache_LC.Vider(Cache_LC.T_LC(Cache));
    end Vider_Cache;


    procedure Vider_Table (Table_Routage : in out T_Table) is
    begin
        Table_LC.Vider(Table_LC.T_LC(Table_Routage));
    end Vider_Table;


    procedure Initialiser_Table_Vide(Table_Routage : out T_Table) is
    begin
        Initialiser(Table_Routage);
    end Initialiser_Table_Vide;


    procedure Initialiser_Cache_Vide (Cache : out T_Cache) is
    begin
        Initialiser(Cache);
    end Initialiser_Cache_Vide;


    procedure Mise_A_Jour_Cache(Cache : in out T_Cache; IP_A_Router : in T_IP; Capacite_Cache : in Integer;
        Politique_Cache : in Unbounded_String; Taille_Cache_Actuelle : in Integer;
        Interface_Nom : in Unbounded_String; Table : in T_Table) is
        Nouvelle_Cellule : T_Cellule_Cache;    -- Cellule à enregistrer
        Masque_Max : T_IP;

        function Plus_Petit(A : in T_Cellule_Cache; B : in T_Cellule_Cache) return Boolean is
        begin
            return (A.Frequence < B.Frequence);
        end Plus_Petit;

        procedure Inserer_Element is new Cache_LC.Inserer(Plus_Petit => Plus_Petit);

        function Determiner_Masque(Table : in T_Table; IP_A_Router : in T_IP) return T_IP is
            Masque : T_IP;
            
            procedure Traiter(Element : in T_Cellule) is
                Masque_Discriminant : constant T_IP := Discriminant(Element.Adresse, IP_A_Router);
            begin
                if Longueur_IP(Masque_Discriminant) < Longueur_IP(Masque) then
                    Masque := Masque_Discriminant;
                else
                    Null;
                end if;
            end Traiter;

            procedure Pour_Chaque_IP is new Table_LC.Pour_Chaque(Traiter => Traiter);

        begin
            Pour_Chaque_IP(Table_LC.T_LC(Table));
            return Masque;
        end Determiner_Masque;

    begin
        -- On cherche le masque le plus long qui discrimine la route
        Masque_Max := Determiner_Masque(Table, IP_A_Router);

        Nouvelle_Cellule := T_Cellule_Cache'(IP_A_Router, Masque_Max, Interface_Nom, 1);
        -- Ajout de la route au cache
        if (Politique_Cache = To_Unbounded_String("FIFO")) or (Politique_Cache = To_Unbounded_String("LRU")) then
            if Taille_Cache_Actuelle < Capacite_Cache then
                Ajouter_Debut(Cache_LC.T_LC(Cache), Nouvelle_Cellule);
            else
                Cache_LC.Supprimer(Cache_LC.T_LC(Cache), Premier(Cache_LC.T_LC(Cache)));
                Ajouter_Debut(Cache_LC.T_LC(Cache), Nouvelle_Cellule);
            end if;
        else
            Cache_LC.Supprimer(Cache_LC.T_LC(Cache), Premier(Cache_LC.T_LC(Cache)));
            Inserer_Element(Cache_LC.T_LC(Cache), Nouvelle_Cellule);
        end if;
    end Mise_A_Jour_Cache;


    procedure Ajouter_Element (Table_Routage : in out T_Table; Adresse : in T_IP;
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

        procedure Ajouter_Element_Bis is new Table_LC.Enregistrer(Selection => Selection);

        Nouvelle_Cellule : constant T_Cellule := T_Cellule'(Adresse, Masque, Interface_Nom);    -- Cellule à enregistrer
    begin
        -- On remplace l'élément si le couple adresse masque existe déjà, sinon on l'ajoute en tête de liste
        Ajouter_Element_Bis(Table_LC.T_LC(Table_Routage), Nouvelle_Cellule);
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
                Table_LC.Ajouter_Debut(Table_LC.T_LC(Table_Routage), Element);

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

        procedure Pour_Chaque_Interface is new Table_LC.Pour_Chaque (Traiter => Trouver);

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
        Pour_Chaque_Interface (Table_LC.T_LC(Table_Routage));
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
