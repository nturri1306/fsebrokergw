package it.unidoc.fse.fsebrokergw.data.enums;


/**
 * @author n.turri
 */
public enum ContestoOperativo {
    TREATMENT("Trattamento di cura ordinario", "Il valore deve essere utilizzato per il servizio di validazione e per i servizi di Creazione e Sostituzione Documento."),
    UPDATE("Invalidamento e aggiornamento di un documento", "Il valore deve essere utilizzato per il servizio di Eliminazione Documento e Aggiornamento Metadati.");

    private String valore;
    private String descrizione;

    ContestoOperativo(String valore, String descrizione) {
        this.valore = valore;
        this.descrizione = descrizione;
    }

    public String getValore() {
        return valore;
    }

    public String getDescrizione() {
        return descrizione;
    }
}
