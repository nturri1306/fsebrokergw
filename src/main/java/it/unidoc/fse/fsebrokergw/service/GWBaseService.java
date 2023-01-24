package it.unidoc.fse.fsebrokergw.service;


import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;


/**
 * @author n.turri
 */
public class GWBaseService {

    private String bearerToken;

    private String hashSignature;

    public String urlService = "http://127.0.0.1:9010";
    List<MediaType> mediaTypes = new ArrayList<>();


    public void setHashSignature(String hashSignature) {
        this.hashSignature = hashSignature;
    }

    public String getHashSignature() {
        return "FAKE_HEADER." + hashSignature + ".FAKE_SIGNATURE";
    }


    public String getBearerToken() {
        return bearerToken;
    }

    public void setBearerToken(String bearerToken) {
        this.bearerToken = bearerToken;
    }

    public String getUrlService() {
        return urlService;
    }

    public void setUrlService(String urlService) {
        this.urlService = urlService;
    }

    public GWBaseService() {
        mediaTypes.add(MediaType.APPLICATION_JSON);
        mediaTypes.add(MediaType.MULTIPART_FORM_DATA);
    }

    public RestTemplate getRestTemplate() {

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getInterceptors().add((request, body, clientHttpRequestExecution) -> {
            HttpHeaders headers = request.getHeaders();
            if (!headers.containsKey("Authorization")) {

                request.getHeaders().add("Authorization", "Bearer " + bearerToken);

                headers.setContentType(MediaType.APPLICATION_JSON);
                headers.setAccept(mediaTypes);

            }
            return clientHttpRequestExecution.execute(request, body);
        });
        return restTemplate;

    }


}
