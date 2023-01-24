package it.unidoc.fse.fsebrokergw.data;

import java.util.List;


/**
 * @author n.turri
 */
public class HealthDataComplete {

    private List<String> attiCliniciRegoleAccesso;
    private String identificativoDoc;
    private String identificativoRep;
    private String tipoDocumentoLivAlto;
    private String assettoOrganizzativo;
    private String dataInizioPrestazione;
    private String dataFinePrestazione;
    private String tipoAttivitaClinica;
    private String identificativoSottomissione;
    private boolean priorita;
    private String workflowInstanceId;
    private String healthDataFormat;
    private String mode;
    private String tipologiaStruttura;

    public String getWorkflowInstanceId() {
        return workflowInstanceId;
    }

    public void setWorkflowInstanceId(String workflowInstanceId) {
        this.workflowInstanceId = workflowInstanceId;
    }

    public String getHealthDataFormat() {
        return healthDataFormat;
    }

    public void setHealthDataFormat(String healthDataFormat) {
        this.healthDataFormat = healthDataFormat;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getTipologiaStruttura() {
        return tipologiaStruttura;
    }

    public void setTipologiaStruttura(String tipologiaStruttura) {
        this.tipologiaStruttura = tipologiaStruttura;
    }

    public List<String> getAttiCliniciRegoleAccesso() {
        return attiCliniciRegoleAccesso;
    }

    public void setAttiCliniciRegoleAccesso(List<String> attiCliniciRegoleAccesso) {
        this.attiCliniciRegoleAccesso = attiCliniciRegoleAccesso;
    }

    public String getIdentificativoDoc() {
        return identificativoDoc;
    }

    public void setIdentificativoDoc(String identificativoDoc) {
        this.identificativoDoc = identificativoDoc;
    }

    public String getIdentificativoRep() {
        return identificativoRep;
    }

    public void setIdentificativoRep(String identificativoRep) {
        this.identificativoRep = identificativoRep;
    }

    public String getTipoDocumentoLivAlto() {
        return tipoDocumentoLivAlto;
    }

    public void setTipoDocumentoLivAlto(String tipoDocumentoLivAlto) {
        this.tipoDocumentoLivAlto = tipoDocumentoLivAlto;
    }

    public String getAssettoOrganizzativo() {
        return assettoOrganizzativo;
    }

    public void setAssettoOrganizzativo(String assettoOrganizzativo) {
        this.assettoOrganizzativo = assettoOrganizzativo;
    }

    public String getDataInizioPrestazione() {
        return dataInizioPrestazione;
    }

    public void setDataInizioPrestazione(String dataInizioPrestazione) {
        this.dataInizioPrestazione = dataInizioPrestazione;
    }

    public String getDataFinePrestazione() {
        return dataFinePrestazione;
    }

    public void setDataFinePrestazione(String dataFinePrestazione) {
        this.dataFinePrestazione = dataFinePrestazione;
    }

    public String getTipoAttivitaClinica() {
        return tipoAttivitaClinica;
    }

    public void setTipoAttivitaClinica(String tipoAttivitaClinica) {
        this.tipoAttivitaClinica = tipoAttivitaClinica;
    }

    public String getIdentificativoSottomissione() {
        return identificativoSottomissione;
    }

    public void setIdentificativoSottomissione(String identificativoSottomissione) {
        this.identificativoSottomissione = identificativoSottomissione;
    }

    public boolean isPriorita() {
        return priorita;
    }

    public void setPriorita(boolean priorita) {
        this.priorita = priorita;
    }


}
