table 50008 "Hitos Facturación"
{
    // EX-SMN 220419 Nuevo campo "No. Factura"

    Caption = 'Hitos de Facturación';
    //LookupPageID = 50107;

    fields
    {
        field(1; Id; Code[50])
        {
        }
        field(2; "Cód. Oferta"; Code[20])
        {
            Caption = 'Cód. Oferta';
        }
        field(3; "Cód. Lín. Oferta"; Code[20])
        {
            Caption = 'Cód. Línea Oferta';

            trigger OnValidate()
            var
                recSLines: Record "Sales Line";
                recSales: Record "sales header";
                v_CantEnviar: Decimal;
                v_CantFact: Decimal;
                recCustomer: Record CUSTOMER;
            begin
                recSLines.SETCURRENTKEY(recSLines."Cód. Línea");
                //recSLines.SETRANGE(recSLines."Document Type",recSLines."Document Type"::Quote);
                recSLines.SETRANGE(recSLines."Cód. Línea", Rec."Cód. Lín. Oferta");

                IF NOT recSLines.FINDSET THEN
                    ERROR('No existe la línea asociada ' + Rec."Cód. Lín. Oferta")
                ELSE BEGIN
                    Rec."No. Cliente" := recSLines."Sell-to Customer No.";
                    recCustomer.GET(recSLines."Sell-to Customer No.");
                    Rec."Nombre Cliente" := recCustomer.Name;
                    recSales.GET(recSLines."Document Type", recSLines."Document No.");
                    Rec."Fecha Reg. Pedido" := recSales."Posting Date";
                    Rec."Document Type" := recSales."Document Type";

                    Rec."No. Producto" := recSLines."No.";
                    Rec."Desc. Línea" := recSLines.Description;
                END;
            end;
        }
        field(4; Percent; Decimal)
        {
            Caption = 'Porcentaje';
        }
        field(5; Total; Decimal)
        {
        }
        field(6; Estado; Option)
        {
            Description = 'Estado en el Workspace.';
            Editable = true;
            OptionMembers = " ",Pendiente,Actualizado;
        }
        field(7; Facturado; Boolean)
        {
            Description = 'Si se marca modificará la cantd. a enviar en el pedido.';

            trigger OnValidate()
            var

                recSLines: Record "Sales Line";
                recSales: Record "sales header";
                v_CantEnviar: Decimal;
                v_CantFact: Decimal;
                recCustomer: Record CUSTOMER;
            begin
                CLEAR(v_CantEnviar);
                CLEAR(v_CantFact);
                recSLines.SETRANGE(recSLines."Cód. Línea", "Cód. Lín. Oferta");
                recSLines.FINDFIRST;

                IF Facturado THEN BEGIN
                    v_CantEnviar := recSLines."Qty. to Ship" + (Rec.Percent / 100) * recSLines.Quantity;
                    v_CantFact := recSLines."Qty. to Invoice" + (Rec.Percent / 100) * recSLines.Quantity;

                    IF (v_CantEnviar + recSLines."Quantity Shipped") > recSLines.Quantity THEN
                        ERROR('Cantidad a enviar no puede ser superior a la cantidad.')
                    ELSE
                        recSLines.VALIDATE("Qty. to Ship", v_CantEnviar);

                    IF (v_CantFact + recSLines."Quantity Invoiced") > recSLines.Quantity THEN
                        ERROR('Cantidad a facturar no puede ser superior a la cantidad.')
                    ELSE
                        recSLines.VALIDATE("Qty. to Invoice", v_CantFact);

                END
                ELSE BEGIN
                    v_CantEnviar := recSLines."Qty. to Ship" - (Rec.Percent / 100) * recSLines.Quantity;
                    IF v_CantEnviar < 0 THEN
                        v_CantEnviar := 0;
                    recSLines.VALIDATE("Qty. to Ship", v_CantEnviar);
                    v_CantFact := recSLines."Qty. to Invoice" - (Rec.Percent / 100) * recSLines.Quantity;
                    IF v_CantFact < 0 THEN
                        v_CantFact := 0;
                    recSLines.VALIDATE("Qty. to Invoice", v_CantFact);
                END;

                recSLines.MODIFY(TRUE);
            end;
        }
        field(8; "Fecha Facturado"; Date)
        {
        }
        field(9; "Fecha prevista fact."; Date)
        {
        }
        field(10; "Fecha carga"; Date)
        {
            Description = 'Fecha de carga desde el workspace';
        }
        field(11; "No. Cliente"; Code[20])
        {
        }
        field(12; "Nombre Cliente"; Text[50])
        {
        }
        field(13; "Fecha Reg. Pedido"; Date)
        {
        }
        field(14; "No. Producto"; Code[20])
        {
        }
        field(15; "Desc. Línea"; Text[50])
        {
        }
        /*  field(16; "Document Type"; Option)
          {
              Caption = 'Document Type';
              OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
              OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
          }
          */
        field(16; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
            //OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            //OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(17; TieneLinea; Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Cód. Línea" = FIELD("Cód. Lín. Oferta")));
            FieldClass = FlowField;
        }
        field(18; "No. Factura"; Code[20])
        {
            Description = 'EX-SMN 220419';
        }
    }

    keys
    {
        key(Key1; Id, "Cód. Lín. Oferta")
        {
            Clustered = true;
        }
        key(Key2; "Cód. Lín. Oferta")
        {
        }
        key(Key3; "Cód. Oferta")
        {
        }
        key(Key4; Estado)
        {
        }
    }

    fieldgroups
    {
    }



}

