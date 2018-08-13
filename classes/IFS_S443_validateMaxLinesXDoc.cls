@RestResource(urlMapping='/v1/integrationprocedure/validateMaxLinesXDoc/*')
global with sharing class IFS_S443_validateMaxLinesXDoc {

    @HttpPost
    global static void getData() {
        FromJSON jsonBody;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        res.addHeader('Content-Type', 'application/json');
        system.debug('Inico de getData');
        try {
            try {
                jsonBody = (fromJSON)JSON.deserialize(req.requestBody.toString(),FromJSON.class);
            }
            catch (Exception e) {
                throw new CalloutException('Error al deserializar los parametros. Verifique la estructura del JSON. Error: ' + e.getMessage());
            }
            system.debug('json:'+ jsonBody);
            checkContrato (jsonBody); //-- Verifico que el contrato (IFS) se cumpla.

            String numeroDocumento = jsonBody.validateMaxLinesXDoc.numeroDocumento;
            String tipoDocumento = ((jsonBody.validateMaxLinesXDoc.tipoDocumento == null) ? '' : jsonBody.validateMaxLinesXDoc.tipoDocumento);


            res.statuscode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(getDatos(numeroDocumento,tipoDocumento,'')));
            
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

    private static Map<String,Object> getDatos (String pnumeroDocumento, String ptipoDocumento, String pgenero) {
        
        System.debug('Validate Lines Qtty');
        //Get the number of lines assigned to a customer

        LinesSetting__c linesSetting = LinesSetting__c.getInstance();
        Integer maxLinesQtty = Integer.valueOf(linesSetting.CantidadDeLineas__c);

        Integer linesQttyAllAssets=0;

        System.debug('Valores Input');
        System.debug('pnumeroDocumento '+ pnumeroDocumento);
        System.debug('ptipoDocumento: ' + ptipoDocumento );
        System.debug('pgenero: '+ pgenero);
        
        if (ptipoDocumento.length() == 0 && pgenero.length() == 0) {
            System.debug('Consulta por '+ pnumeroDocumento);
            linesQttyAllAssets = [SELECT count() FROM Asset 
                                    WHERE Product2.Family = 'Movil' AND Product2.vlocity_cmt__Type__c  = 'Plan Prepago' AND 
                                    Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c = :pnumeroDocumento
                                    And Account.RecordType.Name = 'Consumer'];
        } else {
            if (ptipoDocumento.length() > 0 && pgenero.length() > 0) {
                System.debug('Consulta por numero de Documento: '+ pnumeroDocumento);
                System.debug('tipo de documento: ' + ptipoDocumento );
                System.debug('genero: '+ pgenero);
                linesQttyAllAssets = [SELECT count() FROM Asset 
                                        WHERE Product2.Family = 'Movil' AND Product2.vlocity_cmt__Type__c  = 'Plan Prepago' AND 
                                        Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c = :pnumeroDocumento
                                        AND Account.vlocity_cmt__PrimaryContactId__r.DocumentType__c= :ptipoDocumento 
                                        AND Account.vlocity_cmt__PrimaryContactId__r.Gender__c= : pgenero
                                        And Account.RecordType.Name = 'Consumer'];
            } else if (ptipoDocumento.length() > 0) {
                    System.debug('Consulta por numero de Documento: '+ pnumeroDocumento);
                    System.debug('tipo de documento: ' + ptipoDocumento );
                    linesQttyAllAssets = [SELECT count() FROM Asset 
                                            WHERE Product2.Family = 'Movil' AND Product2.vlocity_cmt__Type__c  = 'Plan Prepago' AND 
                                            Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c = :pnumeroDocumento
                                            AND Account.vlocity_cmt__PrimaryContactId__r.DocumentType__c= :ptipoDocumento 
                                            And Account.RecordType.Name = 'Consumer'];
            } else {
                    System.debug('Consulta por numero de Documento: '+ pnumeroDocumento);
                    System.debug('genero: '+ pgenero);
                    linesQttyAllAssets = [SELECT count() FROM Asset 
                                            WHERE Product2.Family = 'Movil' AND Product2.vlocity_cmt__Type__c  = 'Plan Prepago' AND 
                                            Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c = :pnumeroDocumento
                                            AND Account.vlocity_cmt__PrimaryContactId__r.Gender__c= : pgenero
                                            And Account.RecordType.Name = 'Consumer'];
            }
        }

        return getRespuestaOk(linesQttyAllAssets,maxLinesQtty);
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

    private static Map<String,Object> getRespuestaOk(integer pcantidadContratada, integer pcantOfertaLineas) {
        Map<String, Object> mapa = new Map<String, Object>();
        Map<String, Object> mapa1 = new Map<String, Object>();
        mapa1.put('cantOfertaLineas', pcantOfertaLineas);
        mapa1.put('cantidadContratada', pcantidadContratada);
        mapa.put('validateMaxLinesXDoc', mapa1);
        return mapa;
    }

    /**
     * Objetivo: Verificar que se cumpla el contrato.
     * Si lo cumple termina y sino dispara la excepción: CalloutException.
     */
    private static void checkContrato (FromJSON pJson) {
        System.debug('Entre a checkContrato()');
        final String K_TYPE_OF_DOCUMENT = 'CUIT,CUIL,DNI,LC,LE,CI,PASAPORTE,CIU,PAU';

        if (pJson.validateMaxLinesXDoc == null) {
            System.debug('Error en el JSON');
            throw new CalloutException('Error en la validacion del JSON');
        }

        String numeroDocumento = pJson.validateMaxLinesXDoc.numeroDocumento;
        String tipoDocumento = pJson.validateMaxLinesXDoc.tipoDocumento;

        if (String.isBlank(numeroDocumento)) {
            System.debug('numeroDocumento nulo o vacio');
            throw new CalloutException('Error en la validacion de los atributos del request. El numero de documento esta vacio');
        }
        if (!numeroDocumento.isnumeric()){
            System.debug('numeroDocumento no se corresponde con un valor del tipo numero');
            throw new CalloutException('Error en la validacion de los atributos del request. El numero de documento no se corresponde con un valor del tipo numero');
        }
        if (!(pJson.validateMaxLinesXDoc.tipoDocumento == null)) {
//            if (!String.isBlank(tipoDocumento)) {
                if (K_TYPE_OF_DOCUMENT.indexOf(tipoDocumento)==-1 || String.isBlank(tipoDocumento)) {
                    throw new CalloutException('Request invalido, Tipo de Documento invalido [' + 
                    tipoDocumento + '] - Tipos validos: [' + K_TYPE_OF_DOCUMENT + ']');
                }
//           }
        }

    }

    public class FromJSON {
        public validateMaxLinesXDocClass validateMaxLinesXDoc; 

    }

    public class validateMaxLinesXDocClass {
        public String numeroDocumento; 
        public String tipoDocumento;
    }
}