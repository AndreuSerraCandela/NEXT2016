/// <summary>
/// TableExtension PahyMentMethod (ID 92289) extends Record Payment Method.
/// </summary>
tableextension 92289 PahyMentMethod extends "Payment Method"
{
    fields
    {

        //{ 50800;  ;Cod. payment method SAT;Code3      ;TableRelation="Catalogo CFDI 3.3".Codigo WHERE (Tipo Tabla=CONST(c_FormaPago)) }
        field(50800; "Cod. payment method SAT"; Code[3]) { Caption = 'Cod. payment method SAT'; TableRelation = "Catalogo CFDI 3.3".Codigo WHERE("Tipo Tabla" = CONST('c_FormaPago')); }
        //{ 50801;  ;Description payment method SAT;Text100 }
        field(50801; "Description payment method SAT"; Text[100]) { Caption = 'Description payment method SAT'; }
    }
}