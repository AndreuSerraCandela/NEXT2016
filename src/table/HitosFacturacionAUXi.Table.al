table 50007 HitosFacturacion_AUXi
{
    // LookupPageID = 50106;

    fields
    {
        field(1; Id; Code[50])
        {
        }
        field(2; "Cód. Oferta"; Code[20])
        {
        }
        field(3; "Cód. Lín. Oferta"; Code[20])
        {
        }
        field(4; Percent; Decimal)
        {
        }
        field(5; Total; Decimal)
        {
        }
        field(6; Facturado; Boolean)
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
        field(11; "Fecha Facturación"; Date)
        {
        }
        field(12; Company; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; Id, "Cód. Lín. Oferta")
        {
            Clustered = true;
        }
        key(Key2; ERROR, PROCESAR)
        {
        }
        key(Key3; "Cód. Lín. Oferta")
        {
        }
    }

    fieldgroups
    {
    }
}

