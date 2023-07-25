/// <summary>
/// TableExtension PurchSetup (ID 92312) extends Record Purchases  Payables Setup.
/// </summary>
tableextension 92312 PurchSetup extends "Purchases & Payables Setup"
{
    fields
    {
        //     { 50000;  ;Secci¢n saldo vencimientos;Code20  ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Libro saldo vencimientos));
        //                                                ValidateTableRelation=No;
        //                                                Description=SF-MLA }
        field(5000; "Sección saldo vencimientos"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Libro saldo vencimientos"));
            ValidateTableRelation = false;
            Description = 'SF-MLA';
        }
        // { 50001;  ;Categor¡a producto de compra;Code20;TableRelation="Item Category" }
        field(5001; "Categoría producto de compra"; Code[20])
        {
            TableRelation = "Item Category";
        }
        // { 50002;  ;Libro saldo vencimientos;Code20    ;TableRelation="Gen. Journal Template".Name;
        //                                                Description=SF-MLA }
        field(5002; "Libro saldo vencimientos"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name;
            Description = 'SF-MLA';
        }
    }
}