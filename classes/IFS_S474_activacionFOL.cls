@RestResource(urlMapping='/v1/integrationprocedure/Care_activacionFOL/*')
global with sharing class IFS_S474_activacionFOL {

    public static final boolean K_DEBUG_ON = false;
    private static String guId = null;

    @HttpPost
    global static void getData() {
    
        FromJSON jsonBody;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        Map<String, Object> result = new Map<String, Object>();
        res.addHeader('Content-Type', 'application/json');
        String actualizaStat;

        writeLog ('REQ', req.requestBody.toString());

        try {

            jsonBody = (FromJSON)JSON.deserialize(req.requestBody.toString(),FromJSON.class);

            res.statuscode = 200;

            if (string.isBlank(jsonBody.activacionFOL.idCuenta)) {
                throw new FunctionalException('Error: El campo idCuenta es requerido');
            }
            if (string.isBlank(jsonBody.activacionFOL.operacion)) {
                throw new CalloutException('Error: El campo operacion es requerido');
            }
            if (jsonBody.activacionFOL.operacion !='A' && jsonBody.activacionFOL.operacion !='B') {
                throw new FunctionalException('Error: Los valores validos para operacion son A o B');
            }

            if(String.isNotBlank(jsonBody.activacionFOL.fechaDesde) &&  
                !Pattern.matches('\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d', jsonBody.activacionFOL.fechaDesde)){
                throw new CalloutException('Error: El formato de fechaDesde es invalido (yyyy-mm-dd HH:mm:ss)');
            }

            actualizaStat = actualizaOK(jsonBody.activacionFOL.idCuenta, jsonBody.activacionFOL.operacion);

            if (actualizaStat == '1'){
                throw new FunctionalException('Error: FOL ya estaba activado');
            }
            if (actualizaStat == '2'){
                throw new FunctionalException('Error: FOL ya estaba desactivado');
            }
    
            result.put('descResultado','OK');
            result.put('codResultado','0');
            res.responseBody = Blob.valueOf(JSON.serialize(result));
        }
        catch(FunctionalException e){
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',e.getMessage())));
        }
        catch (CalloutException ce) {
            res.statuscode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('400',ce.getMessage())));
        }

        writeLog ('RES', res.statuscode + ';' + EncodingUtil.base64Decode(EncodingUtil.base64Encode(res.responseBody)).toString());
        
    }

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pDatos) {
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            IFS_LogRecord.record(dts, 'SERVICIO', 'S474', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S474', pTipo, guId, '', pDatos);  
        }
    }

    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        printDebug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('message', pDescripcion);
        mapa.put('errorCode', pcodigo);
        lstErrors.add(mapa);
        return lstErrors;   
    }

    public class FromJSON {
        public FromJSON_1 activacionFOL; 
    }
    public class FromJSON_1 {
        public String idCuenta; 
        public String operacion;
        public String fechaDesde;
    }
    static void printDebug(String pMensaje) {
        if (K_DEBUG_ON) {
            System.debug(pMensaje);
        }
    }
   /**
     * @Objetivo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {

    }

    private Static String actualizaOK(String pCuenta, String pOperacion)  {
        String statOk = '0';
            try{

                    printDebug('Cuenta : ' + pCuenta);    

/*                    Account cuenta = [SELECT Id, FOL__c from Account WHERE AccountIntegrationId__c = :pCuenta LIMIT 1];
                    if (pOperacion == 'A') {
                        if (!cuenta.FOL__c){
                            cuenta.FOL__c = true;
                            UPDATE cuenta;
                        } else {
                            statOk = '1';
                        }
                    }
                    else{
                        if (pOperacion == 'B'){
                            if (cuenta.FOL__c){
                                cuenta.FOL__c = false;
                                UPDATE cuenta;
                            }else{
                                statOk = '2';
                            }
                        }
                    }
                printDebug('Select Account : ' + cuenta.Id);
*/
                return statOk; 
            } catch(FunctionalException e){
                    throw new FunctionalException('Error: la cuenta no existe');            
            }
    }

}