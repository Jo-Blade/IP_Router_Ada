with Ada.Text_IO;     use Ada.Text_IO;
with Arbre_Prefixe;

procedure Test_Arbre_Prefixe is
    -- Instanciation du module arbre_prefixe avec 2 préfixes
    type T_Cle is mod 2**32;      -- Les clés de l'arbre seront des entiers
    
    function Lire_Prefixe(Cle : in T_Cle; Indice : in Natural) return Natural is
    begin
        -- Ici, on va à gauche si le bit de différence est un 0, à droite si c'est un 1
        if Natural(Cle and (2**(32 - Indice - 1))) = 0 then
            return 1;
        else
            return 2;
        end if;
    end Lire_Prefixe;

    package Trie_2 is new Arbre_Prefixe(T_Element => Integer, T_Cle => T_Cle, Nombre_Prefixes => 2,
    Lire_Prefixe => Lire_Prefixe);
    use Trie_2;


    -- Instanciation de Ajouter
    

    -- Variables locales
    Arbre : T_Trie;     -- Arbre du test
    Erreur_Dans_Les_Tests : Exception;  -- Erreur levée lorsqu'un test ne passe pas
begin
    Put_Line("Initialisation de l'arbre");
    Initialiser(Arbre);

    Put_Line("Vidage de l'arbre vide, après test de Est_Vide sur celui-ci");
    if Est_Vide(Arbre) then
        Vider(Arbre);
    else
        raise Erreur_Dans_Les_Tests;
    end if;

    Put_Line("Ajout d'élement dans l'arbre");
    Initialiser(Arbre);
    Ajouter(Arbre, 2, 1);

    Put_Line("Test si l'arbre est une feuille ");
    if Est_Feuille(Arbre) then
        Null;
    else
        raise Erreur_Dans_Les_Tests;
    end if;

    Put_Line("Vidage de l'arbre non vide");
    Vider(Arbre);

    Put_Line("");
    Put_Line("");
    Put_Line("##################################################");
    Put_Line("#################### ALL OK ! ####################");
    Put_Line("##################################################");
    Put_Line("");
exception
    when Erreur_Dans_Les_Tests => 
        Put_Line("");
        Put_Line("######################################################");
        Put_Line("#################### TEST ECHOUE  ####################");
        Put_Line("######################################################");
        Put_Line("");
end Test_Arbre_Prefixe;
