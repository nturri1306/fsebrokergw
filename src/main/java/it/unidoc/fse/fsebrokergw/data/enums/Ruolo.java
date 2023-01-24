package it.unidoc.fse.fsebrokergw.data.enums;


/**
 * @author n.turri
 */
public enum Ruolo {
    AAS("Personale di assistenza ad alta specializzazione", "Medico / Dirigente sanitario"),
    APR("Medico Medicina Generale / Pediatra di Libera Scelta", "Medico Medicina Generale / Pediatra di Libera Scelta"),
    PSS("Professionista del sociale", "Professionista del sociale"),
    INF("Personale infermieristico", "Infermiere o altro Professionista Sanitario"),
    FAR("Farmacista", "Farmacista"),
    OAM("Operatore amministrativo", "Operatore Amministrativo"),
    DRS("Dirigente sanitario", "Medico / Dirigente sanitario"),
    RSA("Medico RSA", "Medico RSA"),
    MRP("Medico Rete di Patologia", "Medico Rete di Patologia"),
    INI("Infrastruttura Nazionale per l’Interoperabilità", "Ruolo di sistema (non indicato nel DPCM perché non rappresenta una professione)"),
    MDS("Ruolo del Ministero della Salute per la gestione del DGC", "Non indicato nel DPCM perché non rappresenta una professione");

    private String valore;
    private String descrizione;

    Ruolo(String valore, String descrizione) {
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
