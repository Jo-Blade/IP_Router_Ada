-- Module qui définit le type adresse ip
-- et les fonction pour manipuler les adresses
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;

package IP is

	type T_IP is private;

  Erreur_Chaine_Non_IP : Exception;
  Erreur_Masque_Invalide : Exception;

  -- convertit un entier en ip 
  -- on ne peut pas représenter toutes les ip par des
  -- entiers, car ils sont trop petits
  function Entier_Vers_IP (n : in Integer) return T_IP
    with Pre => (n >= 0);
  -- pas besoin de tester n <= 2 ** 32 car toujours vrai

  -- convertit une chaine du type 192.168.0.1 en ip
  function Texte_Vers_IP (chaine : in Unbounded_String) return T_IP;

  -- convertit une ip en une chaine du type 192.168.0.1
  function IP_Vers_Texte (ip : T_IP) return Unbounded_String;

  -- renvoie la valeur du i-ème bit (en partant de la gauche)
  function Lire_Bit (ip : T_IP; i : Integer) return Integer
    with Pre => (i >= 1) and (i <= 32);

  -- teste l’égalité entre 2 ip pour un masque donné
  function Egalite_IP (ip1 : T_IP; ip2: T_IP; masque : T_IP)
    return Boolean;

  -- renvoie la longueur max de 1 dans ip en partant de la gauche
  function Longueur_IP(ip : T_IP) return Integer 
    with Post => (Longueur_IP'Result >= 0) and (Longueur_IP'Result <= 32);   

                       
private
	type T_IP is mod 2 ** 32;

end IP;
