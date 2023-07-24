page 50013 OfertasAux
{
    Caption = 'Ofertas Auxiliar';
    InsertAllowed = false;
    PageType = List;
    SourceTable = OfertaVenta_AUXi;
    SourceTableView = SORTING("No.", "Cod. Cab")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Cod. Cab"; Rec."Cod. Cab")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cod. Cab field.';
                }
                field("Cod. Cliente"; Rec."Cod. Cliente")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cod. Cliente field.';
                }
                field("Cod. Vendedor"; Rec."Cod. Vendedor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cod. Vendedor field.';
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company field.';
                }
                field(Description2; Rec.Description2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description2 field.';
                }
                field("Dto. Factura"; Rec."Dto. Factura")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dto. Factura field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(ERROR; Rec.ERROR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERROR field.';
                }
                field("Fecha Aceptación"; Rec."Fecha Aceptación")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha Aceptación field.';
                }
                field("Fecha Carga"; Rec."Fecha Carga")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha Carga field.';
                }
                field(Mail; Rec.Mail)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mail field.';
                }
                field("Mail Vendedor"; Rec."Mail Vendedor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mail Vendedor field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Nombre Vendedor"; Rec."Nombre Vendedor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nombre Vendedor field.';
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

