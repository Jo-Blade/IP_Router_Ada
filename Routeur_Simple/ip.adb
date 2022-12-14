with My_Strings;         use My_Strings;
with Str_Split;

package body IP is
    UN_OCTET: constant T_IP := 2 ** 8;       -- 256

    procedure Entier_Vers_IP (ip : out T_IP; n : in Integer) is
    begin
        ip := T_IP(n);
    end Entier_Vers_IP;

    procedure Texte_Vers_IP (ip: out T_IP;
        chaine : in Unbounded_String) is

        package Split4 is
            new Str_Split (NbrArgs => 4);
        use Split4;

        buffer : T_TAB;
        new_ip : T_IP;
        temp_ip : T_IP;
        n : Integer;
    begin
        new_ip := 0;
        Split(buffer, chaine, '.');

        for i in 1..4 loop
            n := Texte_Vers_Entier( To_String(buffer(i)) );

            if n >= 0 then
                Entier_Vers_IP(temp_ip, n);
                new_IP := new_IP * UN_OCTET + temp_ip;
            else
                raise Erreur_Chaine_Non_IP;
            end if;
        end loop;

        ip := new_ip;
    exception
        when Erreur_Nombre_Arguments =>
            raise Erreur_Chaine_Non_IP;
        when Erreur_Pas_Un_Entier =>
            raise Erreur_Chaine_Non_IP;
    end Texte_Vers_IP;


    function IP_Vers_Texte (ip : T_IP) return Unbounded_String is
        s4 : constant String := Entier_Positif_Vers_Texte(Integer(ip mod 256));
        s3 : constant String := Entier_Positif_Vers_Texte(Integer(ip / (2 ** 8) mod 256));
        s2 : constant String := Entier_Positif_Vers_Texte(Integer(ip / (2 ** 16) mod 256));
        s1 : constant String := Entier_Positif_Vers_Texte(Integer(ip / (2 ** 24) mod 256));
    begin
        return To_Unbounded_String(s1 & "." & s2 & "." & s3 & "." & s4);
    end IP_Vers_Texte;


    function Lire_Bit (ip : T_IP; i : Integer) return Integer is
        POIDS_FORT : constant T_IP  := 2 ** 31;	 -- 10000000.00000000.00000000.00000000
        temp_ip : T_IP;
    begin
        temp_ip := ip * 2 ** (i - 1);

        if (temp_ip and POIDS_FORT) /= 0 then
            return 1;
        else
            return 0;
        end if;
    end Lire_Bit;


    function Egalite_IP (ip1 : T_IP; ip2: T_IP; masque : T_IP)
        return Boolean is
    begin
        return (ip1 and masque) = (ip2 and masque);
    end Egalite_IP;

    function Longueur_IP(ip : T_IP) return Integer is
        Compteur_1 : Integer;
    begin
        Compteur_1 := 0;
        while Lire_Bit(ip, Compteur_1) = 1 loop
          Compteur_1 := Compteur_1 +  1;
        end loop;

        for i in (Compteur_1 + 1)..32 loop
          if Lire_Bit(ip, i) = 0 then
            Null;
          else
            raise Erreur_Masque_Invalide;
          end if;
        end loop;

        return Compteur_1;
    end Longueur_IP;

end IP;
