page 50022 "Contacto Aux JSON"
{
    Caption = 'Contacto Auxiliar';
    PageType = List;
    SourceTable = "Contacto_AUXI_JSon";

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Name2; Rec.Name2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name2 field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(CIF; Rec.CIF)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CIF field.';
                }
                field(ERROR; Rec.ERROR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERROR field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("Fecha Carga"; Rec."Fecha Carga")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha Carga field.';
                }
                field(PROCESAR; Rec.PROCESAR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PROCESAR field.';
                }
                field(TERMINADO; Rec.TERMINADO)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TERMINADO field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        rec.SETRANGE(rec.TERMINADO, FALSE);
    end;
}

