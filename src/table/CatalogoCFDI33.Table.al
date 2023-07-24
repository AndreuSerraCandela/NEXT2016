/// <summary>
/// Table Catalogo CFDI 3.3 (ID 52008).
/// </summary>
table 52008 "Catalogo CFDI 3.3"
{
    DataPerCompany = false;
    DrillDownPageID = 50803;
    LookupPageID = 50803;

    fields
    {
        field(1; "Tipo Tabla"; Text[30])
        {
        }
        field(2; Codigo; Code[20])
        {
        }
        field(3; Descripcion; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Tipo Tabla", Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }
}

