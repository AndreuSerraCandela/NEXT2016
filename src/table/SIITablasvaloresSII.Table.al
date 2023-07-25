table 50600 "SII- Tablas valores SII"
{
    // //010617 SII Nuevo objeto
    // 
    // EX-SGG 260617 NUEVAS FUNCIONES InsertarDatosContraparte Y InsertaDatoEnDocumento PARA DESARROLLAR MEJORAS DEL SII.
    //               MODIFICACION EN InsertarDatosDocumento PARA NO SALIR SI ENCUENTRA ALGUN DATO SII YA EN EL DOCUMENTO Y
    //                NO INSERTAR EN CASO DE QUE YA EXISTA. LLAMADA A FUNCION InsertarDatosContraparte. NUEVO PARAMETRO FUNCION.
    //        270617 CODIGO EN InsertarDatosDocumento PARA USO DE NUEVO CAMPO "Tipo de documento".
    //        280617 SE AGREGA 'TipoDesglose' E ISP (INVERSION SUJETO PASIVO) EN FUNCION GenerarFicheros.
    //               CORRECCIONES EN FUNCION GenerarFicheros. AGRUPO POR "Cód. causa exención". TRANSFERFIELDS.
    //        300617 GESTION FTPS EN SubirFtp().
    //        130717 CODIGO EN ObtenerDocumentos PARA RECOGER DE NUEVO EL REGISTRO PUESTO QUE PUEDE HABER SIDO MODIFICADO AL LOCALIZAR
    //                 INCIDENCIA EN LOS DETALLES DEL DOCUMENTO.
    //        140717 NUEVA FUNCION DevuelveNIFIDFiscalContraparte. CODIGO DE LLAMADA EN InsertaContraparte
    // 
    //        EX-AHG SII+ 130717 A¤adir al nombre de los ficheros de texto generados fecha y hora para permitir m s de un fichero en el mismo d¡a.
    //        EX-AHG SII+ 140717 A¤adir Chequeos reglas de negocio en funci¢n "ChequeosPorDocumento"
    // 
    // EX-OMI 080817 Cálculo de la cuota deducible para las cabeceras de DatosSII
    // 
    // EX-OMI SII 170817 Correcion Criterio de Caja
    //                   Correcion "Cuota deducible" cuando es reversion, con facturas positivo, en abonos negativo
    // 
    // EX-OMI SII 180817 Mostrar lineas con grupo registro IVA producto en blanco
    // EX-AHG SII 270917 Añadido "Fecha operación" al proceso.
    // EX-JVN 110917 SII Función process.WaitForExit espera a finalizar la ejecución.
    // EX-OMI 031017 SII Funcion Ascii2UTF8
    // EX-OMI 301017 Modificacion Hora generar Ficheros
    //               Modificacion Facturas a 0
    // EX-SMN 031117 Modificación cálculos DUA
    // EX-SMN 101117 Corregido el filtro que excluía todos las líneas con "Tipo DUA::Transitario" o "Excluir" aunque fuesen del documento fictio de DUA
    // 
    // EX-JVN 160218 Aplicar cáclculo de ISP a todos los documentos de Reversión, ObtenerDetallesDocumento de compras. Considerar que los
    //               documentos de reversión informan campos de No exenta con el check marcado en conf. múltiple.
    // EX-JVN 260218 Añadido filtro "Origen Documento" en diversas partes para diferenciar documentos de venta y compra con el mismo número
    //               Sustituidas diversas asignaciones por VALIDATE().
    // EX-SIIv3 220518 Mejoras SII v3
    //                 Al generar fichero, sólo en compras, la fecha de expedición es la "fecha de emisión documento" del documento.
    //          070618 Modificaciones
    // EX-SIIv3 070818 CLEAR de FechaExpedición, reestructuración IF
    // EX-SIIv4 Nueva funcionalidad
    // EX-RBF 021220 Modificacion importe para SII2021.
    //        040121 Correcion SII.
    //        010321 Añadido Manual.

    DataCaptionFields = "Id. tabla", Valor, "Descripción";
    // DrillDownPageID = 50600;
    //  LookupPageID = 50600;
    Permissions = TableData 112 = rimd,
                  TableData 114 = rimd,
                  TableData 122 = rimd,
                  TableData 124 = rimd,
                  TableData 5900 = rimd,
                  TableData 5992 = rimd,
                  TableData 5994 = rimd;

    fields
    {
        field(1; "Id. tabla"; Code[10])
        {
        }
        field(2; Valor; Code[50])
        {
        }
        field(3; "Descripción"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Id. tabla", Valor)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Id. tabla", Valor, "Descripción")
        {
        }
    }

    var
        Pt_InfoEmpresa: Record 50605;
        EsCriterioCaja: Boolean;
        CurrExchRate: Record "Currency Exchange Rate";
    //    InFileIncidencias: Record 2000000022;


    procedure InsertarDatosDocumento(TipoDocumento: Integer; NoDocumento: Code[20])
    var
        RecTablaMaestraValores: Record "SII- Tablas valores SII";
        RecConfigDatosDocumento: Record "SII- Config. múltiple";
        RecDatosDocumento: Record "SII- Datos documento";
    begin
        // Inserta los registros con datos configurados obligatorios para el documento.
        // "Tipo documento"::"Factura emitida" vale para Pedidos y Facturas borrador
        // "Tipo documento"::"Abono emitido"   vale para Devoluciones y Abonos borrador

        /*
        1 Factura emitida,
        2 Abono emitido,
        3 Factura emitida reg.,
        4 Abono emitido reg.,
        5 Factura recibida,
        6 Abono recibido,
        7 Factura recibida reg.,
        8 Abono recibido reg.,
        9 BI
        10 Srv pedido,
        11 Srv Factura,
        12 Srv Abono,
        13 Srv Factura reg.,
        14 Srv Abono reg.
        */


        CASE TipoDocumento OF
            1:
                BEGIN    // Fact. emitida borrador
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Factura emitida");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Expedido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Facturas); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Factura emitida";
                END;
            2:
                BEGIN    // Abono emitido borrador
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Abono emitido");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::
                    Expedido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Abonos); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Abono emitido";
                END;
            3:
                BEGIN    // Factura emitida reg.
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Factura emitida reg.");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Expedido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Facturas); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Factura emitida reg.";
                END;
            4:
                BEGIN    // Abono emitida reg.
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Abono emitido reg.");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Expedido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Abonos); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Abono emitido reg.";
                END;

            5: // Fact. recibida borrador
                BEGIN
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Factura recibida");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Recibido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Facturas); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Factura recibida";
                END;
            6: // Abono recibido borrador
                BEGIN
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Abono recibido");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Recibido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Abonos); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Abono recibido";
                END;
            7: // Factura recibida reg.
                BEGIN
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Factura recibida reg.");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Recibido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Facturas); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Factura recibida reg.";
                END;
            8: // Abono recibido reg.
                BEGIN
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Abono recibido reg.");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Recibido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Abonos); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Abono recibido reg.";
                END;
            10: // Servicio pedido
                BEGIN
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Srv pedido");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Expedido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Facturas); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Srv pedido";
                END;
            11: // Servicio Factura
                BEGIN
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Srv Factura");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Expedido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Facturas); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Srv Factura";
                END;
            12: // Servicio Abono
                BEGIN
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Srv Abono");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Expedido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Abonos); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Srv Abono";
                END;
            13: // Servicio Factura Reg.
                BEGIN
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Srv Factura reg.");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Expedido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Facturas); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Srv Factura reg.";
                END;
            14: // Servicio Abono Reg.
                BEGIN
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Srv Abono reg.");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumento);
                    IF RecDatosDocumento.FINDFIRST THEN EXIT;
                    RecConfigDatosDocumento.RESET;
                    RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
                    RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
                    RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Expedido);
                    RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Abonos); //EX-SGG 270617
                    RecDatosDocumento.RESET;
                    RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Srv Abono reg.";
                END;

        END;

        RecConfigDatosDocumento.SETCURRENTKEY(Orden);
        IF RecConfigDatosDocumento.FINDSET THEN
            REPEAT
                RecDatosDocumento."No. Documento" := NoDocumento;
                RecDatosDocumento."Dato SII" := RecConfigDatosDocumento."Nombre dato SII";
                RecDatosDocumento."Desc. dato SII" := RecConfigDatosDocumento.Observaciones;
                RecDatosDocumento."Filtro valores maestros SII" := RecConfigDatosDocumento."Filtro tabla valores SII";
                RecDatosDocumento.Orden := RecConfigDatosDocumento.Orden;
                RecDatosDocumento."Valor dato SII" := RecConfigDatosDocumento."Valor inicial";
                RecDatosDocumento.Obligatorio := RecConfigDatosDocumento.Obligatorio;
                RecDatosDocumento."Dato SII a exportar como" := RecConfigDatosDocumento."Dato SII a exportar como";
                IF NOT RecDatosDocumento.INSERT THEN;
            UNTIL RecConfigDatosDocumento.NEXT = 0;

    end;


    procedure RegistrarDatosDocumento(TipoDocumentoOrigen: Integer; NoDocumentoOrigen: Code[20]; NoDocumentoDestino: Code[20]; "Venta-Compra": Option Venta,Compra; ExcluirSII: Boolean)
    var
        RecDatosDocumento: Record "SII- Datos documento";
        RecDatosDocumentoDestino: Record "SII- Datos documento";
        TextoErrorSII: Text[250];
    begin
        // Arrastra datos SII desde Pedido/Fra/Abo (Venta-Compra)   hasta   Fra reg./Abono reg. (Venta-Compra)
        // "Tipo documento"::"Factura emitida" vale para Pedidos y Facturas borrador
        // "Tipo documento"::"Abono emitido"   vale para Devoluciones y Abonos borrador
        /*
        0 Oferta,
        1 Pedido,
        2 Factura,
        3 Abono,
        4 Pedido abierto,
        5 Devolución
        
        Servicio
        10 Quote,
        11 Order,
        12 Invoice,
        13 Credit Memo
        
        */
        Pt_InfoEmpresa.GET;
        CASE TipoDocumentoOrigen OF
            1, 2:
                BEGIN    // Fact.-Pedido  borrador
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Factura emitida");
                    IF "Venta-Compra" = "Venta-Compra"::Compra THEN
                        RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Factura recibida");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumentoOrigen);
                    IF RecDatosDocumento.FINDSET THEN BEGIN
                        //Control obligatorios SII
                        IF (Pt_InfoEmpresa."Testeo Datos SII en registro") AND (NOT ExcluirSII) THEN BEGIN
                            IF ChequeosObligatoriosRegistro(TipoDocumentoOrigen, "Venta-Compra", NoDocumentoOrigen, TextoErrorSII) THEN
                                ERROR(TextoErrorSII);
                            IF ChequeosConfigIVA(TipoDocumentoOrigen, "Venta-Compra", NoDocumentoOrigen, TextoErrorSII) THEN
                                ERROR(TextoErrorSII);
                        END;
                        REPEAT
                            RecDatosDocumentoDestino.RESET;
                            RecDatosDocumentoDestino.TRANSFERFIELDS(RecDatosDocumento);
                            RecDatosDocumentoDestino."Tipo documento" := RecDatosDocumentoDestino."Tipo documento"::"Factura emitida reg.";
                            IF "Venta-Compra" = "Venta-Compra"::Compra THEN
                                RecDatosDocumentoDestino."Tipo documento" := RecDatosDocumentoDestino."Tipo documento"::"Factura recibida reg.";
                            RecDatosDocumentoDestino."No. Documento" := NoDocumentoDestino;
                            RecDatosDocumentoDestino.INSERT;
                        //RecDatosDocumentoDestino.DELETE;
                        UNTIL RecDatosDocumento.NEXT = 0;
                    END ELSE
                        IF (Pt_InfoEmpresa."Testeo Datos SII en registro") AND (NOT ExcluirSII) THEN
                            ERROR('El documento ' + NoDocumentoOrigen + ' no tiene informados los Datos SII necesarios.');
                END;
            3, 5:
                BEGIN    // Abo.-Dev   borrador
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Abono emitido");
                    IF "Venta-Compra" = "Venta-Compra"::Compra THEN
                        RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Abono recibido");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumentoOrigen);
                    IF RecDatosDocumento.FINDSET THEN BEGIN
                        //Control obligatorios SII
                        IF (Pt_InfoEmpresa."Testeo Datos SII en registro") AND (NOT ExcluirSII) THEN BEGIN
                            IF ChequeosObligatoriosRegistro(TipoDocumentoOrigen, "Venta-Compra", NoDocumentoOrigen, TextoErrorSII) THEN
                                ERROR(TextoErrorSII);
                            IF ChequeosConfigIVA(TipoDocumentoOrigen, "Venta-Compra", NoDocumentoOrigen, TextoErrorSII) THEN
                                ERROR(TextoErrorSII);
                        END;
                        REPEAT
                            RecDatosDocumentoDestino.RESET;
                            RecDatosDocumentoDestino.TRANSFERFIELDS(RecDatosDocumento);
                            RecDatosDocumentoDestino."Tipo documento" := RecDatosDocumentoDestino."Tipo documento"::"Abono emitido reg.";
                            IF "Venta-Compra" = "Venta-Compra"::Compra THEN
                                RecDatosDocumentoDestino."Tipo documento" := RecDatosDocumentoDestino."Tipo documento"::"Abono recibido reg.";
                            RecDatosDocumentoDestino."No. Documento" := NoDocumentoDestino;
                            RecDatosDocumentoDestino.INSERT;
                        //RecDatosDocumentoDestino.DELETE;
                        UNTIL RecDatosDocumento.NEXT = 0;
                    END ELSE
                        IF (Pt_InfoEmpresa."Testeo Datos SII en registro") AND (NOT ExcluirSII) THEN
                            ERROR('El documento ' + NoDocumentoOrigen + ' no tiene informados los Datos SII necesarios.');
                END;
            11:
                BEGIN    // Pedido Modulo Servicios
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Srv pedido");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumentoOrigen);
                    IF RecDatosDocumento.FINDSET THEN BEGIN
                        //Control obligatorios SII
                        IF (Pt_InfoEmpresa."Testeo Datos SII en registro") AND (NOT ExcluirSII) THEN BEGIN
                            IF ChequeosObligatoriosRegistro(TipoDocumentoOrigen, "Venta-Compra", NoDocumentoOrigen, TextoErrorSII) THEN
                                ERROR(TextoErrorSII);
                            IF ChequeosConfigIVA(TipoDocumentoOrigen, "Venta-Compra", NoDocumentoOrigen, TextoErrorSII) THEN
                                ERROR(TextoErrorSII);
                        END;
                        REPEAT
                            RecDatosDocumentoDestino.RESET;
                            RecDatosDocumentoDestino.TRANSFERFIELDS(RecDatosDocumento);
                            RecDatosDocumentoDestino."Tipo documento" := RecDatosDocumentoDestino."Tipo documento"::"Srv Factura reg.";
                            RecDatosDocumentoDestino."No. Documento" := NoDocumentoDestino;
                            RecDatosDocumentoDestino.INSERT;
                        //RecDatosDocumentoDestino.DELETE;
                        UNTIL RecDatosDocumento.NEXT = 0;
                    END ELSE
                        IF (Pt_InfoEmpresa."Testeo Datos SII en registro") AND (NOT ExcluirSII) THEN
                            ERROR('El documento ' + NoDocumentoOrigen + ' no tiene informados los Datos SII necesarios.');
                END;
            12:
                BEGIN    // Factura Modulo Servicios
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Srv Factura");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumentoOrigen);
                    IF RecDatosDocumento.FINDSET THEN BEGIN
                        //Control obligatorios SII
                        IF (Pt_InfoEmpresa."Testeo Datos SII en registro") AND (NOT ExcluirSII) THEN BEGIN
                            IF ChequeosObligatoriosRegistro(TipoDocumentoOrigen, "Venta-Compra", NoDocumentoOrigen, TextoErrorSII) THEN
                                ERROR(TextoErrorSII);
                            IF ChequeosConfigIVA(TipoDocumentoOrigen, "Venta-Compra", NoDocumentoOrigen, TextoErrorSII) THEN
                                ERROR(TextoErrorSII);
                        END;
                        REPEAT
                            RecDatosDocumentoDestino.RESET;
                            RecDatosDocumentoDestino.TRANSFERFIELDS(RecDatosDocumento);
                            RecDatosDocumentoDestino."Tipo documento" := RecDatosDocumentoDestino."Tipo documento"::"Srv Factura reg.";
                            RecDatosDocumentoDestino."No. Documento" := NoDocumentoDestino;
                            RecDatosDocumentoDestino.INSERT;
                        //RecDatosDocumentoDestino.DELETE;
                        UNTIL RecDatosDocumento.NEXT = 0;
                    END ELSE
                        IF (Pt_InfoEmpresa."Testeo Datos SII en registro") AND (NOT ExcluirSII) THEN
                            ERROR('El documento ' + NoDocumentoOrigen + ' no tiene informados los Datos SII necesarios.');
                END;
            13:
                BEGIN    // Abono Modulo Servicios
                    RecDatosDocumento.RESET;
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."Tipo documento", RecDatosDocumento."Tipo documento"::"Srv Abono");
                    RecDatosDocumento.SETRANGE(RecDatosDocumento."No. Documento", NoDocumentoOrigen);
                    IF RecDatosDocumento.FINDSET THEN BEGIN
                        //Control obligatorios SII
                        IF (Pt_InfoEmpresa."Testeo Datos SII en registro") AND (NOT ExcluirSII) THEN BEGIN
                            IF ChequeosObligatoriosRegistro(TipoDocumentoOrigen, "Venta-Compra", NoDocumentoOrigen, TextoErrorSII) THEN
                                ERROR(TextoErrorSII);
                            IF ChequeosConfigIVA(TipoDocumentoOrigen, "Venta-Compra", NoDocumentoOrigen, TextoErrorSII) THEN
                                ERROR(TextoErrorSII);
                        END;
                        REPEAT
                            RecDatosDocumentoDestino.RESET;
                            RecDatosDocumentoDestino.TRANSFERFIELDS(RecDatosDocumento);
                            RecDatosDocumentoDestino."Tipo documento" := RecDatosDocumentoDestino."Tipo documento"::"Srv Abono reg.";
                            RecDatosDocumentoDestino."No. Documento" := NoDocumentoDestino;
                            RecDatosDocumentoDestino.INSERT;
                        //RecDatosDocumentoDestino.DELETE;
                        UNTIL RecDatosDocumento.NEXT = 0;
                    END ELSE
                        IF (Pt_InfoEmpresa."Testeo Datos SII en registro") AND (NOT ExcluirSII) THEN
                            ERROR('El documento ' + NoDocumentoOrigen + ' no tiene informados los Datos SII necesarios.');
                END;


        END;

    end;

    /// <summary>
    /// MostrarDatosDocumento.
    /// </summary>
    /// <param name="TipoDocumento">Integer.</param>
    /// <param name="NoDocumento">Code[20].</param>
    procedure MostrarDatosDocumento(TipoDocumento: Integer; NoDocumento: Code[20])
    var
        RecSIIDatosDocumento: Record "SII- Datos documento";
        RecSIITablaMaestraValores: Record "SII- Tablas valores SII";
        FormSIIDatosDocumento: Page 50603;
    begin

        // SII
        /*
        1 Factura emitida,
        2 Abono emitido,
        3 Factura emitida reg.,
        4 Abono emitido reg.,
        5 Factura recibida,
        6 Abono recibido,
        7 Factura recibida reg.,
        8 Abono recibido reg.,
        9 BI
        10 Srv pedido,
        11 Srv Factura,
        12 Srv Abono,
        13 Srv Factura reg.,
        14 Srv Abono reg.
        */

        RecSIITablaMaestraValores.InsertarDatosDocumento(TipoDocumento, NoDocumento);
        RecSIIDatosDocumento.RESET;
        CASE TipoDocumento OF
            1:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Factura emitida");
            2:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Abono emitido");
            3:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Factura emitida reg.");
            4:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Abono emitido reg.");
            5:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Factura recibida");
            6:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Abono recibido");
            7:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Factura recibida reg.");
            8:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Abono recibido reg.");
            9:
                ;
            10:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Srv pedido");
            11:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Srv Factura");
            12:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Srv Abono");
            13:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Srv Factura reg.");
            14:
                RecSIIDatosDocumento.SETRANGE("Tipo documento", RecSIIDatosDocumento."Tipo documento"::"Srv Abono reg.");

        END;
        RecSIIDatosDocumento.SETRANGE(RecSIIDatosDocumento."No. Documento", NoDocumento);
        FormSIIDatosDocumento.SETTABLEVIEW(RecSIIDatosDocumento);
        FormSIIDatosDocumento.RUN;

    end;


    procedure ObtenerDocumentos(TipoDocumento: Integer; NoDocumento: Code[20])
    var
        RecFraVta: Record "Sales Invoice Header";
        RecAboVta: Record "Sales Cr.Memo Header";
        RecFraCompra: Record "Purch. Inv. Header";
        RecAboCompra: Record "Purch. Cr. Memo Hdr.";
        RecDatosSIIAProcesar: Record 50601;
        NoMov: Integer;
        RecDatosSIIDocumento: Record "SII- Datos documento";
        RecConfigMultipleSII: Record "SII- Config. múltiple";
        Decimal: Decimal;
        TipoDocDatoSII: Integer;
        RecFraVtaServicios: Record "Service Invoice Header";
        RecAboVtaServicios: Record "Service Cr.Memo Header";
        RecLinFraServicios: Record 5993;
        RecLinAboServicios: Record 5995;
        RecConfigContabilidad: Record 98;
        GLEntry: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        recCust: Record Customer;
        recVend: Record Vendor;
        EsDocumentoDUA: Boolean;
        RecBuscarLineas: Record 50601;
        lRec_purchInvLine: Record 123;
        lImporteTotal: Decimal;
        lImporteBaseTotal: Decimal;
        lRec_purchCRMemoLine: Record 125;
        lRec_GLAccount: Record 15;
    begin
        // SII
        // ObtenerDocumentos
        // Recoger datos del documento e insertar los registros correspondientes en tabla buffer de documentos SII a procesar.
        /*
        1 Factura emitida reg.,
        2 Abono emitido reg.,
        3 Factura recibida reg.,
        4 Abono recibido reg.,
        5 B.I.,
        6 Mov. Cont.,
        Módulo de Servicios
        13 Srv Factura reg.,
        14 Srv Abono reg.
        */

        // Registro/os de cabecera
        NoMov += 1;
        // Datos comunes
        RecDatosSIIAProcesar.RESET;
        RecDatosSIIAProcesar.INIT;
        RecDatosSIIAProcesar."Tipo registro" := RecDatosSIIAProcesar."Tipo registro"::Cabecera;
        RecDatosSIIAProcesar."No. documento" := NoDocumento;
        RecDatosSIIAProcesar."No. Línea" := NoMov;

        CASE TipoDocumento OF
            1:
                BEGIN  // Fra venta
                    RecFraVta.GET(NoDocumento);
                    RecFraVta.CALCFIELDS(RecFraVta."Amount Including VAT", RecFraVta.Amount);
                    RecDatosSIIAProcesar."Origen documento" := RecDatosSIIAProcesar."Origen documento"::Emitida;
                    RecDatosSIIAProcesar."Tipo documento" := RecDatosSIIAProcesar."Tipo documento"::Factura;
                    RecDatosSIIAProcesar."Estado documento" := RecDatosSIIAProcesar."Estado documento"::"Pendiente procesar";
                    IF CamposObligatorios(RecDatosSIIAProcesar."Tipo documento", RecDatosSIIAProcesar."Origen documento", NoDocumento,
                                          RecDatosSIIAProcesar."Log. incidencias") THEN
                        RecDatosSIIAProcesar.VALIDATE("Estado documento", RecDatosSIIAProcesar."Estado documento"::Incidencias);

                    RecDatosSIIAProcesar."Fecha de registro" := RecFraVta."Posting Date";
                    RecDatosSIIAProcesar."Tipo procedencia" := RecDatosSIIAProcesar."Tipo procedencia"::Cliente;
                    RecDatosSIIAProcesar."Cód. procedencia" := RecFraVta."Bill-to Customer No.";
                    //EX-JVN 101017
                    RecDatosSIIAProcesar."Nombre procedencia" := RecFraVta."Bill-to Name";
                    IF RecFraVta."Bill-to Name 2" <> '' THEN
                        RecDatosSIIAProcesar."Nombre procedencia" += ' ' + RecFraVta."Bill-to Name 2";
                    //101017 FIN
                    RecDatosSIIAProcesar."Importe total documento" := CurrExchRate.ExchangeAmtFCYToLCY(RecFraVta."Posting Date",
                                                                                                     RecFraVta."Currency Code",
                                                                                                     RecFraVta."Amount Including VAT",
                                                                                                     RecFraVta."Currency Factor");
                    RecDatosSIIAProcesar."CC Importe pendiente" := RecDatosSIIAProcesar."Importe total documento";
                    //EX-OMI 090817
                    RecDatosSIIAProcesar."Importe total documento" := 0;
                    RecDatosSIIAProcesar."Total Base imponible" := CurrExchRate.ExchangeAmtFCYToLCY(RecFraVta."Posting Date",
                                                                                                     RecFraVta."Currency Code",
                                                                                                     RecFraVta.Amount,
                                                                                                     RecFraVta."Currency Factor");
                    RecDatosSIIAProcesar."Fecha obtención información" := CURRENTDATETIME;
                    RecDatosSIIAProcesar."Nº serie registro" := RecFraVta."No. Series";
                    RecDatosSIIAProcesar."Fecha requerida envío control" := RecFraVta."SII Fecha envío a control";
                    RecDatosSIIAProcesar.Ejercicio := DATE2DMY(RecFraVta."Posting Date", 3);
                    RecDatosSIIAProcesar.Periodo := FORMAT(DATE2DMY(RecFraVta."Posting Date", 2));

                    //EX-SIIv3 220518
                    IF Pt_InfoEmpresa."Periodo Trimestral" THEN
                        CASE RecDatosSIIAProcesar.Periodo OF
                            '01', '02', '03':
                                RecDatosSIIAProcesar.Periodo := '1T';
                            '04', '05', '06':
                                RecDatosSIIAProcesar.Periodo := '2T';
                            '07', '08', '09':
                                RecDatosSIIAProcesar.Periodo := '3T';
                            '10', '11', '12':
                                RecDatosSIIAProcesar.Periodo := '4T';
                        END;
                    //EX-SIIv3 fin

                    // Datos contraparte
                    RecDatosSIIAProcesar."NIF Contraparte operación" := RecFraVta."VAT Registration No.";
                    RecDatosSIIAProcesar."Cód. país contraparte" := COPYSTR(RecFraVta."Bill-to Country/Region Code", 1, 2);
                    IF RecDatosSIIAProcesar."Cód. país contraparte" = '' THEN
                        RecDatosSIIAProcesar."Cód. país contraparte" := 'ES';
                    RecDatosSIIAProcesar."Clave Id. fiscal residencia" := '';

                    // Preparación por si es necesario Criterio de caja. No da error si no hay objetos de Criterio de caja
                    RecConfigMultipleSII.RESET;
                    RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Criterio caja");
                    RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Cód forma pago", RecFraVta."Payment Method Code");
                    IF RecConfigMultipleSII.FINDSET THEN;
                    RecDatosSIIAProcesar."CC Medio pago SII" := RecConfigMultipleSII."Medio pago SII";

                    RecDatosSIIAProcesar.INSERT;

                    // Líneas de detalles
                    TipoDocDatoSII := 2;
                    //ObtenerDetallesDocumentos(TipoDocumento,NoDocumento,RecDatosSIIAProcesar);
                END;
            2:
                BEGIN  // Abono venta
                    RecAboVta.GET(NoDocumento);
                    RecAboVta.CALCFIELDS(RecAboVta."Amount Including VAT", Amount);
                    RecDatosSIIAProcesar."Origen documento" := RecDatosSIIAProcesar."Origen documento"::Emitida;
                    RecDatosSIIAProcesar."Tipo documento" := RecDatosSIIAProcesar."Tipo documento"::Abono;
                    RecDatosSIIAProcesar."Estado documento" := RecDatosSIIAProcesar."Estado documento"::"Pendiente procesar";
                    IF CamposObligatorios(RecDatosSIIAProcesar."Tipo documento", RecDatosSIIAProcesar."Origen documento", NoDocumento,
                                          RecDatosSIIAProcesar."Log. incidencias") THEN
                        RecDatosSIIAProcesar.VALIDATE("Estado documento", RecDatosSIIAProcesar."Estado documento"::Incidencias);
                    RecDatosSIIAProcesar."Fecha de registro" := RecAboVta."Posting Date";
                    RecDatosSIIAProcesar."Tipo procedencia" := RecDatosSIIAProcesar."Tipo procedencia"::Cliente;
                    RecDatosSIIAProcesar."Cód. procedencia" := RecAboVta."Bill-to Customer No.";
                    //EX-SII 101017
                    RecDatosSIIAProcesar."Nombre procedencia" := RecAboVta."Bill-to Name";
                    IF RecAboVta."Bill-to Name 2" <> '' THEN
                        RecDatosSIIAProcesar."Nombre procedencia" += ' ' + RecAboVta."Bill-to Name 2";
                    //EX-SII FIN

                    RecDatosSIIAProcesar."Importe total documento" := -CurrExchRate.ExchangeAmtFCYToLCY(RecAboVta."Posting Date",
                                                                                                     RecAboVta."Currency Code",
                                                                                                     RecAboVta."Amount Including VAT",
                                                                                                     RecAboVta."Currency Factor");
                    RecDatosSIIAProcesar."CC Importe pendiente" := RecDatosSIIAProcesar."Importe total documento";
                    //EX-OMI 090817
                    RecDatosSIIAProcesar."Importe total documento" := 0;

                    RecDatosSIIAProcesar."Total Base imponible" := -CurrExchRate.ExchangeAmtFCYToLCY(RecAboVta."Posting Date",
                                                                                                     RecAboVta."Currency Code",
                                                                                                     RecAboVta.Amount,
                                                                                                     RecAboVta."Currency Factor");
                    RecDatosSIIAProcesar."Fecha obtención información" := CURRENTDATETIME;
                    RecDatosSIIAProcesar."Nº serie registro" := RecAboVta."No. Series";
                    RecDatosSIIAProcesar."Fecha requerida envío control" := RecAboVta."SII Fecha envío a control";
                    RecDatosSIIAProcesar.Ejercicio := DATE2DMY(RecAboVta."Posting Date", 3);
                    RecDatosSIIAProcesar.Periodo := FORMAT(DATE2DMY(RecAboVta."Posting Date", 2));

                    // Datos contraparte
                    RecDatosSIIAProcesar."NIF Contraparte operación" := RecAboVta."VAT Registration No.";
                    RecDatosSIIAProcesar."Cód. país contraparte" := COPYSTR(RecAboVta."Bill-to Country/Region Code", 1, 2);
                    IF RecDatosSIIAProcesar."Cód. país contraparte" = '' THEN
                        RecDatosSIIAProcesar."Cód. país contraparte" := 'ES';
                    RecDatosSIIAProcesar."Clave Id. fiscal residencia" := '';

                    // Preparación por si es necesario Criterio de caja. No da error si no hay objetos de Criterio de caja
                    RecConfigMultipleSII.RESET;
                    RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Criterio caja");
                    RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Cód forma pago", RecAboVta."Payment Method Code");
                    IF RecConfigMultipleSII.FINDSET THEN;
                    RecDatosSIIAProcesar."CC Medio pago SII" := RecConfigMultipleSII."Medio pago SII";

                    RecDatosSIIAProcesar.INSERT;
                    // Líneas de detalles
                    TipoDocDatoSII := 3;
                    //ObtenerDetallesDocumentos(TipoDocumento,NoDocumento,RecDatosSIIAProcesar);
                END;
            3:
                BEGIN  // Fra compra
                    RecFraCompra.GET(NoDocumento);
                    RecDatosSIIAProcesar."Nº Doc. proveedor" := RecFraCompra."Vendor Invoice No.";

                    RecFraCompra.CALCFIELDS(RecFraCompra."Amount Including VAT", Amount);
                    RecDatosSIIAProcesar."Origen documento" := RecDatosSIIAProcesar."Origen documento"::Recibida;
                    RecDatosSIIAProcesar."Tipo documento" := RecDatosSIIAProcesar."Tipo documento"::Factura;
                    RecDatosSIIAProcesar."Estado documento" := RecDatosSIIAProcesar."Estado documento"::"Pendiente procesar";
                    IF CamposObligatorios(RecDatosSIIAProcesar."Tipo documento", RecDatosSIIAProcesar."Origen documento", NoDocumento,
                                          RecDatosSIIAProcesar."Log. incidencias") THEN
                        RecDatosSIIAProcesar.VALIDATE("Estado documento", RecDatosSIIAProcesar."Estado documento"::Incidencias);
                    RecDatosSIIAProcesar."Fecha de registro" := RecFraCompra."Posting Date";
                    RecDatosSIIAProcesar."Tipo procedencia" := RecDatosSIIAProcesar."Tipo procedencia"::Proveedor;
                    RecDatosSIIAProcesar."Cód. procedencia" := RecFraCompra."Pay-to Vendor No.";
                    //EX-SII 101017
                    RecDatosSIIAProcesar."Nombre procedencia" := RecFraCompra."Pay-to Name";
                    IF RecFraCompra."Pay-to Name 2" <> '' THEN
                        RecDatosSIIAProcesar."Nombre procedencia" += ' ' + RecFraCompra."Pay-to Name 2";
                    //EX-SII FIN
                    //EX-RBF 041220 Inicio
                    CLEAR(lImporteTotal);
                    CLEAR(lImporteBaseTotal);
                    lRec_purchInvLine.SETRANGE("Document No.", NoDocumento);
                    //lRec_purchInvLine.SETFILTER("Gen. Prod. Posting Group",'<>%1','NOSUJETO');
                    IF lRec_purchInvLine.FINDSET() THEN
                        REPEAT
                            //EX-RBF 040121 Inicio
                            IF lRec_purchInvLine.Type = lRec_purchInvLine.Type::"G/L Account" THEN BEGIN
                                lRec_GLAccount.RESET;
                                CLEAR(lRec_GLAccount);
                                IF lRec_GLAccount.GET(lRec_purchInvLine."No.") THEN;
                                IF NOT lRec_GLAccount."Excluir SII" THEN BEGIN
                                    lImporteTotal += lRec_purchInvLine."Amount Including VAT";
                                    lImporteBaseTotal += lRec_purchInvLine.Amount;
                                END;
                            END
                            ELSE BEGIN
                                lImporteTotal += lRec_purchInvLine."Amount Including VAT";
                                lImporteBaseTotal += lRec_purchInvLine.Amount;
                            END;
                        //EX-RBF 040121 Fin
                        UNTIL lRec_purchInvLine.NEXT = 0;
                    //EX-RBF 041220 Fin
                    RecDatosSIIAProcesar."Importe total documento" := CurrExchRate.ExchangeAmtFCYToLCY(RecFraCompra."Posting Date",
                                                                                                     RecFraCompra."Currency Code",
                                                                                                     //RecFraCompra."Amount Including VAT",
                                                                                                     lImporteTotal,//EX-RBF 041220
                                                                                                     RecFraCompra."Currency Factor");

                    RecDatosSIIAProcesar."CC Importe pendiente" := RecDatosSIIAProcesar."Importe total documento";
                    RecDatosSIIAProcesar."Total Base imponible" := CurrExchRate.ExchangeAmtFCYToLCY(RecFraCompra."Posting Date",
                                                                                                     RecFraCompra."Currency Code",
                                                                                                     //RecFraCompra.Amount,
                                                                                                     lImporteBaseTotal,//EX-RBF 041220
                                                                                                     RecFraCompra."Currency Factor");

                    RecDatosSIIAProcesar."Fecha obtención información" := CURRENTDATETIME;
                    RecDatosSIIAProcesar."Nº serie registro" := RecFraCompra."No. Series";

                    // AHG 13/09/17 Se ira calculando a medida que se procesen las líneas
                    //RecDatosSIIAProcesar."Cuota deducible":=RecDatosSIIAProcesar."Importe total documento"-
                    //                                        RecDatosSIIAProcesar."Total Base imponible";
                    RecDatosSIIAProcesar."Fecha requerida envío control" := RecFraCompra."SII Fecha envío a control";
                    RecDatosSIIAProcesar.Ejercicio := DATE2DMY(RecFraCompra."Posting Date", 3);
                    RecDatosSIIAProcesar.Periodo := FORMAT(DATE2DMY(RecFraCompra."Posting Date", 2));

                    // Datos contraparte
                    RecDatosSIIAProcesar."NIF Contraparte operación" := RecFraCompra."VAT Registration No.";
                    RecDatosSIIAProcesar."Cód. país contraparte" := COPYSTR(RecFraCompra."Pay-to Country/Region Code", 1, 2);
                    IF RecDatosSIIAProcesar."Cód. país contraparte" = '' THEN
                        RecDatosSIIAProcesar."Cód. país contraparte" := 'ES';
                    RecDatosSIIAProcesar."Clave Id. fiscal residencia" := '';

                    // Preparación por si es necesario Criterio de caja. No da error si no hay objetos de Criterio de caja
                    RecConfigMultipleSII.RESET;
                    RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Criterio caja");
                    RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Cód forma pago", RecFraCompra."Payment Method Code");
                    IF RecConfigMultipleSII.FINDSET THEN;
                    RecDatosSIIAProcesar."CC Medio pago SII" := RecConfigMultipleSII."Medio pago SII";

                    RecDatosSIIAProcesar.INSERT;
                    // Líneas de detalles
                    TipoDocDatoSII := 6;
                    //ObtenerDetallesDocumentos(TipoDocumento,NoDocumento,RecDatosSIIAProcesar);

                END;
            4:
                BEGIN  // Abono compra
                    RecAboCompra.GET(NoDocumento);
                    RecDatosSIIAProcesar."Nº Doc. proveedor" := RecAboCompra."Vendor Cr. Memo No.";
                    RecAboCompra.CALCFIELDS(RecAboCompra."Amount Including VAT", Amount);
                    RecDatosSIIAProcesar."Origen documento" := RecDatosSIIAProcesar."Origen documento"::Recibida;
                    RecDatosSIIAProcesar."Tipo documento" := RecDatosSIIAProcesar."Tipo documento"::Abono;
                    RecDatosSIIAProcesar."Estado documento" := RecDatosSIIAProcesar."Estado documento"::"Pendiente procesar";
                    IF CamposObligatorios(RecDatosSIIAProcesar."Tipo documento", RecDatosSIIAProcesar."Origen documento", NoDocumento,
                                          RecDatosSIIAProcesar."Log. incidencias") THEN
                        RecDatosSIIAProcesar.VALIDATE("Estado documento", RecDatosSIIAProcesar."Estado documento"::Incidencias);
                    RecDatosSIIAProcesar."Fecha de registro" := RecAboCompra."Posting Date";
                    RecDatosSIIAProcesar."Tipo procedencia" := RecDatosSIIAProcesar."Tipo procedencia"::Proveedor;
                    RecDatosSIIAProcesar."Cód. procedencia" := RecAboCompra."Pay-to Vendor No.";
                    //EX-SII 101017
                    RecDatosSIIAProcesar."Nombre procedencia" := RecAboCompra."Pay-to Name";
                    IF RecAboCompra."Pay-to Name 2" <> '' THEN
                        RecDatosSIIAProcesar."Nombre procedencia" += ' ' + RecAboCompra."Pay-to Name 2";
                    //EX-SII FIN
                    //EX-RBF 041220 Inicio
                    CLEAR(lImporteTotal);
                    CLEAR(lImporteBaseTotal);
                    lRec_purchCRMemoLine.SETRANGE("Document No.", NoDocumento);
                    //lRec_purchCRMemoLine.SETFILTER("Gen. Prod. Posting Group",'<>%1','NOSUJETO');
                    IF lRec_purchCRMemoLine.FINDSET() THEN
                        REPEAT
                            //EX-RBF 040121 Inicio
                            IF lRec_purchCRMemoLine.Type = lRec_purchCRMemoLine.Type::"G/L Account" THEN BEGIN
                                lRec_GLAccount.RESET;
                                CLEAR(lRec_GLAccount);
                                IF lRec_GLAccount.GET(lRec_purchCRMemoLine."No.") THEN;
                                IF NOT lRec_GLAccount."Excluir SII" THEN BEGIN
                                    lImporteTotal += lRec_purchCRMemoLine."Amount Including VAT";
                                    lImporteBaseTotal += lRec_purchCRMemoLine.Amount;
                                END;
                            END
                            ELSE BEGIN
                                lImporteTotal += lRec_purchCRMemoLine."Amount Including VAT";
                                lImporteBaseTotal += lRec_purchCRMemoLine.Amount;
                            END;
                        //EX-RBF 040121 Fin
                        UNTIL lRec_purchCRMemoLine.NEXT = 0;
                    //EX-RBF 041220 Fin
                    RecDatosSIIAProcesar."Importe total documento" := -CurrExchRate.ExchangeAmtFCYToLCY(RecAboCompra."Posting Date",
                                                                                                     RecAboCompra."Currency Code",
                                                                                                     //RecAboCompra."Amount Including VAT",
                                                                                                     lImporteTotal,//EX-RBF 041220
                                                                                                     RecAboCompra."Currency Factor");

                    RecDatosSIIAProcesar."CC Importe pendiente" := RecDatosSIIAProcesar."Importe total documento";
                    RecDatosSIIAProcesar."Total Base imponible" := -CurrExchRate.ExchangeAmtFCYToLCY(RecAboCompra."Posting Date",
                                                                                                     RecAboCompra."Currency Code",
                                                                                                     //RecAboCompra.Amount,
                                                                                                     lImporteBaseTotal,//EX-RBF 041220
                                                                                                     RecAboCompra."Currency Factor");

                    RecDatosSIIAProcesar."Fecha obtención información" := CURRENTDATETIME;
                    RecDatosSIIAProcesar."Nº serie registro" := RecAboCompra."No. Series";

                    // AHG 13/09/17 Se ira calculando a medida que se procesen las líneas
                    //RecDatosSIIAProcesar."Cuota deducible":=RecDatosSIIAProcesar."Importe total documento"-
                    //                                         RecDatosSIIAProcesar."Total Base imponible";
                    RecDatosSIIAProcesar."Fecha requerida envío control" := RecAboCompra."SII Fecha envío a control";
                    RecDatosSIIAProcesar.Ejercicio := DATE2DMY(RecAboCompra."Posting Date", 3);
                    RecDatosSIIAProcesar.Periodo := FORMAT(DATE2DMY(RecAboCompra."Posting Date", 2));

                    // Datos contraparte
                    RecDatosSIIAProcesar."NIF Contraparte operación" := RecAboCompra."VAT Registration No.";
                    RecDatosSIIAProcesar."Cód. país contraparte" := COPYSTR(RecAboCompra."Pay-to Country/Region Code", 1, 2);
                    IF RecDatosSIIAProcesar."Cód. país contraparte" = '' THEN
                        RecDatosSIIAProcesar."Cód. país contraparte" := 'ES';
                    RecDatosSIIAProcesar."Clave Id. fiscal residencia" := '';

                    // Preparación por si es necesario Criterio de caja. No da error si no hay objetos de Criterio de caja
                    RecConfigMultipleSII.RESET;
                    RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Criterio caja");
                    RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Cód forma pago", RecAboCompra."Payment Method Code");
                    IF RecConfigMultipleSII.FINDSET THEN;
                    RecDatosSIIAProcesar."CC Medio pago SII" := RecConfigMultipleSII."Medio pago SII";

                    RecDatosSIIAProcesar.INSERT;
                    // Líneas de detalles
                    TipoDocDatoSII := 7;
                    //ObtenerDetallesDocumentos(TipoDocumento,NoDocumento,RecDatosSIIAProcesar);
                END;
            13:
                BEGIN  // Fra venta Servicios
                    IF RecFraVtaServicios.READPERMISSION THEN BEGIN
                        RecFraVtaServicios.GET(NoDocumento);
                        RecDatosSIIAProcesar."Origen documento" := RecDatosSIIAProcesar."Origen documento"::Emitida;
                        RecDatosSIIAProcesar."Tipo documento" := RecDatosSIIAProcesar."Tipo documento"::Factura;
                        RecDatosSIIAProcesar."Estado documento" := RecDatosSIIAProcesar."Estado documento"::"Pendiente procesar";
                        IF CamposObligatorios("Sii Tipos Documento"::"Factura servicios", RecDatosSIIAProcesar."Origen documento", NoDocumento,
                                              RecDatosSIIAProcesar."Log. incidencias") THEN
                            RecDatosSIIAProcesar.VALIDATE("Estado documento", RecDatosSIIAProcesar."Estado documento"::Incidencias);

                        RecDatosSIIAProcesar."Fecha de registro" := RecFraVtaServicios."Posting Date";
                        RecDatosSIIAProcesar."Tipo procedencia" := RecDatosSIIAProcesar."Tipo procedencia"::Cliente;
                        RecDatosSIIAProcesar."Cód. procedencia" := RecFraVtaServicios."Bill-to Customer No.";
                        //EX-SII 1010117
                        RecDatosSIIAProcesar."Nombre procedencia" := RecFraVtaServicios."Bill-to Name";
                        IF RecFraVtaServicios."Bill-to Name 2" <> '' THEN
                            RecDatosSIIAProcesar."Nombre procedencia" += ' ' + RecFraVtaServicios."Bill-to Name 2";
                        //EX-SII FIN
                        RecLinFraServicios.RESET;
                        RecLinFraServicios.SETRANGE(RecLinFraServicios."Document No.", NoDocumento);
                        IF RecLinFraServicios.FINDSET THEN
                            REPEAT
                                RecDatosSIIAProcesar."Importe total documento" += CurrExchRate.ExchangeAmtFCYToLCY(RecFraVtaServicios."Posting Date",
                                                                                                             RecFraVtaServicios."Currency Code",
                                                                                                             RecLinFraServicios."Amount Including VAT",
                                                                                                             RecFraVtaServicios."Currency Factor");

                                RecDatosSIIAProcesar."Total Base imponible" += CurrExchRate.ExchangeAmtFCYToLCY(RecFraVtaServicios."Posting Date",
                                                                                                             RecFraVtaServicios."Currency Code",
                                                                                                             RecLinFraServicios."Line Amount",
                                                                                                             RecFraVtaServicios."Currency Factor");

                            UNTIL RecLinFraServicios.NEXT = 0;
                        RecDatosSIIAProcesar."CC Importe pendiente" := RecDatosSIIAProcesar."Importe total documento";
                        //EX-OMI 090817
                        RecDatosSIIAProcesar."Importe total documento" := 0;

                        RecDatosSIIAProcesar."Fecha obtención información" := CURRENTDATETIME;
                        RecDatosSIIAProcesar."Nº serie registro" := RecFraVtaServicios."No. Series";
                        RecDatosSIIAProcesar."Fecha requerida envío control" := RecFraVtaServicios."SII Fecha envío a control";
                        RecDatosSIIAProcesar.Ejercicio := DATE2DMY(RecFraVtaServicios."Posting Date", 3);
                        RecDatosSIIAProcesar.Periodo := FORMAT(DATE2DMY(RecFraVtaServicios."Posting Date", 2));

                        // Datos contraparte
                        RecDatosSIIAProcesar."NIF Contraparte operación" := RecFraVtaServicios."VAT Registration No.";
                        RecDatosSIIAProcesar."Cód. país contraparte" := COPYSTR(RecFraVtaServicios."Bill-to Country/Region Code", 1, 2);
                        IF RecDatosSIIAProcesar."Cód. país contraparte" = '' THEN
                            RecDatosSIIAProcesar."Cód. país contraparte" := 'ES';
                        RecDatosSIIAProcesar."Clave Id. fiscal residencia" := '';

                        // Preparación por si es necesario Criterio de caja. No da error si no hay objetos de Criterio de caja
                        RecConfigMultipleSII.RESET;
                        RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Criterio caja");
                        RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Cód forma pago", RecFraVtaServicios."Payment Method Code");
                        IF RecConfigMultipleSII.FINDSET THEN;
                        RecDatosSIIAProcesar."CC Medio pago SII" := RecConfigMultipleSII."Medio pago SII";

                        RecDatosSIIAProcesar.INSERT;

                        // Líneas de detalles
                        TipoDocDatoSII := 2;
                        //ObtenerDetallesDocumentos(TipoDocumento,NoDocumento,RecDatosSIIAProcesar);
                    END;
                END;
            14:
                BEGIN  // Abo venta Servicios
                    IF RecAboVtaServicios.READPERMISSION THEN BEGIN
                        RecAboVtaServicios.GET(NoDocumento);
                        RecDatosSIIAProcesar."Origen documento" := RecDatosSIIAProcesar."Origen documento"::Emitida;
                        RecDatosSIIAProcesar."Tipo documento" := RecDatosSIIAProcesar."Tipo documento"::Abono;
                        RecDatosSIIAProcesar."Estado documento" := RecDatosSIIAProcesar."Estado documento"::"Pendiente procesar";
                        IF CamposObligatorios("Sii Tipos Documento"::"Abono Servicios", RecDatosSIIAProcesar."Origen documento", NoDocumento,
                                              RecDatosSIIAProcesar."Log. incidencias") THEN
                            RecDatosSIIAProcesar.VALIDATE("Estado documento", RecDatosSIIAProcesar."Estado documento"::Incidencias);

                        RecDatosSIIAProcesar."Fecha de registro" := RecAboVtaServicios."Posting Date";
                        RecDatosSIIAProcesar."Tipo procedencia" := RecDatosSIIAProcesar."Tipo procedencia"::Cliente;
                        RecDatosSIIAProcesar."Cód. procedencia" := RecAboVtaServicios."Bill-to Customer No.";
                        //EX-SII 101017
                        RecDatosSIIAProcesar."Nombre procedencia" := RecAboVtaServicios."Bill-to Name";
                        IF RecAboVtaServicios."Bill-to Name 2" <> '' THEN
                            RecDatosSIIAProcesar."Nombre procedencia" += ' ' + RecAboVtaServicios."Bill-to Name 2";
                        //EX-SII FIN

                        RecLinAboServicios.RESET;
                        RecLinAboServicios.SETRANGE(RecLinAboServicios."Document No.", NoDocumento);
                        IF RecLinAboServicios.FINDSET THEN
                            REPEAT
                                RecDatosSIIAProcesar."Importe total documento" -= CurrExchRate.ExchangeAmtFCYToLCY(RecAboVtaServicios."Posting Date",
                                                                                                             RecAboVtaServicios."Currency Code",
                                                                                                             RecLinAboServicios."Amount Including VAT",
                                                                                                             RecAboVtaServicios."Currency Factor");

                                RecDatosSIIAProcesar."Total Base imponible" -= CurrExchRate.ExchangeAmtFCYToLCY(RecAboVtaServicios."Posting Date",
                                                                                                             RecAboVtaServicios."Currency Code",
                                                                                                             RecLinAboServicios."Line Amount",
                                                                                                             RecAboVtaServicios."Currency Factor");
                            UNTIL RecLinAboServicios.NEXT = 0;
                        RecDatosSIIAProcesar."CC Importe pendiente" := RecDatosSIIAProcesar."Importe total documento";
                        //EX-OMI 090817
                        RecDatosSIIAProcesar."Importe total documento" := 0;

                        RecDatosSIIAProcesar."Fecha obtención información" := CURRENTDATETIME;
                        RecDatosSIIAProcesar."Nº serie registro" := RecAboVtaServicios."No. Series";
                        RecDatosSIIAProcesar."Fecha requerida envío control" := RecAboVtaServicios."SII Fecha envío a control";
                        RecDatosSIIAProcesar.Ejercicio := DATE2DMY(RecAboVtaServicios."Posting Date", 3);
                        RecDatosSIIAProcesar.Periodo := FORMAT(DATE2DMY(RecAboVtaServicios."Posting Date", 2));

                        // Datos contraparte
                        RecDatosSIIAProcesar."NIF Contraparte operación" := RecAboVtaServicios."VAT Registration No.";
                        RecDatosSIIAProcesar."Cód. país contraparte" := COPYSTR(RecAboVtaServicios."Bill-to Country/Region Code", 1, 2);
                        IF RecDatosSIIAProcesar."Cód. país contraparte" = '' THEN
                            RecDatosSIIAProcesar."Cód. país contraparte" := 'ES';
                        RecDatosSIIAProcesar."Clave Id. fiscal residencia" := '';

                        // Preparación por si es necesario Criterio de caja. No da error si no hay objetos de Criterio de caja
                        RecConfigMultipleSII.RESET;
                        RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Criterio caja");
                        RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Cód forma pago", RecAboVtaServicios."Payment Method Code");
                        IF RecConfigMultipleSII.FINDSET THEN;
                        RecDatosSIIAProcesar."CC Medio pago SII" := RecConfigMultipleSII."Medio pago SII";

                        RecDatosSIIAProcesar.INSERT;

                        // Líneas de detalles
                        TipoDocDatoSII := 2;
                        //ObtenerDetallesDocumentos(TipoDocumento,NoDocumento,RecDatosSIIAProcesar);
                    END;
                END;
            //190717 EX-JVN SII
            6:
                BEGIN
                    GLEntry.RESET;
                    GLEntry.SETRANGE("Document No.", NoDocumento);
                    GLEntry.SETFILTER("Source Type", '%1|%2', GLEntry."Source Type"::Customer, GLEntry."Source Type"::Vendor);
                    GLEntry.FINDFIRST;
                    GLEntry2.RESET;
                    GLEntry2.SETCURRENTKEY("Document Type", "Document No.", "Source Type"); //100817 EX-JVN

                    CASE GLEntry."Document Type" OF
                        GLEntry."Document Type"::Invoice:
                            RecDatosSIIAProcesar."Tipo documento" := RecDatosSIIAProcesar."Tipo documento"::Factura;
                        GLEntry."Document Type"::"Credit Memo":
                            RecDatosSIIAProcesar."Tipo documento" := RecDatosSIIAProcesar."Tipo documento"::Abono;
                    END;

                    CASE GLEntry."Source Type" OF
                        GLEntry."Source Type"::Customer:
                            BEGIN
                                RecDatosSIIAProcesar."Origen documento" := RecDatosSIIAProcesar."Origen documento"::Emitida;
                                RecDatosSIIAProcesar."Tipo procedencia" := RecDatosSIIAProcesar."Tipo procedencia"::Cliente;
                                recCust.GET(GLEntry."Source No.");
                                //EX-SII 101017
                                RecDatosSIIAProcesar."Nombre procedencia" := recCust.Name;
                                IF recCust."Name 2" <> '' THEN
                                    RecDatosSIIAProcesar."Nombre procedencia" += ' ' + recCust."Name 2";
                                //EX-SII FIN

                                GLEntry2.SETRANGE("Document Type", GLEntry2."Document Type"::Invoice);
                                GLEntry2.SETRANGE("Document No.", NoDocumento);
                                GLEntry2.SETRANGE("Source Type", GLEntry2."Source Type"::Customer); //100817 EX-JVN SII
                                GLEntry2.CALCSUMS(GLEntry2."Debit Amount", GLEntry2."VAT Amount");
                                RecDatosSIIAProcesar."Importe total documento" := GLEntry2."Debit Amount";
                                RecDatosSIIAProcesar."Total Base imponible" := GLEntry2."Debit Amount" + GLEntry2."VAT Amount";
                                // Datos contraparte
                                RecDatosSIIAProcesar."NIF Contraparte operación" := recCust."VAT Registration No.";
                                RecDatosSIIAProcesar."Cód. país contraparte" := COPYSTR(recCust."Country/Region Code", 1, 2);
                            END;
                        GLEntry."Source Type"::Vendor:
                            BEGIN
                                RecDatosSIIAProcesar."Origen documento" := RecDatosSIIAProcesar."Origen documento"::Recibida;
                                RecDatosSIIAProcesar."Tipo procedencia" := RecDatosSIIAProcesar."Tipo procedencia"::Proveedor;
                                recVend.GET(GLEntry."Source No.");
                                //EX-SII 101017
                                RecDatosSIIAProcesar."Nombre procedencia" := recVend.Name;
                                IF recVend."Name 2" <> '' THEN
                                    RecDatosSIIAProcesar."Nombre procedencia" += ' ' + recVend."Name 2";
                                //EX-SII FIN

                                RecDatosSIIAProcesar."Nº Doc. proveedor" := GLEntry."External Document No.";
                                GLEntry2.SETRANGE("Document Type", GLEntry2."Document Type"::Invoice);
                                GLEntry2.SETRANGE("Document No.", NoDocumento);
                                GLEntry2.SETRANGE("Source Type", GLEntry2."Source Type"::Vendor); //100817 EX-JVN SII
                                GLEntry2.CALCSUMS(GLEntry2."Credit Amount", GLEntry2."VAT Amount");
                                RecDatosSIIAProcesar."Importe total documento" := GLEntry2."Credit Amount";
                                RecDatosSIIAProcesar."Total Base imponible" := GLEntry2."Credit Amount" - GLEntry2."VAT Amount";
                                // Datos contraparte
                                RecDatosSIIAProcesar."NIF Contraparte operación" := recVend."VAT Registration No.";
                                RecDatosSIIAProcesar."Cód. país contraparte" := COPYSTR(recVend."Country/Region Code", 1, 2);
                            END;
                    END;

                    IF GLEntry."Document Type" = GLEntry."Document Type"::"Credit Memo" THEN BEGIN
                        RecDatosSIIAProcesar."Importe total documento" := RecDatosSIIAProcesar."Importe total documento" * -1;
                        RecDatosSIIAProcesar."Total Base imponible" := RecDatosSIIAProcesar."Total Base imponible" * -1;
                    END;

                    RecDatosSIIAProcesar."Estado documento" := RecDatosSIIAProcesar."Estado documento"::"Pendiente procesar";
                    IF CamposObligatorios(RecDatosSIIAProcesar."Tipo documento", RecDatosSIIAProcesar."Origen documento", NoDocumento,
                    RecDatosSIIAProcesar."Log. incidencias") THEN
                        RecDatosSIIAProcesar.VALIDATE("Estado documento", RecDatosSIIAProcesar."Estado documento"::Incidencias);

                    RecDatosSIIAProcesar."Fecha de registro" := GLEntry."Posting Date";
                    RecDatosSIIAProcesar."Cód. procedencia" := GLEntry."Source No.";
                    RecDatosSIIAProcesar."CC Importe pendiente" := RecDatosSIIAProcesar."Importe total documento";
                    RecDatosSIIAProcesar."Fecha obtención información" := CURRENTDATETIME;
                    RecDatosSIIAProcesar."Nº serie registro" := GLEntry."No. Series";
                    RecDatosSIIAProcesar."Fecha requerida envío control" := GLEntry."SII Fecha envío a control";
                    RecDatosSIIAProcesar.Ejercicio := DATE2DMY(GLEntry."Posting Date", 3);
                    RecDatosSIIAProcesar.Periodo := FORMAT(DATE2DMY(GLEntry."Posting Date", 2));

                    // Datos contraparte
                    IF RecDatosSIIAProcesar."Cód. país contraparte" = '' THEN
                        RecDatosSIIAProcesar."Cód. país contraparte" := 'ES';
                    RecDatosSIIAProcesar."Clave Id. fiscal residencia" := '';

                    // Preparación por si es necesario Criterio de caja. No da error si no hay objetos de Criterio de caja
                    RecConfigMultipleSII.RESET;
                    RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Criterio caja");
                    RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Cód forma pago", RecFraVta."Payment Method Code");
                    IF RecConfigMultipleSII.FINDSET THEN;
                    RecDatosSIIAProcesar."CC Medio pago SII" := RecConfigMultipleSII."Medio pago SII";

                    RecDatosSIIAProcesar.INSERT;

                    // Líneas de detalles
                    TipoDocDatoSII := 2;
                    //ObtenerDetallesDocumentos(TipoDocumento,NoDocumento,RecDatosSIIAProcesar);
                END;
        //190717 fin
        END;

        //230218 EX-JVN Nuevo campo de clave primaria
        //RecDatosSIIAProcesar.GET(RecDatosSIIAProcesar."Tipo documento",RecDatosSIIAProcesar."No. documento",
        // RecDatosSIIAProcesar."No. Línea"); //EX-SGG 130717
        RecDatosSIIAProcesar.GET(RecDatosSIIAProcesar."Tipo documento", RecDatosSIIAProcesar."No. documento",
          RecDatosSIIAProcesar."No. Línea", RecDatosSIIAProcesar."Origen documento");

        IF STRLEN(RecDatosSIIAProcesar.Periodo) = 1 THEN
            RecDatosSIIAProcesar.Periodo := '0' + RecDatosSIIAProcesar.Periodo;

        //EX-AHG 270917
        // Por defecto "Fecha operación" = "Fecha registro"
        // Si es rectificativa y llega informada la F. Operación, será cambiada más abajo.
        RecDatosSIIAProcesar."Fecha operación" := RecDatosSIIAProcesar."Fecha de registro";
        //EX-AHG FIN

        // Tratamiento Config. especiales contraparte para cualquier caso
        RecConfigMultipleSII.RESET;
        RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Cliente/Proveedor");
        RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Tipo Contraparte", RecDatosSIIAProcesar."Tipo procedencia");
        RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Cód. contraparte", RecDatosSIIAProcesar."Cód. procedencia");
        IF RecConfigMultipleSII.FINDFIRST THEN BEGIN
            IF RecConfigMultipleSII."NIF Representante contraparte" <> '' THEN
                RecDatosSIIAProcesar."NIF Representante legal" := RecConfigMultipleSII."NIF Representante contraparte";
            IF RecConfigMultipleSII."NIF/ID. fiscal contraparte" <> '' THEN
                RecDatosSIIAProcesar."NIF Contraparte operación" := RecConfigMultipleSII."NIF/ID. fiscal contraparte";
            IF RecConfigMultipleSII."Cód. país contraparte" <> '' THEN
                RecDatosSIIAProcesar."Cód. país contraparte" := RecConfigMultipleSII."Cód. país contraparte";
            IF RecConfigMultipleSII."Clave Id. fiscal contraparte" <> '' THEN
                RecDatosSIIAProcesar."Clave Id. fiscal residencia" := RecConfigMultipleSII."Clave Id. fiscal contraparte";
            IF RecConfigMultipleSII."NIF/ID. fiscal contraparte" <> '' THEN
                RecDatosSIIAProcesar."NIF/ID. fiscal país residencia" := RecConfigMultipleSII."NIF/ID. fiscal contraparte";
            RecDatosSIIAProcesar.MODIFY;
        END;
        // Datos especificos de cada documento
        RecDatosSIIDocumento.RESET;
        RecDatosSIIDocumento.SETRANGE("Tipo documento", TipoDocDatoSII);
        RecDatosSIIDocumento.SETRANGE("No. Documento", NoDocumento);
        IF RecDatosSIIDocumento.FINDFIRST THEN
            REPEAT
                IF RecDatosSIIDocumento."Valor dato SII" <> '' THEN BEGIN
                    CASE TRUE OF
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'TipoFactura':
                            BEGIN
                                RecDatosSIIAProcesar."Tipo factura" := RecDatosSIIDocumento."Valor dato SII";
                                IF RecDatosSIIAProcesar."Tipo factura" = 'F5' THEN EsDocumentoDUA := TRUE;
                            END;
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'TipoComunicacion':
                            RecDatosSIIAProcesar."Tipo comunicación" := RecDatosSIIDocumento."Valor dato SII";
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'TipoRectificativa':
                            RecDatosSIIAProcesar."Tipo factura rectificativa" := RecDatosSIIDocumento."Valor dato SII";
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'TipoOperacion':
                            RecDatosSIIAProcesar."Tipo Op. Intracomunitaria" := RecDatosSIIDocumento."Valor dato SII";
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'ClaveDeclarado':
                            RecDatosSIIAProcesar."Clave declarado" := COPYSTR(RecDatosSIIDocumento."Valor dato SII", 1,
                                                                            MAXSTRLEN(RecDatosSIIAProcesar."Clave declarado"));
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'EstadoMiembro':
                            RecDatosSIIAProcesar."Cód. estado origen/envío" := COPYSTR(RecDatosSIIDocumento."Valor dato SII", 1,
                                                                                     MAXSTRLEN(RecDatosSIIAProcesar."Cód. estado origen/envío"));
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'DescripcionBienes':
                            RecDatosSIIAProcesar."Descripción bienes" := COPYSTR(RecDatosSIIDocumento."Valor dato SII", 1,
                                                                                MAXSTRLEN(RecDatosSIIAProcesar."Descripción bienes"));
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'DireccionOperacion':
                            RecDatosSIIAProcesar."Dirección operador intracom." := COPYSTR(RecDatosSIIDocumento."Valor dato SII", 1,
                                                                                MAXSTRLEN(RecDatosSIIAProcesar."Dirección operador intracom."));
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'ClaveRegimenEspecialOTrascendencia':
                            BEGIN
                                RecDatosSIIAProcesar."Clave régimen especial" := RecDatosSIIDocumento."Valor dato SII";
                            END;

                        RecDatosSIIDocumento."Dato SII a exportar como" = 'DescripcionOperacion':
                            RecDatosSIIAProcesar."Descripción documento" := COPYSTR(RecDatosSIIDocumento."Valor dato SII", 1,
                                                                                  MAXSTRLEN(RecDatosSIIAProcesar."Descripción documento"));
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'ImporteTransmisionSujetAIVA':
                            IF EVALUATE(Decimal, RecDatosSIIDocumento."Valor dato SII") THEN
                                RecDatosSIIAProcesar."Importe transmisiones inmueble" := Decimal;
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'EmitidaPorTerceros':
                            RecDatosSIIAProcesar."Emitida por terceros" := RecDatosSIIDocumento."Valor dato SII";
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'VariosDestinatarios':
                            RecDatosSIIAProcesar."Varios destinatarios" := RecDatosSIIDocumento."Valor dato SII";
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'Cupon':
                            RecDatosSIIAProcesar."Minoración base imponible" := RecDatosSIIDocumento."Valor dato SII";
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'SituacionInmueble':
                            RecDatosSIIAProcesar."Situación Inmueble" := RecDatosSIIDocumento."Valor dato SII";
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'ReferenciaCatastral':
                            RecDatosSIIAProcesar."Ref. catastral Inmueble" := COPYSTR(RecDatosSIIDocumento."Valor dato SII", 1,
                                                                                    MAXSTRLEN(RecDatosSIIAProcesar."Ref. catastral Inmueble"));
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'NumeroFacturaEmisorResumenFin':
                            RecDatosSIIAProcesar."Factura resumen final" := RecDatosSIIDocumento."Valor dato SII";
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'INT_DuaNumero':
                            IF RecDatosSIIDocumento."Valor dato SII" <> '' THEN
                                EsDocumentoDUA := TRUE;
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'INT_NumSerieFacturaEmisorResumenInicial':
                            IF RecDatosSIIDocumento."Valor dato SII" <> '' THEN
                                RecDatosSIIAProcesar."Factura resumen inicial" := RecDatosSIIDocumento."Valor dato SII";
                        //EX-AHG 270917
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'INT_FechaOperacionRectificativa':
                            IF RecDatosSIIDocumento."Valor dato SII" <> '' THEN
                                IF EVALUATE(RecDatosSIIAProcesar."Fecha operación", RecDatosSIIDocumento."Valor dato SII") THEN;
                        //EX-SHG FIN

                        //EX-SIIv3 070618
                        RecDatosSIIDocumento."Dato SII a exportar como" = 'FacturaSimplicadaArticulos7.2_7.3':
                            IF (RecDatosSIIAProcesar."Tipo factura" = 'F5') OR (RecDatosSIIAProcesar."Tipo factura" = 'F3') OR
                               (RecDatosSIIAProcesar."Tipo factura" = 'R1') OR (RecDatosSIIAProcesar."Tipo factura" = 'R2') OR
                               (RecDatosSIIAProcesar."Tipo factura" = 'R3') OR (RecDatosSIIAProcesar."Tipo factura" = 'R4') THEN
                                RecDatosSIIAProcesar.FacturaSimplificadaArticulos := 'S'
                            ELSE
                                RecDatosSIIAProcesar.FacturaSimplificadaArticulos := 'N';
                    //EX-SIIv3 fin

                    END;
                END;
            UNTIL RecDatosSIIDocumento.NEXT = 0;

        // Tratamiento DUA
        // Datos SII DUA

        IF EsDocumentoDUA THEN // Se detectó que se trata de DUA por ser "Tipo factura" =F5 y/o Tener "Nº DUA" informado.
        BEGIN
            RecDatosSIIDocumento.RESET;
            RecDatosSIIDocumento.SETRANGE("Tipo documento", TipoDocDatoSII);
            RecDatosSIIDocumento.SETRANGE("No. Documento", NoDocumento);
            IF RecDatosSIIDocumento.FINDSET THEN
                REPEAT
                    IF RecDatosSIIDocumento."Valor dato SII" <> '' THEN BEGIN
                        CASE TRUE OF
                            RecDatosSIIDocumento."Dato SII a exportar como" = 'INT_DuaNumero':
                                IF RecDatosSIIAProcesar."Tipo factura" = 'F5' THEN BEGIN
                                    Pt_InfoEmpresa.GET;
                                    RecDatosSIIAProcesar."Nombre procedencia" := COPYSTR(Pt_InfoEmpresa."Apell. Nombre.- Razón social", 1, 100);
                                    RecDatosSIIAProcesar."Tipo DUA" := RecDatosSIIAProcesar."Tipo DUA"::Transitario;  // Detectado  DUA total del transitario.
                                    RecDatosSIIAProcesar."NIF Contraparte operación" := Pt_InfoEmpresa."NIF Declarante";
                                    RecDatosSIIAProcesar."Tipo procedencia" := RecDatosSIIAProcesar."Tipo procedencia"::DUA;
                                END ELSE BEGIN
                                    RecDatosSIIAProcesar."Tipo DUA" := RecDatosSIIAProcesar."Tipo DUA"::Proveedor;  // Detectado  DUA en factura del proveedor
                                    RecDatosSIIAProcesar."No Doc. DUA" := COPYSTR(RecDatosSIIDocumento."Valor dato SII", 1, 20);
                                END;
                            RecDatosSIIDocumento."Dato SII a exportar como" = 'INT_DuaBase':
                                IF RecDatosSIIAProcesar."Tipo factura" = 'F5' THEN BEGIN
                                    IF EVALUATE(Decimal, RecDatosSIIDocumento."Valor dato SII") THEN BEGIN
                                        IF TipoDocumento = 4 THEN
                                            Decimal := Decimal * -1;
                                        RecDatosSIIAProcesar."Total Base imponible" := Decimal;
                                        RecDatosSIIAProcesar."Cuota deducible" := Decimal;
                                    END;
                                END;
                            RecDatosSIIDocumento."Dato SII a exportar como" = 'INT_DuaFechaExpedicion':
                                IF RecDatosSIIAProcesar."Tipo factura" = 'F5' THEN BEGIN
                                    IF EVALUATE(RecDatosSIIAProcesar."Fecha de registro", RecDatosSIIDocumento."Valor dato SII") THEN;
                                END ELSE
                                    IF EVALUATE(RecDatosSIIAProcesar."Fecha exp. DUA", RecDatosSIIDocumento."Valor dato SII") THEN;
                            RecDatosSIIDocumento."Dato SII a exportar como" = 'INT_DuaPais':
                                IF RecDatosSIIAProcesar."Tipo factura" = 'F5' THEN BEGIN
                                    RecDatosSIIAProcesar."Cód. país contraparte" := RecDatosSIIDocumento."Valor dato SII";
                                END;
                        END;
                    END;
                UNTIL RecDatosSIIDocumento.NEXT = 0;
            // Tratamiento DUA - FIN
        END;

        // Redondeos generales
        RecConfigContabilidad.GET;
        RecDatosSIIAProcesar."Importe total documento" := ROUND(RecDatosSIIAProcesar."Importe total documento",
                                                              RecConfigContabilidad."Inv. Rounding Precision (LCY)");
        RecDatosSIIAProcesar."Total Base imponible" := ROUND(RecDatosSIIAProcesar."Total Base imponible",
                                                              RecConfigContabilidad."Inv. Rounding Precision (LCY)");
        RecDatosSIIAProcesar."Cuota deducible" := ROUND(RecDatosSIIAProcesar."Cuota deducible",
                                                              RecConfigContabilidad."Inv. Rounding Precision (LCY)");
        RecDatosSIIAProcesar.MODIFY;

        // Una vez completados los datos de cabecera, pasar a generar detalles de líneas.
        ObtenerDetallesDocumentos(TipoDocumento, NoDocumento, RecDatosSIIAProcesar);

        IF RecDatosSIIAProcesar."Estado documento" = RecDatosSIIAProcesar."Estado documento"::Incidencias THEN BEGIN
            RecBuscarLineas.RESET;
            RecBuscarLineas.SETCURRENTKEY("No. documento", "Tipo documento", "Tipo registro", "Estado documento");
            RecBuscarLineas.SETRANGE("No. documento", RecDatosSIIAProcesar."No. documento");
            RecBuscarLineas.SETRANGE("Tipo documento", RecDatosSIIAProcesar."Tipo documento");
            RecBuscarLineas.SETRANGE("Tipo registro", RecBuscarLineas."Tipo registro"::Detalles);
            RecBuscarLineas.SETRANGE("Origen documento", RecDatosSIIAProcesar."Origen documento"); //260218 EX-JVN
            IF RecBuscarLineas.FINDSET THEN
                RecBuscarLineas.MODIFYALL("Estado documento", RecBuscarLineas."Estado documento"::Incidencias);
        END ELSE BEGIN
            //EX-SMN 151117
            RecBuscarLineas.RESET;
            RecBuscarLineas.SETRANGE("No. documento", RecDatosSIIAProcesar."No. documento");
            RecBuscarLineas.SETRANGE("Tipo documento", RecDatosSIIAProcesar."Tipo documento");
            RecBuscarLineas.SETRANGE("Tipo registro", RecBuscarLineas."Tipo registro"::Detalles);
            RecBuscarLineas.SETRANGE("Origen documento", RecDatosSIIAProcesar."Origen documento");
            RecBuscarLineas.SETRANGE("Tipo procedencia", RecDatosSIIAProcesar."Tipo procedencia");
            RecBuscarLineas.SETRANGE("Estado documento", RecBuscarLineas."Estado documento"::Incidencias);
            IF RecBuscarLineas.FINDFIRST THEN BEGIN
                RecDatosSIIAProcesar."Estado documento" := RecBuscarLineas."Estado documento"::Incidencias;
                RecDatosSIIAProcesar."Log. incidencias" := 'Incidencia en línea de detalle del documento.';
                RecDatosSIIAProcesar.MODIFY;
            END;
            //EX-SMN 151117 FIN
        END;

        //EX-OMI 170817
        // Tratamiento Criterio de Caja
        IF EsCriterioCaja THEN BEGIN
            RecDatosSIIAProcesar."Régimen Criterio de caja" := TRUE;
        END ELSE
            RecDatosSIIAProcesar."CC Importe pendiente" := 0;
        //EX-OMI:fin

        // Vuelve a redondear por si ha habido cambios producidos por los detalles.
        RecConfigContabilidad.GET;
        RecDatosSIIAProcesar."Importe total documento" := ROUND(RecDatosSIIAProcesar."Importe total documento",
                                                              RecConfigContabilidad."Inv. Rounding Precision (LCY)");
        RecDatosSIIAProcesar."Total Base imponible" := ROUND(RecDatosSIIAProcesar."Total Base imponible",
                                                              RecConfigContabilidad."Inv. Rounding Precision (LCY)");
        RecDatosSIIAProcesar."Cuota deducible" := ROUND(RecDatosSIIAProcesar."Cuota deducible",
                                                              RecConfigContabilidad."Inv. Rounding Precision (LCY)");
        RecDatosSIIAProcesar.MODIFY;


        IF RecDatosSIIAProcesar."Tipo DUA" = RecDatosSIIAProcesar."Tipo DUA"::Proveedor THEN
        // Crear Documento SII con las líneas de IVA marcadas como "DUA"
        BEGIN
            CASE TipoDocumento OF
                3: // Fra compra
                    CrearDocumentoSII_DUA(RecDatosSIIAProcesar, RecFraCompra."Currency Code", RecFraCompra."Currency Factor");
                4: // Abono compra
                    CrearDocumentoSII_DUA(RecDatosSIIAProcesar, RecAboCompra."Currency Code", RecAboCompra."Currency Factor");
            END;
        END;

    end;


    procedure ObtenerDetallesDocumentos(TipoDocumento: Integer; NoDocumento: Code[20]; var RecCabeceraDatosSII: Record 50601)
    var
        RecDatosSIIAProcesarDet: Record 50601;
        NoMov: Integer;
        RecLinFraVta: Record 113;
        RecLinAboVta: Record 115;
        RecLInFraCompra: Record 123;
        RecLinAboCompra: Record 125;
        RecConfigMultiple: Record "SII- Config. múltiple";
        RecLinFraVtaServicios: Record 5993;
        RecLinAboVtaServicios: Record 5995;
        "-----": Integer;
        RecFraVta: Record 112;
        RecAboVta: Record 114;
        RecFraCompra: Record 122;
        RecAboCompra: Record 124;
        RecFraVtaServicios: Record 5992;
        RecAboVtaServicios: Record 5994;
        Currency: Record 4;
        RecConfigCont: Record 98;
        PrecisionRedondeo: Decimal;
        TipoRedondeo: Text[1];
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        lRstConfIVA: Record 325;
        lpVat: Decimal;
        lpRE: Decimal;
        limportevatre: Decimal;
        saltarcondicion: Boolean;
    begin


        /*
        1 Factura emitida reg.,
        2 Abono emitido reg.,
        3 Factura recibida reg.,
        4 Abono recibido reg.,
        5 BI
        6 Mov. Cont.
        13 Srv Factra reg.,
        14 Srv Abono reg.
        */

        // Registro/os de detalle
        NoMov := 1;
        EsCriterioCaja := FALSE;
        CASE TipoDocumento OF
            1:
                BEGIN  // Fra. venta
                    RecFraVta.GET(NoDocumento);
                    RecFraVta.CALCFIELDS(RecFraVta.Amount, RecFraVta."Amount Including VAT");
                    IF Currency.GET(RecFraVta."Currency Code") THEN BEGIN
                        PrecisionRedondeo := Currency."Amount Rounding Precision";
                        TipoRedondeo := Currency.VATRoundingDirection;
                    END;
                    RecLinFraVta.SETRANGE(RecLinFraVta."Document No.", NoDocumento);
                    IF RecLinFraVta.FINDFIRST THEN
                        REPEAT
                            //IF (RecLinFraVta.Quantity<>0) AND (RecLinFraVta."Unit Price"<>0) THEN   // Solo si la línea lleva cantidad y precio/u
                            IF RecLinFraVta.Quantity <> 0 THEN // Solo si la línea lleva cantidad
                            BEGIN
                                IF NOT ExcluirLinea(RecLinFraVta.Type, RecLinFraVta."No.") THEN BEGIN
                                    NoMov += 1;
                                    RecDatosSIIAProcesarDet.RESET;
                                    RecDatosSIIAProcesarDet.INIT;
                                    RecDatosSIIAProcesarDet."Tipo registro" := RecDatosSIIAProcesarDet."Tipo registro"::Detalles;
                                    RecDatosSIIAProcesarDet."Tipo documento" := RecDatosSIIAProcesarDet."Tipo documento"::Factura;
                                    RecDatosSIIAProcesarDet."Origen documento" := RecDatosSIIAProcesarDet."Origen documento"::Emitida;
                                    RecDatosSIIAProcesarDet."Tipo procedencia" := RecDatosSIIAProcesarDet."Tipo procedencia"::Cliente;
                                    RecDatosSIIAProcesarDet."No. documento" := NoDocumento;
                                    RecDatosSIIAProcesarDet."No. Línea" := NoMov;
                                    RecDatosSIIAProcesarDet."Estado documento" := RecCabeceraDatosSII."Estado documento";

                                    // Datos para desglose por tipo operación (Servicio, Entrega)
                                    RecConfigMultiple.RESET;
                                    RecConfigMultiple.SETRANGE("Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo operación");
                                    RecConfigMultiple.SETRANGE("Gr. Contable producto", RecLinFraVta."Gen. Prod. Posting Group");
                                    IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                        RecDatosSIIAProcesarDet."Desglose tipo operación" := RecConfigMultiple."Tipo operación";
                                        // Datos para desglose por tipo cálculo de IVA (Sujeto-Exento,Sujeto-NoExento,No sujeto...)
                                        RecConfigMultiple.RESET;
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo IVA");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Negocio", RecLinFraVta."VAT Bus. Posting Group");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Producto", RecLinFraVta."VAT Prod. Posting Group");
                                        IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                            RecDatosSIIAProcesarDet."Inv. Sujeto Pasivo" := RecConfigMultiple."Inversión sujeto pasivo";
                                            RecDatosSIIAProcesarDet.DesgloseIVAFactura := RecConfigMultiple."Tipo desglose IVA";
                                            RecDatosSIIAProcesarDet.Sujeta := NOT ((RecConfigMultiple."Tipo cálculo IVA" =
                                                                            RecConfigMultiple."Tipo cálculo IVA"::"No Taxable VAT") OR
                                                                            (RecConfigMultiple."Tipo No sujeta" <> RecConfigMultiple."Tipo No sujeta"::" "));
                                            IF RecDatosSIIAProcesarDet.Sujeta THEN BEGIN
                                                // Exenta
                                                RecDatosSIIAProcesarDet.Exenta := RecConfigMultiple.Exento;
                                                IF RecDatosSIIAProcesarDet.Exenta THEN BEGIN
                                                    RecDatosSIIAProcesarDet."Cód. causa exención" := RecConfigMultiple."Causa exención";
                                                    RecDatosSIIAProcesarDet."Base Imponible exenta" := CurrExchRate.ExchangeAmtFCYToLCY(RecFraVta."Posting Date",
                                                                                                                           RecFraVta."Currency Code",
                                                                                                                           RecLinFraVta.Amount,
                                                                                                                           RecFraVta."Currency Factor");

                                                END;
                                                // No Exenta
                                                IF NOT RecDatosSIIAProcesarDet.Exenta THEN BEGIN
                                                    RecDatosSIIAProcesarDet."Tipo no exenta" := RecConfigMultiple."Tipo No Exención";
                                                    RecDatosSIIAProcesarDet."Tipo impositivo no exenta" := RecLinFraVta."VAT %";
                                                    RecDatosSIIAProcesarDet."Base imponible no exenta" := CurrExchRate.ExchangeAmtFCYToLCY(RecFraVta."Posting Date",
                                                                                                                           RecFraVta."Currency Code",
                                                                                                                           RecLinFraVta.Amount,
                                                                                                                           RecFraVta."Currency Factor");
                                                    IF RecLinFraVta."VAT %" + RecLinFraVta."EC %" <> 0 THEN
                                                        RecDatosSIIAProcesarDet."Cuota imp. no exenta" :=
                                                          CurrExchRate.ExchangeAmtFCYToLCY(RecFraVta."Posting Date",
                                                                                           RecFraVta."Currency Code",
                                                                                           (RecLinFraVta."Amount Including VAT" - RecLinFraVta.Amount) /
                                                                                           (RecLinFraVta."VAT %" + RecLinFraVta."EC %") * RecLinFraVta."VAT %",
                                                                                           RecFraVta."Currency Factor");

                                                    RecDatosSIIAProcesarDet."Tipo RE no exenta" := RecLinFraVta."EC %";

                                                    IF RecDatosSIIAProcesarDet."Tipo RE no exenta" <> 0 THEN
                                                        IF RecLinFraVta."VAT %" + RecLinFraVta."EC %" <> 0 THEN
                                                            RecDatosSIIAProcesarDet."Cuota RE no exenta" :=
                                                             CurrExchRate.ExchangeAmtFCYToLCY(RecFraVta."Posting Date",
                                                                                         RecFraVta."Currency Code",
                                                                                         (RecLinFraVta."Amount Including VAT" - RecLinFraVta.Amount) /
                                                                                         (RecLinFraVta."VAT %" + RecLinFraVta."EC %") * RecLinFraVta."EC %",
                                                                                          RecFraVta."Currency Factor");
                                                END;
                                                // Imp. Total Documento según exento o no exento
                                                RecCabeceraDatosSII."Importe total documento" += CurrExchRate.ExchangeAmtFCYToLCY(RecFraVta."Posting Date",
                                                                                                                                RecFraVta."Currency Code",
                                                                                                                                RecLinFraVta."Amount Including VAT",
                                                                                                                                RecFraVta."Currency Factor");
                                                // Fin Imp Total Documento

                                            END ELSE BEGIN
                                                // No sujeta
                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Articulos 7-14-Otros" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecFraVta."Posting Date",
                                                                                                                                RecFraVta."Currency Code",
                                                                                                                                RecLinFraVta."Amount Including VAT",
                                                                                                                                RecFraVta."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecFraVta."Posting Date",
                                                                                                                                RecFraVta."Currency Code",
                                                                                                                                RecLinFraVta.Amount,
                                                                                                                                RecFraVta."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecFraVta."Posting Date",
                                                                                                                                RecFraVta."Currency Code",
                                                                                                                                RecLinFraVta."Amount Including VAT",
                                                                                                                                RecFraVta."Currency Factor");
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecFraVta."Posting Date",
                                                                                                                                RecFraVta."Currency Code",
                                                                                                                                RecLinFraVta."Amount Including VAT" -
                                                                                                                                RecLinFraVta.Amount,
                                                                                                                                RecFraVta."Currency Factor");
                                                    END;
                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Reg. Localización" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                RecFraVta."Posting Date",
                                                                                                                                RecFraVta."Currency Code",
                                                                                                                                RecLinFraVta."Amount Including VAT",
                                                                                                                                RecFraVta."Currency Factor");


                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                RecFraVta."Posting Date",
                                                                                                                                RecFraVta."Currency Code",
                                                                                                                                RecLinFraVta.Amount,
                                                                                                                                RecFraVta."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                RecFraVta."Posting Date",
                                                                                                                                RecFraVta."Currency Code",
                                                                                                                                RecLinFraVta."Amount Including VAT",
                                                                                                                                RecFraVta."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                RecFraVta."Posting Date",
                                                                                                                                RecFraVta."Currency Code",
                                                                                                                                RecLinFraVta."Amount Including VAT" -
                                                                                                                                RecLinFraVta.Amount,
                                                                                                                                RecFraVta."Currency Factor");
                                                    END;
                                                // Imp. Total Documento según Sujeto o no sujeto
                                                IF RecConfigMultiple."Tipo No sujeta" <> RecConfigMultiple."Tipo No sujeta"::" " THEN
                                                    IF RecDatosSIIAProcesarDet."Importe no sujeta localización" <> 0 THEN
                                                        RecCabeceraDatosSII."Importe total documento" += RecDatosSIIAProcesarDet."Importe no sujeta localización"
                                                    ELSE
                                                        RecCabeceraDatosSII."Importe total documento" += RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14";

                                                // Fin Imp Total Documento

                                                RecDatosSIIAProcesarDet."Base imponible no sujeta" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                      RecFraVta."Posting Date",
                                                                                                                      RecFraVta."Currency Code",
                                                                                                                      RecLinFraVta.Amount,
                                                                                                                      RecFraVta."Currency Factor");
                                                RecDatosSIIAProcesarDet."Tipo No sujeta" := RecConfigMultiple."Tipo No sujeta";
                                            END;

                                            // Diferencias IVA/RE a usar en cálculo de cuotas en la agrupación de impuestos.
                                            RecDatosSIIAProcesarDet."IVA Diferencia" := RecLinFraVta."VAT Difference";
                                            RecDatosSIIAProcesarDet."RE Diferencia" := RecLinFraVta."EC Difference";

                                            // Tratamiento de Criterio de caja
                                            IF RecConfigMultiple."Régimen Criterio de caja" THEN
                                                EsCriterioCaja := TRUE;

                                            // Tratamiento especial para IVA Total
                                            IF RecConfigMultiple."Tipo cálculo IVA" = RecConfigMultiple."Tipo cálculo IVA"::"Full VAT" THEN BEGIN
                                                RecDatosSIIAProcesarDet."Cuota imp. no exenta" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                 RecFraVta."Posting Date",
                                                                                                 RecFraVta."Currency Code",
                                                                                                 RecLinFraVta."Amount Including VAT",
                                                                                                 RecFraVta."Currency Factor");
                                            END;
                                            // Fin - Tratamiento especial para IVA Total

                                        END ELSE BEGIN
                                            RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                            RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de IVA SII : ' +
                                                         RecLinFraVta."VAT Bus. Posting Group" + '-' + RecLinFraVta."VAT Prod. Posting Group" + ' inexistente.';
                                        END;
                                    END ELSE BEGIN
                                        RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                        RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de Operación SII : ' +
                                          RecLinFraVta."Gen. Prod. Posting Group" + ' inexistente.';
                                    END;
                                    RecDatosSIIAProcesarDet."Fecha obtención información" := CURRENTDATETIME;
                                    RecDatosSIIAProcesarDet.INSERT;
                                END;
                            END;
                        UNTIL RecLinFraVta.NEXT = 0;

                    //EX-SIIv3 220518
                    IF ((RecConfigMultiple."Tipo factura emitida" = 'F2') OR
                        (RecConfigMultiple."Tipo factura emitida" = 'F4') OR //EX-SIIv3 070618
                        (RecConfigMultiple."Tipo factura emitida" = 'F5')) //EX-SIIv3 070618
                        AND (RecCabeceraDatosSII."NIF Representante legal" <> '') THEN
                        RecCabeceraDatosSII."Factura SinIdentifDestinatario" := 'S';
                    //EX-SIIv3 fin

                END;
            2:
                BEGIN   // Abono venta
                    RecAboVta.GET(NoDocumento);
                    RecAboVta.CALCFIELDS(Amount, "Amount Including VAT");
                    IF Currency.GET(RecAboVta."Currency Code") THEN BEGIN
                        PrecisionRedondeo := Currency."Amount Rounding Precision";
                        TipoRedondeo := Currency.VATRoundingDirection;
                    END;
                    RecLinAboVta.SETRANGE(RecLinAboVta."Document No.", NoDocumento);
                    IF RecLinAboVta.FINDFIRST THEN
                        REPEAT
                            //EX-OMI 301017
                            IF RecLinAboVta.Quantity <> 0 THEN BEGIN // Solo si la línea lleva cantidad
                                                                     //IF (RecLinAboVta.Quantity<>0) AND (RecLinAboVta."Unit Price"<>0) THEN
                                IF NOT ExcluirLinea(RecLinAboVta.Type, RecLinAboVta."No.") THEN BEGIN
                                    NoMov += 1;
                                    RecDatosSIIAProcesarDet.RESET;
                                    RecDatosSIIAProcesarDet.INIT;
                                    RecDatosSIIAProcesarDet."Tipo registro" := RecDatosSIIAProcesarDet."Tipo registro"::Detalles;
                                    RecDatosSIIAProcesarDet."Tipo documento" := RecDatosSIIAProcesarDet."Tipo documento"::Abono;
                                    RecDatosSIIAProcesarDet."Origen documento" := RecDatosSIIAProcesarDet."Origen documento"::Emitida;
                                    RecDatosSIIAProcesarDet."Tipo procedencia" := RecDatosSIIAProcesarDet."Tipo procedencia"::Cliente;
                                    RecDatosSIIAProcesarDet."No. documento" := NoDocumento;
                                    RecDatosSIIAProcesarDet."No. Línea" := NoMov;
                                    RecDatosSIIAProcesarDet."Estado documento" := RecCabeceraDatosSII."Estado documento";

                                    // Datos para desglose por tipo operación (Servicio, Entrega)
                                    RecConfigMultiple.RESET;
                                    RecConfigMultiple.SETRANGE("Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo operación");
                                    RecConfigMultiple.SETRANGE("Gr. Contable producto", RecLinAboVta."Gen. Prod. Posting Group");
                                    IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                        RecDatosSIIAProcesarDet."Desglose tipo operación" := RecConfigMultiple."Tipo operación";
                                        // Datos para desglose por tipo cálculo de IVA (Sujeto, Exento, No sujeto...)
                                        RecConfigMultiple.RESET;
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo IVA");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Negocio", RecLinAboVta."VAT Bus. Posting Group");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Producto", RecLinAboVta."VAT Prod. Posting Group");
                                        IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                            RecDatosSIIAProcesarDet."Inv. Sujeto Pasivo" := RecConfigMultiple."Inversión sujeto pasivo";
                                            RecDatosSIIAProcesarDet.DesgloseIVAFactura := RecConfigMultiple."Tipo desglose IVA";
                                            RecDatosSIIAProcesarDet.Sujeta := NOT ((RecConfigMultiple."Tipo cálculo IVA" =
                                                                            RecConfigMultiple."Tipo cálculo IVA"::"No Taxable VAT") OR
                                                                            (RecConfigMultiple."Tipo No sujeta" <> RecConfigMultiple."Tipo No sujeta"::" "));

                                            IF RecDatosSIIAProcesarDet.Sujeta THEN BEGIN
                                                // Exenta
                                                RecDatosSIIAProcesarDet.Exenta := RecConfigMultiple.Exento;
                                                IF RecDatosSIIAProcesarDet.Exenta THEN BEGIN
                                                    RecDatosSIIAProcesarDet."Cód. causa exención" := RecConfigMultiple."Causa exención";
                                                    RecDatosSIIAProcesarDet."Base Imponible exenta" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboVta."Posting Date",
                                                                                                                           RecAboVta."Currency Code",
                                                                                                                           RecLinAboVta.Amount,
                                                                                                                           RecAboVta."Currency Factor");
                                                END;
                                                // No Exenta
                                                IF NOT RecDatosSIIAProcesarDet.Exenta THEN BEGIN
                                                    RecDatosSIIAProcesarDet."Tipo no exenta" := RecConfigMultiple."Tipo No Exención";
                                                    RecDatosSIIAProcesarDet."Tipo impositivo no exenta" := RecLinAboVta."VAT %";

                                                    RecDatosSIIAProcesarDet."Base imponible no exenta" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboVta."Posting Date",
                                                                                                                           RecAboVta."Currency Code",
                                                                                                                           RecLinAboVta.Amount,
                                                                                                                           RecAboVta."Currency Factor");
                                                    IF RecLinAboVta."VAT %" + RecLinFraVta."EC %" <> 0 THEN
                                                        RecDatosSIIAProcesarDet."Cuota imp. no exenta" :=
                                                        CurrExchRate.ExchangeAmtFCYToLCY(RecAboVta."Posting Date",
                                                                                         RecAboVta."Currency Code",
                                                                                         (RecLinAboVta."Amount Including VAT" - RecLinAboVta.Amount) /
                                                                                         (RecLinAboVta."VAT %" + RecLinAboVta."EC %") * RecLinAboVta."VAT %",
                                                                                          RecAboVta."Currency Factor") * -1;

                                                    RecDatosSIIAProcesarDet."Tipo RE no exenta" := RecLinAboVta."EC %";
                                                    IF RecDatosSIIAProcesarDet."Tipo RE no exenta" <> 0 THEN
                                                        IF RecLinAboVta."VAT %" + RecLinAboVta."EC %" <> 0 THEN
                                                            RecDatosSIIAProcesarDet."Cuota RE no exenta" :=
                                                            CurrExchRate.ExchangeAmtFCYToLCY(RecAboVta."Posting Date",
                                                                                             RecAboVta."Currency Code",
                                                                                             (RecLinAboVta."Amount Including VAT" - RecLinAboVta.Amount) /
                                                                                             (RecLinAboVta."VAT %" + RecLinAboVta."EC %") * RecLinAboVta."EC %",
                                                                                              RecAboVta."Currency Factor") * -1;

                                                END;
                                                // Imp. Total Documento según exento o no exento
                                                RecCabeceraDatosSII."Importe total documento" += CurrExchRate.ExchangeAmtFCYToLCY(RecAboVta."Posting Date",
                                                                                                                                RecAboVta."Currency Code",
                                                                                                                               -RecLinAboVta."Amount Including VAT",
                                                                                                                                RecAboVta."Currency Factor");


                                                // Fin Imp Total Documento

                                            END ELSE BEGIN
                                                // No sujeta
                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Articulos 7-14-Otros" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecAboVta."Posting Date",
                                                                                                                                RecAboVta."Currency Code",
                                                                                                                                RecLinAboVta."Amount Including VAT",
                                                                                                                                RecAboVta."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecAboVta."Posting Date",
                                                                                                                                RecAboVta."Currency Code",
                                                                                                                                RecLinAboVta.Amount,
                                                                                                                                RecAboVta."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecAboVta."Posting Date",
                                                                                                                                RecAboVta."Currency Code",
                                                                                                                                RecLinAboVta."Amount Including VAT",
                                                                                                                                RecAboVta."Currency Factor");
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecAboVta."Posting Date",
                                                                                                                                RecAboVta."Currency Code",
                                                                                                                                RecLinAboVta."Amount Including VAT" -
                                                                                                                                RecLinAboVta.Amount,
                                                                                                                                RecAboVta."Currency Factor");
                                                    END;
                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Reg. Localización" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecAboVta."Posting Date",
                                                                                                                                RecAboVta."Currency Code",
                                                                                                                                RecLinAboVta."Amount Including VAT",
                                                                                                                                RecAboVta."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecAboVta."Posting Date",
                                                                                                                                RecAboVta."Currency Code",
                                                                                                                                RecLinAboVta.Amount,
                                                                                                                                RecAboVta."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecAboVta."Posting Date",
                                                                                                                                RecAboVta."Currency Code",
                                                                                                                                RecLinAboVta."Amount Including VAT",
                                                                                                                                RecAboVta."Currency Factor");
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecAboVta."Posting Date",
                                                                                                                                RecAboVta."Currency Code",
                                                                                                                                RecLinAboVta."Amount Including VAT" -
                                                                                                                                RecLinAboVta.Amount,
                                                                                                                                RecAboVta."Currency Factor");
                                                    END;

                                                // Imp. Total Documento según Sujeto o no sujeto
                                                IF RecConfigMultiple."Tipo No sujeta" <> RecConfigMultiple."Tipo No sujeta"::" " THEN
                                                    IF RecDatosSIIAProcesarDet."Importe no sujeta localización" <> 0 THEN
                                                        RecCabeceraDatosSII."Importe total documento" += (RecDatosSIIAProcesarDet."Importe no sujeta localización")
                                                    ELSE
                                                        RecCabeceraDatosSII."Importe total documento" += (RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14");

                                                // Fin Imp Total Documento

                                                RecDatosSIIAProcesarDet."Base imponible no sujeta" := -CurrExchRate.ExchangeAmtFCYToLCY(RecAboVta."Posting Date",
                                                                                                                         RecAboVta."Currency Code",
                                                                                                                         RecLinAboVta.Amount,
                                                                                                                         RecAboVta."Currency Factor");
                                                RecDatosSIIAProcesarDet."Tipo No sujeta" := RecConfigMultiple."Tipo No sujeta";
                                            END;

                                            // Diferencias IVA/RE a usar en cálculo de cuotas en la agrupación de impuestos.
                                            RecDatosSIIAProcesarDet."IVA Diferencia" := RecLinAboVta."VAT Difference";
                                            RecDatosSIIAProcesarDet."RE Diferencia" := RecLinAboVta."EC Difference";

                                            // Tratamiento de Criterio de caja
                                            IF RecConfigMultiple."Régimen Criterio de caja" THEN
                                                EsCriterioCaja := TRUE;

                                            // Tratamiento especial para IVA Total
                                            IF RecConfigMultiple."Tipo cálculo IVA" = RecConfigMultiple."Tipo cálculo IVA"::"Full VAT" THEN BEGIN
                                                RecDatosSIIAProcesarDet."Cuota imp. no exenta" :=
                                                           CurrExchRate.ExchangeAmtFCYToLCY(
                                                           RecAboVta."Posting Date",
                                                           RecAboVta."Currency Code",
                                                           RecLinAboVta."Amount Including VAT",
                                                           RecAboVta."Currency Factor") * -1;
                                            END;
                                            // Fin - Tratamiento especial para IVA Total

                                        END ELSE BEGIN
                                            RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                            RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de IVA SII : ' +
                                                         RecLinAboVta."VAT Bus. Posting Group" + '-' + RecLinAboVta."VAT Prod. Posting Group" + ' inexistente.';
                                        END;

                                    END ELSE BEGIN
                                        RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                        RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de Operación SII : ' +
                                          RecLinAboVta."Gen. Prod. Posting Group" + ' inexistente.';
                                    END;

                                    RecDatosSIIAProcesarDet."Fecha obtención información" := CURRENTDATETIME;
                                    RecDatosSIIAProcesarDet.INSERT;
                                END;
                            END;
                        UNTIL RecLinAboVta.NEXT = 0;

                    //EX-SIIv3 070618
                    IF ((RecConfigMultiple."Tipo factura emitida" = 'F4') OR
                        (RecConfigMultiple."Tipo factura emitida" = 'F5'))
                        AND (RecCabeceraDatosSII."NIF Representante legal" <> '') THEN
                        RecCabeceraDatosSII."Factura SinIdentifDestinatario" := 'S';
                    //EX-SIIv3 fin
                END;

            3:
                BEGIN   // Fra compra
                    RecFraCompra.GET(NoDocumento);
                    IF Currency.GET(RecFraCompra."Currency Code") THEN BEGIN
                        PrecisionRedondeo := Currency."Amount Rounding Precision";
                        TipoRedondeo := Currency.VATRoundingDirection;
                    END;
                    RecLInFraCompra.SETRANGE(RecLInFraCompra."Document No.", NoDocumento);
                    IF RecLInFraCompra.FINDFIRST THEN
                        REPEAT
                            //EX-OMI 301017
                            IF RecLInFraCompra.Quantity <> 0 THEN // Solo si la línea lleva cantidad
                                                                  //IF (RecLInFraCompra.Quantity<>0) AND (RecLInFraCompra."Direct Unit Cost"<>0) THEN
                            BEGIN
                                IF NOT ExcluirLinea(RecLInFraCompra.Type, RecLInFraCompra."No.") THEN BEGIN
                                    NoMov += 1;
                                    RecDatosSIIAProcesarDet.RESET;
                                    RecDatosSIIAProcesarDet.INIT;
                                    RecDatosSIIAProcesarDet."Tipo registro" := RecDatosSIIAProcesarDet."Tipo registro"::Detalles;
                                    RecDatosSIIAProcesarDet."Tipo documento" := RecDatosSIIAProcesarDet."Tipo documento"::Factura;
                                    RecDatosSIIAProcesarDet."Origen documento" := RecDatosSIIAProcesarDet."Origen documento"::Recibida;
                                    RecDatosSIIAProcesarDet."Tipo procedencia" := RecDatosSIIAProcesarDet."Tipo procedencia"::Proveedor;
                                    RecDatosSIIAProcesarDet."No. documento" := NoDocumento;
                                    RecDatosSIIAProcesarDet."No. Línea" := NoMov;
                                    RecDatosSIIAProcesarDet."Estado documento" := RecCabeceraDatosSII."Estado documento";

                                    // Datos para desglose por tipo operación (Servicio, Entrega)
                                    RecConfigMultiple.RESET;
                                    RecConfigMultiple.SETRANGE("Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo operación");
                                    RecConfigMultiple.SETRANGE("Gr. Contable producto", RecLInFraCompra."Gen. Prod. Posting Group");
                                    IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                        RecDatosSIIAProcesarDet."Desglose tipo operación" := RecConfigMultiple."Tipo operación";
                                        // Datos para desglose por tipo de IVA
                                        RecConfigMultiple.RESET;
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo IVA");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Negocio", RecLInFraCompra."VAT Bus. Posting Group");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Producto", RecLInFraCompra."VAT Prod. Posting Group");
                                        IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                            RecDatosSIIAProcesarDet."Inv. Sujeto Pasivo" := RecConfigMultiple."Inversión sujeto pasivo";

                                            //040817 EX-SGG SII
                                            //IF (RecDatosSIIAProcesarDet."Inv. Sujeto Pasivo") AND //160218 EX-JVN Aplica a todos los documentos de Reversión
                                            IF (RecLInFraCompra."VAT Calculation Type" = RecLInFraCompra."VAT Calculation Type"::"Reverse Charge VAT") THEN BEGIN

                                                lRstConfIVA.GET(RecConfigMultiple."Gr. Reg. IVA Negocio", RecConfigMultiple."Gr. Reg. IVA Producto");
                                                lpVat := lRstConfIVA."VAT %";
                                                lpRE := lRstConfIVA."EC %";
                                                limportevatre := ((lpVat * RecLInFraCompra.Amount) / 100) + ((lpRE * RecLInFraCompra.Amount) / 100);
                                            END ELSE BEGIN
                                                lpVat := RecLInFraCompra."VAT %";
                                                lpRE := RecLInFraCompra."EC %";
                                                limportevatre := RecLInFraCompra."Amount Including VAT" - RecLInFraCompra.Amount;
                                            END;
                                            //040817 fin

                                            //EX-SMN 161117
                                            //RecCabeceraDatosSII."Cuota deducible"+=limporteVATRE;
                                            RecCabeceraDatosSII."Cuota deducible" += CurrExchRate.ExchangeAmtFCYToLCY(RecFraCompra."Posting Date",
                                                                                                                   RecFraCompra."Currency Code",
                                                                                                                   limportevatre,
                                                                                                                   RecFraCompra."Currency Factor");
                                            RecCabeceraDatosSII.MODIFY;
                                            //EX-SMN FIN

                                            RecDatosSIIAProcesarDet.DesgloseIVAFactura := RecConfigMultiple."Tipo desglose IVA";

                                            //EX-SMN 201117
                                            RecDatosSIIAProcesarDet.Sujeta := NOT ((RecConfigMultiple."Tipo cálculo IVA" =
                                                                           RecConfigMultiple."Tipo cálculo IVA"::"No Taxable VAT") OR
                                                                           (RecConfigMultiple."Tipo No sujeta" <> RecConfigMultiple."Tipo No sujeta"::" "));

                                            IF RecDatosSIIAProcesarDet.Sujeta THEN BEGIN //Sujeta

                                                RecDatosSIIAProcesarDet.Exenta := RecConfigMultiple.Exento;

                                                //200218 EX-JVN Facturas de reversión
                                                //IF RecDatosSIIAProcesarDet.Exenta THEN BEGIN //Exenta
                                                IF RecDatosSIIAProcesarDet.Exenta AND
                                                (RecLInFraCompra."VAT Calculation Type" <> RecLInFraCompra."VAT Calculation Type"::"Reverse Charge VAT")
                                                THEN BEGIN
                                                    //200218 fin

                                                    RecDatosSIIAProcesarDet."Cód. causa exención" := RecConfigMultiple."Causa exención";
                                                    RecDatosSIIAProcesarDet."Base Imponible exenta" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecFraCompra."Posting Date",
                                                                                                                           RecFraCompra."Currency Code",
                                                                                                                           RecLInFraCompra.Amount,
                                                                                                                           RecFraCompra."Currency Factor");
                                                END ELSE BEGIN //No exenta
                                                    RecDatosSIIAProcesarDet."Tipo impositivo no exenta" := lpVat;
                                                    RecDatosSIIAProcesarDet."Base imponible no exenta" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                          RecFraCompra."Posting Date",
                                                                                                                          RecFraCompra."Currency Code",
                                                                                                                          RecLInFraCompra.Amount,
                                                                                                                          RecFraCompra."Currency Factor");

                                                    IF lpVat + lpRE <> 0 THEN
                                                        RecDatosSIIAProcesarDet."Cuota imp. no exenta" :=
                                                         CurrExchRate.ExchangeAmtFCYToLCY(RecFraCompra."Posting Date",
                                                                                        RecFraCompra."Currency Code",
                                                                                        (limportevatre) /
                                                                                        (lpVat + lpRE) * lpVat,
                                                                                        RecFraCompra."Currency Factor");

                                                    //200218 EX-JVN Informarmos de RE sólo si lo tienen las líneas
                                                    IF RecLInFraCompra."VAT Calculation Type" = RecLInFraCompra."VAT Calculation Type"::"Reverse Charge VAT"
                                                    THEN BEGIN
                                                        lpVat := RecLInFraCompra."VAT %";
                                                        lpRE := RecLInFraCompra."EC %";
                                                    END;
                                                    //200218 fin

                                                    RecDatosSIIAProcesarDet."Tipo RE no exenta" := lpRE;

                                                    IF RecDatosSIIAProcesarDet."Tipo RE no exenta" <> 0 THEN
                                                        IF lpVat + lpRE <> 0 THEN
                                                            RecDatosSIIAProcesarDet."Cuota RE no exenta" :=
                                                             CurrExchRate.ExchangeAmtFCYToLCY(RecFraCompra."Posting Date",
                                                                                          RecFraCompra."Currency Code",
                                                                                          (limportevatre) /
                                                                                          (lpVat + lpRE) * lpRE,
                                                                                           RecFraCompra."Currency Factor");
                                                END;
                                            END ELSE BEGIN //No sujeta
                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Articulos 7-14-Otros" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                   RecFraCompra."Posting Date",
                                                                                                                                  RecFraCompra."Currency Code",
                                                                                                                                  RecLInFraCompra."Amount Including VAT",
                                                                                                                                  RecFraCompra."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecFraCompra."Posting Date",
                                                                                                                                RecFraCompra."Currency Code",
                                                                                                                                RecLInFraCompra.Amount,
                                                                                                                                RecFraCompra."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecFraCompra."Posting Date",
                                                                                                                                RecFraCompra."Currency Code",
                                                                                                                                RecLInFraCompra."Amount Including VAT",
                                                                                                                                RecFraCompra."Currency Factor");
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                 RecFraCompra."Posting Date",
                                                                                                                                RecFraCompra."Currency Code",
                                                                                                                                RecLInFraCompra."Amount Including VAT" -
                                                                                                                                RecLInFraCompra.Amount,
                                                                                                                                RecFraCompra."Currency Factor");
                                                    END;
                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Reg. Localización" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                  RecFraCompra."Posting Date",
                                                                                                                                  RecFraCompra."Currency Code",
                                                                                                                                  RecLInFraCompra."Amount Including VAT",
                                                                                                                                  RecFraCompra."Currency Factor");


                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                  RecFraCompra."Posting Date",
                                                                                                                                  RecFraCompra."Currency Code",
                                                                                                                                  RecLInFraCompra.Amount,
                                                                                                                                  RecFraCompra."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                  RecFraCompra."Posting Date",
                                                                                                                                  RecFraCompra."Currency Code",
                                                                                                                                  RecLInFraCompra."Amount Including VAT",
                                                                                                                                  RecFraCompra."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                                  RecFraCompra."Posting Date",
                                                                                                                                  RecFraCompra."Currency Code",
                                                                                                                                  RecLInFraCompra."Amount Including VAT" -
                                                                                                                                  RecLInFraCompra.Amount,
                                                                                                                                  RecFraCompra."Currency Factor");
                                                    END;

                                                //EX-SMN FIN

                                                // Fin Imp Total Documento
                                                RecDatosSIIAProcesarDet."Base imponible no sujeta" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                        RecFraCompra."Posting Date",
                                                                                                                        RecFraCompra."Currency Code",
                                                                                                                        RecLInFraCompra.Amount,
                                                                                                                        RecFraCompra."Currency Factor");
                                                RecDatosSIIAProcesarDet."Tipo No sujeta" := RecConfigMultiple."Tipo No sujeta";
                                                //EX-SMN FIN
                                            END;

                                            IF RecConfigMultiple.REAGP THEN BEGIN
                                                RecDatosSIIAProcesarDet.REAGP := TRUE;
                                                RecDatosSIIAProcesarDet."% Compensación REAGYP" := lpVat;
                                                RecDatosSIIAProcesarDet."Importe Compensación REAGYP" := ((CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                RecFraCompra."Posting Date",
                                                                                                RecFraCompra."Currency Code", RecLInFraCompra."Amount Including VAT",
                                                                                                RecFraCompra."Currency Factor")) -
                                                                                                (CurrExchRate.ExchangeAmtFCYToLCY(RecFraCompra."Posting Date",
                                                                                                RecFraCompra."Currency Code", RecLInFraCompra.Amount,
                                                                                                RecFraCompra."Currency Factor"))) * -1;
                                            END;

                                            // Diferencias IVA/RE a usar en cálculo de cuotas en la agrupación de impuestos.
                                            RecDatosSIIAProcesarDet."IVA Diferencia" := RecLInFraCompra."VAT Difference";
                                            RecDatosSIIAProcesarDet."RE Diferencia" := RecLInFraCompra."EC Difference";

                                            // Tratamiento de Criterio de caja
                                            IF RecConfigMultiple."Régimen Criterio de caja" THEN
                                                EsCriterioCaja := TRUE;

                                            // Marcar si se trata de línea de DUA según configuración.
                                            IF RecConfigMultiple.DUA THEN BEGIN
                                                //061017 EX-JVN
                                                IF RecConfigMultiple."Tipo cálculo IVA" = RecConfigMultiple."Tipo cálculo IVA"::"Full VAT" THEN
                                                    RecDatosSIIAProcesarDet."Tipo DUA" := RecDatosSIIAProcesarDet."Tipo DUA"::Transitario
                                                ELSE
                                                    RecDatosSIIAProcesarDet."Tipo DUA" := RecDatosSIIAProcesarDet."Tipo DUA"::Excluir;
                                                //fin 061017

                                                RecCabeceraDatosSII."Importe total documento" -= CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                         RecFraCompra."Posting Date",
                                                                                                                         RecFraCompra."Currency Code",
                                                                                                                         RecLInFraCompra."Amount Including VAT",
                                                                                                                         RecFraCompra."Currency Factor");
                                                RecCabeceraDatosSII."Total Base imponible" -= CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                         RecFraCompra."Posting Date",
                                                                                                                         RecFraCompra."Currency Code",
                                                                                                                         RecLInFraCompra.Amount,
                                                                                                                         RecFraCompra."Currency Factor");
                                                RecCabeceraDatosSII."Cuota deducible" -= CurrExchRate.ExchangeAmtFCYToLCY(RecFraCompra."Posting Date",
                                                                                                                         RecFraCompra."Currency Code",
                                                                                                                         RecLInFraCompra."Amount Including VAT" -
                                                                                                                         RecLInFraCompra.Amount,
                                                                                                                         RecFraCompra."Currency Factor");

                                                RecCabeceraDatosSII.MODIFY;
                                            END;

                                            // Tratamiento especial para IVA Total
                                            IF RecConfigMultiple."Tipo cálculo IVA" = RecConfigMultiple."Tipo cálculo IVA"::"Full VAT" THEN BEGIN
                                                RecDatosSIIAProcesarDet."Cuota imp. no exenta" :=
                                                           CurrExchRate.ExchangeAmtFCYToLCY(
                                                           RecFraCompra."Posting Date",
                                                           RecFraCompra."Currency Code",
                                                           RecLInFraCompra."Amount Including VAT",
                                                           RecFraCompra."Currency Factor");
                                            END;
                                            // Fin - Tratamiento especial para IVA Total

                                        END ELSE BEGIN
                                            RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                            RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de IVA SII : ' +
                                                         RecLInFraCompra."VAT Bus. Posting Group" + '-' + RecLInFraCompra."VAT Prod. Posting Group" + ' inexistente.';
                                        END;

                                    END ELSE BEGIN
                                        RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                        RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de Operación SII : ' +
                                          RecLInFraCompra."Gen. Prod. Posting Group" + ' inexistente.';
                                    END;

                                    RecDatosSIIAProcesarDet."Fecha obtención información" := CURRENTDATETIME;
                                    RecDatosSIIAProcesarDet.INSERT;
                                END;
                            END;
                        UNTIL RecLInFraCompra.NEXT = 0;
                    RecCabeceraDatosSII."Factura SinIdentifDestinatario" := 'N';  //EX-SIIv3 220518
                END;
            4:
                BEGIN   // Abono compra
                    RecAboCompra.GET(NoDocumento);
                    IF Currency.GET(RecAboCompra."Currency Code") THEN BEGIN
                        PrecisionRedondeo := Currency."Amount Rounding Precision";
                        TipoRedondeo := Currency.VATRoundingDirection;
                    END;
                    RecLinAboCompra.SETRANGE(RecLinAboCompra."Document No.", NoDocumento);
                    IF RecLinAboCompra.FINDFIRST THEN
                        REPEAT
                            //EX-OMI 301017
                            IF RecLinAboCompra.Quantity <> 0 THEN // Solo si la línea lleva cantidad
                                                                  //IF (RecLinAboCompra.Quantity<>0) AND (RecLinAboCompra."Direct Unit Cost"<>0) THEN
                            BEGIN
                                IF NOT ExcluirLinea(RecLinAboCompra.Type, RecLinAboCompra."No.") THEN BEGIN
                                    NoMov += 1;
                                    RecDatosSIIAProcesarDet.RESET;
                                    RecDatosSIIAProcesarDet.INIT;
                                    RecDatosSIIAProcesarDet."Tipo registro" := RecDatosSIIAProcesarDet."Tipo registro"::Detalles;
                                    RecDatosSIIAProcesarDet."Tipo documento" := RecDatosSIIAProcesarDet."Tipo documento"::Abono;
                                    RecDatosSIIAProcesarDet."Origen documento" := RecDatosSIIAProcesarDet."Origen documento"::Recibida;
                                    RecDatosSIIAProcesarDet."Tipo procedencia" := RecDatosSIIAProcesarDet."Tipo procedencia"::Proveedor;
                                    RecDatosSIIAProcesarDet."No. documento" := NoDocumento;
                                    RecDatosSIIAProcesarDet."No. Línea" := NoMov;
                                    RecDatosSIIAProcesarDet."Estado documento" := RecCabeceraDatosSII."Estado documento";

                                    // Datos para desglose por tipo operación (Servicio, Entrega)
                                    RecConfigMultiple.RESET;
                                    RecConfigMultiple.SETRANGE("Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo operación");
                                    RecConfigMultiple.SETRANGE("Gr. Contable producto", RecLinAboCompra."Gen. Prod. Posting Group");
                                    IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                        RecDatosSIIAProcesarDet."Desglose tipo operación" := RecConfigMultiple."Tipo operación";
                                        // Datos para desglose por tipo de IVA
                                        RecConfigMultiple.RESET;
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo IVA");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Negocio", RecLinAboCompra."VAT Bus. Posting Group");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Producto", RecLinAboCompra."VAT Prod. Posting Group");
                                        IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                            RecDatosSIIAProcesarDet."Inv. Sujeto Pasivo" := RecConfigMultiple."Inversión sujeto pasivo";

                                            //040817 EX-SGG SII
                                            //IF (RecDatosSIIAProcesarDet."Inv. Sujeto Pasivo") AND //160218 EX-JVN Aplica a todos los documentos de Reversión
                                            IF (RecLinAboCompra."VAT Calculation Type" = RecLinAboCompra."VAT Calculation Type"::"Reverse Charge VAT") THEN BEGIN

                                                lRstConfIVA.GET(RecConfigMultiple."Gr. Reg. IVA Negocio", RecConfigMultiple."Gr. Reg. IVA Producto");
                                                lpVat := lRstConfIVA."VAT %";
                                                lpRE := lRstConfIVA."EC %";
                                                limportevatre := ((lpVat * RecLinAboCompra.Amount) / 100) + ((lpRE * RecLinAboCompra.Amount) / 100);
                                            END ELSE BEGIN
                                                lpVat := RecLinAboCompra."VAT %";
                                                lpRE := RecLinAboCompra."EC %";
                                                limportevatre := RecLinAboCompra."Amount Including VAT" - RecLinAboCompra.Amount;
                                            END;
                                            //040817 fin

                                            //EX-SMN 161117
                                            //RecCabeceraDatosSII."Cuota deducible"+=-limporteVATRE; //100817 EX-JVN SII
                                            RecCabeceraDatosSII."Cuota deducible" += (CurrExchRate.ExchangeAmtFCYToLCY(RecAboCompra."Posting Date",
                                                                                                                      RecAboCompra."Currency Code",
                                                                                                                      -limportevatre,
                                                                                                                      RecAboCompra."Currency Factor"));
                                            RecCabeceraDatosSII.MODIFY;
                                            //EX-SMN FIN

                                            RecDatosSIIAProcesarDet.DesgloseIVAFactura := RecConfigMultiple."Tipo desglose IVA";

                                            //EX-SMN 171117
                                            RecDatosSIIAProcesarDet.Sujeta := NOT ((RecConfigMultiple."Tipo cálculo IVA" =
                                                                            RecConfigMultiple."Tipo cálculo IVA"::"No Taxable VAT") OR
                                                                            (RecConfigMultiple."Tipo No sujeta" <> RecConfigMultiple."Tipo No sujeta"::" "));

                                            IF RecDatosSIIAProcesarDet.Sujeta THEN BEGIN //Sujeta

                                                RecDatosSIIAProcesarDet.Exenta := RecConfigMultiple.Exento;

                                                //200218 EX-JVN Facturas de reversión
                                                //IF RecDatosSIIAProcesarDet.Exenta THEN BEGIN //Exenta
                                                IF RecDatosSIIAProcesarDet.Exenta AND
                                                (RecLinAboCompra."VAT Calculation Type" <> RecLinAboCompra."VAT Calculation Type"::"Reverse Charge VAT")
                                                THEN BEGIN
                                                    //200218 fin

                                                    RecDatosSIIAProcesarDet."Cód. causa exención" := RecConfigMultiple."Causa exención";
                                                    RecDatosSIIAProcesarDet."Base Imponible exenta" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboCompra."Posting Date",
                                                                                                                           RecAboCompra."Currency Code",
                                                                                                                           RecLinAboCompra.Amount,
                                                                                                                           RecAboCompra."Currency Factor");
                                                END ELSE BEGIN //No Exenta
                                                    RecDatosSIIAProcesarDet."Tipo no exenta" := RecConfigMultiple."Tipo No Exención";
                                                    RecDatosSIIAProcesarDet."Tipo impositivo no exenta" := lpVat;
                                                    RecDatosSIIAProcesarDet."Base imponible no exenta" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboCompra."Posting Date",
                                                                                                                           RecAboCompra."Currency Code",
                                                                                                                           RecLinAboCompra.Amount,
                                                                                                                           RecAboCompra."Currency Factor");
                                                    IF lpVat + lpRE <> 0 THEN
                                                        RecDatosSIIAProcesarDet."Cuota imp. no exenta" :=
                                                         CurrExchRate.ExchangeAmtFCYToLCY(RecAboCompra."Posting Date",
                                                                                        RecAboCompra."Currency Code",
                                                                                        (limportevatre) /
                                                                                        (lpVat + lpRE) * lpVat,
                                                                                        RecAboCompra."Currency Factor") * -1;

                                                    //200218 EX-JVN Informarmos de RE sólo si lo tienen las líneas
                                                    IF RecLinAboCompra."VAT Calculation Type" = RecLinAboCompra."VAT Calculation Type"::"Reverse Charge VAT"
                                                    THEN BEGIN
                                                        lpVat := RecLinAboCompra."VAT %";
                                                        lpRE := RecLinAboCompra."EC %";
                                                    END;
                                                    //200218 fin

                                                    RecDatosSIIAProcesarDet."Tipo RE no exenta" := lpRE;

                                                    IF RecDatosSIIAProcesarDet."Tipo RE no exenta" <> 0 THEN
                                                        IF lpVat + lpRE <> 0 THEN
                                                            RecDatosSIIAProcesarDet."Cuota RE no exenta" :=
                                                             CurrExchRate.ExchangeAmtFCYToLCY(RecAboCompra."Posting Date",
                                                                                           RecAboCompra."Currency Code",
                                                                                           (limportevatre) /
                                                                                           (lpVat + lpRE) * lpRE,
                                                                                            RecAboCompra."Currency Factor") * -1;
                                                END;
                                            END ELSE BEGIN //No Sujeta
                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Articulos 7-14-Otros" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                               RecAboCompra."Posting Date",
                                                                                                                               RecAboCompra."Currency Code",
                                                                                                                               RecLinAboCompra."Amount Including VAT",
                                                                                                                               RecAboCompra."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                               RecAboCompra."Posting Date",
                                                                                                                               RecAboCompra."Currency Code",
                                                                                                                               RecLinAboCompra.Amount,
                                                                                                                               RecAboCompra."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                               RecAboCompra."Posting Date",
                                                                                                                               RecAboCompra."Currency Code",
                                                                                                                               RecLinAboCompra."Amount Including VAT",
                                                                                                                               RecAboCompra."Currency Factor");
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                               RecAboCompra."Posting Date",
                                                                                                                               RecAboCompra."Currency Code",
                                                                                                                               RecLinAboCompra."Amount Including VAT" -
                                                                                                                               RecLinAboCompra.Amount,
                                                                                                                               RecAboCompra."Currency Factor");
                                                    END;
                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Reg. Localización" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                               RecAboCompra."Posting Date",
                                                                                                                               RecAboCompra."Currency Code",
                                                                                                                               RecLinAboCompra."Amount Including VAT",
                                                                                                                               RecAboCompra."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                               RecAboCompra."Posting Date",
                                                                                                                               RecAboCompra."Currency Code",
                                                                                                                               RecLinAboCompra.Amount,
                                                                                                                               RecAboCompra."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                               RecAboCompra."Posting Date",
                                                                                                                               RecAboCompra."Currency Code",
                                                                                                                               RecLinAboCompra."Amount Including VAT",
                                                                                                                               RecAboCompra."Currency Factor");
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                               RecAboCompra."Posting Date",
                                                                                                                               RecAboCompra."Currency Code",
                                                                                                                               RecLinAboCompra."Amount Including VAT" -
                                                                                                                               RecLinAboCompra.Amount,
                                                                                                                               RecAboCompra."Currency Factor");
                                                    END;

                                                // Fin Imp Total Documento
                                                RecDatosSIIAProcesarDet."Base imponible no sujeta" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                         RecAboCompra."Posting Date",
                                                                                                                         RecAboCompra."Currency Code",
                                                                                                                         RecLinAboCompra.Amount,
                                                                                                                         RecAboCompra."Currency Factor");
                                                RecDatosSIIAProcesarDet."Tipo No sujeta" := RecConfigMultiple."Tipo No sujeta";
                                            END;
                                            //EX-SMN FIN

                                            IF RecConfigMultiple.REAGP THEN BEGIN
                                                RecDatosSIIAProcesarDet.REAGP := TRUE;
                                                RecDatosSIIAProcesarDet."% Compensación REAGYP" := lpVat;
                                                RecDatosSIIAProcesarDet."Importe Compensación REAGYP" := ((CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                RecAboCompra."Posting Date",
                                                                                                RecAboCompra."Currency Code", RecLinAboCompra."Amount Including VAT",
                                                                                                RecAboCompra."Currency Factor")) -
                                                                                                (CurrExchRate.ExchangeAmtFCYToLCY(RecAboCompra."Posting Date",
                                                                                                RecAboCompra."Currency Code", RecLinAboCompra.Amount,
                                                                                                RecAboCompra."Currency Factor"))) * -1;
                                            END;

                                            // Diferencias IVA/RE a usar en cálculo de cuotas en la agrupación de impuestos.
                                            RecDatosSIIAProcesarDet."IVA Diferencia" := RecLinAboCompra."VAT Difference";
                                            RecDatosSIIAProcesarDet."RE Diferencia" := RecLinAboCompra."EC Difference";

                                            // Tratamiento de Criterio de caja
                                            IF RecConfigMultiple."Régimen Criterio de caja" THEN
                                                EsCriterioCaja := TRUE;

                                            // Marcar si se trata de línea de DUA según configuración.
                                            IF RecConfigMultiple.DUA THEN BEGIN
                                                //061017 EX-JVN
                                                IF RecConfigMultiple."Tipo cálculo IVA" = RecConfigMultiple."Tipo cálculo IVA"::"Full VAT" THEN
                                                    RecDatosSIIAProcesarDet."Tipo DUA" := RecDatosSIIAProcesarDet."Tipo DUA"::Transitario
                                                ELSE
                                                    RecDatosSIIAProcesarDet."Tipo DUA" := RecDatosSIIAProcesarDet."Tipo DUA"::Excluir;
                                                //fin 061017

                                                RecCabeceraDatosSII."Importe total documento" -= (CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                         RecAboCompra."Posting Date",
                                                                                                                         RecAboCompra."Currency Code",
                                                                                                                         RecLinAboCompra."Amount Including VAT",
                                                                                                                         RecAboCompra."Currency Factor")) * -1;
                                                RecCabeceraDatosSII."Total Base imponible" -= (CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                         RecAboCompra."Posting Date",
                                                                                                                         RecAboCompra."Currency Code",
                                                                                                                         RecLinAboCompra.Amount,
                                                                                                                         RecAboCompra."Currency Factor")) * -1;
                                                RecCabeceraDatosSII."Cuota deducible" -= (CurrExchRate.ExchangeAmtFCYToLCY(RecAboCompra."Posting Date",
                                                                                                                         RecAboCompra."Currency Code",
                                                                                                                         RecLinAboCompra."Amount Including VAT" -
                                                                                                                         RecLinAboCompra.Amount,
                                                                                                                         RecAboCompra."Currency Factor")) * -1;

                                                RecCabeceraDatosSII.MODIFY;
                                            END;

                                            // Tratamiento especial para IVA Total
                                            IF RecConfigMultiple."Tipo cálculo IVA" = RecConfigMultiple."Tipo cálculo IVA"::"Full VAT" THEN BEGIN
                                                RecDatosSIIAProcesarDet."Cuota imp. no exenta" :=
                                                           CurrExchRate.ExchangeAmtFCYToLCY(
                                                           RecAboCompra."Posting Date",
                                                           RecAboCompra."Currency Code",
                                                           RecLinAboCompra."Amount Including VAT",
                                                           RecAboCompra."Currency Factor") * -1;
                                            END;
                                            // Fin - Tratamiento especial para IVA Total

                                        END ELSE BEGIN
                                            RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                            RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de IVA SII : ' +
                                                         RecLinAboCompra."VAT Bus. Posting Group" + '-' + RecLinAboCompra."VAT Prod. Posting Group" + ' inexistente.';
                                        END;

                                    END ELSE BEGIN
                                        RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                        RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de Operación SII : ' +
                                          RecLinAboCompra."Gen. Prod. Posting Group" + ' inexistente.';
                                    END;

                                    RecDatosSIIAProcesarDet."Fecha obtención información" := CURRENTDATETIME;
                                    RecDatosSIIAProcesarDet.INSERT;
                                END;
                            END;
                        UNTIL RecLinAboCompra.NEXT = 0;
                END;
            13:
                BEGIN  // Fra. venta Servicios
                    RecFraVtaServicios.GET(NoDocumento);
                    IF Currency.GET(RecFraVtaServicios."Currency Code") THEN BEGIN
                        PrecisionRedondeo := Currency."Amount Rounding Precision";
                        TipoRedondeo := Currency.VATRoundingDirection;
                    END;
                    RecLinFraVtaServicios.SETRANGE(RecLinFraVtaServicios."Document No.", NoDocumento);
                    IF RecLinFraVtaServicios.FINDFIRST THEN
                        REPEAT
                            //EX-OMI 301017
                            IF RecLinFraVtaServicios.Quantity <> 0 THEN // Solo si la línea lleva cantidad
                                                                        //IF (RecLinFraVtaServicios.Quantity<>0) AND (RecLinFraVtaServicios."Unit Price"<>0) THEN
                            BEGIN
                                IF NOT ExcluirLinea(RecLinFraVtaServicios.Type, RecLinFraVtaServicios."No.") THEN BEGIN

                                    NoMov += 1;
                                    RecDatosSIIAProcesarDet.RESET;
                                    RecDatosSIIAProcesarDet.INIT;
                                    RecDatosSIIAProcesarDet."Tipo registro" := RecDatosSIIAProcesarDet."Tipo registro"::Detalles;
                                    RecDatosSIIAProcesarDet."Tipo documento" := RecDatosSIIAProcesarDet."Tipo documento"::Factura;
                                    RecDatosSIIAProcesarDet."Origen documento" := RecDatosSIIAProcesarDet."Origen documento"::Emitida;
                                    RecDatosSIIAProcesarDet."Tipo procedencia" := RecDatosSIIAProcesarDet."Tipo procedencia"::Cliente;
                                    RecDatosSIIAProcesarDet."No. documento" := NoDocumento;
                                    RecDatosSIIAProcesarDet."No. Línea" := NoMov;
                                    RecDatosSIIAProcesarDet."Estado documento" := RecCabeceraDatosSII."Estado documento";

                                    // Datos para desglose por tipo operación (Servicio, Entrega)
                                    RecConfigMultiple.RESET;
                                    RecConfigMultiple.SETRANGE("Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo operación");
                                    RecConfigMultiple.SETRANGE("Gr. Contable producto", RecLinFraVtaServicios."Gen. Prod. Posting Group");
                                    IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                        RecDatosSIIAProcesarDet."Desglose tipo operación" := RecConfigMultiple."Tipo operación";
                                        // Datos para desglose por tipo cálculo de IVA (Sujeto-Exento,Sujeto-NoExento,No sujeto...)
                                        RecConfigMultiple.RESET;
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo IVA");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Negocio", RecLinFraVtaServicios."VAT Bus. Posting Group");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Producto", RecLinFraVtaServicios."VAT Prod. Posting Group");
                                        IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                            RecDatosSIIAProcesarDet."Inv. Sujeto Pasivo" := RecConfigMultiple."Inversión sujeto pasivo";
                                            RecDatosSIIAProcesarDet.DesgloseIVAFactura := RecConfigMultiple."Tipo desglose IVA";
                                            RecDatosSIIAProcesarDet.Sujeta := NOT ((RecConfigMultiple."Tipo cálculo IVA" =
                                                                            RecConfigMultiple."Tipo cálculo IVA"::"No Taxable VAT") OR
                                                                            (RecConfigMultiple."Tipo No sujeta" <> RecConfigMultiple."Tipo No sujeta"::" "));

                                            IF RecDatosSIIAProcesarDet.Sujeta THEN BEGIN
                                                // Exenta
                                                RecDatosSIIAProcesarDet.Exenta := RecConfigMultiple.Exento;
                                                IF RecDatosSIIAProcesarDet.Exenta THEN BEGIN
                                                    RecDatosSIIAProcesarDet."Cód. causa exención" := RecConfigMultiple."Causa exención";
                                                    RecDatosSIIAProcesarDet."Base Imponible exenta" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                      RecFraVtaServicios."Posting Date",
                                                                                                      RecFraVtaServicios."Currency Code",
                                                                                                      RecLinFraVtaServicios.Amount,
                                                                                                      RecFraVtaServicios."Currency Factor");

                                                END;
                                                // No Exenta
                                                IF NOT RecDatosSIIAProcesarDet.Exenta THEN BEGIN
                                                    RecDatosSIIAProcesarDet."Tipo no exenta" := RecConfigMultiple."Tipo No Exención";
                                                    RecDatosSIIAProcesarDet."Tipo impositivo no exenta" := RecLinFraVtaServicios."VAT %";
                                                    RecDatosSIIAProcesarDet."Base imponible no exenta" :=
                                                                     CurrExchRate.ExchangeAmtFCYToLCY(RecFraVtaServicios."Posting Date",
                                                                                                      RecFraVtaServicios."Currency Code",
                                                                                                      RecLinFraVtaServicios.Amount,
                                                                                                      RecFraVtaServicios."Currency Factor");

                                                    IF RecLinFraVtaServicios."VAT %" + RecLinFraVtaServicios."EC %" <> 0 THEN
                                                        RecDatosSIIAProcesarDet."Cuota imp. no exenta" :=
                                                            CurrExchRate.ExchangeAmtFCYToLCY(RecFraVtaServicios."Posting Date",
                                                                            RecFraVtaServicios."Currency Code",
                                                                            (RecLinFraVtaServicios."Amount Including VAT" - RecLinFraVtaServicios.Amount) /
                                                                            (RecLinFraVtaServicios."VAT %" + RecLinFraVtaServicios."EC %") * RecLinFraVtaServicios."VAT %",
                                                                             RecFraVtaServicios."Currency Factor");

                                                    RecDatosSIIAProcesarDet."Tipo RE no exenta" := RecLinFraVtaServicios."EC %";

                                                    IF RecDatosSIIAProcesarDet."Tipo RE no exenta" <> 0 THEN
                                                        IF RecLinFraVtaServicios."VAT %" + RecLinFraVtaServicios."EC %" <> 0 THEN
                                                            RecDatosSIIAProcesarDet."Cuota RE no exenta" :=
                                                              CurrExchRate.ExchangeAmtFCYToLCY(RecFraVtaServicios."Posting Date",
                                                                               RecFraVtaServicios."Currency Code",
                                                                               (RecLinFraVtaServicios."Amount Including VAT" - RecLinFraVtaServicios.Amount) /
                                                                               (RecLinFraVtaServicios."VAT %" + RecLinFraVtaServicios."EC %") * RecLinFraVtaServicios."EC %",
                                                                                RecFraVtaServicios."Currency Factor");
                                                END;
                                                // Imp. Total Documento según exento o no exento
                                                RecCabeceraDatosSII."Importe total documento" += CurrExchRate.ExchangeAmtFCYToLCY(RecFraVta."Posting Date",
                                                                                                                                RecFraVta."Currency Code",
                                                                                                                                RecLinFraVta."Amount Including VAT",
                                                                                                                                RecFraVta."Currency Factor");
                                                // Fin Imp Total Documento

                                            END ELSE BEGIN
                                                // No sujeta
                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Articulos 7-14-Otros" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                         RecFraVtaServicios."Posting Date",
                                                                                                                         RecFraVtaServicios."Currency Code",
                                                                                                                         RecLinFraVtaServicios."Amount Including VAT",
                                                                                                                         RecFraVtaServicios."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecFraVtaServicios."Posting Date",
                                                                                                                          RecFraVtaServicios."Currency Code",
                                                                                                                          RecLinFraVtaServicios.Amount,
                                                                                                                          RecFraVtaServicios."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecFraVtaServicios."Posting Date",
                                                                                                                          RecFraVtaServicios."Currency Code",
                                                                                                                          RecLinFraVtaServicios."Amount Including VAT",
                                                                                                                          RecFraVtaServicios."Currency Factor");
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecFraVtaServicios."Posting Date",
                                                                                                                          RecFraVtaServicios."Currency Code",
                                                                                                                          RecLinFraVtaServicios."Amount Including VAT" -
                                                                                                                          RecLinFraVtaServicios.Amount,
                                                                                                                          RecFraVtaServicios."Currency Factor");
                                                    END;

                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Reg. Localización" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                         RecFraVtaServicios."Posting Date",
                                                                                                                         RecFraVtaServicios."Currency Code",
                                                                                                                         RecLinFraVtaServicios."Amount Including VAT",
                                                                                                                         RecFraVtaServicios."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecFraVtaServicios."Posting Date",
                                                                                                                          RecFraVtaServicios."Currency Code",
                                                                                                                          RecLinFraVtaServicios.Amount,
                                                                                                                          RecFraVtaServicios."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecFraVtaServicios."Posting Date",
                                                                                                                          RecFraVtaServicios."Currency Code",
                                                                                                                          RecLinFraVtaServicios."Amount Including VAT",
                                                                                                                          RecFraVtaServicios."Currency Factor");
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecFraVtaServicios."Posting Date",
                                                                                                                          RecFraVtaServicios."Currency Code",
                                                                                                                          RecLinFraVtaServicios."Amount Including VAT" -
                                                                                                                          RecLinFraVtaServicios.Amount,
                                                                                                                          RecFraVtaServicios."Currency Factor");
                                                    END;
                                                // Imp. Total Documento según Sujeto o no sujeto
                                                IF RecConfigMultiple."Tipo No sujeta" <> RecConfigMultiple."Tipo No sujeta"::" " THEN
                                                    IF RecDatosSIIAProcesarDet."Importe no sujeta localización" <> 0 THEN
                                                        RecCabeceraDatosSII."Importe total documento" += RecDatosSIIAProcesarDet."Importe no sujeta localización"
                                                    ELSE
                                                        RecCabeceraDatosSII."Importe total documento" += RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14";

                                                // Fin Imp Total Documento

                                                RecDatosSIIAProcesarDet."Base imponible no sujeta" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                          RecFraVtaServicios."Posting Date",
                                                                                                          RecFraVtaServicios."Currency Code",
                                                                                                          RecLinFraVtaServicios.Amount,
                                                                                                          RecFraVtaServicios."Currency Factor");
                                                RecDatosSIIAProcesarDet."Tipo No sujeta" := RecConfigMultiple."Tipo No sujeta";
                                            END;

                                            // Diferencias IVA/RE a usar en cálculo de cuotas en la agrupación de impuestos.
                                            RecDatosSIIAProcesarDet."IVA Diferencia" := RecLinFraVtaServicios."VAT Difference";
                                            RecDatosSIIAProcesarDet."RE Diferencia" := RecLinFraVtaServicios."EC Difference";

                                            // Tratamiento de Criterio de caja
                                            IF RecConfigMultiple."Régimen Criterio de caja" THEN
                                                EsCriterioCaja := TRUE;

                                        END ELSE BEGIN
                                            RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                            RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de IVA SII : ' +
                                                         RecLinFraVtaServicios."VAT Bus. Posting Group" + '-' +
                                                         RecLinFraVtaServicios."VAT Prod. Posting Group" + ' inexistente.';
                                        END;
                                    END ELSE BEGIN
                                        RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                        RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de Operación SII : ' +
                                          RecLinFraVtaServicios."Gen. Prod. Posting Group" + ' inexistente.';
                                    END;

                                    RecDatosSIIAProcesarDet."Fecha obtención información" := CURRENTDATETIME;
                                    RecDatosSIIAProcesarDet.INSERT;
                                END;
                            END;
                        UNTIL RecLinFraVtaServicios.NEXT = 0;
                END;
            14:
                BEGIN  // Abo. venta Servicios
                    RecAboVtaServicios.GET(NoDocumento);
                    IF Currency.GET(RecAboVtaServicios."Currency Code") THEN BEGIN
                        PrecisionRedondeo := Currency."Amount Rounding Precision";
                        TipoRedondeo := Currency.VATRoundingDirection;
                    END;
                    RecLinAboVtaServicios.SETRANGE("Document No.", NoDocumento);
                    IF RecLinAboVtaServicios.FINDFIRST THEN
                        REPEAT
                            //EX-OMI 301017
                            IF RecLinAboVtaServicios.Quantity <> 0 THEN // Solo si la línea lleva cantidad
                                                                        //IF (RecLinAboVtaServicios.Quantity<>0) AND (RecLinAboVtaServicios."Unit Price"<>0) THEN
                            BEGIN
                                IF NOT ExcluirLinea(RecLinAboVtaServicios.Type, RecLinAboVtaServicios."No.") THEN BEGIN
                                    NoMov += 1;
                                    RecDatosSIIAProcesarDet.RESET;
                                    RecDatosSIIAProcesarDet.INIT;
                                    RecDatosSIIAProcesarDet."Tipo registro" := RecDatosSIIAProcesarDet."Tipo registro"::Detalles;
                                    RecDatosSIIAProcesarDet."Tipo documento" := RecDatosSIIAProcesarDet."Tipo documento"::Abono;
                                    RecDatosSIIAProcesarDet."Origen documento" := RecDatosSIIAProcesarDet."Origen documento"::Emitida;
                                    RecDatosSIIAProcesarDet."Tipo procedencia" := RecDatosSIIAProcesarDet."Tipo procedencia"::Cliente;
                                    RecDatosSIIAProcesarDet."No. documento" := NoDocumento;
                                    RecDatosSIIAProcesarDet."No. Línea" := NoMov;
                                    RecDatosSIIAProcesarDet."Estado documento" := RecCabeceraDatosSII."Estado documento";

                                    // Datos para desglose por tipo operación (Servicio, Entrega)
                                    RecConfigMultiple.RESET;
                                    RecConfigMultiple.SETRANGE("Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo operación");
                                    RecConfigMultiple.SETRANGE("Gr. Contable producto", RecLinAboVtaServicios."Gen. Prod. Posting Group");
                                    IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                        RecDatosSIIAProcesarDet."Desglose tipo operación" := RecConfigMultiple."Tipo operación";
                                        // Datos para desglose por tipo cálculo de IVA (Sujeto-Exento,Sujeto-NoExento,No sujeto...)
                                        RecConfigMultiple.RESET;
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo IVA");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Negocio", RecLinAboVtaServicios."VAT Bus. Posting Group");
                                        RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Producto", RecLinAboVtaServicios."VAT Prod. Posting Group");
                                        IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                            RecDatosSIIAProcesarDet."Inv. Sujeto Pasivo" := RecConfigMultiple."Inversión sujeto pasivo";
                                            RecDatosSIIAProcesarDet.DesgloseIVAFactura := RecConfigMultiple."Tipo desglose IVA";
                                            RecDatosSIIAProcesarDet.Sujeta := NOT ((RecConfigMultiple."Tipo cálculo IVA" =
                                                                            RecConfigMultiple."Tipo cálculo IVA"::"No Taxable VAT") OR
                                                                            (RecConfigMultiple."Tipo No sujeta" <> RecConfigMultiple."Tipo No sujeta"::" "));

                                            IF RecDatosSIIAProcesarDet.Sujeta THEN BEGIN
                                                // Exenta
                                                RecDatosSIIAProcesarDet.Exenta := RecConfigMultiple.Exento;
                                                IF RecDatosSIIAProcesarDet.Exenta THEN BEGIN
                                                    RecDatosSIIAProcesarDet."Cód. causa exención" := RecConfigMultiple."Causa exención";
                                                    RecDatosSIIAProcesarDet."Base Imponible exenta" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboVtaServicios."Posting Date",
                                                                                                                           RecAboVtaServicios."Currency Code",
                                                                                                                           RecLinAboVtaServicios.Amount,
                                                                                                                           RecAboVtaServicios."Currency Factor");
                                                END;
                                                // No Exenta
                                                IF NOT RecDatosSIIAProcesarDet.Exenta THEN BEGIN
                                                    RecDatosSIIAProcesarDet."Tipo no exenta" := RecConfigMultiple."Tipo No Exención";
                                                    RecDatosSIIAProcesarDet."Tipo impositivo no exenta" := RecLinAboVtaServicios."VAT %";
                                                    RecDatosSIIAProcesarDet."Base imponible no exenta" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboVtaServicios."Posting Date",
                                                                                                                           RecAboVtaServicios."Currency Code",
                                                                                                                           RecLinAboVtaServicios.Amount,
                                                                                                                           RecAboVtaServicios."Currency Factor");
                                                    IF RecLinAboVtaServicios."VAT %" + RecLinAboVtaServicios."EC %" <> 0 THEN
                                                        RecDatosSIIAProcesarDet."Cuota imp. no exenta" :=
                                                          CurrExchRate.ExchangeAmtFCYToLCY(RecAboVtaServicios."Posting Date",
                                                                              RecAboVtaServicios."Currency Code",
                                                                              (RecLinAboVtaServicios."Amount Including VAT" - RecLinAboVtaServicios.Amount) /
                                                                              (RecLinAboVtaServicios."VAT %" + RecLinAboVtaServicios."EC %") * RecLinAboVtaServicios."VAT %",
                                                                               RecAboVtaServicios."Currency Factor") * -1;

                                                    RecDatosSIIAProcesarDet."Tipo RE no exenta" := RecLinAboVtaServicios."EC %";
                                                    IF RecDatosSIIAProcesarDet."Tipo RE no exenta" <> 0 THEN
                                                        RecDatosSIIAProcesarDet."Cuota RE no exenta" :=
                                                           CurrExchRate.ExchangeAmtFCYToLCY(RecAboVtaServicios."Posting Date",
                                                                        RecAboVtaServicios."Currency Code",
                                                                        (RecLinAboVtaServicios."Amount Including VAT" - RecLinAboVtaServicios.Amount) /
                                                                        (RecLinAboVtaServicios."VAT %" + RecLinAboVtaServicios."EC %") * RecLinAboVtaServicios."EC %",
                                                                         RecAboVtaServicios."Currency Factor") * -1;

                                                END;
                                                // Imp. Total Documento según exento o no exento
                                                RecCabeceraDatosSII."Importe total documento" += (CurrExchRate.ExchangeAmtFCYToLCY(RecAboVta."Posting Date",
                                                                                                                     RecAboVtaServicios."Currency Code",
                                                                                                                     -RecLinAboVtaServicios."Amount Including VAT",
                                                                                                                     RecAboVtaServicios."Currency Factor"));
                                                // Fin Imp Total Documento

                                            END ELSE BEGIN
                                                // No sujeta
                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Articulos 7-14-Otros" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                         RecAboVtaServicios."Posting Date",
                                                                                                                         RecAboVtaServicios."Currency Code",
                                                                                                                         RecLinAboVtaServicios."Amount Including VAT",
                                                                                                                         RecAboVtaServicios."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboVtaServicios."Posting Date",
                                                                                                                          RecAboVtaServicios."Currency Code",
                                                                                                                          RecLinAboVtaServicios.Amount,
                                                                                                                          RecAboVtaServicios."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboVtaServicios."Posting Date",
                                                                                                                          RecAboVtaServicios."Currency Code",
                                                                                                                          RecLinAboVtaServicios."Amount Including VAT",
                                                                                                                          RecAboVtaServicios."Currency Factor");
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboVtaServicios."Posting Date",
                                                                                                                          RecAboVtaServicios."Currency Code",
                                                                                                                          RecLinAboVtaServicios."Amount Including VAT" -
                                                                                                                          RecLinAboVtaServicios.Amount,
                                                                                                                          RecAboVtaServicios."Currency Factor");
                                                    END;

                                                IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Reg. Localización" THEN
                                                    CASE RecConfigMultiple."Dato a exportar No Sujeto" OF
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::" ":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                         RecAboVtaServicios."Posting Date",
                                                                                                                         RecAboVtaServicios."Currency Code",
                                                                                                                         RecLinAboVtaServicios."Amount Including VAT",
                                                                                                                         RecAboVtaServicios."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Base IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboVtaServicios."Posting Date",
                                                                                                                          RecAboVtaServicios."Currency Code",
                                                                                                                          RecLinAboVtaServicios.Amount,
                                                                                                                          RecAboVtaServicios."Currency Factor");

                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Importe IVA Incl.":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboVtaServicios."Posting Date",
                                                                                                                          RecAboVtaServicios."Currency Code",
                                                                                                                          RecLinAboVtaServicios."Amount Including VAT",
                                                                                                                          RecAboVtaServicios."Currency Factor");
                                                        RecConfigMultiple."Dato a exportar No Sujeto"::"Cuota IVA":
                                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                                           RecAboVtaServicios."Posting Date",
                                                                                                                          RecAboVtaServicios."Currency Code",
                                                                                                                          RecLinAboVtaServicios."Amount Including VAT" -
                                                                                                                          RecLinAboVtaServicios.Amount,
                                                                                                                          RecAboVtaServicios."Currency Factor");
                                                    END;
                                                // Imp. Total Documento según Sujeto o no sujeto
                                                IF RecConfigMultiple."Tipo No sujeta" <> RecConfigMultiple."Tipo No sujeta"::" " THEN
                                                    IF RecDatosSIIAProcesarDet."Importe no sujeta localización" <> 0 THEN
                                                        RecCabeceraDatosSII."Importe total documento" += RecDatosSIIAProcesarDet."Importe no sujeta localización"
                                                    ELSE
                                                        RecCabeceraDatosSII."Importe total documento" += RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14";

                                                // Fin Imp Total Documento

                                                RecDatosSIIAProcesarDet."Base imponible no sujeta" := -CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                                          RecAboVtaServicios."Posting Date",
                                                                                                          RecAboVtaServicios."Currency Code",
                                                                                                          RecLinAboVtaServicios.Amount,
                                                                                                          RecAboVtaServicios."Currency Factor");

                                                RecDatosSIIAProcesarDet."Tipo No sujeta" := RecConfigMultiple."Tipo No sujeta";
                                            END;

                                            // Diferencias IVA/RE a usar en cálculo de cuotas en la agrupación de impuestos.
                                            RecDatosSIIAProcesarDet."IVA Diferencia" := RecLinAboVtaServicios."VAT Difference";
                                            RecDatosSIIAProcesarDet."RE Diferencia" := RecLinAboVtaServicios."EC Difference";

                                            // Tratamiento de Criterio de caja
                                            IF RecConfigMultiple."Régimen Criterio de caja" THEN
                                                EsCriterioCaja := TRUE;

                                        END ELSE BEGIN
                                            RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                            RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de IVA SII : ' +
                                                         RecLinAboVtaServicios."VAT Bus. Posting Group" + '-' +
                                                         RecLinAboVtaServicios."VAT Prod. Posting Group" + ' inexistente.';
                                        END;
                                    END ELSE BEGIN
                                        RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                        RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de Operación SII : ' +
                                          RecLinAboVtaServicios."Gen. Prod. Posting Group" + ' inexistente.';
                                    END;

                                    RecDatosSIIAProcesarDet."Fecha obtención información" := CURRENTDATETIME;
                                    RecDatosSIIAProcesarDet.INSERT;
                                END;
                            END;
                        UNTIL RecLinAboVtaServicios.NEXT = 0;
                END;
            //210717 EX-JVN SII
            6:
                BEGIN  // GL Entry
                    GLEntry.RESET;
                    GLEntry.SETRANGE("Document No.", NoDocumento);
                    GLEntry.SETFILTER(GLEntry."Gen. Prod. Posting Group", '<>%1', '');
                    IF GLEntry.FINDSET THEN BEGIN
                        REPEAT
                            NoMov += 1;
                            RecDatosSIIAProcesarDet.RESET;
                            RecDatosSIIAProcesarDet.INIT;
                            RecDatosSIIAProcesarDet."Tipo registro" := RecDatosSIIAProcesarDet."Tipo registro"::Detalles;

                            CASE GLEntry."Document Type" OF
                                GLEntry."Document Type"::Invoice:
                                    RecDatosSIIAProcesarDet."Tipo documento" := RecDatosSIIAProcesarDet."Tipo documento"::Factura;
                                GLEntry."Document Type"::"Credit Memo":
                                    RecDatosSIIAProcesarDet."Tipo documento" := RecDatosSIIAProcesarDet."Tipo documento"::Abono;
                            END;

                            CASE GLEntry."Bal. Account Type" OF
                                GLEntry."Bal. Account Type"::Customer:
                                    BEGIN
                                        RecDatosSIIAProcesarDet."Origen documento" := RecDatosSIIAProcesarDet."Origen documento"::Emitida;
                                        RecDatosSIIAProcesarDet."Tipo procedencia" := RecDatosSIIAProcesarDet."Tipo procedencia"::Cliente;
                                    END;
                                GLEntry."Bal. Account Type"::Vendor:
                                    BEGIN
                                        RecDatosSIIAProcesarDet."Origen documento" := RecDatosSIIAProcesarDet."Origen documento"::Recibida;
                                        RecDatosSIIAProcesarDet."Tipo procedencia" := RecDatosSIIAProcesarDet."Tipo procedencia"::Proveedor;
                                    END;
                            END;

                            RecDatosSIIAProcesarDet."No. documento" := NoDocumento;
                            RecDatosSIIAProcesarDet."No. Línea" := NoMov;
                            RecDatosSIIAProcesarDet."Estado documento" := RecCabeceraDatosSII."Estado documento";

                            // Datos para desglose por tipo operación (Servicio, Entrega)
                            RecConfigMultiple.RESET;
                            RecConfigMultiple.SETRANGE("Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo operación");
                            RecConfigMultiple.SETRANGE("Gr. Contable producto", GLEntry."Gen. Prod. Posting Group");
                            IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                RecDatosSIIAProcesarDet."Desglose tipo operación" := RecConfigMultiple."Tipo operación";

                                // Datos para desglose por tipo cálculo de IVA (Sujeto-Exento,Sujeto-NoExento,No sujeto...)
                                VATEntry.RESET;
                                VATEntry.SETCURRENTKEY("Document No.", "Posting Date");
                                VATEntry.SETRANGE("Document No.", NoDocumento);
                                VATEntry.SETRANGE("Posting Date", RecCabeceraDatosSII."Fecha de registro");
                                VATEntry.SETRANGE("VAT Bus. Posting Group", GLEntry."VAT Bus. Posting Group");
                                VATEntry.SETRANGE("VAT Prod. Posting Group", GLEntry."VAT Prod. Posting Group");
                                //EX-JVN SII 090817
                                IF GLEntry.Amount < 0 THEN
                                    VATEntry.SETFILTER(Base, '<%1', 0)
                                ELSE
                                    VATEntry.SETFILTER(Base, '>=%1', 0);
                                IF VATEntry.FINDFIRST THEN;

                                RecConfigMultiple.RESET;
                                RecConfigMultiple.SETRANGE(RecConfigMultiple."Tipo configuración", RecConfigMultiple."Tipo configuración"::"Tipo IVA");
                                RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Negocio", GLEntry."VAT Bus. Posting Group");
                                RecConfigMultiple.SETRANGE(RecConfigMultiple."Gr. Reg. IVA Producto", GLEntry."VAT Prod. Posting Group");
                                IF RecConfigMultiple.FINDFIRST THEN BEGIN
                                    RecDatosSIIAProcesarDet."Inv. Sujeto Pasivo" := RecConfigMultiple."Inversión sujeto pasivo";
                                    RecDatosSIIAProcesarDet.DesgloseIVAFactura := RecConfigMultiple."Tipo desglose IVA";
                                    RecDatosSIIAProcesarDet.Sujeta := NOT ((RecConfigMultiple."Tipo cálculo IVA" =
                                                                  RecConfigMultiple."Tipo cálculo IVA"::"No Taxable VAT") OR
                                                                  (RecConfigMultiple."Tipo No sujeta" <> RecConfigMultiple."Tipo No sujeta"::" "));
                                    IF RecDatosSIIAProcesarDet.Sujeta THEN BEGIN
                                        // Exenta
                                        RecDatosSIIAProcesarDet.Exenta := RecConfigMultiple.Exento;
                                        IF RecDatosSIIAProcesarDet.Exenta THEN BEGIN
                                            RecDatosSIIAProcesarDet."Cód. causa exención" := RecConfigMultiple."Causa exención";
                                            RecDatosSIIAProcesarDet."Base Imponible exenta" := VATEntry.Base * -1;
                                        END;
                                        // No Exenta
                                        IF NOT RecDatosSIIAProcesarDet.Exenta THEN BEGIN
                                            RecDatosSIIAProcesarDet."Tipo no exenta" := RecConfigMultiple."Tipo No Exención";
                                            RecDatosSIIAProcesarDet."Tipo impositivo no exenta" := VATEntry."VAT %";
                                            RecDatosSIIAProcesarDet."Base imponible no exenta" := VATEntry.Base * -1;

                                            IF VATEntry."VAT %" + VATEntry."EC %" <> 0 THEN
                                                RecDatosSIIAProcesarDet."Cuota imp. no exenta" := VATEntry.Amount * -1;

                                            RecDatosSIIAProcesarDet."Tipo RE no exenta" := VATEntry."EC %";
                                            IF (RecDatosSIIAProcesarDet."Tipo RE no exenta" <> 0) AND (VATEntry."VAT %" + VATEntry."EC %" <> 0) THEN
                                                RecDatosSIIAProcesarDet."Cuota RE no exenta" := VATEntry.Amount * -1;
                                        END;
                                    END ELSE BEGIN
                                        // No sujeta
                                        IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Articulos 7-14-Otros" THEN
                                            RecDatosSIIAProcesarDet."Importe no sujeta Art. 7,14" := VATEntry.Amount * -1;
                                        IF RecConfigMultiple."Tipo No sujeta" = RecConfigMultiple."Tipo No sujeta"::"Reg. Localización" THEN
                                            RecDatosSIIAProcesarDet."Importe no sujeta localización" := VATEntry.Amount * -1;
                                        RecDatosSIIAProcesarDet."Base imponible no sujeta" := VATEntry.Base * -1;
                                        RecDatosSIIAProcesarDet."Tipo No sujeta" := RecConfigMultiple."Tipo No sujeta";
                                    END;

                                    // Tratamiento de Criterio de caja
                                    IF RecConfigMultiple."Régimen Criterio de caja" THEN
                                        EsCriterioCaja := TRUE;

                                END ELSE BEGIN
                                    RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                    RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de IVA SII : ' +
                                      GLEntry."VAT Bus. Posting Group" + '-' + GLEntry."VAT Prod. Posting Group" + ' inexistente.';
                                END;
                            END ELSE BEGIN
                                RecDatosSIIAProcesarDet.VALIDATE("Estado documento", RecDatosSIIAProcesarDet."Estado documento"::Incidencias);
                                RecDatosSIIAProcesarDet."Log. incidencias" := 'Configuración de Tipo de Operación SII : ' +
                                  GLEntry."Gen. Prod. Posting Group" + ' inexistente.';
                            END;
                            RecDatosSIIAProcesarDet."Fecha obtención información" := CURRENTDATETIME;
                            RecDatosSIIAProcesarDet.INSERT;
                        UNTIL GLEntry.NEXT = 0;
                    END ELSE BEGIN //Sin lineas de Detalle
                        RecCabeceraDatosSII.VALIDATE("Estado documento", RecCabeceraDatosSII."Estado documento"::Incidencias);
                        RecCabeceraDatosSII."Log. incidencias" := 'Documento sin líneas de detalle.';
                    END;
                END;
        //210717 fin
        END;

        //EX-SIIv3 220518
        IF (RecCabeceraDatosSII."Importe total documento" > 100000000) OR (RecCabeceraDatosSII."Importe total documento" < -100000000) THEN
            RecCabeceraDatosSII.MacroDato := 'S';
        //EX-SIIv3 fin

    end;


    procedure GenerarFicheros(var Par_RecDocsSIIaProcesar: Record 50601)
    var
        RecConfigEmpresa: Record 50605;
        OutFileEmitidas: File;
        ExternalFileEmitidas: Text[1024];
        OutFileRecibidas: File;
        ExternalFileRecibidas: Text[1024];
        OutTextEmitidas: Text[1024];
        OutTextRecibidas: Text[1024];
        varTab: Char;
        varSpace: Char;
        txtTab: Text[1];
        txtSpace: Text[1];
        RecDatoSIICabecera: Record 50601;
        "---------": Integer;
        RecDocsSIIaProcesar: Record 50601 temporary;
        RecDocsSIIaProcesar2: Record 50601 temporary;
        NLinea: Integer;
        LineaCabecerasTexto: Text[1024];
        FechaExport: DateTime;
        RecCabFactCompra: Record 122;
        RecCabAboCompra: Record 124;
        NumFacturaProv: Text[30];
        VarTime: Text[7];
        CandidatosRecDocsSIIaProcesar: Record 50601;
        RecCabFacCompFechaExp: Record 122;
        RecCabAboCompFechaExp: Record 124;
        FechaExpedicion: Date;
        lrec_Customer: Record Customer;
        lrec_Vendor: Record Vendor;
        LineaCabecerasTexto2: Text[1024];
        "---": Integer;
        FilePlataforma: File;
        vName: Text[30];
        recControlSIIDocumentos: Record 50601;
        pathhistorico: Text;
    begin

        varTab := 9;
        varSpace := 32;
        txtTab := FORMAT(varTab);
        txtSpace := FORMAT(varSpace);
        /*
        //EX-SIIv4 inicio
        RecConfigEmpresa.GET;
        varTab := 9;
        varSpace := 32;
        txtTab := FORMAT(varTab);
        txtSpace := FORMAT(varSpace);
        
        InFileIncidencias.RESET;
        InFileIncidencias.SETRANGE(Path,RecConfigEmpresa."Ruta ficheros SII");/////////////
        InFileIncidencias.SETRANGE("Is a file",TRUE);
        InFileIncidencias.SETFILTER(Name,'*_RespFE_*.*');
        recControlSIIDocumentos.RESET;
        recControlSIIDocumentos.SETRANGE("Origen documento",recControlSIIDocumentos."Origen documento"::Emitida);
        IF InFileIncidencias.FINDSET THEN
        REPEAT
          pathhistorico:=RecConfigEmpresa."Ruta ficheros entregados SII"+'\'+InFileIncidencias.Name;
          ProcesarRespuestaAEAT(InFileIncidencias.Path+'\'+InFileIncidencias.Name,pathhistorico,TRUE);
        UNTIL InFileIncidencias.NEXT = 0;
        
        InFileIncidencias.SETFILTER(Name,'*_RespFR_*');
        recControlSIIDocumentos.RESET;
        recControlSIIDocumentos.SETRANGE("Origen documento",recControlSIIDocumentos."Origen documento"::Recibida);
        IF InFileIncidencias.FINDSET THEN
        REPEAT
          pathhistorico:=RecConfigEmpresa."Ruta ficheros entregados SII"+'\'+InFileIncidencias.Name;
          ProcesarRespuestaAEAT(InFileIncidencias.Path+'\'+InFileIncidencias.Name,pathhistorico,FALSE);
        UNTIL InFileIncidencias.NEXT = 0;
        
        //100918 EX-JVN Control de Incidencias, generar fichero
        CLEAR(FilePlataforma);
        FilePlataforma.TEXTMODE := TRUE;
        FilePlataforma.WRITEMODE := TRUE;
        VarTime := '_'+FORMAT(TIME,6,'<Hour,2><Minute,2><Second,2>');
        VarDate := FORMAT(TODAY,8,'<Year4><Month,2><Day,2>');
        vName := RecConfigEmpresa."Ruta ficheros SII"+'\'+RecConfigEmpresa."NIF Declarante"+'_SII_'+
                                    VarDate+FORMAT(VarTime)+'.txt';
        FilePlataforma.CREATE(vName);
        FilePlataforma.WRITE(Ascii2UTF8('Tipo'+txtTab+'Estado'+txtTab+'Fecha'));
        recControlSIIDocumentos.RESET;
        recControlSIIDocumentos.SETCURRENTKEY("Estado documento","Origen documento");
        recControlSIIDocumentos.SETRANGE("Estado documento",recControlSIIDocumentos."Estado documento"::Incidencias);
        IF recControlSIIDocumentos.FINDFIRST THEN
          FilePlataforma.WRITE(Ascii2UTF8('Incidencia'+txtTab+'Si'+txtTab+FORMAT(VarDate)))
        ELSE
          FilePlataforma.WRITE(Ascii2UTF8('Incidencia'+txtTab+'No'+txtTab+FORMAT(VarDate)));
        
        recControlSIIDocumentos.SETRANGE("Estado documento",recControlSIIDocumentos."Estado documento"::"Enviado a plataforma");
        recControlSIIDocumentos.SETRANGE("Mensaje Respuesta",'');
        IF recControlSIIDocumentos.FINDFIRST THEN
          FilePlataforma.WRITE(Ascii2UTF8('EnviadoaPlataforma'+txtTab+'Si'+txtTab+FORMAT(VarDate)))
        ELSE
          FilePlataforma.WRITE(Ascii2UTF8('EnviadoaPlataforma'+txtTab+'No'+txtTab+FORMAT(VarDate)));
        
        recControlSIIDocumentos.RESET;
        recControlSIIDocumentos.SETRANGE("Estado documento",recControlSIIDocumentos."Estado documento"::"Incluido en fichero");
        recControlSIIDocumentos.SETRANGE("Tipo registro",recControlSIIDocumentos."Tipo registro"::Cabecera);
        recControlSIIDocumentos.SETRANGE("Origen documento",recControlSIIDocumentos."Origen documento"::Emitida);
        FilePlataforma.WRITE(Ascii2UTF8('FacturasEmitidas'+txtTab+FORMAT(recControlSIIDocumentos.COUNT)+txtTab+FORMAT(VarDate)));
        recControlSIIDocumentos.SETRANGE("Origen documento",recControlSIIDocumentos."Origen documento"::Recibida);
        FilePlataforma.WRITE(Ascii2UTF8('FacturasRecibidas'+txtTab+FORMAT(recControlSIIDocumentos.COUNT)+txtTab+FORMAT(VarDate)));
        
        FilePlataforma.CLOSE;
        //EX-SIIv4 end
        */
        LineaCabecerasTexto :=
        'IdVersionSII' + txtTab + 'NIFDeclarante' + txtTab + 'ApellidosNombreRazonSocialDeclarante' + txtTab + 'NIFRepresDeclarante'
        + txtTab + 'TipoComunicacion' + txtTab + 'Ejercicio' + txtTab + 'Periodo' + txtTab + 'Autorizacion' + txtTab + 'NIFEmisor' + txtTab + 'NoFactura' + txtTab +
        'NoFraResumen' + txtTab + 'FechaExpedicion' + txtTab + 'ImpTransmisionesInmuebles' + txtTab + 'FraEmitidaTerceros' + txtTab + 'FraVariosDestinos'
        + txtTab + 'MinoracionBaseImponible' + txtTab + 'ClaveTipoFactura' + txtTab + 'ApellidosNombreRazonSocial' + txtTab +
        'NIFRepresentante' + txtTab + 'NIFOperacion' + txtTab +
        'CodPais' + txtTab + 'ClaveIdFiscalPais' + txtTab + 'NIFIdPais' + txtTab + 'TipoRectificativa' + txtTab + 'FechaExpedicion' + txtTab + 'FechaOperacion'
        + txtTab + 'ImporteTotal' + txtTab + 'ClaveRegimenEspecial' + txtTab + 'BaseImponible' + txtTab + 'DescripcionOperacion' + txtTab +
        'NumeroFacturaEmisorResumenFin' + txtTab +
        'TipoDesglose' + txtTab + //EX-SGG 280617
        'DesgloseServiciosBienes' + txtTab + 'TipoNoExenta' + txtTab + '%TipoImpositivo' + txtTab + 'BaseImponibleLinea' + txtTab + 'CuotaImpuesto' + txtTab +
        'TipoRecEquivalencia' + txtTab + 'CuotaRecEquivaencia' + txtTab + 'CausaExencion' + txtTab + 'BaseImpExenta' + txtTab + 'ImporteNoSujeta7-14'
        + txtTab + 'ImporteNoSujetaLocalizacion' + txtTab +
        'ISP' + txtTab + //EX-SGG 280617
        'FechaRegContable' + txtTab + 'CuotaDeducible' + txtTab + '%CompREAGYP' + txtTab + 'ImpCompREAGYP'
        + txtTab + 'TipoOpIntracom' + txtTab + 'ClaveDeclarado' + txtTab + 'CodEstadoMiembro' + txtTab + 'PlazoOperacion' + txtTab + 'DescripcionBienes'
        + txtTab + 'DireccionOperador' + txtTab + 'OtrosDocumentos' + txtTab + 'SituacionInmueble' + txtTab + 'ReferenciaCatastral';

        //EX-SIIv3
        LineaCabecerasTexto2 :=
        txtTab + 'FacturaSinIdentifDestinatarioArticulo6_1' + txtTab + 'FacturaSimplificadaArticulos7.2_7.3' + txtTab + 'Macrodato'
        + txtTab + 'RefExterna' + txtTab + 'NombreRazonSucedida' + txtTab + 'NIFSucedida';
        //EX-SIIv3

        RecConfigEmpresa.GET;
        IF NOT RecConfigEmpresa."Proceso generación ficheros" THEN
            EXIT;

        // De cada cabecera recibida, comprobar si todas sus lineas tienen el estado "Pendiente procesar",
        // y seleccionar esas lineas como candidatas a ser exportadas
        IF Par_RecDocsSIIaProcesar.FINDSET THEN BEGIN
            CandidatosRecDocsSIIaProcesar.RESET;
            REPEAT
                Par_RecDocsSIIaProcesar.CALCFIELDS("No Lineas detalle");
                CandidatosRecDocsSIIaProcesar.SETRANGE("Tipo documento");
                CandidatosRecDocsSIIaProcesar.SETRANGE("No. documento");
                CandidatosRecDocsSIIaProcesar.SETRANGE("Tipo registro");
                CandidatosRecDocsSIIaProcesar.SETRANGE("Origen documento");
                CandidatosRecDocsSIIaProcesar.SETRANGE("Estado documento");
                CandidatosRecDocsSIIaProcesar.SETRANGE("Tipo DUA"); //EX-SMN 101117

                CandidatosRecDocsSIIaProcesar.SETRANGE("Tipo documento", Par_RecDocsSIIaProcesar."Tipo documento");
                CandidatosRecDocsSIIaProcesar.SETRANGE("No. documento", Par_RecDocsSIIaProcesar."No. documento");
                CandidatosRecDocsSIIaProcesar.SETRANGE("Tipo registro", CandidatosRecDocsSIIaProcesar."Tipo registro"::Detalles);
                CandidatosRecDocsSIIaProcesar.SETRANGE("Origen documento", Par_RecDocsSIIaProcesar."Origen documento");
                CandidatosRecDocsSIIaProcesar.SETRANGE("Estado documento", Par_RecDocsSIIaProcesar."Estado documento");

                //EX-SMN 101117
                IF Par_RecDocsSIIaProcesar."No. documento" = Par_RecDocsSIIaProcesar."No Doc. DUA" THEN //es un factura ficticia DUA
                    CandidatosRecDocsSIIaProcesar.SETRANGE("Tipo DUA")
                ELSE
                    CandidatosRecDocsSIIaProcesar.SETFILTER("Tipo DUA", '<>%1&<>%2', CandidatosRecDocsSIIaProcesar."Tipo DUA"::Transitario,
                     CandidatosRecDocsSIIaProcesar."Tipo DUA"::Excluir); //111017 EX-JVN
                                                                         //EX-SMN FIN

                IF CandidatosRecDocsSIIaProcesar.FINDSET THEN
                    REPEAT
                        CandidatosRecDocsSIIaProcesar.MARK(TRUE); // Solo marcamos candidatos de detalle si todas tienen mismo estado que cabecera
                    UNTIL CandidatosRecDocsSIIaProcesar.NEXT = 0;
            UNTIL Par_RecDocsSIIaProcesar.NEXT = 0;
        END;

        CandidatosRecDocsSIIaProcesar.SETRANGE("Tipo documento");
        CandidatosRecDocsSIIaProcesar.SETRANGE("No. documento");
        CandidatosRecDocsSIIaProcesar.SETRANGE("Tipo registro");
        CandidatosRecDocsSIIaProcesar.SETRANGE("Origen documento");
        CandidatosRecDocsSIIaProcesar.SETRANGE("Estado documento");
        CandidatosRecDocsSIIaProcesar.SETRANGE("Tipo DUA"); //EX-SMN 101117

        //AgruparImpuestos(Par_RecDocsSIIaProcesar,RecDocsSIIaProcesar,TRUE);
        CandidatosRecDocsSIIaProcesar.MARKEDONLY(TRUE);
        AgruparImpuestos(CandidatosRecDocsSIIaProcesar, RecDocsSIIaProcesar, TRUE);

        VarTime := '_' + FORMAT(TIME, 6, '<Hour,2><Minute,2><Second,2>'); //EX-OMI 301017

        RecDocsSIIaProcesar.RESET; // Es temporal y viene ya agrupada.
        IF RecDocsSIIaProcesar.FINDSET THEN BEGIN
            // Creamos dos ficheros y vamos añadiendo en uno u otro según se trate de documento de ventas o compras.
            // Fichero para emitidas
            OutFileEmitidas.TEXTMODE := TRUE;
            OutFileEmitidas.WRITEMODE := TRUE;

            /*EX-AHG SII+ 130717*/
            VarTime := '_' + FORMAT(TIME, 6, '<Hour,2><Minute,2><Second,2>');
            //ExternalFileEmitidas := RecConfigEmpresa."Ruta ficheros SII"+'\'+RecConfigEmpresa."NIF Declarante"+'_LRFE_'+
            //                        FORMAT(TODAY,8,'<Year4><Month,2><Day,2>')+'.txt';
            ExternalFileEmitidas := RecConfigEmpresa."Ruta ficheros SII" + '\' + RecConfigEmpresa."NIF Declarante" + '_LRFE_' +
                                    FORMAT(TODAY, 8, '<Year4><Month,2><Day,2>') +
                                    FORMAT(VarTime);//+'.txt'; //EX-RBF 010321 Inicio
            IF GUIALLOWED THEN ExternalFileEmitidas += 'MANUAL';
            ExternalFileEmitidas += '.txt';
            //EX-RBF 010321 Fin

            /*EX-AHG SII+ 130717*/


            OutFileEmitidas.CREATE(ExternalFileEmitidas);
            CLEAR(OutTextEmitidas);
            // Fichero para recibidas
            OutFileRecibidas.TEXTMODE := TRUE;
            OutFileRecibidas.WRITEMODE := TRUE;

            /*EX-AHG SII+ 130717*/
            VarTime := '_' + FORMAT(TIME, 6, '<Hour,2><Minute,2><Second,2>');
            //ExternalFileRecibidas := RecConfigEmpresa."Ruta ficheros SII"+'\'+RecConfigEmpresa."NIF Declarante"+'_LRFR_'+
            //                        FORMAT(TODAY,8,'<Year4><Month,2><Day,2>')+'.txt';
            ExternalFileRecibidas := RecConfigEmpresa."Ruta ficheros SII" + '\' + RecConfigEmpresa."NIF Declarante" + '_LRFR_' +
                                    FORMAT(TODAY, 8, '<Year4><Month,2><Day,2>') +
                                    FORMAT(VarTime);//+'.txt'; //EX-RBF 010321 Inicio
            IF GUIALLOWED THEN ExternalFileRecibidas += 'MANUAL';
            ExternalFileRecibidas += '.txt';
            //EX-RBF 010321 Fin
            /*EX-AHG SII+ 130717*/

            OutFileRecibidas.CREATE(ExternalFileRecibidas);
            CLEAR(OutTextRecibidas);

            //EX-OMI 041017
            //EX-SIIv3 230518
            //OutFileEmitidas.WRITE(Ascii2UTF8(LineaCabecerasTexto));
            OutFileEmitidas.WRITE(Ascii2UTF8(LineaCabecerasTexto) + Ascii2UTF8(LineaCabecerasTexto2));
            //OutFileRecibidas.WRITE(Ascii2UTF8(LineaCabecerasTexto));
            OutFileRecibidas.WRITE(Ascii2UTF8(LineaCabecerasTexto) + Ascii2UTF8(LineaCabecerasTexto2));
            //EX-SIIv3 FIN

            FechaExport := CURRENTDATETIME;
            REPEAT
                // Localizamos el registro de tipo cabecera para utilizar sus datos en los detalles del fichero de texto.
                RecDatoSIICabecera.SETRANGE(RecDatoSIICabecera."Tipo documento", RecDocsSIIaProcesar."Tipo documento");
                RecDatoSIICabecera.SETRANGE(RecDatoSIICabecera."No. documento", RecDocsSIIaProcesar."No. documento");
                RecDatoSIICabecera.SETRANGE(RecDatoSIICabecera."Tipo registro", RecDatoSIICabecera."Tipo registro"::Cabecera);
                RecDatoSIICabecera.SETRANGE("Origen documento", RecDocsSIIaProcesar."Origen documento"); //260218 EX-JVN
                IF RecDatoSIICabecera.FINDFIRST THEN BEGIN
                    CASE TRUE OF
                        RecDocsSIIaProcesar."Origen documento" = RecDocsSIIaProcesar."Origen documento"::Emitida:
                            BEGIN
                                // Cabecera SII
                                OutTextEmitidas := RecConfigEmpresa."Id versión SII" + txtTab + RecConfigEmpresa."NIF Declarante" + txtTab +
                                                  RecConfigEmpresa."Apell. Nombre.- Razón social" + txtTab +
                                                  RecConfigEmpresa."NIF Representante legal" + txtTab + FORMAT(RecDatoSIICabecera."Tipo comunicación") + txtTab;
                                // Datos periodo
                                OutTextEmitidas += FORMAT(RecDatoSIICabecera.Ejercicio) + txtTab + RecDatoSIICabecera.Periodo + txtTab +
                                                  RecConfigEmpresa."Nº registro envío autorización" + txtTab;

                                // Identificación factura
                                OutTextEmitidas += RecConfigEmpresa."NIF Declarante" + txtTab +
                                                  RecDocsSIIaProcesar."No. documento" + txtTab +
                                                  RecDatoSIICabecera."Factura resumen inicial" + txtTab +
                                                  FORMAT(RecDatoSIICabecera."Fecha de registro") + txtTab;
                                // Datos específicos Emitidas
                                OutTextEmitidas += FORMAT(RecDatoSIICabecera."Importe transmisiones inmueble") + txtTab +
                                                  RecDatoSIICabecera."Emitida por terceros" + txtTab +
                                                  RecDatoSIICabecera."Varios destinatarios" + txtTab +
                                                  RecDatoSIICabecera."Minoración base imponible" + txtTab;
                                //  Común
                                OutTextEmitidas += RecDatoSIICabecera."Tipo factura" + txtTab;

                                // Contraparte
                                OutTextEmitidas += RecDatoSIICabecera."Nombre procedencia" + txtTab +
                                                  RecDatoSIICabecera."NIF Representante legal" + txtTab +
                                                  RecDatoSIICabecera."NIF Contraparte operación" + txtTab +
                                                  RecDatoSIICabecera."Cód. país contraparte" + txtTab +
                                                  RecDatoSIICabecera."Clave Id. fiscal residencia" + txtTab +
                                                  RecDatoSIICabecera."NIF/ID. fiscal país residencia" + txtTab;

                                // Datos Factura-DUA
                                OutTextEmitidas += RecDatoSIICabecera."Tipo factura rectificativa" + txtTab +
                                                  FORMAT(RecDatoSIICabecera."Fecha de registro") + txtTab +
                                                  //EX-AHG 270917
                                                  //FORMAT(RecDatoSIICabecera."Fecha de registro")+txtTab+
                                                  FORMAT(RecDatoSIICabecera."Fecha operación") + txtTab +
                                                  //EX-AHG FIN
                                                  FORMAT(ROUND(RecDatoSIICabecera."Importe total documento", 0.01)) + txtTab +
                                                  RecDatoSIICabecera."Clave régimen especial" + txtTab +
                                                  FORMAT(RecDatoSIICabecera."Total Base imponible") + txtTab +
                                                  RecDatoSIICabecera."Descripción documento" + txtTab;

                                // NumeroFinalFacturaResumen
                                OutTextEmitidas += RecDatoSIICabecera."Factura resumen final" + txtTab;

                                // Desglose Común
                                OutTextEmitidas += RecDocsSIIaProcesar.DesgloseIVAFactura + txtTab; //EX-SGG 280617
                                OutTextEmitidas += RecDocsSIIaProcesar."Desglose tipo operación" + txtTab +
                                                  RecDocsSIIaProcesar."Tipo no exenta" + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Tipo impositivo no exenta") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Base imponible no exenta") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Cuota imp. no exenta") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Tipo RE no exenta") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Cuota RE no exenta") + txtTab;

                                // Desglose Emitidas
                                OutTextEmitidas += RecDocsSIIaProcesar."Cód. causa exención" + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Base Imponible exenta") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Importe no sujeta Art. 7,14") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Importe no sujeta localización") + txtTab;

                                // Desglose Recibidas
                                OutTextEmitidas += COPYSTR(FORMAT(RecDocsSIIaProcesar."Inv. Sujeto Pasivo"), 1, 1) + txtTab; //EX-SGG 280617
                                OutTextEmitidas += txtSpace + txtTab +
                                                  FORMAT(RecDatoSIICabecera."Cuota deducible") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."% Compensación REAGYP") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Importe Compensación REAGYP") + txtTab;

                                // Operaciones intracomunitarias
                                OutTextEmitidas += RecDatoSIICabecera."Tipo Op. Intracomunitaria" + txtTab +
                                                  RecDatoSIICabecera."Clave declarado" + txtTab +
                                                  RecDatoSIICabecera."Cód. estado origen/envío" + txtTab +
                                                  FORMAT(RecDatoSIICabecera."Plazo operación") + txtTab +
                                                  RecDatoSIICabecera."Descripción bienes" + txtTab +
                                                  RecDatoSIICabecera."Dirección operador intracom." + txtTab +
                                                  RecDatoSIICabecera."Otra documentación" + txtTab;
                                // Otros datos - Inmuebles
                                OutTextEmitidas += RecDatoSIICabecera."Situación Inmueble" + txtTab +
                                                  RecDatoSIICabecera."Ref. catastral Inmueble";

                                //EX-SIIv3 220518
                                OutTextEmitidas += txtTab + RecDatoSIICabecera."Factura SinIdentifDestinatario" + txtTab +
                                RecDatoSIICabecera.FacturaSimplificadaArticulos + txtTab +
                                RecDatoSIICabecera.MacroDato + txtTab;
                                //EX-SIIv3fin

                                //EX-SIIv3 070618
                                IF lrec_Customer.GET(RecDatoSIICabecera."Cód. procedencia") THEN BEGIN
                                    OutTextEmitidas += txtTab + lrec_Customer."NIF Entidad Sucedida";
                                    OutTextEmitidas += txtTab + lrec_Customer."Razon Social Entidad Sucedida";
                                END;
                                //EX-SIIv3 fin

                                // Llamada a función que busca datos por documento según el Nombre del nodo XML
                                //Campo := BuscaDatoEnDocumento(RecDocsSIIaProcesar."Tipo documento"+2,RecDocsSIIaProcesar."No. documento",
                                //                             'NombreDatoNodoXml');
                                //EX-OMI 031017
                                OutFileEmitidas.WRITE(Ascii2UTF8(OutTextEmitidas));

                                /*EX-AHG SII+ 130717 - INI*/
                                //RecDatoSIICabecera."Incluido en fichero":= RecConfigEmpresa."NIF Declarante"+'_LRFE_'+
                                //                                           FORMAT(TODAY,8,'<Year4><Month,2><Day,2>')+'.txt';;
                                RecDatoSIICabecera."Incluido en fichero" := RecConfigEmpresa."NIF Declarante" + '_LRFE_' +
                                                                           FORMAT(TODAY, 8, '<Year4><Month,2><Day,2>') +
                                                                           FORMAT(VarTime);//+'.txt';  //EX-RBF 010321 Inicio
                                IF GUIALLOWED THEN RecDatoSIICabecera."Incluido en fichero" += 'MANUAL';
                                RecDatoSIICabecera."Incluido en fichero" += '.txt';
                                //EX-RBF 010321 Fin
                                /*EX-AHG SII+ 130717 - INI*/

                            END;
                        RecDocsSIIaProcesar."Origen documento" = RecDocsSIIaProcesar."Origen documento"::Recibida:
                            BEGIN
                                // Cabecera SII
                                OutTextRecibidas := RecConfigEmpresa."Id versión SII" + txtTab + RecConfigEmpresa."NIF Declarante" + txtTab +
                                                  RecConfigEmpresa."Apell. Nombre.- Razón social" + txtTab +
                                                  RecConfigEmpresa."NIF Representante legal" + txtTab + FORMAT(RecDatoSIICabecera."Tipo comunicación") + txtTab;
                                // Datos periodo
                                OutTextRecibidas += FORMAT(RecDatoSIICabecera.Ejercicio) + txtTab + RecDatoSIICabecera.Periodo + txtTab +
                                                  RecConfigEmpresa."Nº registro envío autorización" + txtTab;

                                //EX-SIIv3 220518
                                CLEAR(FechaExpedicion); //EX-SIIv3 070818
                                IF RecDocsSIIaProcesar."Tipo documento" = RecDocsSIIaProcesar."Tipo documento"::Factura THEN BEGIN
                                    IF RecCabFacCompFechaExp.GET(RecDocsSIIaProcesar."No. documento") THEN
                                        FechaExpedicion := RecCabFacCompFechaExp."Document Date"
                                END ELSE
                                    IF RecDocsSIIaProcesar."Tipo documento" = RecDocsSIIaProcesar."Tipo documento"::Abono THEN BEGIN
                                        IF RecCabAboCompFechaExp.GET(RecDocsSIIaProcesar."No. documento") THEN
                                            FechaExpedicion := RecCabAboCompFechaExp."Document Date"
                                    END ELSE
                                        IF FechaExpedicion = 0D THEN
                                            FechaExpedicion := RecDatoSIICabecera."Fecha de registro";
                                //EX-SIIv3 FIN

                                // Identificación factura
                                OutTextRecibidas += RecDatoSIICabecera."NIF Contraparte operación" + txtTab +
                                                  RecDatoSIICabecera."Nº Doc. proveedor" + txtTab +
                                                  RecDatoSIICabecera."Factura resumen inicial" + txtTab +
                                                  //EX-SIIv3 220518
                                                  //FORMAT(RecDatoSIICabecera."Fecha de registro")+txtTab;
                                                  FORMAT(FechaExpedicion) + txtTab;
                                //EX-SIIv3 FIN


                                // Datos específicos Emitidas
                                OutTextRecibidas += FORMAT(RecDatoSIICabecera."Importe transmisiones inmueble") + txtTab +
                                                  RecDatoSIICabecera."Emitida por terceros" + txtTab +
                                                  RecDatoSIICabecera."Varios destinatarios" + txtTab +
                                                  RecDatoSIICabecera."Minoración base imponible" + txtTab;
                                // Común
                                OutTextRecibidas += RecDatoSIICabecera."Tipo factura" + txtTab;

                                // Contraparte
                                OutTextRecibidas += RecDatoSIICabecera."Nombre procedencia" + txtTab +
                                                  RecDatoSIICabecera."NIF Representante legal" + txtTab +
                                                  RecDatoSIICabecera."NIF Contraparte operación" + txtTab +
                                                  RecDatoSIICabecera."Cód. país contraparte" + txtTab +
                                                  RecDatoSIICabecera."Clave Id. fiscal residencia" + txtTab +
                                                  RecDatoSIICabecera."NIF/ID. fiscal país residencia" + txtTab;

                                // Datos Factura-DUA
                                OutTextRecibidas += RecDatoSIICabecera."Tipo factura rectificativa" + txtTab +
                                                  FORMAT(RecDatoSIICabecera."Fecha de registro") + txtTab +
                                                  //EX-AHG 270917
                                                  //FORMAT(RecDatoSIICabecera."Fecha de registro")+txtTab+
                                                  FORMAT(RecDatoSIICabecera."Fecha operación") + txtTab +
                                                  //EX-AHG FIN
                                                  FORMAT(ROUND(RecDatoSIICabecera."Importe total documento", 0.01)) + txtTab +
                                                  RecDatoSIICabecera."Clave régimen especial" + txtTab +
                                                  FORMAT(RecDatoSIICabecera."Total Base imponible") + txtTab +
                                                  RecDatoSIICabecera."Descripción documento" + txtTab;

                                // NumeroFinalFacturaResumen
                                OutTextRecibidas += RecDatoSIICabecera."Factura resumen final" + txtTab;

                                // Desglose Común
                                OutTextRecibidas += RecDocsSIIaProcesar.DesgloseIVAFactura + txtTab; //EX-SGG 280617
                                OutTextRecibidas += RecDocsSIIaProcesar."Desglose tipo operación" + txtTab +
                                                  RecDocsSIIaProcesar."Tipo no exenta" + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Tipo impositivo no exenta") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Base imponible no exenta") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Cuota imp. no exenta") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Tipo RE no exenta") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Cuota RE no exenta") + txtTab;

                                // Desglose Emitidas
                                OutTextRecibidas += RecDocsSIIaProcesar."Cód. causa exención" + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Base Imponible exenta") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Importe no sujeta Art. 7,14") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Importe no sujeta localización") + txtTab;

                                // Desglose Recibidas
                                OutTextRecibidas += COPYSTR(FORMAT(RecDocsSIIaProcesar."Inv. Sujeto Pasivo"), 1, 1) + txtTab; //EX-SGG 280617
                                OutTextRecibidas += FORMAT(RecDatoSIICabecera."Fecha requerida envío control") + txtTab +
                                                  FORMAT(RecDatoSIICabecera."Cuota deducible") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."% Compensación REAGYP") + txtTab +
                                                  FORMAT(RecDocsSIIaProcesar."Importe Compensación REAGYP") + txtTab;

                                // Operaciones intracomunitarias
                                OutTextRecibidas += RecDatoSIICabecera."Tipo Op. Intracomunitaria" + txtTab +
                                                  RecDatoSIICabecera."Clave declarado" + txtTab +
                                                  RecDatoSIICabecera."Cód. estado origen/envío" + txtTab +
                                                  FORMAT(RecDatoSIICabecera."Plazo operación") + txtTab +
                                                  RecDatoSIICabecera."Descripción bienes" + txtTab +
                                                  RecDatoSIICabecera."Dirección operador intracom." + txtTab +
                                                  RecDatoSIICabecera."Otra documentación" + txtTab;
                                // Otros datos - Inmuebles
                                OutTextRecibidas += RecDatoSIICabecera."Situación Inmueble" + txtTab +
                                                  RecDatoSIICabecera."Ref. catastral Inmueble";

                                //EX-SIIv3 220518
                                OutTextRecibidas += txtTab + RecDatoSIICabecera."Factura SinIdentifDestinatario" + txtTab +
                                RecDatoSIICabecera.FacturaSimplificadaArticulos + txtTab +
                                RecDatoSIICabecera.MacroDato + txtTab;
                                //EX-SIIv3 fin

                                //EX-SIIv3 070618
                                IF lrec_Vendor.GET(RecDatoSIICabecera."Cód. procedencia") THEN BEGIN
                                    OutTextRecibidas += txtTab + lrec_Vendor."NIF Entidad Sucedida";
                                    OutTextRecibidas += txtTab + lrec_Vendor."Razon Social Entidad Sucedida";
                                END;
                                //EX-SIIv3 fin

                                // Llamada a función que busca datos por documento según el Nombre del nodo XML
                                //Campo := BuscaDatoEnDocumento(RecDocsSIIaProcesar."Tipo documento"+2,RecDocsSIIaProcesar."No. documento",
                                //                             'NombreDatoNodoXml');
                                //EX-OMI 031017
                                OutFileRecibidas.WRITE(Ascii2UTF8(OutTextRecibidas));

                                /*EX-AHG SII+ 130717 - INI*/
                                //RecDatoSIICabecera."Incluido en fichero":= RecConfigEmpresa."NIF Declarante"+'_LRFR_'+
                                //                                           FORMAT(TODAY,8,'<Year4><Month,2><Day,2>')+'.txt';;
                                RecDatoSIICabecera."Incluido en fichero" := RecConfigEmpresa."NIF Declarante" + '_LRFR_' +
                                                                           FORMAT(TODAY, 8, '<Year4><Month,2><Day,2>') +
                                                                           FORMAT(VarTime);//+'.txt';  //EX-RBF 010321 Inicio

                                IF GUIALLOWED THEN RecDatoSIICabecera."Incluido en fichero" += 'MANUAL';
                                RecDatoSIICabecera."Incluido en fichero" += '.txt';
                                //EX-RBF 010321 Fin
                                /*EX-AHG SII+ 130717 - INI*/



                            END;
                        RecDocsSIIaProcesar."Origen documento" = RecDocsSIIaProcesar."Origen documento"::"B.I.":
                            BEGIN
                                // NO Desarrollado a fecha 24/05/17
                            END;
                    END;
                    //260218 EX-JVN
                    //RecDatoSIICabecera."Estado documento":=RecDatoSIICabecera."Estado documento"::"Incluido en fichero";
                    RecDatoSIICabecera.VALIDATE("Estado documento", RecDatoSIICabecera."Estado documento"::"Incluido en fichero");
                    //260218 EX-JVN FIN
                    RecDatoSIICabecera."Fecha exportación ficheros" := FechaExport;
                    RecDatoSIICabecera.MODIFY;
                END;
            UNTIL RecDocsSIIaProcesar.NEXT = 0;
        END;
        //100918 EX-JVN Importar respuesta AEAT
        //EX-SIIv4 inicio
        /*
        InFileIncidencias.RESET;
        InFileIncidencias.SETRANGE(Path,RecConfigEmpresa."Ruta ficheros SII");/////////////
        InFileIncidencias.SETRANGE("Is a file",TRUE);
        InFileIncidencias.SETFILTER(Name,'*_RespFE_*.*');
        recControlSIIDocumentos.RESET;
        recControlSIIDocumentos.SETRANGE("Origen documento",recControlSIIDocumentos."Origen documento"::Emitida);
        IF InFileIncidencias.FINDSET THEN
        REPEAT
          pathhistorico:=RecConfigEmpresa."Ruta ficheros entregados SII"+'\'+InFileIncidencias.Name;
          ProcesarRespuestaAEAT(InFileIncidencias.Path+'\'+InFileIncidencias.Name,pathhistorico,TRUE);
        UNTIL InFileIncidencias.NEXT = 0;
        
        InFileIncidencias.SETFILTER(Name,'*_RespFR_*');
        recControlSIIDocumentos.RESET;
        recControlSIIDocumentos.SETRANGE("Origen documento",recControlSIIDocumentos."Origen documento"::Recibida);
        IF InFileIncidencias.FINDSET THEN
        REPEAT
          pathhistorico:=RecConfigEmpresa."Ruta ficheros entregados SII"+'\'+InFileIncidencias.Name;
          ProcesarRespuestaAEAT(InFileIncidencias.Path+'\'+InFileIncidencias.Name,pathhistorico,FALSE);
        UNTIL InFileIncidencias.NEXT = 0;
        
        //100918 EX-JVN Control de Incidencias, generar fichero
        CLEAR(FilePlataforma);
        FilePlataforma.TEXTMODE := TRUE;
        FilePlataforma.WRITEMODE := TRUE;
        VarTime := '_'+FORMAT(TIME,6,'<Hour,2><Minute,2><Second,2>');
        VarDate := FORMAT(TODAY,8,'<Year4><Month,2><Day,2>');
        vName := RecConfigEmpresa."Ruta ficheros SII"+'\'+RecConfigEmpresa."NIF Declarante"+'_SII_'+
                                    VarDate+FORMAT(VarTime)+'.txt';
        FilePlataforma.CREATE(vName);
        FilePlataforma.WRITE(Ascii2UTF8('Tipo'+txtTab+'Estado'+txtTab+'Fecha'));
        recControlSIIDocumentos.RESET;
        recControlSIIDocumentos.SETCURRENTKEY("Estado documento","Origen documento");
        recControlSIIDocumentos.SETRANGE("Estado documento",recControlSIIDocumentos."Estado documento"::Incidencias);
        IF recControlSIIDocumentos.FINDFIRST THEN
          FilePlataforma.WRITE(Ascii2UTF8('Incidencia'+txtTab+'Si'+txtTab+FORMAT(VarDate)))
        ELSE
          FilePlataforma.WRITE(Ascii2UTF8('Incidencia'+txtTab+'No'+txtTab+FORMAT(VarDate)));
        
        recControlSIIDocumentos.SETRANGE("Estado documento",recControlSIIDocumentos."Estado documento"::"Enviado a plataforma");
        recControlSIIDocumentos.SETRANGE("Mensaje Respuesta",'');
        IF recControlSIIDocumentos.FINDFIRST THEN
          FilePlataforma.WRITE(Ascii2UTF8('EnviadoaPlataforma'+txtTab+'Si'+txtTab+FORMAT(VarDate)))
        ELSE
          FilePlataforma.WRITE(Ascii2UTF8('EnviadoaPlataforma'+txtTab+'No'+txtTab+FORMAT(VarDate)));
        
        recControlSIIDocumentos.RESET;
        recControlSIIDocumentos.SETRANGE("Estado documento",recControlSIIDocumentos."Estado documento"::"Incluido en fichero");
        recControlSIIDocumentos.SETRANGE("Tipo registro",recControlSIIDocumentos."Tipo registro"::Cabecera);
        recControlSIIDocumentos.SETRANGE("Origen documento",recControlSIIDocumentos."Origen documento"::Emitida);
        FilePlataforma.WRITE(Ascii2UTF8('FacturasEmitidas'+txtTab+FORMAT(recControlSIIDocumentos.COUNT)+txtTab+FORMAT(VarDate)));
        recControlSIIDocumentos.SETRANGE("Origen documento",recControlSIIDocumentos."Origen documento"::Recibida);
        FilePlataforma.WRITE(Ascii2UTF8('FacturasRecibidas'+txtTab+FORMAT(recControlSIIDocumentos.COUNT)+txtTab+FORMAT(VarDate)));
        
        FilePlataforma.CLOSE;
        */
        //EX-SIIv4 end

    end;


    procedure BuscaDatoEnDocumento(TipoDocumento: Integer; NoDocumento: Code[20]; NombreNodoXML: Text[250]) ValorDatoSII: Code[250]
    var
        RecDatosSIIDocumento: Record "SII- Datos documento";
    begin
        // Busca el dato en el documento, y devuelve el valor

        RecDatosSIIDocumento.RESET;
        RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento."Tipo documento", TipoDocumento);
        RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento."No. Documento", NoDocumento);
        RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento."Dato SII a exportar como", NombreNodoXML);
        IF RecDatosSIIDocumento.FINDFIRST THEN
            ValorDatoSII := RecDatosSIIDocumento."Valor dato SII";
    end;


    /// <summary>
    /// CamposObligatorios.
    /// </summary>
    /// <param name="TipoDocumento">enum "Sii Tipo Documento".</param>
    /// <param name="OrigenDocumento">Enum "Sii Origen Documento".</param>
    /// <param name="NoDocumento">Code[20].</param>
    /// <param name="TextoError">VAR Text[250].</param>
    /// <returns>Return variable HayError of type Boolean.</returns>
    procedure CamposObligatorios(TipoDocumento: enum "Sii Tipos Documento"; OrigenDocumento: Enum "Sii Origen Documento"; NoDocumento: Code[20]; var TextoError: Text[250]) HayError: Boolean
    var
        RecDatosSIIDocumento: Record "SII- Datos documento";
        RecCab: Integer;
        RecConfigDatos: Record "SII- Config. múltiple";
    begin
        // Comprueba si entre los datos SII del documento, hay alguno Obligatorio que no tenga valor.
        // Función para ser llamada con los registros ya obtenidos en ControlDocumentosSII.
        // TipoDocumento= 0:Factura, 1:Abono, 2:B.I. , 13:Factura servicios , 14:Abono Servicios
        // Origen       = 0:Emitida, 1:Recibida, 2:B.I.


        RecConfigDatos.RESET;
        RecConfigDatos.SETRANGE(RecConfigDatos."Tipo configuración", RecConfigDatos."Tipo configuración"::"Datos por documento");
        RecConfigDatos.SETRANGE(RecConfigDatos.Obligatorio, TRUE);
        IF OrigenDocumento = OrigenDocumento::Emitida THEN
            RecConfigDatos.SETRANGE(RecConfigDatos."Informar en documento", RecConfigDatos."Informar en documento"::Expedido)
        ELSE
            RecConfigDatos.SETRANGE(RecConfigDatos."Informar en documento", RecConfigDatos."Informar en documento"::Recibido);
        IF TipoDocumento.AsInteger() IN [0, 13] THEN
            RecConfigDatos.SETRANGE(RecConfigDatos."Tipo de documento", RecConfigDatos."Tipo de documento"::Facturas);
        IF TipoDocumento.AsInteger() IN [1, 14] THEN
            RecConfigDatos.SETRANGE(RecConfigDatos."Tipo de documento", RecConfigDatos."Tipo de documento"::Abonos);
        IF RecConfigDatos.FINDSET THEN
            REPEAT  // Por cada Obligatorio configurado en el maestro , localizar el mismo dato en el documento.

                RecDatosSIIDocumento.RESET;
                CASE TRUE OF
                    OrigenDocumento.AsInteger() = 0: // Ventas
                        BEGIN
                            CASE TRUE OF
                                TipoDocumento.AsInteger() = 0:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Factura emitida reg.");
                                TipoDocumento.AsInteger() = 1:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Abono emitido reg.");
                                TipoDocumento.AsInteger() = 2:
                                    ;
                                TipoDocumento.AsInteger() = 13:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Srv Factura reg.");
                                TipoDocumento.AsInteger() = 14:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Srv Abono reg.");

                            END;
                        END;
                    OrigenDocumento.AsInteger() = 1: // Compras
                        BEGIN
                            CASE TRUE OF
                                TipoDocumento.AsInteger() = 0:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Factura recibida reg.");
                                TipoDocumento.AsInteger() = 1:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Abono recibido reg.");
                                TipoDocumento.AsInteger() = 2:
                                    ;
                            END;
                        END;

                END;
                RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento."No. Documento", NoDocumento);
                RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento."Dato SII a exportar como", RecConfigDatos."Dato SII a exportar como");

                IF RecDatosSIIDocumento.FINDFIRST THEN BEGIN
                    REPEAT
                        IF (RecDatosSIIDocumento.Obligatorio) AND (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                            HayError := TRUE;
                            TextoError := RecDatosSIIDocumento."Dato SII" + ': Obligatorio.'
                        END;
                    UNTIL RecDatosSIIDocumento.NEXT = 0;
                END ELSE BEGIN
                    BEGIN
                        HayError := TRUE;
                        TextoError := 'No se encuentran todos los datos obligatorios para el SII.'
                    END;
                END;

            UNTIL RecConfigDatos.NEXT = 0;

        // Dentro del documento, comprobar si todos los marcadios como obligatorios tienen valor

        RecDatosSIIDocumento.RESET;
        RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento."No. Documento", NoDocumento);
        RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento.Obligatorio, TRUE);
        IF RecDatosSIIDocumento.FINDFIRST THEN
            REPEAT
                IF RecDatosSIIDocumento."Valor dato SII" = '' THEN BEGIN
                    HayError := TRUE;
                    TextoError := 'El dato SII ' + RecDatosSIIDocumento."Dato SII" + ' del Documento ' + NoDocumento +
                    ', es obligatorio y no est  informado.';
                END;
            UNTIL RecDatosSIIDocumento.NEXT = 0;
    end;


    procedure SubirFTP()
    var
        v_fichero: File;
        mFile: Record 2000000022;
        Listado: File;
        Archivo: Text[1024];
        RecDocumentosSII: Record 50601;
        RecDocumentosSII2: Record 50601;
        //  process: DotNet Process;
        RecDocCyP: Record 50604;
    begin

        Pt_InfoEmpresa.GET;

        // Abrir y leer ficheros para localizar documentos y cambirlos de Estado a "Enviado a plataforma"
        mFile.RESET;
        mFile.SETRANGE(Path, Pt_InfoEmpresa."Ruta ficheros SII");
        mFile.SETFILTER(Name, '*LRF*.txt');
        IF mFile.FINDSET THEN
            REPEAT
                // "EC" indica fichero de cobros. "RP" indica fichero de pagos.
                IF (STRPOS(mFile.Name, 'EC') = 0) AND (STRPOS(mFile.Name, 'RP') = 0) THEN BEGIN // Es Fichero de facturas
                    RecDocumentosSII.RESET;
                    RecDocumentosSII.SETRANGE(RecDocumentosSII."Incluido en fichero", mFile.Name);
                    IF RecDocumentosSII.FINDSET THEN
                        REPEAT
                            //260218 EX-JVN
                            //RecDocumentosSII."Estado documento":=RecDocumentosSII."Estado documento"::"Enviado a plataforma";
                            RecDocumentosSII.VALIDATE("Estado documento", RecDocumentosSII."Estado documento"::"Enviado a plataforma");
                            //260218 EX-JVN FIN
                            RecDocumentosSII.MODIFY;
                            IF RecDocumentosSII."Tipo registro" = RecDocumentosSII."Tipo registro"::Cabecera THEN BEGIN
                                RecDocumentosSII2.RESET;
                                RecDocumentosSII2.SETRANGE("Tipo registro", RecDocumentosSII2."Tipo registro"::Detalles);
                                RecDocumentosSII2.SETRANGE("Tipo documento", RecDocumentosSII."Tipo documento");
                                RecDocumentosSII2.SETRANGE("No. documento", RecDocumentosSII."No. documento");
                                RecDocumentosSII2.SETRANGE("Origen documento", RecDocumentosSII."Origen documento"); //260218 EX-JVN
                                IF RecDocumentosSII2.FINDSET THEN
                                    RecDocumentosSII2.MODIFYALL("Estado documento", RecDocumentosSII2."Estado documento"::"Enviado a plataforma");
                            END;
                        UNTIL RecDocumentosSII.NEXT = 0;
                    //EX-SMN 191017
                    //END;
                END ELSE BEGIN
                    RecDocCyP.RESET;
                    RecDocCyP.SETRANGE(RecDocCyP."Incluido en fichero", mFile.Name);
                    IF RecDocCyP.FINDSET THEN
                        REPEAT
                            //260218 EX-JVN
                            //RecDocCyP."Estado documento":=RecDocCyP."Estado documento"::"Enviado a plataforma";
                            RecDocCyP.VALIDATE("Estado documento", RecDocCyP."Estado documento"::"Enviado a plataforma");
                            //260218 EX-JVN FIN
                            RecDocCyP.MODIFY;
                        UNTIL RecDocCyP.NEXT = 0;
                END;
            //EX-SMN FIN
            UNTIL mFile.NEXT = 0;

        CLEAR(v_fichero);
        v_fichero.TEXTMODE(TRUE);
        v_fichero.CREATE(Pt_InfoEmpresa."Ruta ficheros SII" + '\Info.txt');
        //v_fichero.WRITE('OPEN ' + Pt_InfoEmpresa."Servidor FTP SII"); //EX-SGG 300617 COMENTO PARA FTPS.
        v_fichero.WRITE(Pt_InfoEmpresa."Usuario FTP");
        v_fichero.WRITE(Pt_InfoEmpresa."Contraseña FTP");
        v_fichero.WRITE('PROMPT');
        v_fichero.WRITE('PASSIVE'); //EX-SGG 300617 NECESARIO PARA FTPS.
        IF Pt_InfoEmpresa."Ruta subida ficheros FTP SII" <> '' THEN
            v_fichero.WRITE('CD "' + Pt_InfoEmpresa."Ruta subida ficheros FTP SII" + '"');
        //v_fichero.WRITE('LCD "'+Pt_InfoEmpresa."Ruta ficheros SII"+'"');
        v_fichero.WRITE('LCD ' + Pt_InfoEmpresa."Ruta ficheros SII"); //EX-SGG 300617 FTPS SIN "".
        v_fichero.WRITE('MPUT *LR*.txt');
        v_fichero.WRITE('CLOSE');
        v_fichero.WRITE('QUIT');
        v_fichero.CLOSE;

        process := process.Process;
        process.StartInfo.UseShellExecute := FALSE;
        process.StartInfo.FileName := 'ftps.exe';
        //17092020 Comentamos por migracion a Azure
        //process.StartInfo.Arguments := '-z -d -t:5 -e:implicit '+Pt_InfoEmpresa."Servidor FTP SII"+' -s:"'+Pt_InfoEmpresa."Ruta ficheros SII"+'\Info.txt"';
        process.StartInfo.Arguments := '-z -d -t:5 ' + Pt_InfoEmpresa."Servidor FTP SII" + ' -s:"' + Pt_InfoEmpresa."Ruta ficheros SII" + '\Info.txt"';
        process.StartInfo.CreateNoWindow := TRUE;
        process.Start();
        process.WaitForExit; //110917 EX-JVN
        CLEAR(process);

        //SLEEP(5000)
        IF FILE.EXISTS(Pt_InfoEmpresa."Ruta ficheros SII" + '\Info.txt') THEN
            FILE.ERASE(Pt_InfoEmpresa."Ruta ficheros SII" + '\Info.txt');
        SLEEP(500);

        mFile.RESET;
        mFile.SETRANGE(Path, Pt_InfoEmpresa."Ruta ficheros SII");
        mFile.SETFILTER(Name, '%1', '*.txt');
        IF mFile.FINDSET THEN
            REPEAT
                IF FILE.EXISTS(STRSUBSTNO('%1\%2', Pt_InfoEmpresa."Ruta ficheros entregados SII", mFile.Name)) THEN BEGIN
                    FILE.RENAME(STRSUBSTNO('%1\%2', Pt_InfoEmpresa."Ruta ficheros SII", mFile.Name),
                      STRSUBSTNO('%1\%3_%2', Pt_InfoEmpresa."Ruta ficheros entregados SII", mFile.Name, DELCHR(FORMAT(TIME), '=', ':')));
                END ELSE
                    FILE.RENAME(STRSUBSTNO('%1\%2', Pt_InfoEmpresa."Ruta ficheros SII", mFile.Name),
                      STRSUBSTNO('%1\%2', Pt_InfoEmpresa."Ruta ficheros entregados SII", mFile.Name));
            UNTIL mFile.NEXT = 0;
    end;


    procedure ChequeosObligatoriosRegistro(TipoDocumento: Integer; "Venta-Compra": Option Venta,Compra; NoDocumento: Code[20]; var TextoMensajeError: Text[250]) HayError: Boolean
    var
        RecDatosSIIDocumento: Record "SII- Datos documento";
        RecConfigDatos: Record "SII- Config. múltiple";
    begin

        // Comprueba si entre los datos SII del documento, hay alguno Obligatorio que no tenga valor.
        // TipoDocumento= 0:Factura, 1:Abono, 2:B.I.
        // Origen       = 0:Emitida, 1:Recibida, 2:B.I.
        /*
        0 Oferta,
        1 Pedido,
        2 Factura,
        3 Abono,
        4 Pedido abierto,
        5 Devolución
        
        Servicio
        10 Quote,
        11 Order,
        12 Invoice,
        13 Credit Memo
        */

        // Comprobar campos informados
        IF ChequeosPorDocumento(TipoDocumento, "Venta-Compra", NoDocumento, TextoMensajeError) THEN
            ERROR(TextoMensajeError);

        RecConfigDatos.RESET;
        RecConfigDatos.SETRANGE(RecConfigDatos."Tipo configuración", RecConfigDatos."Tipo configuración"::"Datos por documento");
        RecConfigDatos.SETRANGE(RecConfigDatos.Obligatorio, TRUE);
        IF "Venta-Compra" = "Venta-Compra"::Venta THEN
            RecConfigDatos.SETRANGE(RecConfigDatos."Informar en documento", RecConfigDatos."Informar en documento"::Expedido)
        ELSE
            RecConfigDatos.SETRANGE(RecConfigDatos."Informar en documento", RecConfigDatos."Informar en documento"::Recibido);

        IF TipoDocumento IN [1, 2, 11, 12] THEN
            RecConfigDatos.SETRANGE(RecConfigDatos."Tipo de documento", RecConfigDatos."Tipo de documento"::Facturas);
        IF TipoDocumento IN [3, 5, 13] THEN
            RecConfigDatos.SETRANGE(RecConfigDatos."Tipo de documento", RecConfigDatos."Tipo de documento"::Abonos);

        IF RecConfigDatos.FINDSET THEN
            REPEAT  // Por cada Obligatorio configurado en el maestro , localizar el mismo dato en el documento.
                RecDatosSIIDocumento.RESET;
                CASE TRUE OF
                    "Venta-Compra" = "Venta-Compra"::Venta: // Ventas
                        BEGIN
                            CASE TRUE OF
                                TipoDocumento IN [1, 2]:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Factura emitida");
                                TipoDocumento IN [3, 5]:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Abono emitido");
                                TipoDocumento = 11:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Srv pedido");
                                TipoDocumento = 12:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Srv Factura");
                                TipoDocumento = 13:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Srv Abono");

                            END;
                        END;
                    "Venta-Compra" = "Venta-Compra"::Compra: // Compras
                        BEGIN
                            CASE TRUE OF
                                TipoDocumento IN [1, 2]:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Factura recibida");
                                TipoDocumento IN [3, 5]:
                                    RecDatosSIIDocumento.SETRANGE("Tipo documento", RecDatosSIIDocumento."Tipo documento"::"Abono recibido");
                            END;
                        END;

                END;
                RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento."No. Documento", NoDocumento);
                RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento."Dato SII a exportar como", RecConfigDatos."Dato SII a exportar como");
                IF RecDatosSIIDocumento.FINDFIRST THEN BEGIN
                    REPEAT
                        IF (RecDatosSIIDocumento.Obligatorio) AND (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                            HayError := TRUE;
                            TextoMensajeError := 'El dato SII ' + RecDatosSIIDocumento."Dato SII" + ' del Documento ' + NoDocumento +
                            ', es obligatorio y no está informado.';
                        END;
                    UNTIL RecDatosSIIDocumento.NEXT = 0;
                END ELSE BEGIN
                    BEGIN
                        HayError := TRUE;
                        TextoMensajeError := 'Es obligatorio informar el dato SII :' +
                                           RecConfigDatos."Nombre dato SII" + ', en el documento ' + NoDocumento;
                    END;
                END;
            UNTIL RecConfigDatos.NEXT = 0;

        // Dentro del documento, comprobar si todos los marcados como obligatorios tienen valor

        RecDatosSIIDocumento.RESET;
        RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento."No. Documento", NoDocumento);
        RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento.Obligatorio, TRUE);
        IF RecDatosSIIDocumento.FINDFIRST THEN
            REPEAT
                IF RecDatosSIIDocumento."Valor dato SII" = '' THEN BEGIN
                    HayError := TRUE;
                    TextoMensajeError := 'El dato SII ' + RecDatosSIIDocumento."Dato SII" + ' del Documento ' + NoDocumento +
                    ', es obligatorio y no está informado.';
                END;
            UNTIL RecDatosSIIDocumento.NEXT = 0;

    end;


    /// <summary>
    /// ChequeosConfigIVA.
    /// </summary>
    /// <param name="TipoDocumento">Integer.</param>
    /// <param name="Venta-Compra">Option Venta,Compra.</param>
    /// <param name="NoDocumento">Code[20].</param>
    /// <param name="TextoMensajeError">VAR Text[250].</param>
    /// <returns>Return variable HayError of type Boolean.</returns>
    procedure ChequeosConfigIVA(TipoDocumento: Integer; "Venta-Compra": Option Venta,Compra; NoDocumento: Code[20]; var TextoMensajeError: Text[250]) HayError: Boolean
    var
        RecConfigDatosIVA: Record "SII- Config. múltiple";
        RecLInVta: Record 37;
        RecLinCompra: Record 39;
    begin

        // TipoDocumento= 0:Factura, 1:Abono, 2:B.I.
        // Origen       = 0:Emitida, 1:Recibida, 2:B.I.
        /*
        TipoDocumento
        0 Oferta,
        1 Pedido,
        2 Factura,
        3 Abono,
        4 Pedido abierto,
        5 Devolución
        */

        /*
        RecConfigDatos.RESET;
        RecConfigDatos.SETRANGE(RecConfigDatos."Tipo configuración",RecConfigDatos."Tipo configuración"::"Datos por documento");
        RecConfigDatos.SETRANGE(RecConfigDatos.Obligatorio,TRUE);
        */

        CASE TRUE OF
            "Venta-Compra" = "Venta-Compra"::Venta: // Ventas
                BEGIN
                    CASE TRUE OF
                        TipoDocumento = 1:
                            RecLInVta.SETRANGE(RecLInVta."Document Type", RecLInVta."Document Type"::Order);
                        TipoDocumento = 2:
                            RecLInVta.SETRANGE(RecLInVta."Document Type", RecLInVta."Document Type"::Invoice);
                        TipoDocumento = 3:
                            RecLInVta.SETRANGE(RecLInVta."Document Type", RecLInVta."Document Type"::"Credit Memo");
                        TipoDocumento = 5:
                            RecLInVta.SETRANGE(RecLInVta."Document Type", RecLInVta."Document Type"::"Return Order");
                    END;
                    RecLInVta.SETRANGE(RecLInVta."Document No.", NoDocumento);
                    RecLInVta.SETFILTER(RecLInVta."Line Amount", '<>%1', 0);
                    IF RecLInVta.FINDSET THEN
                        REPEAT
                            RecConfigDatosIVA.RESET;
                            RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Tipo configuración", RecConfigDatosIVA."Tipo configuración"::"Tipo IVA");
                            RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Gr. Reg. IVA Negocio", RecLInVta."VAT Bus. Posting Group");
                            RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Gr. Reg. IVA Producto", RecLInVta."VAT Prod. Posting Group");
                            IF NOT RecConfigDatosIVA.FINDSET THEN BEGIN
                                HayError := TRUE;
                                TextoMensajeError := 'La configuración SII de Tipo de IVA ' + RecLInVta."VAT Bus. Posting Group" + '-' +
                                                   RecLInVta."VAT Prod. Posting Group" + ' no está definida. Creela en SII- Config. multiple.';
                            END;
                            // Aprovechar el viaje para controlar si existe Gr. Ctble, producto a efectos de Bienes o Servicios
                            RecConfigDatosIVA.RESET;
                            RecConfigDatosIVA.SETRANGE("Tipo configuración", RecConfigDatosIVA."Tipo configuración"::"Tipo operación");
                            RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Gr. Contable producto", RecLInVta."Gen. Prod. Posting Group");
                            IF NOT RecConfigDatosIVA.FINDSET THEN BEGIN
                                HayError := TRUE;
                                TextoMensajeError := 'La configuración SII de Tipo de Operación para Bienes o Servicios ' +
                                                    RecLInVta."Gen. Prod. Posting Group" +
                                                   ' no está definida. Creela en SII- Config. multiple.';
                            END;
                        UNTIL RecLInVta.NEXT = 0;
                END;
            "Venta-Compra" = "Venta-Compra"::Compra: // Compras
                BEGIN
                    CASE TRUE OF
                        TipoDocumento = 1:
                            RecLinCompra.SETRANGE(RecLinCompra."Document Type", RecLinCompra."Document Type"::Order);
                        TipoDocumento = 2:
                            RecLinCompra.SETRANGE(RecLinCompra."Document Type", RecLinCompra."Document Type"::Invoice);
                        TipoDocumento = 3:
                            RecLinCompra.SETRANGE(RecLinCompra."Document Type", RecLinCompra."Document Type"::"Credit Memo");
                        TipoDocumento = 5:
                            RecLinCompra.SETRANGE(RecLinCompra."Document Type", RecLinCompra."Document Type"::"Return Order");
                    END;
                    RecLinCompra.SETRANGE(RecLinCompra."Document No.", NoDocumento);
                    RecLinCompra.SETFILTER(RecLinCompra."Line Amount", '<>%1', 0);
                    IF RecLinCompra.FINDSET THEN
                        REPEAT
                            RecConfigDatosIVA.RESET;
                            RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Tipo configuración", RecConfigDatosIVA."Tipo configuración"::"Tipo IVA");
                            RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Gr. Reg. IVA Negocio", RecLinCompra."VAT Bus. Posting Group");
                            RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Gr. Reg. IVA Producto", RecLinCompra."VAT Prod. Posting Group");
                            IF NOT RecConfigDatosIVA.FINDSET THEN BEGIN
                                HayError := TRUE;
                                TextoMensajeError := 'La configuración SII de Tipo de IVA :' + RecLinCompra."VAT Bus. Posting Group" + ' - ' +
                                                   RecLinCompra."VAT Prod. Posting Group" + ' no está definida. Creela en SII- Config. multiple SII.';
                            END;
                            // Aprovechar el viaje para controlar si existe Gr. Ctble, producto a efectos de Bienes o Servicios
                            RecConfigDatosIVA.RESET;
                            RecConfigDatosIVA.SETRANGE("Tipo configuración", RecConfigDatosIVA."Tipo configuración"::"Tipo operación");
                            RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Gr. Contable producto", RecLinCompra."Gen. Prod. Posting Group");
                            IF NOT RecConfigDatosIVA.FINDSET THEN BEGIN
                                HayError := TRUE;
                                TextoMensajeError := 'La configuración SII de Tipo de Operación para Bienes y Servicios ' +
                                                   RecLinCompra."Gen. Prod. Posting Group" +
                                                   ' no está definida. Creela en SII- Config. multiple.';
                            END;
                        UNTIL RecLinCompra.NEXT = 0;
                END;
        END;

    end;


    procedure BuscarConfigParaExcluirSII(NoTabla: Integer; NoDocumento: Code[20]) Excluir: Boolean
    var
        RecConfigMultipleSII: Record "SII- Config. múltiple";
        NoBusquesMas: Boolean;
        RecFraVta: Record 112;
        RecLinFraVta: Record 113;
        RecAboVta: Record 114;
        RecLinAboVta: Record 115;
        RecFraCompra: Record 122;
        RecLinFraCompra: Record 123;
        RecAboCompra: Record 124;
        RecLinAboCompra: Record 125;
        "---------- Servicios---------": Integer;
        RecFraServ: Record 5992;
        RecLinFraServ: Record 5993;
        RecAboServ: Record 5994;
        RecLinAboServ: Record 5995;
    begin
        // Busca entre las líneas del documento si hay alguna con configuración de IVA marcada como
        // "Excluir envio SII"
        // Si encuentra alguna, marcará el documento entero como "Excluir de envío a SII"

        NoBusquesMas := FALSE;
        CASE NoTabla OF
            112:
                BEGIN
                    RecLinFraVta.SETRANGE(RecLinFraVta."Document No.", NoDocumento);
                    RecLinFraVta.SETFILTER(RecLinFraVta.Quantity, '<>%1', 0);
                    IF RecLinFraVta.FINDSET THEN
                        REPEAT
                            RecConfigMultipleSII.RESET;
                            RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Tipo IVA");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Negocio", RecLinFraVta."VAT Bus. Posting Group");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Producto", RecLinFraVta."VAT Prod. Posting Group");
                            IF (RecConfigMultipleSII.FINDFIRST) AND (RecConfigMultipleSII."Excluir del SII") THEN BEGIN
                                RecFraVta.GET(NoDocumento);
                                RecFraVta."SII Excluir envío" := TRUE;
                                RecFraVta.MODIFY;
                                Excluir := TRUE;
                                NoBusquesMas := TRUE;
                            END;
                        UNTIL (RecLinFraVta.NEXT = 0) OR (NoBusquesMas);
                END;
            114:
                BEGIN
                    RecLinAboVta.SETRANGE(RecLinAboVta."Document No.", NoDocumento);
                    RecLinAboVta.SETFILTER(RecLinAboVta.Quantity, '<>%1', 0);
                    IF RecLinAboVta.FINDSET THEN
                        REPEAT
                            RecConfigMultipleSII.RESET;
                            RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Tipo IVA");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Negocio", RecLinAboVta."VAT Bus. Posting Group");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Producto", RecLinAboVta."VAT Prod. Posting Group");
                            IF (RecConfigMultipleSII.FINDFIRST) AND (RecConfigMultipleSII."Excluir del SII") THEN BEGIN
                                RecAboVta.GET(NoDocumento);
                                RecAboVta."SII Excluir envío" := TRUE;
                                RecAboVta.MODIFY;
                                Excluir := TRUE;
                                NoBusquesMas := TRUE;
                            END;
                        UNTIL (RecLinAboVta.NEXT = 0) OR (NoBusquesMas);
                END;
            122:
                BEGIN
                    RecLinFraCompra.SETRANGE(RecLinFraCompra."Document No.", NoDocumento);
                    RecLinFraCompra.SETFILTER(RecLinFraCompra.Quantity, '<>%1', 0);
                    IF RecLinFraCompra.FINDSET THEN
                        REPEAT
                            RecConfigMultipleSII.RESET;
                            RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Tipo IVA");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Negocio", RecLinFraCompra."VAT Bus. Posting Group");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Producto", RecLinFraCompra."VAT Prod. Posting Group");
                            IF (RecConfigMultipleSII.FINDFIRST) AND (RecConfigMultipleSII."Excluir del SII") THEN BEGIN
                                RecFraCompra.GET(NoDocumento);
                                RecFraCompra."SII Excluir envío" := TRUE;
                                RecFraCompra.MODIFY;
                                Excluir := TRUE;
                                NoBusquesMas := TRUE;
                            END;
                        UNTIL (RecLinFraCompra.NEXT = 0) OR (NoBusquesMas);
                END;
            124:
                BEGIN
                    RecLinAboCompra.SETRANGE(RecLinAboCompra."Document No.", NoDocumento);
                    RecLinAboCompra.SETFILTER(RecLinAboCompra.Quantity, '<>%1', 0);
                    IF RecLinAboCompra.FINDSET THEN
                        REPEAT
                            RecConfigMultipleSII.RESET;
                            RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Tipo IVA");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Negocio", RecLinAboCompra."VAT Bus. Posting Group");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Producto", RecLinAboCompra."VAT Prod. Posting Group");
                            IF (RecConfigMultipleSII.FINDFIRST) AND (RecConfigMultipleSII."Excluir del SII") THEN BEGIN
                                RecAboCompra.GET(NoDocumento);
                                RecAboCompra."SII Excluir envío" := TRUE;
                                RecAboCompra.MODIFY;
                                Excluir := TRUE;
                                NoBusquesMas := TRUE;
                            END;
                        UNTIL (RecLinAboCompra.NEXT = 0) OR (NoBusquesMas);
                END;
            5592:
                BEGIN
                    RecLinFraServ.SETRANGE(RecLinFraServ."Document No.", NoDocumento);
                    RecLinFraServ.SETFILTER(RecLinFraServ.Quantity, '<>%1', 0);
                    IF RecLinFraServ.FINDSET THEN
                        REPEAT
                            RecConfigMultipleSII.RESET;
                            RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Tipo IVA");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Negocio", RecLinFraServ."VAT Bus. Posting Group");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Producto", RecLinFraServ."VAT Prod. Posting Group");
                            IF (RecConfigMultipleSII.FINDFIRST) AND (RecConfigMultipleSII."Excluir del SII") THEN BEGIN
                                RecFraServ.GET(NoDocumento);
                                RecFraServ."SII Excluir envío" := TRUE;
                                RecFraServ.MODIFY;
                                Excluir := TRUE;
                                NoBusquesMas := TRUE;
                            END;
                        UNTIL (RecLinFraServ.NEXT = 0) OR (NoBusquesMas);
                END;
            5594:
                BEGIN
                    RecLinAboServ.SETRANGE(RecLinAboServ."Document No.", NoDocumento);
                    RecLinAboServ.SETFILTER(RecLinAboServ.Quantity, '<>%1', 0);
                    IF RecLinAboServ.FINDSET THEN
                        REPEAT
                            RecConfigMultipleSII.RESET;
                            RecConfigMultipleSII.SETRANGE("Tipo configuración", RecConfigMultipleSII."Tipo configuración"::"Tipo IVA");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Negocio", RecLinAboServ."VAT Bus. Posting Group");
                            RecConfigMultipleSII.SETRANGE(RecConfigMultipleSII."Gr. Reg. IVA Producto", RecLinAboServ."VAT Prod. Posting Group");
                            IF (RecConfigMultipleSII.FINDFIRST) AND (RecConfigMultipleSII."Excluir del SII") THEN BEGIN
                                RecAboServ.GET(NoDocumento);
                                RecAboServ."SII Excluir envío" := TRUE;
                                RecAboServ.MODIFY;
                                Excluir := TRUE;
                                NoBusquesMas := TRUE;
                            END;
                        UNTIL (RecLinAboServ.NEXT = 0) OR (NoBusquesMas);
                END;




        END;
    end;


    procedure InsertarDatosContraparte(lTipoDoc: Integer; lNumDoc: Code[20]; lCodContra: Code[20])
    var
        lRstConfMul: Record "SII- Config. múltiple";
    begin
        //EX-SGG 260617
        /*
        1 Factura emitida,
        2 Abono emitido,
        3 Factura emitida reg.,
        4 Abono emitido reg.,
        5 Factura recibida,
        6 Abono recibido,
        7 Factura recibida reg.,
        8 Abono recibido reg.,
        9 BI
        10 Srv pedido,
        11 Srv Factura,
        12 Srv Abono,
        13 Srv Factura reg.,
        14 Srv Abono reg.
        */

        lRstConfMul.RESET;
        lRstConfMul.SETRANGE("Tipo configuración", lRstConfMul."Tipo configuración"::"Cliente/Proveedor");
        lRstConfMul.SETRANGE("Cód. contraparte", lCodContra);
        CASE lTipoDoc OF
            //1,2,3,4,10,11,12,13,14: //emitidas
            1, 3, 10, 11, 13: //facturas emitidas //EX-SMN 241017
                BEGIN
                    lRstConfMul.SETRANGE("Tipo Contraparte", lRstConfMul."Tipo Contraparte"::Cliente);
                    IF lRstConfMul.FINDFIRST THEN BEGIN
                        IF STRLEN(lRstConfMul."Tipo factura emitida") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'TipoFactura', lRstConfMul."Tipo factura emitida", 0);
                        IF STRLEN(lRstConfMul."Clave regimen especial emitida") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'ClaveRegimenEspecialOTrascendencia',
                              lRstConfMul."Clave regimen especial emitida", 0);
                    END;
                END;
            //EX-SMN 241017
            2, 4, 12, 14: //abonos emitidos
                BEGIN
                    lRstConfMul.SETRANGE("Tipo Contraparte", lRstConfMul."Tipo Contraparte"::Cliente);
                    IF lRstConfMul.FINDFIRST THEN BEGIN
                        IF STRLEN(lRstConfMul."Tipo abono emitido") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'TipoFactura', lRstConfMul."Tipo abono emitido", 0);
                        IF STRLEN(lRstConfMul."Clave rég. esp. abono emitido") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'ClaveRegimenEspecialOTrascendencia',
                              lRstConfMul."Clave rég. esp. abono emitido", 0);
                    END;
                END;
            //EX-SMN FIN
            //5,6,7,8: //recibidas
            5, 7: //facturas recibidas //EX-SMN 241017
                BEGIN
                    lRstConfMul.SETRANGE("Tipo Contraparte", lRstConfMul."Tipo Contraparte"::Proveedor);
                    IF lRstConfMul.FINDFIRST THEN BEGIN
                        IF STRLEN(lRstConfMul."Tipo factura recibida") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'TipoFactura', lRstConfMul."Tipo factura recibida", 1);
                        IF STRLEN(lRstConfMul."Clave regimen especial recibid") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'ClaveRegimenEspecialOTrascendencia',
                              lRstConfMul."Clave regimen especial recibid", 1);
                    END;
                END;
            //EX-SMN 241017
            6, 8: //abonos recibidos
                BEGIN
                    lRstConfMul.SETRANGE("Tipo Contraparte", lRstConfMul."Tipo Contraparte"::Proveedor);
                    IF lRstConfMul.FINDFIRST THEN BEGIN
                        IF STRLEN(lRstConfMul."Tipo abono recibido") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'TipoFactura', lRstConfMul."Tipo abono recibido", 1);
                        IF STRLEN(lRstConfMul."Clave rég. esp. abono recibido") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'ClaveRegimenEspecialOTrascendencia',
                              lRstConfMul."Clave rég. esp. abono recibido", 1);
                    END;
                END;
        //EX-SMN FIN
        END;

    end;


    procedure InsertarDatosMultiple(lTipoDoc: Integer; lNumDoc: Code[20]; lTipoConf: Integer; lGRIN: Code[20]; lGRIP: Code[20])
    var
        lRstConfMul: Record "SII- Config. múltiple";
        lRstDatosDoc: Record "SII- Datos documento";
    begin
        //EX-SGG 260617
        /*
        1 Factura emitida,
        2 Abono emitido,
        3 Factura emitida reg.,
        4 Abono emitido reg.,
        5 Factura recibida,
        6 Abono recibido,
        7 Factura recibida reg.,
        8 Abono recibido reg.,
        9 BI
        10 Srv pedido,
        11 Srv Factura,
        12 Srv Abono,
        13 Srv Factura reg.,
        14 Srv Abono reg.
        */

        lRstConfMul.RESET;
        lRstConfMul.SETRANGE("Tipo configuración", lTipoConf);
        lRstConfMul.SETRANGE("Gr. Reg. IVA Negocio", lGRIN);
        lRstConfMul.SETRANGE("Gr. Reg. IVA Producto", lGRIP);
        IF lRstConfMul.FINDFIRST THEN
            CASE lTipoDoc OF
                //1,2,3,4,10,11,12,13,14: //emitidas
                1, 3, 10, 11, 13: //facturas emitidas //EX-SMN 241017
                    BEGIN
                        IF STRLEN(lRstConfMul."Tipo factura emitida") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'TipoFactura', lRstConfMul."Tipo factura emitida", 0);
                        IF STRLEN(lRstConfMul."Clave regimen especial emitida") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'ClaveRegimenEspecialOTrascendencia',
                              lRstConfMul."Clave regimen especial emitida", 0);
                    END;
                //EX-SMN 241017
                2, 4, 12, 14: //abonos emitidos
                    BEGIN
                        IF STRLEN(lRstConfMul."Tipo abono emitido") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'TipoFactura', lRstConfMul."Tipo abono emitido", 0);
                        IF STRLEN(lRstConfMul."Clave rég. esp. abono emitido") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'ClaveRegimenEspecialOTrascendencia',
                              lRstConfMul."Clave rég. esp. abono emitido", 0);
                    END;
                //EX-SMN FIN
                //5,6,7,8 //recibidas
                5, 7: //facturas recibidas //EX-SMN 241017
                    BEGIN
                        IF STRLEN(lRstConfMul."Tipo factura recibida") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'TipoFactura', lRstConfMul."Tipo factura recibida", 1);
                        IF STRLEN(lRstConfMul."Clave regimen especial recibid") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'ClaveRegimenEspecialOTrascendencia',
                              lRstConfMul."Clave regimen especial recibid", 1);
                    END;
                //EX-SMN 241017
                6, 8: //abonos recibidos
                    BEGIN
                        IF STRLEN(lRstConfMul."Tipo abono recibido") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'TipoFactura', lRstConfMul."Tipo abono recibido", 1);
                        IF STRLEN(lRstConfMul."Clave rég. esp. abono recibido") > 0 THEN
                            InsertaDatoEnDocumento(lTipoDoc, lNumDoc, 'ClaveRegimenEspecialOTrascendencia',
                              lRstConfMul."Clave rég. esp. abono recibido", 1);
                    END;
            //EX-SMN FIN
            END;

    end;


    procedure InsertaDatoEnDocumento(lTipoDoc: Integer; lNumDoc: Code[20]; lDatoSII: Text[100]; lValor: Code[50]; lInfEnDoc: Integer)
    var
        lRstConfMul: Record "SII- Config. múltiple";
        lRstDatosDoc: Record "SII- Datos documento";
    begin
        //EX-SGG 260617
        /*
        1 Factura emitida,
        2 Abono emitido,
        3 Factura emitida reg.,
        4 Abono emitido reg.,
        5 Factura recibida,
        6 Abono recibido,
        7 Factura recibida reg.,
        8 Abono recibido reg.,
        9 BI
        10 Srv pedido,
        11 Srv Factura,
        12 Srv Abono,
        13 Srv Factura reg.,
        14 Srv Abono reg.
        */

        lRstConfMul.RESET;
        lRstConfMul.SETRANGE("Tipo configuración", lRstConfMul."Tipo configuración"::"Datos por documento");
        lRstConfMul.SETRANGE("Informar en documento", lInfEnDoc);
        lRstConfMul.SETRANGE("Dato SII a exportar como", lDatoSII);
        IF lRstConfMul.FINDFIRST THEN BEGIN
            lRstDatosDoc.INIT;
            Case lTipoDoc of
                1:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Factura emitida";
                2:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Abono emitido";
                3:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Factura emitida reg.";
                4:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Abono emitido reg.";
                5:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Factura recibida";
                6:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Abono recibido";
                7:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Factura recibida reg.";
                8:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Abono recibido reg.";
                9:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::BI;
                10:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Srv pedido";
                11:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Srv Factura";
                12:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Srv Abono";
                13:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Srv Factura reg.";
                14:
                    lRstDatosDoc."Tipo documento" := lRstDatosDoc."Tipo documento"::"Srv Abono reg.";

            end;
            //lRstDatosDoc."Tipo documento" :=  lTipoDoc - 1; //Orden de option igual a ltipodoc menos uno.
            lRstDatosDoc."No. Documento" := lNumDoc;
            lRstDatosDoc."Dato SII" := lRstConfMul."Nombre dato SII";
            lRstDatosDoc."Valor dato SII" := lValor;
            lRstDatosDoc."Filtro valores maestros SII" := lRstConfMul."Filtro tabla valores SII";
            lRstDatosDoc.Orden := lRstConfMul.Orden;
            lRstDatosDoc.Obligatorio := lRstConfMul.Obligatorio;
            lRstDatosDoc."Dato SII a exportar como" := lRstConfMul."Dato SII a exportar como";
            lRstDatosDoc."Desc. dato SII" := lRstConfMul.Observaciones;
            IF NOT lRstDatosDoc.INSERT THEN lRstDatosDoc.MODIFY;
        END;

    end;


    /// <summary>
    /// InsertaContraparte.
    /// </summary>
    /// <param name="Tipo">Integer.</param>
    /// <param name="Código">Code[20].</param>
    procedure InsertaContraparte(Tipo: Integer; "Código": Code[20])
    var
        RecConfigMultipleContrapartes: Record "SII- Config. múltiple";
        RecContrapartes: Record "SII- Config. múltiple";
        RecPaises: Record "Country/Region";
        RecCliente: Record Customer;
        RecProveedor: Record Vendor;
    begin

        // Tipo 1=Cliente
        // Tipo 2=Proveedor

        CASE Tipo OF
            1:
                BEGIN  // Cliente
                    RecCliente.GET(Código);
                    RecConfigMultipleContrapartes.RESET;
                    RecConfigMultipleContrapartes.SETRANGE("Tipo configuración", RecConfigMultipleContrapartes."Tipo configuración"::Contraparte);
                    RecConfigMultipleContrapartes.SETRANGE("Gr. Reg. IVA Negocio", RecCliente."VAT Bus. Posting Group");
                    RecConfigMultipleContrapartes.SETFILTER(RecConfigMultipleContrapartes."Clave Id. fiscal contraparte", '<>%1', '');
                    IF RecConfigMultipleContrapartes.FINDSET THEN BEGIN
                        RecContrapartes.RESET;
                        RecContrapartes.SETRANGE(RecContrapartes."Tipo configuración", RecContrapartes."Tipo configuración"::"Cliente/Proveedor");
                        RecContrapartes.SETRANGE(RecContrapartes."Tipo Contraparte", RecContrapartes."Tipo Contraparte"::Cliente);
                        RecContrapartes.SETRANGE(RecContrapartes."Cód. contraparte", Código);
                        IF (RecPaises.GET(RecCliente."Country/Region Code")) AND (RecCliente."VAT Registration No." <> '') THEN BEGIN
                            IF NOT RecContrapartes.FINDFIRST THEN BEGIN
                                RecContrapartes.RESET;
                                RecContrapartes."Tipo configuración" := RecContrapartes."Tipo configuración"::"Cliente/Proveedor";
                                RecContrapartes.INSERT(TRUE);
                                RecContrapartes."Tipo Contraparte" := RecContrapartes."Tipo Contraparte"::Cliente;
                                RecContrapartes.VALIDATE("Cód. contraparte", Código);

                                RecContrapartes."Clave Id. fiscal contraparte" := RecConfigMultipleContrapartes."Clave Id. fiscal contraparte";
                                IF RecPaises."EU Country/Region Code" <> '' THEN
                                    RecContrapartes."Cód. país contraparte" := RecPaises."EU Country/Region Code"
                                ELSE
                                    RecContrapartes."Cód. país contraparte" := RecPaises.Code;

                                RecContrapartes."NIF/ID. fiscal contraparte" :=
                                 DevuelveNIFIDFiscalContraparte(RecCliente."VAT Registration No.", RecContrapartes."Cód. país contraparte");
                                RecContrapartes."Tipo factura emitida" := RecConfigMultipleContrapartes."Tipo factura emitida";
                                RecContrapartes."Clave regimen especial emitida" := RecConfigMultipleContrapartes."Clave regimen especial emitida";
                                //EX-OMI 311017
                                //RecContrapartes."Tipo factura recibida":=RecConfigMultipleContrapartes."Tipo factura recibida";
                                //RecContrapartes."Clave regimen especial recibid":=RecConfigMultipleContrapartes."Clave regimen especial recibid";

                                RecContrapartes."Tipo abono emitido" := RecConfigMultipleContrapartes."Tipo abono emitido";
                                RecContrapartes."Clave rég. esp. abono emitido" := RecConfigMultipleContrapartes."Clave rég. esp. abono emitido";
                                //EX-OMI 311017 FIN

                                RecContrapartes.MODIFY(TRUE);
                            END ELSE BEGIN
                                RecContrapartes."Clave Id. fiscal contraparte" := RecConfigMultipleContrapartes."Clave Id. fiscal contraparte";
                                IF RecPaises."EU Country/Region Code" <> '' THEN
                                    RecContrapartes."Cód. país contraparte" := RecPaises."EU Country/Region Code"
                                ELSE
                                    RecContrapartes."Cód. país contraparte" := RecPaises.Code;
                                RecContrapartes."NIF/ID. fiscal contraparte" :=
                                 DevuelveNIFIDFiscalContraparte(RecCliente."VAT Registration No.", RecContrapartes."Cód. país contraparte");
                                RecContrapartes."Tipo factura emitida" := RecConfigMultipleContrapartes."Tipo factura emitida";
                                RecContrapartes."Clave regimen especial emitida" := RecConfigMultipleContrapartes."Clave regimen especial emitida";
                                //EX-OMI 311017
                                //RecContrapartes."Tipo factura recibida":=RecConfigMultipleContrapartes."Tipo factura recibida";
                                //RecContrapartes."Clave regimen especial recibid":=RecConfigMultipleContrapartes."Clave regimen especial recibid";

                                RecContrapartes."Tipo abono emitido" := RecConfigMultipleContrapartes."Tipo abono emitido";
                                RecContrapartes."Clave rég. esp. abono emitido" := RecConfigMultipleContrapartes."Clave rég. esp. abono emitido";
                                //EX-OMI 311017 FIN

                                RecContrapartes.MODIFY(TRUE);
                            END;
                        END;
                    END;
                END;
            2:
                BEGIN   // Proveedor
                    RecProveedor.GET(Código);
                    RecConfigMultipleContrapartes.RESET;
                    RecConfigMultipleContrapartes.SETRANGE("Tipo configuración", RecConfigMultipleContrapartes."Tipo configuración"::Contraparte);
                    RecConfigMultipleContrapartes.SETRANGE("Gr. Reg. IVA Negocio", RecProveedor."VAT Bus. Posting Group");
                    RecConfigMultipleContrapartes.SETFILTER(RecConfigMultipleContrapartes."Clave Id. fiscal contraparte", '<>%1', '');
                    IF RecConfigMultipleContrapartes.FINDSET THEN BEGIN
                        RecContrapartes.RESET;
                        RecContrapartes.SETRANGE(RecContrapartes."Tipo configuración", RecContrapartes."Tipo configuración"::"Cliente/Proveedor");
                        RecContrapartes.SETRANGE(RecContrapartes."Tipo Contraparte", RecContrapartes."Tipo Contraparte"::Proveedor);
                        RecContrapartes.SETRANGE(RecContrapartes."Cód. contraparte", Código);
                        IF (RecPaises.GET(RecProveedor."Country/Region Code")) AND (RecProveedor."VAT Registration No." <> '') THEN BEGIN
                            IF NOT RecContrapartes.FINDFIRST THEN BEGIN
                                RecContrapartes.RESET;
                                RecContrapartes."Tipo configuración" := RecContrapartes."Tipo configuración"::"Cliente/Proveedor";
                                RecContrapartes.INSERT(TRUE);
                                RecContrapartes."Tipo Contraparte" := RecContrapartes."Tipo Contraparte"::Proveedor;
                                RecContrapartes.VALIDATE("Cód. contraparte", Código);

                                RecContrapartes."Clave Id. fiscal contraparte" := RecConfigMultipleContrapartes."Clave Id. fiscal contraparte";
                                IF RecPaises."EU Country/Region Code" <> '' THEN
                                    RecContrapartes."Cód. país contraparte" := RecPaises."EU Country/Region Code"
                                ELSE
                                    RecContrapartes."Cód. país contraparte" := RecPaises.Code;
                                RecContrapartes."NIF/ID. fiscal contraparte" :=
                                 DevuelveNIFIDFiscalContraparte(RecProveedor."VAT Registration No.", RecContrapartes."Cód. país contraparte");
                                //EX-OMI 311017
                                //RecContrapartes."Tipo factura emitida":=RecConfigMultipleContrapartes."Tipo factura emitida";
                                //RecContrapartes."Clave regimen especial emitida":=RecConfigMultipleContrapartes."Clave regimen especial emitida";
                                RecContrapartes."Tipo factura recibida" := RecConfigMultipleContrapartes."Tipo factura recibida";
                                RecContrapartes."Clave regimen especial recibid" := RecConfigMultipleContrapartes."Clave regimen especial recibid";
                                RecContrapartes."Tipo abono recibido" := RecConfigMultipleContrapartes."Tipo abono recibido";
                                RecContrapartes."Clave rég. esp. abono recibido" := RecConfigMultipleContrapartes."Clave rég. esp. abono recibido";
                                //EX-OMI 311017 FIN

                                RecContrapartes.MODIFY(TRUE);
                            END ELSE BEGIN
                                RecContrapartes."Clave Id. fiscal contraparte" := RecConfigMultipleContrapartes."Clave Id. fiscal contraparte";
                                IF RecPaises."EU Country/Region Code" <> '' THEN
                                    RecContrapartes."Cód. país contraparte" := RecPaises."EU Country/Region Code"
                                ELSE
                                    RecContrapartes."Cód. país contraparte" := RecPaises.Code;
                                RecContrapartes."NIF/ID. fiscal contraparte" :=
                                 DevuelveNIFIDFiscalContraparte(RecProveedor."VAT Registration No.", RecContrapartes."Cód. país contraparte");
                                //EX-OMI 311017
                                //RecContrapartes."Tipo factura emitida":=RecConfigMultipleContrapartes."Tipo factura emitida";
                                //RecContrapartes."Clave regimen especial emitida":=RecConfigMultipleContrapartes."Clave regimen especial emitida";
                                RecContrapartes."Tipo factura recibida" := RecConfigMultipleContrapartes."Tipo factura recibida";
                                RecContrapartes."Clave regimen especial recibid" := RecConfigMultipleContrapartes."Clave regimen especial recibid";
                                RecContrapartes."Tipo abono recibido" := RecConfigMultipleContrapartes."Tipo abono recibido";
                                RecContrapartes."Clave rég. esp. abono recibido" := RecConfigMultipleContrapartes."Clave rég. esp. abono recibido";
                                //EX-OMI 311017 FIN

                                RecContrapartes.MODIFY(TRUE);
                            END;
                        END;
                    END;
                END;
        END;
    end;


    procedure ChequeosPorDocumento(TipoDocumento: Integer; "Venta-Compra": Option Venta,Compra; NoDocumento: Code[20]; var TextoMensajeError: Text[250]) ExisteError: Boolean
    var
        RecCabVta: Record 36;
        RecCabCompra: Record 38;
        RecCabVtaServ: Record 5900;
        RecDatosSIIDocumento: Record "SII- Datos documento";
        TipoDocDatoSII: Integer;
        ComprobarReglasNegocio: Boolean;
        RecLinCompra: Record 39;
        RecConfigDatosIVA: Record "SII- Config. múltiple";
        ExisteLineaDUA: Boolean;
        FormatoFechaOk: Date;
    begin

        /*EX-AHG SII+ 140717*/

        /* Tipo documento origen :
        0 Oferta,
        1 Pedido,
        2 Factura,
        3 Abono,
        4 Ped. abierto,
        5 Devolución,
        11 Srv Abono,
        12 Srv Factura reg.,
        13 Srv Abono reg.
        */

        /* DatosSIIDocumento:
        0 Factura emitida,
        1 Abono emitido,
        2 Factura emitida reg.,
        3 Abono emitido reg.,
        4 Factura recibida,
        5 Abono recibido,
        6 Factura recibida reg.,
        7 Abono recibido reg.,
        8 BI
        9 Srv pedido,
        10 Srv Factura,
        11 Srv Abono,
        12 Srv Factura reg.,
        13 Srv Abono reg.
        */


        // Función para ir incorporando controles de campos (Cabeceras y/o líneas) de los documentos.
        CASE TRUE OF
            "Venta-Compra" = "Venta-Compra"::Venta: // Ventas
                BEGIN
                    CASE TRUE OF
                        TipoDocumento IN [1, 2, 3, 5]: // Pedido venta, Factura venta, Abono venta, Dev. venta
                            BEGIN
                                //RecCabVta.GET(TipoDocumento,NoDocumento);   //100817 EX-JVN SII, puede tratarse de un Diario
                                IF RecCabVta.GET(TipoDocumento, NoDocumento) THEN BEGIN
                                    // Ir añadiendo campos a controlar
                                    // Informar "SII Fecha envío a control"
                                    IF (RecCabVta."SII Fecha envío a control" = 0D) OR
                                       (RecCabVta."SII Fecha envío a control" < RecCabVta."Posting Date") THEN BEGIN
                                        ExisteError := TRUE;
                                        TextoMensajeError := 'El dato "SII Fecha envío a control" debe estar informado en el documento ' + NoDocumento;
                                    END;
                                END;
                                // Reglas de negocio
                                IF TipoDocumento IN [1, 2] THEN TipoDocDatoSII := 0;
                                IF TipoDocumento IN [3, 5] THEN TipoDocDatoSII := 1;
                                ComprobarReglasNegocio := TRUE;
                            END;
                        TipoDocumento IN [11, 12, 13]: // Pedido servicio,Factura servicio, Abono servicio
                            BEGIN
                                RecCabVtaServ.GET(TipoDocumento - 10, NoDocumento);
                                // Ir añadiendo campos a controlar
                                // Informar "SII Fecha envío a control"
                                IF (RecCabVtaServ."SII Fecha envío a control" = 0D) OR
                                   (RecCabVtaServ."SII Fecha envío a control" < RecCabVtaServ."Posting Date") THEN BEGIN
                                    ExisteError := TRUE;
                                    TextoMensajeError := 'El dato "SII Fecha envío a control" debe estar informado en el documento ' + NoDocumento;
                                END;
                                // Reglas de negocio
                                IF TipoDocumento IN [11] THEN TipoDocDatoSII := 9;
                                IF TipoDocumento IN [12] THEN TipoDocDatoSII := 10;
                                IF TipoDocumento IN [13] THEN TipoDocDatoSII := 11;
                                ComprobarReglasNegocio := TRUE;
                            END;
                    END;
                END;
            "Venta-Compra" = "Venta-Compra"::Compra: // Compras
                BEGIN
                    CASE TRUE OF
                        TipoDocumento IN [1, 2, 3, 5]: // Pedido compra, Factura compra, Abono compra, Dev. compra
                            BEGIN
                                //RecCabCompra.GET(TipoDocumento,NoDocumento); //100817 EX-JVN SII, puede tratarse de un Diario
                                IF RecCabCompra.GET(TipoDocumento, NoDocumento) THEN BEGIN
                                    // Ir añadiendo campos a controlar
                                    // Informar "SII Fecha envío a control"
                                    IF (RecCabCompra."SII Fecha envío a control" = 0D) OR
                                       (RecCabCompra."SII Fecha envío a control" < RecCabCompra."Posting Date") THEN BEGIN
                                        ExisteError := TRUE;
                                        TextoMensajeError := 'El dato "SII Fecha envío a control" debe estar informado en el documento ' + NoDocumento;
                                    END;
                                END;
                                // Reglas de negocio
                                IF TipoDocumento IN [1, 2] THEN TipoDocDatoSII := 4;
                                IF TipoDocumento IN [3, 5] THEN TipoDocDatoSII := 5;
                                ComprobarReglasNegocio := TRUE;
                            END;
                    END;
                END;

        END;

        IF ComprobarReglasNegocio THEN BEGIN
            // Reglas de negocio
            RecDatosSIIDocumento.RESET;
            RecDatosSIIDocumento.SETRANGE("Tipo documento", TipoDocDatoSII);
            RecDatosSIIDocumento.SETRANGE("No. Documento", NoDocumento);

            //TipoFactura R1..R5 : Informar "TipoRectificativa"
            RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'TipoFactura');
            IF (RecDatosSIIDocumento.FINDFIRST) AND (RecDatosSIIDocumento."Valor dato SII" IN ['R1', 'R2', 'R3', 'R4', 'R5']) THEN BEGIN
                RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'TipoRectificativa');
                IF (NOT RecDatosSIIDocumento.FINDFIRST) OR (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                    ExisteError := TRUE;
                    TextoMensajeError := 'El dato SII "Tipo rectificativa" debe estar informado en el documento ' + NoDocumento;
                END;
            END;

            //TipoFactura F4 : Informar "NumeroFacturaEmisorResumenFin"
            RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento."Dato SII a exportar como", 'TipoFactura');
            IF (RecDatosSIIDocumento.FINDFIRST) AND (RecDatosSIIDocumento."Valor dato SII" IN ['F4']) THEN BEGIN
                RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'NumeroFacturaEmisorResumenFin');
                IF (NOT RecDatosSIIDocumento.FINDFIRST) OR (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                    ExisteError := TRUE;
                    TextoMensajeError := 'El dato SII "Numero final factura resumen" debe estar informado en el documento '
                    + NoDocumento;
                END;
            END;

            // * TRATAMIENTO DUA **************************************************************
            //TipoFactura F5 : DUA en factura del transitario.

            RecDatosSIIDocumento.SETRANGE(RecDatosSIIDocumento."Dato SII a exportar como", 'TipoFactura');
            IF (RecDatosSIIDocumento.FINDFIRST) AND (RecDatosSIIDocumento."Valor dato SII" IN ['F5']) THEN BEGIN
                RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'INT_DuaNumero');
                IF (NOT RecDatosSIIDocumento.FINDFIRST) OR (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                    ExisteError := TRUE;
                    TextoMensajeError := 'El dato SII "Número DUA" debe estar informado en el documento ' + NoDocumento;
                END;
                RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'INT_DuaBase');
                IF (NOT RecDatosSIIDocumento.FINDFIRST) OR (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                    ExisteError := TRUE;
                    TextoMensajeError := 'El dato SII "Base DUA" debe estar informado en el documento ' + NoDocumento;
                END;
                RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'INT_DuaFechaExpedicion');
                BEGIN
                    IF (NOT RecDatosSIIDocumento.FINDFIRST) OR (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                        ExisteError := TRUE;
                        TextoMensajeError := 'El dato SII "Fecha exp. DUA" debe estar informado en el documento ' + NoDocumento;
                    END;
                    IF NOT EVALUATE(FormatoFechaOk, RecDatosSIIDocumento."Valor dato SII") THEN BEGIN
                        ExisteError := TRUE;
                        TextoMensajeError := 'El dato SII "Fecha exp. DUA" debe tener formato DD/MM/AAAA en el documento ' + NoDocumento;
                    END;
                END;
                RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'INT_DuaPais');
                IF (NOT RecDatosSIIDocumento.FINDFIRST) OR (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                    ExisteError := TRUE;
                    TextoMensajeError := 'El dato SII "País DUA" debe estar informado en el documento ' + NoDocumento;
                END;
                // Controlar en compras que exista al menos una línea con Iva DUA
                IF "Venta-Compra" = "Venta-Compra"::Compra THEN
                    IF TipoDocumento IN [1, 2, 3, 5] THEN // Pedido compra, Factura compra, Abono compra, Dev. compra
                    BEGIN
                        RecLinCompra.RESET;
                        RecLinCompra.SETRANGE(RecLinCompra."Document Type", TipoDocumento);
                        RecLinCompra.SETRANGE(RecLinCompra."Document No.", NoDocumento);
                        RecLinCompra.SETFILTER(RecLinCompra."VAT Prod. Posting Group", '<>%1', '');
                        IF NOT RecLinCompra.FINDFIRST THEN BEGIN
                            ExisteError := TRUE;
                            TextoMensajeError := 'Al tratarse de documento DUA, debe existir al menos una línea de IVA configurada como DUA.';
                        END ELSE
                            REPEAT
                                RecConfigDatosIVA.RESET;
                                RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Tipo configuración", RecConfigDatosIVA."Tipo configuración"::"Tipo IVA");
                                RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Gr. Reg. IVA Negocio", RecLinCompra."VAT Bus. Posting Group");
                                RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Gr. Reg. IVA Producto", RecLinCompra."VAT Prod. Posting Group");
                                IF RecConfigDatosIVA.FINDFIRST THEN
                                    IF NOT RecConfigDatosIVA.DUA THEN // En el momento de encontrar una válida, el documento DUA es válido
                                    BEGIN
                                        ExisteError := TRUE;
                                        TextoMensajeError := 'Al tratarse de documento DUA, todas las líneas de IVA deben estar configuradas como DUA.';
                                    END;
                            UNTIL RecLinCompra.NEXT = 0;
                    END;
            END ELSE BEGIN

                // DUA incluido en otra factura del proveedor, no del transitario

                RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'INT_DuaNumero');
                IF (RecDatosSIIDocumento.FINDFIRST) AND (RecDatosSIIDocumento."Valor dato SII" <> '') THEN BEGIN
                    RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'INT_DuaBase');
                    IF (NOT RecDatosSIIDocumento.FINDFIRST) OR (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                        ExisteError := TRUE;
                        TextoMensajeError := 'El dato SII "Base DUA" debe estar informado en el documento '
                        + NoDocumento;
                    END;

                    RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'INT_DuaFechaExpedicion');
                    IF (NOT RecDatosSIIDocumento.FINDFIRST) OR (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                        ExisteError := TRUE;
                        TextoMensajeError := 'El dato SII "Fecha exp. DUA" debe estar informado en el documento '
                        + NoDocumento;
                    END;
                    IF NOT EVALUATE(FormatoFechaOk, RecDatosSIIDocumento."Valor dato SII") THEN BEGIN
                        ExisteError := TRUE;
                        TextoMensajeError := 'El dato SII "Fecha exp. DUA" debe tener formato DD/MM/AAAA en el documento ' + NoDocumento;
                    END;

                    RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'INT_DuaPais');
                    IF (NOT RecDatosSIIDocumento.FINDFIRST) OR (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                        ExisteError := TRUE;
                        TextoMensajeError := 'El dato SII "País DUA" debe estar informado en el documento '
                        + NoDocumento;
                    END;
                    // Linea/s DUA (Debe existir al menos 1)
                    IF "Venta-Compra" = "Venta-Compra"::Compra THEN
                        IF TipoDocumento IN [1, 2, 3, 5] THEN // Pedido compra, Factura compra, Abono compra, Dev. compra
                        BEGIN
                            ExisteLineaDUA := FALSE;
                            RecLinCompra.RESET;
                            RecLinCompra.SETRANGE(RecLinCompra."Document Type", TipoDocumento);
                            RecLinCompra.SETRANGE(RecLinCompra."Document No.", NoDocumento);
                            RecLinCompra.SETFILTER(RecLinCompra."VAT Prod. Posting Group", '<>%1', '');
                            IF NOT RecLinCompra.FINDFIRST THEN BEGIN
                                ExisteError := TRUE;
                                TextoMensajeError := 'Al llevar información DUA, debe existir al menos una línea de IVA configurada como DUA.';
                            END ELSE
                                REPEAT
                                    RecConfigDatosIVA.RESET;
                                    RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Tipo configuración", RecConfigDatosIVA."Tipo configuración"::"Tipo IVA");
                                    RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Gr. Reg. IVA Negocio", RecLinCompra."VAT Bus. Posting Group");
                                    RecConfigDatosIVA.SETRANGE(RecConfigDatosIVA."Gr. Reg. IVA Producto", RecLinCompra."VAT Prod. Posting Group");
                                    IF (RecConfigDatosIVA.FINDFIRST) AND (RecConfigDatosIVA.DUA) THEN
                                        ExisteLineaDUA := TRUE;
                                UNTIL RecLinCompra.NEXT = 0;
                            IF NOT ExisteLineaDUA THEN BEGIN
                                ExisteError := TRUE;
                                TextoMensajeError := 'Al tratarse de documento DUA, debe existir al menos una línea de IVA configurada como DUA.';
                            END;
                        END;
                END;
            END;
            // * TRATAMIENTO DUA **************************************************************


            //ClaveRegimenEspecialOTrascendencia 11,12,13: Informar "SituacionInmueble"
            IF "Venta-Compra" = "Venta-Compra"::Venta THEN BEGIN
                RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'ClaveRegimenEspecialOTrascendencia');
                IF (RecDatosSIIDocumento.FINDFIRST) AND (RecDatosSIIDocumento."Valor dato SII" IN ['11', '12', '13']) THEN BEGIN
                    RecDatosSIIDocumento.SETRANGE("Dato SII a exportar como", 'SituacionInmueble');
                    IF (NOT RecDatosSIIDocumento.FINDFIRST) OR (RecDatosSIIDocumento."Valor dato SII" = '') THEN BEGIN
                        ExisteError := TRUE;
                        TextoMensajeError := 'El dato SII "Situacion Inmueble" debe estar informado en el documento '
                        + NoDocumento;
                    END;
                END;
            END;
        END;

        /*EX-AHG SII+ 140717*/

    end;


    procedure AgruparImpuestos(var Loc_RecDocsSIIaProcesar: Record 50601; var Tmp_DocsSIIaProcesar: Record 50601 temporary; CambiarEstado: Boolean)
    var
        NLinea: Integer;
        RecConfigCont: Record 98;
        PrecisionRedondeo: Decimal;
        TipoRedondeo: Text[1];
    begin

        // Recibe documentos del panel de control del SII, y los devuelve en temporal agrupado por los criterios oficiales.
        // El parámetro "CambiarEstado" , los pone en "Incluido en fichero".

        Tmp_DocsSIIaProcesar.DELETEALL;
        NLinea := 1;
        Loc_RecDocsSIIaProcesar.SETCURRENTKEY("Tipo registro", "Tipo documento", "No. documento", "Desglose tipo operación",
                                              "Tipo no exenta", "Inv. Sujeto Pasivo", "Tipo impositivo no exenta");
        Loc_RecDocsSIIaProcesar.SETRANGE(Loc_RecDocsSIIaProcesar."Tipo registro", Loc_RecDocsSIIaProcesar."Tipo registro"::Detalles);
        IF Loc_RecDocsSIIaProcesar.FINDSET THEN
            REPEAT
                // Insertando en temporal por Documento agrupadas por los criterios:
                // Emitidas/Recibidas -  Tipo desglose (B,S) - Tipo NO Exención (1,2,3) - Tipo IVA (xx,xx%) - Desglose IVA - Causa exención
                Tmp_DocsSIIaProcesar.RESET;
                Tmp_DocsSIIaProcesar.SETRANGE("Tipo documento", Loc_RecDocsSIIaProcesar."Tipo documento");
                Tmp_DocsSIIaProcesar.SETRANGE("No. documento", Loc_RecDocsSIIaProcesar."No. documento");
                Tmp_DocsSIIaProcesar.SETRANGE("Origen documento", Loc_RecDocsSIIaProcesar."Origen documento");
                Tmp_DocsSIIaProcesar.SETRANGE("Desglose tipo operación", Loc_RecDocsSIIaProcesar."Desglose tipo operación");
                Tmp_DocsSIIaProcesar.SETRANGE("Tipo no exenta", Loc_RecDocsSIIaProcesar."Tipo no exenta");
                Tmp_DocsSIIaProcesar.SETRANGE("Inv. Sujeto Pasivo", Loc_RecDocsSIIaProcesar."Inv. Sujeto Pasivo");
                Tmp_DocsSIIaProcesar.SETRANGE("Tipo impositivo no exenta", Loc_RecDocsSIIaProcesar."Tipo impositivo no exenta");
                Tmp_DocsSIIaProcesar.SETRANGE("% Compensación REAGYP", Loc_RecDocsSIIaProcesar."% Compensación REAGYP");
                Tmp_DocsSIIaProcesar.SETRANGE("Tipo No sujeta", Loc_RecDocsSIIaProcesar."Tipo No sujeta");
                Tmp_DocsSIIaProcesar.SETRANGE(DesgloseIVAFactura, Loc_RecDocsSIIaProcesar.DesgloseIVAFactura);
                Tmp_DocsSIIaProcesar.SETRANGE("Cód. causa exención", Loc_RecDocsSIIaProcesar."Cód. causa exención");
                Tmp_DocsSIIaProcesar.SETRANGE("Tipo RE no exenta", Loc_RecDocsSIIaProcesar."Tipo RE no exenta");
                IF Tmp_DocsSIIaProcesar.FINDFIRST THEN BEGIN
                    Tmp_DocsSIIaProcesar."Base imponible no exenta" += Loc_RecDocsSIIaProcesar."Base imponible no exenta";
                    Tmp_DocsSIIaProcesar."Importe no sujeta Art. 7,14" += Loc_RecDocsSIIaProcesar."Importe no sujeta Art. 7,14";
                    Tmp_DocsSIIaProcesar."Importe no sujeta localización" += Loc_RecDocsSIIaProcesar."Importe no sujeta localización";
                    Tmp_DocsSIIaProcesar."IVA Diferencia" += Loc_RecDocsSIIaProcesar."IVA Diferencia";
                    Tmp_DocsSIIaProcesar."RE Diferencia" += Loc_RecDocsSIIaProcesar."RE Diferencia";
                    Tmp_DocsSIIaProcesar."Base Imponible exenta" += Loc_RecDocsSIIaProcesar."Base Imponible exenta";
                    Tmp_DocsSIIaProcesar."Base imponible no sujeta" += Loc_RecDocsSIIaProcesar."Base imponible no sujeta";
                    Tmp_DocsSIIaProcesar."Cuota imp. no exenta" += Loc_RecDocsSIIaProcesar."Cuota imp. no exenta";
                    Tmp_DocsSIIaProcesar.MODIFY;
                END ELSE BEGIN
                    Tmp_DocsSIIaProcesar.TRANSFERFIELDS(Loc_RecDocsSIIaProcesar);
                    Tmp_DocsSIIaProcesar."No. Línea" := NLinea;
                    Tmp_DocsSIIaProcesar.INSERT;
                    NLinea += 1;
                END;
                IF CambiarEstado THEN BEGIN
                    //260218 EX-JVN
                    //Loc_RecDocsSIIaProcesar."Estado documento":=Loc_RecDocsSIIaProcesar."Estado documento"::"Incluido en fichero";
                    Loc_RecDocsSIIaProcesar.VALIDATE("Estado documento", Loc_RecDocsSIIaProcesar."Estado documento"::"Incluido en fichero");
                    //260218 EX-JVN FIN
                    Loc_RecDocsSIIaProcesar."Fecha exportación ficheros" := CURRENTDATETIME;
                    Loc_RecDocsSIIaProcesar.MODIFY;
                END;
            UNTIL Loc_RecDocsSIIaProcesar.NEXT = 0;

        // Re-cálculo y redondeo de Cuotas acumuladas
        RecConfigCont.GET;
        PrecisionRedondeo := RecConfigCont."Amount Rounding Precision";
        CASE RecConfigCont."VAT Rounding Type" OF
            RecConfigCont."VAT Rounding Type"::Nearest:
                TipoRedondeo := '=';
            RecConfigCont."VAT Rounding Type"::Up:
                TipoRedondeo := '>';
            RecConfigCont."VAT Rounding Type"::Down:
                TipoRedondeo := '<';
        END;

        Tmp_DocsSIIaProcesar.RESET;

        IF Tmp_DocsSIIaProcesar.FINDSET THEN
            REPEAT
                //WITH Tmp_DocsSIIaProcesar DO BEGIN
                // AHG
                IF Tmp_DocsSIIaProcesar."Base imponible no exenta" <> 0 THEN BEGIN
                    IF Tmp_DocsSIIaProcesar."Tipo impositivo no exenta" <> 0 THEN
                        Tmp_DocsSIIaProcesar."Cuota imp. no exenta" := ROUND((Tmp_DocsSIIaProcesar."Base imponible no exenta" *
                        (Tmp_DocsSIIaProcesar."Tipo impositivo no exenta" / 100)) + Tmp_DocsSIIaProcesar."IVA Diferencia",
                         RecConfigCont."Amount Rounding Precision", TipoRedondeo);
                    IF Tmp_DocsSIIaProcesar."Tipo RE no exenta" <> 0 THEN
                        Tmp_DocsSIIaProcesar."Cuota RE no exenta" := ROUND((Tmp_DocsSIIaProcesar."Base imponible no exenta"
                        * (Tmp_DocsSIIaProcesar."Tipo RE no exenta" / 100)) + Tmp_DocsSIIaProcesar."RE Diferencia",
                         RecConfigCont."Amount Rounding Precision", TipoRedondeo);
                    IF Tmp_DocsSIIaProcesar."% Compensación REAGYP" <> 0 THEN
                        Tmp_DocsSIIaProcesar."Importe Compensación REAGYP" := ROUND((Tmp_DocsSIIaProcesar."Base imponible no exenta"
                        * (Tmp_DocsSIIaProcesar."% Compensación REAGYP" / 100)) + Tmp_DocsSIIaProcesar."IVA Diferencia",
                         RecConfigCont."Amount Rounding Precision", TipoRedondeo);
                END;

                Tmp_DocsSIIaProcesar."Base imponible no sujeta" := ROUND(Tmp_DocsSIIaProcesar."Base imponible no sujeta", RecConfigCont."Amount Rounding Precision", TipoRedondeo);
                Tmp_DocsSIIaProcesar."Base Imponible exenta" := ROUND(Tmp_DocsSIIaProcesar."Base Imponible exenta", RecConfigCont."Amount Rounding Precision", TipoRedondeo);
                Tmp_DocsSIIaProcesar."Base imponible no exenta" := ROUND(Tmp_DocsSIIaProcesar."Base imponible no exenta", RecConfigCont."Amount Rounding Precision", TipoRedondeo);

                Tmp_DocsSIIaProcesar."Importe no sujeta Art. 7,14" := ROUND(Tmp_DocsSIIaProcesar."Importe no sujeta Art. 7,14", RecConfigCont."Amount Rounding Precision", TipoRedondeo);
                Tmp_DocsSIIaProcesar."Importe no sujeta localización" := ROUND(Tmp_DocsSIIaProcesar."Importe no sujeta localización", RecConfigCont."Amount Rounding Precision", TipoRedondeo);

                Tmp_DocsSIIaProcesar.MODIFY;
            // END;
            UNTIL Tmp_DocsSIIaProcesar.NEXT = 0;
    end;


    procedure DevuelveNIFIDFiscalContraparte(lCIFNIF: Text[20]; lPais: Code[2]) lNIFIDFiscalContra: Code[20]
    begin
        lNIFIDFiscalContra := COPYSTR(lPais + lCIFNIF, 1, MAXSTRLEN(lNIFIDFiscalContra));
        IF STRLEN(lCIFNIF) > 1 THEN
            IF COPYSTR(lCIFNIF, 1, 2) = lPais THEN
                lNIFIDFiscalContra := lCIFNIF;
    end;



    /// <summary>
    /// ExcluirLinea.
    /// </summary>
    /// <param name="Tipo">Enum "Service Line Type".</param>
    /// <param name="No">Code[20].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ExcluirLinea(Tipo: Enum "Service Line Type"; No: Code[20]): Boolean
    var
        RecCuenta: Record 15;
    begin
        // Si se trata de Cuenta, y no tiene marcado "Excluir SII", devolverá False.

        CASE Tipo OF
            Tipo::"G/L Account":
                BEGIN
                    IF RecCuenta.GET(No) THEN
                        EXIT(RecCuenta."Excluir SII");
                END;

        END;

        EXIT(FALSE);
    end;


    /// <summary>
    /// PermitirModificarDoc.
    /// </summary>
    /// <param name="lEstado">enum "SII Estado documento".</param>
    /// <param name="lError">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure PermitirModificarDoc(lEstado: enum "SII Estado documento"; lError: Boolean): Boolean
    begin
        IF NOT (lEstado IN [lEstado::" ", lEstado::"Obtener de nuevo"]) THEN
            IF lError THEN
                ERROR('SII Estado documento no debe tener el valor ' + FORMAT(lEstado))
            ELSE
                EXIT(FALSE);

        EXIT(TRUE);
    end;

    local procedure CrearDocumentoSII_DUA(var RecDocSIICabeceraDUAProveedor: Record 50601; CodDivisa: Code[20]; FactorDivisa: Decimal)
    var
        RecDatosSIIDetallesOrigen: Record 50601;
        RecDatosSIIDetallesDestino: Record 50601;
        NoLinea: Integer;
        RecNuevoDocSIIDUACabecera: Record 50601;
        RecDatosSIIOrigen: Record "SII- Datos documento";
        Decimal: Decimal;
        RecConfigEmpresaSII: Record 50605;
        AcumuladoBase: Decimal;
        RecConfigContabilidad: Record 98;
        TipoImpositivoDUA: Decimal;
    begin

        // En los casos de ser DUA informado en factura F1 de proveedor  se creará un documento SII ficticio sin respaldo navegable
        // con los datos de las líneas configuradas con Iva DUA en config múltiple, y con los Datos SII específicos de DUA de la factura
        // registrada.

        RecConfigEmpresaSII.GET;
        // Crear nueva cabecera DUA
        RecDocSIICabeceraDUAProveedor.CALCFIELDS(RecDocSIICabeceraDUAProveedor."No Lineas detalle");
        RecNuevoDocSIIDUACabecera.RESET;
        RecNuevoDocSIIDUACabecera.TRANSFERFIELDS(RecDocSIICabeceraDUAProveedor);
        NoLinea := RecDocSIICabeceraDUAProveedor."No. Línea" + RecDocSIICabeceraDUAProveedor."No Lineas detalle" + 1;
        RecNuevoDocSIIDUACabecera."No. Línea" := NoLinea;

        // Datos SII informados del documento original a distribuir en diferentes campos en el nuevo documento:
        RecDatosSIIOrigen.RESET;
        IF RecDocSIICabeceraDUAProveedor."Tipo documento" = RecDocSIICabeceraDUAProveedor."Tipo documento"::Factura THEN
            RecDatosSIIOrigen.SETRANGE(RecDatosSIIOrigen."Tipo documento", RecDatosSIIOrigen."Tipo documento"::"Factura recibida reg.");
        IF RecDocSIICabeceraDUAProveedor."Tipo documento" = RecDocSIICabeceraDUAProveedor."Tipo documento"::Abono THEN
            RecDatosSIIOrigen.SETRANGE(RecDatosSIIOrigen."Tipo documento", RecDatosSIIOrigen."Tipo documento"::"Abono recibido reg.");
        RecDatosSIIOrigen.SETRANGE(RecDatosSIIOrigen."No. Documento", RecDocSIICabeceraDUAProveedor."No. documento");
        IF RecDatosSIIOrigen.FINDSET THEN
            REPEAT
                CASE TRUE OF
                    RecDatosSIIOrigen."Dato SII a exportar como" = 'INT_DuaNumero':
                        RecNuevoDocSIIDUACabecera."No. documento" := RecDatosSIIOrigen."Valor dato SII";
                    RecDatosSIIOrigen."Dato SII a exportar como" = 'INT_DuaPais':
                        RecNuevoDocSIIDUACabecera."Cód. país contraparte" := RecDatosSIIOrigen."Valor dato SII";
                    RecDatosSIIOrigen."Dato SII a exportar como" = 'INT_DuaBase':
                        BEGIN
                            IF RecDocSIICabeceraDUAProveedor."Tipo documento" = RecDocSIICabeceraDUAProveedor."Tipo documento"::Abono THEN
                                Decimal := Decimal * -1;
                            IF EVALUATE(Decimal, RecDatosSIIOrigen."Valor dato SII") THEN
                                RecNuevoDocSIIDUACabecera."Total Base imponible" := CurrExchRate.ExchangeAmtFCYToLCY(
                                                                                     RecDocSIICabeceraDUAProveedor."Fecha de registro",
                                                                                     CodDivisa,
                                                                                     Decimal,
                                                                                     FactorDivisa);
                        END;
                    RecDatosSIIOrigen."Dato SII a exportar como" = 'INT_DuaFechaExpedicion':
                        IF EVALUATE(RecNuevoDocSIIDUACabecera."Fecha de registro", RecDatosSIIOrigen."Valor dato SII") THEN
                            ;
                    //EX-SMN 031117
                    RecDatosSIIOrigen."Dato SII a exportar como" = 'INT_DuaTipoImpositivo':
                        IF EVALUATE(TipoImpositivoDUA, RecDatosSIIOrigen."Valor dato SII") THEN
                            ;
                //EX-SMN FIN
                END;
            UNTIL RecDatosSIIOrigen.NEXT = 0;
        RecNuevoDocSIIDUACabecera."Tipo factura" := 'F5';
        RecNuevoDocSIIDUACabecera."Clave régimen especial" := '01';
        RecNuevoDocSIIDUACabecera."NIF Contraparte operación" := RecConfigEmpresaSII."NIF Declarante";
        RecNuevoDocSIIDUACabecera."Tipo procedencia" := RecNuevoDocSIIDUACabecera."Tipo procedencia"::DUA;
        RecNuevoDocSIIDUACabecera."Nº serie registro" := '';
        RecNuevoDocSIIDUACabecera."Importe total documento" := 0;
        RecNuevoDocSIIDUACabecera."Cuota deducible" := 0;
        RecNuevoDocSIIDUACabecera."Nº Doc. proveedor" := RecDocSIICabeceraDUAProveedor."No Doc. DUA";
        RecNuevoDocSIIDUACabecera."Tipo DUA" := RecNuevoDocSIIDUACabecera."Tipo DUA"::Transitario;
        RecNuevoDocSIIDUACabecera."Nombre procedencia" := COPYSTR(RecConfigEmpresaSII."Apell. Nombre.- Razón social", 1, 100);
        RecNuevoDocSIIDUACabecera."Clave Id. fiscal residencia" := '';
        RecNuevoDocSIIDUACabecera."NIF/ID. fiscal país residencia" := '';
        RecNuevoDocSIIDUACabecera.INSERT;


        // Crear lineas/s DUA
        CLEAR(AcumuladoBase); //251017 EX-JVN
        RecConfigContabilidad.GET; //251017 EX-JVN
        RecDatosSIIDetallesOrigen.SETRANGE(RecDatosSIIDetallesOrigen."Tipo documento", RecDocSIICabeceraDUAProveedor."Tipo documento");
        RecDatosSIIDetallesOrigen.SETRANGE(RecDatosSIIDetallesOrigen."No. documento", RecDocSIICabeceraDUAProveedor."No. documento");
        RecDatosSIIDetallesOrigen.SETRANGE(RecDatosSIIDetallesOrigen."Tipo registro", RecDatosSIIDetallesOrigen."Tipo registro"::Detalles);
        RecDatosSIIDetallesOrigen.SETRANGE(RecDatosSIIDetallesOrigen."Origen documento", RecDocSIICabeceraDUAProveedor."Origen documento");
        RecDatosSIIDetallesOrigen.SETRANGE(RecDatosSIIDetallesOrigen."Tipo DUA", RecDatosSIIDetallesOrigen."Tipo DUA"::Transitario);
        IF RecDatosSIIDetallesOrigen.FINDSET THEN
            REPEAT
                NoLinea += 1;
                RecDatosSIIDetallesDestino.RESET;
                RecDatosSIIDetallesDestino.TRANSFERFIELDS(RecDatosSIIDetallesOrigen);
                RecDatosSIIDetallesDestino."No. Línea" := NoLinea;
                RecDatosSIIDetallesDestino."No. documento" := RecNuevoDocSIIDUACabecera."No. documento";
                RecDatosSIIDetallesDestino."Tipo procedencia" := RecDatosSIIDetallesDestino."Tipo procedencia"::DUA;
                RecDatosSIIDetallesDestino."Nº serie registro" := '';
                RecDatosSIIDetallesDestino.INSERT;

                // Acumulando por si hay mas de una línea de DUA
                IF RecDocSIICabeceraDUAProveedor."Tipo documento" = RecDocSIICabeceraDUAProveedor."Tipo documento"::Factura THEN BEGIN
                    RecNuevoDocSIIDUACabecera."Importe total documento" += RecDatosSIIDetallesOrigen."Cuota imp. no exenta";
                    RecNuevoDocSIIDUACabecera."Cuota deducible" += RecDatosSIIDetallesOrigen."Cuota imp. no exenta";
                END ELSE BEGIN
                    RecNuevoDocSIIDUACabecera."Importe total documento" += (RecDatosSIIDetallesOrigen."Cuota imp. no exenta") * -1;
                    RecNuevoDocSIIDUACabecera."Cuota deducible" += (RecDatosSIIDetallesOrigen."Cuota imp. no exenta") * -1;
                END;
                RecNuevoDocSIIDUACabecera.MODIFY;

                //251017 EX-JVN Base imponible no exenta
                //EX-SMN 031117
                //RecDatosSIIDetallesDestino."Base imponible no exenta" := RecDatosSIIDetallesDestino."Cuota imp. no exenta" / (RecDatosSIIDetallesDestino."Tipo impositivo no exenta"/100);
                RecDatosSIIDetallesDestino."Base imponible no exenta" := RecNuevoDocSIIDUACabecera."Total Base imponible";
                RecDatosSIIDetallesDestino."Tipo impositivo no exenta" := TipoImpositivoDUA;
                //RecDatosSIIDetallesDestino."Base imponible no exenta":=ROUND(RecDatosSIIDetallesDestino."Base imponible no exenta", RecConfigContabilidad."Inv. Rounding Precision (LCY)");
                //AcumuladoBase += RecDatosSIIDetallesDestino."Base imponible no exenta";
                //EX-SMN FIN
                RecDatosSIIDetallesDestino.MODIFY;
            UNTIL RecDatosSIIDetallesOrigen.NEXT = 0;

        //EX-SMN 031117
        /*
        //251017 EX-JVN Incidencia por base DUA
        IF AcumuladoBase <> RecNuevoDocSIIDUACabecera."Total Base imponible" THEN BEGIN
          RecNuevoDocSIIDUACabecera.VALIDATE("Estado documento",RecNuevoDocSIIDUACabecera."Estado documento"::Incidencias);
          RecNuevoDocSIIDUACabecera."Log. incidencias" := 'El Dato SII de Base imponible DUA no coincide con lo calculado en las líneas.';
        END;
        */
        //EX-SMN FIN
        //101017 EX-JVN Añadimos la Base imponible DUA a la cabecera
        IF RecDocSIICabeceraDUAProveedor."Tipo documento" = RecDocSIICabeceraDUAProveedor."Tipo documento"::Factura THEN
            RecNuevoDocSIIDUACabecera."Importe total documento" += RecNuevoDocSIIDUACabecera."Total Base imponible"
        ELSE
            RecNuevoDocSIIDUACabecera."Importe total documento" += (RecNuevoDocSIIDUACabecera."Total Base imponible") * -1;
        RecNuevoDocSIIDUACabecera.MODIFY;

    end;


    procedure SubirFTPNoSeguro()
    var
        v_fichero: File;
        mFile: Record 2000000022;
        Listado: File;
        Archivo: Text[1024];
        RecDocumentosSII: Record 50601;
        RecDocumentosSII2: Record 50601;
        process: DotNet Process;
    begin
        Pt_InfoEmpresa.GET;

        // Abrir y leer ficheros para localizar documentos y cambirlos de Estado a "Enviado a plataforma"
        mFile.RESET;
        mFile.SETRANGE(Path, Pt_InfoEmpresa."Ruta ficheros SII");
        mFile.SETFILTER(Name, '*LRF*.txt');
        IF mFile.FINDSET THEN
            REPEAT
                // "EC" indica fichero de cobros. "RP" indica fichero de pagos.
                IF (STRPOS(mFile.Name, 'EC') = 0) AND (STRPOS(mFile.Name, 'RP') = 0) THEN BEGIN // Es Fichero de facturas
                    RecDocumentosSII.RESET;
                    RecDocumentosSII.SETRANGE(RecDocumentosSII."Incluido en fichero", mFile.Name);
                    IF RecDocumentosSII.FINDSET THEN
                        REPEAT
                            RecDocumentosSII."Estado documento" := RecDocumentosSII."Estado documento"::"Enviado a plataforma";
                            RecDocumentosSII.MODIFY;
                            IF RecDocumentosSII."Tipo registro" = RecDocumentosSII."Tipo registro"::Cabecera THEN BEGIN
                                RecDocumentosSII2.RESET;
                                RecDocumentosSII2.SETRANGE("Tipo registro", RecDocumentosSII2."Tipo registro"::Detalles);
                                RecDocumentosSII2.SETRANGE("Tipo documento", RecDocumentosSII."Tipo documento");
                                RecDocumentosSII2.SETRANGE("No. documento", RecDocumentosSII."No. documento");
                                IF RecDocumentosSII2.FINDSET THEN
                                    RecDocumentosSII2.MODIFYALL("Estado documento", RecDocumentosSII2."Estado documento"::"Enviado a plataforma");
                            END;
                        UNTIL RecDocumentosSII.NEXT = 0;
                END;
            //ELSE Es Fichero de cobros/pagos
            UNTIL mFile.NEXT = 0;

        CLEAR(v_fichero);
        v_fichero.TEXTMODE(TRUE);
        v_fichero.CREATE(Pt_InfoEmpresa."Ruta ficheros SII" + '\Info.txt');
        //v_fichero.WRITE('OPEN ' + Pt_InfoEmpresa."Servidor FTP SII"); //EX-SGG 300617 COMENTO PARA FTPS.
        v_fichero.WRITE(Pt_InfoEmpresa."Usuario FTP");
        v_fichero.WRITE(Pt_InfoEmpresa."Contraseña FTP");
        v_fichero.WRITE('PROMPT');
        //v_fichero.WRITE('PASSIVE'); //EX-SGG 300617 NECESARIO PARA FTPS.
        IF Pt_InfoEmpresa."Ruta subida ficheros FTP SII" <> '' THEN
            v_fichero.WRITE('CD "' + Pt_InfoEmpresa."Ruta subida ficheros FTP SII" + '"');
        //v_fichero.WRITE('LCD "'+Pt_InfoEmpresa."Ruta ficheros SII"+'"');
        v_fichero.WRITE('LCD ' + Pt_InfoEmpresa."Ruta ficheros SII"); //EX-SGG 300617 FTPS SIN "".
        v_fichero.WRITE('MPUT *LR*.txt');
        v_fichero.WRITE('CLOSE');
        v_fichero.WRITE('QUIT');
        v_fichero.CLOSE;

        process := process.Process;
        process.StartInfo.UseShellExecute := FALSE;
        //process.StartInfo.FileName := 'ftps.exe';
        //process.StartInfo.Arguments := '-z -d -t:5 -e:implicit '+Pt_InfoEmpresa."Servidor FTP SII"+' -s:"'+Pt_InfoEmpresa."Ruta ficheros SII"+'\Info.txt"';
        process.StartInfo.FileName := 'ftp.exe';
        process.StartInfo.Arguments := ' -s:"' + Pt_InfoEmpresa."Ruta ficheros SII" + '\Info.txt"' + ' ' + Pt_InfoEmpresa."Servidor FTP SII";
        process.StartInfo.CreateNoWindow := TRUE;
        process.Start();
        process.WaitForExit; //110917 EX-JVN
        CLEAR(process);

        //SLEEP(5000)
        IF FILE.EXISTS(Pt_InfoEmpresa."Ruta ficheros SII" + '\Info.txt') THEN
            FILE.ERASE(Pt_InfoEmpresa."Ruta ficheros SII" + '\Info.txt');
        SLEEP(500);

        mFile.RESET;
        mFile.SETRANGE(Path, Pt_InfoEmpresa."Ruta ficheros SII");
        mFile.SETFILTER(Name, '%1', '*.txt');
        IF mFile.FINDSET THEN
            REPEAT
                IF FILE.EXISTS(STRSUBSTNO('%1\%2', Pt_InfoEmpresa."Ruta ficheros entregados SII", mFile.Name)) THEN BEGIN
                    FILE.RENAME(STRSUBSTNO('%1\%2', Pt_InfoEmpresa."Ruta ficheros SII", mFile.Name),
                      STRSUBSTNO('%1\%3_%2', Pt_InfoEmpresa."Ruta ficheros entregados SII", mFile.Name, DELCHR(FORMAT(TIME), '=', ':')));
                END ELSE
                    FILE.RENAME(STRSUBSTNO('%1\%2', Pt_InfoEmpresa."Ruta ficheros SII", mFile.Name),
                      STRSUBSTNO('%1\%2', Pt_InfoEmpresa."Ruta ficheros entregados SII", mFile.Name));
            UNTIL mFile.NEXT = 0;
    end;


    procedure ModificarFacturaSimplificada(TipoDocumento: Integer; NoDocumento: Code[20]; DesdeTicket: Code[20]; HastaTicket: Code[20]; Agrupar: Boolean; JnTemplate: Code[10]; JnlBatch: Code[10])
    var
        RecTablaMaestraValores: Record "SII- Tablas valores SII";
        RecConfigDatosDocumento: Record "SII- Config. múltiple";
        RecDatosDocumento: Record "SII- Datos documento";
        GnJnLine: Record 81;
        ConfCont: Record 98;
    begin
        /*
        TipoFactura                        F4
        TipoComunicacion                   A0
        ClaveRegimenEspecialOTrascendencia 01
        DescripcionOperacion               Asiento resumen de tickets
        Número inicial factura resumen     Se indicara el primer ticket del monitor de ventas se busca el ticket por Fecha y delegación y el pr
        Número final factura resumen       Se indicara el número de documento del ultimo ticket por fecha y delegación.
        */

        IF Agrupar THEN BEGIN
            /*
              GnJnLine.RESET;
              GnJnLine.SETRANGE("Journal Template Name",JnTemplate);
              GnJnLine.SETRANGE("Journal Batch Name",JnlBatch);
              IF GnJnLine.FINDSET THEN
              REPEAT
                IF GnJnLine."Document No." <> DesdeTicket THEN BEGIN
                  GnJnLine."Document No." := DesdeTicket;
                  GnJnLine.MODIFY;
                END;
              UNTIL GnJnLine.NEXT = 0;
            */

            RecConfigDatosDocumento.RESET;
            RecConfigDatosDocumento.SETRANGE("Tipo configuración", RecConfigDatosDocumento."Tipo configuración"::"Datos por documento");
            RecConfigDatosDocumento.SETRANGE(RecConfigDatosDocumento.Desactivar, FALSE);
            RecConfigDatosDocumento.SETRANGE("Informar en documento", RecConfigDatosDocumento."Informar en documento"::Expedido);
            RecConfigDatosDocumento.SETRANGE("Tipo de documento", RecConfigDatosDocumento."Tipo de documento"::Facturas);

            RecConfigDatosDocumento.SETRANGE("Dato SII a exportar como", 'TipoFactura');
            IF RecConfigDatosDocumento.FINDFIRST THEN BEGIN
                RecDatosDocumento.INIT;
                RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Factura emitida";
                RecDatosDocumento."No. Documento" := NoDocumento;
                RecDatosDocumento."Dato SII" := RecConfigDatosDocumento."Nombre dato SII";
                RecDatosDocumento."Desc. dato SII" := RecConfigDatosDocumento.Observaciones;
                RecDatosDocumento."Filtro valores maestros SII" := RecConfigDatosDocumento."Filtro tabla valores SII";
                RecDatosDocumento.Orden := RecConfigDatosDocumento.Orden;
                RecDatosDocumento."Valor dato SII" := 'F4';
                RecDatosDocumento.Obligatorio := RecConfigDatosDocumento.Obligatorio;
                RecDatosDocumento."Dato SII a exportar como" := RecConfigDatosDocumento."Dato SII a exportar como";
                IF NOT RecDatosDocumento.INSERT THEN
                    RecDatosDocumento.MODIFY;
            END;

            RecConfigDatosDocumento.SETRANGE("Dato SII a exportar como", 'TipoComunicacion');
            IF RecConfigDatosDocumento.FINDFIRST THEN BEGIN
                RecDatosDocumento.INIT;
                RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Factura emitida";
                RecDatosDocumento."No. Documento" := NoDocumento;
                RecDatosDocumento."Dato SII" := RecConfigDatosDocumento."Nombre dato SII";
                RecDatosDocumento."Desc. dato SII" := RecConfigDatosDocumento.Observaciones;
                RecDatosDocumento."Filtro valores maestros SII" := RecConfigDatosDocumento."Filtro tabla valores SII";
                RecDatosDocumento.Orden := RecConfigDatosDocumento.Orden;
                RecDatosDocumento."Valor dato SII" := 'A0';
                RecDatosDocumento.Obligatorio := RecConfigDatosDocumento.Obligatorio;
                RecDatosDocumento."Dato SII a exportar como" := RecConfigDatosDocumento."Dato SII a exportar como";
                IF NOT RecDatosDocumento.INSERT THEN
                    RecDatosDocumento.MODIFY;
            END;

            RecConfigDatosDocumento.SETRANGE("Dato SII a exportar como", 'ClaveRegimenEspecialOTrascendencia');
            IF RecConfigDatosDocumento.FINDFIRST THEN BEGIN
                RecDatosDocumento.INIT;
                RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Factura emitida";
                RecDatosDocumento."No. Documento" := NoDocumento;
                RecDatosDocumento."Dato SII" := RecConfigDatosDocumento."Nombre dato SII";
                RecDatosDocumento."Desc. dato SII" := RecConfigDatosDocumento.Observaciones;
                RecDatosDocumento."Filtro valores maestros SII" := RecConfigDatosDocumento."Filtro tabla valores SII";
                RecDatosDocumento.Orden := RecConfigDatosDocumento.Orden;
                RecDatosDocumento."Valor dato SII" := '01';
                RecDatosDocumento.Obligatorio := RecConfigDatosDocumento.Obligatorio;
                RecDatosDocumento."Dato SII a exportar como" := RecConfigDatosDocumento."Dato SII a exportar como";
                IF NOT RecDatosDocumento.INSERT THEN
                    RecDatosDocumento.MODIFY;
            END;

            RecConfigDatosDocumento.SETRANGE("Dato SII a exportar como", 'DescripcionOperacion');
            IF RecConfigDatosDocumento.FINDFIRST THEN BEGIN
                RecDatosDocumento.INIT;
                RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Factura emitida";
                RecDatosDocumento."No. Documento" := NoDocumento;
                RecDatosDocumento."Dato SII" := RecConfigDatosDocumento."Nombre dato SII";
                RecDatosDocumento."Desc. dato SII" := RecConfigDatosDocumento.Observaciones;
                RecDatosDocumento."Filtro valores maestros SII" := RecConfigDatosDocumento."Filtro tabla valores SII";
                RecDatosDocumento.Orden := RecConfigDatosDocumento.Orden;
                RecDatosDocumento."Valor dato SII" := 'Asiento resumen de tickets';
                RecDatosDocumento.Obligatorio := RecConfigDatosDocumento.Obligatorio;
                RecDatosDocumento."Dato SII a exportar como" := RecConfigDatosDocumento."Dato SII a exportar como";
                IF NOT RecDatosDocumento.INSERT THEN
                    RecDatosDocumento.MODIFY;
            END;

            //Número final factura resumen
            RecConfigDatosDocumento.SETRANGE("Dato SII a exportar como", 'NumeroFacturaEmisorResumenFin');
            IF RecConfigDatosDocumento.FINDFIRST THEN BEGIN
                RecDatosDocumento.INIT;
                RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Factura emitida";
                RecDatosDocumento."No. Documento" := NoDocumento;
                RecDatosDocumento."Dato SII" := RecConfigDatosDocumento."Nombre dato SII";
                RecDatosDocumento."Desc. dato SII" := RecConfigDatosDocumento.Observaciones;
                RecDatosDocumento."Filtro valores maestros SII" := RecConfigDatosDocumento."Filtro tabla valores SII";
                RecDatosDocumento.Orden := RecConfigDatosDocumento.Orden;
                RecDatosDocumento."Valor dato SII" := HastaTicket;
                RecDatosDocumento.Obligatorio := RecConfigDatosDocumento.Obligatorio;
                RecDatosDocumento."Dato SII a exportar como" := RecConfigDatosDocumento."Dato SII a exportar como";
                IF NOT RecDatosDocumento.INSERT THEN
                    RecDatosDocumento.MODIFY;
            END;

            //Número inicial factura resumen
            RecConfigDatosDocumento.SETRANGE("Dato SII a exportar como", 'INT_NumSerieFacturaEmisorResumenInicial');
            IF RecConfigDatosDocumento.FINDFIRST THEN BEGIN
                RecDatosDocumento.INIT;
                RecDatosDocumento."Tipo documento" := RecDatosDocumento."Tipo documento"::"Factura emitida";
                RecDatosDocumento."No. Documento" := NoDocumento;
                RecDatosDocumento."Dato SII" := RecConfigDatosDocumento."Nombre dato SII";
                RecDatosDocumento."Desc. dato SII" := RecConfigDatosDocumento.Observaciones;
                RecDatosDocumento."Filtro valores maestros SII" := RecConfigDatosDocumento."Filtro tabla valores SII";
                RecDatosDocumento.Orden := RecConfigDatosDocumento.Orden;
                RecDatosDocumento."Valor dato SII" := DesdeTicket;
                RecDatosDocumento.Obligatorio := RecConfigDatosDocumento.Obligatorio;
                RecDatosDocumento."Dato SII a exportar como" := RecConfigDatosDocumento."Dato SII a exportar como";
                IF NOT RecDatosDocumento.INSERT THEN
                    RecDatosDocumento.MODIFY;
            END;

            GnJnLine.RESET;
            GnJnLine.SETRANGE("Journal Template Name", JnTemplate);
            GnJnLine.SETRANGE("Journal Batch Name", JnlBatch);
            IF GnJnLine.FINDSET THEN BEGIN
                GnJnLine.MODIFYALL("SII Datos Documento", TRUE);
                GnJnLine.MODIFYALL("SII Fecha envío a control", GnJnLine."Posting Date");
            END;
        END;

    end;


    /// <summary>
    /// Ascii2UTF8.
    /// </summary>
    /// <param name="lTxt">Text[1024].</param>
    /// <returns>Return value of type Text[1024].</returns>
    procedure Ascii2UTF8(lTxt: Text[1024]): Text[1024]
    var
        lArrS: array[24] of Text[1];
        lArrC: array[24] of Char;
        lAux: Text[1024];
        li: Integer;
        ln: Integer;
    begin

        //EX-SGG 010817 UTF8
        IF STRLEN(lTxt) = 0 THEN EXIT(lTxt);

        lArrS[1] := 'á';
        lArrS[3] := 'Á';
        lArrS[5] := 'é';
        lArrS[7] := 'É';
        lArrS[9] := 'í';
        lArrS[11] := 'Í';
        lArrS[13] := 'ó';
        lArrS[15] := 'Ó';
        lArrS[17] := 'ú';
        lArrS[19] := 'Ú';
        lArrS[21] := 'ñ';
        lArrS[23] := 'Ñ';

        FOR ln := 1 TO 23 DO BEGIN
            lArrC[ln] := 195;
            ln += 1;
        END;

        lArrC[2] := 161;
        lArrC[4] := 129;
        lArrC[6] := 248; //229
        lArrC[8] := 137;
        lArrC[10] := 173;
        lArrC[12] := 141;
        lArrC[14] := 179;
        lArrC[16] := 147;
        lArrC[18] := 186;
        lArrC[20] := 154;
        lArrC[22] := 176; //177 178
        lArrC[24] := 145;

        FOR li := 1 TO STRLEN(lTxt) DO BEGIN
            FOR ln := 1 TO 23 DO
                IF lArrS[ln] <> '' THEN BEGIN
                    IF FORMAT(lTxt[li]) = lArrS[ln] THEN BEGIN
                        lAux := COPYSTR(lTxt, 1, li - 1);
                        lAux += FORMAT(lArrC[ln]) + FORMAT(lArrC[ln + 1]);
                        lTxt := lAux + COPYSTR(lTxt, li + 1);
                        li += 1;
                        ln := 23;
                    END;
                END;
        END;

        EXIT(lTxt);
    end;

    local procedure ProcesarRespuestaAEAT(vPath: Text; vPathhistorico: Text; tipo: Boolean)
    var
        recControlSIIDocumentos: Record 50601;
        InTextIncidencias: Text;
        respuestaAEAT: File;
        txtField: Text[300];
        txtField2: Text[300];
        lInStr: InStream;
        lBigTxtLin: BigText;
        lc10: Char;
        ls10: Text[1];
        lc09: Char;
        ls09: Text[1];
        lFinLin: Integer;
        lPosLin: Integer;
        vFin: Boolean;
        vFechaReg: Date;
        rec_purchheader: Record 122;
        rec_purchmemoheader: Record 124;
    begin
        /*
          //120918 EX-JVN Nueva funcion
          //EX-SIIv4
          lc10:=10;
          lc09:=9;
          ls10:=FORMAT(lc10);
          ls09:=FORMAT(lc09);
        
          CLEAR(respuestaAEAT);
          CLEAR(lBigTxtLin);
          CLEAR(lInStr);
          respuestaAEAT.TEXTMODE(FALSE);
          respuestaAEAT.OPEN(vPath);
          respuestaAEAT.CREATEINSTREAM(lInStr);
          lBigTxtLin.READ(lInStr);
          lPosLin:=1;
          lFinLin:=lBigTxtLin.TEXTPOS(FORMAT(ls10));
          lBigTxtLin.GETSUBTEXT(lBigTxtLin,lFinLin+1); //quitar la cabecera y salto de linea
          REPEAT
        
            rec_purchheader.RESET;
            rec_purchmemoheader.RESET;
        
            lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls09));
            lBigTxtLin.GETSUBTEXT(txtField,1,lPosLin-1); //NumSerieFactura
            lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
            IF tipo THEN
              recControlSIIDocumentos.SETRANGE("No. documento",txtField)
            ELSE BEGIN
              //recControlSIIDocumentos.SETRANGE("No. documento",txtField)
              recControlSIIDocumentos.SETRANGE("No. Doc. proveedor",txtField);
              rec_purchheader.SETRANGE("Vendor Invoice No.",txtField);
              rec_purchmemoheader.SETRANGE("Vendor Cr. Memo No.",txtField);
            END;
            lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls09));
            lBigTxtLin.GETSUBTEXT(txtField,1,lPosLin-1); //FechaExpedicionFactura
            lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
            EVALUATE(vFechaReg,txtField);
            IF tipo THEN
              recControlSIIDocumentos.SETRANGE("Fecha de registro",vFechaReg)
            ELSE BEGIN
              rec_purchheader.SETRANGE(rec_purchheader."Document Date",vFechaReg);
              IF NOT rec_purchheader.FINDFIRST THEN BEGIN
                rec_purchmemoheader.SETRANGE("Document Date",vFechaReg);
                IF rec_purchmemoheader.FINDFIRST THEN
                  recControlSIIDocumentos.SETRANGE("Fecha de registro",rec_purchmemoheader."Posting Date");
              END ELSE
                recControlSIIDocumentos.SETRANGE("Fecha de registro",rec_purchheader."Posting Date");
            END;
            lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls09));
            lBigTxtLin.GETSUBTEXT(txtField,1,lPosLin-1); //RespuestaAEAT
            lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
            lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls10)); //Fin de linea
            IF lPosLin <> 0 THEN BEGIN
              lBigTxtLin.GETSUBTEXT(txtField2,1,lPosLin-1); //MensajeRespuesta
              lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
              vFin := FALSE;
            END ELSE BEGIN
              lBigTxtLin.GETSUBTEXT(txtField2,1);
              vFin := TRUE;
            END;
            IF recControlSIIDocumentos.FINDFIRST THEN BEGIN
              CASE txtField OF
                'RECHAZADA':
                  recControlSIIDocumentos.VALIDATE("Respuesta AEAT",recControlSIIDocumentos."Respuesta AEAT"::Rechazada);
                'ACEPTADA CON ERRORES':
                  BEGIN
                    recControlSIIDocumentos.VALIDATE("Respuesta AEAT",recControlSIIDocumentos."Respuesta AEAT"::"Acepatada con Errores");
                    recControlSIIDocumentos."Estado documento":=recControlSIIDocumentos."Estado documento"::"Validado AEAT";//EX-SIIv4
                  END;
                'ACEPTADA':
                  BEGIN
                    recControlSIIDocumentos.VALIDATE("Respuesta AEAT",recControlSIIDocumentos."Respuesta AEAT"::Aceptada);
                    recControlSIIDocumentos."Estado documento":=recControlSIIDocumentos."Estado documento"::"Validado AEAT";//EX-SIIv4
                  END;
              END;
              recControlSIIDocumentos."Mensaje Respuesta" := txtField2;
              recControlSIIDocumentos.MODIFY;
            END;
          UNTIL vFin;
        
          respuestaAEAT.CLOSE;
          SLEEP(400);
          FILE.COPY(vPath, vPathhistorico);
          ERASE(vPath);
          */
        /*
        //EX-SIIv4
        lc10:=10;
        lc09:=9;
        ls10:=FORMAT(lc10);
        ls09:=FORMAT(lc09);

        CLEAR(respuestaAEAT);
        CLEAR(lBigTxtLin);
        CLEAR(lInStr);
        respuestaAEAT.TEXTMODE(FALSE);
        respuestaAEAT.OPEN(vPath);
        respuestaAEAT.CREATEINSTREAM(lInStr);
        lBigTxtLin.READ(lInStr);
        lPosLin:=1;
        lFinLin:=lBigTxtLin.TEXTPOS(FORMAT(ls10));
        lBigTxtLin.GETSUBTEXT(lBigTxtLin,lFinLin+1); //quitar la cabecera y salto de linea
        REPEAT
          rec_purchheader.RESET;
          rec_purchmemoheader.RESET;
          lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls09));
          lBigTxtLin.GETSUBTEXT(txtField,1,lPosLin-1); //NumSerieFactura
          lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
          IF tipo THEN
            recControlSIIDocumentos.SETRANGE("No. documento",txtField)
          ELSE BEGIN
            //recControlSIIDocumentos.SETRANGE("No. documento",txtField)
            recControlSIIDocumentos.SETRANGE("No. Doc. proveedor",txtField);
            rec_purchheader.SETRANGE("Vendor Invoice No.",txtField);
            rec_purchmemoheader.SETRANGE("Vendor Cr. Memo No.",txtField);
          END;
          lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls09));
          lBigTxtLin.GETSUBTEXT(txtField,1,lPosLin-1); //FechaExpedicionFactura
          lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
          EVALUATE(vFechaReg,txtField);
          IF tipo THEN
            recControlSIIDocumentos.SETRANGE("Fecha de registro",vFechaReg)
          ELSE BEGIN
            rec_purchheader.SETRANGE(rec_purchheader."Document Date",vFechaReg);
            IF NOT rec_purchheader.FINDFIRST THEN BEGIN
              rec_purchmemoheader.SETRANGE("Document Date",vFechaReg);
              IF rec_purchmemoheader.FINDFIRST THEN
                recControlSIIDocumentos.SETRANGE("Fecha de registro",rec_purchmemoheader."Posting Date");
            END ELSE
              recControlSIIDocumentos.SETRANGE("Fecha de registro",rec_purchheader."Posting Date");
          END;

          IF NOT tipo THEN BEGIN
            lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls09));
            lBigTxtLin.GETSUBTEXT(txtField,1,lPosLin-1); //NIF
            lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
            rec_purchheader.SETRANGE(rec_purchheader."VAT Registration No.",txtField);
            IF NOT rec_purchheader.FINDFIRST THEN BEGIN
              rec_purchmemoheader.SETRANGE("VAT Registration No.",txtField);
              IF rec_purchmemoheader.FINDFIRST THEN BEGIN
                recControlSIIDocumentos.SETRANGE("Fecha de registro",rec_purchmemoheader."Posting Date");
                recControlSIIDocumentos.SETRANGE("No. Doc. proveedor",rec_purchmemoheader."Vendor Cr. Memo No.");
              END;
            END ELSE BEGIN
              recControlSIIDocumentos.SETRANGE("No. Doc. proveedor",rec_purchheader."Vendor Invoice No.");
              recControlSIIDocumentos.SETRANGE("Fecha de registro",rec_purchheader."Posting Date");
            END;
          END;

          lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls09));
          lBigTxtLin.GETSUBTEXT(txtField,1,lPosLin-1); //RespuestaAEAT
          lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
          lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls10)); //Fin de linea
          IF lPosLin <> 0 THEN BEGIN
            lBigTxtLin.GETSUBTEXT(txtField2,1,lPosLin-1); //MensajeRespuesta
            lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
            vFin := FALSE;
          END ELSE BEGIN
            lBigTxtLin.GETSUBTEXT(txtField2,1);
            vFin := TRUE;
          END;

          IF recControlSIIDocumentos.FINDFIRST THEN BEGIN
            CASE txtField OF
              'RECHAZADA':
                recControlSIIDocumentos.VALIDATE("Respuesta AEAT",recControlSIIDocumentos."Respuesta AEAT"::Rechazada);
              'ACEPTADA CON ERRORES':
                BEGIN
                  recControlSIIDocumentos.VALIDATE("Respuesta AEAT",recControlSIIDocumentos."Respuesta AEAT"::"Acepatada con Errores");
                  recControlSIIDocumentos."Estado documento":=recControlSIIDocumentos."Estado documento"::"Validado AEAT";//EX-SIIv4
                END;
              'ACEPTADA':
                BEGIN
                  recControlSIIDocumentos.VALIDATE("Respuesta AEAT",recControlSIIDocumentos."Respuesta AEAT"::Aceptada);
                  recControlSIIDocumentos."Estado documento":=recControlSIIDocumentos."Estado documento"::"Validado AEAT";//EX-SIIv4
                END;
            END;
            recControlSIIDocumentos."Mensaje Respuesta" := txtField2;
            recControlSIIDocumentos.MODIFY;
          END;
        UNTIL vFin;
        respuestaAEAT.CLOSE;
        SLEEP(400);
        FILE.COPY(vPath, vPathhistorico);
        ERASE(vPath);
      */

    end;

    local procedure DescargarFTP()
    var
        v_fichero: File;
        CmdFile: File;
        FTPHostname: Text[30];
        wshshell: Automation;
        WinStyle: Integer;
        WaitOnReturn: Boolean;
        rutaFTPS: Text[100];
    begin
        /*
        //EX-SIIv4
        lc10:=10;
        lc09:=9;
        ls10:=FORMAT(lc10);
        ls09:=FORMAT(lc09);
        
        CLEAR(respuestaAEAT);
        CLEAR(lBigTxtLin);
        CLEAR(lInStr);
        respuestaAEAT.TEXTMODE(FALSE);
        respuestaAEAT.OPEN(vPath);
        respuestaAEAT.CREATEINSTREAM(lInStr);
        lBigTxtLin.READ(lInStr);
        lPosLin:=1;
        lFinLin:=lBigTxtLin.TEXTPOS(FORMAT(ls10));
        lBigTxtLin.GETSUBTEXT(lBigTxtLin,lFinLin+1); //quitar la cabecera y salto de linea
        REPEAT
          rec_purchheader.RESET;
          rec_purchmemoheader.RESET;
          lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls09));
          lBigTxtLin.GETSUBTEXT(txtField,1,lPosLin-1); //NumSerieFactura
          lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
          IF tipo THEN
            recControlSIIDocumentos.SETRANGE("No. documento",txtField)
          ELSE BEGIN
            //recControlSIIDocumentos.SETRANGE("No. documento",txtField)
            recControlSIIDocumentos.SETRANGE("No. Doc. proveedor",txtField);
            rec_purchheader.SETRANGE("Vendor Invoice No.",txtField);
            rec_purchmemoheader.SETRANGE("Vendor Cr. Memo No.",txtField);
          END;
          lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls09));
          lBigTxtLin.GETSUBTEXT(txtField,1,lPosLin-1); //FechaExpedicionFactura
          lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
          EVALUATE(vFechaReg,txtField);
          IF tipo THEN
            recControlSIIDocumentos.SETRANGE("Fecha de registro",vFechaReg)
          ELSE BEGIN
            rec_purchheader.SETRANGE(rec_purchheader."Document Date",vFechaReg);
            IF NOT rec_purchheader.FINDFIRST THEN BEGIN
              rec_purchmemoheader.SETRANGE("Document Date",vFechaReg);
              IF rec_purchmemoheader.FINDFIRST THEN
                recControlSIIDocumentos.SETRANGE("Fecha de registro",rec_purchmemoheader."Posting Date");
            END ELSE
              recControlSIIDocumentos.SETRANGE("Fecha de registro",rec_purchheader."Posting Date");
          END;
        
          IF NOT tipo THEN BEGIN
            lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls09));
            lBigTxtLin.GETSUBTEXT(txtField,1,lPosLin-1); //NIF
            lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
            rec_purchheader.SETRANGE(rec_purchheader."VAT Registration No.",txtField);
            IF NOT rec_purchheader.FINDFIRST THEN BEGIN
              rec_purchmemoheader.SETRANGE("VAT Registration No.",txtField);
              IF rec_purchmemoheader.FINDFIRST THEN BEGIN
                recControlSIIDocumentos.SETRANGE("Fecha de registro",rec_purchmemoheader."Posting Date");
                recControlSIIDocumentos.SETRANGE("No. Doc. proveedor",rec_purchmemoheader."Vendor Cr. Memo No.");
              END;
            END ELSE BEGIN
              recControlSIIDocumentos.SETRANGE("No. Doc. proveedor",rec_purchheader."Vendor Invoice No.");
              recControlSIIDocumentos.SETRANGE("Fecha de registro",rec_purchheader."Posting Date");
            END;
          END;
        
          lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls09));
          lBigTxtLin.GETSUBTEXT(txtField,1,lPosLin-1); //RespuestaAEAT
          lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
          lPosLin := lBigTxtLin.TEXTPOS(FORMAT(ls10)); //Fin de linea
          IF lPosLin <> 0 THEN BEGIN
            lBigTxtLin.GETSUBTEXT(txtField2,1,lPosLin-1); //MensajeRespuesta
            lBigTxtLin.GETSUBTEXT(lBigTxtLin,lPosLin+1);
            vFin := FALSE;
          END ELSE BEGIN
            lBigTxtLin.GETSUBTEXT(txtField2,1);
            vFin := TRUE;
          END;
        
          IF recControlSIIDocumentos.FINDFIRST THEN BEGIN
            CASE txtField OF
              'RECHAZADA':
                recControlSIIDocumentos.VALIDATE("Respuesta AEAT",recControlSIIDocumentos."Respuesta AEAT"::Rechazada);
              'ACEPTADA CON ERRORES':
                BEGIN
                  recControlSIIDocumentos.VALIDATE("Respuesta AEAT",recControlSIIDocumentos."Respuesta AEAT"::"Acepatada con Errores");
                  recControlSIIDocumentos."Estado documento":=recControlSIIDocumentos."Estado documento"::"Validado AEAT";//EX-SIIv4
                END;
              'ACEPTADA':
                BEGIN
                  recControlSIIDocumentos.VALIDATE("Respuesta AEAT",recControlSIIDocumentos."Respuesta AEAT"::Aceptada);
                  recControlSIIDocumentos."Estado documento":=recControlSIIDocumentos."Estado documento"::"Validado AEAT";//EX-SIIv4
                END;
            END;
            recControlSIIDocumentos."Mensaje Respuesta" := txtField2;
            recControlSIIDocumentos.MODIFY;
          END;
        UNTIL vFin;
        respuestaAEAT.CLOSE;
        SLEEP(400);
        FILE.COPY(vPath, vPathhistorico);
        ERASE(vPath);
        */

        /*
        //EX-SIIv4
        Pt_InfoEmpresa.GET;
        CLEAR(v_fichero);
        v_fichero.TEXTMODE(TRUE);
        v_fichero.CREATE(Pt_InfoEmpresa."Ruta ficheros SII" +'\Info.txt');
        v_fichero.WRITE(Pt_InfoEmpresa."Usuario FTP");
        v_fichero.WRITE(Pt_InfoEmpresa."Contrase¤a FTP");
        v_fichero.WRITE('PROMPT');
        v_fichero.WRITE('PASSIVE');
        IF Pt_InfoEmpresa."Ruta subida ficheros FTP SII" <> '' THEN
          v_fichero.WRITE('CD "' + Pt_InfoEmpresa."Ruta subida ficheros FTP SII" + '"');
        
        v_fichero.WRITE('LCD '+Pt_InfoEmpresa."Ruta ficheros SII");
        v_fichero.WRITE('MGET *RESP*.txt');
        v_fichero.WRITE('DEL *RESP*.txt');
        v_fichero.WRITE('CLOSE');
        v_fichero.WRITE('QUIT');
        v_fichero.CLOSE;
        
        FTPHostname := Pt_InfoEmpresa."Servidor FTP SII";
        CmdFile.CREATE(Pt_InfoEmpresa."Ruta ficheros SII" + '\download.cmd');
        CmdFile.TEXTMODE(TRUE);
        IF GUIALLOWED THEN
          v_fichero.WRITE('FTPS -z -d -t:5 -e:implicit '+Pt_InfoEmpresa."Servidor FTP SII"+' -s:"'+
            Pt_InfoEmpresa."Ruta ficheros SII"+'\Info.txt"')
        ELSE BEGIN //Env¡o por NAS
          rutaFTPS:='"' + FORMAT(Pt_InfoEmpresa."Fecha Limite presentacion AEAT");
          v_fichero.WRITE(rutaFTPS + 'ftps.exe" -z -d -t:5 -e:implicit '+Pt_InfoEmpresa."Servidor FTP SII"+' -s:"'+
            Pt_InfoEmpresa."Ruta ficheros SII"+'\Info.txt"');
        END;
        
        CmdFile.CLOSE;
        
        IF ISCLEAR(wshshell) THEN
          CREATE(wshshell);
        WinStyle := 0;
        WaitOnReturn := TRUE;
        wshshell.Run(Pt_InfoEmpresa."Ruta ficheros SII" + '\download.cmd',WinStyle,WaitOnReturn);
        CLEAR(wshshell);
        */


        /*
        //EX-SIIv4
        Pt_InfoEmpresa.GET;
        CLEAR(v_fichero);
        v_fichero.TEXTMODE(TRUE);
        v_fichero.CREATE(Pt_InfoEmpresa."Ruta ficheros SII" +'\Info.txt');
        v_fichero.WRITE(Pt_InfoEmpresa."Usuario FTP");
        v_fichero.WRITE(Pt_InfoEmpresa."Contrase¤a FTP");
        v_fichero.WRITE('PROMPT');
        v_fichero.WRITE('PASSIVE');
        IF Pt_InfoEmpresa."Ruta subida ficheros FTP SII" <> '' THEN
          v_fichero.WRITE('CD "' + Pt_InfoEmpresa."Ruta subida ficheros FTP SII" + '"');
        
        v_fichero.WRITE('LCD '+Pt_InfoEmpresa."Ruta ficheros SII");
        v_fichero.WRITE('MGET *RESP*.txt');
        v_fichero.WRITE('MDEL *RESP*.txt');
        v_fichero.WRITE('CLOSE');
        v_fichero.WRITE('QUIT');
        v_fichero.CLOSE;
        
        ///////////////////ROLES
        
        process:=process.Process;
        process.StartInfo.UseShellExecute:=FALSE;
        process.StartInfo.FileName := 'ftps.exe';
        process.StartInfo.Arguments := '-z -d -t:5 -e:implicit '+Pt_InfoEmpresa."Servidor FTP SII"+' -s:"'+Pt_InfoEmpresa."Ruta ficheros SII
        process.StartInfo.CreateNoWindow := TRUE;
        process.Start();
        process.WaitForExit;
        CLEAR(process);
        
        IF FILE.EXISTS(Pt_InfoEmpresa."Ruta ficheros SII" +'\Info.txt') THEN
          FILE.ERASE(Pt_InfoEmpresa."Ruta ficheros SII" +'\Info.txt');
        SLEEP(500);
        */
        /*
        ///////////////////Clasico
        FTPHostname := Pt_InfoEmpresa."Servidor FTP SII";
        CmdFile.CREATE(Pt_InfoEmpresa."Ruta ficheros SII" + '\download.cmd');
        CmdFile.TEXTMODE(TRUE);
        IF GUIALLOWED THEN
          v_fichero.WRITE('FTPS -z -d -t:5 -e:implicit '+Pt_InfoEmpresa."Servidor FTP SII"+' -s:"'+
            Pt_InfoEmpresa."Ruta ficheros SII"+'\Info.txt"')
        ELSE BEGIN //Env¡o por NAS
          rutaFTPS:='"' + FORMAT(Pt_InfoEmpresa."Fecha Limite presentacion AEAT");
          v_fichero.WRITE(rutaFTPS + 'ftps.exe" -z -d -t:5 -e:implicit '+Pt_InfoEmpresa."Servidor FTP SII"+' -s:"'+
            Pt_InfoEmpresa."Ruta ficheros SII"+'\Info.txt"');
        END;
        
        CmdFile.CLOSE;
        
        IF ISCLEAR(wshshell) THEN
          CREATE(wshshell);
        WinStyle := 0;
        WaitOnReturn := TRUE;
        wshshell.Run(Pt_InfoEmpresa."Ruta ficheros SII" + '\download.cmd',WinStyle,WaitOnReturn);
        CLEAR(wshshell);
        */

    end;
}

