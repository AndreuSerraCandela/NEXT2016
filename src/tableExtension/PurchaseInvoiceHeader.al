/// <summary>
/// TableExtension PurchaseInvoiceHeader (ID 92122) extends Record 122.
/// </summary>
tableextension 92122 PurchaseInvoiceHeader extends 122
{
    fields
    {
        field(50600; "SII Estado documento"; Enum "SII Estado documento")
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("SII- Datos SII Documentos"."Estado documento" WHERE("Tipo documento" = FILTER(Factura),
                                    "No. documento" = FIELD("No."),
                                    "Origen documento" = FILTER(Recibida)));
            //OptionCaptionML = ESP=" ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT";
            //OptionString = [ ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT];
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            Editable = false;
        }

        //    { 50601;  ;SII Fecha env¡o a control;Date     ;OnValidate=BEGIN
        //                                                             RstValSII.PermitirModificarDoc("SII Estado documento",TRUE); //EX-SGG 180717

        //                                                             //030817 EX-JVN SII
        //                                                             IF "SII Fecha env¡o a control" < "Posting Date" THEN
        //                                                               ERROR('La Fecha env¡o a control no puede ser inferior a la fecha de registro.');
        //                                                           END;

        //                                                Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
        field(50601; "SII Fecha envío a control"; Date)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            trigger OnValidate()
            var
                RstValSII: Record 50600;
            begin
                RstValSII.PermitirModificarDoc(Rec."SII Estado documento", TRUE); //EX-SGG 180717

                //030817 EX-JVN SII
                if (Rec."SII Fecha envío a control" < Rec."Posting Date") then
                    error('La Fecha envío a control no puede ser inferior a la fecha de registro.');
            end;
        }

        // { 50602;  ;SII Excluir env¡o   ;Boolean       ;OnValidate=BEGIN
        //                                                             RstValSII.PermitirModificarDoc("SII Estado documento",TRUE); //EX-SGG 180717
        //                                                           END;

        //                                                Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
        field(50602; "SII Excluir envío"; Boolean)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            trigger OnValidate()
            var
                RstValSII: Record 50600;
            begin
                RstValSII.PermitirModificarDoc(Rec."SII Estado documento", TRUE); //EX-SGG 180717
            end;


        }

        // { 50800;  ;Fiscal Invoice Number PAC;Text50   ;CaptionML=[ENU=Fiscal Invoice Number PAC;
        //                                                           ESM=N£mero de factura fiscal PAC;
        //                                                           FRC=Num‚ro de facture fiscale PAC;
        //                                                           ENC=Fiscal Invoice Number PAC];
        //                                                Description=EXC.REG;
        //                                                Editable=No }
        field(50800; "Fiscal Invoice Number PAC"; Text[50])
        {
            CaptionML = ENU = 'Fiscal Invoice Number PAC', ESM = 'Número de factura fiscal PAC', FRC = 'Numéro de facture fiscale PAC',
        ENC = 'Fiscal Invoice Number PAC';
            Description = 'EXC.REG';
            Editable = false;
        }
        field(50205; "Purchaser Code New"; Code[40])
        {
            Caption = 'Código de comprador';
            TableRelation = "Salesperson/Purchaser";
        }
    }
}
tableextension 92124 PurchaseCrHeader extends 124
{
    fields
    {
        field(50600; "SII Estado documento"; Enum "SII Estado documento")
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("SII- Datos SII Documentos"."Estado documento" WHERE("Tipo documento" = FILTER(Abono),
                                    "No. documento" = FIELD("No."),
                                    "Origen documento" = FILTER(Recibida)));
            //OptionCaptionML = ESP=" ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT";
            //OptionString = [ ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT];
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            Editable = false;
        }

        //    { 50601;  ;SII Fecha env¡o a control;Date     ;OnValidate=BEGIN
        //                                                             RstValSII.PermitirModificarDoc("SII Estado documento",TRUE); //EX-SGG 180717

        //                                                             //030817 EX-JVN SII
        //                                                             IF "SII Fecha env¡o a control" < "Posting Date" THEN
        //                                                               ERROR('La Fecha env¡o a control no puede ser inferior a la fecha de registro.');
        //                                                           END;

        //                                                Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
        field(50601; "SII Fecha envío a control"; Date)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            trigger OnValidate()
            var
                RstValSII: Record 50600;
            begin
                RstValSII.PermitirModificarDoc(Rec."SII Estado documento", TRUE); //EX-SGG 180717

                //030817 EX-JVN SII
                if (Rec."SII Fecha envío a control" < Rec."Posting Date") then
                    error('La Fecha envío a control no puede ser inferior a la fecha de registro.');
            end;
        }

        // { 50602;  ;SII Excluir env¡o   ;Boolean       ;OnValidate=BEGIN
        //                                                             RstValSII.PermitirModificarDoc("SII Estado documento",TRUE); //EX-SGG 180717
        //                                                           END;

        //                                                Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
        field(50602; "SII Excluir envío"; Boolean)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            trigger OnValidate()
            var
                RstValSII: Record 50600;
            begin
                RstValSII.PermitirModificarDoc(Rec."SII Estado documento", TRUE); //EX-SGG 180717
            end;


        }

        // { 50800;  ;Fiscal Invoice Number PAC;Text50   ;CaptionML=[ENU=Fiscal Invoice Number PAC;
        //                                                           ESM=N£mero de factura fiscal PAC;
        //                                                           FRC=Num‚ro de facture fiscale PAC;
        //                                                           ENC=Fiscal Invoice Number PAC];
        //                                                Description=EXC.REG;
        //                                                Editable=No }
        field(50800; "Fiscal Invoice Number PAC"; Text[50])
        {
            CaptionML = ENU = 'Fiscal Invoice Number PAC', ESM = 'Número de factura fiscal PAC', FRC = 'Numéro de facture fiscale PAC',
        ENC = 'Fiscal Invoice Number PAC';
            Description = 'EXC.REG';
            Editable = false;
        }
        field(50205; "Purchaser Code New"; Code[40])
        {
            Caption = 'Código de comprador';
            TableRelation = "Salesperson/Purchaser";
        }
    }
}