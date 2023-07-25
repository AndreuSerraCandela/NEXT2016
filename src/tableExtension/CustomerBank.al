/// <summary>
/// TableExtension CustomerBank (ID 9287) extends Record Customer Bank Account.
/// </summary>
tableextension 92287 CustomerBank extends "Customer Bank Account"
{
    fields
    {

        // { 50800;  ;Bank Code           ;Code3         ;CaptionML=[ENU=Bank Code;
        //                                                           ESM=C¢digo de banco;
        //                                                           FRC=Code de la banque;
        //                                                           ENC=Bank Code];
        //                                                Numeric=Yes;
        //                                                Description=EX.REG }
        field(50800; BankCode; Code[3])
        {
            CaptionML = ENU = 'Bank Code', ESM = 'Código de banco', FRC = 'Code de la banque', ENC = 'Bank Code';
            Description = 'EX.REG';
            Numeric = true;
        }
    }
}
tableextension 92288 VendorBank extends "Vendor Bank Account"
{
    fields
    {

        // { 50800;  ;Bank Code           ;Code3         ;CaptionML=[ENU=Bank Code;
        //                                                           ESM=C¢digo de banco;
        //                                                           FRC=Code de la banque;
        //                                                           ENC=Bank Code];
        //                                                Numeric=Yes;
        //                                                Description=EX.REG }
        field(50800; BankCode; Code[3])
        {
            CaptionML = ENU = 'Bank Code', ESM = 'Código de banco', FRC = 'Code de la banque', ENC = 'Bank Code';
            Description = 'EX.REG';
            Numeric = true;
        }
    }
}