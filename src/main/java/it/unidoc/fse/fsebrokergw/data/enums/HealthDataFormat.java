package it.unidoc.fse.fsebrokergw.data.enums;


/**
 * @author n.turri
 */
public enum HealthDataFormat {
    C("CDA", "Clinical Document Architecture");

    private final String code;
    private final String description;

    HealthDataFormat(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public String getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }
}
