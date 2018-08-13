@RestResource(urlMapping='/v1/integrationprocedure/CustomerCare_CP_validateCPDiscount/*')
global with sharing class IFS_S195_validateCPData {

    @HttpGet
    global static void getData() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String, Object> result = new Map<String, Object>();
        Map<String, Object> result1 = new Map<String, Object>();
        res.addHeader('Content-Type', 'application/json');
        try {

            res.statuscode = 200;
            String nroLinea = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

            // Validaciones de requeridos
            if (string.isBlank(nroLinea)) {
                throw new CalloutException('Error: El número de línea es requerido');
            }

            result1.put('validateCPData',getDataAsociado(nroLinea));
            res.responseBody = Blob.valueOf(JSON.serialize(result1));

        }
        catch(Exception e){
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',e.getMessage())));
        }
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

    private static ToJSON_1 getDataAsociado(String pNroLinea){
        ToJSON_1 lToJson = new ToJSON_1();
        String lMercado;

        try {
            Asset lAccountId = [SELECT AccountId, Product2Id from Asset WHERE MSISDN__c = :pNroLinea and Network_Status__c = 'Active' LIMIT 1];
            System.debug('Select Asset lAccountId' + lAccountId.AccountId);
        
            if (String.isBlank(lAccountId.AccountId)){
                throw new FunctionalException('Error: No existe la linea');    
            }
        

            try {
                Account cuenta = [SELECT Id, ClubMember__c, PersonalClubCategory__c, vlocity_cmt__AccountPaymentType__c from Account WHERE Id = :lAccountId.AccountId];
                System.debug('Select Account : ' + cuenta.Id);
        
                    if (!string.isBlank(cuenta.Id)){

                if (cuenta.ClubMember__c == true){
                    lToJson.estadoSocio = 'Socio adherido';
                }
                else{
                    lToJson.estadoSocio = 'No Socio';
                }

                
                lToJson.categoriaSocio = cuenta.PersonalClubCategory__c;

                lMercado = getSegmento(lAccountId.Product2Id)[0];
                System.debug('Sal+i de getSegmento lMercado: ' + lMercado);
                
                if(lMercado == 'Prepago'){
                    lToJson.codMercado = 'PRE';
                } else if (lMercado == 'Postpago'){
                    lToJson.codMercado = 'POS';
                } else if (lMercado == 'Hibrido'){
                    lToJson.codMercado = 'HIB';
                }              
                else {
                    lToJson.codMercado = '';
                }
            }
            else{
                throw new CalloutException('Error: No existe la cuenta asociada a la linea');
            }

        
            }
            catch  (Exception e){
                throw new FunctionalException('Error al obtener los datos de la cuenta: ' + lAccountId.AccountId + '. Error: ' + e.getMessage());
            }

        }
        catch  (Exception e){
                throw new FunctionalException('Error al obtener el accountId del nroLinea: ' + pNroLinea + '. Error: ' + e.getMessage());
        }

         return lToJson;
    }
 
    /**
     * Objetivo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {

    }

    private static List<String> getSegmento (String pProduct2Id){
        List<String> lSegmento;

        try {
            Product2 producto = [SELECT vlocity_cmt__Type__c, vlocity_cmt__SubType__c, Family, vlocity_cmt__JSONAttribute__c FROM Product2  WHERE Id = :pProduct2Id];
            if (producto != null) {
                List<String> jsonAttribute = getFormaPago (producto.vlocity_cmt__JSONAttribute__c);
                lSegmento = getFormaPago(producto.vlocity_cmt__JSONAttribute__c);

                System.debug('Sali de getformaPago---> lSegmento: ' + lSegmento );
                return lSegmento;
            }
            else {
                System.debug('Error al obtener atributos para el productId: ' + pProduct2Id);
                throw new FunctionalException('Error al obtener atributos para el productId: ' + pProduct2Id);
            }
        }
        catch (Exception e) {
            System.debug('Error al obtener atributos para el productId: ' + pProduct2Id + '. Error: ' + e.getMessage());
            throw new FunctionalException('Error al obtener atributos para el productId: ' + pProduct2Id + '. Error: ' + e.getMessage());
        }
    }


    /*
     * Esta funcion permite obtener de una estructura json ingresada como parametro
     * un atributo determinado, en este caso value__c dentro del tag FAN_ATTCAT_000045
     * devolviendo el valor contenido en value__c en una lista de string.
     * Tree:
     *        categorycode__c == 'medio de pago'
     *              value__c --> valor a obtener.
     */
    private static List<String> getFormaPago (String pJsonAttribute) {
        System.debug('Entre a getFormaPago()');
        List<String> lstFormaPago = new List<String>();
        if (String.isBlank(pJsonAttribute)) {
            return lstFormaPago;   
        }

        String valor = null;
        String campo = null;
        JSONParser parser = JSON.createParser(pJsonAttribute);
        Boolean eos = false; //-- End of search.
        while (parser.nextToken() != null && !eos) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'attributedisplayname__c')) {
                if (parser.nextValue() != null) {
                    valor = parser.getText();
                    if (valor != null && valor == 'Modo de Pago'){
                        valor = null;
                        System.debug('Encontre el tag: Modo de Pago');
                        while (parser.nextToken() != null && !eos) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'value__c')) {
                                System.debug('... campo: value__c');
                                if (parser.nextValue() != null) {
                                    valor = parser.getText();
                                    eos = true;
                                    System.debug('... valor del campo value__c' + valor);
                                    String [] aValor = valor.split('[;]');
                                    for (Integer i=0; aValor != null && i < aValor.size(); i++) {
                                        if (aValor[i] != null && aValor[i] != 'null') {
                                            lstFormaPago.add(aValor[i]);
                                        }
                                    }
                                }    
                            }    
                        }    
                    }
                }    
            }
        }
        return lstFormaPago;
    }



 
    public class ToJSON_1 {
        public String estadoSocio; 
        public String categoriaSocio;
        public String codMercado;
    }
}