/// <summary>
/// TableExtension GenJnlLine (ID 92081) extends Record Gen. Journal Line.
/// </summary>
tableextension 92081 GenJnlLine extends "Gen. Journal Line"
{
    fields
    {
        //    { 50601;  ;SII Fecha env¡o a control;Date     ;Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
        field(50601; "SII Fecha Envío a Control"; Date)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
        }
        // { 50602;  ;SII Excluir env¡o   ;Boolean       ;OnValidate=VAR
        //                                                             recGenJnLine@1100220000 : Record 81;
        //                                                           BEGIN

        //                                                             //250717 EX-JVN SII
        //                                                             recGenJnLine.SETCURRENTKEY("Posting Date","Document No.");
        //                                                             recGenJnLine.SETRANGE("Posting Date","Posting Date");
        //                                                             recGenJnLine.SETRANGE("Document No.","Document No.");
        //                                                             recGenJnLine.SETFILTER("Line No.",'<>%1',"Line No.");
        //                                                             IF recGenJnLine.FINDSET THEN
        //                                                               recGenJnLine.MODIFYALL("SII Excluir env¡o","SII Excluir env¡o");
        //                                                             //250717
        //                                                           END;

        //                                                Description=AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII }
        field(50602; "SII Excluir Envio"; Boolean)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            trigger OnValidate()

            var
                recGenJnLine: Record 81;
            begin
                // 250717 EX-JVN SII
                recGenJnLine.SETCURRENTKEY("Posting Date", "Document No.");
                recGenJnLine.SETRANGE("Posting Date", "Posting Date");
                recGenJnLine.SETRANGE("Document No.", "Document No.");
                recGenJnLine.SETFILTER("Line No.", '<>%1', "Line No.");
                if recGenJnLine.FINDSET then begin
                    recGenJnLine.MODIFYALL("SII Excluir Envio", "SII Excluir Envio");
                end;
                // 250717
            end;

        }
        // { 50603;  ;SII Datos Documento ;Boolean       ;Description=EX-JVN }
        field(50603; "SII Datos Documento"; Boolean)
        {
            Description = 'EX-JVN';
        }
    }
}