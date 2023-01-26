package it.unidoc.fse.fsebrokergw;

import java.io.File;
import java.io.IOException;

import javax.xml.transform.stream.StreamSource;

import com.helger.schematron.ISchematronResource;
import com.helger.schematron.xslt.SchematronResourceSCH;

public class SchemaValidator {
    public static void main(String[] args) throws Exception {
        String xmlFile = "path/to/xmlFile.xml";


        File folders = new File("src\\test\\resources\\Files\\schematronVACC\\OK");

        File[] listOfFiles = folders.listFiles();

        String schematronFile = "Files" + File.separator + "schematronVACC" + File.separator + "schV3" + File.separator + "schematron_certificato_VACC v1.3.sch";
        // Crea uno schematron resource
        ISchematronResource aResSCH = SchematronResourceSCH.fromFile(new File(schematronFile));


        if (aResSCH.isValidSchematron()) {


            for (int i = 0; i < listOfFiles.length; i++) {

                // valida xml contro schematron
                boolean bValid = aResSCH.getSchematronValidity(new StreamSource(listOfFiles[i])).isValid();
                if (bValid) {
                    System.out.println("XML file is valid against the schematron.");
                } else {
                    System.out.println("XML file is not valid against the schematron.");
                    //System.out.println(aResSCH.getSchematronValidity(new StreamSource(new File(xmlFile))).getErrorList());
                }


            }
        }
        else{
            System.out.println("schematron non valido");
        }
    }
}
