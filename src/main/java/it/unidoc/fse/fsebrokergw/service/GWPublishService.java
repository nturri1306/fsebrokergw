package it.unidoc.fse.fsebrokergw.service;


import com.google.gson.Gson;
import it.unidoc.fse.fsebrokergw.data.HealthDataComplete;
import it.unidoc.fse.fsebrokergw.data.response.DocumentSuccessResponse;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.io.File;


/**
 * @author n.turri
 */

public class GWPublishService extends GWBaseService {

    private  String urlValidation ="/v1/documents";

    public ResponseEntity<DocumentSuccessResponse> publish(String fileName, HealthDataComplete healthData, MediaType mediaType) {
        try {

            Gson gson = new Gson();
            Object requestBody = gson.toJson(healthData);

            RestTemplate restTemplate = new RestTemplate();

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(mediaType);
            //headers.add("Authorization","Bearer: "+ getBearerToken());
            headers.add("FSE-JWT-Signature", getHashSignature());
            headers.add("Accept", "application/json");

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

    public ResponseEntity<String> deleteDocument(String documentId) {

        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        //headers.add("Authorization","Bearer: "+ getBearerToken());
        headers.add("FSE-JWT-Signature", getHashSignature());
        headers.set("accept", "application/json");

        HttpEntity<Void> request = new HttpEntity<>(headers);

        ResponseEntity<String> response = restTemplate.exchange(urlService + urlValidation + documentId, HttpMethod.DELETE, request, String.class);

        return response;
    }


    public ResponseEntity<String> updateDocument(String documentId, String fileName, HealthDataComplete healthData, MediaType mediaType) {

        RestTemplate restTemplate = new RestTemplate();


        HttpHeaders headers = new HttpHeaders();
        //headers.add("Authorization","Bearer: "+ getBearerToken());
        headers.add("FSE-JWT-Signature", getHashSignature());
        headers.set("accept", "application/json");

        headers.setContentType(mediaType);

        MultiValueMap<String, Object> parts = new LinkedMultiValueMap<>();
        parts.add("requestBody", healthData);
        parts.add("file", new FileSystemResource(fileName));
        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(parts, headers);
        ResponseEntity<String> response = restTemplate.exchange(urlService + urlValidation + documentId, HttpMethod.PUT, requestEntity, String.class);

        return response;

    }


}
