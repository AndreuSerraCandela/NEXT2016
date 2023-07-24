table 50005 Proyecto_AUXi
{

    fields
    {
        field(1; "No."; Integer)
        {
            Description = 'Id proyecto';
        }
        field(2; "Código"; Code[20])
        {
        }
        field(3; Name; Text[50])
        {
        }
        field(4; ERROR; Boolean)
        {
            Description = 'Fallo al pasar a NAV.';
        }
        field(5; PROCESAR; Boolean)
        {
            Description = 'Importado de workspace, pendiente de tratar.';
        }
        field(6; TERMINADO; Boolean)
        {
            Description = 'Introducido en NAV correctamente.';
        }
        field(7; "Fecha Carga"; Date)
        {
            Description = 'Fecha de carga desde el workspace.';
        }
    }

    keys
    {
        key(Key1; "No.", "Código")
        {
            Clustered = true;
        }
        key(Key2; ERROR, PROCESAR)
        {
        }
        key(Key3; "Código")
        {
        }
    }

    fieldgroups
    {
    }
}

