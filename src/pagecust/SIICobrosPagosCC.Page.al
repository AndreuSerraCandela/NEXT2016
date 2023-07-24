page 50607 "SII- Cobros/Pagos CC"
{
    PageType = List;
    SourceTable = "SII- Cobros-Pagos CC";

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
                field("Estado documento"; Rec."Estado documento")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Estado documento field.';
                }
                field(Fecha; Rec.Fecha)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha field.';
                }
                field(Importe; Rec.Importe)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Importe field.';
                }
                field("Incluido en fichero"; Rec."Incluido en fichero")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incluido en fichero field.';
                }
                field("No. documento SII"; Rec."No. documento SII")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. documento SII field.';
                }
                field("Nº mov. Det. Cli/Pro"; Rec."Nº mov. Det. Cli/Pro")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nº mov. Det. Cli/Pro field.';
                }
                field("Origen documento"; Rec."Origen documento")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Origen documento field.';
                }
                field("Tipo documento"; Rec."Tipo documento")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo documento field.';
                }
                field("Últ. estado en fecha"; Rec."Últ. estado en fecha")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Últ. estado en fecha field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        rec.FILTERGROUP(0);
    end;


    procedure SetDocumentoSII(TipoDocumento: Option Factura,Abono,"B.I."; OrigenDocumento: Option Emitida,Recibida,"B.I."; NoDocumento: Code[20])
    begin
        rec.SETRANGE(rec."Tipo documento", TipoDocumento);
        rec.SETRANGE("Origen documento", OrigenDocumento);
        rec.SETRANGE(rec."No. documento SII", NoDocumento);
    end;
}

