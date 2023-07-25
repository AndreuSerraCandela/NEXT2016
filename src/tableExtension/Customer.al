/// <summary>
/// TableExtension Custom (ID 92018) extends Record Customer.
/// </summary>
tableextension 92018 Custom extends Customer
{
    fields
    {
        // { 50600;  ;Clave Id. fiscal contraparte;Code2 ;Description=SII: Muestra dato SII de Contraparte }
        field(50600; "Clave Id. fiscal contraparte"; Code[2])
        {
           Description = 'SII: Muestra dato SII de Contraparte';
        }
        // { 50601;  ;NIF Entidad Sucedida;Code10        ;Description=SIIv3: 070618 }
        field(50601; "NIF Entidad Sucedida"; Code[10])
        {
           Description = 'SIIv3: 070618';
        }
        //{ 50602;  ;Razon Social Entidad Sucedida;Code10;
        //                                           Description=SIIv3: 070618 }
        field(50602; "Razon Social Entidad Sucedida"; Code[10])
        {
           Description = 'SIIv3: 070618';
        }
        //{ 50800;  ;Cliente FacturaE    ;Boolean       ;CaptionML=ESM=Cliente FacturaE;
        //                                           Description=EX-SGG-FACTE }
        field(50800; "Cliente FacturaE"; Boolean)
        {
           Caption= 'Cliente FacturaE';
           Description = 'EX-SGG-FACTE';
        }
        //{ 50801;  ;E-Mail para FacturaE;Text80        ;CaptionML=ESM=E-Mail para FacturaE;
        //                                           Description=EX-SGG-FACTE }
        field(50801; "E-Mail para FacturaE"; Text[80])
        {
           Caption= 'E-Mail para FacturaE';
           Description = 'EX-SGG-FACTE';
        }
        // { 50802;  ;Calle               ;Text50        ;OnValidate=BEGIN
        //                                                         //Enable by
        //                                                         //Direccion; //EX-SGG-FACTE;
        //                                                       END;

        //                                            CaptionML=ESM=Calle FacturaE;
        //                                            Description=EX-SGG-FACTE }
        field(50802; "Calle"; Text[50])
        {
           Caption= 'Calle FacturaE';
           Description = 'EX-SGG-FACTE';
        }
        // { 50803;  ;No. Int.            ;Text10        ;OnValidate=BEGIN
        //                                                         //Direccion; //EX-SGG-FACTE;
        //                                                       END;

        //                                            CaptionML=ESM=No. Int. FacturaE;
        //                                            Description=EX-SGG-FACTE }
        field(50803; "No. Int."; Text[10])
        {
           Caption= 'No. Int. FacturaE';
           Description = 'EX-SGG-FACTE';
        }
        //  { 50804;  ;No. Ext.            ;Text10        ;OnValidate=BEGIN
        //                                                         //Direccion; //EX-SGG-FACTE;
        //                                                       END;

        //                                            CaptionML=ESM=No. Ext. FacturaE;
        //                                            NotBlank=Yes;
        //                                            Description=EX-SGG-FACTE }
        field(50804; "No. Ext."; Text[10])
        {
           Caption= 'No. Ext. FacturaE';
           NotBlank=true;
           Description = 'EX-SGG-FACTE';
        }
        // { 50805;  ;CFDI Uso            ;Code20        ;TableRelation="Catalogo CFDI 3.3".Codigo WHERE (Tipo Tabla=CONST(c_UsoCFDI));
        //                                             Description=EX-FACTE }
        field(50805; "CFDI Uso"; Code[20])
        {
           Description = 'EX-FACTE';
           TableRelation="Catalogo CFDI 3.3".Codigo WHERE ("Tipo Tabla"=CONST('c_UsoCFDI'));
        }
        //{ 50806;  ;CFDI Aduana         ;Code20        ;TableRelation="Catalogo CFDI 3.3".Codigo WHERE (Tipo Tabla=CONST(c_Aduana));
        //                                           Description=EX-FACTE }
        field(50806; "CFDI Aduana"; Code[20])
        {
           Description = 'EX-FACTE';
           TableRelation="Catalogo CFDI 3.3".Codigo WHERE ("Tipo Tabla"=CONST('c_Aduana'));
        }
    }
    trigger OnAfterModify()
    VAR
        RecTablasSII : Record 50600;
    Begin       

    // ++ SII (030717)
    IF (Rec."Country/Region Code" <> xRec."Country/Region Code") OR
        (Rec."VAT Registration No." <> xRec."VAT Registration No.") OR
        (Rec."Post Code" <> xRec."Post Code") OR
        (Rec."VAT Bus. Posting Group"<>xRec."VAT Bus. Posting Group") THEN
        //BEGIN
        // MODIFY;
        RecTablasSII.InsertaContraparte(1,Rec."No.");
        //END;
    // -- SII (030717)
    END;
    
}