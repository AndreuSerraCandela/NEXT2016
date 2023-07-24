table 50120 "DIOT Report"
{

    fields
    {
        field(1; Vendor; Code[20])
        {
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Third type"; Code[10])
        {
        }
        field(4; "Operation Type"; Code[10])
        {
        }
        field(5; RFC; Text[30])
        {
        }
        field(6; "Fiscal ID"; Text[30])
        {
        }
        field(7; "Foreing Name"; Text[60])
        {
        }
        field(8; Country; Code[10])
        {
        }
        field(9; Nationality; Text[30])
        {
        }
        field(10; Campo8; Decimal)
        {
        }
        field(11; Campo9; Decimal)
        {
        }
        field(12; Campo10; Decimal)
        {
        }
        field(13; Campo11; Decimal)
        {
        }
        field(14; Campo12; Decimal)
        {
        }
        field(15; Campo13; Decimal)
        {
        }
        field(16; Campo14; Decimal)
        {
        }
        field(17; Campo15; Decimal)
        {
        }
        field(18; Campo16; Decimal)
        {
        }
        field(19; Campo17; Decimal)
        {
        }
        field(20; Campo18; Decimal)
        {
        }
        field(21; Campo19; Decimal)
        {
        }
        field(22; Campo20; Decimal)
        {
        }
        field(23; Campo21; Decimal)
        {
        }
        field(24; Campo22; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; Vendor, "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

