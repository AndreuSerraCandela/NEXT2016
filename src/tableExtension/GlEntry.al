/// <summary>
/// TableExtension GlEntry (ID 92017) extends Record G/L Entry.
/// </summary>
tableextension 92017 GlEntry extends "G/L Entry"
{
    fields
    {
        // { 50600;  ;SII Estado documento;Option        ;FieldClass=FlowField;
        //                                            CalcFormula=Lookup("SII- Datos SII Documentos"."Estado documento" WHERE (Tipo documento=FIELD(SII Filtro Tipo Doc.),
        //                                                                                                                     No. documento=FIELD(Document No.),
        //                                                                                                                     Origen documento=FIELD(SII Filtro Origen Doc.)));
        //                                            OptionString=[ ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias];
        field(50600; "SII Estado documento"; Enum "SII Estado Documento")
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("SII- Datos SII Documentos"."Estado documento" WHERE("Tipo documento" = FIELD("SII Filtro Tipo Doc."),
             "Origen documento" = FIELD("SII Filtro Origen Doc.")));
            //OptionString=[ ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias];

            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
        }
        //{ 50601;  ;SII Fecha env¡o a control;Date     ;Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
        field(50601; "SII Fecha envío a control"; Date)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
        }
        //{ 50602;  ;SII Excluir env¡o   ;Boolean       ;Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
        field(50602; "SII Excluir envío"; Boolean)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
        }
        //{ 50603;  ;SII Datos Documento ;Boolean       ;Description=EX-JVN }
        field(50603; "SII Datos Documento"; Boolean)
        {
            Description = 'EX-JVN';
        }
        // { 50604;  ;SII Filtro Tipo Doc.;Option        ;FieldClass=FlowFilter;
        //                                                OptionString=Factura,Abono,B.I.;
        //                                                Description=EX-JVN }
        field(50604; "SII Filtro Tipo Doc."; Enum "SII Tipo Documento")
        {
            FieldClass = FlowFilter;
            // OptionString=Factura,Abono,B.I.;
            Description = 'EX-JVN';
        }
        // { 50605;  ;SII Filtro Origen Doc.;Option      ;FieldClass=FlowFilter;
        //                                                OptionString=Emitida,Recibida,B.I.;
        //                                                Description=EX-JVN }
        field(50605; "SII Filtro Origen Doc."; Enum "SII Origen Documento")
        {
            FieldClass = FlowFilter;
            // OptionString=Emitida,Recibida,B.I.;
            Description = 'EX-JVN';
        }

        //{ 50800;  ;UUID FacturaE       ;Text50        ;Description=EX-FACTE 130215 }
        field(50800; "UUID FacturaE"; Text[50])
        {
            Description = 'EX-FACTE 130215';
        }
        //{ 50801;  ;Fecha certificaci¢n FacturaE;Date  ;Description=EX-FACTE 130215 }
        field(50801; "Fecha certificación FacturaE"; Date)
        {
            Description = 'EX-FACTE 130215';
        }
        //{ 50802;  ;Hora certificaci¢n FacturaE;Time   ;Description=EX-FACTE 130215 }
        field(50802; "Hora certificación FacturaE"; Time)
        {
            Description = 'EX-FACTE 130215';
        }
    }
}