-- Initialiser la table de routage avec le fichier dédié
function Initialiser_Table (Table: out T_LC; Fichier : in File_Type) return T_LC with;
    Pre => Est_Present (Fichier);
    Post => not Est_Vide (Table)
        and Contient (Table, Texte_Vers_IP("0.0.0.0"), "eth0");