tableextension 92015 GlAccount extends "G/L Account"
{
    fields
    {
        //      { 50000;  ;Retenci¢n           ;Boolean       ;OnValidate=BEGIN
        //                                                             //SF-MLA Comentado ante la posibilidad de existir mas de una cuenta contable de retenci¢n.
        //                                                             {pT_Account.RESET;
        //                                                             pT_Account.SETRANGE(Retenci¢n,TRUE);
        //                                                             pT_Account.SETFILTER(pT_Account."No.",'<>%1',Rec."No.");
        //                                                             IF pT_Account.FINDFIRST THEN BEGIN
        //                                                               ERROR('Ya existe una cuenta con el CheckGLAcc "Retenci¢n" marcado: '+FORMAT(pT_Account."No."));
        //                                                             END;}
        //                                                           END;
        field(50000; Retencion; Boolean)
        {
            // trigger OnValidate()
            // {
            //     var pT_Account = new RecordRef(TableNo, "G/L Account");
            //     pT_Account.RESET();
            //     pT_Account.SETRANGE("Retencion", true);
            //     pT_Account.SETFILTER("No.", "<>%1", Rec."No.");
            //     if (pT_Account.FINDFIRST())
            //     {
            //         throw new Exception("Ya existe una cuenta con el CheckGLAcc \"Retencion\" marcado: " + FORMAT(pT_Account."No."));
            //     }
            // }
        }

        //                                                Description=SF-MLA Llevar retenci¢n a Impresi¢n de facturas Netex }
        // { 50600;  ;Excluir SII         ;Boolean       ;Description=SII }
        field(50600; ExcluirSII; Boolean)
        {
            Description = 'SII';
        }
        // { 50800;  ;C¢digo agrupaci¢n SAT;Code10       ;Description=EX-CONT.MED.ELEC }
        field(50800; "Codigo agrupacion SAT"; Code[10])
        {
            Description = 'EX-CONT.MED.ELEC';
        }
        // { 50801;  ;Subcuenta de        ;Code20        ;TableRelation="G/L Account";
        //                                                Description=EX-CONT.MED.ELECV1.1 }
        field(50801; "Subcuenta de"; Code[20])
        {
            TableRelation = "G/L Account";
            Description = 'EX-CONT.MED.ELECV1.1';
        }
        // { 50802;  ;Naturaleza          ;Option        ;OptionCaptionML=ESM=A,D;
        //                                                OptionString=A,D;
        //                                                Description=EX-CONT.MED.ELECV1.1 }
        field(50802; Naturaleza; Enum Naturaleza)
        {
            Description = 'EX-CONT.MED.ELECV1.1';
        }
        // { 50803;  ;CFDI ClaveProdServ  ;Code20        ;TableRelation="Catalogo CFDI 3.3".Codigo WHERE (Tipo Tabla=CONST(c_ClaveProdServ));
        //                                                Description=EX-FACTE }
        field(50803; "CFDI ClaveProdServ"; Code[20])
        {
            TableRelation = "Catalogo CFDI 3.3".Codigo WHERE("Tipo Tabla" = CONST('c_ClaveProdServ'));
            Description = 'EX-FACTE';
        }

    }
}