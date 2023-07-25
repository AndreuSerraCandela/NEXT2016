/// <summary>
/// TableExtension PurchaseLine (ID 92039) extends Record Purchase Line.
/// </summary>
tableextension 92039 PurchaseLine extends "Purchase Line"
{
    fields
    {
        //    { 50000;  ;C¢d. L¡nea          ;Code50        ;OnValidate=BEGIN
        //                                                             PurchLine2.RESET;
        //                                                             PurchLine2.SETRANGE(PurchLine2."Document Type",PurchLine2."Document Type"::Order);
        //                                                             PurchLine2.SETRANGE(PurchLine2."C¢d. L¡nea","C¢d. L¡nea");

        //                                                             IF PurchLine2.FINDSET THEN
        //                                                               ERROR('Ya existe el c¢digo de l¡nea '+"C¢d. L¡nea");
        //                                                           END;

        //                                                Description=EX-JVN: C¢digo £nico de l¡nea, importado de WORKSPACE. }
        field(50000; "Cód. Línea"; Code[50])
        {
            trigger OnValidate()
            var
                PurchLine2: Record "Purchase Line";
            begin
                PurchLine2.RESET;
                PurchLine2.SETRANGE("Document Type", PurchLine2."Document Type"::Order);
                PurchLine2.SETRANGE("Cód. Línea", "Cód. Línea");

                if PurchLine2.FINDSET then
                    ERROR('Ya existe el código de línea ' + "Cód. Línea");
            end;
        }

        // { 50002;  ;ID Workspace        ;Text50         }
        field(50002; "ID Workspace"; Text[50]) { }
    }
}
/// <summary>
/// TableExtension PurchaseLine (ID 92039) extends Record Purchase Line.
/// </summary>
tableextension 92123 PurchaseInvLine extends 123
{
    fields
    {
        //    { 50000;  ;C¢d. L¡nea          ;Code50        ;OnValidate=BEGIN
        //                                                             PurchLine2.RESET;
        //                                                             PurchLine2.SETRANGE(PurchLine2."Document Type",PurchLine2."Document Type"::Order);
        //                                                             PurchLine2.SETRANGE(PurchLine2."C¢d. L¡nea","C¢d. L¡nea");

        //                                                             IF PurchLine2.FINDSET THEN
        //                                                               ERROR('Ya existe el c¢digo de l¡nea '+"C¢d. L¡nea");
        //                                                           END;

        //                                                Description=EX-JVN: C¢digo £nico de l¡nea, importado de WORKSPACE. }
        field(50000; "Cód. Línea"; Code[50])
        {

        }
        field(50001; Estado; Enum "Estado WorkSpace")
        { }

        // { 50002;  ;ID Workspace        ;Text50         }
        field(50002; "ID Workspace"; Text[50]) { }
    }
}
/// <summary>
/// TableExtension PurchaseLine (ID 92039) extends Record Purchase Line.
/// </summary>
tableextension 92125 PurchaseCrLine extends 125
{
    fields
    {
        //    { 50000;  ;C¢d. L¡nea          ;Code50        ;OnValidate=BEGIN
        //                                                             PurchLine2.RESET;
        //                                                             PurchLine2.SETRANGE(PurchLine2."Document Type",PurchLine2."Document Type"::Order);
        //                                                             PurchLine2.SETRANGE(PurchLine2."C¢d. L¡nea","C¢d. L¡nea");

        //                                                             IF PurchLine2.FINDSET THEN
        //                                                               ERROR('Ya existe el c¢digo de l¡nea '+"C¢d. L¡nea");
        //                                                           END;

        //                                                Description=EX-JVN: C¢digo £nico de l¡nea, importado de WORKSPACE. }
        field(50000; "Cód. Línea"; Code[50])
        {

        }
        field(50001; Estado; Enum "Estado WorkSpace")
        { }
        // { 50002;  ;ID Workspace        ;Text50         }
        field(50002; "ID Workspace"; Text[50]) { }
    }
}