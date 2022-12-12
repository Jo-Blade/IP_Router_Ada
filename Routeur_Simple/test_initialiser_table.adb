with Text_IO; use Text_IO;
with Initialiser_Table; use Initialiser_Table;


procedure test_initialiser_table is
    Table : T_LC;
    F : File_Type;
begin
    Create(F, Out_File, "test_initialiser_table", "");
    Initialiser_Table(Table, F);
    pragma assert(Table = null);
    Delete(F);
end test_initialiser_table;
