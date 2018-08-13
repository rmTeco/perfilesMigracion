@RestResource(urlMapping='/v1/integrationprocedure/queryBillingInfo/*')
global with sharing class IFS_S484_QueryBillingInfo {

    @HttpPost
    global static void getData() {
        System.debug('---- getData()');

        Http http = new Http();
        String nroLinea = null;
        Map<String, Object> resultado = null;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        res.addHeader('Content-Type', 'application/json');
        try {
            res.statuscode = 200;
            Map<String, Object> body = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
            if (body == null || body.isEmpty()) {
                throw new CalloutException('El request vino sin parametros ');
            }

            nroLinea = (String)body.get('linea');
            if (String.isBlank(nroLinea)) {
                throw new CalloutException('El numero de linea vino vacio o nulo');
            }
            
            res.responseBody = Blob.valueOf(JSON.serialize(queryBillingInfo(nroLinea)));
        }
        catch (FunctionalException fe) {
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',fe.getMessage())));
        }
        catch (CalloutException ce) {
            res.statuscode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('400',ce.getMessage())));
        }
        catch(Exception e){
            res.statuscode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('500',e.getMessage())));
        }
    }

    /**
     * @Objetivo: Arma la estructura de respuesta No Ok.
     */
    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        System.debug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }

        /**
     * @Objetivo: Actualizar el IMEI de la factura creada en Huawei.
     */
    private static Map<String, Object> queryBillingInfo (String pNroLinea) {
        System.debug('---- queryBillingInfo()');
        try {
            Id billingAccountId = getBillingAccountId (pNroLinea);
            return getBillingAccountData(billingAccountId);
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage(), e);
        }
    }  

    private static Map<String, Object> getBillingAccountData(Id pBillingAccountId) {
        Map<String, Object> retMap = new Map<String, Object>();
        try {
            List<Account> lstAccount = [SELECT Id, AccountIntegrationId__c, BillingStateCode, CustomerIntegrationId__c FROM Account WHERE Id = :pBillingAccountId];
            if (lstAccount == null || lstAccount.size()==0) {
                throw new FunctionalException('No se encontro el BillingAccount ' + pBillingAccountId);
            }
            retMap.put('idCliente',lstAccount[0].CustomerIntegrationId__c);
            if (String.isBlank(lstAccount[0].BillingStateCode)) {
                retMap.put('codProvincia','C');
            } else{
                retMap.put('codProvincia',lstAccount[0].BillingStateCode);
            }
            
            retMap.put('cuentaFacturacion', lstAccount[0].AccountIntegrationId__c);
            return retMap;
        }
        catch (Exception e) {
            throw new FunctionalException('Obteniendo los datos de facturacion de ' + pBillingAccountId + ' - ' + e.getMessage(), e);
        }
    }

    /**
     * @Objetivo: Dado un numero de linea, buscar el asset 
     *            y devolver el billingaccount de ese asset.
     */
    private static Id getBillingAccountId (String pNroLinea) {
        System.debug('----- getBillingAccount()');
        try {
            List<Asset> lstAsset = [SELECT vlocity_cmt__BillingAccountId__c FROM Asset WHERE MSISDN__c = :pNroLinea];
            if (lstAsset == null || lstAsset.size()==0) {
                throw new FunctionalException('Linea Inexistente');
            }
            return lstAsset[0].vlocity_cmt__BillingAccountId__c;
        }
        catch (Exception e) {
            throw new FunctionalException('obteniendo el Asset de la linea ' + pNroLinea + ' - ' + e.getMessage(), e);
        }
    }

    /**
     * Objetivo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {

    }
  

}