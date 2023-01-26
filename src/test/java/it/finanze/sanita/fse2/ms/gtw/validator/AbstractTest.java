package it.finanze.sanita.fse2.ms.gtw.validator;

import static it.finanze.sanita.fse2.ms.gtw.validator.utility.FileUtility.getFileFromInternalResources;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import it.finanze.sanita.fse2.ms.gtw.validator.utility.ProfileUtility;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.context.ServletWebServerApplicationContext;
/*
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;*/

import it.finanze.sanita.fse2.ms.gtw.validator.config.Constants;

/*
import it.finanze.sanita.fse2.ms.gtw.validator.exceptions.BusinessException;
import it.finanze.sanita.fse2.ms.gtw.validator.repository.entity.DictionaryETY;
import it.finanze.sanita.fse2.ms.gtw.validator.repository.entity.SchemaETY;
import it.finanze.sanita.fse2.ms.gtw.validator.repository.entity.SchematronETY;
import it.finanze.sanita.fse2.ms.gtw.validator.repository.entity.TerminologyETY;
import it.finanze.sanita.fse2.ms.gtw.validator.utility.ProfileUtility;

*/
import lombok.extern.slf4j.Slf4j;

@Slf4j
public abstract class AbstractTest {


    @Autowired
    protected ServletWebServerApplicationContext context;

    protected Map<String, byte[]> getSchematronFiles(final String directoryPath) {
        Map<String, byte[]> map = new HashMap<>();
        try {
            File directory = new File(directoryPath);

            //only first level files.
            String[] actualFiles = directory.list();

            if (actualFiles!=null && actualFiles.length>0) {
                for (String namefile : actualFiles) {
                    File file = new File(directoryPath+ File.separator + namefile);
                    map.put(namefile, Files.readAllBytes(file.toPath()));
                }
            }
        } catch(Exception ex) {
            log.error("Error while get schematron files : " + ex);
          //  throw new BusinessException("Error while get schematron files : " + ex);
        }
        return map;
    }



    protected String getTestCda() {
        return new String(getFileFromInternalResources("Files" + File.separator + "cda1.xml"), StandardCharsets.UTF_8);
    }

}
