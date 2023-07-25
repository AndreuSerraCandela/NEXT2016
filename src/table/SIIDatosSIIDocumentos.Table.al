/// <summary>
/// Table SII- Datos SII Documentos (ID 50601).
/// </summary>
table 50601 "SII- Datos SII Documentos"
{
    // EX-SGG SII 280617 CAMBIO LONGITUD CAMPO DesgloseIVAFactura DE 1 A 2.
    //            130717 NUEVA OPCIÓN EN CAMPO "Estado documento" "Obtener de nuevo"
    //            180717 NUEVA CLAVE Desglose tipo operación,Sujeta,Exenta
    // EX-AHG SII 270917 Nuevo campo "Fecha operación"
    // EX-JVN 061017 Nueva opcion para Tipo DUA, Excluir
    //        111017 Añadido Tipo DUA=FILTER(<>Transitario&<>Excluir) al cálculo de Nº líneas detalle
    // 
    // EX-JVN SII 230218 Nuevo campo en la clave primaria "Origen documento"
    // EX-JVN SII 260218 Nuevo filtro para diferenciar entre compras y ventas
    // EX-SIIv3 230518 Nuevos campos SII v3
    // EX-SIIv4 Nueva clave de Estado Documento y Origen documento
    //          Nuevos campos Respuesta AEAT, Mensaje Respuesta


    fields
    {
        field(1; "Tipo registro"; Enum "Sii Tipo registro")
        {
            //OptionMembers = Cabecera,Detalles;
        }
        field(2; "Tipo documento"; enum "Sii Tipos Documento")
        {
            //  OptionMembers = Factura,Abono,"B.I.";
        }
        field(3; "No. documento"; Code[20])
        {
            TableRelation = IF ("Tipo procedencia" = CONST(Cliente),
                                "Tipo documento" = CONST(Factura)) "Sales Invoice Header" WHERE("No." = FIELD("No. documento"))
            ELSE
            IF ("Tipo procedencia" = CONST(Cliente),
                                         "Tipo documento" = CONST(Abono)) "Sales Cr.Memo Header" WHERE("No." = FIELD("No. documento"))
            ELSE
            IF ("Tipo procedencia" = CONST(Proveedor),
                                                  "Tipo documento" = CONST(Factura)) "Purch. Inv. Header" WHERE("No." = FIELD("No. documento"))
            ELSE
            IF ("Tipo procedencia" = CONST(Proveedor),
                                                           "Tipo documento" = CONST(Abono)) "Purch. Cr. Memo Hdr." WHERE("No." = FIELD("No. documento"));
            ValidateTableRelation = false;
        }
        field(4; "No. Línea"; Integer)
        {
        }
        field(5; "Origen documento"; Enum "Sii Origen Documento")
        {
            //OptionMembers = Emitida,Recibida,"B.I.";
        }
        field(6; "Fecha de registro"; Date)
        {
        }
        field(7; "Tipo procedencia"; Option)
        {
            OptionMembers = Cliente,Proveedor,"B.I.",DUA;
        }
        field(8; "Cód. procedencia"; Code[20])
        {
        }
        field(9; "Nombre procedencia"; Text[100])
        {
        }
        field(10; "Importe total documento"; Decimal)
        {
            BlankZero = true;
        }
        field(11; "Fecha obtención información"; DateTime)
        {
        }
        field(12; "Fecha exportación ficheros"; DateTime)
        {
        }
        field(13; "Fecha envío a plataforma"; DateTime)
        {
        }
        field(14; "Tipo factura"; Code[2])
        {
            TableRelation = IF ("Origen documento" = CONST(Emitida)) "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L2_EMI'))
            ELSE
            IF ("Origen documento" = CONST(Recibida)) "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L2_RECI'));
        }
        field(15; "Clave régimen especial"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L31'));
        }
        field(16; "Descripción documento"; Text[250])
        {
        }
        field(17; "Tipo comunicación"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L0'));
        }
        field(18; "Tipo factura rectificativa"; Code[1])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L5'));
        }
        field(19; "Nº serie registro"; Code[20])
        {
        }
        field(20; "NIF Representante legal"; Code[9])
        {
        }
        field(21; "NIF Contraparte operación"; Code[20])
        {
        }
        field(22; "Cód. país contraparte"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L17'));
        }
        field(23; "Clave Id. fiscal residencia"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L4'));
        }
        field(24; "NIF/ID. fiscal país residencia"; Code[20])
        {
        }
        field(25; "Total Base imponible"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
        }
        field(26; "Situación Inmueble"; Code[1])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L6'));
        }
        field(27; "Ref. catastral Inmueble"; Text[25])
        {
        }
        field(28; "Fecha requerida envío control"; Date)
        {
            Editable = false;
        }
        field(29; Ejercicio; Integer)
        {
        }
        field(30; Periodo; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L1'));
        }
        field(31; "Base rectificada"; Decimal)
        {
        }
        field(32; "Cuota rectificada"; Decimal)
        {
        }
        field(33; "Cuota recargo rectificada"; Decimal)
        {
        }
        field(34; "Identificacion fras Rect-Sust."; Text[50])
        {
        }
        field(35; "Nº Doc. proveedor"; Text[35])
        {
        }
        field(36; "Tipo DUA"; Option)
        {
            OptionMembers = " ",Proveedor,Transitario,Excluir;
        }
        field(37; "No Doc. DUA"; Text[20])
        {
        }
        field(38; "Fecha exp. DUA"; Date)
        {
        }
        field(39; "Fecha operación"; Date)
        {
            Description = 'En rectificativas = Fecha registro doc. rectificado. En el resto = fecha registro';
        }
        field(50; "Desglose tipo operación"; Code[1])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('HP2'));
        }
        field(51; Sujeta; Boolean)
        {
        }
        field(52; Exenta; Boolean)
        {
        }
        field(53; "Cód. causa exención"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L9'));
        }
        field(54; "Base Imponible exenta"; Decimal)
        {
        }
        field(55; "Tipo no exenta"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L7'));
        }
        field(56; "Tipo impositivo no exenta"; Decimal)
        {
        }
        field(57; "Base imponible no exenta"; Decimal)
        {
        }
        field(58; "Cuota imp. no exenta"; Decimal)
        {
        }
        field(59; "Tipo RE no exenta"; Decimal)
        {
        }
        field(60; "Cuota RE no exenta"; Decimal)
        {
        }
        field(61; "Importe no sujeta Art. 7,14"; Decimal)
        {
        }
        field(62; "Importe no sujeta localización"; Decimal)
        {
        }
        field(63; "Importe transmisiones inmueble"; Decimal)
        {
        }
        field(64; "Emitida por terceros"; Code[1])
        {
        }
        field(65; "Varios destinatarios"; Code[1])
        {
        }
        field(66; "Minoración base imponible"; Code[1])
        {
        }
        field(67; "Cuota deducible"; Decimal)
        {
        }
        field(68; "% Compensación REAGYP"; Decimal)
        {
        }
        field(69; "Importe Compensación REAGYP"; Decimal)
        {
        }
        field(70; DesgloseIVAFactura; Code[2])
        {
            Description = 'EX-SGG 280617 DE 1->2';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('HP1'));
        }
        field(71; "Inv. Sujeto Pasivo"; Boolean)
        {
        }
        field(72; "Tipo No sujeta"; Option)
        {
            OptionMembers = " ","Articulos 7-14-Otros","Reg. Localización";
        }
        field(73; REAGP; Boolean)
        {
        }
        field(74; "Régimen Criterio de caja"; Boolean)
        {
        }
        field(75; "Base imponible no sujeta"; Decimal)
        {
        }
        field(76; "IVA Diferencia"; Decimal)
        {
        }
        field(77; "RE Diferencia"; Decimal)
        {
        }
        field(100; "Tipo Op. Intracomunitaria"; Code[1])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L12'));
        }
        field(101; "Clave declarado"; Code[1])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L13'));
        }
        field(102; "Cód. estado origen/envío"; Code[2])
        {
        }
        field(103; "Plazo operación"; Integer)
        {
        }
        field(104; "Descripción bienes"; Text[40])
        {
        }
        field(105; "Dirección operador intracom."; Text[120])
        {
        }
        field(106; "Otra documentación"; Text[150])
        {
        }
        field(107; "Factura resumen final"; Text[60])
        {
        }
        field(108; "Factura resumen inicial"; Text[60])
        {
        }
        field(200; "Estado documento"; enum "Sii Estado Documento")
        {
            // OptionCaption = ' ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT';
            //OptionMembers = " ","Pendiente procesar","Incluido en fichero","Enviado a plataforma",Incidencias,"Obtener de nuevo","Validado AEAT";

            trigger OnValidate()
            var
                RecDatosCabeceraSII: Record "SII- Datos SII Documentos";
            begin
                /*
                // Si es Detalle , la cabecera tambien cambiará de estado
                IF "Tipo registro" ="Tipo registro"::Detalles THEN
                BEGIN
                   CASE "Estado documento" OF
                    "Estado documento"::Incidencias:
                      BEGIN
                        RecDatosCabeceraSII.RESET;
                        RecDatosCabeceraSII.SETCURRENTKEY("No. documento","Tipo documento","Tipo registro","Estado documento");
                        RecDatosCabeceraSII.SETRANGE("No. documento","No. documento");
                        RecDatosCabeceraSII.SETRANGE("Tipo documento","Tipo documento");
                        RecDatosCabeceraSII.SETRANGE("Tipo registro","Tipo registro"::Cabecera);
                        RecDatosCabeceraSII.FINDFIRST;
                        RecDatosCabeceraSII."Estado documento":="Estado documento";
                        RecDatosCabeceraSII."Log. incidencias":='Incidencia en línea de detalle del documento.';
                        RecDatosCabeceraSII.MODIFY;
                      END;
                   END;
                END;
                */
                //140717 EX-JVN
                IF "Tipo registro" = "Tipo registro"::Cabecera THEN BEGIN
                    RecDatosCabeceraSII.RESET;
                    RecDatosCabeceraSII.SETCURRENTKEY("No. documento", "Tipo documento", "Tipo registro", "Estado documento");
                    RecDatosCabeceraSII.SETRANGE("No. documento", "No. documento");
                    RecDatosCabeceraSII.SETRANGE("Tipo documento", "Tipo documento");
                    RecDatosCabeceraSII.SETRANGE("Tipo registro", "Tipo registro"::Detalles);
                    RecDatosCabeceraSII.SETRANGE("Origen documento", "Origen documento"); //260218 EX-JVN
                    IF RecDatosCabeceraSII.FINDSET THEN
                        RecDatosCabeceraSII.MODIFYALL("Estado documento", Rec."Estado documento");
                    /*
                    END ELSE BEGIN
                      RecDatosCabeceraSII.RESET;
                      RecDatosCabeceraSII.SETCURRENTKEY("No. documento","Tipo documento","Tipo registro","Estado documento");
                      RecDatosCabeceraSII.SETRANGE("No. documento","No. documento");
                      RecDatosCabeceraSII.SETRANGE("Tipo documento","Tipo documento");
                      RecDatosCabeceraSII.SETRANGE("Tipo registro","Tipo registro"::Cabecera);
                      RecDatosCabeceraSII.FINDFIRST;
                      IF RecDatosCabeceraSII."Estado documento" <> "Estado documento" THEN BEGIN
                        MESSAGE('Modifique el campo "Estado documento" de la cabecera.');
                        "Estado documento" := xRec."Estado documento";
                      END;
                    */
                END;
                //140717 fin

            end;
        }
        field(201; "Log. incidencias"; Text[250])
        {
            Description = 'EX-SII 151117 De 100 a 250';
        }
        field(202; "Incluido en fichero"; Text[50])
        {
        }
        field(203; "No Lineas detalle"; Integer)
        {
            /*    CalcFormula = Count("SII- Datos SII Documentos" WHERE("Tipo registro"=FILTER(Detalles),
                                                                       "Tipo documento"=FIELD(Tipo documento),
                                                                       "No. documento"=FIELD("No. documento"),
                                                                       "Origen documento"=FIELD(Origen documento),
                                                                       "Tipo DUA"=FILTER(<>'Transitario&'<>Excluir)));
                                                                       */
            //CalcFormula = count("SII- Datos documento" where (tipo r))

            FieldClass = FlowField;
        }
        field(300; "CC Importe Cobrado/Pagado"; Decimal)
        {
            Description = 'CC (Criterio de caja)';
        }
        field(301; "CC Importe pendiente"; Decimal)
        {
            Description = 'CC (Criterio de caja)';
        }
        field(302; ControlInternoProcesosCC; Integer)
        {
            Description = 'CC (Criterio de caja)';
        }
        field(303; "CC Medio pago SII"; Code[2])
        {
            Description = 'Medio pago para Criterio de caja';
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L11'));
        }
        field(304; "Factura SinIdentifDestinatario"; Code[1])
        {
            Description = 'SII v3';
            InitValue = 'N';
        }
        field(305; FacturaSimplificadaArticulos; Code[1])
        {
            Description = 'SII v3';
            InitValue = 'N';
        }
        field(306; MacroDato; Code[1])
        {
            Description = 'SII v3';
            InitValue = 'N';
        }
        field(307; "Respuesta AEAT"; Option)
        {
            Description = 'SII v4';
            OptionCaption = ' ,Aceptada,Acepatada con Errores,Rechazada';
            OptionMembers = " ",Aceptada,"Acepatada con Errores",Rechazada;

            trigger OnValidate()
            begin
                //EX-SIIv4
                IF "Respuesta AEAT" = "Respuesta AEAT"::Aceptada THEN
                    VALIDATE("Estado documento", "Estado documento"::"Validado AEAT");
            end;
        }
        field(308; "Mensaje Respuesta"; Text[250])
        {
            Description = 'SII v4';
        }
    }

    keys
    {
        key(Key1; "Tipo documento", "No. documento", "No. Línea", "Origen documento")
        {
            Clustered = true;
        }
        key(Key2; "Tipo registro", "Tipo documento", "No. documento", "Tipo no exenta")
        {
        }
        key(Key3; "Tipo registro", "Tipo documento", "No. documento", "Desglose tipo operación", "Tipo no exenta", "Inv. Sujeto Pasivo", "Tipo impositivo no exenta")
        {
        }
        key(Key4; "No. documento", "Tipo documento", "Tipo registro", "Estado documento")
        {
        }
        key(Key5; "Desglose tipo operación", Sujeta, Exenta)
        {
        }
        key(Key6; "Estado documento", "Origen documento")
        {
        }
    }

    fieldgroups
    {
    }
}

