page 50017 HitosFactAux
{
    Caption = 'Hitos de Facturación Aux';
    InsertAllowed = false;
    PageType = List;
    SourceTable = 50007;
    SourceTableView = SORTING(Id)
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; rec.Id)
                {
                }
                field("Cód. Oferta"; rec."Cód. Oferta")
                {
                }
                field("Cód. Lín. Oferta"; rec."Cód. Lín. Oferta")
                {
                }
                field(Percent; rec.Percent)
                {
                }
                field(Total; rec.Total)
                {
                }
                field(Facturado; rec.Facturado)
                {
                }
                field(ERROR; rec.ERROR)
                {
                }
                field(PROCESAR; rec.PROCESAR)
                {
                }
                field(TERMINADO; rec.TERMINADO)
                {
                }
                field("Fecha Carga"; rec."Fecha Carga")
                {
                }
                field("Fecha Facturación"; rec."Fecha Facturación")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        rec.SETRANGE(rec.TERMINADO, FALSE);
    end;
}

