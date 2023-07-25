/// <summary>
/// TableExtension Check (ID 90272) extends Record 272.
/// </summary>
tableextension 90272 Check extends 272
{
    fields
    {

        field(50000; "No. Asiento"; Integer)
        {
            ; FieldClass = FlowField;
            CalcFormula = Lookup("Bank Account Ledger Entry"."Transaction No." WHERE("Entry No." = FIELD("Bank Account Ledger Entry No.")));
            Description = 'EX-SGG 291014 Contabilidad medios electrónicos';
            Editable = false;
            ;
        }
        field(50001; "Cód. banco SAT"; Text[3])
        {
            ; FieldClass = FlowField;
            CalcFormula = Lookup("Bank Account"."Código banco SAT" WHERE("No." = FIELD("Bank Account No.")));
            Description = 'EX-SGG 291014 Contabilidad medios electrónicos';
            Editable = false;
            ;
        }
        field(50002; "Cód. cuenta banco"; Text[30])
        {
            ; FieldClass = FlowField;
            CalcFormula = Lookup("Bank Account"."Bank Account No." WHERE("No." = FIELD("Bank Account No.")));
            Description = 'EX-SGG 291014 Contabilidad medios electrónicos';
            Editable = false;
            ;
        }
        field(50003; "Descripción contrapartida"; Text[100])
        {
            ; FieldClass = FlowField;
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Bal. Account No.")));
            Description = 'EX-SGG 291014 Contabilidad medios electrónicos';
            Editable = false;
            ;
        }
        field(50004; "RFC contrapartida"; Text[30])
        {
            ; FieldClass = FlowField;
            CalcFormula = Lookup(Vendor."VAT Registration No." WHERE("No." = FIELD("Bal. Account No.")));
            Description = 'EX-SGG 291014 Contabilidad medios electrónicos';
            Editable = false;
            ;
        }
    }

}

