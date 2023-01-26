package it.finanze.sanita.fse2.ms.gtw.validator.config;


/**
 * Constants application.
 */
public final class Constants {


    public static final class Collections {

        public static final String DICTIONARY = "dictionary";

        public static final String SCHEMA = "schema";

        public static final String SCHEMATRON = "schematron";

        public static final String TERMINOLOGY = "terminology";

        public static final String TRANSFORM = "transform";

        public static final String CODE_SYSTEM= "code_system";


        private Collections() {

        }
    }


    public static final class Profile {

        public static final String TEST = "test";
        public static final String DEV = "dev";
        public static final String DOCKER = "docker";

        public static final String TEST_PREFIX = "test_";

        /**
         * Constructor.
         */
        private Profile() {
            //This method is intentionally left blank.
        }

    }

    public static final class Logs {
        public static final String ERR_NOT_ALL_CODES_FOUND = "Not all codes for system {} are present on Mongo";
        public static final String ERR_VOCABULARY_VALIDATION = "Error while executing validation on vocabularies for system %s";

        private Logs() {}
    }

    public static final class App {
        public static final String SYSTEM_KEY = "system";
        public static final String CODE_KEY = "code";
        public static final String CODE_SYSTEM_KEY = "codeSystem";
        public static final String CODE_SYSTEM_VERSION_KEY = "codeSystemVersion";
        public static final String WHITELIST_KEY = "whitelist";
        public static final String VALUE_KEY = "value";

        private App() {}
    }

    public static final class Config {

        private Config() {}

        public static final String WHOIS_PATH = "/v1/whois";

        public static final String STATUS_PATH = "/status";

        public static final String MOCKED_GATEWAY_NAME = "mocked-gateway";
    }

    /**
     *	Constants.
     */
    private Constants() {

    }
}
