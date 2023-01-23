package it.unidoc.fse.fsebrokergw.service;

import it.unidoc.fse.fsebrokergw.data.DocumentStatus;
import it.unidoc.fse.fsebrokergw.data.response.TransactionData;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

public class GWStatusService extends GWBaseService {


    //status:
    public ResponseEntity<DocumentStatus> getStatus() {
        try {
            return getRestTemplate().getForEntity(urlService + "/status", DocumentStatus.class);
        } catch (Exception ex) {
            return null;
        }
    }

    public ResponseEntity<TransactionData> getWorkflowInstanceId(String workflowInstanceId) {
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("FSE-JWT-Signature", getHashSignature());
        //headers.set("Authorization", "Bearer eyJhbGciOiJSUzI1NiIsInR5c ... iZPqKv3kUbn1qzLg");
        headers.set("accept", MediaType.APPLICATION_JSON_VALUE);

        HttpEntity<String> entity = new HttpEntity<>("parameters", headers);

        ResponseEntity<TransactionData> response = restTemplate.exchange(urlService + "/v1/status/" + workflowInstanceId, HttpMethod.GET, entity, TransactionData.class);

        return response;

    }

}
