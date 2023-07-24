table 50013 Intercomapy_AUXI
{
    DataPerCompany = false;

    fields
    {
        field(1; ID; Code[50])
        {
            Description = 'ID del webservice';
        }
        field(2; "Company Origin"; Text[30])
        {
            Caption = 'Empresa Origen';
            Description = 'Nombre empresa que vende';
        }
        field(4; "Currency Origin"; Code[10])
        {
            Caption = 'Divisa Origen';
        }
        field(5; "Amount Origin"; Decimal)
        {
            Caption = 'Importe Origen';
        }
        field(6; ERROR; Boolean)
        {
            Description = 'Fallo al pasar a NAV.';
        }
        field(7; PROCESAR; Boolean)
        {
            Description = 'Importado de workspace, pendiente de tratar.';
        }
        field(8; "TERMINADO VENTA"; Boolean)
        {
            Description = 'Introducido en NAV correctamente, doc de venta';
        }
        field(9; "Fecha Carga"; Date)
        {
            Description = 'Fecha de carga desde el workspace.';
        }
        field(10; "Posting Date"; Date)
        {
            Caption = 'Fecha de Registro';
        }
        field(11; "Company Destination"; Text[30])
        {
            Caption = 'Empresa Destino';
            Description = 'Nombre empresa que compra';
        }
        field(12; "Amount Destination"; Decimal)
        {
            Caption = 'Importe Destino';
        }
        field(13; "Currency Destination"; Code[10])
        {
            Caption = 'Divisa Destino';
        }
        field(14; "Documento No"; Code[20])
        {
            Caption = 'Nº Documento';
        }
        field(15; "TERMINADO COMPRA"; Boolean)
        {
            Description = 'Introducido en NAV correctamente, doc de compra';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
        key(Key2; ERROR, PROCESAR, "Company Origin", "Company Destination", "TERMINADO VENTA", "TERMINADO COMPRA")
        {
        }
    }

    fieldgroups
    {
    }
}

