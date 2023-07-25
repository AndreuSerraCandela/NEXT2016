/// <summary>
/// PageExtension PurchHeaqder (ID 92038) extends Record purchase header.
/// </summary>
tableextension 92038 PurchHeaqder extends "Purchase Header"
{
    //                                                 Editable=No }
    // { 50000;  ;Totalmente facturado;Boolean        }
    // { 50001;  ;Error en l¡neas     ;Boolean       ;FieldClass=FlowField;
    //                                                CalcFormula=Exist(LinCompra_AUXi_JSon WHERE (C¢d. Cab=FIELD(No.),
    //                                                                                             ERROR=CONST(Yes)));
    //                                                Description=EX-JVN;
    //                                                Editable=No }
    // { 50600;  ;SII Estado documento;Option        ;FieldClass=FlowField;
    //                                                CalcFormula=Lookup("SII- Datos SII Documentos"."Estado documento" WHERE (Tipo documento=FILTER(Factura),
    //                                                                                                                         No. documento=FIELD(No.),
    //                                                                                                                         Origen documento=FILTER(Recibida)));
    //                                                OptionString=[ ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT];
    //                                                Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
    // { 50601;  ;SII Fecha env¡o a control;Date     ;Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
    // { 50602;  ;SII Excluir env¡o   ;Boolean       ;Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
    // { 50800;  ;Fiscal Invoice Number PAC;Text50   ;CaptionML=[ENU=Fiscal Invoice Number PAC;
    //                                                           ESM=N£mero de factura fiscal PAC;
    //                                                           FRC=Num‚ro de facture fiscale PAC;
    //                                                           ENC=Fiscal Invoice Number PAC];
    fields
    {
        field(50000; "Totalmente Facturado"; Boolean)
        {
        }
        field(50001; "Error en líneas"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = EXIST(LinCompra_AUXi_JSon WHERE("Cód. Cab" = FIELD("No."),
                                                           ERROR = CONST(true)));
            Description = 'EX-JVN';
            Editable = false;
        }
        field(50600; "SII Estado documento"; Enum "Sii Estado Documento")
        {
            FieldClass = FlowField;
            CalcFormula = LOOKUP("SII- Datos SII Documentos"."Estado documento" WHERE("Tipo documento" = FILTER("Factura"),
                                                                                       "No. documento" = FIELD("No."),
                                                                                       "Origen documento" = FILTER("Recibida")));
            // OptionString = '[ ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT]';
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
        }
        field(50601; "SII Fecha envío a control"; Date)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
        }
        field(50602; "SII Excluir envío"; Boolean)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
        }
        field(50800; "Fiscal Invoice Number PAC"; Text[50])
        {
            Caption = 'Número de factura fiscal PAC';

        }
        field(50205; "Purchaser Code New"; Code[40])
        {
            Caption = 'Código de comprador';
            TableRelation = "Salesperson/Purchaser";
        }
    }
}