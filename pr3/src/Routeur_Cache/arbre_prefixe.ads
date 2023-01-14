generic
    -- Type des éléments contenus dans l’arbre
    type T_Element is private;
    -- Type des clés contenues dans l’arbre
    type T_Cle is private;

    -- Longueur de l’alphabet des mots reconnus par l’arbre
    Nombre_Prefixes : Natural;

    -- Lire_Prefixe permet de déterminer quel préfixe (donc enfant) choisir
    -- Renvoie un entier entre 1 et Nombre_Prefixes
    with function Lire_Prefixe (Cle : in T_Cle; Indice : in Natural) return Natural;

package Arbre_Prefixe is

    type T_Trie is limited private;
    type T_Noeud is limited private;

    Element_Absent_Error : Exception;



    -- Initialiser un Arbre Vide (pointeur NULL)
    procedure Initialiser (Arbre : out T_Trie) with
        post => Est_Vide(Arbre);

    -- Vider un Arbre en supprimant tous ses éléments et en libérer la mémoire utilisée
    procedure Vider (Arbre : in out T_Trie) with
        post => Est_Vide(Arbre);

    -- Tester si l’arbre passé en paramètre est vide (True si Arbre est vide)
    function Est_Vide (Arbre : in T_Trie) return Boolean;

    -- Tester si l’arbre passé en paramètre est une feuille. C’est à dire que tous ses
    -- fils sont des arbres vide
    function Est_Feuille (Arbre : in T_Trie) return Boolean;

    -- Ajouter un élément dans l’arbre que l’on peut retrouver en suivant successivement
    -- le chemin (regarder récursivement dans les bons fils) associé aux lettres de la clé
    -- donné par la fonction Lire_Préfixe
    generic
        with procedure Post_Traitement (Arbre: in out T_Trie);
    procedure Ajouter (Arbre : in out T_Trie; Cle : in T_Cle; Element : in T_Element);

    -- lire la donnée contenue dans la racine de l’arbre passé en paramètre
    function Lire_Donnee_Racine (Arbre : in T_Trie) return T_Element with
        pre => not Est_Vide(Arbre);

    -- lire la clé associée à la donnée contenue dans la racine de l’arbre passé en paramètre
    function Lire_Cle_Racine (Arbre : in T_Trie) return T_Cle with
        pre => not Est_Vide(Arbre);

    -- modifier la donnée contenue dans la racine de l’arbre passé en paramètre
    procedure Ecrire_Donnee_Tete (Arbre : in out T_Trie; Donnee : in T_Element) with
        pre => not Est_Vide(Arbre);

    -- Obtenir une copie du i-eme enfant de l’arbre courant
    function Lire_Ieme_Enfant (Arbre : in T_Trie; i : Natural) return T_Trie with
        pre => not Est_Feuille(Arbre);


    -- Supprime toutes les feuilles de l’arbre F telles que Selection(F) = True.
    -- La fonction générique "Selection" renvoie True si le nœud courant est un parent d’au
    -- moins un nœud à supprimer. Elle renvoie également True si le nœud courant est une feuille
    -- à supprimer de l’arbre. False dans les autres cas.
    --
    -- La fonction Post_Traitement permet d’appliquer un post traitement sur tous les nœud visités,
    -- après la suppression des éléments à supprimer. Et dans l’ordre inverse dans lequel ils ont été visité.
    -- Exemple: On peut utilisé Post_Traitement pour s’assurer que la donnée du nœud parent soit toujours
    --          Egale au minimum de celle de ses enfants, à la fin de l’opération
    generic
        with function Selection (Arbre : in T_Trie) return Boolean;
        with procedure Post_Traitement (Arbre: in out T_Trie);
    procedure Supprimer_Selection (Arbre : in out T_Trie);


    -- Applique un Traitement à tous les nœuds de l’arbre, en suivant l’ordre d’un parcours en profondeur
    -- Exemple: On peut utiliser cette fonction pour créer une procédure pour afficher l’arbre.
    generic
        with procedure Traiter (Arbre : in T_Trie);
    procedure Parcours_Profondeur_Post (Arbre : in T_Trie);

    function Trouver (Arbre : in T_Trie; Cle : in T_Cle) return T_Element;


    -- Chercher une clé dans l’arbre en suivant la méthode habituelle des arbres préfixes (À chaque profondeur
    -- on choisit le fils correspondant au caractère actuel de la clé renvoyé par la fonction Lire_Prefixe).
    -- Quand on arrive sur la feuille finale, on regarde si le mot trouvé correspond aux attentes avec la fonction
    -- Verifier passée en paramètre générique.
    -- Exemple:
    -- Cela permet de trouver l’élément dont la clé est la plus proche de celle passée en paramètre. C’est à dire
    -- la clé la plus longue, incluse dans la clé demandée.
    --
    -- La fonction Post_Traitement permet d’appliquer un post traitement sur tous les nœud visités,
    -- après la suppression des éléments à supprimer. Et dans l’ordre inverse dans lequel ils ont été visité.
    -- Exemple: On peut utilisé Post_Traitement pour s’assurer que la donnée du nœud parent soit toujours
    generic
        with function Verifier (Cle : in T_Cle; Element : in T_Element) return Boolean;
        with procedure Post_Traitement (Arbre: in out T_Trie);
    procedure Chercher_Et_Verifier_Post (Element_Trouve : out T_Element; Arbre : in out T_Trie; Cle : in T_Cle);


    -- Cette procedure est inutilisée dans ce projet, mais reste présente dans le cas d’une éventuelle réutilisation
    -- de ce module dans un projet futur.
    --
    -- À la manière de Supprimer_Selection, cette procedure permet de trouver un élément à l’aide de la fonction
    -- "Selection" passée en paramètre de généricité.
    -- La fonction Selection renvoie True si le nœud courant possède au moins un fils qui satisfait la demande
    -- de l’utilisateur, ou dans le cas d’une feuille, si le nœud courant correspond aux attentes de l’utilisateur.
    --
    -- La fonction Choisir permet, dans le cas de plusieurs occurences trouvées, d’en choisir une seule qui sera renvoyée
    -- à l’utilisateur.
    --
    -- Exemple: Cette fonction peut servir à réimplémenter une table de routage classique en renvoyer le nœud avec le masque
    -- le plus long, qui vérifie la condition de routage du paquet courant : (IP and Masque) = (Adresse and Masque)
    -- (voir Routage_LA.ads)
    --
    -- La fonction Post_Traitement permet d’appliquer un post traitement sur tous les nœud visités,
    -- après la suppression des éléments à supprimer. Et dans l’ordre inverse dans lequel ils ont été visité.
    -- Exemple: On peut utilisé Post_Traitement pour s’assurer que la donnée du nœud parent soit toujours
    generic
        with function Selection (Arbre : in T_Trie) return Boolean;
        with function Choisir (Element1 : in T_Element; Element2 : in T_Element) return T_Element;
        with procedure Post_Traitement (Arbre: in out T_Trie);
    procedure Trouver_Selection_Post (Element_Trouve : out T_Element; Arbre : in out T_Trie);

    private

    type T_Trie is access T_Noeud;

    -- Tableau d’enfant pour prendre en compte des alphabets de longueur quelconque
    type T_Enfants is Array(1..Nombre_Prefixes) of T_Trie;

    type T_Noeud is
        record
            Cle : T_Cle;
            Element : T_Element;
            Enfants : T_Enfants;
        end record;

end Arbre_Prefixe;
