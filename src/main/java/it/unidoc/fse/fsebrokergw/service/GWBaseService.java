package it.unidoc.fse.fsebrokergw.service;


import it.unidoc.fse.fsebrokergw.YAMLConfig;
import org.apache.http.client.HttpClient;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContextBuilder;
import org.apache.http.ssl.SSLContexts;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import javax.net.ssl.SSLContext;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URL;
import java.security.KeyStore;
import java.util.ArrayList;
import java.util.List;


/**
 * @author n.turri
 */
public class GWBaseService {

    private String bearerToken;

    private String hashSignature;

    public String _urlService = "http://127.0.0.1:9010";

    public String urlService =  "https://modipa-val.fse.salute.gov.it/govway/rest/in/FSE/gateway";

    //public String urlService =  "http://127.0.0.1:8010/govway/rest/in/FSE/gateway";


    List<MediaType> mediaTypes = new ArrayList<>();


    public void setHashSignature(String hashSignature) {
        this.hashSignature = hashSignature;
    }

    public String getHashSignature() {
        return "FAKE_HEADER." + hashSignature + ".FAKE_SIGNATURE";
    }

    public String getHashSignatureGW() {
        return  hashSignature ;
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

    YAMLConfig yamlConfig;

    public void setYamlConfig(YAMLConfig yamlConfig) {
        this.yamlConfig = yamlConfig;
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
    public RestTemplate getSSLRestTemplate() throws Exception {

        SSLContext sslContext = new SSLContextBuilder()
                .loadTrustMaterial(new URL("file:src/main/resources/auth.p12"), "csa".toCharArray()).build();
        SSLConnectionSocketFactory sslConFactory = new SSLConnectionSocketFactory(sslContext);

        CloseableHttpClient httpClient = HttpClients.custom().setSSLSocketFactory(sslConFactory).build();
        ClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory(httpClient);
        RestTemplate restTemplate = new RestTemplate(requestFactory);

        return restTemplate;

    }

    public RestTemplate getSSLRestTemplate2() throws Exception {


        KeyStore keystore = KeyStore.getInstance(KeyStore.getDefaultType());
        char[] password = "nicola".toCharArray();
        FileInputStream fis = new FileInputStream("C:\\Users\\nturri\\.keystore");
        keystore.load(fis, password);
        fis.close();

        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, null, null);

        SSLConnectionSocketFactory sslConFactory = new SSLConnectionSocketFactory(sslContext, new String[]{"TLSv1.2", "TLSv1.3"},
                null, SSLConnectionSocketFactory.getDefaultHostnameVerifier());

        CloseableHttpClient httpClient = HttpClients.custom().setSSLSocketFactory(sslConFactory).build();
        ClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory(httpClient);
        RestTemplate restTemplate = new RestTemplate(requestFactory);

        return  restTemplate;
    }

    public RestTemplate getSSLRestTemplate3() throws Exception {

        KeyStore keyStore = KeyStore.getInstance("PKCS12");
        InputStream stream = new FileInputStream("C:\\fse2\\certificati\\auth.pfx");
        keyStore.load(stream, "csa".toCharArray());

        SSLContext sslContext = SSLContexts.custom().loadKeyMaterial(keyStore, "csa".toCharArray()).build();
        SSLConnectionSocketFactory sslConFactory = new SSLConnectionSocketFactory(sslContext);

        CloseableHttpClient httpClient = HttpClients.custom().setSSLSocketFactory(sslConFactory).build();
        ClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory(httpClient);
        RestTemplate restTemplate = new RestTemplate(requestFactory);

        return  restTemplate;

    }



}

