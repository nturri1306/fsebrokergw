package it.unidoc.fse.fsebrokergw.data.enums;

public enum Organizzazione {
    ORG_010("010", "Regione Piemonte"),
    ORG_020("020", "Regione Valle d'Aosta"),
    ORG_030("030", "Regione Lombardia"),
    ORG_041("041", "P.A. Bolzano"),
    ORG_042("042", "P.A. Trento"),
    ORG_050("050", "Regione Veneto"),
    ORG_060("060", "Regione Friuli Venezia Giulia"),
    ORG_070("070", "Regione Liguria"),
    ORG_080("080", "Regione Emilia-Romagna"),
    ORG_090("090", "Regione Toscana"),
    ORG_100("100", "Regione Umbria"),
    ORG_110("110", "Regione Marche"),
    ORG_120("120", "Regione Lazio"),
    ORG_130("130", "Regione Abruzzo"),
    ORG_140("140", "Regione Molise"),
    ORG_150("150", "Regione Campania"),
    ORG_160("160", "Regione Puglia"),
    ORG_170("170", "Regione Basilicata"),
    ORG_180("180", "Regione Calabria"),
    ORG_190("190", "Regione Sicilia"),
    ORG_200("200", "Regione Sardegna"),
    ORG_000("000", "INI o Sistema TS"),
    ORG_001("001", "SASN"),
    ORG_999("999", "MDS");


    private String valore;
    private String descrizione;

    public String getValore() {
        return valore;
    }

    public String getDescrizione() {
        return descrizione;
    }

    Organizzazione(String valore, String descrizione) {

    }

}