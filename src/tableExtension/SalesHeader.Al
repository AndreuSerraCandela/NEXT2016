/// <summary>
/// TableExtension SalesHeader (ID 92036) extends Record Sales Header.
/// </summary>
tableextension 92036 SalesHeader extends "Sales Header"
{
    fields
    {

        // { 50001;  ;Error en l¡neas     ;Boolean       ;FieldClass=FlowField;
        //                                                CalcFormula=Exist(OfertaLinVenta_AUXi WHERE (Cod. Cab.=FIELD(No.),
        //                                                                                             ERROR=CONST(Yes)));
        //                                                Editable=No }
        // { 50600;  ;SII Estado documento;Option        ;FieldClass=FlowField;
        //                                                CalcFormula=Lookup("SII- Datos SII Documentos"."Estado documento" WHERE (Tipo documento=FILTER(Factura),
        //                                                                                                                         No. documento=FIELD(No.),
        //                                                                                                                         Origen documento=FILTER(Emitida)));
        //                                                OptionString=[ ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT];
        //                                                Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
        // { 50601;  ;SII Fecha env¡o a control;Date     ;Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
        // { 50602;  ;SII Excluir env¡o   ;Boolean       ;Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
        // { 50801;  ;Cliente FacturaE    ;Boolean       ;Description=EX-SGG-FACTE }
        // { 50802;  ;Factura-a Calle     ;Text50        ;OnValidate=BEGIN
        //                                                             Direccion; //EX-SGG-FACTE;
        //                                                           END;

        //                                                Description=EX-SGG-FACTE }
        // { 50803;  ;Factura-a No. Int.  ;Text10        ;OnValidate=BEGIN
        //                                                             Direccion; //EX-SGG-FACTE;
        //                                                           END;

        //                                                Description=EX-SGG-FACTE }
        // { 50804;  ;Factura-a No. Ext.  ;Text10        ;OnValidate=BEGIN
        //                                                             Direccion; //EX-SGG-FACTE;
        //                                                           END;

        //                                                Description=EX-SGG-FACTE }
        // { 50805;  ;Cuenta pago         ;Code10        ;TableRelation="Customer Bank Account".Code WHERE (Customer No.=FIELD(Bill-to Customer No.));
        //                                                Description=EX-SGG-FACTE }
        // { 50806;  ;Hora FacturaE generada;Time        ;Description=EX-SGG-FACTE }
        // { 50807;  ;Usuario FacturaE generada;Code50   ;Description=EX-SGG-FACTE,EX-SGG 060215 20->50 }
        // { 50808;  ;CFDI Tipo Relacion  ;Code10        ;TableRelation="Catalogo CFDI 3.3".Codigo WHERE (Tipo Tabla=CONST(c_TipoRelacion));
        //                                                Description=EX-FACTE }
        // { 50809;  ;CFDI Uso            ;Code20        ;TableRelation="Catalogo CFDI 3.3".Codigo WHERE (Tipo Tabla=CONST(c_UsoCFDI));
        //                                                Description=EX-FACTE }
        // }
        field(50001; "Error en líneas"; Boolean)
        {
            FieldClass = FlowField;
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            CalcFormula = Exist("OfertaLinVenta_AUXi" WHERE("Cod. Cab." = FIELD("No."), "ERROR" = CONST(true)));
            Editable = false;
        }
        field(50600; "SII Estado documento"; Enum "Sii Estado Documento")
        {
            FieldClass = FlowField;
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            CalcFormula = Lookup("SII- Datos SII Documentos"."Estado documento" WHERE("Tipo documento" = FILTER(Factura),
                                                                 "No. documento" = FIELD("No."),
                                                                 "Origen documento" = FILTER(Emitida)));
        }
        field(50601; "SII Fecha envío a control"; Date) { Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII'; }
        field(50602; "SII Excluir envío"; Boolean) { Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII'; }
        field(50801; "Cliente FacturaE"; Boolean) { Description = 'EX-SGG-FACTE'; }
        field(50802; "Factura-a Calle"; Text[50])
        {
            Description = 'EX-SGG-FACTE';
            trigger OnValidate()
            begin
                Direccion(); //EX-SGG-FACTE;
            end;
        }
        field(50803; "Factura-a No. Int."; Text[10])
        {
            Description = 'EX-SGG-FACTE';
            trigger OnValidate()
            begin
                Direccion(); //EX-SGG-FACTE;
            end;
        }
        field(50804; "Factura-a No. Ext."; Text[10])
        {
            Description = 'EX-SGG-FACTE';
            trigger OnValidate()
            begin
                Direccion(); //EX-SGG-FACTE;
            end;

        }
        field(50805; "Cuenta pago"; Code[10]) { Description = 'EX-SGG-FACTE'; }
        field(50806; "Hora FacturaE generada"; Time) { Description = 'EX-SGG-FACTE'; }
        field(50807; "Usuario FacturaE generada"; Code[50]) { Description = 'EX-SGG-FACTE,EX-SGG 060215 20->50'; }
        field(50808; "CFDI Tipo Relacion"; Code[10]) { Description = 'EX-FACTE'; TableRelation = "Catalogo CFDI 3.3".Codigo WHERE("Tipo Tabla" = CONST('c_TipoRelacion')); }
        field(50809; "CFDI Uso"; Code[20]) { Description = 'EX-FACTE'; TableRelation = "Catalogo CFDI 3.3".Codigo WHERE("Tipo Tabla" = CONST('c_UsoCFDI')); }

        FIELD(50025; "SalesPerson Code New"; Code[40]) { TableRelation = "Salesperson/Purchaser"."Code New"; Editable = false; }
    }
    PROCEDURE Direccion();
    BEGIN
        "Bill-to Address" := COPYSTR("Factura-a Calle" + ' ' + "Factura-a No. Ext.", 1, 50);
        IF "Factura-a No. Int." <> '' THEN
            "Bill-to Address" := COPYSTR("Bill-to Address" + ' - ' + "Factura-a No. Int.", 1, 30);

        "Sell-to Address" := "Bill-to Address";
    END;

}