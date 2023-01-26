package it.it.finanze.sanita.fse2.ms.gtw.validator.cda;

import com.helger.schematron.ISchematronResource;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import it.finanze.sanita.fse2.ms.gtw.validator.dto.SchematronFailedAssertionDTO;
import it.finanze.sanita.fse2.ms.gtw.validator.dto.SchematronValidationResultDTO;

import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.List;

import static org.apache.commons.lang3.StringUtils.isEmpty;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import javax.xml.transform.stream.StreamSource;
/*
import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;*/

import com.helger.schematron.ISchematronResource;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
/*
import it.finanze.sanita.fse2.ms.gtw.validator.config.Constants;
import it.finanze.sanita.fse2.ms.gtw.validator.dto.CodeDTO;
import it.finanze.sanita.fse2.ms.gtw.validator.dto.ExtractedInfoDTO;
import it.finanze.sanita.fse2.ms.gtw.validator.dto.SchematronFailedAssertionDTO;
import it.finanze.sanita.fse2.ms.gtw.validator.dto.SchematronValidationResultDTO;
import it.finanze.sanita.fse2.ms.gtw.validator.dto.TerminologyExtractionDTO;
import it.finanze.sanita.fse2.ms.gtw.validator.exceptions.BusinessException;*/
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CDAHelper {

    private CDAHelper(){}
    public static SchematronValidationResultDTO validateXMLViaSchematronFull(ISchematronResource aResSCH , final byte[] xml) throws Exception{
        List<SchematronFailedAssertionDTO> assertions = new ArrayList<>();
        boolean validST = aResSCH.isValidSchematron();
        boolean validXML = true;

        if (validST|| true) {

            SchematronOutputType type = null;
            try (ByteArrayInputStream iStream = new ByteArrayInputStream(xml)){
                type = aResSCH.applySchematronValidationToSVRL(new StreamSource(iStream));
            }
            List<Object> asserts = type.getActivePatternAndFiredRuleAndFailedAssert();

            for (Object object : asserts) {
                if (object instanceof FailedAssert) {
                    validXML = false;
                    FailedAssert failedAssert = (FailedAssert) object;
                    SchematronFailedAssertionDTO failedAssertion = SchematronFailedAssertionDTO.builder().location(failedAssert.getLocation()).test(failedAssert.getTest()).text(failedAssert.getText().getContent().toString()).build();
                    assertions.add(failedAssertion);
                } else if(object instanceof SuccessfulReport) {
                    SuccessfulReport warningAssert = (SuccessfulReport) object;
                    SchematronFailedAssertionDTO warningAssertion = SchematronFailedAssertionDTO.builder().location(warningAssert.getLocation()).test(warningAssert.getTest()).text(warningAssert.getText().getContent().toString()).build();
                    assertions.add(warningAssertion);
                }
            }
        }

        return new SchematronValidationResultDTO(validST, validXML, null, assertions);
    }
}
