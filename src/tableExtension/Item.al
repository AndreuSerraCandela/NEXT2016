/// <summary>
/// TableExtension ItemExt (ID 92027) extends Record Item.
/// </summary>
tableextension 92027 ItemExt extends Item
{
    fields
    {
        // { 50000;  ;Id JSon             ;Text50        ;Description=EX-JVN Integraci¢n JSon }
        field(50000; "Id JSon"; Text[50]) { Description = 'EX-JVN Integraci¢n JSon'; }
        // { 50800;  ;CFDI ClaveProdServ  ;Code20        ;TableRelation="Catalogo CFDI 3.3".Codigo WHERE (Tipo Tabla=CONST(c_ClaveProdServ));
        //                                            Description=EX-FACTE }
        field(50800; "CFDI ClaveProdServ"; Code[20]) { TableRelation = "Catalogo CFDI 3.3".Codigo WHERE("Tipo Tabla" = CONST('c_ClaveProdServ')); Description = 'EX-FACTE'; }
    }
}