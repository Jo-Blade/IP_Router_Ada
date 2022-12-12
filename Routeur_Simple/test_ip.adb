with IP;      use IP;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO;      use Ada.Text_IO;

procedure test_ip is
  IP1 : T_IP;
begin
  Texte_Vers_IP(IP1, To_Unbounded_String("192.168.1.200"));

  Put(To_String(IP_Vers_Texte(IP1)));
end test_ip;
