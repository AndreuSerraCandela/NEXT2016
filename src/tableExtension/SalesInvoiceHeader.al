/// <summary>
/// TableExtension SalesInvoiceHeader (ID 92112) extends Record Sales Invoice Header.
/// </summary>
tableextension 92112 SalesInvoiceHeader extends "Sales Invoice Header"
{

    fields
    {
        field(50600; "SII Estado documento"; Enum "SII Estado documento")
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("SII- Datos SII Documentos"."Estado documento" WHERE("Tipo documento" = FILTER(Factura),
                                    "No. documento" = FIELD("No."),
                                    "Origen documento" = FILTER(Emitida)));
            //OptionCaptionML = ESP=" ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT";
            //OptionString = [ ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT];
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            Editable = false;
        }

        field(50601; "SII Fecha envío a control"; Date)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            trigger OnValidate()
            var
                RstValSII: Record 50600;
            BEGIN
                RstValSII.PermitirModificarDoc("SII Estado documento", TRUE); //EX-SGG 180717

                //030817 EX-JVN SII
                IF "SII Fecha envío a control" < Rec."Posting Date" THEN
                    ERROR('La Fecha envío a control no puede ser inferior a la fecha de registro.');
            END;



        }

        field(50602; "SII Excluir envío"; Boolean)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            trigger OnValidate()
            var
                RstValSII: Record 50600;
            BEGIN
                RstValSII.PermitirModificarDoc("SII Estado documento", TRUE); //EX-SGG 180717
            END;


        }

        field(50801; "Cliente FacturaE"; Boolean)
        {
            Description = 'EX-SGG-FACTE';
        }

        field(50802; "Factura-a Calle"; Text[50])
        {
            Description = 'EX-SGG-FACTE';
            trigger OnValidate()
            BEGIN
                Direccion; //EX-SGG-FACTE;
            END;


        }

        field(50803; "Factura-a No. Int."; Text[10])
        {
            description = 'EX-SGG-FACTE';
            trigger OnValidate()
            BEGIN
                Direccion; //EX-SGG-FACTE;
            END;


        }

        field(50804; "Factura-a No. Ext."; Text[10])
        {
            Description = 'EX-SGG-FACTE';
            trigger OnValidate()
            BEGIN
                Direccion; //EX-SGG-FACTE;
            END;


        }

        field(50805; "Cuenta pago"; Code[10])
        {
            TableRelation = "Customer Bank Account";
            Description = 'EX-SGG-FACTE';
        }

        field(50806; "Hora FacturaE generada"; Time)
        {
            Description = 'EX-SGG-FACTE';
        }

        field(50807; "Usuario FacturaE generada"; Code[50])
        {
            Description = 'EX-SGG-FACTE,EX-SGG 060215 20->50';
        }

        field(50808; "CFDI Tipo Relacion"; Code[10])
        {
            Description = 'EX-FACTE';
        }

        field(50809; "CFDI Uso"; Code[20])
        {
            Description = 'EX-FACTE';
        }

        field(50811; "Folio fiscal"; Text[100])
        {
            Description = 'EX-SGG-FACTE';
        }

        field(50812; "Timbre cancelado"; Boolean)
        {
            Description = 'EX-SGG-FACTE';
        }

        field(50813; "Estado"; Enum "Estado Aceptacion")
        {
            // OptionCaptionML = ESM=" ,Aceptado,Cancelado";
            // OptionString = [ ,Aceptado,Cancelado];
            Description = 'EX-SGG-FACTE';
        }

        field(50814; "Fecha timbrado"; Date)
        {
            Description = 'EX-SGG-FACTE';
        }

        field(50815; "Hora timbrado"; Time)
        {
            Description = 'EX-SGG-FACTE';
        }

        field(50816; "FacturaE generada"; Boolean)
        {
            Description = 'EX-SGG-FACTE';
        }

        field(50817; "FacturaE descargada"; Boolean)
        {
            Description = 'EX-SGG-FACTE';
        }

        field(50818; "Fecha FacturaE generada"; Date)
        {
            Description = 'EX-SGG-FACTE';
        }
        FIELD(50025; "SalesPerson Code New"; Code[40]) { TableRelation = "Salesperson/Purchaser"."Code New"; Editable = false; }
    }
    PROCEDURE "--EX-SGG-FACTE"();
    BEGIN
    END;

    PROCEDURE Direccion();
    BEGIN
        "Bill-to Address" := COPYSTR("Factura-a Calle" + ' ' + "Factura-a No. Ext.", 1, 100);
        IF "Factura-a No. Int." <> '' THEN
            "Bill-to Address" := COPYSTR("Bill-to Address" + ' - ' + "Factura-a No. Int.", 1, 100);

        "Sell-to Address" := "Bill-to Address";
    END;

}