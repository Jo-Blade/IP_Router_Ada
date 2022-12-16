with Ada.Strings;               use Ada.Strings;	-- pour Both utilisé par Trim
with Ada.Command_Line;          use Ada.Command_Line;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO;               use Ada.Text_IO;
with Routage;                   use Routage;
with IP;                        use IP;

procedure Routeur_Simple is
    -- Paramètres de commande
    Afficher_Stats : Boolean := True;   -- Affichage des statistiques, vrai de base
    Nom_Fichier_Table : Unbounded_String := To_Unbounded_String("table.txt");        -- Nom du fichier de la table de routage, table.txt de base
    Nom_Fichier_Paquet : Unbounded_String := To_Unbounded_String("paquets.txt");     -- Nom du fichier des paquets à router, paquets.txt de base
    Nom_Fichier_Resultat : Unbounded_String := To_Unbounded_String("resultats.txt"); -- Nom du fichier où écrire les résultats, resultats.txt de base

    -- Liste chainées
    Table : T_Table;                    -- La table de routage

    -- Variables locales
    i : Integer;                        -- Compteur
    Numero_Ligne : Integer;             -- Numéro de la ligne courante
    Cle : Unbounded_String;             -- Stocke un argument de la ligne de commande
    Ligne : Unbounded_String;           -- Ligne courante du fichier des paquets
    Interface_Nom : Unbounded_String;   -- Nom de l'interface du paquet routé
    Parametre_Inconnu : Exception;      -- Exception lorsque un paramètre inconnu est mis en ligne de commande
    Ouverture_Impossible : Exception;   -- Exception lorsque le fichier contenant la table ou le spaquets n'existe pas
    Commande_Inconnue : Exception;      -- Exception lorsque une commande inconnue est lue dans Fichier_Paquet
    Commande_Fin : Exception;           -- Exception lorsque une la commande fin est lue dans Fichier_Paquet
    Erreur_Dernier_Argument : Exception;-- Exception lorsque le dernier argument rentré en requiert un suivant inexistant
    Fichier_Paquet : File_Type;         -- Fichier où sont les paquets à router
    Fichier_Resultat : File_Type;       -- Fichier où les résultats seront écrits
    Fichier_Table : File_Type;          -- Fichier où est stockée la table de routage

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
            end;
        end loop;

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
                i := i + 1;
                Interface_Nom := Trouver_Interface(Table, Texte_Vers_IP(Ligne));
                Put_Line (Fichier_Resultat, To_String(IP_Vers_Texte(Texte_Vers_IP(Ligne)) & " " & Interface_Nom));
            elsif Ligne = "table" then      -- la ligne commande l'affichage de la table
                Numero_Ligne := Integer (Line (Fichier_Paquet));
                Put_Line ("table (ligne"& Integer'Image (Numero_Ligne)& ")");
                Afficher_Table (Table);
            elsif Ligne = "stats" then      -- la ligne commande l'affichage de Fin
                Numero_Ligne := Integer (Line (Fichier_Paquet));
                Put_Line ("fin (ligne"& Integer'Image (Numero_Ligne)& ")");
                if i > 1 then
                    Put_Line ("Au cours du programme,"& Integer'Image (i)& " demandes de route ont été effectuées.");
                elsif i = 1 then
                    Put_Line ("Au cours du programme, 1 demande de route a été effectuée.");
                else
                    Put_Line ("Au cours du programme, aucune demande de route n'a été effectuée.");
                end if;
            elsif Ligne = "fin" then      -- la ligne commande l'affichage de Fin
                Numero_Ligne := Integer (Line (Fichier_Paquet));
                Put_Line ("fin (ligne"& Integer'Image (Numero_Ligne)& ")");
                Close (Fichier_Paquet);
                Close (Fichier_Resultat);
                Vider_Table (Table);
                raise Commande_Fin;
            else
                Numero_Ligne := Integer (Line (Fichier_Paquet));
                raise Commande_Inconnue;
            end if;
        exception when Commande_Inconnue => Put_Line ("Commande inconnue ("& To_String(Ligne)& ") détectée, la ligne"& Integer'Image (Numero_Ligne - 1)&" sera ignorée.");
        end;
    exit when End_Of_File (Fichier_Paquet);
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
    when Commande_Fin => Null;
    when Ouverture_Impossible => Null;
    when others => Put_Line ("Erreur inconnue, arrêt immédiat du routeur.");
end Routeur_Simple;
