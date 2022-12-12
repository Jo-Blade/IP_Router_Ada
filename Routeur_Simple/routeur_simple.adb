with Ada.Command_Line;          use Ada.Command_Line;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Exceptions;            use Ada.Exceptions;
with Ada.Text_IO;               use Ada.Text_IO;
with Routage;                   use Routage;

procedure Routeur_Simple is
    -- Paramètres de commande
    Afficher_Stats : Boolean := True;       -- Affichage des statistiques, vrai de base
    Nom_Fichier_Table : Unbounded_String := To_Unbounded_String("table.txt");        -- Nom du fichier de la table de routage, table.txt de base
    Nom_Fichier_Paquet : Unbounded_String := To_Unbounded_String("paquets.txt");     -- Nom du fichier des paquets à router, paquets.txt de base
    Nom_Fichier_Resultat : Unbounded_String := To_Unbounded_String("resultats.txt"); -- Nom du fichier où écrire les résultats, resultats.txt de base

    -- zomufoisgufoiusgfoigsfugyiuefuyesfisgfiugfjsgi
    -- Liste chainées
    Tabl : T_LC;    -- A revoir avec routage.ad?

    -- Variables locales
    i : Integer;                        -- Compteur
    Cle : Unbounded_String;             -- Stocke un argument de la ligne de commande
    Ligne : Unbounded_String;           -- Ligne courante du fichier des paquets
    Interface_Nom : Unbounded_String;   -- Nom de l'interface du paquet routé
    Parametre_Inconnu : Exception;      -- Exception lorsque un paramètre inconnu est mis en ligne de commande
    Commande_Inconnue : Exception;      -- Exception lorsque une commande inconnue est mis lue dans Fichier_Paquet
    Fichier_Paquet : File_Type;         -- Fichier où sont les paquets à router
    Fichier_Resultat : File_Type;       -- Fichier où les résultats seront écrits

begin
    -- Lecture les paramètres en entrée
    begin
        i := 1;
        while i <= Argument_Count loop
            -- Lecture du i-ème paramètre
            Cle := To_Unbounded_String (Argument(i));
            -- Traitement du i-ième paramètre
            i := i + 1;
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
            elsif Cle = "-p" then
                Nom_Fichier_Resultat := To_Unbounded_String(Argument(i));
            else
                raise Parametre_Inconnu;
            end if;
            i := i + 1;
        end loop;
    exception
        when Parametre_Inconnu => Put_Line ("Paramètre entré inconnu");
    end;

    -- Initialisaton de la table de routage
    Initialiser (Table);

    -- Gestion des paquets et écriture des résultats
    Open (Fichier_Paquet, In_File, To_String(Nom_Fichier_Paquet));
    Create (Fichier_Resultat, Out_File, To_String(Nom_Fichier_Resultat));
    begin
        loop
            -- Lecture de la ligne courante
            Ligne := Get_Line (Fichier_Paquet);
            Trim (Ligne, Both);
            -- Gestion du de la ligne
            if To_String(Ligne)(1) >= '0' and To_String(Ligne)(1) <= '2' then     -- la ligne est un paquet
                Interface_Nom = Trouver_Interface(Table, Ligne);
                Put (Fichier_Resultat, To_String(Interface_Nom));
            elsif Ligne = "Table" then      -- la ligne commande l'affichage de la table
                Put_Line ("Table (ligne", Integer (Line (Fichier_Paquet)));
                Afficher (Table);
            elsif Ligne = "Fin" then      -- la ligne commande l'affichage de Fin
                Put_Line ("Fin (ligne", Integer (Line (Fichier_Paquet)));
            else
                raise Commande_Inconnue;
            end if;
        exit when End_Of_File (Fichier_Paquet);
        end loop;
    exception when Commande_Inconnue => Put_Line ("Commande inconnue détectée");
    end;
    Close (Fichier_Paquet);
    Close (Fichier_Resultat);

end Routeur_Simple;
