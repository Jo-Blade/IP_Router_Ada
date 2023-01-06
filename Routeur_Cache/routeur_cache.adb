with Ada.Strings;               use Ada.Strings;	
with Ada.Command_Line;          use Ada.Command_Line;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO;               use Ada.Text_IO;
with Routage;                   use Routage;
with IP;                        use IP;
with My_Strings;                use My_Strings;

procedure Routeur_Cache is
    -- Paramètres de commande
    Afficher_Stats : Boolean := True;   -- Affichage des statistiques, vrai de base
    Capacite_Cache : Integer := 0;      -- Capacité du cache, fixé à 0 initialement
    Politique_Cache : Unbounded_String := To_Unbounded_String("FIFO");               -- Politique du cache, FIFO initialement
    Nom_Fichier_Table : Unbounded_String := To_Unbounded_String("table.txt");        -- Nom du fichier de la table de routage, table.txt de base
    Nom_Fichier_Paquet : Unbounded_String := To_Unbounded_String("paquets.txt");     -- Nom du fichier des paquets à router, paquets.txt de base
    Nom_Fichier_Resultat : Unbounded_String := To_Unbounded_String("resultats.txt"); -- Nom du fichier où écrire les résultats, resultats.txt de base

    -- Liste chainées
    Table : T_Table;                    -- La table de routage
    Cache : T_Cache;                    -- Le cache associé à la table de routage

    -- Variables locales
    i : Integer;                        -- Compteur
    Numero_Ligne : Integer;             -- Numéro de la ligne courante
    Cle : Unbounded_String;             -- Stocke un argument de la ligne de commande
    Ligne : Unbounded_String;           -- Ligne courante du fichier des paquets
    Interface_Nom : Unbounded_String;   -- Nom de l'interface du paquet routé
    Parametre_Inconnu : Exception;      -- Exception lorsque un paramètre inconnu est mis en ligne de commande
    Ouverture_Impossible : Exception;   -- Exception lorsque le fichier contenant la table ou le spaquets n'existe pas
    Commande_Inconnue : Exception;      -- Exception lorsque une commande inconnue est lue dans Fichier_Paquet
    Erreur_Dernier_Argument : Exception;-- Exception lorsque le dernier argument rentré en requiert un suivant inexistant
    Erreur_Politique_Incorrecte : Exception;    -- Exception lorsque la politique lue est inconnue
    Fichier_Paquet : File_Type;         -- Fichier où sont les paquets à router
    Fichier_Resultat : File_Type;       -- Fichier où les résultats seront écrits
    Fichier_Table : File_Type;          -- Fichier où est stockée la table de routage
    Taille_Cache_Actuelle : Integer := 0;   -- Taille actuelle du cache, fixé à 0 initialement

    -- Routage_Par_Table s'execute lorsque le cache ne contient pas la route nécessaire
    -- On recherche d'abord dans la table, puis on met à jour le cache
    procedure Routage_Par_Table(Table : in T_Table; IP_A_Router : in T_IP) is
    begin
        -- Recherche de la route dans la table
        Interface_Nom := Trouver_Interface(Table, IP_A_Router);
        -- Mise à jour du cache
        Mise_A_Jour_Cache(Cache, IP_A_Router, Capacite_Cache, Politique_Cache, Taille_Cache_Actuelle, Interface_Nom, Table);
        if Taille_Cache_Actuelle < Capacite_Cache then
            Taille_Cache_Actuelle := Taille_Cache_Actuelle + 1;
        else
            null;
        end if;
        -- Ecriture de la route dans le fichier
        Put_Line (Fichier_Resultat, To_String(IP_Vers_Texte(Texte_Vers_IP(Ligne)) & " " & Interface_Nom));
    end Routage_Par_Table;

