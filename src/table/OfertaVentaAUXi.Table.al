table 50003 OfertaVenta_AUXi
{
    // 110918 EX-JVN Cod Vendedor aumentado de 10 a 40


    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Cod. Cab"; Code[20])
        {
        }
        field(3; "Cod. Cliente"; Code[20])
        {
        }
        field(4; "Cod. Vendedor"; Code[40])
        {
            Description = 'EX-JVN aumentado de 10 a 40';
        }
        field(5; "Dto. Factura"; Decimal)
        {
        }
        field(6; ERROR; Boolean)
        {
            Description = 'Fallo al pasar a NAV.';
        }
        field(7; PROCESAR; Boolean)
        {
            Description = 'Importado de workspace, pendiente de tratar.';
        }
        field(8; TERMINADO; Boolean)
        {
            Description = 'Introducido en NAV correctamente.';
        }
        field(9; "Fecha Carga"; Date)
        {
            Description = 'Fecha de carga desde el workspace.';
        }
        field(10; "Fecha Aceptación"; Date)
        {
        }
        field(11; Mail; Text[50])
        {
        }
        field(12; Description; Text[50])
        {
        }
        field(13; Description2; Text[50])
        {
        }
        field(14; Company; Text[50])
        {
        }
        field(15; "Nombre Vendedor"; Text[50])
        {
        }
        field(16; "Mail Vendedor"; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "No.", "Cod. Cab")
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

