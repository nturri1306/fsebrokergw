package it.unidoc.fse.fsebrokergw;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import it.finanze.sanita.fjm.Launcher;
import it.finanze.sanita.fse2.ms.gtw.validator.JWTGenerator;
import it.unidoc.fse.fsebrokergw.YAMLConfig;
import it.unidoc.fse.fsebrokergw.data.DataSign;
import it.unidoc.fse.fsebrokergw.data.HealthData;
import it.unidoc.fse.fsebrokergw.data.HealthDataComplete;
import it.unidoc.fse.fsebrokergw.data.enums.*;
import it.unidoc.fse.fsebrokergw.data.response.*;
import it.unidoc.fse.fsebrokergw.service.GWPublishService;
import it.unidoc.fse.fsebrokergw.service.GWStatusService;
import it.unidoc.fse.fsebrokergw.service.GWValidationService;
import it.unidoc.fse.fsebrokergw.service.TestService;
import net.minidev.json.parser.JSONParser;
import net.minidev.json.parser.ParseException;
import okhttp3.*;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContextBuilder;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import javax.net.ssl.SSLContext;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.security.spec.InvalidKeySpecException;
import java.util.ArrayList;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;


/**
 * @author n.turri
 */
@SpringBootTest
@RunWith(SpringRunner.class)
@ContextConfiguration(classes = YAMLConfig.class)
@TestPropertySource(locations = "classpath:application-test.yml")
public class TestFseBrokerGW {

    @Autowired
    private YAMLConfig yamlConfig;
    GWStatusService gwStatusService;
    GWValidationService gwValidationService;
    GWPublishService gwPublishService;
    private String lastIdentificativoDoc;
    private static String pathPdf;

    public TestFseBrokerGW() {

    }

