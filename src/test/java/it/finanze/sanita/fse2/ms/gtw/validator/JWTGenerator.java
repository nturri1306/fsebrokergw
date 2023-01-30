package it.finanze.sanita.fse2.ms.gtw.validator;

import ch.qos.logback.classic.PatternLayout;
import ch.qos.logback.core.FileAppender;
import ch.qos.logback.core.rolling.RollingFileAppender;
import it.finanze.sanita.fjm.*;
import org.junit.Test;
import org.junit.jupiter.api.DisplayName;

import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.logging.Logger;

public class JWTGenerator {

    @Test
    @DisplayName("sign generate")
    public void sign_generate() throws Exception {

        //-d C:/fse2/certificati/sign.json -a sign -p csa -t 100000 -v

        String jsonFile = "C:/fse2/certificati/sign.json";
        String user = "sign";
        String pwd = "csa";

        String[] args = {"-d", jsonFile, "-a", user, "-p", pwd, "-t", "100000", "-v"};

        Launcher.main(args);


    }

    @Test
    @DisplayName("auth  generate")
    public void auth_generate() throws Exception {

        //-d C:/fse2/certificati/sign.json -a sign -p csa -t 100000 -v

        String jsonFile = "C:/fse2/certificati/cert.json";
        String user = "cert";
        String pwd = "csa";

        String[] args = {"-d", jsonFile, "-a", user, "-p", pwd, "-t", "100000", "-v"};

        Launcher.main(args);
    }




    @Test
    @DisplayName("sign generate")
    public void sign_generate_with_hash() throws Exception {

        //-d C:/fse2/certificati/sign.json -a sign -p csa -t 100000 -v

        String jsonFile = "C:/fse2/certificati/sign.json";
        String user = "sign";
        String pwd = "csa";
        String pdfFile="C:\\logs\\sing_vacc.pdf";

        String[] args = {"-d", jsonFile, "-a", user, "-p", pwd, "-t", "100000", "-v","-f",pdfFile };

        Launcher.main(args);


    }


    public void sign_generate_with_hash(  String jsonFile,String pdfFile) throws Exception {

        //-d C:/fse2/certificati/sign.json -a sign -p csa -t 100000 -v

        String user = "sign";
        String pwd = "csa";
        //String pdfFile="C:\\logs\\sing_vacc.pdf";

        String[] args = {"-d", jsonFile, "-a", user, "-p", pwd, "-t", "100000", "-v","-f",pdfFile };

        Launcher.main(args);


    }

    public void sign_generate(  String jsonFile) throws Exception {

        //-d C:/fse2/certificati/sign.json -a sign -p csa -t 100000 -v

        String user = "sign";
        String pwd = "csa";
        //String pdfFile="C:\\logs\\sing_vacc.pdf";

        String[] args = {"-d", jsonFile, "-a", user, "-p", pwd, "-t", "100000", "-v" };

        Launcher.main(args);


    }



    /**
     *
     * "resource_hl7_type": "('11502-2^^2.16.840.1.113883.6.1')", laboratorio
     *
     57833-6 Prescrizione farmaceutica
     60591-5 Profilo Sanitario Sintetico
     11502-2 Referto di Laboratorio
     57829-4 Prescrizione per prodotto o apparecchiature mediche
     34105-7 Lettera di dimissione ospedaliera
     18842-5 Lettera di dimissione non ospedaliera
     59258-4 Verbale di pronto soccorso
     68604-8 Referto di radiologia
     11526-1 Referto di anatomia patologica
     59284-0 Documento dei consensi
     28653-4 Certificato di malattia
     57832-8 Prescrizione diagnostica o specialistica
     29304-3 Erogazione farmaceutica
     11488-4 Referto specialistico
     57827-8 Esenzione da reddito
     81223-0 Erogazione specialistica
     18776-5 Piano terapeutico
     97500-3 Certificazione verde Covid-19 (Digital Green Certificate)1
     87273-9 Scheda singola vaccinazione
     82593-5 Certificato vaccinale
     97499-8 Certificato di guarigione da Covid-19
     */

}
