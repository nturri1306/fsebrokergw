package it.unidoc.fse.fsebrokergw;


import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.boot.context.properties.EnableConfigurationProperties;


@Configuration
@EnableConfigurationProperties
@ConfigurationProperties
public class YAMLConfig {


    private String GWURLSERVICE;
    private String JWT_CERT_VACC_PAYLOAD;
    private String JWT_CERT_VACC_WITH_HASH_PAYLOAD;
    private String JWT_LAB_PAYLOAD;
    private String JWT_LAB_WITH_HASH_PAYLOAD;
    private String JWT_LDO_PAYLOAD;
    private String JWT_PSS_PAYLOAD;
    private String JWT_PSS_WITH_HASH_PAYLOAD;
    private String JWT_RAD_PAYLOAD;
    private String JWT_RAD_WITH_HASH_PAYLOAD;
    private String JWT_RSA_PAYLOAD;
    private String JWT_RSA_WITH_HASH_PAYLOAD;
    private String JWT_SING_VACC_PAYLOAD;
    private String JWT_SING_VACC_WITH_HASH_PAYLOAD;
    private String JWT_VPS_PAYLOAD;
    private String JWT_VPS_WITH_HASH_PAYLOAD;
    private String JWT_LDO_WITH_HASH_PAYLOAD;

    private String PDF_CERT_VACC;
    private String PDF_LAB;
    private String PDF_LOD;
    private String PDF_PSS;
    private String PDF_RAD;
    private String PDF_RSA;
    private String PDF_SING_VACC;
    private String PDF_VPS;

    public String getPDF_CERT_VACC() {
        return PDF_CERT_VACC;
    }

    public void setPDF_CERT_VACC(String PDF_CERT_VACC) {
        this.PDF_CERT_VACC = PDF_CERT_VACC;
    }

    public String getPDF_LAB() {
        return PDF_LAB;
    }

    public void setPDF_LAB(String PDF_LAB) {
        this.PDF_LAB = PDF_LAB;
    }

    public String getPDF_LOD() {
        return PDF_LOD;
    }

    public void setPDF_LOD(String PDF_LOD) {
        this.PDF_LOD = PDF_LOD;
    }

    public String getPDF_PSS() {
        return PDF_PSS;
    }

    public void setPDF_PSS(String PDF_PSS) {
        this.PDF_PSS = PDF_PSS;
    }

    public String getPDF_RAD() {
        return PDF_RAD;
    }

    public void setPDF_RAD(String PDF_RAD) {
        this.PDF_RAD = PDF_RAD;
    }

    public String getPDF_RSA() {
        return PDF_RSA;
    }

    public void setPDF_RSA(String PDF_RSA) {
        this.PDF_RSA = PDF_RSA;
    }

    public String getPDF_SING_VACC() {
        return PDF_SING_VACC;
    }

    public void setPDF_SING_VACC(String PDF_SING_VACC) {
        this.PDF_SING_VACC = PDF_SING_VACC;
    }

    public String getPDF_VPS() {
        return PDF_VPS;
    }

    public void setPDF_VPS(String PDF_VPS) {
        this.PDF_VPS = PDF_VPS;
    }




    public String getGWURLSERVICE() {
        return GWURLSERVICE;
    }

    public void setGWURLSERVICE(String GWURLSERVICE) {
        this.GWURLSERVICE = GWURLSERVICE;
    }


    public String getJWT_LDO_WITH_HASH_PAYLOAD() {
        return JWT_LDO_WITH_HASH_PAYLOAD;
    }

    public void setJWT_LDO_WITH_HASH_PAYLOAD(String JWT_LDO_WITH_HASH_PAYLOAD) {
        this.JWT_LDO_WITH_HASH_PAYLOAD = JWT_LDO_WITH_HASH_PAYLOAD;
    }

    public String getJWT_PSS_PAYLOAD() {
        return JWT_PSS_PAYLOAD;
    }

    public void setJWT_PSS_PAYLOAD(String JWT_PSS_PAYLOAD) {
        this.JWT_PSS_PAYLOAD = JWT_PSS_PAYLOAD;
    }

    public String getJWT_PSS_WITH_HASH_PAYLOAD() {
        return JWT_PSS_WITH_HASH_PAYLOAD;
    }

    public void setJWT_PSS_WITH_HASH_PAYLOAD(String JWT_PSS_WITH_HASH_PAYLOAD) {
        this.JWT_PSS_WITH_HASH_PAYLOAD = JWT_PSS_WITH_HASH_PAYLOAD;
    }

    public String getJWT_RAD_PAYLOAD() {
        return JWT_RAD_PAYLOAD;
    }

