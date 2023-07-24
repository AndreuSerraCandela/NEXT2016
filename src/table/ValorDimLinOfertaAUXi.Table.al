table 50006 ValorDimLinOferta_AUXi
{

    fields
    {
        field(1; "Cód. Project"; Code[20])
        {
        }
        field(2; "Cód. LínOffer"; Code[20])
        {
        }
        field(3; "Id Lin"; Integer)
        {
        }
        field(4; ERROR; Boolean)
        {
        }
        field(5; PROCESAR; Boolean)
        {
        }
        field(6; TERMINADO; Boolean)
        {
        }
        field(7; "Fecha Carga"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Cód. Project", "Cód. LínOffer")
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

