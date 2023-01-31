package it.unidoc.fse.fsebrokergw.service;


import com.google.gson.Gson;

import it.unidoc.fse.fsebrokergw.data.response.DocumentBaseResponse;
import it.unidoc.fse.fsebrokergw.data.response.DocumentResponse;
import it.unidoc.fse.fsebrokergw.data.HealthData;

import it.unidoc.fse.fsebrokergw.data.response.DocumentSuccessResponse;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.*;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;


import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;
import java.io.File;
import java.io.FileInputStream;
import java.security.KeyStore;


/**
 * @author n.turri
 */
public class GWValidationService extends GWBaseService {

    public static SSLContext createSSLContext() throws Exception {
        // Carica il TrustStore
        KeyStore trustStore = KeyStore.getInstance("JKS");
        FileInputStream fis = new FileInputStream("c:\\fse2\\certificati\\auth.jks");
        trustStore.load(fis, "nicola".toCharArray());
        fis.close();

        // Inizializza il TrustManager
        TrustManagerFactory tmf = TrustManagerFactory.getInstance("SunX509");
        tmf.init(trustStore);

        // Crea il contesto SSL
        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, tmf.getTrustManagers(), null);
        return sslContext;
    }

   private  String urlValidation ="/v1/documents/validation";

    public ResponseEntity<DocumentSuccessResponse> validation(String fileName, HealthData healthData, MediaType mediaType) {
        try {

            Gson gson = new Gson();
            Object requestBody = gson.toJson(healthData);

            RestTemplate restTemplate;

            if (urlService.indexOf("https")<0) {

              restTemplate = new RestTemplate();
            }
            else {
                restTemplate = getSSLRestTemplate3();
            }

            HttpHeaders headers = new HttpHeaders();

            headers.setContentType(mediaType);
            headers.add("Authorization","Bearer "+ getBearerToken());
            headers.add("FSE-JWT-Signature", getHashSignatureGW());
            headers.add("Accept", "application/json");
            headers.add("Content-Type", "multipart/form-data");




            MultiValueMap<String, Object> map = new LinkedMultiValueMap<>();
            map.add("requestBody", requestBody.toString());
            map.add("file", new FileSystemResource(new File(fileName)));

            HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(map, headers);

            ResponseEntity<DocumentSuccessResponse> response = restTemplate.postForEntity(urlService + urlValidation, request, DocumentSuccessResponse.class);


            return response;


        } catch (Exception e) {
            e.printStackTrace();

            return null;
        }



    }



}
