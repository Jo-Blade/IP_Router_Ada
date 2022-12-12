with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Liste_Chainee is


	procedure Initialiser(Liste: out T_LC) is
	begin
        Liste := null;
    end Initialiser;


	function Est_Vide (Liste : T_LC) return Boolean is
	begin
		return Liste = null;
	end;


    function Taille (Liste : in T_LC) return Integer is
        L : T_LC;
        Compteur : Integer;
    begin
        Compteur := 0;
        L := Liste;
        while not Est_Vide(L) loop
            Compteur := Compteur + 1;
            L := L.all.Suivant;
        end loop;

        return Compteur;
	end Taille;


    procedure Enregistrer (Liste : in out T_LC ; Element : in T_Element ; Donnee : in T_Donnee) is
    begin
        if Est_Vide(Liste) then
            Liste := new T_Cellule'(Element, Donnee, null);
        elsif Liste.all.Element = Element then
            Liste.all.Donnee := Donnee;
        else
            Enregistrer(Liste.all.suivant, Element, Donnee);
        end if;
	end Enregistrer;


    function Est_Presente (Liste : in T_LC ; Element : in T_Element) return Boolean is
        L : T_LC;
    begin
        L := Liste;
        while not Est_Vide(L) loop
            if L.all.element = Element then
                return True;
            else
                null;
            end if;
            L := L.all.Suivant;
        end loop;
        return False;
	end;


    procedure Supprimer (Liste : in out T_LC ; Element : in T_Element) is
        det : T_LC;
    begin
        if Est_Vide(Liste) then
            raise Element_Absente_Exception;
        elsif  Liste.all.element = Element then
            det := Liste;
            Liste := Liste.all.Suivant;
            free(det);
        else
            Supprimer(Liste.all.Suivant, Element);
        end if;
	end Supprimer;


    procedure Vider (Liste : in out T_LC) is
        L : T_LC;
        Suiv : T_LC;
    begin
        L := Liste;
        while not Est_Vide(L) loop
            suiv := L.all.Suivant;
            Supprimer(Liste, L.all.Element);
            L := Suiv;
        end loop;
	end Vider;


    procedure Pour_Chaque (Liste : in T_LC) is
        L : T_LC;
	begin
        L := Liste;
        While not Est_Vide(L) loop
            begin
                Traiter(L.all.Element);
            exception
                when others =>
                    Put("Il y a une erreur.");
                    New_Line;
            end;
            L := L.all.Suivant;
        end loop;
	end Pour_Chaque;


end Liste_Chainee;
