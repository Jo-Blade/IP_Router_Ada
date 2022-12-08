-- Module qui définit le type adresse ip
-- et les fonction pour manipuler les adresses
package IP is

	type T_IP is limited private;

  -- convertit une chaine du type 192.168.0.1 en ip
  function Texte_Vers_IP (ip : T_IP) return T_IP;

  -- convertit une ip en une chaine du type 192.168.0.1
  function IP_Vers_Texte (ip : T_IP) return Unbounded_String;

  -- renvoie la valeur du i-ème bit (en partant de la gauche)
  function Lire_Bit (ip : T_IP; i : Integer) return Integer;

  -- teste l’égalité entre 2 ip pour un masque donné
  function Egalite_IP (ip1 : T_IP; ip2: T_IP; masque : T_IP)
    return Boolean;

private
	type T_IP is mod 2 ** 32;

end IP;
