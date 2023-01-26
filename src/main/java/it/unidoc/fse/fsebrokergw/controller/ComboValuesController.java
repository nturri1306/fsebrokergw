package it.unidoc.fse.fsebrokergw.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


/**
 * @author n.turri
 */
@RestController
public class ComboValuesController {

    @GetMapping("/comboValues")
    public List<String> getComboValues() {
        Map<String, String> schema = SchemaMap.getSchemaMap();
        return new ArrayList<>(schema.keySet());

    }
}
