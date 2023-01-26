package it.finanze.sanita.fse2.ms.gtw.validator.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class SchematronValidationResultDTO {

    private Boolean validSchematron;

    private Boolean validXML;

    private String message;

    private List<SchematronFailedAssertionDTO> failedAssertions;

}
