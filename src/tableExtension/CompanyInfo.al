/// <summary>
/// TableExtension CompanyInfo (ID 92081) extends Record Company Information.
/// </summary>
tableextension 92079 CompanyInfo extends "Company Information"
{
    fields
    {
        //    { 50000;  ;Registro Mercantil  ;Text250       ;Description=EX-JVN-100216 }
        field(50000; RegistroMercantil; Text[250])
        {
            Caption = 'Registro Mercantil';
            Description = 'EX-JVN-100216';
        }
        // { 50001;  ;CLABE               ;Text100       ;Description=EX-JVN 250618 }
        field(50001; CLABE; Text[100])
        {
            Caption = 'CLABE';
            Description = 'EX-JVN 250618';
        }
        // { 50802;  ;Calle               ;Text50        ;OnValidate=BEGIN
        //                                                             Direccion; //EX-SGG-FACTE;
        //                                                           END;

        //                                                Description=EX-SGG-FACTE }
        field(50802; Calle; Text[50])
        {
            Caption = 'Calle';
            Description = 'EX-SGG-FACTE';
            trigger OnValidate()
            begin
                Direccion;
            end;

        }
        // { 50803;  ;No. Int.            ;Text10        ;OnValidate=BEGIN
        //                                                             Direccion; //EX-SGG-FACTE;
        //                                                           END;

        //                                                Description=EX-SGG-FACTE }
        field(50803; "No. Int."; Text[10])
        {
            Caption = 'No. Int.';
            Description = 'EX-SGG-FACTE';
            trigger OnValidate()
            begin
                Direccion;
            end;

        }
        // { 50804;  ;No. Ext.            ;Text10        ;OnValidate=BEGIN
        //                                                             Direccion; //EX-SGG-FACTE;
        //                                                           END;

        //                                                Description=EX-SGG-FACTE }
        field(50804; "No. Ext."; Text[10])
        {
            Caption = 'No. Ext.';
            Description = 'EX-SGG-FACTE';
            trigger OnValidate()
            begin
                Direccion;
            end;

        }
        // { 50805;  ;Regimen fiscal      ;Text150       ;Description=EX-SGG-FACTE }
        field(50805; "Regimen fiscal"; Text[150])
        {
            Caption = 'Regimen fiscal';
            Description = 'EX-SGG-FACTE';
        }
        // { 50806;  ;Representante legal ;Text80        ;Description=EX-SGG-FACTE }
        field(50806; "Representante legal"; Text[80])
        {
            Caption = 'Representante legal';
            Description = 'EX-SGG-FACTE';
        }
        // { 50810;  ;Ruta ficheros FacturaE;Text200     ;Description=EX-SGG-FACTE }
        field(50810; "Ruta ficheros FacturaE"; Text[200])
        {
            Caption = 'Ruta ficheros FacturaE';
            Description = 'EX-SGG-FACTE';
        }
        // { 50811;  ;N§ serie FacturaE   ;Code10        ;TableRelation="No. Series";
        //                                                Description=EX-SGG-FACTE }
        field(50811; "Nº serie FacturaE"; Code[10])
        {
            Caption = 'Nº serie FacturaE';
            Description = 'EX-SGG-FACTE';
            TableRelation = "No. Series";
        }
        // { 50812;  ;Ruta FTP FacturaE   ;Text50        ;Description=EX-SGG-FACTE }
        field(50812; "Ruta FTP FacturaE"; Text[50])
        {
            Caption = 'Ruta FTP FacturaE';
            Description = 'EX-SGG-FACTE';
        }
        // { 50813;  ;Usuario FTP FacturaE;Text50        ;Description=EX-SGG-FACTE }
        field(50813; "Usuario FTP FacturaE"; Text[50])
        {
            Caption = 'Usuario FTP FacturaE';
            Description = 'EX-SGG-FACTE';
        }
        // { 50814;  ;Contrase¤a FTP FacturaE;Text50     ;Description=EX-SGG-FACTE }
        field(50814; "Contraseña FTP FacturaE"; Text[50])
        {
            Caption = 'Contraseña FTP FacturaE';
            Description = 'EX-SGG-FACTE';
        }
        // { 50815;  ;FTP dir. subida FacturaE;Text50    ;Description=EX-SGG-FACTE }
        field(50815; "FTP dir. subida FacturaE"; Text[50])
        {
            Caption = 'FTP dir. subida FacturaE';
            Description = 'EX-SGG-FACTE';
        }
        // { 50816;  ;Ruta descarga FTP FacturaE;Text100 ;Description=EX-SGG-FACTE }
        field(50816; "Ruta descarga FTP FacturaE"; Text[100])
        {
            Caption = 'Ruta descarga FTP FacturaE';
            Description = 'EX-SGG-FACTE';
        }
        // { 50817;  ;Texto observaciones ;Text80        ;Description=EX-SGG-FACTE }
        field(50817; "Texto observaciones"; Text[80])
        {
            Caption = 'Texto observaciones';
            Description = 'EX-SGG-FACTE';
        }
        // { 50818;  ;Mail contacto 1     ;Text50        ;Description=EX-SGG-FACTE }
        field(50818; "Mail contacto 1"; Text[50])
        {
            Caption = 'Mail contacto 1';
            Description = 'EX-SGG-FACTE';
        }
        // { 50819;  ;Mail contacto 2     ;Text50        ;Description=EX-SGG-FACTE }
        field(50819; "Mail contacto 2"; Text[50])
        {
            Caption = 'Mail contacto 2';
            Description = 'EX-SGG-FACTE';
        }
        // { 50820;  ;Tel‚fono contacto   ;Text30        ;Description=EX-SGG-FACTE }
        field(50820; "Teléfono contacto"; Text[30])
        {
            Caption = 'Teléfono contacto';
            Description = 'EX-SGG-FACTE';
        }
        // { 50821;  ;FTP dir. bajada FacturaE;Text50    ;Description=EX-SGG-FACTE }
        field(50821; "FTP dir. bajada FacturaE"; Text[50])
        {
            Caption = 'FTP dir. bajada FacturaE';
            Description = 'EX-SGG-FACTE';
        }
        // { 50822;  ;Auto FacturaE       ;Boolean       ;Description=EX-SGG-FACTE }
        field(50822; "Auto FacturaE"; Boolean)
        {
            Caption = 'Auto FacturaE';
            Description = 'EX-SGG-FACTE';
        }
        // { 50823;  ;Ruta vinculos FacturaE;Text200     ;Description=EX-SGG-FACTE }
        field(50823; "Ruta vínculos FacturaE"; Text[200])
        {
            Caption = 'Ruta vínculos FacturaE';
            Description = 'EX-SGG-FACTE';
        }
        // { 50824;  ;Federal ID No.      ;Text30        ;CaptionML=[ENU=Federal ID No.;
        //                                                           ESM=CURP;
        //                                                           FRC=Nø d'identification f‚d‚ral;
        //                                                           ENC=Federal BIN No.];
        //                                                Description=EXC.REG }
        field(50824; "Federal ID No."; Text[30])
        {
            CaptionML = ENU = 'Federal ID No.', ESM = 'CURP', FRC = 'Nº d''identification fédéral', ENC = 'Federal BIN No.';
            Description = 'EXC.REG';
        }
        // { 50825;  ;Lugar Expedicion    ;Text30        ;Description=EX-MX,EX-ELEC-MX }
        field(50825; "Lugar Expedicion"; Text[30])
        {
            Caption = 'Lugar Expedicion';
            Description = 'EX-MX,EX-ELEC-MX';
        }
        // { 50826;  ;imageISO9001        ;BLOB          ;SubType=Bitmap }
        field(50826; imageISO9001; BLOB)
        {
            Caption = 'imageISO9001';
            Subtype = Bitmap;
        }
        // { 50827;  ;imageISO27001       ;BLOB          ;SubType=Bitmap }
        field(50827; imageISO27001; BLOB)
        {
            Caption = 'imageISO27001';
            Subtype = Bitmap;
        }
        field(90000; "Default Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }
    PROCEDURE "--EX-SGG-FACTE"();
    BEGIN
    END;

    PROCEDURE Direccion();
    BEGIN
        Address := COPYSTR(Calle + ' ' + "No. Ext.", 1, 100);
        IF "No. Int." <> '' THEN
            Address := COPYSTR(Address + ' - ' + "No. Int.", 1, 100);
    END;
}