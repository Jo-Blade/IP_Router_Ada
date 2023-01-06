generic
type T_Element is private;
type T_Cle is private;

Nombre_Prefixes : Natural;

with function Lire_Prefixe (Cle : in T_Cle; Indice : in Natural) return Natural;

package Arbre_Prefixe is

  type T_Trie is limited private;
  type T_Noeud is limited private;

  Element_Absent_Error : Exception;

  --RAJOUTER LES POST ET PRECONDITIONS DANS CE MODULE

  procedure Initialiser (Arbre : out T_Trie) with
    post => Est_Vide(Arbre);

    procedure Vider (Arbre : in out T_Trie) with
      post => Est_Vide(Arbre);

      function Est_Vide (Arbre : in T_Trie) return Boolean;

      function Est_Feuille (Arbre : in T_Trie) return Boolean;

      -- IMPORTANT IL MANQUE DES EXCEPTIONS (ex: si le préfixe n’existe pas)
      -- la post condition est exécutée sur tous les arbres VISITÉS APRÈS QUE L’ÉLÉMENT AIE ÉTÉ AJOUTÉ
      -- DANS L’ORDRE DÉCROISSANT DES PROFONDEURS (utile pour mettre à jour un minimum par exemple)
      -- va falloir que je change noeud par arbre je pense
      generic
      with procedure Post_Traitement (Arbre: in out T_Trie);
      procedure Ajouter (Arbre : in out T_Trie; Cle : in T_Cle; Element : in T_Element);

      -- NE PAS OUBLIER DE RAJOUTER LES EXCEPTIONS TRIE_VIDE OU UNE PRÉCONDITION
      -- lire la donnee en tête de l’arbre (rajouter la meme pour la clé)
      function Lire_Donnee_Racine (Arbre : in T_Trie) return T_Element with
        pre => not Est_Vide(Arbre);

      function Lire_Cle_Racine (Arbre : in T_Trie) return T_Cle with
        pre => not Est_Vide(Arbre);

        -- affecter la donnée en tête de l’arbre (ne pas rajouter la même pour la clé, sinon ça va faire des trucs bizarres)
        procedure Ecrire_Donnee_Tete (Arbre : in out T_Trie; Donnee : in T_Element) with
          pre => not Est_Vide(Arbre);

          -- renvoie une copie du ieme enfant de l’arbre
          -- NE PAS OUBLIER DE RAJOUTER LES PRE ET POST
          function Lire_Ieme_Enfant (Arbre : in T_Trie; i : Natural) return T_Trie with
            pre => not Est_Feuille(Arbre);

            -- Selection est une fonction qui recevra l’arbre courant
            -- si c’est une feuille => true = à supprimer, false = ne rien faire
            -- sinon => true = l’élément à supprimer est un noeud, false = arreter de parcourir cet arbre
            -- jsuis pas sur de cette idée … mais ça devrait marcher pour la recherche du min (on stocke le min dans une
            -- variable "globale" et on renvoie true si arbre.all.element.min = global_min)
            generic
            with function Selection (Arbre : in T_Trie) return Boolean;
            with procedure Post_Traitement (Arbre: in out T_Trie);
            procedure Supprimer_Selection (Arbre : in out T_Trie);

            -- changer Noeud en T_Trie ?
            --  generic
            --    with procedure Post_Traitement (Noeud : in out T_Noeud);
            --  procedure Trouver (Element : out T_Element; Arbre : in T_Trie; Cle : in T_Cle);

            -- IMPORTANT IL MANQUE DES EXCEPTIONS
            -- je vais changer traiter pour envoyer un arbre ?
            -- et créer 2 fonctions get_Cle et get_Element pour l’utilisateur
            generic
            with procedure Traiter (Cle : in T_Cle; Element : in T_Element);
            procedure Parcours_Profondeur_Post (Arbre : in T_Trie);

            function Trouver (Arbre : in T_Trie; Cle : in T_Cle) return T_Element;

            --  generic
            --    with procedure Post_Traitement (Arbre: in out T_Trie);
            --  procedure Trouver_Post (Element_Trouve : out T_Element; Arbre : in out T_Trie; Cle : in T_Cle);

            -- Cette procedure cherche une clé dans l’arbre
            -- et quand elle arrive sur la feuille finale, vérifie si la condition
            -- Vérifier est vrai.
            -- On va donc examiner l’élément du tableau avec la clé la plus longue contenue dans Cle
            -- et appliquer, si cette élément vérifie la condition, un post traitement à tous les noeuds visités
            generic
            with function Verifier (Cle : in T_Cle; Element : in T_Element) return Boolean;
            with procedure Post_Traitement (Arbre: in out T_Trie);
            procedure Chercher_Et_Verifier_Post (Element_Trouve : out T_Element; Arbre : in out T_Trie; Cle : in T_Cle);


            -- Cette fonction sera normalement inutilisée dans le projet
            -- mais pourrait être utilisée pour implémenter une table de routage classique
            -- (même si on perd un peu l’interet de la structure d’arbre)
            generic
            with function Selection (Arbre : in T_Trie) return Boolean;
            with function Choisir (Element1 : in T_Element; Element2 : in T_Element) return T_Element;
            with procedure Post_Traitement (Arbre: in out T_Trie);
            procedure Trouver_Selection_Post (Element_Trouve : out T_Element; Arbre : in out T_Trie);

            private

            type T_Trie is access T_Noeud;

            type T_Enfants is Array(1..Nombre_Prefixes) of T_Trie;

            type T_Noeud is
              record
                Cle : T_Cle;
                Element : T_Element;
                Enfants : T_Enfants;
              end record;

end Arbre_Prefixe;
