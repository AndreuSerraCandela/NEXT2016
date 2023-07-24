page 50014 LineasOfertasAux
{
    Caption = 'Lineas Oferta Auxiliar';
    InsertAllowed = false;
    PageType = List;
    SourceTable = OfertaLinVenta_AUXi;
    SourceTableView = SORTING("Cod. Lin.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Cod. Cab."; Rec."Cod. Cab.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cod. Cab. field.';
                }
                field(Cantidad; Rec.Cantidad)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cantidad field.';
                }
                field("Cod. Lin."; Rec."Cod. Lin.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cod. Lin. field.';
                }
                field("Cod. Producto"; Rec."Cod. Producto")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cod. Producto field.';
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company field.';
                }
                field(Coste; Rec.Coste)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Coste field.';
                }
                field("DIM Licencia"; Rec."DIM Licencia")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Licencia field.';
                }
                field("DIM Proyecto"; Rec."DIM Proyecto")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Proyecto field.';
                }
                field("Descripción"; Rec."Descripción")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Descripción field.';
                }
                field("Descripción2"; Rec."Descripción2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Descripción2 field.';
                }
                field(Dto; Rec.Dto)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dto field.';
                }
                field(ERROR; Rec.ERROR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERROR field.';
                }
                field("Fecha Carga"; Rec."Fecha Carga")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha Carga field.';
                }
                field(Observaciones; Rec.Observaciones)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Observaciones field.';
                }
                field(PROCESAR; Rec.PROCESAR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PROCESAR field.';
                }
                field(PVP; Rec.PVP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PVP field.';
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

