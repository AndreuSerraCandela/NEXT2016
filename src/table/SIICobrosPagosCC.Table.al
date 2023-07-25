/// <summary>
/// Table SII- Cobros-Pagos CC (ID 50604).
/// </summary>
table 50604 "SII- Cobros-Pagos CC"
{
    // EX-SMN 191017 Añado estado documento "Validado AEAT"


    fields
    {
        field(1; "Tipo documento"; enum "Sii Tipos Documento")
        {
            //OptionMembers = Factura,Abono,"B.I.";
        }
        field(2; "No. documento SII"; Code[20])
        {
        }
        field(3; "Nº mov. Det. Cli/Pro"; Integer)
        {
        }
        field(4; Fecha; Date)
        {
        }
        field(5; Importe; Decimal)
        {
        }
        field(6; "Entry Type"; Enum "Detailed CV Ledger Entry Type")
        {
            Caption = 'Entry Type';
            //OptionCaption = ',Initial Entry,Application,Unrealized Loss,Unrealized Gain,Realized Loss,Realized Gain,Payment Discount,Payment Discount (VAT Excl.),Payment Discount (VAT Adjustment),Appln. Rounding,Correction of Remaining Amount,Payment Tolerance,Payment Discount Tolerance,Payment Tolerance (VAT Excl.),Payment Tolerance (VAT Adjustment),Payment Discount Tolerance (VAT Excl.),Payment Discount Tolerance (VAT Adjustment),,,,Rejection,Redrawal,Expenses';
            //OptionMembers = ,"Initial Entry",Application,"Unrealized Loss","Unrealized Gain","Realized Loss","Realized Gain","Payment Discount","Payment Discount (VAT Excl.)","Payment Discount (VAT Adjustment)","Appln. Rounding","Correction of Remaining Amount","Payment Tolerance","Payment Discount Tolerance","Payment Tolerance (VAT Excl.)","Payment Tolerance (VAT Adjustment)","Payment Discount Tolerance (VAT Excl.)","Payment Discount Tolerance (VAT Adjustment)",,,,Rejection,Redrawal,Expenses;
        }
        field(7; "Document Type"; enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            //OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,,,,,,,,,,,,Bill';
            //OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,Bill;
        }
        field(8; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(9; "Origen documento"; enum "Sii Origen Documento")
        {
            // OptionMembers = Emitida,Recibida,"B.I.";
        }
        field(200; "Estado documento"; Enum "Sii Estado Documento")
        {
            // OptionMembers = " ","Pendiente procesar","Incluido en fichero","Enviado a plataforma",Incidencias,"Obtener de nuevo","Validado AEAT";
        }
        field(201; "Últ. estado en fecha"; Date)
        {
        }
        field(202; "Incluido en fichero"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Tipo documento", "No. documento SII", "Nº mov. Det. Cli/Pro")
        {
            Clustered = true;
            SumIndexFields = Importe;
        }
        key(Key2; Fecha)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ActualizaImportesDocumentoSII(xRec);
    end;

    trigger OnModify()
    begin
        ActualizaImportesDocumentoSII(Rec);
    end;


    /// <summary>
    /// ActualizaImportesDocumentoSII.
    /// </summary>
    /// <param name="RecCCCobroPago">Record "SII- Cobros-Pagos CC".</param>
    procedure ActualizaImportesDocumentoSII(RecCCCobroPago: Record "SII- Cobros-Pagos CC")
    var
        RecCCSII: Record "SII- Cobros-Pagos CC";
        RecDocumentosSII: Record "SII- Datos SII Documentos";
    begin
        RecCCCobroPago.RESET;
        RecCCCobroPago.SETRANGE(RecCCCobroPago."Tipo documento", "Tipo documento");
        RecCCCobroPago.SETRANGE(RecCCCobroPago."No. documento SII", "No. documento SII");
        IF RecCCCobroPago.FINDFIRST THEN BEGIN
            RecDocumentosSII.RESET;
            RecDocumentosSII.SETRANGE(RecDocumentosSII."Tipo documento", RecCCCobroPago."Tipo documento");
            RecDocumentosSII.SETRANGE(RecDocumentosSII."No. documento", RecCCCobroPago."No. documento SII");
            RecDocumentosSII.SETRANGE(RecDocumentosSII."Tipo registro", RecDocumentosSII."Tipo registro"::Cabecera);
            IF RecDocumentosSII.FINDSET THEN BEGIN
                RecDocumentosSII."CC Importe Cobrado/Pagado" := 0;
                RecDocumentosSII.MODIFY;
                RecCCSII.RESET;
                RecCCSII.SETRANGE(RecCCSII."Tipo documento", RecCCCobroPago."Tipo documento");
                RecCCSII.SETRANGE(RecCCSII."No. documento SII", RecCCCobroPago."No. documento SII");
                IF RecCCSII.FINDSET THEN BEGIN
                    REPEAT
                        RecDocumentosSII."CC Importe Cobrado/Pagado" += RecCCSII.Importe;
                        RecDocumentosSII.MODIFY;
                    UNTIL RecCCSII.NEXT = 0;
                    RecDocumentosSII."CC Importe pendiente" := RecDocumentosSII."Importe total documento" -
                                                             ABS(RecDocumentosSII."CC Importe Cobrado/Pagado");
                    RecDocumentosSII.MODIFY;
                END ELSE BEGIN
                    RecDocumentosSII."CC Importe Cobrado/Pagado" := 0;
                    RecDocumentosSII."CC Importe pendiente" := RecDocumentosSII."Importe total documento";
                    RecDocumentosSII.MODIFY;
                END;
            END;
        END;
    end;
}

