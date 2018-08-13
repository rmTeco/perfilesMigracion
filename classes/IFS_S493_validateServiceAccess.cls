@RestResource(urlMapping='/v1/integrationprocedure/validateServiceAccess/contacto/obtener/*')
global with sharing class IFS_S493_validateServiceAccess {

    @HttpGet
    global static void getData() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String, Object> result = new Map<String, Object>();
        res.addHeader('Content-Type', 'application/json');
        try {
            res.statuscode = 200;
            //-- Procesamiento de parametros
            String arg1 = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            String contactId = arg1;
            String msisdn = req.params.get('numeroLinea');
            System.debug('parametro nroLinea --> ' + msisdn);

            // Validaciones de requeridos
            if (string.isBlank(msisdn)) {
                throw new CalloutException('El numero de linea es requerido');
            }
            if (string.isBlank(contactId)) {
                throw new CalloutException('El identificador de contacto es requerido');
            }
            res.responseBody = Blob.valueOf(JSON.serialize(procesar(msisdn, contactId))); //<--- Proceso y respondo.
        }
        catch (FunctionalException fe) {
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk(fe.codDP, fe.getMessage())));
        }
        catch (CalloutException ce) {
            res.statuscode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('400', ce.getMessage())));
        }
    }

    /**
     * @Objetivo: Realizar todas las validaciones y devolver
     *            la estructura con las respuestas.
     */
    private static Map<String, Object> procesar (String pMsisdn, String pContactId) {
        System.debug('Entre en procesar() - Parametros: ' + pMsisdn + ' - ' + pContactId);
        Map<String, Object> respuesta = new Map<String, Object>();

        try {
            List<Contact> lstContact = getContactById (pContactId);
            List<Asset> lstAsset = getAssetByMsisdn (pMsisdn);
            if (lstAsset != null && !lstAsset.isEmpty()) {
                List<Contact> lstContacts = getContactByAccount (lstAsset[0].AccountId);
                if (lstContacts != null && !lstContacts.isEmpty()) {
                    String sresp = (lstContacts[0].Id == pContactId ? 'Verdadero' : 'Falso' );
                    if ( sresp == 'Falso'){
                        sresp = (validarContactSecundario (pContactId, lstAsset[0].AccountId) ? 'Verdadero' : 'Falso' );
                    }
                    respuesta.put('valor', sresp);
                    return respuesta;
                }
            }
        }
        catch (FunctionalException fe) {
            throw fe;
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }

        respuesta.put('valor', 'Falso');

        return respuesta;
    }



    /**
     * @Objetivo: Obtener el Asset a traves del MSISDN
     */
    private static List<Asset> getAssetByMsisdn (String pMsisdn) {
        System.debug('Entre en getAssetByMsisdn - Parametro: ' + pMsisdn);
        try {
            List<Asset> lstAsset = [SELECT AccountId, Status FROM Asset WHERE MSISDN__c = :pMsisdn LIMIT 1];
            if (lstAsset == null || lstAsset.isEmpty()) {
                throw new FunctionalException('Numero de linea ingresado no existe');
            }
            return lstAsset;
        }
        catch (Exception e) {
            FunctionalException fe =  new FunctionalException(e.getMessage());
            fe.codDP = 'NEG0493001';
            throw fe;
        }
    }

    /**
     * @Objectivo: Obtener los datos de un contacto a traves del AccountId.
     *             Path: Account -> Contact
     */
    private static List<Contact> getContactByAccount (String pAccountId) {
        System.debug('Entre en getContactByAccount - Parametro: ' + pAccountId);
        Account account = null;
        try {
            account = [SELECT vlocity_cmt__PrimaryContactId__c FROM Account WHERE Id = :pAccountId LIMIT 1];
            if (account == null) {
                throw new FunctionalException('El query para obtener cuenta retorno un objeto nulo. ');
            }
        }
        catch (Exception e) {
            System.debug('---- Error: ' + e.getMessage());
            throw new FunctionalException('Fallo al obtener la cuenta Id: ' + pAccountId + '. Error: ' + e.getMessage());
        }

        String contactId = String.valueOf(account.vlocity_cmt__PrimaryContactId__c);

        if (String.isBlank(contactId)) {
            System.debug('---- Error: El contactId obtenido de la cuenta es nulo o vacio.');
            throw new FunctionalException('El contactId obtenido de la cuenta es nulo o vacio.');    
        }

        System.debug('------ contactId: ' + contactId);

        return getContactById (contactId);
    }


    /**
     * @Objectivo: Obtener y validar el contactId.
     */
    private static List<Contact> getContactById (String pContactId) {
        System.debug('---- Entre en getContactById() - Parametro: ' + pContactId);
        try {
            List<Contact> lstContact = [SELECT Id, DocumentNumber__c, DocumentType__c, vlocity_cmt__IsActive__c FROM Contact WHERE Id = :pContactId];
            if (lstContact == null || lstContact.isEmpty()) {
                throw new FunctionalException('El query para obtener los datos del contacto retorno un objeto nulo. ');    
            }
            return lstContact;
        }
        catch (Exception e) {
            System.debug('---- Error: ' + e.getMessage());
            FunctionalException fe = new FunctionalException('El contacto ingresado no existe');
            fe.codDP = 'NEG0493002';
            throw fe;
        }
    }

    /**
     * @Objectivo: Valida la relacion cuenta/contacto secundario.
     *              Esta funcion se disparara si el contacto enviado no es 
     *              el primario.
     */
    private static Boolean validarContactSecundario (String pContactId, String pAccountId) {
        System.debug('---- Entre en getContactSecundarioById() - Parametro: ' + pContactId);
        try {
            List<AccountContactRelation> lstContact = [SELECT Id, IsActive FROM AccountContactRelation WHERE ContactId = :pContactId AND AccountId = :pAccountId];
            if (lstContact == null || lstContact.isEmpty()) {
                throw new FunctionalException('El query para obtener los datos del contacto retorno un objeto nulo. ');    
            }
            return true;
        }
        catch (Exception e) {
            System.debug('---- Error en validarContactSecundario() -->  ' + e.getMessage());
            return false;
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

    //---- Clases para soportar el intercambio de parametros ----//
    /**
     * @Objetivo: Para saber que codigo mandar debo poder
     *            diferenciar una excepcion funcional de
     *            otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {
        public String codDP {set;get;} {codDP = '417';}
    }

}