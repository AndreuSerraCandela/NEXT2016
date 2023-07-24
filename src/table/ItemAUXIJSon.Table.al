table 50015 Item_AUXI_JSon
{

    fields
    {
        field(1; Id; Text[50])
        {
            Description = 'KP';
        }
        field(2; "Code"; Code[20])
        {
        }
        field(3; Description; Text[50])
        {
        }
        field(4; Active; Boolean)
        {
        }
        field(5; "Prod. de Compra"; Boolean)
        {
        }
        field(6; "Fecha Carga"; Date)
        {
            Description = 'Fecha de carga desde el workspace.';
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

