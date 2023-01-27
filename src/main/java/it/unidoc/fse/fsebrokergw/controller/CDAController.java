package it.unidoc.fse.fsebrokergw.controller;

import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.io.resource.inmemory.ReadableResourceInputStream;

import com.helger.schematron.xslt.SchematronResourceSCH;
import it.finanze.sanita.fse2.ms.gtw.validator.dto.SchematronValidationResultDTO;

import it.finanze.sanita.fse2.ms.gtw.validator.utility.FileUtility;
import it.it.finanze.sanita.fse2.ms.gtw.validator.cda.CDAHelper;
import it.unidoc.fse.fsebrokergw.Application;
import it.unidoc.fse.fsebrokergw.YAMLConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;


/**
 * @author n.turri
 */

@Controller
public class CDAController {

    @Autowired
    YAMLConfig yamlConfig;


    @PostMapping("/validate-cda")
    public @ResponseBody String validateCDA(@RequestParam("cdaFile") MultipartFile cdaFile,
                                            @RequestParam("comboValue") String comboValue) throws IOException {


        StringBuffer result = new StringBuffer();

        //String executionPath = System.getProperty("user.dir");

        var schemaValue = SchemaMap.getSchemaMap().get(comboValue);

        File folder = new File(yamlConfig.getSCHEMATRON_PATH()  + File.separator + schemaValue + File.separator + "schV3");

        File[] files = folder.listFiles();

        Path path = Paths.get(files[0].getAbsoluteFile().getPath());

        var schemaName = files[0].getAbsoluteFile().getName();

        byte[] schematron = Files.readAllBytes(path);


        try (ByteArrayInputStream bytes = new ByteArrayInputStream(schematron)) {
            IReadableResource readableResource = new ReadableResourceInputStream(schemaName, bytes);
            SchematronResourceSCH schematronResource = new SchematronResourceSCH(readableResource);

            SchematronValidationResultDTO resultDTO = CDAHelper.validateXMLViaSchematronFull(schematronResource, cdaFile.getBytes());

            if (resultDTO.getFailedAssertions().size() > 0) {

                for (var ass : resultDTO.getFailedAssertions()) {
                    result.append(ass.getText() + "\r\n");
                    result.append("----> "+ ass.getTest() + "\r\n");


                }
            } else {
                if (resultDTO.getValidSchematron()) {
                    result.append("cda valido");
                } else if (resultDTO.getValidXML()) {
                    result.append("cda valido");
                }

                return result.toString();
            }


        } catch (IOException e) {
            return e.getMessage();
        } catch (Exception e) {
            return e.getMessage();
        }


        // Restituisce la vista per mostrare il messaggio di risposta
        return result.toString();
    }
}