begin
    -- Lecture les paramètres en entrée
    i := 1;
    while i <= Argument_Count loop
        begin
            -- Lecture du i-ème paramètre
            Cle := To_Unbounded_String (Argument(i));
            -- Traitement du i-ième paramètre
            i := i + 1;
            if (i > Argument_Count) and (Cle = "-p" or Cle = "-t" or Cle = "-r") then
                raise Erreur_Dernier_Argument;
            else
                if Cle = "-p" then
                    Nom_Fichier_Paquet := To_Unbounded_String(Argument(i));
                elsif Cle = "-c" then
                    Capacite_Cache := Texte_Vers_Entier(Argument(i));
                elsif Cle = "-P" then
                    Politique_Cache  := To_Unbounded_String(Argument(i));
                    if (Politique_Cache /= To_Unbounded_String("FIFO")) and (Politique_Cache /= To_Unbounded_String("LRU")) and (Politique_Cache /= To_Unbounded_String("LFU")) then
                        raise Erreur_Politique_Incorrecte;
                    else
                        null;
                    end if;
                elsif Cle = "-S" then
                    Afficher_Stats := False;
                    i := i - 1;
                elsif Cle = "-s" then
                    Afficher_Stats := True;
                    i := i - 1;
                elsif Cle = "-t" then
                    Nom_Fichier_Table := To_Unbounded_String(Argument(i));
                elsif Cle = "-r" then
                    Nom_Fichier_Resultat := To_Unbounded_String(Argument(i));
                else
                    raise Parametre_Inconnu;
                end if;
                i := i + 1;
            end if;
        exception
            when Parametre_Inconnu => Put_Line ("Le"& Integer'Image (i-1)& "ème paramètre en entrée est inconnu il sera ignoré.");
            when Erreur_Dernier_Argument => Put_Line ("Le dernier argument est incorrect, il sera ignoré.");
            when Erreur_Pas_Un_Entier => Put_Line ("Le"& Integer'Image (i)& "ème paramètre en entrée, la taille du cache, n'est pas un entier. Cette commande sera ignorée.");
            when Erreur_Politique_Incorrecte => Put_Line ("Le"& Integer'Image (i)& "ème paramètre en entrée, la politique du cache, n'est pas connue. Cette commande sera ignorée.");
        end;
    end loop;

    -- Initialisation du cache
    Initialiser_Cache_Vide (Cache);

    -- Initialisaton de la table de routage
    New_Line;
    begin
        Open (Fichier_Table, In_File, To_String(Nom_Fichier_Table));
    exception
        when Name_Error => 
            Put_Line ("Le fichier '"& To_String(Nom_Fichier_Table)& "' n'existe pas. Cette erreur est fatale."); 
            raise Ouverture_Impossible;
    end;
    Initialiser_Table (Table, Fichier_Table);
    Close (Fichier_Table);

    -- Gestion des paquets et écriture des résultats
    begin
        Open (Fichier_Paquet, In_File, To_String(Nom_Fichier_Paquet));
    exception
        when Name_Error => 
            Put_Line ("Le fichier '"& To_String(Nom_Fichier_Paquet)& "' existe pas. Cette erreur est fatale."); 
            raise Ouverture_Impossible;
    end;
    Create (Fichier_Resultat, Out_File, To_String(Nom_Fichier_Resultat));
    i := 0;     -- Compte le nombre de demandes de routage
    loop
        begin
            -- Lecture de la ligne courante
            Ligne := To_Unbounded_String(Get_Line (Fichier_Paquet));
            Trim (Ligne, Both);
            -- Gestion du de la ligne
            if To_String(Ligne)(1) >= '0' and To_String(Ligne)(1) <= '2' then     -- la ligne est un paquet
                -- Je cherche dans le cache si une route correspond, si c'est le cas la route est ajoutée
                -- Le cas échéant, une exception Route_Pas_Dans_Cache est levée.
                -- Il s'agit alors de mettre le cache à jour, tout en routant avec la table de routage.
                i := i + 1;
                --
                --
                --
                --
                --
                --
                Interface_Nom := Trouver_Interface_Cache(Cache, Texte_Vers_IP(Ligne), Politique_Cache);
                Put_Line (Fichier_Resultat, To_String(IP_Vers_Texte(Texte_Vers_IP(Ligne)) & " " & Interface_Nom));
            elsif Ligne = "cache" then      -- la ligne commande l'affichage du cache
                Numero_Ligne := Integer (Line (Fichier_Paquet)) - 1;
                Put_Line ("cache (ligne"& Integer'Image (Numero_Ligne)& ")");
                --
                --
                --
                --
                --
                Afficher_Cache (Cache);
            elsif Ligne = "table" then      -- la ligne commande l'affichage de la table
                Numero_Ligne := Integer (Line (Fichier_Paquet)) - 1;
                Put_Line ("table (ligne"& Integer'Image (Numero_Ligne)& ")");
                Afficher_Table (Table);
            elsif Ligne = "stats" then      -- la ligne commande l'affichage de Fin
                Numero_Ligne := Integer (Line (Fichier_Paquet)) - 1;
                Put_Line ("stats (ligne"& Integer'Image (Numero_Ligne)& ")");
                if i > 1 then
                    Put_Line ("Au cours du programme,"& Integer'Image (i)& " demandes de route ont été effectuées.");
                elsif i = 1 then
                    Put_Line ("Au cours du programme, 1 demande de route a été effectuée.");
                else
                    Put_Line ("Au cours du programme, aucune demande de route n'a été effectuée.");
                end if;
            elsif Ligne = "fin" then      -- la ligne commande l'affichage de Fin
                Numero_Ligne := Integer (Line (Fichier_Paquet)) - 1;
                Put_Line ("fin (ligne"& Integer'Image (Numero_Ligne)& ")");
            else
                Numero_Ligne := Integer (Line (Fichier_Paquet)) - 1;
                raise Commande_Inconnue;
            end if;
        exception 
            when Commande_Inconnue => Put_Line ("Commande inconnue ("& To_String(Ligne)& ") détectée, la ligne"& Integer'Image (Numero_Ligne)&" sera ignorée.");
            --
            --
            --
            --
            -- Exception à définir
            when Route_Pas_Dans_Cache => Routage_Par_Table(Table, Texte_Vers_IP(Ligne));
        end;
        exit when (Ligne = "fin") or End_Of_File (Fichier_Paquet);
    end loop;
    -- Affichage des statistiques
    if Afficher_Stats then
        if i > 1 then
            Put_Line ("Au cours du programme,"& Integer'Image (i)& " demandes de route ont été effectuées.");
        elsif i = 1 then
            Put_Line ("Au cours du programme, 1 demande de route a été effectuée.");
        else
            Put_Line ("Au cours du programme, aucune demande de route n'a été effectuée.");
        end if;
    else
        Null;
    end if;
    Close (Fichier_Paquet);
    Close (Fichier_Resultat);
    Vider_Table (Table);

exception 
    when Route_De_Base_Inconnue => Put_Line ("La route de base '0.0.0.0 0.0.0.0' n'existe pas, cette erreur est fatale.");
    when Ouverture_Impossible => Null;
    when others => Put_Line ("Erreur inconnue, arrêt immédiat du routeur.");
end Routeur_Cache;
