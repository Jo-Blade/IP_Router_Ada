with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with IP;                        use IP;
with Arbre_Prefixe;

with Routage;


package Routage_LA is

  type T_Table is limited private;

  -- Exceptions
  Route_De_Base_Inconnue : Exception;
  Interface_Par_Defaut : Exception;
  Interface_Non_Trouve : Exception;


  -- Initialiser avec la table de routage vide
  procedure Initialiser_Table_Vide (Table_Routage : out T_Table) 
    with Post => Est_Vide(Table_Routage);


    -- Vider la table de routage
    procedure Vider_Table (Table_Routage : in out T_Table) 
      with Post => Est_Vide (Table_Routage);


      -- Dans le cas d’une table de routage classique, utiliser cette fonction
      -- Trouve l'interface correspondant à une IP dans la table de routage
      -- Et met à jour l’id des éléments visités pour savoir quel est l’interface la moins récemment utilisée
      procedure Trouver_Interface_Table (Interface_Nom: out Unbounded_String; Table_Routage : in out T_Table; IP : in T_IP);


      -- Cette fonction ne fonctionne que dans le cas où la Table_Routage est en réalité un cache LA (et est alors plus rapide)
      -- Trouve l'interface correspondant à une IP dans la table de routage
      -- Et met à jour l’id des éléments visités pour savoir quel est l’interface la moins récemment utilisée
      procedure Trouver_Interface_Cache (Interface_Nom: out Unbounded_String; Table_Routage : in out T_Table; IP : in T_IP; Politique_Cache : in Unbounded_String);


      -- Afficher tous les élément de la table de routage
      procedure Afficher_Table(Table_Routage: in T_Table);


        -- Renvoie si la table est vide ou non
        function Est_Vide (Table_Routage : in T_Table) return Boolean;


        -- Met à jour le cache en accord avec la politique et la cohérence du cache
        procedure Mise_A_Jour_Cache(Cache : in out T_Table; IP_A_Router : in T_IP; Capacite_Cache : in Integer;
          Politique_Cache : in Unbounded_String; Taille_Cache_Actuelle : in Integer;
          Interface_Nom : in Unbounded_String; Table : in Routage.T_Table);



        private

        function Lire_Prefixe (Cle : in T_IP; Indice : in Natural) return Natural with
          pre => Indice < 32,
          post => Lire_Prefixe'Result = 1 or Lire_Prefixe'Result = 2;



          -- Type des cellules enregistrées dans la liste chainée représentant la table
          type T_Cellule is
            record
              Masque : T_IP;
              Interface_Nom : Unbounded_String;
              Id : Natural;   --L'Id le plus petit représente l'élément le moins récement utilisé
            end record;

          --Instanciation de arbre_prefixe
          --Clé : contient l'adresse de l'interface
          --Element : contient masque, interface_nom, age.
          package Trie_LA is new Arbre_Prefixe(T_Element => T_Cellule, T_Cle => T_IP, Nombre_Prefixes => 2,
          Lire_Prefixe => Lire_Prefixe);
          use Trie_LA;

          type T_Table is new T_Trie;


end Routage_LA;
