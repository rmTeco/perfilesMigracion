/**
 * Este servicio recibe un identificador de cliente (MSISDN o AccountIntegrationId) y devuelve
 * lista con datos de las tarjetas de credito asociadas a la cuenta obtenida.
 *
 * @Version: S452_1
 * @Author: Pablo Salord (Certa Consulting)
 * @see: PFTA-7257
 *
 * @Version: S452_2
 * @Author: Alejandro Salord (Certa Consulting)
 * @see: PFTA-10408
 */
@RestResource(urlMapping='/v1/integrationprocedure/queryCreditCardAsociation/*')
global with sharing class IFS_S452_queryCreditCardAsociation {

    private static final Boolean K_DEBUG_ON = true; 
    private static String guId = null;

    @HttpPost
    global static void getData() {
        printDebug('Paso 1');
        FromJSON jsonBody;
        List<vlocity_cmt__PaymentMethod__c> listaTarjetas = new List<vlocity_cmt__PaymentMethod__c>();
        List<Map<String, Object>> arrayTarjetas = new List<Map<String, Object>>();
        printDebug('Paso 2');
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        Map<String, Object> result = new Map<String, Object>();
        Map<String, Object> result1 = new Map<String, Object>();
        res.addHeader('Content-Type', 'application/json');

        writeLog ('REQ', req.requestBody.toString());

        try {
            printDebug('Paso 3');

            res.statuscode = 200;
            printDebug('Paso 4');
            
            jsonBody = (FromJSON)JSON.deserialize(req.requestBody.toString(),FromJSON.class);
            printDebug('Paso 5');
            printDebug(''+jsonBody);
            

            // Validaciones de requeridos
            if (jsonBody == null) {
                throw new CalloutException('El request vino vacio.');
            }

            String nroLinea = null;
            String idCliente = null;

            if (!String.isBlank(jsonBody.queryCreditCardAsociation.choiceId.nroLinea)) {
                nroLinea = jsonBody.queryCreditCardAsociation.choiceId.nroLinea;
            }

            if (!String.isBlank(jsonBody.queryCreditCardAsociation.choiceId.idCliente)) {
                idCliente = jsonBody.queryCreditCardAsociation.choiceId.idCliente;
            }

            if (String.isBlank(nroLinea) && String.isBlank(idCliente)) {
                throw new CalloutException('El nroLinea y idCliente vinieron nulos o vacios.');
            }

            Account[] lstCuentas = null;
            if (!String.isBlank(nroLinea)) { //-- Priorizo el nroLinea a pedido de TA-MDW.
                lstCuentas = getAccountByMSISDN(nroLinea);
                idCliente = lstCuentas[0].AccountIntegrationId__c;
            }
            else {
                lstCuentas = getAccountByIdCliente(idCliente);
            }

            printDebug('Antes de getTarjetas');
            listaTarjetas = getTarjetas(lstCuentas);

            printDebug('Después de getTarjetas');

            if (listaTarjetas.size() > 0){
            
                for (Integer i=0; i < listaTarjetas.size(); i++) {
                    Map<String,Object> lJson = new Map<String,Object>();
                    System.debug('For de tarjetas --> ' + listaTarjetas[i].vlocity_cmt__AccountId__c + ' '
                                                        +  listaTarjetas[i].vlocity_cmt__CardNumber__c + ' '                                   
                                                        +  listaTarjetas[i].vlocity_cmt__IsActive__c + ' '                                   
                                                        +  listaTarjetas[i].vlocity_cmt__CardHolderName__c + ' '                                   
                                                        +  listaTarjetas[i].vlocity_cmt__CardType__c + ' '                                   
                                                        +  listaTarjetas[i].vlocity_cmt__ExpirationMonth__c + ' '                                   
                                                        +  listaTarjetas[i].vlocity_cmt__ExpirationYear__c + ' '                                   
                                                        +  listaTarjetas[i].vlocity_cmt__Last4Numbers__c + ' '                                   
                                                        +  listaTarjetas[i].vlocity_cmt__isPrimary__c + ' '                                   
                                                        +  listaTarjetas[i].Security__c);


                    if (!String.isBlank(idCliente)){
                        lJson.put('idCliente',idCliente);  
                    }else{
                        lJson.put('idCliente','');
                    }
                    if (listaTarjetas[i].vlocity_cmt__IsActive__c != null){
                        lJson.put('active',listaTarjetas[i].vlocity_cmt__IsActive__c);  
                    }else{
                        lJson.put('active','');
                    }
                    if (listaTarjetas[i].vlocity_cmt__CardHolderName__c != null){ 
                        lJson.put('cardHolderName',listaTarjetas[i].vlocity_cmt__CardHolderName__c);  
                    }else{
                        lJson.put('cardHolderName','');
                    }
                    lJson.put('cardNumber',listaTarjetas[i].vlocity_cmt__CardNumber__c);  
                    if (listaTarjetas[i].vlocity_cmt__CardType__c != null){
                        lJson.put('cardType',listaTarjetas[i].vlocity_cmt__CardType__c);  
                    }
                    if (listaTarjetas[i].vlocity_cmt__ExpirationMonth__c != null){
                        lJson.put('expirationMonth',listaTarjetas[i].vlocity_cmt__ExpirationMonth__c);  
                    }else{
                        lJson.put('expirationMonth','');
                    }
                    if(listaTarjetas[i].vlocity_cmt__ExpirationYear__c !=null){
                        lJson.put('expirationYear',listaTarjetas[i].vlocity_cmt__ExpirationYear__c);  
                    }else{
                        lJson.put('expirationYear','');
                    }
                    if(listaTarjetas[i].vlocity_cmt__Last4Numbers__c != null){
                        lJson.put('last4Numbers',listaTarjetas[i].vlocity_cmt__Last4Numbers__c);  
                    }else{
                        lJson.put('last4Numbers','');
                    }
                    if (listaTarjetas[i].Security__c != null){
                        lJson.put('isPrimary',listaTarjetas[i].vlocity_cmt__isPrimary__c);
                    }
                    if (listaTarjetas[i].Security__c != null && listaTarjetas[i].Security__c != 0 ){
                        lJson.put('securityCode',String.valueOf(listaTarjetas[i].Security__c));  
                    }
  
                    arrayTarjetas.add(lJson);
                }
            }

            if (arrayTarjetas != null && !arrayTarjetas.isEmpty()) {
                Map<String, Object> queryCreditCardAsociationList = new Map<String, Object>();
                queryCreditCardAsociationList.put('queryCreditCardAsociationList', arrayTarjetas);
                result.put('queryCreditCardAsociation', queryCreditCardAsociationList);
            }

            res.responseBody = Blob.valueOf(JSON.serialize(result));

        }
        catch(FunctionalException fe){
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk(fe.codDP,fe.getMessage())));
        }
        catch(CalloutException ce){
            res.statuscode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('400',ce.getMessage())));
        }
        catch(Exception e){
            res.statuscode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('500',e.getMessage())));
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
            IFS_LogRecord.record(dts, 'SERVICIO', 'S452', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S452', pTipo, guId, '', pDatos);  
        }
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

    /**
     * @Objetivo: Dado un account-integration-id obtener el account.
     */
    private static Account[] getAccountByIdCliente(String pIdCliente) {
        try {
            printDebug('metodo --> getAccountByIdCliente()');
            Account[] lstCuentas = [SELECT Id, AccountIntegrationId__c FROM Account WHERE AccountIntegrationId__c = :pIdCliente];
            if (lstCuentas == null || lstCuentas.isEmpty()) {
                throw new FunctionalException('El query devolvio lista vacia.');
            }
            return lstCuentas;
        }
        catch (Exception e) {
            FunctionalException fe = new FunctionalException('El cliente no existe');
            fe.codDP = '02';
            throw fe;
        }
    }

    /**
     * @Objetivo: Dado un MSISDN (nroLinea) obtener el account.
     */
    private static Account[] getAccountByMSISDN(String pMSISDN) {
        try {
            printDebug('metodo --> getAccountByMSISDN()');
            List<Account> lstCuentas = new List<Account>();
            List<SObject> lstObjects = [SELECT Account.Id, Account.AccountIntegrationId__c FROM Asset WHERE MSISDN__c = :pMSISDN];
            if (lstObjects != null && !lstObjects.isEmpty()) {
                lstCuentas.add((Account)lstObjects[0].getSObject('Account'));
            }
            return lstCuentas;
        }
        catch (Exception e) {
            FunctionalException fe = new FunctionalException('El cliente no existe - Error: ' + e.getMessage());
            fe.codDP = '02';
            throw fe;
        }
    }

    /**
     * @Objetivo: Dado un Account obtener las tarjetas de credito asociadas.
     */
    private static List<vlocity_cmt__PaymentMethod__c> getTarjetas(Account[] pLstCuentas){
        try{
            printDebug('metodo --> getTarjetas() - pLstCuentas --> ' + pLstCuentas);

            if (pLstCuentas.size() > 0){
                vlocity_cmt__PaymentMethod__c[] paymentMtd = [
                SELECT vlocity_cmt__AccountId__c, 
                    vlocity_cmt__IsActive__c, 
                    vlocity_cmt__CardNumber__c, 
                    vlocity_cmt__CardHolderName__c, 
                    vlocity_cmt__CardType__c, 
                    vlocity_cmt__ExpirationMonth__c, 
                    vlocity_cmt__ExpirationYear__c, 
                    vlocity_cmt__Last4Numbers__c, 
                    vlocity_cmt__isPrimary__c, 
                    Security__c 
                FROM vlocity_cmt__PaymentMethod__c 
                WHERE vlocity_cmt__AccountId__c = :pLstCuentas[0].Id AND 
                    vlocity_cmt__MethodType__c = 'Credit Card'];
                return paymentMtd;
            }
            else{
                throw new FunctionalException('La cuenta vino nula.');            
            }
        }
        catch(Exception e){
            throw new FunctionalException('No se pudo recuperar informacion ' + e.getMessage() );
        }
    }
 
 
    /**
     * @Objetivo: Para saber que codigo mandar debo poder
     *            diferenciar una excepcion funcional de
     *            otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {
        public String codDP {set;get;} {codDP = '417';}
    }
 
    /**
     * @Objetivo: Imprimir mensajes en el canal debug.
     */
    private static void printDebug(String pMsj) {
        if (K_DEBUG_ON) {
            System.debug(pMsj);
        }
    }
 
 
    private class FromJSON {
        public FromJSON_1 queryCreditCardAsociation; 
    }

    private class FromJSON_1 {
        public ChoiceClass choiceId; 
    }

    private class ChoiceClass {
        public String idCliente;
        public String nroLinea;
    }

}