    public void setJWT_RAD_PAYLOAD(String JWT_RAD_PAYLOAD) {
        this.JWT_RAD_PAYLOAD = JWT_RAD_PAYLOAD;
    }

    public String getJWT_RAD_WITH_HASH_PAYLOAD() {
        return JWT_RAD_WITH_HASH_PAYLOAD;
    }

    public void setJWT_RAD_WITH_HASH_PAYLOAD(String JWT_RAD_WITH_HASH_PAYLOAD) {
        this.JWT_RAD_WITH_HASH_PAYLOAD = JWT_RAD_WITH_HASH_PAYLOAD;
    }

    public String getJWT_RSA_PAYLOAD() {
        return JWT_RSA_PAYLOAD;
    }

    public void setJWT_RSA_PAYLOAD(String JWT_RSA_PAYLOAD) {
        this.JWT_RSA_PAYLOAD = JWT_RSA_PAYLOAD;
    }

    public String getJWT_RSA_WITH_HASH_PAYLOAD() {
        return JWT_RSA_WITH_HASH_PAYLOAD;
    }

    public void setJWT_RSA_WITH_HASH_PAYLOAD(String JWT_RSA_WITH_HASH_PAYLOAD) {
        this.JWT_RSA_WITH_HASH_PAYLOAD = JWT_RSA_WITH_HASH_PAYLOAD;
    }

    public String getJWT_SING_VACC_PAYLOAD() {
        return JWT_SING_VACC_PAYLOAD;
    }

    public void setJWT_SING_VACC_PAYLOAD(String JWT_SING_VACC_PAYLOAD) {
        this.JWT_SING_VACC_PAYLOAD = JWT_SING_VACC_PAYLOAD;
    }

    public String getJWT_SING_VACC_WITH_HASH_PAYLOAD() {
        return JWT_SING_VACC_WITH_HASH_PAYLOAD;
    }

    public void setJWT_SING_VACC_WITH_HASH_PAYLOAD(String JWT_SING_VACC_WITH_HASH_PAYLOAD) {
        this.JWT_SING_VACC_WITH_HASH_PAYLOAD = JWT_SING_VACC_WITH_HASH_PAYLOAD;
    }

    public String getJWT_CERT_VACC_PAYLOAD() {
        return JWT_CERT_VACC_PAYLOAD;
    }

    public void setJWT_CERT_VACC_PAYLOAD(String JWT_CERT_VACC_PAYLOAD) {
        this.JWT_CERT_VACC_PAYLOAD = JWT_CERT_VACC_PAYLOAD;
    }

    public String getJWT_CERT_VACC_WITH_HASH_PAYLOAD() {
        return JWT_CERT_VACC_WITH_HASH_PAYLOAD;
    }

    public void setJWT_CERT_VACC_WITH_HASH_PAYLOAD(String JWT_CERT_VACC_WITH_HASH_PAYLOAD) {
        this.JWT_CERT_VACC_WITH_HASH_PAYLOAD = JWT_CERT_VACC_WITH_HASH_PAYLOAD;
    }

    public String getJWT_VPS_PAYLOAD() {
        return JWT_VPS_PAYLOAD;
    }

    public void setJWT_VPS_PAYLOAD(String JWT_VPS_PAYLOAD) {
        this.JWT_VPS_PAYLOAD = JWT_VPS_PAYLOAD;
    }

    public String getJWT_VPS_WITH_HASH_PAYLOAD() {
        return JWT_VPS_WITH_HASH_PAYLOAD;
    }

    public void setJWT_VPS_WITH_HASH_PAYLOAD(String JWT_VPS_WITH_HASH_PAYLOAD) {
        this.JWT_VPS_WITH_HASH_PAYLOAD = JWT_VPS_WITH_HASH_PAYLOAD;
    }


    public String getJWT_LDO_PAYLOAD() {
        return JWT_LDO_PAYLOAD;
    }

    public void setJWT_LDO_PAYLOAD(String JWT_LDO_PAYLOAD) {
        this.JWT_LDO_PAYLOAD = JWT_LDO_PAYLOAD;
    }


    public String getJWT_LAB_WITH_HASH_PAYLOAD() {
        return JWT_LAB_WITH_HASH_PAYLOAD;
    }

    public void setJWT_LAB_WITH_HASH_PAYLOAD(String JWT_LAB_WITH_HASH_PAYLOAD) {
        this.JWT_LAB_WITH_HASH_PAYLOAD = JWT_LAB_WITH_HASH_PAYLOAD;
    }

    public String getJWT_LAB_PAYLOAD() {
        return JWT_LAB_PAYLOAD;
    }

    public void setJWT_LAB_PAYLOAD(String JWT_LAB_PAYLOAD) {
        this.JWT_LAB_PAYLOAD = JWT_LAB_PAYLOAD;
    }
}
