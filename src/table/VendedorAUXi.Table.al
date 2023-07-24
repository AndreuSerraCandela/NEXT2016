table 50002 Vendedor_AUXi
{

    fields
    {
        field(1; Codigo; Code[10])
        {
        }
        field(2; Name; Text[50])
        {
        }
        field(3; ERROR; Boolean)
        {
            Description = 'Fallo al pasar a NAV.';
        }
        field(4; PROCESAR; Boolean)
        {
            Description = 'Importado de workspace, pendiente de tratar.';
        }
        field(5; TERMINADO; Boolean)
        {
            Description = 'Introducido en NAV correctamente.';
        }
        field(6; "Fecha Carga"; Date)
        {
            Description = 'Fecha de carga desde el workspace.';
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
        key(Key2; ERROR, PROCESAR)
        {
        }
    }

    fieldgroups
    {
    }
}