    @Before
    public void setUp() {
        try {
            String executionPath = System.getProperty("user.dir");

            pathPdf = executionPath + "/src/test/resources/files/pdf";

            String urlService = yamlConfig.getGWURLSERVICE();

            gwStatusService = new GWStatusService();
            gwStatusService.setUrlService(urlService);

            gwValidationService = new GWValidationService();
            gwValidationService.setUrlService(urlService);

            gwPublishService = new GWPublishService();
            gwPublishService.setUrlService(urlService);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void getStatusTraceId() throws Exception {

        String fileJson = getFileDataSign("CREATE");

        JWTGenerator jwtGenerator = new JWTGenerator();
        jwtGenerator.sign_generate(fileJson);


        gwStatusService.setBearerToken(Launcher._jwt);
        gwStatusService.setHashSignature(Launcher._sig);
        gwStatusService.setYamlConfig(yamlConfig);


        var transResponse = gwStatusService.getStatusTraceId("ef285db74658672e");


    }

    @Test
    public void test() throws Exception {


        SSLContext sslContext = new SSLContextBuilder()
                .loadTrustMaterial(new URL("file:src/main/resources/auth.p12"), "csa".toCharArray()).build();
        SSLConnectionSocketFactory sslConFactory = new SSLConnectionSocketFactory(sslContext);

        CloseableHttpClient httpClient = HttpClients.custom().setSSLSocketFactory(sslConFactory).build();
        ClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory(httpClient);
        RestTemplate restTemplate = new RestTemplate(requestFactory);

        MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();
        headers.add("Content-Type", "application/json");
        headers.add("Authorization", "Bearer " + yamlConfig.getJWT_PAYLOAD());
        var entity = restTemplate.exchange(yamlConfig.getGWURLSERVICE() + "/v1/status/search/3f3ab67d9395af4", HttpMethod.GET, new HttpEntity<Object>(headers),
                String.class);

    }

    @Test
    public void testPdf() {
        try {

            TestService testService = new TestService();

            testService.setBearerToken(yamlConfig.getJWT_PAYLOAD());
            testService.setHashSignature(yamlConfig.getJWT_WITH_HASH_PAYLOAD());


            // String pdfFile = pathPdf + File.separator + yamlConfig.getPDF_LAB();

            String pdfFile = "c:\\logs\\output.pdf";

            var response = testService.test(pdfFile, getHealthDataValidationAttachment(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);


        } catch (KeyStoreException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (CertificateException e) {
            throw new RuntimeException(e);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        } catch (UnrecoverableKeyException e) {
            throw new RuntimeException(e);
        } catch (KeyManagementException e) {
            throw new RuntimeException(e);
        }
    }

    private TransactionData getWorkFlowIntanceId(String workFlowIntanceId) throws JsonProcessingException {
        var transResponse = gwStatusService.getWorkflowInstanceId(workFlowIntanceId);
        assertTrue(transResponse.getStatusCode().value() == 200 || transResponse.getStatusCode().value() == 201);
        TransactionData transactionData = transResponse.getBody();
        System.out.println(new ObjectMapper().writeValueAsString(transactionData));
        return transactionData;
    }

    private TransactionData getStatusTraceId(String traceId) throws JsonProcessingException {
        var transResponse = gwStatusService.getStatusTraceId(traceId);
        assertTrue(transResponse.getStatusCode().value() == 200 || transResponse.getStatusCode().value() == 201);
        TransactionData transactionData = transResponse.getBody();
        System.out.println(new ObjectMapper().writeValueAsString(transactionData));
        return transactionData;
    }

    @Test
    public void status() {
        assertEquals(gwStatusService.getStatus().getStatusCode().value(), 200);
    }


    @Test
    public void validationAttachment_CERT_VACC_GW() throws Exception {


        String fileJson = getFileDataSign("CREATE");

        String pdfFile = "C:\\logs\\sing_vacc.pdf";

        JWTGenerator jwtGenerator = new JWTGenerator();
        jwtGenerator.sign_generate_with_hash(fileJson, pdfFile);

        gwValidationService.setBearerToken(Launcher._jwt);
        gwValidationService.setHashSignature(Launcher._sig);
        gwValidationService.setYamlConfig(yamlConfig);

        var response = gwValidationService.validation(pdfFile, getHealthDataValidationAttachment(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(response.getStatusCode().value() == 200 || response.getStatusCode().value() == 201);

        var transactionData = getWorkFlowIntanceId(response.getBody().getWorkflowInstanceId());

        assertTrue(transactionData.getTransactionData().size() > 0);

        transactionData = getStatusTraceId(response.getBody().getTraceID());

        assertTrue(transactionData.getTransactionData().size() > 0);
    }

    @Test
    public void validationAttachment_CERT_VACC() throws JsonProcessingException {

        gwValidationService.setBearerToken(yamlConfig.getJWT_CERT_VACC_PAYLOAD());
        gwValidationService.setHashSignature(yamlConfig.getJWT_CERT_VACC_WITH_HASH_PAYLOAD());
        String pdfFile = pathPdf + File.separator + yamlConfig.getPDF_CERT_VACC();

        var response = gwValidationService.validation(pdfFile, getHealthDataValidationAttachment(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(response.getStatusCode().value() == 200 || response.getStatusCode().value() == 201);

        var transactionData = getWorkFlowIntanceId(response.getBody().getWorkflowInstanceId());

        assertTrue(transactionData.getTransactionData().size() > 0);

        transactionData = getStatusTraceId(response.getBody().getTraceID());

        assertTrue(transactionData.getTransactionData().size() > 0);
    }

    @Test
    public void validationResource_CERT_VACC() throws JsonProcessingException {

        gwValidationService.setBearerToken(yamlConfig.getJWT_CERT_VACC_PAYLOAD());
        gwValidationService.setHashSignature(yamlConfig.getJWT_CERT_VACC_WITH_HASH_PAYLOAD());
        String pdfFile = "C:\\fse2\\output.pdf";

        var response = gwValidationService.validation(pdfFile, getHealthDataValidationResource(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(response.getStatusCode().value() == 200 || response.getStatusCode().value() == 201);

        var transactionData = getWorkFlowIntanceId(response.getBody().getWorkflowInstanceId());

        assertTrue(transactionData.getTransactionData().size() > 0);


    }


    @Test
    public void validationAttachment_LAB() throws JsonProcessingException {

        gwValidationService.setBearerToken(yamlConfig.getJWT_LAB_PAYLOAD());
        gwValidationService.setHashSignature(yamlConfig.getJWT_LAB_WITH_HASH_PAYLOAD());

        String pdfFile = pathPdf + File.separator + yamlConfig.getPDF_LAB();

        var response = gwValidationService.validation(pdfFile, getHealthDataValidationAttachment(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(response.getStatusCode().value() == 200 || response.getStatusCode().value() == 201);

        var transactionData = getWorkFlowIntanceId(response.getBody().getWorkflowInstanceId());

        assertTrue(transactionData.getTransactionData().size() > 0);
    }

    @Test
    public void validationAttachment_RAD() throws JsonProcessingException {

        gwValidationService.setBearerToken(yamlConfig.getJWT_RAD_PAYLOAD());
        gwValidationService.setHashSignature(yamlConfig.getJWT_RAD_WITH_HASH_PAYLOAD());
        String pdfFile = pathPdf + File.separator + yamlConfig.getPDF_RAD();

        var response = gwValidationService.validation(pdfFile, getHealthDataValidationAttachment(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(response.getStatusCode().value() == 200 || response.getStatusCode().value() == 201);

        var transactionData = getWorkFlowIntanceId(response.getBody().getWorkflowInstanceId());

        assertTrue(transactionData.getTransactionData().size() > 0);
    }

    @Test
    public void publishAttachment_CERT_VACC() throws JsonProcessingException {

        gwValidationService.setBearerToken(yamlConfig.getJWT_CERT_VACC_PAYLOAD());
        gwValidationService.setHashSignature(yamlConfig.getJWT_CERT_VACC_WITH_HASH_PAYLOAD());

        gwPublishService.setBearerToken(yamlConfig.getJWT_CERT_VACC_PAYLOAD());
        gwPublishService.setHashSignature(yamlConfig.getJWT_CERT_VACC_WITH_HASH_PAYLOAD());

        String pdfFile = pathPdf + File.separator + yamlConfig.getPDF_CERT_VACC();

        String identificativoDoc = "2.16.840.1.113883.2.9.2.120.4.4^2" + getRandom();

        var validationResponse = gwValidationService.validation(pdfFile, getHealthDataValidationAttachment(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(validationResponse.getStatusCode().value() == 200 || validationResponse.getStatusCode().value() == 201);

        var validationTrans = gwStatusService.getWorkflowInstanceId(validationResponse.getBody().getWorkflowInstanceId());

        assertTrue(validationTrans.getStatusCode().value() == 200 || validationTrans.getStatusCode().value() == 201);


        var healthData = getHealthDataPublish(validationResponse.getBody().getWorkflowInstanceId(), identificativoDoc);

        var publishResponse = gwPublishService.publish(pdfFile, healthData, org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(publishResponse.getStatusCode().value() == 200 || publishResponse.getStatusCode().value() == 201);

        var publishTrans = gwStatusService.getWorkflowInstanceId(publishResponse.getBody().getWorkflowInstanceId());

        TransactionData transactionData = publishTrans.getBody();

        System.out.println(new ObjectMapper().writeValueAsString(transactionData));

        lastIdentificativoDoc = identificativoDoc;

    }

    @Test
    public void updateAttachment_CERT_VACC() throws JsonProcessingException {

        publishAttachment_CERT_VACC();

        gwValidationService.setBearerToken(yamlConfig.getJWT_CERT_VACC_PAYLOAD());
        gwValidationService.setHashSignature(yamlConfig.getJWT_CERT_VACC_WITH_HASH_PAYLOAD());

        gwPublishService.setBearerToken(yamlConfig.getJWT_CERT_VACC_PAYLOAD());
        gwPublishService.setHashSignature(yamlConfig.getJWT_CERT_VACC_WITH_HASH_PAYLOAD());
        String pdfFile = pathPdf + File.separator + yamlConfig.getPDF_CERT_VACC();
        String identificativoDoc = lastIdentificativoDoc;

        var validationResponse = gwValidationService.validation(pdfFile, getHealthDataValidationAttachment(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(validationResponse.getStatusCode().value() == 200 || validationResponse.getStatusCode().value() == 201);


        var validationTrans = gwStatusService.getWorkflowInstanceId(validationResponse.getBody().getWorkflowInstanceId());

        assertTrue(validationTrans.getStatusCode().value() == 200 || validationTrans.getStatusCode().value() == 201);

        var healthData = getHealthDataPublish(validationResponse.getBody().getWorkflowInstanceId(), identificativoDoc);

        var updateResponse = gwPublishService.updateDocument(identificativoDoc, pdfFile, healthData, org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(updateResponse.getStatusCode().value() == 200 || updateResponse.getStatusCode().value() == 201);
    }

    @Test
    public void deleteAttachment_CERT_VACC() throws JsonProcessingException {

        publishAttachment_CERT_VACC();
        String pdfFile = pathPdf + File.separator + yamlConfig.getPDF_CERT_VACC();
        String identificativoDoc = lastIdentificativoDoc;
        var res = gwPublishService.deleteDocument(identificativoDoc);
        assertTrue(res.getStatusCode().value() == 200 || res.getStatusCode().value() == 201);
    }

    public HealthDataComplete getHealthDataPublish(String workflowInstanceId, String identificativoDoc) {
        HealthDataComplete healthData = new HealthDataComplete();

        healthData.setWorkflowInstanceId(workflowInstanceId);
        healthData.setHealthDataFormat(HealthDataFormat.C.getCode());
        healthData.setMode(InjectionMode.A.getCode());
        healthData.setTipologiaStruttura(HealthcareFacilityTypeCode.Ospedale.toString());
        List<String> attiClinici = new ArrayList<>();
        attiClinici.add(EventCode.EventCode_P99.getCodice());
        healthData.setAttiCliniciRegoleAccesso(attiClinici);
        healthData.setIdentificativoDoc(identificativoDoc);
        healthData.setIdentificativoRep("2.16.840.1.113883.2.9.2.120.4.5.1");
        healthData.setTipoDocumentoLivAlto(TipoDocumentoAltoLivello.REF.toString());
        healthData.setAssettoOrganizzativo(PracticeSettingCode.AD_PSC001.toString());
        healthData.setDataInizioPrestazione("20141020110012");
        healthData.setDataFinePrestazione("20141020110012");
        healthData.setTipoAttivitaClinica(AttivitaClinica.CON.toString());
        healthData.setIdentificativoSottomissione("2.16.840.1.113883.2.9.2.120.4.3.489592");
        healthData.setPriorita(false);

        return healthData;

    }

    public HealthData getHealthDataValidationAttachment() {
        HealthData healthDataValidation = new HealthData();
        healthDataValidation.setActivity(ValidationType.P.getCode());
        healthDataValidation.setHealthDataFormat(HealthDataFormat.C.getCode());
        healthDataValidation.setMode(InjectionMode.A.getCode());

        return healthDataValidation;
    }

    public HealthData getHealthDataValidationResource() {
        HealthData healthDataValidation = getHealthDataValidationAttachment();
        healthDataValidation.setMode(InjectionMode.R.getCode());
        return healthDataValidation;
    }

    private int getRandom() {
        int min = 10000; // Minimum value of range
        int max = 30000; // Maximum value of range
        // Generate random int value from min to max
        int random_int = (int) Math.floor(Math.random() * (max - min + 1) + min);
        // Printing the generated random numbers
        return random_int;
    }

    @Test
    public void validationPostman() throws IOException {

        OkHttpClient client = new OkHttpClient().newBuilder()
                .build();
        RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM)
                .addFormDataPart("file", "/C:/it-fse-gtw-test-container-main/tests/files/pdf/CERT_VACC.pdf",
                        RequestBody.create(okhttp3.MediaType.parse("application/octet-stream"), new File("/C:/it-fse-gtw-test-container-main/tests/files/pdf/CERT_VACC.pdf")))
                .addFormDataPart("requestBody", "{\"healthDataFormat\": \"CDA\",  \"mode\": \"ATTACHMENT\",  \"activity\": \"VERIFICA\"}")
                .build();

        Request request = new Request.Builder()
                .url("https://modipa-val.fse.salute.gov.it/govway/rest/in/FSE/gateway/v1/documents/validation")
                .method("POST", body)
                .addHeader("Content-Type", "multipart/form-data")
                .addHeader("Accept", "application/json")
                .addHeader("FSE-JWT-Signature", yamlConfig.getJWT_WITH_HASH_PAYLOAD())
                .addHeader("Authorization", "Bearer " + yamlConfig.getJWT_PAYLOAD())
                .build();


        var response = client.newCall(request).execute();

        assertTrue(response.code() == 200 || response.code() == 201);


    }

    /*
    * {
    "alg":"rs256",
    "typ":"jwt",
	"sub": "PROVAX00X00X000Y^^^&2.16.840.1.113883.2.9.4.3.2&ISO",
	"subject_role": "AAS",
	"purpose_of_use": "TREATMENT",
	"iss": "S1#111CONSORZIOCSA",
	"subject_application_id": "fsebroker",
	"subject_application_vendor": "fsebroker",
	"subject_application_version": "V.1.0.0",
	"locality": "rome",
	"subject_organization_id": "120",
	"subject_organization": "Regione Lazio",
	"aud" : "https://modipa-val.fse.salute.gov.it/govway/rest/in/FSE/gateway/v1",
	"patient_consent": true,
    "action_id": "CREATE",
	"resource_hl7_type": "('87273-9^^2.16.840.1.113883.6.1')",
	"jti": "3722467",
	"person_id":"RSSMRA75C03F839K^^^&2.16.840.1.113883.2.9.4.3.2&ISO",
	"pem_path": "C:/fse2/certificati/sign.pem",
	"p12_path": "C:/fse2/certificati/sign.p12"
}
    * */

   // @Test
    public String getFileDataSign(String action_id) throws FileNotFoundException, ParseException {


        JSONParser parser = new JSONParser();

        Object obj = parser.parse(new FileReader("C:\\fse2\\certificati\\sign.json"));
        Gson g = new Gson();

        DataSign dataSign = g.fromJson(obj.toString(), DataSign.class);
        dataSign.setJti(String.valueOf(getRandom()));
        dataSign.setAction_id(action_id);
        dataSign.setPerson_id("RSSMRA75C03F839K^^^&2.16.840.1.113883.2.9.4.3.2&ISO");
        dataSign.setResource_hl7_type("('87273-9^^2.16.840.1.113883.6.1')");


        ObjectMapper mapper = new ObjectMapper();

        var fileName = System.getProperty("java.io.tmpdir") + File.separator+ "sign.json";

        if (new File(fileName).exists())
            new File(fileName).delete();


        try {
            mapper.writeValue(new File(fileName), dataSign);
            String jsonString = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(dataSign);

            System.out.println(jsonString);

            return  fileName;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;

    }


}
