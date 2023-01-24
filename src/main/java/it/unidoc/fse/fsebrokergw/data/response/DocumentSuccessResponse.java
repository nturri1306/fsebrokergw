package it.unidoc.fse.fsebrokergw.data.response;


/**
 * @author n.turri
 */
public class DocumentSuccessResponse extends DocumentBaseResponse {

    private String traceID;

    private String spanID;


    public String getTraceID() {
        return traceID;
    }

    public void setTraceID(String traceID) {
        this.traceID = traceID;
    }

    public String getSpanID() {
        return spanID;
    }

    public void setSpanID(String spanID) {
        this.spanID = spanID;
    }


}
