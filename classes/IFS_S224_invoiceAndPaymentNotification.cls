@RestResource(urlMapping='/v1/integrationprocedure/Sales_CollectionAndBilling_invoiceAndPaymentNotification/*')
global with sharing class IFS_S224_invoiceAndPaymentNotification {

    private static boolean K_DEBUG_ON = true;    //-- Enable / Disable Class Debug Mode.
    private static String guId = null;

    @HttpPost
    global static void getData() {
        FromJSON jsonBody;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        Map<String, Object> result = new Map<String, Object>();
        Map<String, Object> result1 = new Map<String, Object>();
        Map<String, Object> result2 = new Map<String, Object>();
        res.addHeader('Content-Type', 'application/json');
        try {
            writeLog ('REQ', req.requestBody.toString());

            res.statuscode = 200;
            jsonBody = (FromJSON)JSON.deserialize(req.requestBody.toString(),FromJSON.class);

            if (string.isBlank(jsonBody.invoiceAndPaymentNotification.SalesOrderId)) {
                throw new CalloutException('Error: El campo salesOrderId es requerido');
            }
            if (string.isBlank(jsonBody.invoiceAndPaymentNotification.Status)) {
                throw new CalloutException('Error: El campo status es requerido');
            }
            result1.put('SalesOrderId',jsonBody.invoiceAndPaymentNotification.SalesOrderId);
            result1.put('Status',jsonBody.invoiceAndPaymentNotification.Status);

            if (!string.isBlank(jsonBody.invoiceAndPaymentNotification.StatusInvoice)) {
                result1.put('StatusInvoice',jsonBody.invoiceAndPaymentNotification.StatusInvoice);
            }
            if (!string.isBlank(jsonBody.invoiceAndPaymentNotification.ReasonCode)) {
                result1.put('ReasonCode',jsonBody.invoiceAndPaymentNotification.ReasonCode);
            }
            if (!string.isBlank(jsonBody.invoiceAndPaymentNotification.ReasonCodeName)) {
                result1.put('ReasonCodeName',jsonBody.invoiceAndPaymentNotification.ReasonCodeName);
            }
            if (!string.isBlank(jsonBody.invoiceAndPaymentNotification.Comments)) {
                result1.put('Comments',jsonBody.invoiceAndPaymentNotification.Comments);
            }
            if (jsonBody.invoiceAndPaymentNotification.TotalInvoiceAmount != null) {
                result1.put('TotalInvoiceAmount',jsonBody.invoiceAndPaymentNotification.TotalInvoiceAmount);
            }
            if (!string.isBlank(jsonBody.invoiceAndPaymentNotification.LegalInvoiceNumber)) {
                result1.put('LegalInvoiceNumber',jsonBody.invoiceAndPaymentNotification.LegalInvoiceNumber);
            }
    
            result2.put('invoiceAndPaymentNotification',result1);    
            result2.put('JSONResponse',JSON.serialize(result2));    
            system.debug((String) result2.get('JSONResponse'));

            if(!Test.isRunningTest()){
                Boolean stat = BillingResponseHandler.callBackService224(null, null, result2);
                if (!stat){
                    throw new CalloutException('Error en la llamada a la clase BillingResponseHandler');
                }
            }
            result.put('resultCode',0);
            result.put('resultDesc','OK');
            res.responseBody = Blob.valueOf(JSON.serialize(result));
            writeLog ('RES', res.statuscode + ';' + JSON.serialize(result));
        }
        catch(Exception e){
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',e.getMessage())));
            writeLog ('RES', res.statuscode + ';' + JSON.serialize(getRespuestaNoOk('417',e.getMessage())));
        }
    }

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pDatos) {
        printDebug('Entre en writeLog - pTipo --> ' + pTipo + ' - pDatos --> ' + pDatos);
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            IFS_LogRecord.record(dts, 'SERVICIO', 'S224', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S224', pTipo, guId, '', pDatos);  
        }

    }


    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        System.debug('Entre a getRespuestaNoOk() ' + pDescripcion);
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }

    /**
     * @Objetivo: Wrapper del System.debug que permite 
     *            setearle si imprime o no.
     */
    private static void printDebug(String pMensaje) {
        if (K_DEBUG_ON) {
            System.debug(pMensaje);
        }
    }

    public class FromJSON {
        public FromJSON_1 invoiceAndPaymentNotification; 
    }
    public class FromJSON_1 {
        public String SalesOrderId; 
        public String Status;
        public String StatusInvoice;
        public String ReasonCode;
        public String Comments;
        public String ReasonCodeName;
        public Decimal TotalInvoiceAmount;
        public String LegalInvoiceNumber;


     
    }
}