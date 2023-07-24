/// <summary>
/// TableExtension SalesPerson (ID 92013).
/// </summary>
tableextension 92013 SalesPerson extends "Salesperson/Purchaser"
{
    // { 1   ;   ;Code                ;Code40        ;OnValidate=BEGIN
    //                                                         TESTFIELD(Code);
    //                                                       END;

    //                                            CaptionML=[ENU=Code;
    //                                                       ESP=C¢digo];
    //                                            NotBlank=Yes;
    //                                            Description=EX-JVN Aumentado de 10 a 40 }
    fields
    {
        field(50001; "Code New"; Code[40])
        {
            Caption = 'Código Largo';
            NotBlank = true;
            Description = 'EX-JVN Aumentado de 10 a 40';
            Trigger OnValidate()
            BEGIN
                If Code = '' Then Code := CopyStr("Code New", 1, 20);
            END;
        }
    }
}