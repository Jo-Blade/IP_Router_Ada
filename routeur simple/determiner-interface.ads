function Determiner_Interface(IP: in T_IP;Table_Routage: in T_TABLE ) return String
    with pre => non Est_Vide(Table_Routage)

