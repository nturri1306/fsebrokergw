package it.unidoc.fse.fsebrokergw.controller;

import java.util.HashMap;


/**
 * @author n.turri
 */
public class SchemaMap {

    static HashMap<String,String> maps = new HashMap<>();

/*
* R>                                schematronFSE
26/01/2023  10:41    <DIR>          schematronLDO
26/01/2023  10:41    <DIR>          schematronPSS
26/01/2023  10:41    <DIR>          schematronRAD
26/01/2023  10:41    <DIR>          schematronRSA
26/01/2023  10:41    <DIR>          schematronSinVACC
26/01/2023  10:41    <DIR>          schematronVACC
26/01/2023  10:41    <DIR>          schematronVPS
* */
    public static   HashMap<String,String> getSchemaMap()
    {

        maps.put("FSE","schematronFSE");
        maps.put("LDO","schematronLDO");
        maps.put("PSS","schematronPSS");
        maps.put("RAD","schematronRAD");
        maps.put("RSA","schematronRSA");
        maps.put("SINVACC","schematronSinVACC");
        maps.put("VACC","schematronVACC");
        maps.put("VPS","schematronVPS");

        return  maps;
    }


}
