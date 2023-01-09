with Ada.Text_IO;     use Ada.Text_IO;
with Arbre_Prefixe;

procedure Test_Arbre_Prefixe is
    -- Instanciation du module arbre_prefixe avec 2 préfixes
    package Trie_2 is new Arbre_Prefixe(T_Element => Integer, T_Cle => T_Cle, Nombre_Prefixes => 2,
    Lire_Prefixe => Lire_Prefixe);
    use Trie_2;

    Arbre : T_Trie;     -- Arbre du test
begin
    Put_Line("Initialisation de l'arbre");
    Initialiser(Arbre);

    Put_Line("");
    Put_Line("");
    Put_Line("##################################################");
    Put_Line("#################### ALL OK ! ####################");
    Put_Line("##################################################");
    Put_Line("");
end Test_Arbre_Prefixe;
