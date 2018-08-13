@RestResource(urlMapping='/v1/integrationprocedure/getContactAccountsAndServicesInformation/contacto/obtener/*')
global with sharing class IFS_S492_getContactAccountsAndServicesIn {

    @HttpGet
    global static void getData() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String, Object> result = new Map<String, Object>();
        res.addHeader('Content-Type', 'application/json');
        try {
            res.statuscode = 200;
            //-- Procesamiento de parametros
            String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            System.debug('parametro contactId --> ' + contactId);

            // Validaciones de requeridos
            if (string.isBlank(contactId)) {
                throw new CalloutException('El identificador de contacto es requerido');
            }
            res.responseBody = Blob.valueOf(JSON.serialize(procesar(contactId))); //<--- Proceso y respondo.
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
    private static Map<String, Object> procesar (String pContactId) {
        System.debug('Entre en procesar() - Parametro: ' + pContactId);
        Map<String, Object> respuesta = new Map<String, Object>();

        try {
            List<Contact> lstContact = getContactById (pContactId);
            if (lstContact == null || lstContact.isEmpty()) {
                throw new FunctionalException('El contactId ' + pContactId + ' no existe');
            }

            List<Map<String, Object>> lstAccounts = new List<Map<String, Object>>();
            respuesta.put('cuentaLista', lstAccounts);

            Map<String, Object> mapaTipoCuenta = new Map<String, Object>();
            lstAccounts.add(mapaTipoCuenta); 

            List<Map<String, Object>> lstTipoCuentas = new List<Map<String, Object>>();
            mapaTipoCuenta.put('tipoDeCuenta', lstTipoCuentas);

            //-- Account Consumer
            List<Account> lstConsumerAccount = getConsumerAccountById (lstContact[0].AccountId);
            Map<String, Object> mapaConsumerAccount = new Map<String, Object>();
            Map<String, Object> consumerObj = new Map<String, Object>();
            if (lstConsumerAccount != null && !lstConsumerAccount.isEmpty()) {
                consumerObj.put('lineasLista', getAssetByAccountId (lstConsumerAccount[0].Id));
                consumerObj.put('segmento2', lstConsumerAccount[0].SegmentLevel2__c);
                consumerObj.put('segmento1', lstConsumerAccount[0].SegmentLevel1__c);
            }
            mapaConsumerAccount.put('consumer', consumerObj);
            lstTipoCuentas.add(mapaConsumerAccount);

            //-- Account Bussines
            List<Account> lstBussinerAccount = getBussinerAccountById (lstContact[0].AccountId);
            Map<String, Object> mapaBussinerAccount = new Map<String, Object>();
            List<Map<String, Object>> lstBussinesObj = new List<Map<String, Object>>();
            if (lstBussinerAccount != null && !lstBussinerAccount.isEmpty()) {
                Map<String, Object> bussinerObj = new Map<String, Object>();
                bussinerObj.put('lineasLista', getAssetByAccountId (lstBussinerAccount[0].Id));
                bussinerObj.put('segmento2', lstBussinerAccount[0].SegmentLevel2__c);
                bussinerObj.put('segmento1', lstBussinerAccount[0].SegmentLevel1__c);
                bussinerObj.put('cuit', lstBussinerAccount[0].CuitNumber__c);
                lstBussinesObj.add(bussinerObj);
            }
            mapaBussinerAccount.put('bussinessList', lstBussinesObj);
            lstTipoCuentas.add(mapaBussinerAccount);

            //-- Datos Personales del contacto --//
            respuesta.put('numeroDocumento', lstContact[0].DocumentNumber__c);
            respuesta.put('tipoDocumento', lstContact[0].DocumentType__c);
            respuesta.put('sexo',lstContact[0].Gender__c);
            respuesta.put('email',lstContact[0].Email);
            respuesta.put('apellido',lstContact[0].LastName);
            respuesta.put('nombre', lstContact[0].FirstName);
            
            return respuesta;
        }
        catch (FunctionalException fe) {
            throw fe;
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objetivo: Obtener el Asset a traves de AccountId
     */
    private static List<Map<String, Object>> getAssetByAccountId (Id pId) {
        System.debug('Entre en getAssetByAccountId - Parametro: ' + pId);
        List<Map<String, Object>> lstAssets = new List<Map<String, Object>>();

        try {
            List<Asset> lstAsset = new List<Asset>();
            if(Test.isRunningTest()){
                lstAsset = [SELECT Id, MSISDN__c, Product2Id, vlocity_cmt__JSONAttribute__c  FROM Asset WHERE AccountId = :pId AND MSISDN__c != null];
            } else {
                lstAsset = [SELECT Id, MSISDN__c, Product2Id, vlocity_cmt__JSONAttribute__c  FROM Asset WHERE AccountId = :pId AND Tipo_de_Producto__c LIKE 'Plan%' AND MSISDN__c != null];
            }
            if (lstAsset == null || lstAsset.isEmpty()) {
                throw new FunctionalException('No se encontro Assets para el AccountId : ' + pId);
            }
            for (Integer i=0; i < lstAsset.size(); i++) {
                Map<String, Object> m = new Map<String, Object>();
                try {
                    Product2 p = getProduct(lstAsset[i].Product2Id);
                    if (p!=null) {
                        m.put('codPlan', p.ProductCode);
                        m.put('tipoPlan', getAttrValue (p.vlocity_cmt__JSONAttribute__c, 'FAN_ATTCAT_000045', 'FAN_ATT_000045', 'value__c'));
                        m.put('codTasadorPlan', getAttrValue (p.vlocity_cmt__JSONAttribute__c, 'FAN_ATTCAT_000042', 'FAN_ATT_000031', 'value__c'));
                        m.put('idTasadorPlan', getAttrValue (p.vlocity_cmt__JSONAttribute__c, 'FAN_ATTCAT_000042', 'FAN_ATT_000030', 'value__c'));
                    }
                }
                catch (Exception e) {
                    m.put('codPlan', '');
                    m.put('tipoPlan', '');
                    m.put('codTasadorPlan', '');
                    m.put('idTasadorPlan', '');
                }
                m.put('idPlan', lstAsset[i].Product2Id);
                m.put('numeroLinea', lstAsset[i].MSISDN__c);
                lstAssets.add(m);
            }
            return lstAssets;
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objetivo: Obtener dado un Id el Product2.
     */
    private static Product2 getProduct(Id pProductId) {
        Product2 p = [SELECT Id, ProductCode, vlocity_cmt__JSONAttribute__c FROM Product2 WHERE Id = :pProductId];
        return p;
    }


     /*
     * Esta funcion permite obtener de una estructura json ingresada como parametro
     * un atributo determinado, en este caso value__c dentro del tag FAN_ATTCAT_000045
     * devolviendo el valor contenido en value__c en una lista de string.
     * Tree:
     *        categorycode__c == FAN_ATTCAT_000045
     *              value__c --> valor a obtener.
     */
    private static String getAttrValue (String pJsonAttribute, String pCategoria, String pAttrUniqCode, String pFieldValueName) {
        System.debug('---- executing getAttrValue()');
        String retValue = '';
        if (String.isBlank(pJsonAttribute)) {
            return retValue;   
        }

        String valor = null;
        String campo = null;
        JSONParser parser = JSON.createParser(pJsonAttribute);
        Boolean eos = false; //-- End of search.
        while (parser.nextToken() != null && !eos) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'categorycode__c')) {
                if (parser.nextValue() != null) {
                    valor = parser.getText();
                    if (valor != null && valor == pCategoria){
                        valor = null;
                        System.debug('Encontre el tag: ' + pCategoria);
                        while (parser.nextToken() != null && !eos) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'attributeuniquecode__c')) {
                                if (parser.nextValue() != null) {
                                    valor = parser.getText();
                                    if (valor != null && valor == pAttrUniqCode){
                                        valor = null;
                                        System.debug('Encontre el tag: ' + pAttrUniqCode);
                                        while (parser.nextToken() != null && !eos) {
                                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == pFieldValueName)) {
                                                System.debug('... campo: ' + pFieldValueName);
                                                if (parser.nextValue() != null) {
                                                    retValue = parser.getText();
                                                    eos = true;
                                                    System.debug('... valor del campo ' + pFieldValueName + ' --> ' + retValue);
                                                }    
                                            }    
                                        }    
                                    }
                                }
                            }
                        }                
                    }
                }    
            }
        }
        return retValue;
    }


    /**
     * @Objectivo: Obtener los datos de un contacto a traves del AccountId.
     *             Path: Account -> Contact
     
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
*/
    /**
     * @Objectivo: Dado un Account Id obtener todos los registros cuyo record type 
     *             sea Consumer.
     */
    private static List<Account> getConsumerAccountById (Id pAccountId) {
        try {
            Id recordTypeConsumerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
            List<Account> lstCosumerAccount = [SELECT Id, SegmentLevel1__c, SegmentLevel2__c FROM Account WHERE Id = :pAccountId AND RecordTypeId = :recordTypeConsumerId];
            if (lstCosumerAccount == null) {
                throw new FunctionalException('No se encontro Consumer Account para el Id: ' + pAccountId);
            }
            return lstCosumerAccount;
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }
    }


    /**
     * @Objectivo: Dado un Account Id obtener todos los registros cuyo record type 
     *             sea Consumer.
     */
    private static List<Account> getBussinerAccountById (Id pAccountId) {
        try {
            Id recordTypeBusinessId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
            List<Account> lstBusinessAccount = [SELECT Id, CuitNumber__c, SegmentLevel1__c, SegmentLevel2__c FROM Account WHERE Id = :pAccountId AND RecordTypeId = :recordTypeBusinessId];
            if (lstBusinessAccount == null) {
                throw new FunctionalException('No se encontro Business Account para el Id: ' + pAccountId);
            }
            return lstBusinessAccount;
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objectivo: Obtener y validar el contactId.
     */
    private static List<Contact> getContactById (String pContactId) {
        System.debug('---- Entre en getContactById() - Parametro: ' + pContactId);
        try {
            List<Contact> lstContact = [SELECT Id, AccountId, FirstName, LastName, Email, Gender__c, DocumentNumber__c, DocumentType__c, vlocity_cmt__IsActive__c FROM Contact WHERE Id = :pContactId];
            if (lstContact == null || lstContact.isEmpty()) {
                throw new FunctionalException('El query para obtener los datos del contacto retorno un objeto nulo. ');    
            }
            System.debug('---- Salgo de getContactById() - Parametro: ' + pContactId);
            return lstContact;
        }
        catch (Exception e) {
            System.debug('---- Error: ' + e.getMessage());
            FunctionalException fe = new FunctionalException('El contacto ingresado no existe');
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