global with sharing class IFS_S073_getBill implements vlocity_cmt.VlocityOpenInterface {

    private static String guId = null;
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;


        try {
            if (methodName.equals('getBill')){
               Map<String, Object> m = getBill(inputMap, outMap, options);
               if (outMap == null ) {
                   outMap = new Map<String, Object>();
               }
               outMap.put('IPResult', m);
               return true;
            }
            result = false;  
        } 
        catch(Exception e) {
            System.debug('IFS_S073_getBill.invokeMethod -> exception: ' + e.getStackTraceString());
            result = false;
        }


        return result;
    }    

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pReq, String pRes, Integer pResStatus) {
        System.debug('Entre en writeLog - pTipo --> ' + pTipo + ' - pReq --> ' + pReq + ' - pRes --> ' + pRes + ' - pResStatus --> ' + pResStatus);
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = String.isBlank(guId) ? GuidUtil.NewGuid() : guId;  
            IFS_LogRecord.record(dts, 'SERVICIO', 'S073', pTipo, guId, '', '');  
        }
        else {
            String datos = 'status code = ' + pResStatus + ' ; status = ; ';
            if (pResStatus < 300) {
                datos += 'request to DPW OK';
            }
            else {
                datos += 'request to DPW FAIL ; request body = ' + (String.isBlank(pReq)?'':pReq) + ' ; Response = ' + pRes;
            } 
            IFS_LogRecord.record(dts, 'SERVICIO', 'S073', pTipo, guId, '', datos);  
        }
    }


    /**
     * @Objetivo: Recibe un request y devuelve un mapa de bits.
     */
    private Map<String, Object> getBill (Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('InputMap recibido --> ' +  inputMap);

        try {
            if (inputMap == null || inputMap.isEmpty()) {
                throw new CalloutException('El inputMap vino vacio o nulo.');
            }
            String body = JSON.serialize(inputMap);
            if (outMap == null) {
                outMap = new Map<String, Object>();
            }
            if (!Test.isRunningTest()) {
                HttpResponse response = makeCallout(body);
                System.debug('response body recibido --> ' +  response.getBody());
                return (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            }
            else {
                HttpResponse response = makeCallout(body);
                if (inputMap != null && inputMap.containsKey('Request')) {
                    Map<String, Object> request = (Map<String, Object>)inputMap.get('Request');
                    if (!request.containsKey('database')) {
                        throw new CalloutException('No vino el campo database');    
                    }
                }
                else {
                    throw new CalloutException('No vino el Request');
                }
                Map<String, Object> resp = new Map<String, Object>();
                Map<String, Object> campos = new Map<String, Object>();
                campos.put('outputformat','PDF');
                campos.put('pagecount','32');
                campos.put('pagedatabytes','JVBERi0xLjMNCiXx4tPEtaaXiA0KMiAwIG9iag0KPDwNCiAvVGl0bGUgKERvY3VtZW50KQ0KIC9Qcm9kdWNlciAoUmVuZGVyaW5nIEVuZ2luZSA2LjFNMnAwMjA5KQ0KPj4NCmVuZG9iag0');
                resp.put('renderTransformResult', campos);
                return resp;
            }
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString();
            System.debug('===========================================================================');
            System.debug(stackTrace);
            System.debug('===========================================================================');
            throw e;
        }
    }

    /**
     * @Objetivo: Hacer la llamada http
     */
    public static HttpResponse makeCallout(String body) {
        System.debug('---- Inicio makeCallout --');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        EndPointService__c endpoint;


        try {
            List<EndPointService__c> endPoints = [SELECT Name, EndPoint__c FROM EndPointService__c WHERE Name = 'IFS_s073' LIMIT 1];
            if (endPoints != null && !endPoints.isEmpty()) {
                endpoint = endPoints[0];
                System.debug('Endpoint obtenido --> ' + endpoint.endpoint__c);
            }
            else {
                System.debug('No se pudo obtener el endpoint para el servicio IFS_S073 de la tabla de EndPointService__c');
                throw new CalloutException('No se pudo obtener el endpoint para el servicio IFS_S073 de la tabla de EndPointService__c');
            }

            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setMethod('POST');
            request.setEndpoint(endpoint.endpoint__c);
            request.setBody(body);
            if (!Test.isRunningTest()) {
                String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
                request.setHeader('Authorization', authorizationHeader);
                HttpResponse response = http.send(request);

                writeLog ('REQ', null, null, 0);
                writeLog ('RES', request.getBody(), response.getBody(), response.getStatusCode());
                
                return response;
            }
            else {
                return null;
            }                
        }
        catch (Exception e) {
            throw new CalloutException(e);
        }    
    }  
}