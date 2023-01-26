package it.unidoc.fse.fsebrokergw.service;


import com.google.gson.Gson;

import it.unidoc.fse.fsebrokergw.data.response.DocumentBaseResponse;
import it.unidoc.fse.fsebrokergw.data.response.DocumentResponse;
import it.unidoc.fse.fsebrokergw.data.HealthData;

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
public class GWValidationService extends GWBaseService {

   private  String urlValidation ="/v1/documents/validation";

    public ResponseEntity<DocumentSuccessResponse> validation(String fileName, HealthData healthData, MediaType mediaType) {
        try {

            Gson gson = new Gson();
            Object requestBody = gson.toJson(healthData);

            RestTemplate restTemplate = new RestTemplate();

            HttpHeaders headers = new HttpHeaders();

            headers.setContentType(mediaType);
            headers.add("Authorization","Bearer: "+ getBearerToken());
            headers.add("FSE-JWT-Signature", getHashSignatureGW());
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

}
