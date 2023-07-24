table 50018 "Relacion Empresas JSon"
{
    DataPerCompany = false;

    fields
    {
        field(1; Company; Text[30])
        {
            TableRelation = Company.Name;
        }
        field(2; "Code"; Code[20])
        {
            Description = 'Código de WS';
        }
        field(3; Id; Text[40])
        {
        }
    }

    keys
    {
        key(Key1; Company, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

