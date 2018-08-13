@RestResource(urlMapping='/v1/integrationprocedure/validateReproNoNominated/*')
global with sharing class IFS_S442_validateReproNoNominated {

    @HttpPost
    global static void getData() {
        FromJSON jsonBody;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        res.addHeader('Content-Type', 'application/json');
        try {
            try {
                jsonBody = (fromJSON)JSON.deserialize(req.requestBody.toString(),FromJSON.class);
            }
            catch (Exception e) {
                throw new CalloutException('Error al deserializar los parametros. Verifique la estructura del JSON. Error: ' + e.getMessage());
            }

            system.debug('json:'+ jsonBody);
            checkContrato (jsonBody); //-- Verifico que el contrato (IFS) se cumpla.

            res.statuscode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(getLinea(jsonBody.validateReproNoNominated.nroLinea)));

        }
        catch (CalloutException ce) {
            res.statuscode = 404;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',ce.getMessage())));
        }
        catch(Exception e){
            res.statuscode = 404;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',e.getMessage())));
        }
    }

    private static Map<String,Object> getLinea (String pNroLinea) {
        boolean lvalor = false;
        
        List<Asset> asset = [SELECT Id, MSISDN__c, AccountId FROM Asset WHERE MSISDN__c = :pNroLinea];
        if (asset.size()>0) {
            List<Account> account = [SELECT Id, UnnamedCustomer__c FROM Account WHERE Id = :asset.get(0).AccountId];
            if (account.size()>0){
                if (account.get(0).UnnamedCustomer__c) {
                    lvalor = true;        
                }
            }
        }
        System.debug('Respuesta lvalor:');

        return getRespuestaOk(lvalor);
    }

    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        System.debug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }

    private static Map<String,Object> getRespuestaOk(boolean pValor) {
        Map<String, Object> mapa = new Map<String, Object>();
        Map<String, Object> mapa1 = new Map<String, Object>();
        Integer lresp = (pValor ? 0 : 1);
        mapa1.put('respuesta', lresp);
        mapa.put('validateReproNoNominated', mapa1);
        return mapa;
    }

    /**
     * Objetivo: Verificar que se cumpla el contrato.
     * Si lo cumple termina y sino dispara la excepción: CalloutException.
     */
    private static void checkContrato (FromJSON pJson) {
        System.debug('Entre a checkContrato()');

        if (pJson.validateReproNoNominated == null) {
            System.debug('Error en el JSON');
            throw new CalloutException('Error en la validacion del JSON');
        }

        String nroLinea = pJson.validateReproNoNominated.nroLinea;

        if (String.isBlank(nroLinea)) {
            System.debug('nroLinea nulo o vacio');
            throw new CalloutException('Error en la validacion de los atributos del request. El numero de linea esta vacio');
        }
        if (!nroLinea.isnumeric()){
            System.debug('nroLinea no se corresponde con un valor del tipo numero');
            throw new CalloutException('Error en la validacion de los atributos del request. El numero de linea no se corresponde con un valor del tipo numero');
        }
    }


    public class FromJSON {
        public validateReproNoNominatedClass validateReproNoNominated; 

    }

    public class validateReproNoNominatedClass {
        public String nroLinea; 
    }
}