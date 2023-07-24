page 50004 "Relación Empresas Integracion"
{
    PageType = ListPart;
    SourceTable = "Relacion Empresas JSon";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Company; rec.Company)
                {
                }
                field(Code; rec.Code)
                {
                }
                field(Id; rec.Id)
                {
                }
            }
        }
    }

    actions
    {
    }
}

