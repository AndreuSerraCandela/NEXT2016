/// <summary>
/// Table SII- Datos documento (ID 50603).
/// </summary>
table 50603 "SII- Datos documento"
{
    // EX-SGG 270617 CORRECCIONES EN Dato SII - OnLookup() Y USO DEL NUEVO CAMPO Tipo de documento EN CONFIG MULTIPLE.
    //        180717 NUEVA FUNCON CompruebaEstadoSIIDoc. LLAMADA EN EVENTOS. NO PERMITIR RENOMBRAR EL REGISTRO.


    fields
    {
        field(1; "Tipo documento"; Enum "SII Tipo Documento")
        {
            // OptionMembers = "Factura emitida","Abono emitido","Factura emitida reg.","Abono emitido reg.","Factura recibida","Abono recibido","Factura recibida reg.","Abono recibido reg.",BI,"Srv pedido","Srv Factura","Srv Abono","Srv Factura reg.","Srv Abono reg.";
        }
        field(2; "No. Documento"; Code[20])
        {
        }
        field(3; "Dato SII"; Text[50])
        {
            NotBlank = true;

            trigger OnLookup()
            var
                FormListaCamposSII: Page 50602;
                RecConfDatosDocumentos: Record 50602 temporary;
            begin
                // SII Muestra Datos configurados para documentos No desactivados
                /*
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

                IF "Dato SII" <> '' THEN
                    EXIT;
                RecConfDatosDocumentos.RESET;
                RecConfDatosDocumentos.SETRANGE("Tipo configuración", RecConfDatosDocumentos."Tipo configuración"::"Datos por documento");

                CASE "Tipo documento".AsInteger() OF
                    0, 1, 2, 3, 9, 10, 11, 12, 13:
                        BEGIN
                            RecConfDatosDocumentos.SETRANGE("Informar en documento", RecConfDatosDocumentos."Informar en documento"::Expedido);
                            CASE "Tipo documento".AsInteger() OF
                                0, 2, 4, 6, 9, 10, 12, 13:
                                    RecConfDatosDocumentos.SETRANGE("Tipo de documento", RecConfDatosDocumentos."Tipo de documento"::Facturas);
                                ELSE
                                    RecConfDatosDocumentos.SETRANGE("Tipo de documento", RecConfDatosDocumentos."Tipo de documento"::Abonos);
                            END;
                        END;
                    4, 5, 6, 7:
                        BEGIN
                            RecConfDatosDocumentos.SETRANGE("Informar en documento", RecConfDatosDocumentos."Informar en documento"::Recibido);
                            CASE "Tipo documento".AsInteger() OF
                                4, 6:
                                    RecConfDatosDocumentos.SETRANGE("Tipo de documento", RecConfDatosDocumentos."Tipo de documento"::Facturas);
                                ELSE
                                    RecConfDatosDocumentos.SETRANGE("Tipo de documento", RecConfDatosDocumentos."Tipo de documento"::Abonos);
                            END;
                        END;
                END;

                CLEAR(FormListaCamposSII);
                FormListaCamposSII.LOOKUPMODE(TRUE);
                FormListaCamposSII.EDITABLE(FALSE);
                FormListaCamposSII.SETTABLEVIEW(RecConfDatosDocumentos);
                IF FormListaCamposSII.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    FormListaCamposSII.GETRECORD(RecConfDatosDocumentos);
                    "Dato SII" := RecConfDatosDocumentos."Nombre dato SII";
                    "Valor dato SII" := RecConfDatosDocumentos."Valor inicial";
                    "Filtro valores maestros SII" := RecConfDatosDocumentos."Filtro tabla valores SII";
                    Orden := RecConfDatosDocumentos.Orden;
                    Obligatorio := RecConfDatosDocumentos.Obligatorio;
                    "Dato SII a exportar como" := RecConfDatosDocumentos."Dato SII a exportar como";
                END;

            end;
        }
        field(4; "Valor dato SII"; Code[50])
        {
            TableRelation = IF ("Filtro valores maestros SII" = FILTER(<> '')) "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L1'));

            trigger OnLookup()
            var
                FormTablaMaestraSII: Page 50600;
                RecListaTablasSII: Record 50600;
            begin
                // SII Filtros de tabla valores maestros según configuración del dato.
                IF "Filtro valores maestros SII" <> '' THEN BEGIN
                    RecListaTablasSII.RESET;
                    RecListaTablasSII.SETRANGE(RecListaTablasSII."Id. tabla", "Filtro valores maestros SII");
                    IF RecListaTablasSII.FINDSET THEN BEGIN
                        CLEAR(FormTablaMaestraSII);
                        FormTablaMaestraSII.SETTABLEVIEW(RecListaTablasSII);
                        FormTablaMaestraSII.EDITABLE(FALSE);
                        FormTablaMaestraSII.LOOKUPMODE(TRUE);
                        IF FormTablaMaestraSII.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            FormTablaMaestraSII.GETRECORD(RecListaTablasSII);
                            "Valor dato SII" := RecListaTablasSII.Valor;
                            MODIFY(TRUE);
                            ;
                        END;
                    END;
                END;
            end;

            trigger OnValidate()
            var
                RecListaTablasSII: Record 50600;
            begin
                // SII Validar el dato
            end;
        }
        field(5; "Desc. dato SII"; Text[250])
        {
            CalcFormula = Lookup("SII- Tablas valores SII".Descripción WHERE(Valor = FIELD("Valor dato SII"),
                                                                              "Id. tabla" = FIELD("Filtro valores maestros SII")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Filtro valores maestros SII"; Code[30])
        {
        }
        field(7; Orden; Integer)
        {
        }
        field(8; Obligatorio; Boolean)
        {
        }
        field(9; "Dato SII a exportar como"; Text[100])
        {
            Description = 'Mapeo con su correspondiente Nodo para el mensaje XLM';
        }
    }

    keys
    {
        key(Key1; "Tipo documento", "No. Documento", "Dato SII")
        {
            Clustered = true;
        }
        key(Key2; Orden)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        GLEntry: Record "G/L Entry";
        DatosDocSII: Record "SII- Datos documento";
    begin
        CompruebaEstadoSIIDoc; //EX-SGG 180717

        //210717 EX-JVN SII
        DatosDocSII.RESET;
        DatosDocSII.SETRANGE("Tipo documento", "Tipo documento");
        DatosDocSII.SETRANGE("No. Documento", "No. Documento");
        IF NOT DatosDocSII.FINDFIRST THEN BEGIN
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", "No. Documento");
            CASE "Tipo documento" OF
                2, 6:
                    GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Invoice);
                3, 7:
                    GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::"Credit Memo");
            END;
            IF GLEntry.FINDSET THEN
                GLEntry.MODIFYALL("SII Datos Documento", FALSE);
        END;
        //210717 fin
    end;

    trigger OnInsert()
    begin
        CompruebaEstadoSIIDoc; //EX-SGG 180717
    end;

    trigger OnModify()
    begin
        CompruebaEstadoSIIDoc; //EX-SGG 180717
    end;

    trigger OnRename()
    begin
        ERROR('No es posible renombrar este registro'); //EX-SGG 180717
    end;

    local procedure CompruebaEstadoSIIDoc()
    var
        lRstFacV: Record "112";
        lRstFacC: Record "122";
        lRstAboV: Record "114";
        lRstAboC: Record "124";
        lRstValSII: Recor "SII- Tablas valores SII";
        GLEntry: Recor  "G/L Entry";
    begin
        //200717 EX-JVN SII
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("Document No.");
        GLEntry.SETRANGE("Document No.", "No. Documento");
        //200717 fin

        CASE "Tipo documento" OF
            2:
                BEGIN
                    IF lRstFacV.GET("No. Documento") THEN BEGIN
                        lRstFacV.CALCFIELDS("SII Estado documento");
                        lRstValSII.PermitirModificarDoc(lRstFacV."SII Estado documento", TRUE);
                        //200717 EX-JVN SII
                    END ELSE BEGIN
                        GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Invoice);
                        GLEntry.SETRANGE("SII Filtro Tipo Doc.", GLEntry."SII Filtro Tipo Doc."::Factura);
                        GLEntry.SETRANGE("SII Filtro Origen Doc.", GLEntry."SII Filtro Origen Doc."::Emitida);
                        IF GLEntry.FINDFIRST THEN BEGIN
                            GLEntry.CALCFIELDS("SII Estado documento");
                            lRstValSII.PermitirModificarDoc(GLEntry."SII Estado documento", TRUE);
                        END;
                    END;
                    //200717 fin
                END;
            3:
                BEGIN
                    IF lRstAboV.GET("No. Documento") THEN BEGIN //200717 EX-JVN SII
                        lRstAboV.CALCFIELDS("SII Estado documento");
                        lRstValSII.PermitirModificarDoc(lRstAboV."SII Estado documento", TRUE);
                        //200717 EX-JVN SII
                    END ELSE BEGIN
                        GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::"Credit Memo");
                        GLEntry.SETRANGE("SII Filtro Tipo Doc.", GLEntry."SII Filtro Tipo Doc."::Abono);
                        GLEntry.SETRANGE("SII Filtro Origen Doc.", GLEntry."SII Filtro Origen Doc."::Emitida);
                        IF GLEntry.FINDFIRST THEN BEGIN
                            GLEntry.CALCFIELDS("SII Estado documento");
                            lRstValSII.PermitirModificarDoc(GLEntry."SII Estado documento", TRUE);
                        END;
                    END;
                    //200717 fin
                END;
            6:
                BEGIN
                    IF lRstFacC.GET("No. Documento") THEN BEGIN //200717 EX-JVN SII
                        lRstFacC.CALCFIELDS("SII Estado documento");
                        lRstValSII.PermitirModificarDoc(lRstFacC."SII Estado documento", TRUE);
                        //200717 EX-JVN SII
                    END ELSE BEGIN
                        GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Invoice);
                        GLEntry.SETRANGE("SII Filtro Tipo Doc.", GLEntry."SII Filtro Tipo Doc."::Factura);
                        GLEntry.SETRANGE("SII Filtro Origen Doc.", GLEntry."SII Filtro Origen Doc."::Recibida);
                        IF GLEntry.FINDFIRST THEN BEGIN
                            GLEntry.CALCFIELDS("SII Estado documento");
                            lRstValSII.PermitirModificarDoc(GLEntry."SII Estado documento", TRUE);
                        END;
                    END;
                    //200717 fin
                END;
            7:
                BEGIN
                    IF lRstAboC.GET("No. Documento") THEN BEGIN //200717 EX-JVN SII
                        lRstAboC.CALCFIELDS("SII Estado documento");
                        lRstValSII.PermitirModificarDoc(lRstAboC."SII Estado documento", TRUE);
                        //200717 EX-JVN SII
                    END ELSE BEGIN
                        GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::"Credit Memo");
                        GLEntry.SETRANGE("SII Filtro Tipo Doc.", GLEntry."SII Filtro Tipo Doc."::Abono);
                        GLEntry.SETRANGE("SII Filtro Origen Doc.", GLEntry."SII Filtro Origen Doc."::Recibida);
                        IF GLEntry.FINDFIRST THEN BEGIN
                            GLEntry.CALCFIELDS("SII Estado documento");
                            lRstValSII.PermitirModificarDoc(GLEntry."SII Estado documento", TRUE);
                        END;
                    END;
                    //200717 fin
                END;
        END;
    end;
}

