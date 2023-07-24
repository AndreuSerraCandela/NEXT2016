table 50011 LinCompra_AUXi
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            Description = 'Identificador único de línea.';
        }
        field(2; "Cód. Cab"; Code[20])
        {
        }
        field(3; "Cód. Producto"; Code[20])
        {
        }
        field(4; Importe; Decimal)
        {
        }
        field(5; ERROR; Boolean)
        {
            Description = 'Fallo al pasar a NAV.';
        }
        field(6; PROCESAR; Boolean)
        {
            Description = 'Importado de workspace, pendiente de tratar.';
        }
        field(7; TERMINADO; Boolean)
        {
            Description = 'Introducido en NAV correctamente.';
        }
        field(8; "Fecha Carga"; Date)
        {
            Description = 'Fecha de carga desde el workspace.';
        }
        field(9; Cantidad; Decimal)
        {
        }
        field(10; Company; Text[36])
        {
            Description = 'Empresa del producto';
        }
        field(11; Description; Text[250])
        {
        }
        field(12; "Unit Price"; Decimal)
        {
        }
        field(13; Total; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
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

