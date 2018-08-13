public with sharing class IFS_S435_getLineDataValidation_cls {
    
    public static ResultObj getLineDataValidation(String pJsonInput){
		ResultObj resultObject;
        Map<String, Object> resultado;
        FromJSON jsonBody;
        System.debug('Entre a getLineDataValidation()' + pJsonInput);

        try {
            jsonBody = (FromJSON)JSON.deserialize(pJsonInput, FromJSON.class);

            checkContrato (jsonBody); 
            resultObject = new ResultObj(200, Blob.valueOf(JSON.serialize(procesar (jsonBody))));
            System.debug('Retorna: ' + resultObject);
            return resultObject;
        }
        catch (FunctionalException fe) {
        	resultObject = new ResultObj(417, Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',fe.getMessage()))));
        	return resultObject;
        }
        catch (CalloutException ce) {
            resultObject = new ResultObj(400, Blob.valueOf(JSON.serialize(getRespuestaNoOk('400',ce.getMessage()))));
            System.debug('Retorna: ' + resultObject);
            return resultObject;
        }
    }    

    /**
     * @Objetivo: Realizar todas las validaciones y devolver
     *            la estructura con las respuestas.
     */
    private static Map<String, Object> procesar (FromJSON pJson) {
        System.debug('Entre en procesar()');
        Map<String, Object> respuesta = new Map<String, Object>();
        Asset asset = null;
        Contact contact = null;
        String codMercado = null;

        //-- Seteo valores por defecto --//
        String suspSiniestro = 'NOK';
        String validacionDocumento = 'NOK';
        String validacionMercado = 'NOK';
        String estadoContratoActivo = 'NOK';
        String codInteraccionNegocio = null;
        String fechaSuspension = null;
        String fechaModificacionContrato = null;
        Boolean caseFound = false;

        //-- Obtengo el Asset principal - Se supone que es el equivalente a lo que llaman Contrato.
        try {
            asset = getAssetByMsisdn (pJson.getLineDataValidation.nroLinea);
            System.debug('Asset Status: ' + asset.Status);
            if (asset.Status != 'SUSPENDED') {
                suspSiniestro = 'OK';
            }
            else {
                //-- Solo si la suspención fue por siniestro
                suspSiniestro = (asset.Sub_Status__c == 'SINIESTRO') ? 'NOK' : 'OK';
            }
        }
        catch (Exception e) {
            System.debug('Error al obtener los datos del Asset. Error: ' + e.getMessage());
        }   

        if (suspSiniestro == 'NOK') {
            System.debug('Como esta suspendido por Siniestro, voy a buscar el Case de suspencion');
            try {
                Map<String, Object> mapCase = getCase (asset.AssetId__c);
                if (mapCase != null && !mapCase.isEmpty()) {
                    codInteraccionNegocio = (String)mapCase.get('codInteraccionNegocio');
                    fechaSuspension = (String)mapCase.get('fechaSuspension');
                    caseFound = true;
                }
            }
            catch (Exception e) {
                System.debug(e.getMessage());
            }     
        }
        //-- A traves del Asset obtengo la cuenta y a traves de esta, el Contacto
        try {
            contact = getContactByAccount (asset.AccountId);
            System.debug('---- Contact Tipo Doc: ' + contact.DocumentType__c);
            System.debug('---- Contact Nro  Doc: ' + contact.DocumentNumber__c);
            if (pJson.getLineDataValidation.tipoDocumento.equals(contact.DocumentType__c)) {
                System.debug('---- Valido Ok el Tipo de documento: ' + pJson.getLineDataValidation.tipoDocumento); 
                if (pJson.getLineDataValidation.numeroDocumento.equals(contact.DocumentNumber__c)) {
                    System.debug('---- Valido Ok el numero de documento: ' + pJson.getLineDataValidation.numeroDocumento); 
                    validacionDocumento = 'OK';
                }
                else {
                    System.debug('---- Valido NOk el numero de documento: ' + pJson.getLineDataValidation.numeroDocumento);
                }                                       
            }
            else {
                System.debug('---- Valido NOk el Tipo de documento: ' + pJson.getLineDataValidation.tipoDocumento);                    
            }
        }
        catch (Exception e) {
            System.debug('Error al obtener los datos del Documento. Error: ' + e.getMessage());
        }    

        //-- Proceso el json con atributos para obtener el codigo de mercado.
        try {
            String reqMercado = getVLMercadoCode (pJson.getLineDataValidation.codMercadoDonante);
            String jsonAttribute = getJsonRootAsset (asset.vlocity_cmt__RootItemId__c);
            codMercado = getMercado (jsonAttribute);

            if((reqMercado.equalsIgnoreCase('Pospago') || reqMercado.equalsIgnoreCase('Hibrido')) && 
                (codMercado.equalsIgnoreCase('Pospago') || codMercado.equalsIgnoreCase('Hibrido'))) {
                reqMercado = 'OK';
                codMercado = 'OK';
            }
            if (codMercado.equalsIgnoreCase(reqMercado)) {
                validacionMercado = 'OK';
            }
        }
        catch (Exception e) {
            System.debug('Error al obtener los datos del Mercado. Error: ' + e.getMessage());
        }

        try {
            getEstadoContrato(asset.vlocity_cmt__JSONAttribute__c);
            estadoContratoActivo = 'OK';
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }

        if (caseFound) {
            respuesta.put('fechaSuspension', fechaSuspension);
            respuesta.put('codInteraccionNegocio', codInteraccionNegocio);
        }
        respuesta.put('codOperadoraDonante', '5777');
        respuesta.put('validacionDocumento',validacionDocumento);
        respuesta.put('estadoContratoActivo', estadoContratoActivo);
        respuesta.put('suspSiniestro',suspSiniestro);
        respuesta.put('validacionMercado',validacionMercado);

        return respuesta;
    }

    /**
     * @Objetivo: Los codigos de mercados que vienen de MDW son
     *            distintos que los que estan en VL. Esta funcion
     *            convierte de MDW a Vlocity.
     */
    private static String getVLMercadoCode (String pMDWCode) {
        System.debug('Entre en getVLMercadoCode()');
        
        if (String.isBlank(pMDWCode)) {
            System.debug('----- Codigo de Mercado a traducir nulo o vacio');
            throw new FunctionalException('Codigo de Mercado a traducir nulo o vacio');
        }
        else if (pMDWCode.equalsIgnoreCase('POS')) {
            return 'Pospago';
        }
        else if (pMDWCode.equalsIgnoreCase('MIX')) {
            return 'Hibrido';
        }
        if (pMDWCode.equalsIgnoreCase('PRE')) {
            return 'Prepago';
        }
        else {
            throw new FunctionalException('Codigo de Mercado a traducir invalido. Codigo: ' + pMDWCode);
        }            
    }

    /**
     * @Objetivo: Verificar el cumplimiento del contrato.
     */
    private static void checkContrato (FromJSON pJsonBody) {
        System.debug('Entre en checkContrato');
        final String K_MERCADO_VALUES = 'PRE,POS,MIX';
        final String K_TIPO_DOCUMENTOS_VALUES = 'CUIT,CUIL,DNI,LC,LE,CI,PASAPORTE,CIU,PAU';

        if (pJsonBody == null) {
            throw new CalloutException('El request vino nulo');
        }

        if (pJsonBody.getLineDataValidation == null) {
            throw new CalloutException('El request vino nulo');
        }

        if (String.isBlank(pJsonBody.getLineDataValidation.nroLinea)) {
            throw new CalloutException('El numero de linea vino vacio o nulo');
        }

        if (String.isBlank(pJsonBody.getLineDataValidation.codMercadoDonante)) {
            throw new CalloutException('El codigo de Mercado Donante vino vacio o nulo');
        } else {
            if(K_MERCADO_VALUES.indexOf(pJsonBody.getLineDataValidation.codMercadoDonante)==-1){
                throw new CalloutException('El codigo de Mercado Donante vino con valores diferentes a los definidos: ' + K_MERCADO_VALUES + '. Valor recibido:  ' + pJsonBody.getLineDataValidation.codMercadoDonante);
            }                
        }

        if (String.isBlank(pJsonBody.getLineDataValidation.tipoDocumento)) {
            throw new CalloutException('El tipo de Documento vino vacio o nulo');
        } else {
            if(K_TIPO_DOCUMENTOS_VALUES.indexOf(pJsonBody.getLineDataValidation.tipoDocumento)==-1){
                throw new FunctionalException('El tipo de documento vino con valores diferentes a los definidos: ' + K_TIPO_DOCUMENTOS_VALUES + '. Valor recibido:  ' + pJsonBody.getLineDataValidation.tipoDocumento);
            }                
        }

        if (String.isBlank(pJsonBody.getLineDataValidation.numeroDocumento)) {
            throw new CalloutException('El numero de Documento vino vacio o nulo');
        } else {
            if(!pJsonBody.getLineDataValidation.numeroDocumento.isNumeric()){
                throw new CalloutException('El numero de documento vino con valores no numericos. Valor recibido:  ' + pJsonBody.getLineDataValidation.numeroDocumento);
            }                
        }

        if (String.isBlank(pJsonBody.getLineDataValidation.fechaSolicitudPortacionReceptora)) {
            throw new CalloutException('La fecha de inicio de operacion en la entidad receptora vino vacia o nula');
        } else {
            try {
                DateTime d = DateTime.valueOf(pJsonBody.getLineDataValidation.fechaSolicitudPortacionReceptora);
            }                
            catch (Exception e) {
                throw new CalloutException('La fecha de inicio de operacion en la entidad receptora vino en formato diferente al definido (YYYY-MM-DD HH:MI:SS) o con valores invalidos.. Valor recibido:  ' + pJsonBody.getLineDataValidation.fechaSolicitudPortacionReceptora);                
            }
        }
    }

    /**
     * @Objetivo: Obtener el Asset a traves del MSISDN
     */
    private static Asset getAssetByMsisdn (String pMsisdn) {
        System.debug('Entre en getAssetByMsisdn');

        if (String.isBlank(pMsisdn)) {
            throw new FunctionalException('El Msisdn vino vacio o nulo. ');
        }

        try {
            Asset asset = [SELECT AccountId, Status, vlocity_cmt__JSONAttribute__c, Sub_Status__c, AssetId__c, vlocity_cmt__RootItemId__c FROM Asset WHERE MSISDN__c = :pMsisdn LIMIT 1];
            if (asset == null) {
                throw new FunctionalException('No se pudo obtener el Asset a traves del MSISDN: ' + pMsisdn);
            }
            return asset;
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objectivo: Obtener los datos de un contacto a traves del AccountId.
     *             Path: Account -> Contact
     */
    private static Contact getContactByAccount (String pAccountId) {
        System.debug('Entre en getContactByAccount');
        Account account = null;

        if (String.isBlank(pAccountId)) {
            throw new FunctionalException('El Id de cuenta vino vacio o nulo.');
        }

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

        try {
            Contact contact = [SELECT DocumentNumber__c, DocumentType__c, vlocity_cmt__IsActive__c FROM Contact WHERE Id = :contactId];
            if (contact == null) {
                throw new FunctionalException('El query para obtener los datos del contacto retorno un objeto nulo. ');    
            }
            return contact;
        }
        catch (Exception e) {
            System.debug('---- Error: ' + e.getMessage());
            throw new FunctionalException('Fallo al obtener el Contacto por Id: ' + contactId + '. Error: ' + e.getMessage());
        }
    }

    /**
     * @Objetivo: Dado un rootItemId devolver su json attribute.
     */
    private static String getJsonRootAsset (String RootItemId) {
        System.debug('Entre en getJsonRootAsset');

        try {
            Asset asset = [SELECT vlocity_cmt__JSONAttribute__c FROM Asset WHERE Id = :RootItemId];
            if (asset == null) {
                throw new FunctionalException('Error al obtener el Asset Root. El query devolvio objeto nulo');
            }
            return asset.vlocity_cmt__JSONAttribute__c;
        }
        catch (Exception e) {
            System.debug('------ Error: ' + e.getMessage());
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objetivo: Dado un json attribute obtener el codigo de 
     *   mercado. Este es buscando:
     * 	 categorycode__c          : FAN_ATTCAT_000045
	 *   attributeuniquecode__c   : FAN_ATT_000045
	 *   isactive__c              : true
	 *   attributeRunTimeInfo     : Map<String, Object>
	 *   selectedItem             : Map<String, Object>
	 *	 value : Posibles valores : Prepago, Pospago, Hibrido
     */
    private static String getMercado(String pJsonAttribute) {
        System.debug('Entre en getMercado()');
        String mercado = null;

        try {
            mercado = getValorMercado (pJsonAttribute, 'FAN_ATTCAT_000045', 'FAN_ATT_000045');
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }
        return mercado;
    }

    private static String getValorMercado (String pJsonAttribute, String pCodCategoria, String pCodAtributo) {
        System.debug('Entre en getMercado()');
        if (String.isBlank(pJsonAttribute)){
            throw new FunctionalException('El pJsonAttribute vino vacio o nulo');
        }

        try {
            Map<String, Object> jsonAttributes = (Map<String, Object>)JSON.deserializeUntyped(pJsonAttribute);
            Set<String> attributesKeys = jsonAttributes.keySet();
            for(String attributeKey : attributesKeys){
                List<Object> attributes = (List<Object>)jsonAttributes.get(attributeKey);
                for(Object attribute : attributes){
                    Map<String, Object> mapAttribute = (Map<String, Object>) attribute;
                    String categoria = (String)mapAttribute.get('categorycode__c');
                    if (!String.isBlank(categoria) && categoria == pCodCategoria) {
                        System.debug('---- Encontre codigo de categoria ' + pCodCategoria);
                        String unicode = (String)mapAttribute.get('attributeuniquecode__c');
                        if (!String.isBlank(unicode) && unicode == pCodAtributo) {
                            System.debug('---- Encontre codigo de atributo ' + pCodAtributo);
                            Boolean isActive = (Boolean)mapAttribute.get('isactive__c');
                            String valor = (String)mapAttribute.get('value__c');
                            if (valor != null && !valor.equalsIgnoreCase('null')) {
                                return valor;
                            }
                            else {
                                Map<String, Object> mapaAttRuntimeInfo = (Map<String, Object>)mapAttribute.get('attributeRunTimeInfo');
                                if (mapaAttRuntimeInfo != null) {
                                    Map<String, Object> mapaSelected = (Map<String, Object>)mapaAttRuntimeInfo.get('selectedItem');
                                    if (mapaSelected != null) {
                                        valor = (String)mapaSelected.get('value');
                                        return valor;
                                    }
                                }    
                            }    
                        }
                    }        
                }    
            }    
            throw new FunctionalException('No se encontro el codigo de Mercado.');
        }
        catch (Exception e) {
            System.debug('getMercado JSONAttr-----> ' + pJsonAttribute);
            throw new FunctionalException('Error al deserializar los atributos del Asset para buscar el Mercado.');
        }
    }

    /**
     * @Objetivo: Recorrer el json y buscar los atributos que describen 
     *            el estado de los servicios de voz, sms, gprs, linea fija.
     */
    private static void getEstadoContrato (String pJsonAttribute) {
        System.debug('Entre en getEstadoContrato()');
        if (String.isBlank(pJsonAttribute)){
            throw new FunctionalException('El pJsonAttribute vino vacio o nulo');
        }

        Boolean activo = false;

        try {
            Map<String, Object> jsonAttributes = (Map<String, Object>)JSON.deserializeUntyped(pJsonAttribute);
            Set<String> attributesKeys = jsonAttributes.keySet();
            for(String attributeKey : attributesKeys){
                List<Object> attributes = (List<Object>)jsonAttributes.get(attributeKey);
                for(Object attribute : attributes){
                    Map<String, Object> mapAttribute = (Map<String, Object>) attribute;
                    String categoria = (String)mapAttribute.get('categorycode__c');
                    if (!String.isBlank(categoria) && categoria == 'FAN_ATTCAT_000041') {
                        System.debug('---- Encontre FAN_ATTCAT_000041');
                        String unicode = (String)mapAttribute.get('attributeuniquecode__c');
                        if (!String.isBlank(unicode) && (unicode == 'FAN_ATT_000026' || unicode == 'FAN_ATT_000027' || unicode == 'FAN_ATT_000028' || unicode == 'FAN_ATT_000029')) {
                            System.debug('---- Encontre ' + unicode);
                            Boolean isActive = (Boolean)mapAttribute.get('isactive__c');
                            Map<String, Object> mapaAttRuntimeInfo = (Map<String, Object>)mapAttribute.get('attributeRunTimeInfo');
                            if (mapaAttRuntimeInfo != null) {
                                Map<String, Object> mapaSelected = (Map<String, Object>)mapaAttRuntimeInfo.get('selectedItem');
                                if (mapaSelected != null) {
                                    String valor = (String)mapaSelected.get('value');
                                    //-- Me aseguro que con que haya alguno activo, siempre quede activo.
                                    activo = activo || (!String.isBlank(valor) && valor == 'true') ;
                                }    
                            }    
                        }
                    }        
                }    
            } 
            if (!activo) {   
                throw new FunctionalException('Contrato inactivo.');
            }
        }
        catch (Exception e) {
            throw new FunctionalException('Error al obtener los datos del contrato. Error: ' + e.getMessage());
        }
    }

    /**
     * @Objectivo: Dado un asset id obtener el case.
     */
    private static Map<String, Object> getCase (String pAssetId) {
        System.debug('Entre en getCase()');

        if (String.isBlank(pAssetId)) {
            throw new FunctionalException('El asset id para obtener el Case vino vacio o nulo');
        }

        List<Case> lstCase = null;
        try {
            lstCase = [SELECT CaseNumber, CreatedDate, Subject FROM Case WHERE AssetId = :pAssetId];
            if (lstCase == null || lstCase.isEmpty()) {
                throw new FunctionalException('El query para obtener el Case retorno vacio o nulo.');
            }
            Map<String, Object> mapCase = new Map<String, Object>();
            for (Case lcase : lstCase) {
                mapCase.put('codInteraccionNegocio',lcase.CaseNumber);
                mapCase.put('fechaSuspension',String.valueOf(lcase.CreatedDate));
            }
            return mapCase;
        }
        catch (Exception e) {
            System.debug('-------- Error: ' + e.getMessage());
            throw new FunctionalException('Fallo al obtener el Case del AssetId: ' + pAssetId + '. Error: ' + e.getMessage());
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

    }

    /**
     * Clase en donde serializo los parámetros de entrada
     * del servicio.
     */
    
    public class ResultObj {
		public Integer resultCode;
		public Blob resultMessage;

		public ResultObj(Integer code, Blob msg) {
			this.resultCode = code;
			this.resultMessage = msg;
		}
	}

    //-- Definicion del Request --//
    private class FromJSON {
        public LineDataValidationClass getLineDataValidation;
    }

    private class LineDataValidationClass {
        public String nroLinea;
        public String codMercadoDonante;
        public String tipoDocumento;
        public String numeroDocumento;
        public String fechaSolicitudPortacionReceptora;
    }

}