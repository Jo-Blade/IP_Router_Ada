with Ada.Text_IO;               use Ada.Text_IO;

package body Routage_LL is

  procedure Afficher_Cache(Cache: in T_Table; Politique_Cache : in Unbounded_String) is
    procedure Afficher (Cellule : T_Cellule_Cache) is
    begin
      if Politique_Cache = To_Unbounded_String("LFU") then
        Put_Line(To_String(IP_Vers_Texte(Cellule.Adresse) & " " & IP_Vers_Texte(Cellule.Masque) & " " & Cellule.Interface_Nom & " " & Integer'Image(Cellule.Frequence)));
      else
        Put_Line(To_String(IP_Vers_Texte(Cellule.Adresse) & " " & IP_Vers_Texte(Cellule.Masque) & " " & Cellule.Interface_Nom));
      end if;
    end Afficher;

    procedure Afficher_Cache_Bis is new Cache_LC.Pour_Chaque (Traiter => Afficher);
  begin
    Afficher_Cache_Bis (Cache_LC.T_LC(Cache));
  end Afficher_Cache;


  function Est_Vide (Table_Routage : in T_Table) return Boolean is
  begin
    return Cache_LC.Est_Vide(Cache_LC.T_LC(Table_Routage));
  end Est_Vide;


  procedure Vider_Table (Table_Routage : in out T_Table) is
  begin
    Cache_LC.Vider(Cache_LC.T_LC(Table_Routage));
  end Vider_Table;


  procedure Initialiser_Table_Vide (Table_Routage : out T_Table) is
  begin
    Initialiser(Table_Routage);
  end Initialiser_Table_Vide;


  procedure Mise_A_Jour_Cache(Cache : in out T_Table; IP_A_Router : in T_IP; Capacite_Cache : in Integer;
    Politique_Cache : in Unbounded_String; Taille_Cache_Actuelle : in Integer;
    Interface_Nom : in Unbounded_String; Table : in Routage.T_Table) is

    Nouvelle_Cellule : T_Cellule_Cache;    -- Cellule à enregistrer
    Masque_Max : T_IP;                     -- Masque à ajouter au Cache

    -- Cherche le masque minimal discriminant 2 IP
    function Plus_Petit(A : in T_Cellule_Cache; B : in T_Cellule_Cache) return Boolean is
    begin
      return (A.Frequence <= B.Frequence);
    end Plus_Petit;

    procedure Inserer_Element is new Cache_LC.Inserer(Plus_Petit => Plus_Petit);

  begin
    if Capacite_Cache = 0 then
      Null;
    else
      -- On cherche le masque le plus long qui discrimine la route
      Masque_Max := Routage.Determiner_Masque_Cache(Table, IP_A_Router);

      Nouvelle_Cellule := T_Cellule_Cache'(IP_A_Router, Masque_Max, Interface_Nom, 1);
      -- Ajout de la route au cache
      if Est_Vide (Cache) then
        Ajouter_Debut(Cache, Nouvelle_Cellule);
      else
        if (Politique_Cache = To_Unbounded_String("FIFO")) or (Politique_Cache = To_Unbounded_String("LRU")) then
          if Taille_Cache_Actuelle < Capacite_Cache then
            Ajouter_Fin(Cache, Nouvelle_Cellule);
          else
            Ajouter_Fin(Cache, Nouvelle_Cellule);
            Cache_LC.Supprimer(Cache_LC.T_LC(Cache), Premier(Cache_LC.T_LC(Cache)));
          end if;
        else
          if Taille_Cache_Actuelle < Capacite_Cache then
            Ajouter_Debut(Cache_LC.T_LC(Cache), Nouvelle_Cellule);
          else
            Inserer_Element(Cache_LC.T_LC(Cache), Nouvelle_Cellule);
            Cache_LC.Supprimer(Cache_LC.T_LC(Cache), Premier(Cache_LC.T_LC(Cache)));
          end if;
        end if;
      end if;
    end if;
  end Mise_A_Jour_Cache;


  procedure Trouver_Interface_Cache (Interface_Nom: out Unbounded_String; Table_Routage : in out T_Table; IP : in T_IP; Politique_Cache : in Unbounded_String) is
    -- Variables locales
    Longueur_Max : Integer;                 -- Plus grande longueur de masque
    Interface_Trouve : Unbounded_String;    -- Nom de l'interface vers laquelle sera routé le paquet
    Est_Routable : Boolean := False;        -- Stocke si un routage est possible ou non via le cache
    Route_Valide : T_Cellule_Cache;         -- La route choisie
    Route_Temp : T_Cellule_Cache;           -- Route temporaire pour l'extraction de route valide du cache

    -- Définition de la procedure Trouver qui s'appliquera pour chaque élément de la table de routage
    procedure Trouver (Cellule : in T_Cellule_Cache) is
      Taille_Masque : Integer;            -- Taille du masque courant
    begin
      Taille_Masque := Longueur_IP(Cellule.Masque);
      if Egalite_IP(IP, Cellule.Adresse, Cellule.Masque) and then (Taille_Masque >= Longueur_Max) then
        Longueur_Max := Taille_Masque;
        Interface_Trouve := Cellule.Interface_Nom;
        Est_Routable := True;
        Route_Valide := Cellule;
      else
        Null;
      end if;
    end Trouver;

    procedure Pour_Chaque_Interface is new Cache_LC.Pour_Chaque (Traiter => Trouver);

    -- Extraction de l'élément à replacer dans le cache
    function Selection_Extraction (Element : in T_Cellule_Cache) return Boolean is
    begin
      return Element = Route_Valide;
    end Selection_Extraction;

    procedure Extraire_Debut_Cache is new Cache_LC.Extraire (Selection => Selection_Extraction);

    -- Insère l'élément précédemment extrait à la fin du cache pour conserver la cohérence
    function Plus_Petit (Element_A : in T_Cellule_Cache; Element_B : in T_Cellule_Cache) return Boolean is
      Test : Boolean;         -- Résultat du test de Plus_Petit
    begin
      if Politique_Cache = To_Unbounded_String("LRU") then
        Test := True;
      elsif Politique_Cache = To_Unbounded_String("LFU") then
        Test := (Element_A.Frequence > Element_B.Frequence);
      else
        Null;
      end if;
      return Test;
    end Plus_Petit;

    procedure Inserer_Fin_Cache is new Cache_LC.Inserer (Plus_Petit => Plus_Petit);

  begin
    Longueur_Max := 0;
    Interface_Trouve := To_Unbounded_String("");
    Pour_Chaque_Interface (Cache_LC.T_LC(Table_Routage));
    if not Est_Routable then
      raise Interface_Non_Trouve;
    elsif (Politique_Cache = To_Unbounded_String("LRU")) or (Politique_Cache = To_Unbounded_String("LFU")) then
      Extraire_Debut_Cache(Route_Temp, Cache_LC.T_LC(Table_Routage));
      Route_Temp.Frequence := Route_Temp.Frequence + 1;
      Inserer_Fin_Cache(Cache_LC.T_LC(Table_Routage), Route_Temp);
    else
      Null;
    end if;
    Interface_Nom := Interface_Trouve;
  end Trouver_Interface_Cache;

end Routage_LL;
