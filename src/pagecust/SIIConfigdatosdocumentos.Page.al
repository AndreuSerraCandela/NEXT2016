page 50602 "SII- Config. datos documentos"
{
    // //010617 SII Nuevo objeto

    PageType = List;
    SourceTable = "SII- Config. múltiple";
    SourceTableView = WHERE("Tipo configuración" = FILTER('Datos por documento'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field(Orden; Rec.Orden)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Orden field.';
                }
                field("No. Linea"; Rec."No. Linea")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Linea field.';
                }
                field("% IVA"; Rec."% IVA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the % IVA field.';
                }
                field("Causa exención"; Rec."Causa exención")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Causa exención field.';
                }
                field("Clave Id. fiscal contraparte"; Rec."Clave Id. fiscal contraparte")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clave Id. fiscal contraparte field.';
                }
                field("Clave regimen especial emitida"; Rec."Clave regimen especial emitida")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clave régimen especial emitida field.';
                }
                field("Clave regimen especial recibid"; Rec."Clave regimen especial recibid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clave régimen especial recibida field.';
                }
                field("Clave rég. esp. abono emitido"; Rec."Clave rég. esp. abono emitido")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clave rég. esp. abono emitido field.';
                }
                field("Clave rég. esp. abono recibido"; Rec."Clave rég. esp. abono recibido")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clave rég. esp. abono recibido field.';
                }
                field("Cód forma pago"; Rec."Cód forma pago")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cód forma pago field.';
                }
                field("Cód. contraparte"; Rec."Cód. contraparte")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cód. contraparte field.';
                }
                field("Cód. país contraparte"; Rec."Cód. país contraparte")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cód. país contraparte field.';
                }
                field(DUA; Rec.DUA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DUA field.';
                }
                field("Dato SII a exportar como"; Rec."Dato SII a exportar como")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dato SII a exportar como field.';
                }
                field("Dato a exportar No Sujeto"; Rec."Dato a exportar No Sujeto")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dato a exportar No Sujeto field.';
                }
                field(Desactivar; Rec.Desactivar)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Desactivar field.';
                }
                field("Excluir del SII"; Rec."Excluir del SII")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Excluir del SII field.';
                }
                field(Exento; Rec.Exento)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exento field.';
                }
                field("Filtro tabla valores SII"; Rec."Filtro tabla valores SII")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Filtro tabla valores SII field.';
                }
                field("Gr. Contable producto"; Rec."Gr. Contable producto")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gr. Contable producto field.';
                }
                field("Gr. Reg. IVA Negocio"; Rec."Gr. Reg. IVA Negocio")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gr. Reg. IVA Negocio field.';
                }
                field("Gr. Reg. IVA Producto"; Rec."Gr. Reg. IVA Producto")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gr. Reg. IVA Producto field.';
                }
                field("Informar en documento"; Rec."Informar en documento")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Informar en documento field.';
                }
                field("Inversión sujeto pasivo"; Rec."Inversión sujeto pasivo")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inversión sujeto pasivo field.';
                }
                field("Medio pago SII"; Rec."Medio pago SII")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Medio pago SII field.';
                }
                field("NIF Representante contraparte"; Rec."NIF Representante contraparte")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NIF Representante contraparte field.';
                }
                field("NIF/ID. fiscal contraparte"; Rec."NIF/ID. fiscal contraparte")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NIF/ID. fiscal contraparte field.';
                }
                field("Nombre contraparte"; Rec."Nombre contraparte")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nombre contraparte field.';
                }
                field("Nombre dato SII"; Rec."Nombre dato SII")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nombre dato SII field.';
                }
                field(Obligatorio; Rec.Obligatorio)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Obligatorio field.';
                }
                field(Observaciones; Rec.Observaciones)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Observaciones field.';
                }
                field(REAGP; Rec.REAGP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the REAGP field.';
                }
                field("Régimen Criterio de caja"; Rec."Régimen Criterio de caja")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Régimen Criterio de caja field.';
                }
                field("Tipo Contraparte"; Rec."Tipo Contraparte")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo Contraparte field.';
                }
                field("Tipo No Exención"; Rec."Tipo No Exención")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo No Exención field.';
                }
                field("Tipo No sujeta"; Rec."Tipo No sujeta")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo No sujeta field.';
                }
                field("Tipo abono emitido"; Rec."Tipo abono emitido")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo abono emitido field.';
                }
                field("Tipo abono recibido"; Rec."Tipo abono recibido")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo abono recibido field.';
                }
                field("Tipo configuración"; Rec."Tipo configuración")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo configuración field.';
                }
                field("Tipo cálculo IVA"; Rec."Tipo cálculo IVA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Calculation Type field.';
                }
                field("Tipo de documento"; Rec."Tipo de documento")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo de documento field.';
                }
                field("Tipo desglose IVA"; Rec."Tipo desglose IVA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo desglose IVA field.';
                }
                field("Tipo factura emitida"; Rec."Tipo factura emitida")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo factura emitida field.';
                }
                field("Tipo factura recibida"; Rec."Tipo factura recibida")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo factura recibida field.';
                }
                field("Tipo operación"; Rec."Tipo operación")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tipo operación field.';
                }
                field("Valor inicial"; Rec."Valor inicial")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Valor inicial field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        rec.FILTERGROUP(0);
    end;
}

