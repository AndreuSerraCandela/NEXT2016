table 50012 Contacto_AUXI_JSon
{
    Caption = 'Contactos AUX';
    // LookupPageID = 50100;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; CIF; Code[15])
        {
        }
        field(3; Name; Text[250])
        {
        }
        field(4; Name2; Text[250])
        {
        }
        field(5; Email; Text[80])
        {
        }
        field(6; Address; Text[250])
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
        key(Key3; CIF)
        {
        }
    }

    fieldgroups
    {
    }
}

