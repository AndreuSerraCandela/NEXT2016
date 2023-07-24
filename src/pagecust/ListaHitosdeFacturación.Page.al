page 50018 "Lista Hitos de Facturación"
{
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Hitos Facturación";

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
                field("Cód. Lín. Oferta"; Rec."Cód. Lín. Oferta")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cód. Línea Oferta field.';
                }
                field("Cód. Oferta"; Rec."Cód. Oferta")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cód. Oferta field.';
                }
                field("Desc. Línea"; Rec."Desc. Línea")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Desc. Línea field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(Estado; Rec.Estado)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Estado field.';
                }
                field(Facturado; Rec.Facturado)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Facturado field.';
                }
                field("Fecha Facturado"; Rec."Fecha Facturado")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha Facturado field.';
                }
                field("Fecha Reg. Pedido"; Rec."Fecha Reg. Pedido")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha Reg. Pedido field.';
                }
                field("Fecha carga"; Rec."Fecha carga")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha carga field.';
                }
                field("Fecha prevista fact."; Rec."Fecha prevista fact.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fecha prevista fact. field.';
                }
                field("No. Cliente"; Rec."No. Cliente")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Cliente field.';
                }
                field("No. Factura"; Rec."No. Factura")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Factura field.';
                }
                field("No. Producto"; Rec."No. Producto")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Producto field.';
                }
                field("Nombre Cliente"; Rec."Nombre Cliente")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nombre Cliente field.';
                }
                field(Percent; Rec.Percent)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Porcentaje field.';
                }
                field(TieneLinea; Rec.TieneLinea)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TieneLinea field.';
                }
                field(Total; Rec.Total)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        IF (rec.Estado = rec.Estado::Pendiente) OR (rec.Estado = rec.Estado::Actualizado) THEN
            v_editable := FALSE
        ELSE
            v_editable := TRUE;
    end;

    var
        v_editable: Boolean;
}

