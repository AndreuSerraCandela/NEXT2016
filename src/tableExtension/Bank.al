/// <summary>
/// TableExtension Bank (ID 92270) extends Record Bank Account.
/// </summary>
tableextension 92270 Bank extends "Bank Account"
{
    fields
    {
        //{ 50000;  ;Imprimir en Facturas;Boolean       ;OnValidate=BEGIN
        //                                                             pT_Banco.RESET;
        //                                                             pT_Banco.SETRANGE("Imprimir en Facturas",TRUE);
        //                                                             pT_Banco.SETFILTER("No.",'<>%1',Rec."No.");
        //                                                             IF pT_Banco.FINDFIRST THEN BEGIN
        //                                                                ERROR('Ya existe otro banco con "Imprimir en Facturas" marcado: '+FORMAT(pT_Banco."No."));
        //                                                             END;
        //                                                           END;

        //                                                Description=SF-MLA Campo para imprimir banco en factura de venta Netex. }
        field(50000; "Imprimir en Facturas"; Boolean)
        {
            trigger OnValidate()
            var
                pT_Banco: Record "Bank Account";
            begin
                pT_Banco.reset();
                pT_Banco.setRange("Imprimir en Facturas", true);
                pT_Banco.setFilter("No.", '<>%1', Rec."No.");
                if (pT_Banco.findFirst())
                then
                    error('Ya existe otro banco con \"Imprimir en Facturas\" marcado: ' + format(pT_Banco."No."));

            end;
        }
        // { 50021;  ;C¢digo banco SAT    ;Text3         ;CaptionML=ESM=C¢digo banco SAT;
        //                                                Description=EX-SGG 291014 Contabilidad medios electr¢nicos }
        field(50021; "Código banco SAT"; Text[3])
        {
            Caption = 'Código banco SAT';
            Description = 'EX-SGG 291014 Contabilidad medios electrónicos';

        }
    }
}