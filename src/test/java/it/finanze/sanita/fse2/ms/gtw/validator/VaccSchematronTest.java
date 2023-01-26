package it.finanze.sanita.fse2.ms.gtw.validator;

import com.helger.commons.io.resource.inmemory.ReadableResourceInputStream;
import it.finanze.sanita.fse2.ms.gtw.validator.config.Constants;
import it.finanze.sanita.fse2.ms.gtw.validator.dto.SchematronValidationResultDTO;
import it.finanze.sanita.fse2.ms.gtw.validator.utility.FileUtility;
import it.it.finanze.sanita.fse2.ms.gtw.validator.cda.CDAHelper;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.junit.jupiter.api.DisplayName;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.util.Map;

import com.helger.commons.io.resource.IReadableResource;
import com.helger.schematron.xslt.SchematronResourceSCH;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;


@Slf4j
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles(Constants.Profile.TEST)
public  class VaccSchematronTest extends AbstractTest {

    @Test
    @DisplayName("CDA OK")
    public  void cdaOK() throws Exception {
        byte[] schematron = FileUtility.getFileFromInternalResources("Files" + File.separator + "schematronVACC" + File.separator + "schV3" + File.separator +"schematron_certificato_VACC v1.3.sch");

        try (ByteArrayInputStream bytes = new ByteArrayInputStream(schematron)) {
            IReadableResource readableResource = new ReadableResourceInputStream("schematron_certificato_VACC v1.3.sch", bytes);
            SchematronResourceSCH schematronResource = new SchematronResourceSCH(readableResource);
            Map<String,byte[]> cdasOK = getSchematronFiles("src\\test\\resources\\Files\\schematronVACC\\OK");
            for(Map.Entry<String, byte[]> cdaOK : cdasOK.entrySet()) {
               System.out.println("File analyzed :" + cdaOK.getKey());
                SchematronValidationResultDTO resultDTO = CDAHelper.validateXMLViaSchematronFull(schematronResource, cdaOK.getValue());
                assertEquals(0, resultDTO.getFailedAssertions().size());
                assertEquals(true, resultDTO.getValidSchematron());
                assertEquals(true, resultDTO.getValidXML());
            }
        }

    }

    @Test
    @DisplayName("CDA ERROR")
   public void cdaError() throws Exception {
        byte[] schematron = FileUtility.getFileFromInternalResources("Files" + File.separator + "schematronVACC" + File.separator + "schV3" + File.separator +"schematron_certificato_VACC v1.3.sch");

        try (ByteArrayInputStream bytes = new ByteArrayInputStream(schematron)) {
            IReadableResource readableResource = new ReadableResourceInputStream("schematron_certificato_VACC v1.3.sch", bytes);
            SchematronResourceSCH schematronResource = new SchematronResourceSCH(readableResource);

            Map<String,byte[]> cdasKO = getSchematronFiles("src\\test\\resources\\Files\\schematronVACC\\ERROR");
            for(Map.Entry<String, byte[]> cdaKO : cdasKO.entrySet()) {

                SchematronValidationResultDTO resultDTO = CDAHelper.validateXMLViaSchematronFull(schematronResource, cdaKO.getValue());
                boolean result = resultDTO.getFailedAssertions().size()>0;
                assertTrue(result);
            }
        }

    }


    @Test
    @DisplayName("CDA Test")
    public  void cdaTest() throws Exception {
        byte[] schematron = FileUtility.getFileFromInternalResources("Files" + File.separator + "schematronVACC" + File.separator + "schV3" + File.separator +"schematron_certificato_VACC v1.3.sch");

        try (ByteArrayInputStream bytes = new ByteArrayInputStream(schematron)) {
            IReadableResource readableResource = new ReadableResourceInputStream("schematron_certificato_VACC v1.3.sch", bytes);
            SchematronResourceSCH schematronResource = new SchematronResourceSCH(readableResource);
            Map<String,byte[]> cdasOK = getSchematronFiles("C:\\it-fse-gtw-test-container-main\\tests\\files\\xml\\lab.xml");
            for(Map.Entry<String, byte[]> cdaOK : cdasOK.entrySet()) {
                log.info("File analyzed :" + cdaOK.getKey());
                SchematronValidationResultDTO resultDTO = CDAHelper.validateXMLViaSchematronFull(schematronResource, cdaOK.getValue());
                assertEquals(0, resultDTO.getFailedAssertions().size());
                assertEquals(true, resultDTO.getValidSchematron());
                assertEquals(true, resultDTO.getValidXML());
            }
        }

    }
}
