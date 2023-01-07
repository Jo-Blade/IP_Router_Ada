with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Unchecked_Deallocation;


package body Liste_Chainee is
    procedure Free is
        new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LC);


    -- Initialiser la liste chainée
    procedure Initialiser(Liste: out T_LC) is
    begin
        Liste := null;
    end Initialiser;


    -- Vérifier que la liste chainée est vide
    function Est_Vide (Liste : T_LC) return Boolean is
    begin
        return Liste = null;
    end;


    -- Ajouter un élément au début de la liste chainée
    procedure Ajouter_Debut (Liste: in out T_LC; Element: T_Element) is
    begin
        Liste := new T_Cellule'(Element, Liste);
    end Ajouter_Debut;


    -- Retourner le premier élément de la liste chainée
    -- On lève une exception si la liste est vide : Element_Absent_Error
    function Premier (Liste: in T_LC) return T_Element is
    begin
        if Liste = null then
            raise Element_Absent_Error;
        end if;
        return Liste.all.Element;
    end Premier;


    -- Retourner la taille de la liste chainée
    function Taille(Liste: in T_LC) return Integer is
    begin
        if Liste = null then
            return 0;
        else
            return 1 + Taille(Liste.all.Suivante);
        end if;
    end Taille;


    -- Retourne le booléen true si l'élémnet souhaité est présent dans la liste chainée
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


    -- Supprimer un élement de la liste chainée la premier fois qu'il apparait
    -- On lève une exception si la liste est vide : Element_Absent_Error
    procedure Supprimer(Liste: in out T_LC; Element: in T_Element) is
        A_Detruire: T_LC;   -- elément courant à détruire de la liste
    begin
        if Liste = null then
            raise Element_Absent_Error;
        elsif Liste.all.Element = Element then
            A_Detruire := Liste;
            Liste := Liste.all.Suivante;
            Free (A_Detruire);
        else
            Supprimer(Liste.all.Suivante, Element);
        end if;
    end Supprimer;


    -- Obtenir la première apparition dans la liste chainée de l'élément souhaité
    -- On lève une exception si la liste est vide : Element_Absent_Error
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


    -- Inserer un élément dans la liste chainée après l'élément souhaité
    procedure Inserer_Apres (Liste: in out T_LC ; Nouveau, Element: in T_Element) is
        Reference: T_LC;
    begin
        Reference := Cellule_Contenant (Element, Liste);
        --  peut lever Element_Absent_Error que l'on laisse se propager.
        Reference.all.Suivante := new T_Cellule'(Nouveau, Reference.all.Suivante);
    end Inserer_Apres;


    -- Retourner l'entier à l'indice souhaité dans la liste chainée
    -- On lève une exception si l'indice : Indice_Error
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


    -- Vider la liste chainée dans son intégralité
    procedure Vider (Liste : in out T_LC) is
        Liste_Temp : T_LC;
        Suite_Liste: T_LC;
    begin
        Liste_Temp := Liste;
        while not Est_Vide(Liste_Temp) loop
            Suite_Liste:= Liste_Temp.all.Suivante;
            Supprimer(Liste, Liste_Temp.all.Element);
            Liste_Temp := Suite_Liste;
        end loop;
    end Vider;


    -- Fonction générique que implemeter d'autres fonctions qui s'appliquent à
    -- chaque élément de la liste chainée
    procedure Pour_Chaque (Liste : in T_LC) is
        Liste_Temp : T_LC;
    begin
        Liste_Temp := Liste;
        While not Est_Vide(Liste_Temp) loop
            begin
                Traiter(Liste_Temp.all.Element);
            exception
                when others =>
                    Put("Il y a une erreur lors de Pour_Chaque dans liste_chainee.adb.");
                    New_Line;
            end;
            if Est_Vide(Liste_Temp) then
                Put_Line("Est_Vide");
            else
                Put_Line("not Est_Vide");
            end if;
            Liste_Temp := Liste_Temp.all.Suivante;
            if Est_Vide(Liste_Temp) then
                Put_Line("Est_Vide");
            else
                Put_Line("not Est_Vide");
            end if;
            Put_Line("--");
        end loop;
    end Pour_Chaque;


    -- Rajouter un élément dans une liste chainée et si l'élément est déjà présent 
    -- le remplacer
    procedure Enregistrer (Liste : in out T_LC; Element : in T_ELement) is
    begin
        if Est_Vide(Liste) then
            Ajouter_Debut(Liste, Element);
        elsif Selection(Liste.all.Element) then
            Liste.all.Element := Element;
        else
            Enregistrer(Liste.all.Suivante, Element);
        end if;
    end Enregistrer;

    procedure Inserer (Liste : in out T_LC; Element : in T_Element) is
    begin
      if Est_Vide(Liste) or not Plus_Petit(Element, Liste.All.Element) then
        Liste := new T_Cellule'(Element, Liste);
      else
        Inserer(Liste.All.Suivante, Element);
      end if;
    end Inserer;

    function Trouver(Liste : in T_LC) return T_Element is
    begin
      if Est_Vide(Liste) then
        raise Element_Absent_Error;
      elsif Selection(Liste.All.Element) then
        return Liste.All.Element;
      else
        return Trouver (Liste.All.Suivante);
      end if;
    end Trouver;

    procedure Extraire (Element_Trouve : out T_Element; Liste : in out T_LC) is
      temp_Liste : T_LC;
    begin
      if Est_Vide(Liste) then
        raise Element_Absent_Error;
      elsif Selection(Liste.All.Element) then
        Element_Trouve := Liste.All.Element;
        temp_Liste := Liste;
        Liste := Liste.All.Suivante;
        Free(temp_Liste);
      else
        Extraire (Element_Trouve, Liste.All.Suivante);
      end if;
    end Extraire;

end Liste_Chainee;
