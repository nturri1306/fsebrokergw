package it.unidoc.fse.fsebrokergw.data.enums;


/**
 * @author n.turri
 */
public enum AttivitaClinica {
    PHR("Personal Health Record Update", "Documenti trasmessi direttamente dal paziente mediante il taccuino personale."),
    CON("Consulto", "Documenti trasmessi per richiedere un consulto."),
    DIS("Discharge", "Documenti trasmessi a seguito di un ricovero."),
    ERP("Erogazione Prestazione Prenotata", "Documenti trasmessi a seguito di una prestazione programmata/prenotata"),
    SistemaTS("Documenti sistema TS", "Documenti resi disponibili nel FSE dal Sistema TS.");

    private String displayName;
    private String descrizioneUtilizzo;

    AttivitaClinica(String displayName, String descrizioneUtilizzo) {
        this.displayName = displayName;
        this.descrizioneUtilizzo = descrizioneUtilizzo;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDescrizioneUtilizzo() {
        return descrizioneUtilizzo;
    }
}