with My_Strings;         use My_Strings;
with Str_Split;

package body IP is

    function Entier_Vers_IP (n : in Integer) return T_IP is
    begin
        return T_IP(n);
    end Entier_Vers_IP;

    function Texte_Vers_IP (Chaine : in Unbounded_String) return T_IP is
        UN_OCTET: constant T_IP := 2 ** 8;       -- 256

        package Split4 is
            new Str_Split (NbrArgs => 4);
        use Split4;

        Buffer : T_TAB;   -- Contient la chaine split en fonction d'un caractère
        New_IP : T_IP;    -- IP temporaire pour le traitement d'IP
        n : Integer;      -- octet courant de l'ip
    begin
        New_IP := 0;
        Split(Buffer, Chaine, '.');

        for i in 1..4 loop
            n := Texte_Vers_Entier( To_String(Buffer(i)) ); -- lecture du i-ème octet d'IP

            if n >= 0 then
                New_IP := New_IP * UN_OCTET + Entier_Vers_IP(n);
            else
                raise Erreur_Chaine_Non_IP;
            end if;
        end loop;

        return New_IP;
    exception
        when Erreur_Nombre_Arguments => raise Erreur_Chaine_Non_IP;
        when Erreur_Pas_Un_Entier => raise Erreur_Chaine_Non_IP;
    end Texte_Vers_IP;


    function IP_Vers_Texte (IP : T_IP) return Unbounded_String is
        -- Séparation de l'ip en 4 octets
        S4 : constant String := Entier_Positif_Vers_Texte(Integer(IP mod 256));
        S3 : constant String := Entier_Positif_Vers_Texte(Integer(IP / (2 ** 8) mod 256));
        S2 : constant String := Entier_Positif_Vers_Texte(Integer(IP / (2 ** 16) mod 256));
        S1 : constant String := Entier_Positif_Vers_Texte(Integer(IP / (2 ** 24) mod 256));
    begin
        return To_Unbounded_String(S1 & "." & S2 & "." & S3 & "." & S4);
    end IP_Vers_Texte;


    function Lire_Bit (IP : T_IP; i : Integer) return Integer is
        POIDS_FORT : constant T_IP  := 2 ** 31;	 -- 10000000.00000000.00000000.00000000
        Temp_IP : T_IP;
    begin
        Temp_IP := IP * 2 ** (i - 1);

        if (Temp_IP and POIDS_FORT) /= 0 then
            return 1;
        else
            return 0;
        end if;
    end Lire_Bit;


    function Egalite_IP (IP1 : T_IP; IP2: T_IP; Masque : T_IP)
        return Boolean is
    begin
        -- Egalite bit à bit entre IP1 et IP2 et le masque
        return (IP1 and Masque) = (IP2 and Masque);
    end Egalite_IP;


    function Longueur_IP(IP : T_IP) return Integer is
        Compteur_1 : Integer;
    begin
        Compteur_1 := 1;
        while (Compteur_1 <= 32) and then Lire_Bit(IP, Compteur_1) = 1 loop
            Compteur_1 := Compteur_1 +  1;
        end loop;

        -- Un masque ne peut contenir qu'une suite de 1 suivi d'une suite de 0
        -- par exemple:
        --    11111111111111100000000000000000 est bon
        --    11111100011111100000000000001111 n'est pas bon
        for i in (Compteur_1 + 1)..32 loop
            if Lire_Bit(IP, i) = 0 then
                Null;
            else
                raise Erreur_Masque_Invalide;
            end if;
        end loop;

        return Compteur_1 - 1;
    end Longueur_IP;

end IP;
