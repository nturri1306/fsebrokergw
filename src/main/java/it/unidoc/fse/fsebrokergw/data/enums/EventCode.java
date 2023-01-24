package it.unidoc.fse.fsebrokergw.data.enums;


/**
 * @author n.turri
 */

public enum EventCode {

    EventCode_P99("P99","Oscuramento del documento", "Specifica che un assistito ha stabilito di oscurare un documento a tutti i ruoli abilitati all’accesso al FSE."),
    EventCode_J07BX03("J07BX03","Vaccino per Covid-19", "Fornisce indicazione relativamente all’evento vaccino per Covid-19, dettagliando maggiormente il contenuto del metadato typeCode cui è correlato (ad es. scheda della singola vaccinazione). Il codice utilizzato è individuato dalla classificazione ATC."),
    EventCode_LP418019_8("LP418019_8","Tampone antigenico per Covid-19", "Fornisce indicazione relativamente all’evento tampone antigenico per Covid-19, dettagliando maggiormente il contenuto del metadato typeCode cui è correlato (ad es. referto di laboratorio). Il codice utilizzato è individuato dalla codifica LOINC."),
    EventCode_LP417541_2("LP417541_2","Tampone molecolare per Covid-19", "Fornisce indicazione relativamente all’evento tampone molecolare per Covid-19, dettagliando maggiormente il contenuto del metadato typeCode cui è correlato (ad es. referto di laboratorio). Il codice utilizzato è individuato dalla codifica LOINC."),
    EventCode_96118_5("96118_5","Test Sierologico qualitativo", "Fornisce indicazione relativamente all’evento test sierologico qualitativo per Covid-19, dettagliando maggiormente il contenuto del metadato typeCode cui è correlato (ad es. referto di laboratorio). Il codice utilizzato è individuato dalla codifica LOINC."),
    EventCode_94503_0("94503_0","Test Sierologico quantitativo", "Fornisce indicazione relativamente all’evento test sierologico quantitativo per Covid-19, dettagliando maggiormente il contenuto del metadato typeCode cui è correlato (ad es. referto di laboratorio). Il codice utilizzato è individuato dalla codifica LOINC."),
    EventCode_pay("pay","Prescrizione farmaceutica non a carico SSN", "Fornisce indicazione relativamente alla cosiddetta “Ricetta bianca”, consentendo di specificare che il metadato typeCode (57833-6) cui è correlato fa riferimento ad una prescrizione non a carico del SSN. Il codice utilizzato è individuato dal value set http://hl7.org/fhir/ValueSet/coverage-type"),
    EventCode_PUBLICPOL("PUBLICPOL","Prescrizione farmaceutica SSN", "Consente di specificare che il metadato typeCode (57833-6) cui è correlato fa riferimento ad una prescrizione a carico del SSN in maniera totale o parziale. Il codice utilizzato è individuato dal value set http://hl7.org/fhir/ValueSet/coverage-type");



    private  String  codice;
    private String nomeMnemonico;
    private String descrizioneUtilizzo;

    public String getNomeMnemonico() {
        return nomeMnemonico;
    }

    public String getDescrizioneUtilizzo() {
        return descrizioneUtilizzo;
    }


    public String getCodice() {
        return codice;
    }

    EventCode(String codice,String nomeMnemonico, String descrizioneUtilizzo) {
        this.codice=codice;
        this.nomeMnemonico = nomeMnemonico;
        this.descrizioneUtilizzo = descrizioneUtilizzo;
    }


}
