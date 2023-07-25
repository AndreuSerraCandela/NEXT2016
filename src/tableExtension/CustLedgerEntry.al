/// <summary>
/// TableExtension CustEntry (ID 92021) extends Record Cust. Ledger Entry.
/// </summary>
tableextension 92021 CustEntry extends "Cust. Ledger Entry"
{
    fields
    {
        // { 25  ;   ;Salesperson Code    ;Code40        ;TableRelation=Salesperson/Purchaser;
        //                                            CaptionML=[ENU=Salesperson Code;
        //                                                       ESP=C¢d. vendedor];
        //                                            Description=EX-JVN aumentado de 10 a 40 }
        field(50025; "Salesperson Code New"; Code[40])
        {
            TableRelation = "Salesperson/Purchaser"."Code New";
            Caption = 'Código Vendedor Largo';
            Description = 'EX-JVN aumentado de 10 a 40';
            trigger OnValidate()
            var
                Salesperson: Record "Salesperson/Purchaser";
            begin
                if ("Salesperson Code New" <> '') then begin
                    Salesperson.SetRange("Code New", "Salesperson Code New");
                    if Salesperson.FindFirst() then begin
                        "Salesperson Code" := Salesperson."Code";
                    end;
                end;
            end;
        }
    }
}
/// <summary>
/// TableExtension CustEntry (ID 92021) extends Record Cust. Ledger Entry.
/// </summary>
tableextension 92025 VendorEntry extends "Vendor Ledger Entry"
{
    fields
    {
        // { 25  ;   ;Salesperson Code    ;Code40        ;TableRelation=Salesperson/Purchaser;
        //                                            CaptionML=[ENU=Salesperson Code;
        //                                                       ESP=C¢d. vendedor];
        //                                            Description=EX-JVN aumentado de 10 a 40 }
        field(50025; "Purchase Code New"; Code[40])
        {
            TableRelation = "Salesperson/Purchaser"."Code New";
            Caption = 'Código Vendedor Largo';
            Description = 'EX-JVN aumentado de 10 a 40';
            trigger OnValidate()
            var
                Salesperson: Record "Salesperson/Purchaser";
            begin
                if ("Purchase Code New" <> '') then begin
                    Salesperson.SetRange("Code New", "Purchase Code New");
                    if Salesperson.FindFirst() then begin
                        "Purchaser Code" := Salesperson."Code";
                    end;
                end;
            end;
        }
        // { 50000;  ;Id JSon             ;Text50        ;Description=EX-JVN Integraci¢n JSon }
        field(50000; "Id JSon"; Text[50])
        {
            Caption = 'Id JSon';
            Description = 'EX-JVN Integración JSon';
        }
        // { 50001;  ;No. AUX             ;Code20        ;Description=EX-JVN }
        field(50001; "No. AUX"; Code[20])
        {
            Caption = 'No. AUX';
            Description = 'EX-JVN';
        }
        // { 50091;  ;Vendor Type         ;Option        ;CaptionML=[ENU=Vendor Type;
        //                                                       ESP=Tipo Proveedor];
        //                                            OptionCaptionML=[ENU=" ,National,Foreign,Global";
        //                                                             ESP=" ,Nacional,Extranjero,Global";
        //                                                             ESM=" ,Nacional,Extranjero,Global"];
        //                                            OptionString=[ ,Nacional,Extranjero,Global];
        //                                            Description=EXC.REG }
        field(50091; "Vendor Type"; Enum "Vendor Type")

        {
            Caption = 'Tipo Proveedor';
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
            Caption = 'Tipo de Operación';
            Description = 'EXC.REG';
        }
        //{ 50600;  ;Clave Id. fiscal contraparte;Code2 ;Description=SII: Muestra dato SII de Contraparte }
        field(50600; "Clave Id. fiscal contraparte"; Code[2])
        {
            Caption = 'Clave Id. fiscal contraparte';
            Description = 'SII: Muestra dato SII de Contraparte';
        }
        //{ 50601;  ;NIF Entidad Sucedida;Code10        ;Description=SIIv3: 070618 }
        field(50601; "NIF Entidad Sucedida"; Code[10])
        {
            Caption = 'NIF Entidad Sucedida';
            Description = 'SIIv3: 070618';
        }
        // { 50602;  ;Razon Social Entidad Sucedida;Code10;
        //                                             Description=SIIv3: 070618 }
        field(50602; "Razon Social Entidad Sucedida"; Code[10])
        {
            Caption = 'Razon Social Entidad Sucedida';
            Description = 'SIIv3: 070618';
        }
    }
}