package it.unidoc.fse.fsebrokergw.data.response;


import java.util.ArrayList;

public class TransactionData  {

    private String traceID;
    private String spanID;

    ArrayList<DocumentResponse> transactionData = new ArrayList<DocumentResponse>();

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



    public ArrayList<DocumentResponse> getTransactionData() {
        return transactionData;
    }

    public void setTransactionData(ArrayList<DocumentResponse> transactionData) {
        this.transactionData = transactionData;
    }

}
