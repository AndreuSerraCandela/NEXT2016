/// <summary>
/// TableExtension SalesSetup (ID 92311) extends Record Sales  Receivables Setup.
/// </summary>
tableextension 92311 SalesSetup extends "Sales & Receivables Setup"
{
    fields
    {

        field(50000; "Sección saldo vencimientos"; Code[20])
        {
            ; TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Libro saldo vencimientos"));
            ValidateTableRelation = false;
            Description = 'SF-MLA';
        }
        field(50001; "Plantilla Cliente por defecto"; Code[10])
        {
            TableRelation = "Customer Templ.";
            Description = 'EX-JVN';
        }
        field(50002; "Sección Vendedores"; Code[20]) {; Description = 'EX-JVN'; }
        field(50003; "Valor Centro Oferta "; Code[20])
        {
            ; TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            Description = 'EX-JVN';
        }
        field(50004; "Valor Departamento Oferta"; Code[20])
        {
            ; TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Description = 'EX-JVN';
        }
        field(50005; "Valor 2 Centro Oferta"; Code[20])
        {
            ; TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            Description = 'EX-JVN';
        }
        field(50006; "Valor 2 Departamento Oferta"; Code[20])
        {
            ; TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Description = 'EX-JVN';
        }
        field(50007; "Libro saldo vencimientos"; Code[20])
        {
            ; TableRelation = "Gen. Journal Template".Name;
            Description = 'SF-MLA';
        }
        field(50008; "Omite movimientos"; Boolean) {; Description = '3717'; }
        field(52009; "URL Servicio Web CertificaE"; Text[250]) {; Description = 'EXC-FACTE'; }
        field(52010; "Usuario CertificaE"; Text[100]) {; Description = 'EXC-FACTE'; }
        field(52011; "Password CertificaE"; Text[50]) {; Description = 'EXC-FACTE'; }
        field(52015; "Ruta Archivos Maestros"; Text[250]) {; Description = 'EXC-FACTE'; }
        field(52017; "Ruta Archivos Retorno"; Text[250]) {; Description = 'EXC-FACTE'; }
        field(52018; "Logo Empresa"; Text[250]) {; Description = 'EXC-FACTE'; }
    }
}
