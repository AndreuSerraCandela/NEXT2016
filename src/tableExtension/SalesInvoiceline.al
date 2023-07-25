/// <summary>
/// TableExtension SalesInvoiceLine (ID 91113) extends Record Sales Invoice Line.
/// </summary>
tableextension 91113 SalesInvoiceLine extends "Sales Invoice Line"
{

    fields
    {
        field(50000; "Cód Línea"; Code[20])
        {
            Description = 'Código único de línea, importado de WORKSPACE.';
            DataClassification = CustomerContent;
        }
        field(50001; "Precio Coste"; Decimal)
        {
            Caption = 'Precio Coste';
            DataClassification = CustomerContent;
        }
        field(50800; "Línea Retención"; Enum "Línea Retención")
        {
            Caption = 'Línea Retención';
            FieldClass = FlowField;
            // OptionMembers = T,R;
            CalcFormula = Lookup("VAT Posting Setup"."CFDI Categoria Imp" WHERE("VAT Prod. Posting Group" = FIELD("VAT Prod. Posting Group"), "VAT Bus. Posting Group" = FIELD("VAT Bus. Posting Group")));
        }
    }
}
tableextension 91115 SalesICrMemoLine extends "Sales Cr.Memo Line"
{

    fields
    {


        field(50800; "Línea Retención"; Enum "Línea Retención")
        {
            Caption = 'Línea Retención';
            FieldClass = FlowField;
            // OptionMembers = T,R;
            CalcFormula = Lookup("VAT Posting Setup"."CFDI Categoria Imp" WHERE("VAT Prod. Posting Group" = FIELD("VAT Prod. Posting Group"), "VAT Bus. Posting Group" = FIELD("VAT Bus. Posting Group")));
        }
    }
}

