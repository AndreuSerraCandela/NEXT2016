/// <summary>
/// Enum Sii Tipo Documento (ID 92001).
/// </summary>
enum 92001 "Sii Tipo Documento"
{
    //"Factura emitida","Abono emitido","Factura emitida reg.","Abono emitido reg.","Factura recibida","Abono recibido","Factura recibida reg.","Abono recibido reg.",BI,"Srv pedido","Srv Factura","Srv Abono","Srv Factura reg.","Srv Abono reg.";
    value(0; "Factura emitida")
    { }
    value(1; "Abono emitido")
    { }
    value(2; "Factura emitida reg.")
    { }
    value(3; "Abono emitido reg.")
    { }
    value(4; "Factura recibida")
    { }
    value(5; "Abono recibido")
    { }
    value(6; "Factura recibida reg.")
    { }
    value(7; "Abono recibido reg.")
    { }
    value(8; BI)
    { }
    value(9; "Srv pedido")
    { }
    value(10; "Srv Factura")
    { }
    value(11; "Srv Abono")
    { }
    value(12; "Srv Factura reg.")
    { }
    value(13; "Srv Abono reg.")
    { }

}
enum 92002 "Sii Tipo registro"
{
    //OptionMembers = Cabecera,Detalles;
    value(0; "Cabecera")
    { }
    value(1; "Detalles")
    { }
}
enum 92003 "Sii Tipos Documento"
{
    //Factura,Abono,"B.I."
    value(0; "Factura")
    { }
    value(1; "Abono")
    { }
    value(2; "B.I.")
    { }
}
enum 92004 "Sii Origen Documento"
{
    //OptionMembers = Emitida,Recibida,"B.I.";
    value(0; "Emitida")
    { }
    value(1; "Recibida")
    { }
    value(2; "B.I.")
    { }
}
enum 92005 "Sii Estado Documento"
{
    //// OptionMembers = " ","Pendiente procesar","Incluido en fichero","Enviado a plataforma",Incidencias,"Obtener de nuevo","Validado AEAT";

    value(0; " ")
    { }
    value(1; "Pendiente procesar")
    { }
    value(2; "Incluido en fichero")
    { }
    value(3; "Enviado a plataforma")
    { }
    value(4; Incidencias)
    { }
    value(5; "Obtener de nuevo")
    { }
    value(6; "Validado AEAT")
    { }
}