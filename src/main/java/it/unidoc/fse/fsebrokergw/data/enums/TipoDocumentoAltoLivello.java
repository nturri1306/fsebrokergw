package it.unidoc.fse.fsebrokergw.data.enums;


/**
 * @author n.turri
 */

public enum TipoDocumentoAltoLivello {
    WOR("Documento di workflow", "Questa classe di documenti deve essere utilizzata per i documenti di workflow."),
    REF("Referto", "Questa classe di documenti deve essere utilizzata per ogni tipologia di referto."),
    LDO("Lettera di dimissione ospedaliera", "Questa classe di documenti deve essere utilizzata per le lettere di dimissione ospedaliera."),
    RIC("Richiesta", "Questa classe di documenti deve essere utilizzata per ogni tipologia di richiesta (prescrizioni, richieste di consulto, ecc.)."),
    SUM("Sommario", "Questa classe di documenti deve essere utilizzata per ogni tipologia di sommario (ad es. profilo sanitario sintetico)."),
    TAC("Taccuino", "Questa classe deve essere utilizzata per indicare documenti trasmessi nel taccuino dall’assistito."),
    PRS("Prescrizione", "Questa classe specifica che le informazioni riguardano le prescrizioni condivise dal Sistema TS."),
    PRE("Prestazioni", "Questa classe specifica che le informazioni riguardano le prestazioni erogate condivise dal Sistema TS."),
    ESE("Esenzione", "Questa classe indica che le informazioni riguardano le esenzioni."),
    PDC("Piano di cura", "Questa classe specifica che le informazioni riguardano i piani terapeutici condivisi dal Sistema TS."),
    VAC("Vaccino", "Questa classe di documenti deve essere utilizzata per ogni tipologia di vaccino (scheda della singola vaccinazione, certificato vaccinale)."),
    CER("Certificato per DGC", "Questa classe di documenti deve essere utilizzata per i documenti associati al Digital Green Certificate (certificazione verde Covid-19, certificazione di guarigione da Covid-19)."),
    VRB("Verbale", "Questa classe di documenti deve essere utilizzata per ogni tipologia di verbale (ad es. verbale di pronto soccorso).");

    private String nomeMnemonico;
    private String descrizioneUtilizzo;

    TipoDocumentoAltoLivello(String nomeMnemonico, String descrizioneUtilizzo) {
        this.nomeMnemonico = nomeMnemonico;
        this.descrizioneUtilizzo = descrizioneUtilizzo;
    }

    public String getNomeMnemonico() {
        return nomeMnemonico;
    }

    public String getDescrizioneUtilizzo() {
        return descrizioneUtilizzo;
    }
}
