page 50002 "Registrar Hitos Facturación"
{
    InsertAllowed = false;
    PageType = List;
    SourceTable = 50008;
    SourceTableView = SORTING(Id, "Cód. Lín. Oferta")
                      ORDER(Ascending)
                      WHERE(TieneLinea = CONST(true));

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
                    Caption = 'No. Cabecera';
                }
                field("Fecha Reg. Pedido"; rec."Fecha Reg. Pedido")
                {
                }
                field("Cód. Lín. Oferta"; rec."Cód. Lín. Oferta")
                {
                    Caption = 'Código Línea';
                }
                field("Desc. Línea"; rec."Desc. Línea")
                {
                }
                field("No. Producto"; rec."No. Producto")
                {
                }
                field("No. Cliente"; rec."No. Cliente")
                {
                }
                field("Nombre Cliente"; rec."Nombre Cliente")
                {
                }
                field(Percent; rec.Percent)
                {
                }
                field(Total; rec.Total)
                {
                }
                field(Estado; rec.Estado)
                {
                    Editable = false;
                }
                field(Facturado; rec.Facturado)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Facturar Varios"; v_FacturarVarios)
                {

                    trigger OnValidate()
                    begin
                        IF Rec."Fecha Facturado" = 0D THEN BEGIN
                            CLEAR(v_CantEnviar);
                            CLEAR(v_CantFact);
                            recSLines.SETRANGE(recSLines."Cód. Línea", Rec."Cód. Lín. Oferta");
                            recSLines.FINDFIRST;

                            IF v_FacturarVarios THEN BEGIN
                                v_CantEnviar := recSLines."Qty. to Ship" + (Rec.Percent / 100) * recSLines.Quantity;
                                v_CantFact := recSLines."Qty. to Invoice" + (Rec.Percent / 100) * recSLines.Quantity;

                                IF (v_CantEnviar + recSLines."Quantity Shipped") > recSLines.Quantity THEN
                                    ERROR('Cantidad a enviar no puede ser superior a la cantidad.')
                                ELSE
                                    recSLines.VALIDATE(recSLines."Qty. to Ship", v_CantEnviar);

                                IF (v_CantFact + recSLines."Quantity Invoiced") > recSLines.Quantity THEN
                                    ERROR('Cantidad a facturar no puede ser superior a la cantidad.')
                                ELSE
                                    recSLines.VALIDATE(recSLines."Qty. to Invoice", v_CantFact);
                                Rec.Facturado := TRUE;
                            END
                            ELSE BEGIN
                                v_CantEnviar := recSLines."Qty. to Ship" - (Rec.Percent / 100) * recSLines.Quantity;
                                IF v_CantEnviar < 0 THEN
                                    v_CantEnviar := 0;
                                recSLines.VALIDATE(recSLines."Qty. to Ship", v_CantEnviar);
                                v_CantFact := recSLines."Qty. to Invoice" - (Rec.Percent / 100) * recSLines.Quantity;
                                IF v_CantFact < 0 THEN
                                    v_CantFact := 0;
                                recSLines.VALIDATE(recSLines."Qty. to Invoice", v_CantFact);
                                Rec.Facturado := FALSE;
                            END;

                            Rec.MODIFY(TRUE);
                            recSLines.MODIFY(TRUE);

                            recSaleHeader.GET(recSaleHeader."Document Type"::Order, Rec."Cód. Oferta");
                            recSaleHeader.MARK(v_FacturarVarios);
                        END
                        ELSE
                            ERROR('El Hito ya ha sido facturado.');

                    end;
                }
                field("Fecha Facturado"; rec."Fecha Facturado")
                {
                }
                field("Fecha prevista fact."; rec."Fecha prevista fact.")
                {
                }
                field("Fecha carga"; rec."Fecha carga")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Registrar)
            {
                Image = Invoice;

                trigger OnAction()
                begin
                    CLEAR(rptFactLotes);

                    recSaleHeader.MARKEDONLY(TRUE);
                    rptFactLotes.SETTABLEVIEW(recSaleHeader);
                    rptFactLotes.InitializeRequest(TRUE, TRUE, 0D, FALSE, FALSE, FALSE);
                    rptFactLotes.RUNMODAL;
                    recSaleHeader.CLEARMARKS;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        v_FacturarVarios := Rec.Facturado;
    end;

    trigger OnOpenPage()
    begin
        rec.SETRANGE(Rec."Fecha Facturado", 0D);
        rec.SETRANGE(Rec."Document Type", Rec."Document Type"::Order);

        recSaleHeader.CLEARMARKS;
    end;

    var
        v_FacturarVarios: Boolean;
        rptFactLotes: Report "Batch Post Sales Orders";
        recSaleHeader: Record "Sales Header";
        recSLines: Record "Sales Line";
        v_CantEnviar: Decimal;
        v_CantFact: Decimal;
}

