/// <summary>
/// TableExtension VendorExt (ID 92023) extends Record Vendor.
/// </summary>
tableextension 92023 VendorExt extends Vendor
{
    fields
    {
        //{ 50000;  ;Id JSon             ;Text50        ;Description=EX-JVN Integraci¢n JSon }
        field(50000; "Id JSon"; Text[50]) { Description = 'EX-JVN Integraci¢n JSon'; }
        //{ 50001;  ;No. AUX             ;Code20        ;Description=EX-JVN }
        field(50001; "No. AUX"; Code[20]) { Description = 'EX-JVN'; }
        // { 50091;  ;Vendor Type         ;Option        ;CaptionML=[ENU=Vendor Type;
        //                                                         ESP=Tipo Proveedor];
        //                                             OptionCaptionML=[ENU=" ,National,Foreign,Global";
        //                                                                 ESP=" ,Nacional,Extranjero,Global";
        //                                                                 ESM=" ,Nacional,Extranjero,Global"];
        //                                             OptionString=[ ,Nacional,Extranjero,Global];
        //                                             Description=EXC.REG }
        field(50091; "Vendor Type"; Enum "Vendor Type")
        {
            Caption = 'Tipo Proveedor';
            //OptionCaptionML = 'ENU=" ,National,Foreign,Global";ESP=" ,Nacional,Extranjero,Global";ESM=" ,Nacional,Extranjero,Global"';
            //OptionString = ' ,Nacional,Extranjero,Global';
            Description = 'EXC.REG';
        }
        // { 50092;  ;Operation Type      ;Option        ;CaptionML=[ENU=Operation Type;
        //                                                         ESP=Tipo de Operaci¢n];
        //                                             OptionCaptionML=[ENU=" ,Prestador de Servicios Profesionales,Arrendamientio de Inmuebles,Otros";
        //                                                                 ESP=" ,Prestador de Servicios Profesionales,Arrendamientio de Inmuebles,Otros"];
        //                                             OptionString=[ ,PrestadorServicios,Arrendamientio,Otros];
        //                                             Description=EXC.REG }
        field(50092; "Operation Type"; Enum "Operation Type")
        {
            Caption = 'Tipo de Operaci¢n';
            //OptionCaptionML = 'ENU=" ,Prestador de Servicios Profesionales,Arrendamientio de Inmuebles,Otros";ESP=" ,Prestador de Servicios Profesionales,Arrendamientio de Inmuebles,Otros"';
            //OptionString = ' ,PrestadorServicios,Arrendamientio,Otros';
            Description = 'EXC.REG';
        }
        //{ 50600;  ;Clave Id. fiscal contraparte;Code2 ;Description=SII: Muestra dato SII de Contraparte }
        field(50600; "Clave Id. fiscal contraparte"; Code[2]) { Description = 'SII: Muestra dato SII de Contraparte'; }
        //{ 50601;  ;NIF Entidad Sucedida;Code10        ;Description=SIIv3: 070618 }
        field(50601; "NIF Entidad Sucedida"; Code[10]) { Description = 'SIIv3: 070618'; }
        //{ 50602;  ;Razon Social Entidad Sucedida;Code10;
        //                                            Description=SIIv3: 070618 }
        field(50602; "Razon Social Entidad Sucedida"; Code[10]) { Description = 'SIIv3: 070618'; }
        // { 29  ;   ;Purchaser Code      ;Code40        ;TableRelation=Salesperson/Purchaser;
        //                                            CaptionML=[ENU=Purchaser Code;
        //                                                       ESP=C¢d. comprador];
        //                                            Description=EX-JVN ampliado de 10 a 40 }
        field(50029; "Purchaser Code New"; Code[40])
        {
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Cód. comprador';
            Description = 'EX-JVN ampliado de 10 a 40';
            trigger OnValidate()
            var
                SalespersonPurchaser: Record "Salesperson/Purchaser";
            begin
                SalespersonPurchaser.SetRange("Code New", "Purchaser Code New");
                if SalespersonPurchaser.Find('-') then
                    "Purchaser Code" := SalespersonPurchaser."Code";

            end;
        }
    }
    trigger OnModify()
    VAR
        RecTablasSII: Record 50600;
    BEGIN

        // ++ SII (030717)
        IF ("Country/Region Code" <> xRec."Country/Region Code") OR
           ("VAT Registration No." <> xRec."VAT Registration No.") OR
           ("Post Code" <> xRec."Post Code") OR
           ("VAT Bus. Posting Group" <> xRec."VAT Bus. Posting Group") THEN
            //BEGIN
            // MODIFY;
            RecTablasSII.InsertaContraparte(2, "No.");
        //END;
        // -- SII (030717)
    END;

}