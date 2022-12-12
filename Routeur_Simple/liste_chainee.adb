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

    procedure Ajouter_Debut (Liste: in out T_LC; Element: T_Element) is
    begin
        Liste := new T_Cellule'(Element, Liste);
    end Ajouter_Debut;
    
    function Premier (Liste: in T_LC) return T_Element is
    begin
        if Liste = null then
            raise Element_Absent_Error;
        end if;
        return Liste.all.Element;
    end Premier;
        
    function Taille(Liste: in T_LC) return Integer is
    begin
        if Liste = null then
            return 0;
        else
            return 1 + Taille(Liste.all.Suivante);
        end if;
    end Taille;



    function Est_Present(Liste: in T_LC; Element: in T_Element) return Boolean is
    begin
        if Liste = Null then
            return False;
        elsif Liste.all.Element = Element then
            return True;
        else
            return Est_Present(Liste.all.Suivante, Element);
        end if;
    end Est_Present;


    procedure Supprimer(Liste: in out T_LC; Indice: in Integer) is
        A_Detruire: T_LC;
    begin
        if Liste = null or Indice < 0 then
            raise Indice_Error;
        elsif Indice = 0 then
            A_Detruire := Liste;
            Liste := Liste.all.Suivante;
            Free (A_Detruire);
        else
            Supprimer(Liste.all.Suivante, Indice - 1);
        end if;
    end Supprimer;
    
    function Cellule_Contenant(Element: T_Element; Liste: in T_LC) return T_LC is
    begin
        if Liste = null then
            raise Element_Absent_Error;
        elsif Liste.all.Element = Element then
            return Liste;
        else
            return Cellule_Contenant(Element, Liste.all.Suivante);
        end if;
    end Cellule_Contenant;

    procedure Inserer_Apres (Liste: in out T_Liste ; Nouveau, Element: in T_Element) is
        Reference: T_Liste;
    begin
        Reference := Cellule_Contenant (Element, Liste);
        --! peut lever Element_Absent_Error que l'on laisse se propager.
        Reference.all.Suivante := new T_Cellule'(Nouveau, Reference.all.Suivante);
    end Inserer_Apres;

    function Ieme(Liste: in T_LC; Indice: in Integer) return T_Element is
    begin
        if Liste = null or Indice < 0 then
            raise Indice_Error;
        elsif Indice = 0 then
            return Liste.all.Element;
        else
            return Ieme(Liste.all.Suivante, Indice - 1);
        end if;
    end Ieme;

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
