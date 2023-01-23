package it.unidoc.fse.fsebrokergw.data.enums;

public enum InjectionMode {
    A("ATTACHMENT", "CDA iniettato nel PDF come allegato (EmbeddedFiles)"),
    R("RESOURCE", "CDA iniettato nel PDF come risorsa (XFAResources)");

    private final String code;
    private final String description;

    InjectionMode(String code, String description) {
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
