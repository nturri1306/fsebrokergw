package it.unidoc.fse.fsebrokergw.service;


import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.*;
import java.security.cert.CertificateException;


import com.google.gson.Gson;
import it.unidoc.fse.fsebrokergw.data.HealthData;
import it.unidoc.fse.fsebrokergw.data.response.DocumentSuccessResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.TrustSelfSignedStrategy;

import org.apache.http.impl.client.CloseableHttpClient;
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

import java.io.FileInputStream;
import java.security.KeyFactory;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.SecureRandom;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Base64;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;

import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;


public class TestService extends GWBaseService {

    private String urlValidation = "/v1/documents/validation";

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
        headers.add("Content-Type", "multipart/form-data");
        headers.add("Accept", "application/json");
        headers.add("Authorization", "Bearer " + getBearerToken());
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

    public void test2() throws IOException, CertificateException, NoSuchAlgorithmException, KeyStoreException, KeyManagementException, InvalidKeySpecException {


        test3();

// Carica i certificati
        InputStream pem = new FileInputStream("C:\\fse2\\certificati\\auth.pem");
        InputStream key = new FileInputStream("C:\\fse2\\certificati\\auth.key");

// Crea un KeyStore
        KeyStore keyStore = KeyStore.getInstance("PKCS12");
        keyStore.load(null, null);

// Carica i certificati nel KeyStore
        CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
        X509Certificate cert = (X509Certificate) certFactory.generateCertificate(pem);

        String encodedString = Base64.getEncoder().encodeToString(key.readAllBytes());
// encoded String contains now the base64 encoded data of the base64 encoded key data

        byte[] decodedString = Base64.getDecoder().decode(encodedString);


        KeyFactory kf = KeyFactory.getInstance("RSA");
        PKCS8EncodedKeySpec keysp = new PKCS8EncodedKeySpec(decodedString);
        PrivateKey clientPrivateKey = kf.generatePrivate(keysp);


        loadTestKey("C:\\fse2\\certificati\\auth.key");


        PrivateKey privateKey = KeyFactory.getInstance("RSA").generatePrivate(new PKCS8EncodedKeySpec(key.readAllBytes()));

        keyStore.setKeyEntry("alias", privateKey, "csa".toCharArray(), new Certificate[]{cert});





// Crea un TrustManagerFactory
        TrustManagerFactory trustManagerFactory = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        trustManagerFactory.init(keyStore);

// Crea un SSLContext
        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, trustManagerFactory.getTrustManagers(), new SecureRandom());


        CloseableHttpClient httpClient = HttpClients.custom()
                .setSSLContext(sslContext)
                .build();

        HttpComponentsClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory(httpClient);



// Crea un RestTemplate
        RestTemplate restTemplate = new RestTemplate(requestFactory);

// Effettua una chiamata GET
        ResponseEntity<String> response = restTemplate.getForEntity(urlService+"/v1/status/search/3f3ab67d9395af47", String.class);

    }

    public  void test3() throws IOException, CertificateException, NoSuchAlgorithmException, KeyStoreException, KeyManagementException {

        SSLContext sslContext = new SSLContextBuilder()
                .loadTrustMaterial(new URL("file:C:\\fse2\\certificati\\auth.p12"), "csa".toCharArray()).build();
        SSLConnectionSocketFactory sslConFactory = new SSLConnectionSocketFactory(sslContext);

        CloseableHttpClient httpClient = HttpClients.custom().setSSLSocketFactory(sslConFactory).build();
        ClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory(httpClient);
        RestTemplate restTemplate = new RestTemplate(requestFactory);



        ResponseEntity<String> response = restTemplate.getForEntity(urlService+"/v1/status/search/3f3ab67d9395af47", String.class);


    }

    public PrivateKey loadTestKey(String fileName) throws NoSuchAlgorithmException, InvalidKeySpecException, IOException {
        PKCS8EncodedKeySpec ks = new PKCS8EncodedKeySpec(Files.readAllBytes(Paths.get(fileName)));
        KeyFactory kf = KeyFactory.getInstance("RSA");
        return kf.generatePrivate(ks);
    }



}
