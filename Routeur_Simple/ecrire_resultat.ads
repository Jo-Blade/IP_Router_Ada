procedure Ecrire_Resultat(IP: in T_IP;Interface: in String;Fichier: in out File_Type) is
    with Pre => Est_Present(Fichier)
         Post => Est_Ecrit(IP, Interface, Fichier)


