package it.unidoc.fse.fsebrokergw.data.enums;



/**
 * @author n.turri
 */

public enum PracticeSettingCode {

    AD_PSC001("Allergologia"),
    AD_PSC002("Day Hospital"),
    AD_PSC003("Anatomia e Istologia Patologica"),
    AD_PSC005("Angiologia"),
    AD_PSC006("Cardiochirurgia Padiatrica"),
    AD_PSC007("Cardiochirurgia"),
    AD_PSC008("Cardiologia"),
    AD_PSC009("Chirurgia Generale"),
    AD_PSC010("Chirurgia Maxillo-Facciale"),
    AD_PSC011("Chirurgia Pediatrica"),
    AD_PSC012("Chirurgia Plastica"),
    AD_PSC013("Chirurgia Toracica"),
    AD_PSC014("Chirurgia Vascolare"),
    AD_PSC015("Medicina Sportiva"),
    AD_PSC018("Ematologia e Immunoematologia"),
    AD_PSC019("Malattie Endocrine, del Ricambio e della Nutrizione"),
    AD_PSC020("Immunologia"),
    AD_PSC021("Geriatria"),
    AD_PSC024("Malattie Infettive e Tropicali"),
    AD_PSC025("Medicina del Lavoro"),
    AD_PSC026("Medicina Generale"),
    AD_PSC027("Medicina Legale"),
    AD_PSC028("Unita Spinale"),
    AD_PSC029("Nefrologia"),
    AD_PSC030("Neurochirurgia"),
    AD_PSC031("Nido"),
    AD_PSC032("Neurologia"),
    AD_PSC033("Neuropsichiatria Infantile"),
    AD_PSC034("Oculistica"),
    AD_PSC035("Odontoiatria e Stomatologia"),
    AD_PSC036("Ortopedia e Traumatologia"),
    AD_PSC037("Ostetricia e Ginecologia"),
    AD_PSC038("Otorinolaringoiatria"),
    AD_PSC039("Pediatria"),
    AD_PSC040("Psichiatria"),
    AD_PSC042("Tossicologia"),
    AD_PSC043("Urologia"),
    AD_PSC046("Grandi Ustioni Pediatriche"),
    AD_PSC047("Grandi Ustionati"),
    AD_PSC048("Nefrologia (Abilitazione Trapianto Rene)"),
    AD_PSC049("Terapia Intensiva"),
    AD_PSC050("Unità Coronarica"),
    AD_PSC051("Astanteria"),
    AD_PSC052("Dermatologia"),
    AD_PSC054("Emodialisi"),
    AD_PSC055("Farmacologia Clinica"),
    AD_PSC056("Recupero e Riabilitazione Funzionale"),
    AD_PSC057("Fisiopatologia della Riabilitazione Umana"),
    AD_PSC058("Gastroenterologia"),
    AD_PSC060("Lungodegenti"),
    AD_PSC061("Medicina Nucleare"),
    AD_PSC062("Neonatologia"),
    AD_PSC064("Oncologia"),
    AD_PSC065("Oncoematologia Pediatrica"),
    AD_PSC066("Oncoematologia"),
    AD_PSC068("Pneumologia, Fisiopatologia Respiratoria, Tisiologia"),
    AD_PSC069("Radiologia"),
    AD_PSC070("Radioterapia"),
    AD_PSC071("Reumatologia"),
    AD_PSC073("Terapia Intensiva Neonatale"),
    AD_PSC074("Radioterapia Oncologica"),
    AD_PSC075("Neuro-Riabilitazione"),
    AD_PSC076("Neurochirurgia Pediatrica"),
    AD_PSC077("Nefrologia Pediatrica"),
    AD_PSC078("Urologia Pediatrica"),
    AD_PSC082("Anestesia e Rianimazione"),
    AD_PSC097("Detenuti"),
    AD_PSC098("Day Surgery Plurispecialistica"),
    AD_PSC100("Laboratorio Analisi Chimico Cliniche"),
    AD_PSC101("Microbiologia e Virologia"),
    AD_PSC102("Centro Trasfusionale e Immunoematologico"),
    AD_PSC103("Radiodiagnostica"),
    AD_PSC104("Neuroradiologia"),
    AD_PSC106("Pronto Soccorso e OBI"),
    AD_PSC107("Poliambulatorio"),
    AD_PSC109("Centrale Operativa 118"),
    AD_PSC121("Comparti Operatori - Degenza Ordinaria"),
    AD_PSC122("Comparti Operatori - Day Surgery"),
    AD_PSC126("Libera Professione Degenza"),
    AD_PSC127("Hospice Ospedaliero"),
    AD_PSC129("Trapianto Organi e Tessuti"),
    AD_PSC130("Medicina di Base"),
    AD_PSC131("Assistenza Territoriale"),
    AD_PSC199("Raccolta Consenso"),
    AD_PSC999("Altro");

    private String valore;

    public String getValore() {
        return valore;
    }

    PracticeSettingCode(String valore) {
        this.valore =valore;
    }
}

