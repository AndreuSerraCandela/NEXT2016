tableextension 92050 ContactEx extends Contact //5050
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(90001; "Salesperson Filter 2"; Code[20])
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowFilter;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92065 InterationLogEntry extends "Interaction Log Entry" //5065
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}

tableextension 92071 Campaign extends Campaign //5071
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(90001; "Salesperson Filter 2"; Code[20])
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowFilter;
            TableRelation = "Salesperson/Purchaser";
        }
    }

}
tableextension 92072 CampaingEntry extends "Campaign Entry" //5072
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

}

tableextension 92076 SegmentHeader extends "Segment Header" //5076
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92077 SegmentLineEx extends "Segment Line" //5077
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92079 MarketingSetupEx extends "Marketing Setup" //5079
{
    fields
    {
        field(90000; "Default Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

}
tableextension 92080 ToDo extends "To-do" //5080
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(90001; "Completed By 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
        }
    }

}
tableextension 92083 TeamEx extends Team //5083
{
    fields
    {
        field(90001; "Salesperson Filter 2"; Code[20])
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowFilter;
            TableRelation = "Salesperson/Purchaser";
        }
    }

}
tableextension 92084 TeamSalesperson extends "Team Salesperson" //5084
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92092 OpportunityEx extends Opportunity //5092
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92093 OpportunityEntryEx extends "Opportunity Entry" //5093
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92096 SegmentWizardFilterEx extends "Segment Wizard Filter" //5096
{
    fields
    {
        field(90001; "Salesperson Filter 2"; Code[20])
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowFilter;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92102 RMMatrixManagementEx extends "RM Matrix Management" //5102
{
    fields
    {
        field(90001; "Salesperson Filter 2"; Code[20])
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowFilter;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92107 SalesHeaderArchive extends "Sales Header Archive" //5107
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92108 SalesLineArchive extends "Sales Line Archive" //5108
{
    fields
    {
        field(50000; "Cód. Línea"; code[20])
        {
            DataClassification = ToBeClassified;
            //EX-JVN: Código único de línea, importado de WORKSPACE.
        }
    }

    var
        myInt: Integer;
}
tableextension 92109 PurchaseHeaderArchiveEx extends "Purchase Header Archive" //5109
{
    fields
    {
        field(90000; "Purchaser Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

}

tableextension 92200 EmployeeEx extends Employee //5200
{
    fields
    {
        field(90000; "Salespers./Purch. Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92201 ValueEntryEx extends "Value Entry" // 5802
{
    fields
    {
        field(90000; "Salespers./Purch. Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92202 ServiceHeaderEx extends "Service Header" //5900
{
    fields
    {
        field(50600; "SII Estado documento"; Option)
        {
            CalcFormula = Lookup("SII- Datos SII Documentos"."Estado documento" WHERE("Tipo documento" = FILTER('Factura'),
                                                                                       "No. documento" = FIELD("No."),
                                                                                       "Origen documento" = FILTER('Emitida')));
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT';
            OptionMembers = " ","Pendiente procesar","Incluido en fichero","Enviado a plataforma",Incidencias,"Obtener de nuevo","Validado AEAT";
        }
        field(50601; "SII Fecha envío a control"; Date)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
        }
        field(50602; "SII Excluir envío"; Boolean)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
        }
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

}
tableextension 92203 ServiceLineEx extends "Service Line" //5902
{
    fields
    {
        // Add changes to table fields here
    }

    //oninsert
    //SIIInsertarDatosMultiple


    procedure SIIInsertarDatosMultiple()
    var
        lRstTblValSII: Record 50600;
    begin
        //SII
        /*
        CASE "Document Type" OF
            "Document Type"::Order:
                lRstTblValSII.InsertarDatosMultiple(10, "Document No.", 1, "VAT Bus. Posting Group", "VAT Prod. Posting Group");
            "Document Type"::Invoice:
                lRstTblValSII.InsertarDatosMultiple(11, "Document No.", 1, "VAT Bus. Posting Group", "VAT Prod. Posting Group");
            "Document Type"::"Credit Memo":
                lRstTblValSII.InsertarDatosMultiple(12, "Document No.", 1, "VAT Bus. Posting Group", "VAT Prod. Posting Group");
        END;
        */
    end;

    var
        myInt: Integer;
}
tableextension 92204 servicecontractHeaderEx extends "Service Contract Header" //5965
{
    fields
    {
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92205 FiledServiceContractHeader extends "Filed Service Contract Header" //5970
{
    fields
    {
        // Add changes to table fields here
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92206 ServiceShipmentHeaderEx extends "Service Shipment Header" // 5990
{
    fields
    {
        // Add changes to table fields here
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92207 ServiceInvoiceHeaderEx extends "Service Invoice Header" //5992
{
    fields
    {
        // Add changes to table fields here
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92208 ServiceCrMemoHeaderEx extends "Service Cr.Memo Header" //5994
{
    fields
    {
        // Add changes to table fields here
        field(50600; "SII Estado documento"; Option)
        {
            CalcFormula = Lookup("SII- Datos SII Documentos"."Estado documento" WHERE("Tipo documento" = FILTER('Abono'),
                                                                                       "No. documento" = FIELD("No."),
                                                                                       "Origen documento" = FILTER('Emitida')));
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Pendiente procesar,Incluido en fichero,Enviado a plataforma,Incidencias,Obtener de nuevo,Validado AEAT';
            OptionMembers = " ","Pendiente procesar","Incluido en fichero","Enviado a plataforma",Incidencias,"Obtener de nuevo","Validado AEAT";
        }
        field(50601; "SII Fecha envío a control"; Date)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';

            trigger OnValidate()
            begin
                RstValSII.PermitirModificarDoc("SII Estado documento", TRUE); //EX-SGG 180717

                //030817 EX-JVN SII
                IF "SII Fecha envío a control" < "Posting Date" THEN
                    ERROR('La Fecha envío a control no puede ser inferior a la fecha de registro.');
            end;
        }
        field(50602; "SII Excluir envío"; Boolean)
        {
            Description = 'AHG - SII 30/05/17  Nuevos campos Informativos  y de filtros para tratamient6o de SII';

            trigger OnValidate()
            begin
                RstValSII.PermitirModificarDoc("SII Estado documento", TRUE); //EX-SGG 180717
            end;
        }
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
        RstValSII: Record "SII- Tablas valores SII";
}
tableextension 92209 ReturnShpmentHeader extends "Return Shipment Header" //6650
{
    fields
    {
        // Add changes to table fields here
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}
tableextension 92210 ReturnreceptHeaderEx extends "Return Receipt Header" //6660
{
    fields
    {
        // Add changes to table fields here
        field(90000; "Salesperson Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    var
        myInt: Integer;
}