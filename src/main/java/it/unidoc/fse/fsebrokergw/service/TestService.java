package it.unidoc.fse.fsebrokergw.service;


import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.*;
import java.security.cert.CertificateException;


import com.google.gson.Gson;
import it.unidoc.fse.fsebrokergw.data.HealthData;
import it.unidoc.fse.fsebrokergw.data.response.DocumentSuccessResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.TrustSelfSignedStrategy;

import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContextBuilder;

import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

public class TestService extends  GWBaseService {

    private  String urlValidation ="/v1/documents/validation";
      public ResponseEntity<DocumentSuccessResponse> test(String fileName, HealthData healthData, MediaType mediaType)
              throws KeyStoreException, IOException, CertificateException, NoSuchAlgorithmException, UnrecoverableKeyException, KeyManagementException {

        Gson gson = new Gson();
        Object requestBody = gson.toJson(healthData);

        String certFileName = "c:\\fse2\\certificati\\auth.p12";
        String pass = "csa";
        //String requestBody = "{\"healthDataFormat\": \"CDA\",  \"mode\": \"ATTACHMENT\",  \"activity\": \"VERIFICA\"}";

        KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
        keyStore.load(new FileInputStream(new File(certFileName)), pass.toCharArray());
        SSLConnectionSocketFactory socketFactory = new SSLConnectionSocketFactory(
                new SSLContextBuilder().loadTrustMaterial(null, new TrustSelfSignedStrategy())
                        .loadKeyMaterial(keyStore, pass.toCharArray()).build());


        HttpClient httpClient = HttpClients.custom().setSSLSocketFactory(socketFactory).build();
        ClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory(httpClient);


        RestTemplate restTemplate = new RestTemplate(requestFactory);


        HttpHeaders headers = new HttpHeaders();

        headers.setContentType(mediaType);
        headers.add("Content-Type","multipart/form-data");
        headers.add("Accept", "application/json");
        headers.add("Authorization","Bearer "+ getBearerToken());
        headers.add("FSE-JWT-Signature", getHashSignatureGW());



        MultiValueMap<String, Object> map = new LinkedMultiValueMap<>();
        map.add("requestBody", requestBody.toString());
        map.add("file", new FileSystemResource(new File(fileName)));

        HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(map, headers);

        ResponseEntity<DocumentSuccessResponse> response = restTemplate.postForEntity(urlService + urlValidation, request, DocumentSuccessResponse.class);


        return response;



/*
        ResponseEntity<Object> res = restTemplate.postForEntity(endpoint, entity, Object.class);
//  ResponseEntity<Object> res = restTemplate.exchange(endpoint, HttpMethod.POST, entity, Object.class);

        if (res.getStatusCode().is2xxSuccessful())
            return res.getBody().toString();
        else
            return res.getStatusCode().toString();*/
    }

}
