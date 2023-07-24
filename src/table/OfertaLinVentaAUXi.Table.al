table 50004 OfertaLinVenta_AUXi
{

    fields
    {
        field(1; "Cod. Lin."; Code[20])
        {
        }
        field(2; "Cod. Cab."; Code[20])
        {
        }
        field(3; "Cod. Producto"; Code[20])
        {
        }
        field(4; PVP; Decimal)
        {
        }
        field(5; Cantidad; Decimal)
        {
        }
        field(6; Dto; Decimal)
        {
        }
        field(7; Total; Decimal)
        {
        }
        field(8; ERROR; Boolean)
        {
        }
        field(9; PROCESAR; Boolean)
        {
        }
        field(10; TERMINADO; Boolean)
        {
        }
        field(11; Observaciones; Text[250])
        {
        }
        field(12; "Fecha Carga"; Date)
        {
        }
        field(13; "Descripción"; Text[50])
        {
        }
        field(14; "Descripción2"; Text[50])
        {
        }
        field(15; Company; Text[50])
        {
        }
        field(16; "DIM Proyecto"; Code[20])
        {
            Caption = 'Proyecto';
        }
        field(17; "DIM Licencia"; Code[20])
        {
            Caption = 'Licencia';
        }
        field(18; Coste; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Lin.")
        {
            Clustered = true;
        }
        key(Key2; "Cod. Cab.")
        {
        }
    }

    fieldgroups
    {
    }
}

