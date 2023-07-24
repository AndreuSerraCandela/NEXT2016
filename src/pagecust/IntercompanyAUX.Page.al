page 50023 "Intercompany AUX"
{
    Caption = 'Intercompany Auxiliar';
    PageType = List;
    SourceTable = Intercomapy_AUXI;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field("Documento No"; Rec."Documento No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nº Documento field.';
                }
                field("Fecha Carga"; Rec."Fecha Carga")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha Carga field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha de Registro field.';
                }
                field("Amount Destination"; Rec."Amount Destination")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Importe Destino field.';
                }
                field("Amount Origin"; Rec."Amount Origin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Importe Origen field.';
                }
                field("Company Destination"; Rec."Company Destination")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Empresa Destino field.';
                }
                field("Company Origin"; Rec."Company Origin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Empresa Origen field.';
                }
                field("Currency Destination"; Rec."Currency Destination")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Divisa Destino field.';
                }
                field("Currency Origin"; Rec."Currency Origin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Divisa Origen field.';
                }
                field(ERROR; Rec.ERROR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERROR field.';
                }
                field(PROCESAR; Rec.PROCESAR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PROCESAR field.';
                }
                field("TERMINADO COMPRA"; Rec."TERMINADO COMPRA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TERMINADO COMPRA field.';
                }
                field("TERMINADO VENTA"; Rec."TERMINADO VENTA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TERMINADO VENTA field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        rec.SETRANGE(rec.PROCESAR, TRUE);
    end;
}

