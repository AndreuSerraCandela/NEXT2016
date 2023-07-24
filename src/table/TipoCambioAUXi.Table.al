table 50009 TipoCambio_AUXi
{

    fields
    {
        field(1; "Cód. Divisa"; Code[10])
        {
        }
        field(2; "Fecha Cambio"; Date)
        {
        }
        field(3; "Tipo Cambio"; Decimal)
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
        key(Key1; "Cód. Divisa", "Fecha Cambio")
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

