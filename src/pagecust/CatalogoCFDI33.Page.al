page 50803 "Catalogo CFDI 3.3"
{
    PageType = List;
    SourceTable = "Catalogo CFDI 3.3";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo Tabla"; rec."Tipo Tabla")
                {
                    ApplicationArea = all;
                }
                field(Codigo; rec.Codigo)
                {
                    ApplicationArea = all;
                }
                field(Descripcion; rec.Descripcion)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

