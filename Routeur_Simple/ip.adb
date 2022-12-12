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
    return False;
  end Egalite_IP;

end IP;



--
--  with Ada.Text_IO;            use Ada.Text_IO;
--  with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;
--
--  -- Volontairement, ce programme contient des redondances qui pourraient être
--  -- supprimées en utilisant des sous-programmes et des répétitions.
--
--  procedure Exemple_Adresse_IP is
--
--    type T_Adresse_IP is mod 2 ** 32;
--
--    POIDS_FORT : constant T_Adresse_IP  := 2 ** 31;	 -- 10000000.00000000.00000000.00000000
--
--    IP1 : T_Adresse_IP;
--    IP2 : T_Adresse_IP;
--    M1 : T_Adresse_IP;
--    D1 : T_Adresse_IP;
--
--    Bit_A_1 : Boolean;
--  begin
--    -- Construire 147.127.18.0 (en appliquant le schéma de Horner)
--    IP1 := 147;
--    IP1 := IP1 * UN_OCTET + 128;
--    IP1 := IP1 * UN_OCTET + 18;
--    IP1 := IP1 * UN_OCTET + 15;
--
--    -- Afficher les 4 octets (en sens inverse) en base 10
--    Put ("IP1 (octets inversés) = ");
--    IP2 := IP1;
--    Put (Natural (IP2 mod UN_OCTET));	-- Conversion d'un T_Adresse_IP en Integer pour utiliser Put sur Integer
--    IP2 := IP2 / UN_OCTET;
--    Put (Natural (IP2 mod UN_OCTET));
--    IP2 := IP2 / UN_OCTET;
--    Put (Natural (IP2 mod UN_OCTET));
--    IP2 := IP2 / UN_OCTET;
--    Put (Natural (IP2 mod UN_OCTET));
--    New_Line;
--
--    -- Afficher les 4 octets (en sens inverse) en base 2
--    Put ("IP1 (octets inversés) = ");
--    IP2 := IP1;
--    Put (Natural (IP2 mod UN_OCTET), Base => 2, Width => 12);
--    IP2 := IP2 / UN_OCTET;
--    Put (Natural (IP2 mod UN_OCTET), Base => 2, Width => 12);
--    IP2 := IP2 / UN_OCTET;
--    Put (Natural (IP2 mod UN_OCTET), Base => 2, Width => 12);
--    IP2 := IP2 / UN_OCTET;
--    Put (Natural (IP2 mod UN_OCTET), Base => 2, Width => 12);
--    New_Line;
--    New_Line;
--
--    -- Est-ce que le bit de poids fort (1ier bit) est à 1 ?
--    Bit_A_1 := (IP1 and POIDS_FORT) /= 0;
--    if Bit_A_1 then
--      Put_Line ("premier bit à 1");
--    else
--      Put_Line ("premier bit à 0");
--    end if;
--
--    -- Est-ce que le 2ème bit est à 1 ?
--    Bit_A_1 := ((IP1 * 2) and POIDS_FORT) /= 0;
--    if Bit_A_1 then
--      Put_Line ("Deuxième bit à 1");
--    else
--      Put_Line ("Deuxième bit à 0");
--    end if;
--
--    -- Construire un masque 255.255.255
--    M1 := -1;	-- des 1 partout
--    M1 := M1 - 255;
--
--    New_Line;
--    Put ("M1  = ");
--    Put (Natural ((M1 / UN_OCTET ** 3) mod UN_OCTET), 1); Put (".");
--    Put (Natural ((M1 / UN_OCTET ** 2) mod UN_OCTET), 1); Put (".");
--    Put (Natural ((M1 / UN_OCTET ** 1) mod UN_OCTET), 1); Put (".");
--    Put (Natural  (M1 mod UN_OCTET), 1);
--    New_Line;
--
--    D1 := IP1 - 15;
--    Put ("D1  = ");
--    Put (Natural ((D1 / UN_OCTET ** 3) mod UN_OCTET), 1); Put (".");
--    Put (Natural ((D1 / UN_OCTET ** 2) mod UN_OCTET), 1); Put (".");
--    Put (Natural ((D1 / UN_OCTET ** 1) mod UN_OCTET), 1); Put (".");
--    Put (Natural  (D1 mod UN_OCTET), 1);
--    New_Line;
--
--    Put ("IP1 = ");
--    Put (Natural ((IP1 / UN_OCTET ** 3) mod UN_OCTET), 1); Put (".");
--    Put (Natural ((IP1 / UN_OCTET ** 2) mod UN_OCTET), 1); Put (".");
--    Put (Natural ((IP1 / UN_OCTET ** 1) mod UN_OCTET), 1); Put (".");
--    Put (Natural  (IP1 mod UN_OCTET), 1);
--    New_Line;
--
--    IP2 := IP1 + 2 ** 8;
--    Put ("IP2 = ");
--    Put (Natural ((IP2 / UN_OCTET ** 3) mod UN_OCTET), 1); Put (".");
--    Put (Natural ((IP2 / UN_OCTET ** 2) mod UN_OCTET), 1); Put (".");
--    Put (Natural ((IP2 / UN_OCTET ** 1) mod UN_OCTET), 1); Put (".");
--    Put (Natural  (IP2 mod UN_OCTET), 1);
--    New_Line;
--
--    -- Est-ce qu'une adresse IP1 correspond à la route (D1, M1)
--    if (IP1 and M1) = D1 then
--      Put_Line ("IP1 Correspond à (D1, M1)");
--    else
--      Put_Line ("IP1 ne correspond pas à (D1, M1)");
--    end if;
--
--    -- Est-ce qu'une adresse IP1 correspond à la route (D1, M1)
--    if (IP2 and M1) = D1 then
--      Put_Line ("IP2 Correspond à (D1, M1)");
--    else
--      Put_Line ("IP2 ne correspond pas à (D1, M1)");
--    end if;
--
--    -- Décalerr des bits : il suffit de multiplier par 2 (décalage vers la
--    -- gauche) ou diviser par 2 (décalage vers la droite).
--    IP1 := 147;
--    New_Line;
--    Put ("IP1 avant décalage           = "); Put (Integer (IP1),          Base => 2, Width => 15);  New_Line;
--    Put ("IP1 décalé à gauche (1 bit)  = "); Put (Integer (IP1 * 2),      Base => 2, Width => 15);  New_Line;
--    Put ("IP1 décalé à droite (1 bit)  = "); Put (Integer (IP1 / 2),      Base => 2, Width => 15);  New_Line;
--    Put ("IP1 décalé à gauche (3 bit)  = "); Put (Integer (IP1 * 2 ** 3), Base => 2, Width => 15);  New_Line;
--    Put ("IP1 décalé à droite (3 bit)  = "); Put (Integer (IP1 / 2 ** 3), Base => 2, Width => 15);  New_Line;
--
--
--
--  end Exemple_Adresse_IP;
