package it.unidoc.fse.fsebrokergw.data.response;


public class DocumentResponse extends DocumentBaseResponse {

    private String eventType;
    private String eventDate;
    private String eventStatus;
    private String subject;
    private String organizzazione;
    private String issuer;
    private String expiringDate;
    private String identificativoDocumento;
    private String tipoAttivita;



    public String getIdentificativoDocumento() {
        return identificativoDocumento;
    }

    public void setIdentificativoDocumento(String identificativoDocumento) {
        this.identificativoDocumento = identificativoDocumento;
    }

    public String getTipoAttivita() {
        return tipoAttivita;
    }

    public void setTipoAttivita(String tipoAttivita) {
        this.tipoAttivita = tipoAttivita;
    }


    public String getEventType() {
        return eventType;
    }

    public String getEventDate() {
        return eventDate;
    }

    public String getEventStatus() {
        return eventStatus;
    }

    public String getSubject() {
        return subject;
    }

    public String getOrganizzazione() {
        return organizzazione;
    }


    public String getIssuer() {
        return issuer;
    }

    public String getExpiringDate() {
        return expiringDate;
    }

    // Setter Methods

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public void setEventDate(String eventDate) {
        this.eventDate = eventDate;
    }

    public void setEventStatus(String eventStatus) {
        this.eventStatus = eventStatus;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public void setOrganizzazione(String organizzazione) {
        this.organizzazione = organizzazione;
    }


    public void setIssuer(String issuer) {
        this.issuer = issuer;
    }

    public void setExpiringDate(String expiringDate) {
        this.expiringDate = expiringDate;
    }

}
