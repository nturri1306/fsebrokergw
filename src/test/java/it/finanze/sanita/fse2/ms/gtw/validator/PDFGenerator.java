package it.finanze.sanita.fse2.ms.gtw.validator;


import  it.finanze.sanita.fpm.*;
import org.junit.Test;
import org.junit.jupiter.api.DisplayName;

import java.io.File;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class PDFGenerator {






    @Test
    @DisplayName("GENERATE")
    public  void generate() throws Exception {


       String output = "C:/LOGS/output.pdf";
       String cdaFile ="C:/it-fse-gtw-test-container-main/tests/files/xml/LAB.xml";

       File fileOut = new  File(output);

      if (fileOut.exists())
          fileOut.delete();



        String[] args ={"-c",cdaFile,"-x","-o",output};

        Launcher.main(args);

       assertEquals(fileOut.exists(),true);



    }
}
