/**
 * Este es un servicio rest que permite consultar los numeros amigos configurados
 * para una determinada cuenta.
 *
 * @Author: Alejandro Salord (Certa Consulting).
 * @Version: 
 * @see: 
 */
 public with sharing class IFS_S453_queryFriendsAndFamily_cls {
    public static final boolean K_DEBUG_ON = true;

    public static ResultObj queryFriendsAndFamily(String jsonInput) {
        printDebug('Entre a queryFriendsAndFamily() - Params: ' + jsonInput);

		ResultObj resultObject;
        FromJSON jsonBody;

        try {
            try {
                jsonBody = (FromJSON)JSON.deserialize(jsonInput, FromJSON.class);
            }
            catch (Exception e) {
                throw new CalloutException('Error al deserializar los parametros. Error: ' + e.getMessage());
            } 
        
            checkContrato (jsonBody); //-- Verifico que el contrato (IFS) se cumpla.

            resultObject = new ResultObj(200, Blob.valueOf(JSON.serialize(getFriendsAndFamily (jsonBody))));
            printDebug('Retorna: ' + resultObject);
            return resultObject;
        }
        catch (FunctionalException fe) {
        	resultObject = new ResultObj(417, Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',fe.getMessage()))));
            printDebug('Retorna: ' + resultObject);
        	return resultObject;
        }
        catch (CalloutException ce) {
            resultObject = new ResultObj(400, Blob.valueOf(JSON.serialize(getRespuestaNoOk('400',ce.getMessage()))));
            printDebug('Retorna: ' + resultObject);
            return resultObject;
        }
        catch(Exception e){
        	resultObject = new ResultObj(500, Blob.valueOf(JSON.serialize(getRespuestaNoOk('500',e.getMessage()))));
            printDebug('Retorna: ' + resultObject);
            return resultObject;
        }
    }

    private static ToJson getFriendsAndFamily (FromJSON pJsonBody) {
        printDebug('Entre a getFriendsAndFamily()');

        if (pJsonBody == null) {
            throw new CalloutException('El request vino vacio');
        }

        ToJson toJson = new ToJson();

        Asset asset = null;

        //-- Obtengo el root item id por subscriber o por msisdn
        if (!String.isBlank(pJsonBody.choiceId.subscriberId)) {
            asset = getRootItemIdBySubscriptorId(pJsonBody.choiceId.subscriberId);
        }
        else {
            asset = getRootItemIdByMSISDN(pJsonBody.choiceId.nroLinea);
        }

        String rootItemId = asset.vlocity_cmt__RootItemId__c;        

        List<Asset> lstAssets = getAssetsByRootItemId (rootItemId); //--Obtengo todos los registros para ese rootItemId

        toJson.subscriberId = asset.Subscription_Id__c != null ? asset.Subscription_Id__c : ''; //-- guardo el subscriptionId.

        /*
         * -- Hago un corte/control por producto (productLN==productLNAnt) seleccionando dos tipos de registros
         *    que dependen del json attribute. Si el codigo es: 
         *             FAN_ATTCAT_000046 --> Me viene los totales
         *             FAN_ATTCAT_000047 --> Me viene la lista de telefonos asociada.
         */
        Integer i=0;
        Boolean eod = (i==lstAssets.size()); //-- Indica la finalización de datos.
        System.debug('El tamaño de la lista Asset es:' + lstAssets.size());
        while (!eod) {
            if (lstAssets.get(i).SubTipo_de_Producto__c == null || lstAssets.get(i).Id == null || lstAssets.get(i).vlocity_cmt__JSONAttribute__c == null || lstAssets.get(i).vlocity_cmt__LineNumber__c == null
                || lstAssets.get(i).vlocity_cmt__AssetReferenceId__c == null ) {
                    printDebug('--- Error en la configuracion del plan, estan viniendo valores nulos. ---- ');
                    i+=1;
                    eod = (i>=lstAssets.size());
                    continue;
            }
            String lsubTipo = lstAssets.get(i).SubTipo_de_Producto__c;
            String productLN = getProductLineNumber (lstAssets.get(i).vlocity_cmt__LineNumber__c);
            String productLNAnt = productLN;
            ToJsonOferta oferta = new ToJsonOferta();
            List<ToJsonLinea> lstLineas = new List<ToJsonLinea>();
            while (!eod && productLNAnt == productLN) {
                Integer tipoRegistro = verificarAtributos(lstAssets.get(i).vlocity_cmt__JSONAttribute__c, lstAssets.get(i).Product2.vlocity_cmt__JSONAttribute__c);
                if (tipoRegistro==1) {
                    oferta = getValoresMaximos (lstAssets.get(i).Product2.vlocity_cmt__JSONAttribute__c, lsubTipo, lstAssets.get(i).vlocity_cmt__AssetReferenceId__c);
                }
                else if (tipoRegistro==2){
                    ToJsonLinea linea = getNumeroAmigo (lstAssets.get(i).vlocity_cmt__JSONAttribute__c, lstAssets.get(i).vlocity_cmt__AssetReferenceId__c);
                    lstLineas.add(linea);
                }
                i+=1;
                eod = (i>=lstAssets.size());
                if (!eod) {
                    productLN = getProductLineNumber (lstAssets.get(i).vlocity_cmt__LineNumber__c);
                }
            }
            eod = (i>=lstAssets.size());
            oferta.lstLineas = lstLineas;
            if (!String.isBlank(oferta.tipoServicio) && !String.isBlank(oferta.ofertaId)) {
                toJson.lstOfertas.add(oferta);
            }
        }

        return toJson;
    }


    /**
     *  Este metodo recibe un string param con el siguiente formato: 9999.9999.9999.9999
     *  [0]=Plan [1]=Producto [2]=Producto Hijo [3]=Producto Hijo, etc.
     *  Solo interesa devolver el Producto o sea [1].
     */
    private static String getProductLineNumber (String pLN) {
        if (String.isBlank(pLN)) {
            return null;
        }
        String [] aLN = pLN.split('\\.');
        if (aLN == null || aLN.size() < 2) {
            return null;
        }
        return aLN[1];
    }

    /*
     * Esta funcion se encarga de verificar el tipo de registro basado en el jsonAttribute. Si 
     * encuentra el valor de atributo:
     *           FAN_ATTCAT_000046 --> devuelve 1 -> Aqui encuentro los valores maximos del plan.
     *           FAN_ATTCAT_000047 --> devuelve 2 -> Aqui encuentro el numero de telefono y tipo.
     *           Otro              --> devuelve 0 -> Este valor indica que el registro no debe ser tratado.
     */
    private static Integer verificarAtributos(String pAssetJsonAttribute, String pProductJsonAttribute) {
        printDebug('Entre en verificarAtributos');
        if (String.isBlank(pAssetJsonAttribute)) {
            printDebug('Error al buscar verificar los atributos. Vinieron vacio');
            return 0;
        }

        if (String.isBlank(pProductJsonAttribute)) {
            printDebug('Error al buscar verificar los atributos. Vinieron vacio');
            return 0;
        }

        if (pProductJsonAttribute.indexOf('FAN_ATTCAT_000046')>-1) {
            printDebug('----- Encontre FAN_ATTCAT_000046');
            return 1;
        }
        else if (pAssetJsonAttribute.indexOf('FAN_ATTCAT_000047')>-1) {
            printDebug('----- Encontre FAN_ATTCAT_000047');
            return 2;
        }
        else {
            printDebug('----- No encontre nada.');
            return 0;
        }
    }

    /*
     * Esta funcion obtiene el plan Numeros Amigos para el rootItemId.
     */
    private static List<Asset> getAssetsByRootItemId (String pRootItemId) {
        printDebug('Entre a getAssetsByRootItemId()');

        if (String.isBlank(pRootItemId)) {
            printDebug(' ---- El pRootItemId vino vacio');
            throw new CalloutException('El pRootItemId vino vacio');
        }

        List<Asset> lstAssets = null;

        try {
            lstAssets = [SELECT id, vlocity_cmt__AssetReferenceId__c, Name, SubTipo_de_Producto__c, vlocity_cmt__JSONAttribute__c, Product2.vlocity_cmt__JSONAttribute__c, vlocity_cmt__LineNumber__c FROM Asset WHERE vlocity_cmt__RootItemId__c = :pRootItemId AND Tipo_de_Producto__c = 'Numeros Amigos'  ORDER BY vlocity_cmt__LineNumber__c];
            if (lstAssets == null || lstAssets.size()==0) {
                throw new FunctionalException('Error al obtener los Assets por rootItemId. El resultado del query fue nulo o vacio');    
            }
            return lstAssets;
        }
        catch (Exception e) {
            printDebug(' ---- Fallo al obtener el nivel 1 - El agrupador rootItemId. Error: ' + e.getMessage());
            throw new FunctionalException('Error al obtener el plan numeros amigos del rootItemId: ' + pRootItemId + '. Error: ' + e.getMessage());
        }    
    }

    /*
     * Esta funcion recorre los atributos pasados en el parametro pJsonAttribute y busca en esos
     * atributos el número amigo y el tipo, devolviendo un objeto ToJsonLinea.
     */
    private static ToJsonLinea getNumeroAmigo (String pJsonAttribute, String pAssetId) {
        printDebug('Entre en getNumeroAmigo - pAssetId --> ' + pAssetId);
        ToJsonLinea lnumeroAmigo = new ToJsonLinea();

        JSONParser parser = JSON.createParser(pJsonAttribute);
        Boolean eos = false; //-- End of search.
        String valor = null;

        lnumeroAmigo.assetId = pAssetId;

        while (parser.nextToken() != null && !eos) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'categorycode__c')) {
                if (parser.nextValue() != null) {
                    valor = parser.getText();
                    if (valor != null && valor == 'FAN_ATTCAT_000047'){
                        valor = null;
                        printDebug(' ---- Encontre el tag: FAN_ATTCAT_000047');
                        Boolean eoa = false;
                        while (parser.nextToken() != null && !eos && !eoa) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'attributeuniquecode__c')) {
                                if (parser.nextValue() != null) {
                                    String codigoUnico = parser.getText();
                                    if (codigoUnico != null && codigoUnico == 'FAN_ATT_000057'){
                                        valor = null;
                                        printDebug(' -------- Encontre el tag: ' + codigoUnico);
                                        while (parser.nextToken() != null && !eos && !eoa) {
                                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'value')) {
                                                printDebug('---------- campo: value');
                                                if (parser.nextValue() != null) {
                                                    valor = parser.getText();
                                                    printDebug('---------- valor del campo value --> ' + valor);
                                                    lnumeroAmigo.nroLinea = valor;
                                                    eoa = true;
                                                }    
                                            }    
                                        }    
                                    }
                                    else if (codigoUnico != null && (codigoUnico == 'FAN_ATT_000129')) {
                                        valor = null;
                                        printDebug('---------- Encontre el tag: ' + codigoUnico);
                                        while (parser.nextToken() != null && !eos) {
                                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'selectedItem')) {
                                                printDebug('---------- campo: selectedItem');
                                                while (parser.nextToken() != null && !eos && !eoa) {
                                                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'value')) {
                                                        if (parser.nextValue() != null) {
                                                            valor = parser.getText();
                                                            printDebug('---------- valor del campo value --> ' + valor);
                                                            lnumeroAmigo.tipo = valor;
                                                            eoa = true;
                                                            eos = true;
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
            }
        }
        printDebug('---------- valores devueltos --> ' + lnumeroAmigo);
        return lnumeroAmigo;
    }


    /*
     * Esta funcion busca en el jsonAttribute los valores maximo del plan. De acuerdo al codigoUnico que define
     * cual es el total que corresponde. Devuelve un objeto de tipo ToJsonOferta.
     */
    private static ToJsonOferta getValoresMaximos (String pJsonAttribute, String pTipoServicio, String pOfertaId) {
        printDebug('Entre en getValoresMaximos - pTipoServicio --> ' + pTipoServicio + ' - pOfertaId --> ' + pOfertaId);
        ToJsonOferta loferta = new ToJsonOferta();

        JSONParser parser = JSON.createParser(pJsonAttribute);
        Boolean eos = false; //-- End of search.
        String valor = null;

        loferta.tipoServicio = pTipoServicio;
        loferta.ofertaId = pOfertaId;

        while (parser.nextToken() != null && !eos) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'categorycode__c')) {
                if (parser.nextValue() != null) {
                    valor = parser.getText();
                    if (valor != null && valor == 'FAN_ATTCAT_000046'){
                        valor = null;
                        printDebug('Encontre el tag: FAN_ATTCAT_000046');
                        while (parser.nextToken() != null && !eos) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'attributeuniquecode__c')) {
                                if (parser.nextValue() != null) {
                                    String codigoUnico = parser.getText();
                                    if (codigoUnico != null && (codigoUnico == 'FAN_ATT_000049' || codigoUnico == 'FAN_ATT_000050' || codigoUnico == 'FAN_ATT_000051' || codigoUnico == 'FAN_ATT_000052' || codigoUnico == 'FAN_ATT_000053' || codigoUnico == 'FAN_ATT_000054')){
                                        valor = null;
                                        printDebug('Encontre el tag: ' + codigoUnico);
                                        Boolean eoa = false;
                                        while (parser.nextToken() != null && !eos && !eoa) {
                                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'value__c')) {
                                                printDebug('... campo: value__c');
                                                if (parser.nextValue() != null) {
                                                    valor = parser.getText();
                                                    printDebug('... valor del campo value__c --> ' + valor);
                                                    if (codigoUnico == 'FAN_ATT_000049') {
                                                        loferta.cantMaxLineasTotal = valor;
                                                        eoa = true;    
                                                    }
                                                    else if (codigoUnico == 'FAN_ATT_000050') {
                                                        loferta.cantMaxLineasOnNet = valor;    
                                                        eoa = true;    
                                                    }    
                                                    else if (codigoUnico == 'FAN_ATT_000051') {
                                                        loferta.cantMaxLineasOffNet = valor;    
                                                        eoa = true;    
                                                    }    
                                                    else if (codigoUnico == 'FAN_ATT_000052') {
                                                        loferta.cantMaxLineasDDI = valor;    
                                                        eoa = true;    
                                                    }    
                                                    else if (codigoUnico == 'FAN_ATT_000053') {
                                                        loferta.cantMaxLineasFijas = valor;    
                                                        eoa = true;    
                                                    }    
                                                    else if (codigoUnico == 'FAN_ATT_000054') {
                                                        loferta.cantMaxLineasMoviles = valor;    
                                                        eoa = true;    
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
        }
        return loferta;
    }


    /**
     * Esta funcion obtiene el rootItemId del Asset buscandolo por subscritorId.
     */
    private static Asset getRootItemIdBySubscriptorId (String pSubscritorId) {
        printDebug('Entre a getRootItemIdBySubscriptorId()');
        String accountId = null;
        
        if (String.isBlank(pSubscritorId)) {
            printDebug(' ---- El pSubscritorId vino vacio');
            throw new CalloutException('El pSubscritorId vino vacio');
        }

        try {
            List<Asset> asset = [SELECT vlocity_cmt__RootItemId__c, Subscription_Id__c FROM Asset WHERE Subscription_Id__c = :pSubscritorId];
            if (asset.size()>0) {
                return asset.get(0);
            }
            else {
                throw new FunctionalException('Error al obtener el RootItemId del subscriptionId: ' + pSubscritorId);
            }
        }
        catch (Exception e) {
            printDebug(' ---- Error al obtener el RootItemId del subscriptionId: ' + pSubscritorId + '. Error: ' + e.getMessage());
            throw new FunctionalException('Error al obtener el RootItemId del subscriptionId: ' + pSubscritorId + '. Error: ' + e.getMessage());
        }    
    }

    /**
     * Esta funcion obtiene el rootItemId del Asset buscandolo por MSISDN.
     */
    private static Asset getRootItemIdByMSISDN (String pNroLinea) {
        printDebug('Entre a getRootItemIdByMSISDN()');
        String accountId = null;

        if (String.isBlank(pNroLinea)) {
            printDebug(' ---- El pNroLinea vino vacio');
            throw new CalloutException('El pNroLinea vino vacio');
        }
        
        try {
            List<Asset> asset = [SELECT vlocity_cmt__RootItemId__c, Subscription_Id__c FROM Asset WHERE MSISDN__c = :pNroLinea];
            if (asset.size()>0) {
                return asset.get(0);
            }
            else {
                throw new FunctionalException('Error al obtener el RootItemId del MSISDN: ' + pNroLinea);
            }
        }
        catch (Exception e) {
            printDebug(' --- Error al obtener el RootItemId del MSISDN: ' + pNroLinea + '. Error: ' + e.getMessage());
            throw new FunctionalException('Error al obtener el RootItemId del MSISDN: ' + pNroLinea + '. Error: ' + e.getMessage());
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
     * Objetivo: Verificar que se cumpla el contrato.
     * Si lo cumple termina y sino dispara la excepción: CalloutException.
     */
    private static void checkContrato (FromJSON pJson) {
        printDebug('Entre a checkContrato()');

        if (pJson == null) {
            printDebug('El json vino vacio o nulo'); 
            throw new CalloutException('Error en la validacion de los atributos del request. Vino vacio.');
        }

        String subscriberId = pJson.choiceId.subscriberId;
        String nroLinea = pJson.choiceId.nroLinea;

        if (String.isBlank(subscriberId) && String.isBlank(nroLinea)) {
            printDebug('El subscriber y el nroLinea no vinieron o estan vacios, como es un choice alguno tiene que venir con valor'); 
            throw new CalloutException('Error en la validacion de los atributos del request. El choice vino vacio y debe contener al menos uno de los dos datos [subscriberId o nroLinea]');
        }
    }

    /**
     * Wrapper del System.debug(o)
     */
    private static void printDebug(String pMensaje) {
        if (K_DEBUG_ON) {
            System.debug(pMensaje);
        }
    }

    /**
     * Objetivo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
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

    //-- Estructura de parametros de entrada --
    private class FromJSON {
        public ChoiceClass choiceId;
    }

    private class ChoiceClass {
        public String subscriberId;
        public String nroLinea;
    }

    //-- Estructura de respuesta --
    private class ToJson {
        public List<ToJsonOferta> lstOfertas;
        public String subscriberId;
        public ToJson() {
            lstOfertas = new List<ToJsonOferta>();
        }
    }

    private class ToJsonOferta {
        public List<ToJsonLinea> lstLineas;
        public String tipoServicio;
        public String ofertaId;
        public String cantMaxLineasFijas;
        public String cantMaxLineasDDI;
        public String cantMaxLineasTotal;
        public String cantMaxLineasOffNet;
        public String cantMaxLineasOnNet;
        public String cantMaxLineasMoviles;

        public ToJsonOferta () {
            lstLineas = new List<ToJsonLinea>();
        }
    }

    private class ToJsonLinea {
        public String assetId;
        public String tipo;
        public String nroLinea;
    }
    

}