with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

--Ecrire les résultats dans le fichier. --

procedure Ecrire_Resultat(IP: in T_IP;Interface: in String;Fichier: in out File_Type) is
    F : File_Type;
begin
    Open(F, In_File, Fichier, ""); --Ouvre le fichier.--
    Put(F, IP,Interface);
    New_Line;
    Close(F); --Ferme le fichier.--
end Ecrire_Resultat;
