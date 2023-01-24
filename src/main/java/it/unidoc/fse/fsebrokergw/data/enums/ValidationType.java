package it.unidoc.fse.fsebrokergw.data.enums;


/**
 * @author n.turri
 */
public enum ValidationType {
    V("VERIFICA", "Attività di validazione"),
    P("VALIDATION", "Attività di validazione finalizzata alla pubblicazione");

    private final String code;
    private final String description;

    ValidationType(String code, String description) {
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
