/// <summary>
/// TableExtension PaymentTerms (ID 92003) extends Record Payment Terms.
/// </summary>
tableextension 92003 PaymentTerms extends "Payment Terms"
{
    // { 50802;  ;CFDI                ;Code20        ;TableRelation="Catalogo CFDI 3.3".Codigo WHERE (Tipo Tabla=CONST(c_MetodoPago));
    fields
    {
        field(50802; "CFDI"; Code[20])
        {
            TableRelation = "Catalogo CFDI 3.3".Codigo WHERE("Tipo Tabla" = CONST('c_MetodoPago'));
        }
    }

}