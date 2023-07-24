table 50017 "Datos IC"
{

    fields
    {
        field(1; Empresa; Text[50])
        {
            TableRelation = Company.Name;

            trigger OnValidate()
            begin
                IF Empresa = COMPANYNAME THEN
                    ERROR('No es necesario introducir datos de la propia empresa.');
            end;
        }
        field(2; Tipo; Option)
        {
            OptionCaption = 'Sales,Purchases';
            OptionMembers = Sales,Purchases;
        }
        field(3; "Cliente/Proveedor"; Code[20])
        {
            TableRelation = IF (Tipo = CONST(Sales)) Customer
            ELSE
            IF (Tipo = CONST(Purchases)) Vendor;
        }
    }

    keys
    {
        key(Key1; Empresa, Tipo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recCompanies: Record Company;
        recDatosIC: Record "Datos IC";


    procedure CrearRegistros()
    begin
        recCompanies.RESET;
        recCompanies.SETFILTER(Name, '<>%1', COMPANYNAME);
        IF recCompanies.FINDSET THEN
            REPEAT
                recDatosIC.INIT;
                recDatosIC.Empresa := recCompanies.Name;
                recDatosIC.Tipo := recDatosIC.Tipo::Sales;
                IF recDatosIC.INSERT THEN;
                recDatosIC.Tipo := recDatosIC.Tipo::Purchases;
                IF recDatosIC.INSERT THEN;
            UNTIL recCompanies.NEXT = 0;
    end;
}

