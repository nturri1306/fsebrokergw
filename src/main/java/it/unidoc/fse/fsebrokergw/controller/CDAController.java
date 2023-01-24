package it.unidoc.fse.fsebrokergw.controller;

import org.dom4j.Document;
import org.dom4j.io.SAXReader;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.SAXException;

import java.io.IOException;

@Controller
public class CDAController {


    @PostMapping("/validate-cda")
    public @ResponseBody String validateCDA(@RequestParam("cdaFile") MultipartFile cdaFile, Model model) {

        try {
            // Crea un oggetto SAXReader per leggere il file XML
            SAXReader reader = new SAXReader();
/*
            // Legge il file CDA caricato
            Document document = reader.read(cdaFile.getInputStream());

            // Crea un oggetto SchematronValidator per eseguire la validazione
            SchematronValidator validator = new SchematronValidator();

            // Esegue la validazione utilizzando lo schema Schematron specificato
            SchematronOutput output = validator.validate(document, "schema.sch");

            // Verifica se la validazione è stata eseguita con successo
            if (output.isValid()) {
                model.addAttribute("message", "Il file CDA è valido");
            } else {
                model.addAttribute("message", "Il file CDA non è valido");
            }*/
        } catch (Exception e) {
            model.addAttribute("message", "Errore durante la validazione: " + e.getMessage());
        }

        // Restituisce la vista per mostrare il messaggio di risposta
        return "cda-response";
    }
}
