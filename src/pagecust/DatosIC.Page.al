page 50003 "Datos IC"
{
    PageType = ListPart;
    SourceTable = "Datos IC";

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field(Tipo; Rec.Tipo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo field.';
                }
                field(Empresa; Rec.Empresa)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Empresa field.';
                }
                field("Cliente/Proveedor"; Rec."Cliente/Proveedor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cliente/Proveedor field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Crear Datos")
            {

                trigger OnAction()
                begin
                    Rec.CrearRegistros;
                end;
            }
        }
    }
}

