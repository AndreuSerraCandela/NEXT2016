tableextension 92230 SourceCode extends "Source Code"
{
    fields
    {
        //{ 50000;  ;Tipo poliza         ;Option        ;OptionCaptionML=ESM=" ,Ingresos,Egresos,Diario";
        //                                           OptionString=[ ,Ingresos,Egresos,Diario];
        //                                           Description=EX-SGG 291014 Contabilidad medios electr¢nicos }
        field(50000; "Tipo póliza"; Enum "Tipo póliza")
        {
            //OptionCaptionML=ENU=,ESN=,ESM=Ingresos,Egresos,Diario;
            //OptionString=,Ingresos,Egresos,Diario;
            Description = 'EX-SGG 291014 Contabilidad medios electrónicos';
        }
    }
}