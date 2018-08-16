@RestResource(urlMapping='/v1/integrationprocedure/CollectionAndBilling_Collection_reconnectService/*')
global with sharing class IFS_S185_reconnectService {

    private static boolean K_DEBUG_ON = true;    //-- Enable / Disable Class Debug Mode.
    private static String guId = null;

    @HttpPost
    global static void getData() {
        FromJSON jsonBody;
        ToJSON tojson;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        Map<String, Object> result = new Map<String, Object>();
        Map<String, Object> result1 = new Map<String, Object>();

        res.addHeader('Content-Type', 'application/json');

        writeLog ('REQ', req.requestBody.toString());

        try {
            res.statuscode = 200;
            jsonBody = (FromJSON)JSON.deserialize(req.requestBody.toString(),FromJSON.class);

            // Validaciones del mensaje
            printDebug('Paso 1: Validaciones del mensaje');
            if (jsonBody.reconnectService.WorkOrderType != '4') {
                throw new CalloutException('Error: El campo WorkOrderType debe tener el valor 4 para rehabilitacion');
            }
            printDebug('Paso 2: Validaciones del mensaje');
            if (jsonBody.reconnectService.OrderObjType != 'S') {
                throw new CalloutException('Error: El campo OrderObjType debe tener el valor S para rehabilitacion');
            }
            printDebug('Paso 3: Validaciones del mensaje');
            if (string.isBlank(jsonBody.reconnectService.OrderObjKey)) {
                throw new CalloutException('Error: El campo OrderObjKey es requerido');
            }
            printDebug('Paso 4: Validaciones del mensaje');
            if (string.isBlank(jsonBody.reconnectService.OrderObjCode)) {
                throw new CalloutException('Error: El campo OrderObjCode es requerido');
            }
            printDebug('Paso 5: Validaciones del mensaje');
            if (!orderParamOk(jsonBody.reconnectService.OrderParam)) {
                throw new CalloutException('Error en la lista de parámetros');
            }
            printDebug('Paso 6: Pasé todas las validaciones');

            insertInBatchQueue(mapeoOM(jsonBody));

            result.put('ResultHeader', mapaRespuesta());
            res.responseBody = Blob.valueOf(JSON.serializePretty(result));

            writeLog ('RES', 200 + ';' + JSON.serializePretty(result));

            printDebug('Paso ultimo: paso');

        }
        catch(Exception e){
            res.statuscode = 417 ;
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
            IFS_LogRecord.record(dts, 'SERVICIO', 'S185', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S185', pTipo, guId, '', pDatos);  
        }
    }


    private static Map<String, Object> mapeoOM (FromJSON pJson) {

        if (pJson == null){
            throw new CalloutException('Error JSON de entrada a OM es nulo');
        }

        FromJSON_to lJson = new FromJSON_to();
        lJson.typeOfJob = 'Rehabilitacion';
      
        lJson.lines.add(pJson.reconnectService);
        String strJson = JSON.serialize(lJson);
        Map<String, Object> result = (Map<String,Object>)JSON.deserializeUntyped(strJson);
        return result;
    }

    private static void insertInBatchQueue(Map<String, Object> pMapa){

        try {
            printDebug('..... instancio la clase xOMBatchLines ()');
            xOMBatchLines.ResultObj result = xOMBatchLines.generateBatchJobsFromJSONUntyped(pMapa);
            if (result.resultCode != 200) {
                throw new CalloutException(result.resultMessage);
            }
        }
        catch (Exception e) {
            throw new CalloutException(e.getMessage());
        }
    }


    private static Boolean orderParamOk(List<FromJSON_2> pOrderParam){
        Boolean opTypeOk;
        Boolean oldStatusOk;
        Boolean newStatusOk;
        Boolean statusTimeOk;

        opTypeOk     = false;
        oldStatusOk  = false;
        newStatusOk  = false;
        statusTimeOk = false;

        if (pOrderParam != null){
            printDebug('OrderParam es nulo');
        }

        Integer i=0;
        for (i=0; i<pOrderParam.size(); i++) {
            String c = pOrderParam[i].Code;
            String d = pOrderParam[i].Value;
            if (c=='OpType' && d=='30'){
                opTypeOk = true;
            }
            if (c=='OldStatus' && (d=='3' || d=='4' || d=='8')){
                oldStatusOk = true;
            }
            if (c=='NewStatus' && (d=='2')){
                newStatusOk = true;
            }
            if (c=='StatusTime' && !string.isBlank(d)){
                statusTimeOk = isDateTime (d);
            }
        }

        return opTypeOk && oldStatusOk && newStatusOk && statusTimeOk;
    }


    /**
     * Valida el formato de la fecha/hora.
     */
    private static Boolean isDateTime (String pDateTime) {
        try {
            if (String.isBlank(pDateTime) || pDateTime.length() != 14) {
                throw new CalloutException('El tamaño del atributo debe ser 14 - Actual: ' + pDateTime.length());
            }
            Integer year  = Integer.valueOf(pDateTime.substring(0,4));
            Integer month = Integer.valueOf(pDateTime.substring(4,6));
            Integer day   = Integer.valueOf(pDateTime.substring(6,8));
            Integer hour  = Integer.valueOf(pDateTime.substring(8,10));
            Integer min   = Integer.valueOf(pDateTime.substring(10,12));
            Integer sec   = Integer.valueOf(pDateTime.substring(12,14));

            Boolean isYearOK = year > 2000 && year < 2050;
            Boolean isBisiesto = isBisiesto(year);
            Boolean isMonthOK = month > 0 && month < 13;
            Boolean isDayOK = (month != 2 && day > 0 && day < 32) || (month == 2 && day > 0 && day < 29) || (month == 2 && isBisiesto && day > 0 && day < 30);
            Boolean isHourOK = hour > 0 && hour < 24;
            Boolean isMinOK = min >= 0 && min < 60;
            Boolean isSecOK = sec >= 0 && sec < 60;
                        
            return isYearOK && isMonthOK && isDayOK && isHourOK && isMinOK && isSecOK;
        }
        catch (Exception e) {
            System.debug('metodo: isDateTime - Error: ' + e.getMessage());
            return false;
        }
    }

    /**
     * Devuelve si el año es bisiesto o no.
     */
    private static Boolean isBisiesto (Integer pAnio) {
        return (Math.mod(pAnio, 4) == 0 && Math.mod(pAnio, 100) != 0) || Math.mod(pAnio, 400) == 0;
    }

    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        printDebug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }

    private static Map<String, Object> mapaRespuesta() {
        Map<String, Object> mapa = new Map<String, Object>();

        mapa.put('ResultDesc','Operation Successfuly');
        mapa.put('ResultCode',0);
        mapa.put('Version','1');

        return mapa;   
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
        public FromJSON_1 reconnectService; 
    }

    public class FromJSON_to {
        public FromJSON_to(){
            lines = new  List<FromJSON_1>();
        }
        public String typeOfJob;
        public List<FromJSON_1> lines; 
    }
    
    public class FromJSON_1 {
        public String WorkOrderType; 
        public String OrderObjType;
        public String OrderObjKey;
        public String OrderObjCode;
        public List<FromJSON_2> OrderParam;
    }

    public class FromJSON_2 {
        public String Code;
        public String Value;
        public List<FromJSON_2> Param;
        public List<FromJSON_4> ObjParam;
    }

    public class FromJSON_4 {
        public String Value;
        public List<FromJSON_2> Param;
        public List<FromJSON_4> ObjParam;
    }

    public class ToJSON {
        public ToJSON_1 ResultHeader;
    }
    public class ToJSON_1 {
        public String Version;
        public String ResultCode;
        public String ResultDesc;
    }
}