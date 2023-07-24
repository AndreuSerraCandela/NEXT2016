table 50014 LinCompra_AUXi_JSon
{

    fields
    {
        field(1; "ID Line"; Code[50])
        {
            Description = 'Indentificador';
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Cód. Cab"; Code[20])
        {
        }
        field(4; "Cód. Producto"; Code[20])
        {
        }
        field(5; Cantidad; Decimal)
        {
        }
        field(6; Importe; Decimal)
        {
        }
        field(7; ERROR; Boolean)
        {
            Description = 'Fallo al pasar a NAV.';
        }
        field(8; PROCESAR; Boolean)
        {
            Description = 'Importado de workspace, pendiente de tratar.';
        }
        field(9; TERMINADO; Boolean)
        {
            Description = 'Introducido en NAV correctamente.';
        }
        field(10; "Fecha Carga"; Date)
        {
            Description = 'Fecha de carga desde el workspace.';
        }
        field(11; "ID Workspace"; Text[50])
        {
            Description = 'ID único de WS';
        }
    }

    keys
    {
        key(Key1; "ID Line")
        {
            Clustered = true;
        }
        key(Key2; "Line No.", "Cód. Cab")
        {
        }
    }

    fieldgroups
    {
    }
}

