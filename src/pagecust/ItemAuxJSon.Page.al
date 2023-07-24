page 50025 "Item Aux JSon"
{
    Caption = 'Productos Auxiliar';
    PageType = List;
    SourceTable = Item_AUXI_JSon;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Id field.';
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field("Fecha Carga"; Rec."Fecha Carga")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha Carga field.';
                }
                field("Prod. de Compra"; Rec."Prod. de Compra")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prod. de Compra field.';
                }
            }
        }
    }

    actions
    {
    }
}

