table 50605 "Company Information 2"
{
    // SIIv3 Periodo Trimestral
    //       Fecha Limite presentacion AEAT
    // EX-SIIv4 Nuevo campo Fecha Limite Inferior


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(50600; "Id. Empresa SII"; Code[3])
        {
        }
        field(50601; "Ruta ficheros SII"; Text[250])
        {
        }
        field(50602; "Ruta ficheros entregados SII"; Text[250])
        {
        }
        field(50603; "Servidor FTP SII"; Text[250])
        {
        }
        field(50604; "Ruta subida ficheros FTP SII"; Text[250])
        {
        }
        field(50605; "Usuario FTP"; Text[50])
        {
        }
        field(50606; "Contraseña FTP"; Text[50])
        {
        }
        field(50607; "Id versión SII"; Text[30])
        {
        }
        field(50608; "Tipo comunicación"; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L0'));
        }
        field(50609; "NIF Declarante"; Code[9])
        {
        }
        field(50610; "Apell. Nombre.- Razón social"; Text[120])
        {
        }
        field(50611; "NIF Representante legal"; Code[9])
        {
        }
        field(50612; Ejercicio; Integer)
        {
        }
        field(50613; Periodo; Code[2])
        {
            TableRelation = "SII- Tablas valores SII".Valor WHERE("Id. tabla" = FILTER('L1'));
        }
        field(50614; "Nº registro envío autorización"; Code[15])
        {
        }
        field(50615; "Obtener docs. desde fecha"; Date)
        {
        }
        field(50616; "Obtener docs. hasta fecha"; Date)
        {
        }
        field(50617; "Generar fichero desde fecha"; Date)
        {
        }
        field(50618; "Generar fichero hasta fecha"; Date)
        {
        }
        field(50619; "Enviar documentos desde fecha"; Date)
        {
        }
        field(50620; "Enviar documentos hasta fecha"; Date)
        {
        }
        field(50621; "Ult. desde fecha Obtención"; Date)
        {
        }
        field(50622; "Ult. hasta fecha Obtención"; Date)
        {
        }
        field(50623; "Ult. desde fecha generación"; Date)
        {
        }
        field(50624; "Ult. hasta fecha generación"; Date)
        {
        }
        field(50625; "Ult. desde fecha Envío"; Date)
        {
        }
        field(50626; "Ult. hasta fecha Envío"; Date)
        {
        }
        field(50627; "Procesar Facturas venta"; Boolean)
        {
        }
        field(50628; "Procesar Abonos venta"; Boolean)
        {
        }
        field(50629; "Procesar Facturas compra"; Boolean)
        {
        }
        field(50630; "Procesar Abonos compra"; Boolean)
        {
        }
        field(50631; "Procesar Bienes de inversión"; Boolean)
        {

            trigger OnValidate()
            begin
                ERROR('Proceso no implementado.');
            end;
        }
        field(50632; "Proceso obtención documentos"; Boolean)
        {
        }
        field(50633; "Proceso generación ficheros"; Boolean)
        {
        }
        field(50634; "Proceso envío a plataforma"; Boolean)
        {
        }
        field(50635; "Testeo Datos SII en registro"; Boolean)
        {
        }
        field(50636; "Procesar Movimientos Contables"; Boolean)
        {
        }
        field(50637; "Periodo Trimestral"; Boolean)
        {
            Description = 'SIIv3';
        }
        field(50638; "Fecha Limite presentacion AEAT"; DateFormula)
        {
            Caption = 'Fecha Limite presentación AEAT';
            Description = 'SIIv3';
        }
        field(50639; "Fecha Limite Inferior"; DateFormula)
        {
            Description = 'SIIV4 240918';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

