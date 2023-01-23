package it.unidoc.fse.fsebrokergw.data.enums;

public enum ActivityType {
    CREATE("CREATE", "Il valore deve essere utilizzato per il servizio di validazione e per il servizio di Pubblicazione Creazione Documento"),
    DELETE("DELETE", "Il valore deve essere utilizzato per il servizio di Eliminazione Documento"),
    UPDATE("UPDATE", "Il valore deve essere utilizzato per il servizio di Aggiornamento Metadati");

    private final String code;
    private final String description;

    ActivityType(String code, String description) {
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
