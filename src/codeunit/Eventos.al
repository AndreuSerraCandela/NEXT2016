/// <summary>
/// Codeunit Eventos (ID 92000).
/// </summary>
codeunit 92000 Eventos
{
    /// <summary>
    /// OnAfterValidateEvent.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Header".</param>
    /// <param name="xRec">VAR Record "Sales Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    procedure OnAfterValidateEvent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        pT_Customer: Record Customer;
    begin

        //SF-MLA Desarrollo para cambiar la descripci¢n del asiento por el n£mero externo + nombre del cliente.
        IF (Rec."Document Type" = Rec."Document Type"::"Credit Memo") OR
            (Rec."Document Type" = Rec."Document Type"::"Return Order") THEN BEGIN
            IF NOT pT_Customer.GET(Rec."Sell-to Customer No.") THEN
                CLEAR(pT_Customer);
            Rec."Posting Description" := COPYSTR(Rec."External Document No." + ' ' + pT_Customer.Name, 1, 100);
        END ELSE BEGIN
            IF NOT pT_Customer.GET(Rec."Sell-to Customer No.") THEN
                CLEAR(pT_Customer);
            Rec."Posting Description" := COPYSTR(Rec."External Document No." + ' ' + pT_Customer.Name, 1, 100);
        END;
        //FIN SF-MLA
    end;
    /// <summary>
    /// OnAfterValidateExter.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Header".</param>
    /// <param name="xRec">VAR Record "Sales Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'External Document No.', false, false)]
    procedure OnAfterValidateExter(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        pT_Customer: Record Customer;
    begin

        //SF-MLA Desarrollo para cambiar la descripci¢n del asiento por el n£mero externo + nombre del cliente.
        IF (Rec."Document Type" = Rec."Document Type"::"Credit Memo") OR
            (Rec."Document Type" = Rec."Document Type"::"Return Order") THEN BEGIN
            IF NOT pT_Customer.GET(Rec."Sell-to Customer No.") THEN
                CLEAR(pT_Customer);
            Rec."Posting Description" := COPYSTR(Rec."External Document No." + ' ' + pT_Customer.Name, 1, 100);
        END ELSE BEGIN
            IF NOT pT_Customer.GET(Rec."Sell-to Customer No.") THEN
                CLEAR(pT_Customer);
            Rec."Posting Description" := COPYSTR(Rec."External Document No." + ' ' + pT_Customer.Name, 1, 100);
        END;
        //FIN SF-MLA
    end;
    /// <summary>
    /// OnAfterValidateBillTo.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Header".</param>
    /// <param name="xRec">VAR Record "Sales Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Bill-to Customer No.', false, false)]
    procedure OnAfterValidateBillTo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        RecSIITablaMaestraValores: Record 50600;
    begin
        //SII
        CASE Rec."Document Type" OF
            Rec."Document Type"::Order, Rec."Document Type"::Invoice:
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosDocumento(1, Rec."No.");
                    RecSIITablaMaestraValores.InsertarDatosContraparte(1, Rec."No.", Rec."Bill-to Customer No.");
                END;
            Rec."Document Type"::"Credit Memo", Rec."Document Type"::"Return Order":
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosDocumento(2, Rec."No.");
                    RecSIITablaMaestraValores.InsertarDatosContraparte(2, Rec."No.", Rec."Bill-to Customer No.");
                END;
        END;
        // SII
    END;
    /// <summary>
    /// OnAfterValidatePostingDate.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Header".</param>
    /// <param name="xRec">VAR Record "Sales Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Posting Date', false, false)]
    procedure OnAfterValidatePostingDate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        Rec."SII Fecha envío a control" := Rec."Posting Date"; //170717 EX-JVN SII
    end;
    /// <summary>
    /// OnAfterValidateSalesPersonCodeNew.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Header".</param>
    /// <param name="xRec">VAR Record "Sales Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'SalesPerson Code', false, false)]
    procedure OnAfterValidateSalesPersonCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        SalesPersonCode: Record "Salesperson/Purchaser";
    begin
        IF Rec."Salesperson Code" <> '' THEN BEGIN
            SalesPersonCode.GET(Rec."Salesperson Code");
            Rec."Salesperson Code New" := SalesPersonCode."Code New";
        END;
    end;

    /// <summary>
    /// OnAfterValidateSalesPersonCodeNew.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Header".</param>
    /// <param name="xRec">VAR Record "Sales Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'SalesPerson Code New', false, false)]
    procedure OnAfterValidateSalesPersonCodeNew(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        SalesPersonCode: Record "Salesperson/Purchaser";
    begin
        IF Rec."Salesperson Code New" <> '' THEN BEGIN
            SalesPersonCode.SetRange("Code New", Rec."Salesperson Code New");
            If SalesPersonCode.FindFirst() THEN
                Rec."Salesperson Code" := SalesPersonCode."Code";

        END;
    end;
    /// <summary>
    /// OnAfterValidateCorrectInvoiceNo.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Header".</param>
    /// <param name="xRec">VAR Record "Sales Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Corrected Invoice No.', false, false)]
    procedure OnAfterValidateCorrectInvoiceNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        RecSIITablaMaestraValores: Record 50600;
        SalesInvoiceHeader: Record 112;
    BEGIN
        IF Rec."Corrected Invoice No." <> '' THEN BEGIN
            SalesInvoiceHeader.SETCURRENTKEY("No.");
            SalesInvoiceHeader.SETRANGE("Bill-to Customer No.", Rec."Bill-to Customer No.");
            SalesInvoiceHeader.SETRANGE("No.", Rec."Corrected Invoice No.");
            IF SalesInvoiceHeader.FINDFIRST THEN

                // SII Informar Datos SII: Fecha operaci¢n factura rectificada
                RecSIITablaMaestraValores.InsertaDatoEnDocumento(2, Rec."No.", 'INT_FechaOperacionRectificativa',
            FORMAT(SalesInvoiceHeader."Posting Date"), 0);
        end;
    end;

    /// <summary>
    /// OnAfterInitRecord.
    /// </summary>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitRecord', '', false, false)]
    procedure OnAfterInitRecord(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."SII Fecha envío a control" := SalesHeader."Posting Date"; //170717 EX-JVN SII

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeSalesLineInsert', '', false, false)]
    local procedure OnBeforeSalesLineInsert(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary; SalesHeader: Record "Sales Header")
    begin
        //EX-JVN-270116:Campos personalizados
        SalesLine."Cód. Línea" := TempSalesLine."Cód. Línea";
        SalesLine."Precio Coste" := TempSalesLine."Precio Coste";
        SalesLine.VALIDATE("Unit Price", TempSalesLine."Unit Price");
        SalesLine."Dimension Set ID" := TempSalesLine."Dimension Set ID";
        //EX-JVN-270116:fin
    end;

    [EventSubsCriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventSl(var Rec: Record "Sales Line"; Runtrigger: Boolean)
    VAR
        lRstTblValSII: Record 50600;
    BEGIN
        //SII
        CASE Rec."Document Type" OF
            Rec."Document Type"::Order, Rec."Document Type"::Invoice:
                lRstTblValSII.InsertarDatosMultiple(1, Rec."Document No.", 1, Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");
            Rec."Document Type"::"Credit Memo", Rec."Document Type"::"Return Order":
                lRstTblValSII.InsertarDatosMultiple(2, Rec."Document No.", 1, Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");
        END;
    END;
    // Lo mismo para purchase line
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventPl(var Rec: Record "Purchase Line"; Runtrigger: Boolean)
    var
        RecSIITablaMaestraValores: Record 50600;
    begin
        //SII
        CASE Rec."Document Type" OF
            Rec."Document Type"::Order, Rec."Document Type"::Invoice:
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosMultiple(5, Rec."Document No.", 1, Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");
                END;
            Rec."Document Type"::"Credit Memo", Rec."Document Type"::"Return Order":
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosMultiple(6, Rec."Document No.", 1, Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");
                END;
        END;
        // SII
    end;

    [EventSubsCriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEventSl(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; Runtrigger: Boolean)
    VAR
        lRstTblValSII: Record 50600;
    BEGIN
        //SII
        CASE Rec."Document Type" OF
            Rec."Document Type"::Order, Rec."Document Type"::Invoice:
                lRstTblValSII.InsertarDatosMultiple(1, Rec."Document No.", 1, Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");
            Rec."Document Type"::"Credit Memo", Rec."Document Type"::"Return Order":
                lRstTblValSII.InsertarDatosMultiple(2, Rec."Document No.", 1, Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");
        END;
    END;
    // Lo mismo para purchase line
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEventPl(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; Runtrigger: Boolean)
    var
        RecSIITablaMaestraValores: Record 50600;
    begin
        //SII
        CASE Rec."Document Type" OF
            Rec."Document Type"::Order, Rec."Document Type"::Invoice:
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosMultiple(5, Rec."Document No.", 1, Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");
                END;
            Rec."Document Type"::"Credit Memo", Rec."Document Type"::"Return Order":
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosMultiple(6, Rec."Document No.", 1, Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");
                END;
        END;
        // SII
    end;

    [EventSubsCriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEventSl(var Rec: Record "Sales Line"; Runtrigger: Boolean)
    VAR
        recHitosFact: Record "Hitos Facturación";
    BEGIN
        //200616 EX-JVN Al eliminar una oferta borramos sus hitos
        IF Rec."Document Type" = Rec."Document Type"::Quote THEN BEGIN
            recHitosFact.RESET;
            recHitosFact.SETRANGE(recHitosFact."Cód. Lín. Oferta", Rec."Cód. Línea");
            recHitosFact.SETRANGE(recHitosFact.Estado, recHitosFact.Estado::" ");
            recHitosFact.DELETEALL;
        END;
        //200616 EX-JVN fin
    END;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateTypeOnCopyFromTempSalesLine', '', false, false)]
    local procedure OnValidateTypeOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary)
    begin
        //EX-JVN-290316:Mantenemos el C¢d. L¡nea
        IF TempSalesLine."Cód. Línea" <> '' THEN
            SalesLine."Cód. Línea" := TempSalesLine."Cód. Línea";
    end;
    // Lo mismo para purchase line
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateTypeOnCopyFromTempPurchLine', '', false, false)]
    local procedure OnValidateTypeOnCopyFromTempPurchLine(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary; xPurchaseLine: Record "Purchase Line")
    begin
        //EX-JVN-290316:Mantenemos el C¢d. L¡nea
        IF TempPurchaseLine."Cód. Línea" <> '' THEN
            PurchLine."Cód. Línea" := TempPurchaseLine."Cód. Línea";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnCopyFromTempSalesLine', '', false, false)]
    local procedure OnValidateNoOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    begin
        //EX-JVN-290316:Mantenemos el C¢d. L¡nea
        IF TempSalesLine."Cód. Línea" <> '' THEN
            SalesLine."Cód. Línea" := TempSalesLine."Cód. Línea";
    end;
    // Lo mismo para purchase line
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateNoOnCopyFromTempPurchLine', '', false, false)]
    local procedure OnValidateNoOnCopyFromTempPurchLine(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary; xPurchLine: Record "Purchase Line")
    begin
        //EX-JVN-290316:Mantenemos el C¢d. L¡nea
        IF TempPurchaseLine."Cód. Línea" <> '' THEN
            PurchLine."Cód. Línea" := TempPurchaseLine."Cód. Línea";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateQuantityEventSl(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        v_percent: Decimal;
        recHitosFact: Record "Hitos Facturación";
    begin

        //EX-JVN-070116
        IF CurrFieldNo = Rec.FIELDNO(Rec."Qty. to Ship") THEN BEGIN
            CLEAR(v_percent);
            recHitosFact.RESET;
            recHitosFact.SETRANGE("Cód. Lín. Oferta", Rec."Cód. Línea");
            recHitosFact.SETRANGE(Facturado, TRUE);
            IF recHitosFact.FINDFIRST THEN BEGIN
                REPEAT
                    v_percent += recHitosFact.Percent;
                UNTIL recHitosFact.NEXT = 0;
                IF Rec."Qty. to Ship" <> (v_percent / 100) THEN
                    DIALOG.MESSAGE('Hitos de facturación marcados no acumulan la cantidad indicada.');
            END;
        END;
        //EX-JVN-070116:fin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEventPh(var Rec: Record "Purchase Header"; Runtrigger: Boolean)
    var
        DatosSIIDoc: Record "SII- Datos SII Documentos";
        toTypeSII: Integer;
    begin
        //140717 EX-JVN SII
        CASE Rec."Document Type".AsInteger() OF
            1, 2:
                toTypeSII := 4;
            3, 5:
                toTypeSII := 5;
        END;

        DatosSIIDoc.RESET;
        DatosSIIDoc.SETRANGE("Tipo documento", toTypeSII);
        DatosSIIDoc.SETRANGE("No. Documento", Rec."No.");
        IF DatosSIIDoc.FINDSET THEN
            DatosSIIDoc.DELETEALL;
        //140717 fin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Pay-to Vendor No.', false, false)]
    local procedure OnAfterValidatePayToVendorNo(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        pT_Proveedor: Record Vendor;
        RecSIITablaMaestraValores: Record 50600;
    begin
        //SF-MLA Desarrollo para cambiar la descripci¢n del asiento por el n£mero externo + nombre del proveedor.
        IF (Rec."Document Type" = Rec."Document Type"::"Credit Memo") OR
            (Rec."Document Type" = Rec."Document Type"::"Return Order") THEN BEGIN
            IF NOT pT_Proveedor.GET(Rec."Pay-to Vendor No.") THEN
                CLEAR(pT_Proveedor);
            Rec."Posting Description" := COPYSTR(Rec."Vendor Cr. Memo No." + ' ' + pT_Proveedor.Name, 1, 50);
        END ELSE BEGIN
            IF NOT pT_Proveedor.GET(Rec."Pay-to Vendor No.") THEN
                CLEAR(pT_Proveedor);
            Rec."Posting Description" := COPYSTR(Rec."Vendor Invoice No." + ' ' + pT_Proveedor.Name, 1, 50);
        END;
        //FIN SF-MLA


        //SII
        CASE Rec."Document Type" OF
            Rec."Document Type"::Order, Rec."Document Type"::Invoice:
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosDocumento(5, Rec."No.");
                    RecSIITablaMaestraValores.InsertarDatosContraparte(5, Rec."No.", Rec."Pay-to Vendor No.");
                END;
            Rec."Document Type"::"Credit Memo", Rec."Document Type"::"Return Order":
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosDocumento(6, Rec."No.");
                    RecSIITablaMaestraValores.InsertarDatosContraparte(6, Rec."No.", Rec."Pay-to Vendor No.");
                END;
        END;
        // SII
    END;

    /// <summary>
    /// OnAfterValidateSalesPersonCodeNew.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Header".</param>
    /// <param name="xRec">VAR Record "Sales Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Purchaser Code New', false, false)]
    procedure OnAfterValidatePurchPersonCodeNew(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        SalesPersonCode: Record "Salesperson/Purchaser";
    begin
        IF Rec."Purchaser Code New" <> '' THEN BEGIN

            SalesPersonCode.SetRange("Code New", Rec."Purchaser Code New");
            If SalesPersonCode.FindFirst() THEN
                Rec."Purchaser Code" := SalesPersonCode."Code";

        END;
    end;

    /// <summary>
    /// OnAfterValidateSalesPersonCodeNew.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Header".</param>
    /// <param name="xRec">VAR Record "Sales Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Purchaser Code', false, false)]
    procedure OnAfterValidatePurchPersonCode(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        SalesPersonCode: Record "Salesperson/Purchaser";
    begin
        IF Rec."Purchaser Code" <> '' THEN BEGIN
            SalesPersonCode.GET(Rec."Purchaser Code");
            Rec."Purchaser Code New" := SalesPersonCode."Code New";
        END;
    end;

    /// <summary>
    /// OnAfterValidateVendorInvoiceNo.
    /// </summary>
    /// <param name="Rec">VAR Record "Purchase Header".</param>
    /// <param name="xRec">VAR Record "Purchase Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Vendor Invoice No.', false, false)]
    procedure OnAfterValidateVendorInvoiceNo(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var

        pT_Proveedor: Record Vendor;
    begin
        //SF-MLA Desarrollo para cambiar la descripci¢n del asiento por el n£mero externo + nombre del proveedor.
        IF (Rec."Document Type" = Rec."Document Type"::"Credit Memo") OR
            (Rec."Document Type" = Rec."Document Type"::"Return Order") THEN BEGIN
            IF NOT pT_Proveedor.GET(Rec."Pay-to Vendor No.") THEN
                CLEAR(pT_Proveedor);
            Rec."Posting Description" := COPYSTR(Rec."Vendor Cr. Memo No." + ' ' + pT_Proveedor.Name, 1, 100);
        END ELSE BEGIN
            IF NOT pT_Proveedor.GET(Rec."Pay-to Vendor No.") THEN
                CLEAR(pT_Proveedor);
            Rec."Posting Description" := COPYSTR(Rec."Vendor Invoice No." + ' ' + pT_Proveedor.Name, 1, 100);
        END;
        //FIN SF-MLA
    END;
    //Lo mismo para Vendor Cr. Memo No.
    /// <summary>
    /// OnAfterValidateVendorCrMemoNo.
    /// </summary>
    /// <param name="Rec">VAR Record "Purchase Header".</param>
    /// <param name="xRec">VAR Record "Purchase Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Vendor Cr. Memo No.', false, false)]
    procedure OnAfterValidateVendorCrMemoNo(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var

        pT_Proveedor: Record Vendor;
    begin
        //SF-MLA Desarrollo para cambiar la descripci¢n del asiento por el n£mero externo + nombre del proveedor.
        IF (Rec."Document Type" = Rec."Document Type"::"Credit Memo") OR
            (Rec."Document Type" = Rec."Document Type"::"Return Order") THEN BEGIN
            IF NOT pT_Proveedor.GET(Rec."Pay-to Vendor No.") THEN
                CLEAR(pT_Proveedor);
            Rec."Posting Description" := COPYSTR(Rec."Vendor Cr. Memo No." + ' ' + pT_Proveedor.Name, 1, 100);
        END ELSE BEGIN
            IF NOT pT_Proveedor.GET(Rec."Pay-to Vendor No.") THEN
                CLEAR(pT_Proveedor);
            Rec."Posting Description" := COPYSTR(Rec."Vendor Invoice No." + ' ' + pT_Proveedor.Name, 1, 100);
        END;
        //FIN SF-MLA
    END;
    //Crear evento para Corrected Invoice No.
    /// <summary>
    /// OnAfterValidateCorrectedInvoiceNo.
    /// </summary>
    /// <param name="Rec">VAR Record "Purchase Header".</param>
    /// <param name="xRec">VAR Record "Purchase Header".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    /// <remarks>EX-JVN-140717 SII</remarks>
    /// <history>
    /// [EX-JVN] 14/07/2017 Created
    /// </history>
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Corrected Invoice No.', false, false)]
    procedure OnAfterValidateCorrectedInvoiceNo(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        RecSIITablaMaestraValores: Record 50600;
        PurchaseInvoiceHeader: Record 122;
    BEGIN
        // SII Informar Datos SII: Fecha operaci¢n factura rectificada
        IF Rec."Corrected Invoice No." <> '' THEN BEGIN
            PurchaseInvoiceHeader.SETCURRENTKEY("No.");
            PurchaseInvoiceHeader.SETRANGE("Pay-to Vendor No.", Rec."Pay-to Vendor No.");
            PurchaseInvoiceHeader.SETRANGE("No.", Rec."Corrected Invoice No.");
            IF PurchaseInvoiceHeader.FINDFIRST THEN
                RecSIITablaMaestraValores.InsertaDatoEnDocumento(6, Rec."No.", 'INT_FechaOperacionRectificativa',
                FORMAT(PurchaseInvoiceHeader."Posting Date"), 0);
        end;
    end;
    //Evento para InitRecord en purchAse Header
    /// <summary>
    /// OnAfterInitRecord.
    /// </summary>
    /// <param name="PurchHeader">VAR Record "Purchase Header".</param>
    /// <remarks>EX-JVN-140717 SII</remarks>
    /// <history>
    /// [EX-JVN] 14/07/2017 Created
    /// </history>
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInitRecord', '', false, false)]
    procedure OnAfterInitRecordph(var PurchHeader: Record "Purchase Header")
    var
        pT_Proveedor: Record Vendor;
    begin
        PurchHeader."SII Fecha envío a control" := PurchHeader."Posting Date"; //170717 EX-JVN SII
                                                                               //SF-DGM:INICIO
                                                                               //"Posting Description" := FORMAT("Document Type") + ' ' + "No.";
        IF NOT pT_Proveedor.GET(PurchHeader."Pay-to Vendor No.") THEN
            CLEAR(pT_Proveedor);
        PurchHeader."Posting Description" := PurchHeader."Vendor Invoice No." + ' ' + pT_Proveedor.Name;
        //SF-DGM:FIN
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventGjl(var Rec: Record "Gen. Journal Line"; Runtrigger: Boolean)
    begin
        Rec."SII Fecha envío a control" := Rec."Posting Date"; //170717 EX-JVN SII
    end;
    //lo mismo en Modify
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEventGjl(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; Runtrigger: Boolean)
    begin
        IF (Rec."SII Fecha envío a control" = 0D) AND
              (Rec."Document Type" IN [Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo"]) THEN
            Rec."SII Fecha envío a control" := Rec."Posting Date"; //170717 EX-JVN SII
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEventGjl(var Rec: Record "Gen. Journal Line"; Runtrigger: Boolean)
    var
        JnLine: Record "Gen. Journal Line";
        toTypeSII: Integer;
        DatosSIIDoc: Record "SII- Datos SII Documentos";
    begin
        //040817 EX-JVN SII
        JnLine.RESET;
        JnLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
        JnLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
        JnLine.SETRANGE("Document No.", Rec."Document No.");
        JnLine.SETRANGE("Document Type", Rec."Document Type");
        JnLine.SETRANGE("Posting Date", Rec."Posting Date");
        IF NOT JnLine.FINDFIRST THEN BEGIN
            CASE Rec."Document Type".AsInteger() OF
                2:
                    CASE Rec."Account Type" OF
                        Rec."Account Type"::Customer:
                            toTypeSII := 1;
                        Rec."Account Type"::Vendor:
                            toTypeSII := 5;
                    END;
                3:
                    CASE Rec."Account Type" OF
                        Rec."Account Type"::Customer:
                            toTypeSII := 2;
                        Rec."Account Type"::Vendor:
                            toTypeSII := 6;
                    END;
            END;

            DatosSIIDoc.RESET;
            DatosSIIDoc.SETRANGE("Tipo documento", toTypeSII);
            DatosSIIDoc.SETRANGE("No. Documento", Rec."Document No.");
            IF DatosSIIDoc.FINDSET THEN
                DatosSIIDoc.DELETEALL;
        END;
        //040817 fin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetCustomerAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetCustomerAccount(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; CallingFieldNo: Integer)
    var
        RecSIITablaMaestraValores: Record 50600;
    begin
        //190717 EX-JVN SII
        CASE GenJournalLine."Document Type" OF
            GenJournalLine."Document Type"::Invoice:
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosDocumento(1, GenJournalLine."Document No.");
                    RecSIITablaMaestraValores.InsertarDatosContraparte(1, GenJournalLine."Document No.", GenJournalLine."Source No.");
                    GenJournalLine."SII Datos Documento" := TRUE;
                END;
            GenJournalLine."Document Type"::"Credit Memo":
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosDocumento(2, GenJournalLine."Document No.");
                    RecSIITablaMaestraValores.InsertarDatosContraparte(2, GenJournalLine."Document No.", GenJournalLine."Source No.");
                    GenJournalLine."SII Datos Documento" := TRUE;
                END;
        END;
        //190717 fin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetVendorAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetVendorAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; CallingFieldNo: Integer)
    var
        RecSIITablaMaestraValores: Record 50600;
    begin
        //190717 EX-JVN SII
        CASE GenJournalLine."Document Type" OF
            GenJournalLine."Document Type"::Invoice:
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosDocumento(5, GenJournalLine."Document No.");
                    RecSIITablaMaestraValores.InsertarDatosContraparte(5, GenJournalLine."Document No.", GenJournalLine."Source No.");
                    GenJournalLine."SII Datos Documento" := TRUE;
                END;
            GenJournalLine."Document Type"::"Credit Memo":
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosDocumento(6, GenJournalLine."Document No.");
                    RecSIITablaMaestraValores.InsertarDatosContraparte(6, GenJournalLine."Document No.", GenJournalLine."Source No.");
                    GenJournalLine."SII Datos Documento" := TRUE;
                END;
        END;
        //190717 fin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Posting Date', false, false)]
    local procedure OnAfterValidatePostingDateEventGjl(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        Rec."SII Fecha envío a control" := Rec."Posting Date"; //170717 EX-JVN SII
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterInsertInvLineFromShptLine', '', false, false)]
    local procedure OnAfterInsertInvLineFromShptLine(var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line"; var NextLineNo: Integer; SalesShipmentLine: Record "Sales Shipment Line")
    var
        RecSIITablaMaestraValores: Record 50600;
    begin
        //SII
        CASE SalesLine."Document Type" OF
            SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice:
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosMultiple(5, SalesLine."Document No.", 1, SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group");
                END;
            SalesLine."Document Type"::"Credit Memo", SalesLine."Document Type"::"Return Order":
                BEGIN
                    RecSIITablaMaestraValores.InsertarDatosMultiple(6, SalesLine."Document No.", 1, SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group");
                END;
        END;
        // SII
    end;
}