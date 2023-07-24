table 50602 "SII- Config. múltiple"
{
    // //010617 SII Nuevo objeto
    // 
    // EX-SGG 260617 NUEVOS CAMPOS Tipo factura emitida/recibida Y Clave regimen especial emitida/recibida
    //               PARA CONFIGURACIÓN MULTIPLE Y CONTRAPARTE. CODIGO EN CAMPOS.
    //        270617 NUEVO CAMPO Tipo de documento PARA ESTABLECER VALORES PREDETERMINADOS DEPENDIENDO DEL DOCUMENTO
    //        130717 TABLEERELATION EN CAMPO "Valor inicial".
    // EX-SMN 251017 COMENTADO GET DEL VALIDATE DE LOS CÓDIGOS DE PAÍS
    // EX-SMN 241017 NUEVOS CAMPOS Tipo abono emitido/recibido Y Clave regimen especial abono emitido/recibido
    //               PARA CONFIGURACIÓN MULTIPLE Y CONTRAPARTE. CODIGO EN CAMPOS.

    DrillDownPageID = 50605;
    LookupPageID = 50605;

    fields
    {
        field(1; "Tipo configuración"; Option)
        {
            OptionMembers = "Tipo operación","Tipo IVA","Cliente/Proveedor","Datos por documento","Criterio caja",Contraparte;
        }
        field(2; "No. Linea"; Integer)
        {
        }
        field(3; "Gr. Contable producto"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(4; "Gr. Reg. IVA Negocio"; Code[20])
        {
            TableRelation = "VAT Posting Setup"."VAT Bus. Posting Group";

            trigger OnLookup()
            var

                RecConfGrRegIVA: Record 325;
                Form472: Page "VAT Posting Setup";

                RecCliente: Record Customer;
                RecProveedor: Record Vendor;
                RecConfigMultipleAux: Record 50602;
            begin

                CLEAR(Form472);
                Form472.SETTABLEVIEW(RecConfGrRegIVA);
                Form472.LOOKUPMODE(TRUE);
                IF Form472.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    Form472.GETRECORD(RecConfGrRegIVA);
                    CASE "Tipo configuración" OF
                        "Tipo configuración"::"Tipo IVA":
                            BEGIN
                                "Gr. Reg. IVA Negocio" := RecConfGrRegIVA."VAT Bus. Posting Group";
                                "Gr. Reg. IVA Producto" := RecConfGrRegIVA."VAT Prod. Posting Group";
                                "Tipo cálculo IVA" := RecConfGrRegIVA."VAT Calculation Type";
                                "% IVA" := RecConfGrRegIVA."VAT %";
                                MODIFY;
                            END;
                        ELSE BEGIN
                            "Gr. Reg. IVA Negocio" := RecConfGrRegIVA."VAT Bus. Posting Group";
                            "Gr. Reg. IVA Producto" := '';
                            "Tipo cálculo IVA" := rec."Tipo cálculo IVA"::"Full VAT";
                            "% IVA" := 0;

                            MODIFY;
                        END;
                    END;
                END;
            end;
        }
        field(5; "Gr. Reg. IVA Producto"; Code[20])
        {
            Editable = false;
        }
        field(10; "Cód forma pago"; Code[12])
        {
            Description = 'Forma d epago estandar NAV para mapear con medio pago SII';
            TableRelation = "Payment Method".Code;
        }
        field(11; "Medio pago SII"; Code[2])
        {
            Description = 'Medio pago para Criterio de caja';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L11'));
        }
        field(20; "Tipo operación"; Code[1])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('HP2'));
        }
        /*field(21; "Tipo cálculo IVA"; Option)
        {
            Caption = 'VAT Calculation Type';
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax,No Taxable VAT';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax","No Taxable VAT"," ";
        }
        */
        field(21; "Tipo cálculo IVA"; Enum "Tax Calculation Type")
        {
            Caption = 'VAT Calculation Type';
            // OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax,No Taxable VAT';
            //  OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax","No Taxable VAT"," ";
        }
        field(22; "% IVA"; Decimal)
        {
            BlankZero = true;
        }
        field(23; Exento; Boolean)
        {
        }
        field(24; "Causa exención"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L9'));
        }
        field(25; "Tipo No Exención"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L7'));
        }
        field(26; "Inversión sujeto pasivo"; Boolean)
        {
        }
        field(27; "Tipo desglose IVA"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('HP1'));
        }
        field(28; "Tipo No sujeta"; Option)
        {
            OptionMembers = " ","Articulos 7-14-Otros","Reg. Localización";
        }
        field(29; REAGP; Boolean)
        {
        }
        field(30; "Régimen Criterio de caja"; Boolean)
        {
        }
        field(31; "Excluir del SII"; Boolean)
        {
            Description = 'Marcará la cabecera del documento como "Excluir del SII"';
        }
        field(32; DUA; Boolean)
        {
            Description = 'Para identificar en facturas las líneas DUA a declarar';
        }
        field(33; "Dato a exportar No Sujeto"; Option)
        {
            Description = 'En el caso de No sujetas por tener "Tipo No Sujeta", saber que valor se debe exportar';
            OptionCaption = ' ,Base IVA,Importe IVA Incl.,Cuota IVA';
            OptionMembers = " ","Base IVA","Importe IVA Incl.","Cuota IVA";
        }
        field(40; "Tipo Contraparte"; Option)
        {
            OptionMembers = Cliente,Proveedor;
        }
        field(41; "Cód. contraparte"; Code[20])
        {
            TableRelation = IF ("Tipo Contraparte" = CONST(Cliente)) Customer."No."
            ELSE
            IF ("Tipo Contraparte" = CONST(Proveedor)) Vendor."No.";

            trigger OnValidate()
            begin
                CASE "Tipo Contraparte" OF
                    "Tipo Contraparte"::Cliente:
                        IF RecCliente.GET("Cód. contraparte") THEN
                            "Nombre contraparte" := RecCliente.Name;
                    "Tipo Contraparte"::Proveedor:
                        IF RecProveedor.GET("Cód. contraparte") THEN
                            "Nombre contraparte" := RecProveedor.Name;
                END;
            end;
        }
        field(42; "Nombre contraparte"; Text[50])
        {
            Editable = false;
        }
        field(43; "Clave Id. fiscal contraparte"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L4'));
        }
        field(44; "NIF Representante contraparte"; Code[9])
        {
        }
        field(45; "Cód. país contraparte"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L17'));

            trigger OnValidate()
            var
                recCountry: Record "Country/Region";
            begin
                //recCountry.GET("Cód. país contraparte"); //030817 EX-JVN SII
            end;
        }
        field(46; "NIF/ID. fiscal contraparte"; Code[20])
        {
        }
        field(50; "Tipo factura emitida"; Code[2])
        {
            Description = 'EX-SGG 260617';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = CONST('L2_EMI'));

            trigger OnValidate()
            begin
                //EX-SGG 260617
                IF "Tipo configuración" = "Tipo configuración"::"Cliente/Proveedor" THEN
                    TESTFIELD("Tipo Contraparte", "Tipo Contraparte"::Cliente);
            end;
        }
        field(51; "Clave regimen especial emitida"; Code[2])
        {
            Caption = 'Clave régimen especial emitida';
            Description = 'EX-SGG 260617';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L31'));

            trigger OnValidate()
            begin
                //EX-SGG 260617
                IF "Tipo configuración" = "Tipo configuración"::"Cliente/Proveedor" THEN
                    TESTFIELD("Tipo Contraparte", "Tipo Contraparte"::Cliente);
            end;
        }
        field(52; "Tipo factura recibida"; Code[2])
        {
            Description = 'EX-SGG 260617';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = CONST('L2_RECI'));

            trigger OnValidate()
            begin
                //EX-SGG 260617
                IF "Tipo configuración" = "Tipo configuración"::"Cliente/Proveedor" THEN
                    TESTFIELD("Tipo Contraparte", "Tipo Contraparte"::Proveedor);
            end;
        }
        field(53; "Clave regimen especial recibid"; Code[2])
        {
            Caption = 'Clave régimen especial recibida';
            Description = 'EX-SGG 260617';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L32'));

            trigger OnValidate()
            begin
                //EX-SGG 260617
                IF "Tipo configuración" = "Tipo configuración"::"Cliente/Proveedor" THEN
                    TESTFIELD("Tipo Contraparte", "Tipo Contraparte"::Proveedor);
            end;
        }
        field(54; "Tipo de documento"; Option)
        {
            Description = 'EX-SGG 270617';
            OptionCaption = 'Facturas,Abonos';
            OptionMembers = Facturas,Abonos;
        }
        field(55; "Tipo abono emitido"; Code[2])
        {
            Description = 'EX-SMN 241017';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = CONST('L2_EMI'));

            trigger OnValidate()
            begin
                //EX-SMN 241017
                IF "Tipo configuración" = "Tipo configuración"::"Cliente/Proveedor" THEN
                    TESTFIELD("Tipo Contraparte", "Tipo Contraparte"::Cliente);
            end;
        }
        field(56; "Clave rég. esp. abono emitido"; Code[2])
        {
            Caption = 'Clave rég. esp. abono emitido';
            Description = 'EX-SMN 241017';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L31'));

            trigger OnValidate()
            begin
                //EX-SMN 241017
                IF "Tipo configuración" = "Tipo configuración"::"Cliente/Proveedor" THEN
                    TESTFIELD("Tipo Contraparte", "Tipo Contraparte"::Cliente);
            end;
        }
        field(57; "Tipo abono recibido"; Code[2])
        {
            Description = 'EX-SMN 241017';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = CONST('L2_RECI'));

            trigger OnValidate()
            begin
                //EX-SMN 241017
                IF "Tipo configuración" = "Tipo configuración"::"Cliente/Proveedor" THEN
                    TESTFIELD("Tipo Contraparte", "Tipo Contraparte"::Proveedor);
            end;
        }
        field(58; "Clave rég. esp. abono recibido"; Code[2])
        {
            Caption = 'Clave rég. esp. abono recibido';
            Description = 'EX-SMN 241017';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L32'));

            trigger OnValidate()
            begin
                //EX-SMN 241017
                IF "Tipo configuración" = "Tipo configuración"::"Cliente/Proveedor" THEN
                    TESTFIELD("Tipo Contraparte", "Tipo Contraparte"::Proveedor);
            end;
        }
        field(100; "Nombre dato SII"; Text[50])
        {
        }
        field(101; "Filtro tabla valores SII"; Code[10])
        {
        }
        field(102; "Informar en documento"; Option)
        {
            OptionMembers = Expedido,Recibido,"B.I.";
        }
        field(103; Observaciones; Text[250])
        {
        }
        field(104; Orden; Integer)
        {
            Description = 'Orden de aparición en documento';
        }
        field(105; "Dato SII a exportar como"; Text[100])
        {
            Description = 'Mapeo con su correspondiente Nodo para el mensaje XLM';
        }
        field(106; Desactivar; Boolean)
        {
            Description = 'No se arrastra al documento';
        }
        field(107; Obligatorio; Boolean)
        {
            Description = 'Control en registro de documento';
        }
        field(108; "Valor inicial"; Text[50])
        {
            Description = 'Valor por defecto al insertarse en el documento';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FIELD("Filtro tabla valores SII"));
        }
    }


    keys
    {
        key(Key1; "Tipo configuración", "No. Linea")
        {
            Clustered = true;
        }
        key(Key2; Orden)
        {
        }


    }




    trigger OnInsert()
    VAR
    begin
        RecConfigMultipleAux.RESET;
        RecConfigMultipleAux.SETRANGE(RecConfigMultipleAux."Tipo configuración", "Tipo configuración");
        IF RecConfigMultipleAux.FINDLAST THEN
            "No. Linea" := RecConfigMultipleAux."No. Linea" + 10000
        ELSE
            "No. Linea" := 10000;
    end;

    var

        RecConfGrRegIVA: Record 325;
        Form472: page "VAT Posting Setup";
        RecCliente: Record Customer;
        RecProveedor: Record Vendor;
        RecConfigMultipleAux: Record 50602;

}



