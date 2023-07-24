page 50021 LinCompraAux
{
    Caption = 'Líneas Compra Auxiliar';
    InsertAllowed = false;
    PageType = List;
    SourceTable = LinCompra_AUXi;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
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
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
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
                field(Importe; Rec.Importe)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Importe field.';
                }
                field(PROCESAR; Rec.PROCESAR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PROCESAR field.';
                }
                field(Total; Rec.Total)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
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

