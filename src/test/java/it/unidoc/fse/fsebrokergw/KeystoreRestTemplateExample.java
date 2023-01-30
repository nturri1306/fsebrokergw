package it.unidoc.fse.fsebrokergw;

import java.io.FileInputStream;
import java.security.KeyStore;

import javax.net.ssl.SSLContext;

import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

public class KeystoreRestTemplateExample {
    public static void main(String[] args) throws Exception {

        KeyStore keystore = KeyStore.getInstance(KeyStore.getDefaultType());
        char[] password = "nicola".toCharArray();
        FileInputStream fis = new FileInputStream("C:\\Users\\nturri\\.keystore");
        keystore.load(fis, password);
        fis.close();

        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, null, null);

        SSLConnectionSocketFactory sslConFactory = new SSLConnectionSocketFactory(sslContext, new String[] { "TLSv1.2","TLSv1.3" },
                null, SSLConnectionSocketFactory.getDefaultHostnameVerifier());

        CloseableHttpClient httpClient = HttpClients.custom().setSSLSocketFactory(sslConFactory).build();
        ClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory(httpClient);
        RestTemplate restTemplate = new RestTemplate(requestFactory);

        MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();

        headers.add("Authorization", "Bearer ");

        headers.add("Content-Type", "application/json");
        var entity = restTemplate.exchange("https://modipa-val.fse.salute.gov.it/rest/FSE/gateway/v1/status/search/3f3ab67d9395af4", HttpMethod.GET, new HttpEntity<Object>(headers),
                String.class);
    }
}
