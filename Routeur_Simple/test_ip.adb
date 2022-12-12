with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Integer_Text_IO;      use Ada.Integer_Text_IO;
with IP;      use IP;

procedure test_ip is
    IP1 : T_IP;
    IP2 : T_IP;
    IP3 : T_IP;
    IP4 : T_IP;
    IP5 : T_IP;
    Masque1 : T_IP;
    Masque2 : T_IP;
    IP_Entier : T_IP;
begin
    Texte_Vers_IP(IP1, To_Unbounded_String("192.168.0.20"));

    Put(To_String(IP_Vers_Texte(IP1)));

    for i in 1..32 loop
        New_Line;
        Put( Lire_Bit(IP1, i) );
    end loop;
    
   
    -- Tests Egalite_IP
    Texte_Vers_IP(IP2, To_Unbounded_String("192.168.0.20"));
    Texte_Vers_IP(IP3, To_Unbounded_String("192.168.1.20"));
    Texte_Vers_IP(Masque1, To_Unbounded_String("255.255.255.255"));
    Texte_Vers_IP(Masque2, To_Unbounded_String("255.255.0.0"));
    pragma Assert(Egalite_IP(IP1,IP2,Masque1));
    pragma Assert(Egalite_IP(IP1,IP2,Masque2));
    pragma Assert(not Egalite_IP(IP1,IP3,Masque1));
    pragma Assert(Egalite_IP(IP1,IP3,Masque2));
    
    --Tests Lire_Bit
    
    -- Tests Texte_Vers_IP et IP_Vers_Texte
    Texte_Vers_IP(IP2, To_Unbounded_String("192.168.0.20"));
    IP4:= IP_Vers_Texte(IP2);
    Texte_Vers_IP(IP3, To_Unbounded_String("192.168.1.20"));
    IP5:= IP_Vers_Texte(IP3);
    Pragma Assert(IP4 = To_Unbounded_String("192.168.0.20"));
    Pragma Assert(IP5 = To_Unbounded_String("192.168.1.20"));    
    begin 
        Texte_Vers_IP(IP2, To_Unbounded_String("192.168.a.20"));
    exception
        when Erreur_Nombre_Arguments =>
            raise Erreur_Chaine_Non_IP;
    end;
    
    -- tests Entier_Vers_IP
    Entier_Vers_IP(IP_Entier, 6);
    Texte_Vers_IP(IP2, To_Unbounded_String("0.0.0.6"));
    pragma Assert(Egalite_IP(IP2,IP_Entier,Masque1));
    Entier_Vers_IP(IP_Entier, 489);
    Texte_Vers_IP(IP2, To_Unbounded_String("0.0.1.233"));
    Texte_Vers_IP(IP3, To_Unbounded_String("0.0.001.233"));
    pragma Assert(Egalite_IP(IP2,IP_Entier,Masque1));
    pragma Assert(Egalite_IP(IP3,IP_Entier,Masque1));

end test_ip;
