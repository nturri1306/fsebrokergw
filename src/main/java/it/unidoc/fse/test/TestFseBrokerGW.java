package it.unidoc.fse.test;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import it.unidoc.fse.fsebrokergw.data.*;
import it.unidoc.fse.fsebrokergw.data.enums.*;
import it.unidoc.fse.fsebrokergw.data.response.TransactionData;
import it.unidoc.fse.fsebrokergw.service.*;

import org.testng.annotations.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import static org.testng.Assert.assertEquals;
import static org.testng.Assert.assertTrue;

@SpringBootTest

public class TestFseBrokerGW {

    GWStatusService gwStatusService;
    GWValidationService gwValidationService;
    GWPublishService gwPublishService;

    final Properties properties = new Properties();

     String lastIdentificativoDoc;


    public TestFseBrokerGW() {
        setUp();

        String urlService = properties.getProperty("gw.url.service");

        gwStatusService = new GWStatusService();
        gwStatusService.setUrlService(urlService);

        gwValidationService = new GWValidationService();
        gwValidationService.setUrlService(urlService);

        gwPublishService = new GWPublishService();
        gwPublishService.setUrlService(urlService);
    }

    public void setUp() {


        try {
            String executionPath = System.getProperty("user.dir");
            properties.load(new FileInputStream(executionPath + "/src/main/resources/application.properties"));
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    private TransactionData getWorkFlowIntanceId(String workFlowIntanceId) throws JsonProcessingException {
        var transResponse = gwStatusService.getWorkflowInstanceId(workFlowIntanceId);

        assertTrue(transResponse.getStatusCode().value() == 200 || transResponse.getStatusCode().value() == 201);

        TransactionData transactionData = transResponse.getBody();

        System.out.println(new ObjectMapper().writeValueAsString(transactionData));

        return  transactionData;
    }

    @Test
    public void status() {
        assertEquals(gwStatusService.getStatus().getStatusCode().value(), 200);

    }

    @Test
    public void validationAttachment_CERT_VACC() throws JsonProcessingException {

        gwValidationService.setBearerToken(properties.getProperty("JWT_CERT_VACC_PAYLOAD"));
        gwValidationService.setHashSignature(properties.getProperty("JWT_CERT_VACC_WITH_HASH_PAYLOAD"));
        String pdfFile = "C:\\it-fse-gtw-test-container-main\\tests\\files\\pdf\\CERT_VACC.pdf";

        var response = gwValidationService.validation(pdfFile, getHealthDataValidation(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);


        assertTrue(response.getStatusCode().value() == 200 || response.getStatusCode().value() == 201);

        var transactionData = getWorkFlowIntanceId(response.getBody().getWorkflowInstanceId());

        assertTrue( transactionData.getTransactionData().size()>0);


    }



    @Test
    public void validationAttachment_LAB() throws JsonProcessingException {

        gwValidationService.setBearerToken(properties.getProperty("JWT_LAB_PAYLOAD"));
        gwValidationService.setHashSignature(properties.getProperty("JWT_LAB_WITH_HASH_PAYLOAD"));
        String pdfFile = "C:\\it-fse-gtw-test-container-main\\tests\\files\\pdf\\LAB.pdf";

        var response = gwValidationService.validation(pdfFile, getHealthDataValidation(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(response.getStatusCode().value() == 200 || response.getStatusCode().value() == 201);

       var transactionData = getWorkFlowIntanceId(response.getBody().getWorkflowInstanceId());

        assertTrue( transactionData.getTransactionData().size()>0);


    }

    @Test
    public void validationAttachment_RAD() throws JsonProcessingException {

        gwValidationService.setBearerToken(properties.getProperty("JWT_RAD_PAYLOAD"));
        gwValidationService.setHashSignature(properties.getProperty("JWT_RAD_WITH_HASH_PAYLOAD"));
        String pdfFile = "C:\\it-fse-gtw-test-container-main\\tests\\files\\pdf\\RAD.pdf";

        var response = gwValidationService.validation(pdfFile, getHealthDataValidation(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(response.getStatusCode().value() == 200 || response.getStatusCode().value() == 201);

        var transactionData = getWorkFlowIntanceId(response.getBody().getWorkflowInstanceId());

        assertTrue( transactionData.getTransactionData().size()>0);

    }

    @Test
    public void publishAttachment_CERT_VACC() throws JsonProcessingException {

        gwValidationService.setBearerToken(properties.getProperty("JWT_CERT_VACC_PAYLOAD"));
        gwValidationService.setHashSignature(properties.getProperty("JWT_CERT_VACC_WITH_HASH_PAYLOAD"));
        gwPublishService.setBearerToken(properties.getProperty("JWT_CERT_VACC_PAYLOAD"));
        gwPublishService.setHashSignature(properties.getProperty("JWT_CERT_VACC_WITH_HASH_PAYLOAD"));
        String pdfFile = "C:\\it-fse-gtw-test-container-main\\tests\\files\\pdf\\CERT_VACC.pdf";
        String identificativoDoc = "2.16.840.1.113883.2.9.2.120.4.4^2"+getRandom();

        var validationResponse = gwValidationService.validation(pdfFile, getHealthDataValidation(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(validationResponse.getStatusCode().value() == 200 || validationResponse.getStatusCode().value() == 201);

        var validationTrans = gwStatusService.getWorkflowInstanceId(validationResponse.getBody().getWorkflowInstanceId());

        assertTrue(validationTrans.getStatusCode().value() == 200 || validationTrans.getStatusCode().value() == 201);


       var healthData = getHealthDataPublish(validationResponse.getBody().getWorkflowInstanceId(),identificativoDoc);

        var publishResponse = gwPublishService.publish(pdfFile, healthData, org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(publishResponse.getStatusCode().value() == 200 || publishResponse.getStatusCode().value() == 201);

        var publishTrans = gwStatusService.getWorkflowInstanceId(publishResponse.getBody().getWorkflowInstanceId());

        TransactionData transactionData = publishTrans.getBody();

        System.out.println(new ObjectMapper().writeValueAsString(transactionData));

        lastIdentificativoDoc=identificativoDoc;


    }

    @Test
    public void updateAttachment_CERT_VACC() throws JsonProcessingException {

        publishAttachment_CERT_VACC();

        gwValidationService.setBearerToken(properties.getProperty("JWT_CERT_VACC_PAYLOAD"));
        gwValidationService.setHashSignature(properties.getProperty("JWT_CERT_VACC_WITH_HASH_PAYLOAD"));
        gwPublishService.setBearerToken(properties.getProperty("JWT_CERT_VACC_PAYLOAD"));
        gwPublishService.setHashSignature(properties.getProperty("JWT_CERT_VACC_WITH_HASH_PAYLOAD"));
        String pdfFile = "C:\\it-fse-gtw-test-container-main\\tests\\files\\pdf\\CERT_VACC.pdf";
        String identificativoDoc = lastIdentificativoDoc;

        var validationResponse = gwValidationService.validation(pdfFile, getHealthDataValidation(), org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(validationResponse.getStatusCode().value() == 200 || validationResponse.getStatusCode().value() == 201);


        var validationTrans = gwStatusService.getWorkflowInstanceId(validationResponse.getBody().getWorkflowInstanceId());

        assertTrue(validationTrans.getStatusCode().value() == 200 || validationTrans.getStatusCode().value() == 201);

        var healthData = getHealthDataPublish(validationResponse.getBody().getWorkflowInstanceId(),identificativoDoc);

        var updateResponse = gwPublishService.updateDocument ( identificativoDoc,  pdfFile, healthData, org.springframework.http.MediaType.MULTIPART_FORM_DATA);

        assertTrue(updateResponse.getStatusCode().value() == 200 ||updateResponse.getStatusCode().value() == 201);


    }

    @Test
    public void deleteAttachment_CERT_VACC() throws JsonProcessingException {

        publishAttachment_CERT_VACC();

        String pdfFile = "C:\\it-fse-gtw-test-container-main\\tests\\files\\pdf\\CERT_VACC.pdf";
        String identificativoDoc = lastIdentificativoDoc;

        var res = gwPublishService.deleteDocument(identificativoDoc);

        assertTrue(res.getStatusCode().value() == 200 || res.getStatusCode().value() == 201);



    }

    public  HealthDataComplete getHealthDataPublish(String workflowInstanceId,String identificativoDoc)
    {
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

        return  healthData;

    }

    public  HealthData getHealthDataValidation() {
        HealthData healthDataValidation = new HealthData();
        healthDataValidation.setActivity(ValidationType.P.getCode());
        healthDataValidation.setHealthDataFormat(HealthDataFormat.C.getCode());
        healthDataValidation.setMode(InjectionMode.A.getCode());

        return healthDataValidation;
    }

 /*   @Test
    public void validationPostman() {

        OkHttpClient client = new OkHttpClient().newBuilder().build();
        MediaType mediaType = MediaType.parse("multipart/form-data");
        RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM).addFormDataPart("file", "/C:/it-fse-gtw-test-container-main/tests/files/pdf/CERT_VACC.pdf", RequestBody.create(MediaType.parse("application/octet-stream"), new File("/C:/it-fse-gtw-test-container-main/tests/files/pdf/CERT_VACC.pdf"))).addFormDataPart("requestBody", "{\"activity\":\"VALIDATION\",\"healthDataFormat\":\"CDA\",\"mode\":\"ATTACHMENT\"}").build();
        Request request = new Request.Builder().url("http://127.0.0.1:9010/v1/documents/validation").method("POST", body).addHeader("Content-Type", "multipart/form-data").addHeader("Accept", "application/json")
                //.addHeader("Authorization", "Bearer "+properties.getProperty("JWT_CERT_VACC_PAYLOAD"))
                .addHeader("FSE-JWT-Signature", "FAKE_HEADER." + properties.getProperty("JWT_CERT_VACC_WITH_HASH_PAYLOAD") + ".FAKE_SIGNATURE")


                .build();
        try {
            Response response = client.newCall(request).execute();

            System.out.println(response.body().string());


            assertTrue(response.code() == 200 || response.code() == 201);

        } catch (IOException e) {
            throw new RuntimeException(e);
        }

    }

*/

/*

    @Test
    public void getWorkflow() {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        Request request = new Request.Builder().url("http://127.0.0.1:9010/v1/status/2.16.840.1.113883.2.9.2.120.4.4.46a41df0ab0514f11c0811056832c3225e06c8e11824f27c7e5517ca5cfc57fe.b82b76a7a4^^^^urn:ihe:iti:xdw:2013:workflowInstanceId").addHeader("Accept", "application/json").addHeader("FSE-JWT-Signature", "FAKE_HEADER." + properties.getProperty("JWT_CERT_VACC_WITH_HASH_PAYLOAD") + ".FAKE_SIGNATURE").build();


        try {
            Response response = client.newCall(request).execute();


            assertTrue(response.code() == 200 || response.code() == 201);

            System.out.println(response.body().string());

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }*/

    private int getRandom()
    {
        int min = 10000; // Minimum value of range
        int max = 30000; // Maximum value of range
        // Generate random int value from min to max
        int random_int = (int)Math.floor(Math.random() * (max - min + 1) + min);
        // Printing the generated random numbers
        return random_int;
    }

}
