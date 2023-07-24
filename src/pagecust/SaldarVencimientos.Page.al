page 50010 "Saldar Vencimientos"
{
    // SF-MLA Page para lanzar la acción de saldar Vencimientos desde Documentos a pagar.


    layout
    {
        area(content)
        {
            field("Fecha Documento"; XFechaDocumento)
            {
            }
            field("Nº Documento"; XNumDocumento)
            {
            }
        }
    }

    actions
    {
    }

    var
        XFechaDocumento: Date;
        XNumDocumento: Code[20];


    procedure "MandaParámetros"(var X2Documento: Code[20]; var X2Fecha: Date)
    var
        formu: Page "Cartera Documents";
    begin
        X2Documento := XNumDocumento;
        X2Fecha := XFechaDocumento;
    end;
}

