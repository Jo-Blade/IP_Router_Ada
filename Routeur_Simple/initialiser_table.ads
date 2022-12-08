-- Initialiser la table de routage avec le fichier dédié
function Initialiser_Table (Table: out T_Liste; Fichier : in File_Type) return T_Liste with;
    Post => not Est_Vide (Table)
        and Contient (Table, Texte_Vers_IP("0.0.0.0"), "eth0");
