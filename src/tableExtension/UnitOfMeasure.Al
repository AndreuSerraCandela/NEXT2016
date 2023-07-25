/// <summary>
/// TableExtension UnitOfmeasure (ID 92204) extends Record Unit of Measure.
/// </summary>
tableextension 92004 UnitOfmeasure extends "Unit of Measure"
{
    fields
    {
        //{ 50800;  ;CFDI Clave Unidad   ;Code20        ;TableRelation="Catalogo CFDI 3.3".Codigo WHERE (Tipo Tabla=CONST(c_ClaveUnidad));
        //                                           Description=EX-FACTE }
        field(50800; "CFDI Clave Unidad"; Code[20])
        {
            TableRelation = "Catalogo CFDI 3.3".Codigo WHERE("Tipo Tabla" = CONST('c_ClaveUnidad'));
            Description = 'EX-FACTE';
        }
    }
}