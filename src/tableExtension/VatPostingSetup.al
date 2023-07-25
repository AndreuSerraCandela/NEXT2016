/// <summary>
/// TableExtension VatPostingSetup (ID 92325) extends Record VAT Posting Setup.
/// </summary>
tableextension 92325 VatPostingSetup extends "VAT Posting Setup"
{
    fields
    {

        // { 50800;  ;CFDI Impuesto       ;Code20        ;TableRelation="Catalogo CFDI 3.3".Codigo WHERE (Tipo Tabla=CONST(c_Impuesto));
        //                                                Description=EX-FACTE }
        field(50800; "CFDI Impuesto"; Code[20])
        {
            TableRelation = "Catalogo CFDI 3.3".Codigo WHERE("Tipo Tabla" = CONST('c_Impuesto'));
            Description = 'EX-FACTE';
        }
        // { 50801;  ;CFDI Factor         ;Option        ;OptionString=Tasa,Cuota;
        //                                                Description=EX-FACTE }
        field(50801; "CFDI Factor"; Enum "CFDI Factor")
        {

            //OptionString = 'Tasa,Cuota';
            Description = 'EX-FACTE';
        }
        // { 50802;  ;CFDI Categoria Imp  ;Option        ;OptionString=T,R;
        //                                                Description=EX-FACTE }
        field(50802; "CFDI Categoria Imp"; Enum "CFDI Categoria Imp")
        {
            //OptionString = 'T,R';
            Description = 'EX-FACTE';
        }
    }
}