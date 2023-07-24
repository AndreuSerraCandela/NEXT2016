page 50024 "LinCompra Aux JSon"
{
    Caption = 'Líneas Compra Auxiliar';
    PageType = List;
    SourceTable = "LinCompra_AUXi_JSon";

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Cód. Cab"; Rec."Cód. Cab")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cód. Cab field.';
                }
                field("Cód. Producto"; Rec."Cód. Producto")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cód. Producto field.';
                }
                field(Cantidad; Rec.Cantidad)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cantidad field.';
                }
                field("Fecha Carga"; Rec."Fecha Carga")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha Carga field.';
                }
                field("ID Line"; Rec."ID Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID Line field.';
                }
                field(ERROR; Rec.ERROR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERROR field.';
                }
                field(Importe; Rec.Importe)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Importe field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(PROCESAR; Rec.PROCESAR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PROCESAR field.';
                }
                field("ID Workspace"; Rec."ID Workspace")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID Workspace field.';
                }
                field(TERMINADO; Rec.TERMINADO)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TERMINADO field.';
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

