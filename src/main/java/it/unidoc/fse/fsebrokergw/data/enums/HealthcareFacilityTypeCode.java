package it.unidoc.fse.fsebrokergw.data.enums;


/**
 * @author n.turri
 */
public enum HealthcareFacilityTypeCode {
    Ospedale("Ospedale", "Indica che il documento è stato prodotto in regime di ricovero ospedaliero del paziente."),
    Prevenzione("Prevenzione", "Indica che il documento è stato prodotto a seguito di uno screening o di medicina preventiva."),
    Territorio("Territorio", "Indica che il documento è stato prodotto a seguito di un incontro con uno specialista territoriale (ad es. MMG, PLS, ecc.)."),
    SistemaTS("SistemaTS", "Indica che il documento è gestito e condiviso dal Sistema TS."),
    Cittadino("Cittadino", "Indica che il dato/documento è stato inserito dal cittadino.");

    private String nomeMnemonico;
    private String descrizione;

    HealthcareFacilityTypeCode(String nomeMnemonico, String descrizione) {
        this.nomeMnemonico = nomeMnemonico;
        this.descrizione = descrizione;
    }

    public String getNomeMnemonico() {
        return nomeMnemonico;
    }

    public String getDescrizione() {
        return descrizione;
    }
}
