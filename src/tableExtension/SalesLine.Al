/// <summary>
/// TableExtension SalesLine (ID 92037) extends Record Sales Line.
/// </summary>
tableextension 92037 SalesLine extends "Sales Line"
{
    fields
    {
        // { 50000;  ;C¢d. L¡nea          ;Code20        ;OnValidate=BEGIN
        //                                                         SalesLine2.RESET;
        //                                                         //SalesLine2.SETRANGE(SalesLine2."Document Type",SalesLine2."Document Type"::Quote);
        //                                                         SalesLine2.SETRANGE(SalesLine2."C¢d. L¡nea","C¢d. L¡nea");

        //                                                         IF SalesLine2.FINDSET THEN
        //                                                           ERROR('Ya existe el c¢digo de l¡nea '+"C¢d. L¡nea");
        //                                                       END;
        field(50000; "Cód. Línea"; Code[20])
        {
            Description = 'EX-JVN: Código £nico de línea, importado de WORKSPACE.';
            trigger OnValidate()

            var
                SalesLine2: Record "Sales Line";
            begin
                SalesLine2.RESET;
                //SalesLine2.SETRANGE(SalesLine2."Document Type",SalesLine2."Document Type"::Quote);
                SalesLine2.SETRANGE(SalesLine2."Cód. Línea", "Cód. Línea");

                if SalesLine2.FINDSET then
                    ERROR('Ya existe el código de línea ' + "Cód. Línea");
            end;

        }

        //{ 50001;  ;Precio Coste        ;Decimal       ;Description=EX-JVN }
        field(50001; "Precio Coste"; Decimal)
        {
            Description = 'EX-JVN';
        }
        //{ 50002;  ;Dim3                ;Code20        ;Description=EX-JVN }
        field(50002; "Dim3"; Code[20])
        {
            Description = 'EX-JVN';
        }
    }
}
tableextension 92111 SalesShptLine extends "Sales Shipment Line"
{
    fields
    {
        // { 50000;  ;C¢d. L¡nea          ;Code20        ;OnValidate=BEGIN
        //                                                         SalesLine2.RESET;
        //                                                         //SalesLine2.SETRANGE(SalesLine2."Document Type",SalesLine2."Document Type"::Quote);
        //                                                         SalesLine2.SETRANGE(SalesLine2."C¢d. L¡nea","C¢d. L¡nea");

        //                                                         IF SalesLine2.FINDSET THEN
        //                                                           ERROR('Ya existe el c¢digo de l¡nea '+"C¢d. L¡nea");
        //                                                       END;
        field(50000; "Cód. Línea"; Code[20])
        {
            Description = 'EX-JVN: Código £nico de línea, importado de WORKSPACE.';
            trigger OnValidate()

            var
                SalesLine2: Record "Sales Line";
            begin
                SalesLine2.RESET;
                //SalesLine2.SETRANGE(SalesLine2."Document Type",SalesLine2."Document Type"::Quote);
                SalesLine2.SETRANGE(SalesLine2."Cód. Línea", "Cód. Línea");

                if SalesLine2.FINDSET then
                    ERROR('Ya existe el código de línea ' + "Cód. Línea");
            end;

        }

        //{ 50001;  ;Precio Coste        ;Decimal       ;Description=EX-JVN }
        field(50001; "Precio Coste"; Decimal)
        {
            Description = 'EX-JVN';
        }
        //{ 50002;  ;Dim3                ;Code20        ;Description=EX-JVN }
        field(50002; "Dim3"; Code[20])
        {
            Description = 'EX-JVN';
        }
    }
}