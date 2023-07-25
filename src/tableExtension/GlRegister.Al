/// <summary>
/// TableExtension GlRegister (ID 92045) extends Record G/L Register.
/// </summary>
tableextension 92045 GlRegister extends "G/L Register"
{
    fields
    {

        // { 50000;  ;Tipo p¢liza         ;Option        ;FieldClass=FlowField;
        //                                                CalcFormula=Lookup("Source Code"."Tipo poliza" WHERE (Code=FIELD(Source Code)));
        //                                                OptionCaptionML=ESM=" ,Ingresos,Egresos,Diario";
        //                                                OptionString=[ ,Ingresos,Egresos,Diario];
        //                                                Description=EX-SGG 291014 Contabilidad medios electr¢nicos.;
        //                                                Editable=No }
        field(50000; "Tipo póliza"; Enum "Tipo Póliza")
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Source Code"."Tipo póliza" WHERE(Code = FIELD("Source Code")));
            //OptionCaptionML = ESM=" ,Ingresos,Egresos,Diario";
            //OptionString = [ ,Ingresos,Egresos,Diario];
            Description = 'EX-SGG 291014 Contabilidad medios electrónicos.';
            Editable = false;


        }
        // { 50001;  ;Descripci¢n p¢liza  ;Text50        ;FieldClass=FlowField;
        //                                                CalcFormula=Lookup("G/L Entry".Description WHERE (Entry No.=FIELD(From Entry No.)));
        //                                                Description=EX-SGG 291014 Contabilidad medios electr¢nicos.;
        //                                                Editable=No }
        field(50001; "Descripción Póliza"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Entry".Description WHERE("Entry No." = FIELD("From Entry No.")));
            Description = 'EX-SGG 291014 Contabilidad medios electrónicos.';
            Editable = false;
        }
    }
}