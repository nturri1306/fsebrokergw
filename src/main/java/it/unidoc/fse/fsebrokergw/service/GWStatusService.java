package it.unidoc.fse.fsebrokergw.service;

import it.unidoc.fse.fsebrokergw.data.DocumentStatus;
import it.unidoc.fse.fsebrokergw.data.response.TransactionData;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;


/**
 * @author n.turri
 */
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
        //headers.add("FSE-JWT-Signature", getHashSignature());
        headers.set("Authorization", "Bearer "+getBearerToken());
        headers.set("accept", MediaType.APPLICATION_JSON_VALUE);

        HttpEntity<String> entity = new HttpEntity<>("parameters", headers);
        ResponseEntity<TransactionData> response = restTemplate.exchange(urlService + "/v1/status/" + workflowInstanceId, HttpMethod.GET, entity, TransactionData.class);

        return response;

    }

    public ResponseEntity<TransactionData> getStatusTraceId(String traceId) {
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        //headers.add("FSE-JWT-Signature", getHashSignature());
        headers.set("Authorization", "Bearer "+getBearerToken());
        headers.set("accept", MediaType.APPLICATION_JSON_VALUE);

        HttpEntity<String> entity = new HttpEntity<>("parameters", headers);
        ResponseEntity<TransactionData> response = restTemplate.exchange(urlService + "/v1/status/search/" + traceId, HttpMethod.GET, entity, TransactionData.class);

        return response;

    }

}
