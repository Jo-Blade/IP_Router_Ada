with IP;      use IP;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Integer_Text_IO;      use Ada.Integer_Text_IO;

procedure test_ip is
  IP1 : T_IP;
begin
  Texte_Vers_IP(IP1, To_Unbounded_String("192.168.0.20"));

  Put(To_String(IP_Vers_Texte(IP1)));

  for i in 1..32 loop
    New_Line;
    Put( Lire_Bit(IP1, i) );
  end loop;
end test_ip;
