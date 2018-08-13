global with sharing class ta_sales_renovacionDatos implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('GetAvailableOffers')){
                GetAvailableOffers(inputMap, outMap, options);
            }
            if (methodName.equals('EnviarSMSExito')){
                EnviarSMSExito(inputMap, outMap, options);
            }
            if (methodName.equals('AddSelectedPack')){
                AddSelectedPack(inputMap, outMap, options);
            }
            result = false;
            //System.debug('outMap:' + outMap);
        }
        catch(Exception e)
        {
            System.debug('ta_sales_renovacionDatos:invokeMethod -> exception: '+e);
            throw e;
            //result = false;
        }
        return result;
    }
    
    public static void GetAvailableOffers(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        String cellNumber = (String) inputMap.get('nroLinea');
        //Modificado 27/03/18 por Mariano Hernández vlocity_cmt__LineNumber__c por MSISDN__c
        Asset ast = [SELECT AccountId FROM Asset WHERE MSISDN__c =: cellNumber LIMIT 1];

        String body = '{"idCliente" : "'+ast.AccountId+'","choiceId": {"nroLinea" : "'+cellNumber+'"},"codCanal" : "IVR"}';
        System.debug(body);
        
        IFS_S445_getAvailableOffers_cls.ResultObj resultObj = IFS_S445_getAvailableOffers_cls.getAvailableOffers(body);
        Map<String, Object> result = new Map<String,Object>();
        if (!Test.isRunningTest()) {
            result = (Map<String, Object>) JSON.deserializeUntyped(resultObj.resultMessage.toString());
        } else {
            result.put('lstOferta','Reseteo');
            Order orderTest = [SELECT Id FROM Order LIMIT 1];
            result.put('orderId',orderTest.Id);
        }
        System.debug('El resultado es:' + result);
        
        Object m = result.get('lstOferta');
        String cadena = String.valueOf(m);
        if(cadena.contains('Reseteo')){
            System.debug('contiene Reseteo');
        }

        Id orderId = (Id) result.get('orderId');
        Order order = new Order(Id = orderId, Gestion__c = 'Reseteo de Cuota');
        update order;

        outMap.put('accountId', ast.AccountId);
        outMap.put('Products', result);
    }     
    
    public static void EnviarSMSExito(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        system.debug('EnviarSMSExito');
        String cellNumber = (String) inputMap.get('nroLinea');
        system.debug(cellNumber);
        Map < String, String > variables = new Map < String, String > ();
        Boolean SMSsendStatus = taSalesSMSInteraction.sendSMSTemplate(cellNumber, 'Renovacion de datos Exitosa', variables);
    }

    public static void AddSelectedPack(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        System.debug('AddSelectedPack');
        
        List<Object> selectedCombo = (List<Object>) options.get('SelectedCombo');
        String idOrder = (String) options.get('IdOrder');
        
        Id priceBookEntryId;
        for(Object combo : selectedCombo) {
            Map<String, Object> comboSelected = (Map<String, Object>) combo;
            if(comboSelected.get('vlcSelected') == true) {
                priceBookEntryId = (Id) comboSelected.get('idListaPrecio');
            }
        }

        OrderItem item;
        List<OrderItem> itemList = [SELECT Id, PricebookEntryId FROM OrderItem WHERE OrderId = :idOrder];
        if (itemList.size() > 0) item = itemList.get(0);

        if(item != null && item.PricebookEntryId != priceBookEntryId)
        {
            Map<String, Object> inputMapAPI = new Map<String, Object>();
            inputMapAPI.put('cartId',idOrder);
            inputMapAPI.put('Id',item.Id);
            Map<String, Object> responseAPI = taOrderController.deleteCartItem(inputMapAPI);
            //outMap.put('AddItemToCart_DeleteItemResponse',responseAPI);
        }

        if(item == null || item.PricebookEntryId != priceBookEntryId)
        {
            Map<String, Object> inputMapAPI = new Map<String, Object>();
            inputMapAPI.put('cartId',idOrder);
            inputMapAPI.put('itemId',priceBookEntryId);
            Map<String, Object> responseAPI = taOrderController.addToCartItems(inputMapAPI);
            /*
            Map<String, Object> responseAPIResult = (Map<String, Object>) responseAPI.get('result');
            List<Object> responseAPIResultList = (List<Object>) responseAPIResult.get('messages');
            outMap.put('AddItemToCart_AddItemResponse',responseAPIResultList.get(0));
            */
        }
    }

    public static void ChangeSubOffering(String idOrder, String medioDePago, OrderItem item){
        System.debug('Change Sub Offering');
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();

        input = GenerateRequestS210(medioDePago, item);
        
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        integProcServ.invokeMethod('IFS_S210', input, output, options2);
        
        System.debug('response_S210: ' + output);
        Map<String,Object> ipResult = (Map<String,Object>)output.get('IPResult');
        //COMO EL SERVICIO NO ESTA CONFIGURADO, SE PASA OTRO RESULTADO PARA PODER VER LA FUNCIONALIDAD
        //ipResult = '{"listaModificaOferta": [{"fechaVigenciaHastaProdAdq": "201711010000","fechaVigenciaDesdeProdAdq": "201701010000","producto": {"codProducto": 1837006933}}]}';
        
        String orderStatus;
            if (ipResult.containsKey('Error')) {
                orderStatus = 'Draft';
            } else {
                orderStatus = 'Activated';
            }
        //}
        Order ord = new Order(Id = idOrder, Status = orderStatus);
        update ord;
    }

    private static Map<String, Object> GenerateRequestS210(String medioDePago, OrderItem item){
        System.debug('Generate Request S210');
        
        //String reqMock = '{"body": {"codigoAcceso": {"codSuscripcion": "152001012"},"ofertaPrincipal": {"ofertaPrincipalAnterior": {"producto": {"codProducto": 1078}},"nuevaOfertaPrincipal": {"producto": {"codProducto": 1837006933},"codGranularidadProducto": "S","tipoAplicacionOferta": "I","estadoProductoAdq": "2","listaInstanciaProducto": [{"codProducto": 1053,"marcaProductoPrincipal": "A","codGranularidadProducto": "S","tipoRed": "0"}]},"tiempoEfectivo": {"ejecucionCambio": "I"}}}}';
        Map<String, Object> body = new Map<String, Object>();
        Map<String, Object> codigoAcceso = new Map<String, Object>();
                
        Map<String, Object> ofertaComplementaria = new Map<String, Object>();
        List<Object> listaAgregoOferta = new List<Object>();
        Map<String, Object> auxMapListaAgregoOferta = new Map<String, Object>();
        Map<String, Object> instanciaOferta = new Map<String, Object>();
        Map<String, Object> producto = new Map<String, Object>();

        if(item.Product2 != null) {   System.debug('product......' + item.Product2.Id);
            String codProducto = item.Product2.ProductCode;
            String jsonAttribute = item.Product2.vlocity_cmt__JSONAttribute__c;
                        
            //Get the offer Expiration Date from the JSON Attributes
            Map<String, Object> unitOfMeasureMap = AssetAttributesUtils.GetJSONAttribute(jsonAttribute, 'Unidad de Medida de Vigencia');    
            List<Object> defaultValuesList = (List<Object>)((Map<String, Object>)unitOfMeasureMap.get('attributeRunTimeInfo')).get('default');  
            Map<String, Object> valueMap = (Map<String, Object>) defaultValuesList.get(0);  
            String unitOfMeasure = (String) valueMap.get('value');  

            Map<String, Object> expirationMap = AssetAttributesUtils.GetJSONAttribute(jsonAttribute, 'Vigencia Activacion');    
            String expirationValue = (String)((Map<String, Object>)expirationMap.get('attributeRunTimeInfo')).get('default');   
            
            //With the Expiration and the Unit of Measure of expiration, calculate the expiration date
            DateTime activationDate = Datetime.now();
            Integer expirationValueInt = Integer.valueOf(expirationValue);  
            DateTime expirationDateTime;

            if(unitOfMeasure == 'H')
                expirationDateTime = activationDate.addHours(expirationValueInt);
            else if(unitOfMeasure == 'D')
                 expirationDateTime = activationDate.addDays(expirationValueInt);
            else if(unitOfMeasure == 'W')
                expirationDateTime = activationDate.addDays(expirationValueInt * 7);
            else
                expirationDateTime = activationDate.addMonths(expirationValueInt * 12);

            Date expirationDate = expirationDateTime.date();
            String formattedExpirationDateTime = string.valueOf(expirationDate) + ' 00:00:00';
            
            auxMapListaAgregoOferta.put('fechaHastaCaracteristicaProd', formattedExpirationDateTime);    

            Map<String, Object> tiempoEfectivo = new Map<String, Object>();
            tiempoEfectivo.put('ejecucionCambio', 'I');
            auxMapListaAgregoOferta.put('tiempoEfectivo', tiempoEfectivo);            
            
            listaAgregoOferta.add(auxMapListaAgregoOferta);
            ofertaComplementaria.put('listaAgregoOferta', listaAgregoOferta);   

            //Depending on the Payment Method selected, include data on the request or not
            if (medioDePago != 'Descuento de Saldo') {      
                List<Object> listaPropiedades = new List<Object>();
                Map<String, Object> auxMapListaPropiedades = new Map<String, Object>();
                auxMapListaPropiedades.put('fechaHastaCaracteristicaProd', formattedExpirationDateTime);
                auxMapListaPropiedades.put('valorCaracteristicaProducto', '0');
                auxMapListaPropiedades.put('tipoCaracteristicaProducto', '1');
                auxMapListaPropiedades.put('codCaracteristicaProducto', 'C_RC_OVERRIDE_PRICE');
                
                listaPropiedades.add(auxMapListaPropiedades);
                instanciaOferta.put('listaPropiedades', listaPropiedades);
            }
            //END DEPENDENCY

            //Get the offer Origin Id from the JSON Attributes <-- eliminado 06/jun
            //Map<String, Object> idOriginMap = AssetAttributesUtils.GetJSONAttribute(jsonAttribute, 'ID Sistema Origen');
            //String idOriginValue = (String)((Map<String, Object>)idOriginMap.get('attributeRunTimeInfo')).get('default');
            
            String idOriginValue = item.Product2.ID_Sistema_Origen__c;
            //Adding codProducto value
            producto.put('codProducto', idOriginValue);
            instanciaOferta.put('producto', producto);

            auxMapListaAgregoOferta.put('instanciaOferta', instanciaOferta);
            
            body.put('ofertaComplementaria', ofertaComplementaria);
        }

        if (item.vlocity_cmt__AssetId__r.Subscription_Id__c != null)
            codigoAcceso.put('codSuscripcion', item.vlocity_cmt__AssetId__r.Subscription_Id__c);
        else
            codigoAcceso.put('identificadorRecurso', item.vlocity_cmt__AssetId__r.MSISDN__c);
        
        body.put('codigoAcceso', codigoAcceso);

        Map<String, Object> request = new Map<String, Object>();
        request.put('body', body);
        System.debug('Request Body: ' + JSON.serialize(request));
        
        return request;
    }
}