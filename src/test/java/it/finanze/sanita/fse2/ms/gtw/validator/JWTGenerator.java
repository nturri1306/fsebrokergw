package it.finanze.sanita.fse2.ms.gtw.validator;

import it.finanze.sanita.fjm.*;
import org.junit.Test;
import org.junit.jupiter.api.DisplayName;

public class JWTGenerator {

    @Test
    @DisplayName("sign generate")
    public void sign_generate() throws Exception {

        //-d C:/fse2/certificati/sign.json -a sign -p csa -t 100000 -v

        String jsonFile = "C:/fse2/certificati/sign.json";
        String user = "sign";
        String pwd = "csa";

        String[] args = {"-d", jsonFile, "-a", user, "-p", pwd, "-t", "100000", "-v"};

        Launcher.main(args);
    }

    @Test
    @DisplayName("auth  generate")
    public void auth_generate() throws Exception {

        //-d C:/fse2/certificati/sign.json -a sign -p csa -t 100000 -v

        String jsonFile = "C:/fse2/certificati/cert.json";
        String user = "cert";
        String pwd = "csa";

        String[] args = {"-d", jsonFile, "-a", user, "-p", pwd, "-t", "100000", "-v"};

        Launcher.main(args);
    }
}
