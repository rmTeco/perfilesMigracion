global with sharing class taCpqAppHandler implements vlocity_cmt.VlocityOpenInterface2{

    public String maxDownstream;
    public String voiceService;
    public Boolean prefaMade = false;

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        Boolean result = true; 
        try
        {
            if(methodName.equals('getCartsProducts')){
                getCartsProducts(methodName, input, outMap, options);
            }
            if(methodName.equals('processPrefaResult')){
                processPrefaResult(methodName, input, outMap, options);
            }
            if(methodName.equals('getCartsProductsById')){
                getCartsProductsById(methodName, input, outMap, options);
            }
        }
        catch(Exception e)
        {
            System.debug('taCpqAppHandler:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    public void getCartsProductsById(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        System.debug('getCartsProductsById');
        try
        {
            String idOrder = (String) input.get('cartId');
            vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
             System.debug('methodName : '+methodName+' input: '+input+' outMap: '+outMap+' options: '+options);
            Object cpqAppHandlerReturn = cpqAppHandler.invokeMethod(methodName, input, outMap, options);
            System.debug('outMap : '+outMap);
            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)outMap.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT);
            List<vlocity_cmt.JSONRecord> pbeList  =  (List<vlocity_cmt.JSONRecord>)result.records;

            Map<String, Decimal> standardPricesById = new Map<String, Decimal>();
            Map<String, Decimal> listPricesById = new Map<String, Decimal>();
            Map<String, Decimal> oneTimeById = new Map<String, Decimal>();
            Set<Id> queryIds = new Set<Id>();
            for(vlocity_cmt.JSONRecord record: pbeList){
                Product2 product2Fields = (product2)record.fields.get('Product2');
                Product2 prod = [SELECT vlocity_cmt__JSONAttribute__c FROM Product2 WHERE Id = :product2Fields.Id];
                    product2Fields.vlocity_cmt__JSONAttribute__c = prod.vlocity_cmt__JSONAttribute__c;
                    record.fields.put('Product2', product2Fields);
                if(product2Fields.Family != null && product2Fields.Family == 'Internet'){
                    standardPricesById.put(product2Fields.Id, null);
                    queryIds.add(product2Fields.Id);
                }
                if(product2Fields.Family != null && product2Fields.Family == 'Movil' && product2Fields.vlocity_cmt__Type__c == 'Dispositivo'){
                    system.debug('Cp Check'+product2Fields.Family+ '-Id' +product2Fields.Id);
                    listPricesById.put(product2Fields.Id, null);
                    oneTimeById.put(product2Fields.Id, null);
                    queryIds.add(product2Fields.Id);
                }
                
                if(product2Fields.Family != null && product2Fields.Family == 'Movil'){
                    System.debug('queryIds.add Movil Family ById');
                    queryIds.add(product2Fields.Id);
                }
            }
            system.debug('Cp Check queryIds'+ queryIds);
            if(queryIds.size() > 0){
                Pricebook2 pb2 = [SELECT Id, Name, IsActive FROM PriceBook2 WHERE IsStandard=True LIMIT 1];
                system.debug('Cp Check queryIds'+ queryIds);
                List<PriceBookEntry> entries = [SELECT Product2Id, vlocity_cmt__RecurringPrice__c, UnitPrice, OneTime_Price_w_o_VAT__c FROM PriceBookEntry WHERE Product2Id IN :queryIds];
                system.debug('entries'+entries);
                for(PriceBookEntry entry: entries){
                    standardPricesById.put(entry.Product2Id, entry.vlocity_cmt__RecurringPrice__c);
                    listPricesById.put(entry.Product2Id, entry.UnitPrice);
                    oneTimeById.put(entry.Product2Id, entry.OneTime_Price_w_o_VAT__c);
                }
                for(vlocity_cmt.JSONRecord record: pbeList){
                    Product2 product2Fields = (product2)record.fields.get('Product2');
                    if(product2Fields.Family == 'Internet'){
                        Decimal recurring = standardPricesById.get(product2Fields.Id);
                        if(recurring != null){
                            Map<String, Object> recPrice = new Map<String, Object>();
                            recPrice.put('label', 'Standard Recurring');
                            recPrice.put('value', recurring);
                            record.fields.put('StandardRecurring', recPrice);
                        }
                    }else if(product2Fields.Family == 'Movil' && product2Fields.vlocity_cmt__Type__c == 'Dispositivo'){
                        Decimal listprice = listPricesById.get(product2Fields.Id);
                        Map<String, Object> lPrice = new Map<String, Object>();
                        lPrice.put('label', 'List Price');
                        lPrice.put('value', listprice == null ? 0 : listprice);
                        record.fields.put('ListPrice', lPrice);

                        Decimal onetime = oneTimeById.get(product2Fields.Id);
                        Map<String, Object> otPrice = new Map<String, Object>();
                        otPrice.put('label', 'OneTime Price');
                        otPrice.put('value', onetime == null ? 0 : onetime);
                        record.fields.put('OneTimePrice', otPrice);
                    }else if(product2Fields.Family == 'Movil'){
                        System.debug('getCartsProductsById: Movil SMS QUANTITY');
                        /*Need SMS Saliente, Voz Saliente, Datos Salientes to Show Details*/
                        Map<String, Object> smsQt = new Map<String, Object>();
                        smsQt.put('label', 'Quantity');
                        smsQt.put('value', '3000');
                        record.fields.put('SMSQuantity', smsQt);
                    }
                    
                }

                System.debug('Print pbeList:');
                System.debug(pbeList);
                result.records = pbeList;
            }

            updateCartProductById(outMap, idOrder);
        }
        catch(Exception ex)
        {
            throw ex;
        }

    }

    private void updateCartProductById(Map<String, Object> outMap, String idOrder)
    {
        System.debug('updateCartProductById');
        String responseBody;
        try
        {
            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult) outMap.get('result');
            List<vlocity_cmt.JSONRecord> recordsResult = new List<vlocity_cmt.JSONRecord>();

            for (vlocity_cmt.JSONRecord p : result.records)
            {
                //System.debug('records: ' + p);
                recordsResult.add(p);
                Map<String, Object> product = (Map<String, Object>)p.fields.get('ProductCode');
                if (product != null)
                {
                    System.debug('product: ' + product);
                    String nmuCart = (String) product.get('value');
                    System.debug('nmuCart: ' + nmuCart);
                    List<String> stocks = GetStockCode(idOrder);
                    List<Object> existencias = GetExistences(idOrder, null, null, nmuCart, stocks);
                    Integer stockAmmount = getStock(nmuCart, existencias, stocks);
                    Map<String, Object> stock = new Map<String, Object>();
                    stock.put('Ammount', stockAmmount);
                    p.fields.put('Stock', stock);
                }
            }

            result.records = recordsResult;
        }
        catch(Exception e)
        {
            throw e;
        }

    }

    public static List<String> GetStockCode(String idOrder){
        /*PFTA-6033 */
        Order order = [SELECT Delivery_Method__c, vlocity_cmt__OriginatingChannel__c FROM Order where Id = :idOrder]; 
        String deliveryMethod = order.Delivery_Method__c;
        String channel = order.vlocity_cmt__OriginatingChannel__c;
        Map<string, Object> response = TaMatrixUtils.getStockAvailableCode(channel, deliveryMethod);
        String codStocks= (String) response.get('StockAvailableCode__StockAvailableCode');
        List<String> stocks = new List<String>();
        stocks = codStocks.split(',', 0);
        System.debug('RESPONSE getStockAvailableCode');
        System.debug('Codigo Tangible: ' + codStocks);        
        return stocks;
    }


    private List<Object> GetExistences(String idOrder, String codeMarc, String codFamProd, String nmuCart, List<String> stocks)
    {
        System.debug('GetExistences');
        try
        {
            List<Object> existencias = new List<Object>();
            Map<String,String> getPointOfSaleWarehouseResponse = taOrderController.GetPointOfSaleWarehouse(idOrder);
            String codPuntoDeVenta = getPointOfSaleWarehouseResponse.get('codPuntoDeVenta');
            String codDeposito = getPointOfSaleWarehouseResponse.get('codDeposito');
            Map<String, Object> jSonResponse;

            System.debug('LRO -- Cod Punto de Venta: ' + codPuntoDeVenta);
            System.debug('LRO -- Cod Deposito: ' + codDeposito);
            System.debug('LRO -- Cod Marc: ' + codeMarc);
            System.debug('LRO -- Cod Fam Prod: ' + codFamProd);
            System.debug('LRO -- NMU Cart: ' + nmuCart);
            System.debug('LRO -- Stocks: ' + stocks);

            //PFTA - 10326 - Se envia siempre punto de venta 0
            if (stocks.size() > 1)
                jSonResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad('0', codDeposito, codeMarc, codFamProd, nmuCart, null);
            else
                jSonResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad('0', codDeposito, codeMarc, codFamProd, nmuCart, stocks[0]);

            existencias = (List<Object>) jSonResponse.get('listaExistencias');
            return existencias;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    public void getCartsProducts(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            String idOrder = (String) input.get('cartId');
            String prefaResult = '120000';
            GetPrefaResult(idOrder);
            String query = (String) input.get('query');
            //input.put('query', null);
            //input.put('pagesize', '100');
            if(!Test.isRunningTest()){
                vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
                system.debug('input'+input+'methodName'+methodName+outMap+'options'+options);
                Object cpqAppHandlerReturn = cpqAppHandler.invokeMethod(methodName, input, outMap, options);
            } else {
                        outMap = MockupFactory.getCardsProductsTest();
                    }
            system.debug('outMap: ' + outMap);
            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)outMap.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT);
            List<vlocity_cmt.JSONRecord> pbeList  =  (List<vlocity_cmt.JSONRecord>)result.records;
            System.debug('pbeList: ' + pbeList);
            Map<String, Decimal> standardPricesById = new Map<String, Decimal>();
            Map<String, Decimal> listPricesById = new Map<String, Decimal>();
            Map<String, Decimal> oneTimeById = new Map<String, Decimal>();
            Set<Id> queryPriceListsEntry = new Set<Id>();
            Set<Id> queryIds = new Set<Id>();
            List<Id> prodIds = new List<Id>();
            for(vlocity_cmt.JSONRecord record: pbeList){
                Product2 product2Fields = (product2)record.fields.get('Product2');
                prodIds.add(product2Fields.Id);
            }
            Map<Id, Product2> jsonProducts = new Map<Id, Product2>([SELECT vlocity_cmt__JSONAttribute__c FROM Product2 WHERE Id IN :prodIds]);

            for(vlocity_cmt.JSONRecord record: pbeList){
                Product2 product2Fields = (product2)record.fields.get('Product2');
                Product2 jsonProd = jsonProducts.get(product2Fields.Id);
                product2Fields.vlocity_cmt__JSONAttribute__c = jsonProd.vlocity_cmt__JSONAttribute__c;
                record.fields.put('Product2', product2Fields);
                if(product2Fields.Family != null){
                    if(product2Fields.Family == 'Internet'){
                        standardPricesById.put(product2Fields.Id, null);
                        queryIds.add(product2Fields.Id);
                    }

                    if(product2Fields.Family == 'Movil' && product2Fields.vlocity_cmt__Type__c == 'Dispositivo'){
                        listPricesById.put(product2Fields.Id, null);
                        oneTimeById.put(product2Fields.Id, null);
                        queryIds.add(product2Fields.Id);
                    }

                    if(product2Fields.Family == 'Movil'){
                        queryIds.add(product2Fields.Id);
                    }

                }

                queryPriceListsEntry.add(product2Fields.Id);
            }

            //Se obtienen precios de lista
            if(queryPriceListsEntry.size() > 0){                
                Map<String, Decimal> priceListsById = new Map<String, Decimal>();
                system.debug('Cp Check');
                System.debug(queryPriceListsEntry);
                List<vlocity_cmt__PriceListEntry__c> priceListEntrys = [select vlocity_cmt__ProductId__c, vlocity_cmt__PricingElementId__r.vlocity_cmt__Amount__c from vlocity_cmt__PriceListEntry__c where vlocity_cmt__IsBasePrice__c=true AND vlocity_cmt__PricingElementId__r.vlocity_cmt__LoyaltyAmount__c=null AND vlocity_cmt__ProductId__c IN :queryPriceListsEntry];
                for(vlocity_cmt__PriceListEntry__c priceList: priceListEntrys){
                    System.debug(priceList.vlocity_cmt__ProductId__c);
                    System.debug(priceList.vlocity_cmt__PricingElementId__r.vlocity_cmt__Amount__c);
                    priceListsById.put(priceList.vlocity_cmt__ProductId__c, priceList.vlocity_cmt__PricingElementId__r.vlocity_cmt__Amount__c);
                }

                System.debug('priceListsById: ');
                System.debug(priceListsById);
                for(vlocity_cmt.JSONRecord record: pbeList){
                    Product2 product2Fields = (product2)record.fields.get('Product2');
                    Decimal ammount = priceListsById.get(product2Fields.Id);
                System.debug('ammount: ');
                System.debug(ammount);
                    Map<String, Object> otPriceJ = new Map<String, Object>();
                    otPriceJ.put('label', 'Price List Entry');
                    otPriceJ.put('value', ammount == null ? 0 : ammount);
                    record.fields.put('PricingElement', otPriceJ);
                }
            }

            if(queryIds.size() > 0){
                Pricebook2 pb2 = [SELECT Id, Name, IsActive FROM PriceBook2 WHERE IsStandard=True LIMIT 1];
                System.debug('Pricebook2');
                System.debug(pb2);
                List<PriceBookEntry> entries = [SELECT Product2Id, vlocity_cmt__RecurringPrice__c, UnitPrice, OneTime_Price_w_o_VAT__c FROM PriceBookEntry WHERE Product2Id IN :queryIds];
                System.debug('entries: '+entries);
                for(PriceBookEntry entry: entries){
                    standardPricesById.put(entry.Product2Id, entry.vlocity_cmt__RecurringPrice__c);
                    listPricesById.put(entry.Product2Id, entry.UnitPrice);
                    System.debug('entry data');
                    System.debug(entry.UnitPrice);
                    System.debug(entry.OneTime_Price_w_o_VAT__c);
                    System.debug(entry.Product2Id);
                    oneTimeById.put(entry.Product2Id, entry.OneTime_Price_w_o_VAT__c);
                }
                for(vlocity_cmt.JSONRecord record: pbeList){
                    Product2 product2Fields = (product2)record.fields.get('Product2');
                    if(product2Fields.Family == 'Internet'){
                        Decimal recurring = standardPricesById.get(product2Fields.Id);
                        if(recurring != null){
                            Map<String, Object> recPrice = new Map<String, Object>();
                            recPrice.put('label', 'Standard Recurring');
                            recPrice.put('value', recurring);
                            record.fields.put('StandardRecurring', recPrice);
                        }
                    }else if(product2Fields.Family == 'Movil' && product2Fields.vlocity_cmt__Type__c == 'Dispositivo'){
                        Decimal listprice = listPricesById.get(product2Fields.Id);
                        Map<String, Object> lPrice = new Map<String, Object>();
                        lPrice.put('label', 'List Price');
                        lPrice.put('value', listprice == null ? 0 : listprice);
                        record.fields.put('ListPrice', lPrice);

                        Decimal onetime = oneTimeById.get(product2Fields.Id);
                        Map<String, Object> otPrice = new Map<String, Object>();
                        System.debug('PRINT ONETIME: ');
                        System.debug(onetime);
                        otPrice.put('label', 'OneTime Price');
                        otPrice.put('value', onetime == null ? 0 : onetime);
                        record.fields.put('OneTimePrice', otPrice);
                    }                    
                }
                System.debug('pbeList');
                System.debug(pbeList);
                result.records = pbeList;
            }
            List<String> stocks = GetStockCode(idOrder);
            List<Object> existencias = GetExistences(idOrder, null, null, null, stocks);
            updateCartsProducts(outMap, existencias, query, prefaResult, stocks);
        }
        catch(Exception ex)
        {
            throw ex;
        }

    }

    private void GetPrefaResult(String idOrder)
    {
        System.debug('GetPrefaResult');
        try
        {
            maxDownstream = null;
            voiceService = null;
            Order order = [SELECT PrefeasibilityResult__c FROM Order where Id = :idOrder];
            if (order.PrefeasibilityResult__c != null)
            {
                System.debug('order.PrefeasibilityResult__c: ' + order.PrefeasibilityResult__c);
                prefaMade = true;
                Map<String, Object> prefa = (Map<String, Object>) JSON.deserializeUntyped(order.PrefeasibilityResult__c);
                System.debug('prefa: ' + prefa);
                List<Object> accesTechs = (List<Object>) prefa.get('tecnologiasAcceso');
                PrefeasibilityFilter (accesTechs);
            }
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    public void PrefeasibilityFilter (List<Object> accesTechs){
        try{
            Integer maxDownstreamInt = 0;
            voiceService = 'NO';

            for (Object t : accesTechs){
                Map<string, Object> technology = (Map<string, Object>) t;
                String tecnologia = (String) technology.get('tecnologia');
                List<Object> services = (List<Object>) technology.get('servicios');
                String codigoMensaje = (String) technology.get('codigoMensaje');
                for (Object  s : services){
                    String serviceType = (string)(((Map<string,Object>)s).get('servicio'));
                    Map<string,object> service = (Map<string,Object>) s;
                    List<object> technicalStandards = (List<object>) service.get('standardsTecnico');
                    for(Object ts : technicalStandards){
                        Map<string,Object> techStandard = (Map<string,Object>) ts;
                        String disponibilidad = (string) techStandard.get('disponibilidad');
                        
                        if(disponibilidad == 'F'){
                            disponibilidad = TaMatrixUtils.checkPrefa(codigoMensaje, tecnologia, serviceType);
                        }
                        
                        if(serviceType=='Internet'){
                            string medicionDeBajada = String.valueof(techStandard.get('medicionDeBajada'));
                            if(String.isNotBlank(medicionDeBajada) && disponibilidad == 'SI'){
                                Integer downstream = Integer.valueOf(medicionDeBajada);
                                if(downstream > maxDownstreamInt)
                                    maxDownstreamInt = downstream;
                            }
                        }
                        if(serviceType=='Voz'){
                            if(disponibilidad == 'SI'){
                                voiceService = 'SI';
                            }
                        }
                    }
                }
            }

            maxDownstream = String.valueof(maxDownstreamInt);
        }
        catch(Exception e){
            throw e;
        }
    }

    public void processPrefaResult(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        List<Object> result = new List<Object>();
        //Get CategoryService (Internet)
        String categoryService; //TODO
        //get prefa
        Map<String, Object> prefa = new Map<String, Object>();//TODO
        List<Object> accesTechs = (List<Object>) prefa.get('tecnologiasAcceso');
        for (Object t : accesTechs){
            Map<string, Object> technology = (Map<string, Object>) t;
            String tecnologia = (String) technology.get('tecnologia');
            List<Object> services = (List<Object>) technology.get('servicios');
            String codigoMensaje = (String) technology.get('codigoMensaje');
            for (Object  s : services){
                String serviceType = (string)(((Map<string,Object>)s).get('servicio'));
                Map<string,object> service = (Map<string,Object>) s;
                List<object> technicalStandards = (List<object>) service.get('standardsTecnico');
                for(Object ts : technicalStandards){
                    Map<string,Object> techStandard = (Map<string,Object>) ts;
                    String disponibilidad = (string) techStandard.get('disponibilidad');
                    
                    if(disponibilidad == 'F'){
                        disponibilidad = TaMatrixUtils.checkPrefa(codigoMensaje, tecnologia, serviceType);
                    }
                    
                    if(serviceType == categoryService && disponibilidad == 'SI'){
                        Map<String, String> node = new Map<String, String>();
                        node.put('Tecnologia', String.valueof(techStandard.get('standardTecnico')));
                        String standardTecnico = String.valueof(techStandard.get('standardTecnico'));
                        if(serviceType == 'Internet'){
                            node.put('Categoria', 'Internet + Voz');
                        }else{
                            node.put('Categoria', serviceType);
                        }
                        node.put('Acceso', tecnologia);
                        result.add(node);
                    }
                }
            }
        }
        outMap.put('Result', result);
    }

    /* CODE COMMENTED BECUASE NOW WE ARE CALLING A SERVICE (IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad)
     * THAT HANDLES THE FUNCTIONALITY.
     * TO BE ERASED AFTER THE SERVICE CALL IS FULLY DEVELOPED AND TESTED
     *
    private String invokeStockService()
    {
        String responseBody;
        try
        {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://demo9538567.mockable.io/getAvailability');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            request.setBody('{"name":"mighty moose"}');
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if (response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
            } else {
                responseBody = response.getBody();
            }

            return responseBody;
        }
        catch(Exception e)
        {
            throw e;
        }
    }
    */

    private void updateCartsProducts(Map<String, Object> outMap, List<Object> existencias, String query, String prefaResult, List<String> stocks)
    {
        System.debug('updateCartsProducts');
        String responseBody;
        try
        {
            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult) outMap.get('result');

            System.debug('result: ' + result);

            List<vlocity_cmt.JSONRecord> recordsResult = new List<vlocity_cmt.JSONRecord>();

            for (vlocity_cmt.JSONRecord p : result.records)
            {
                //System.debug('records: ' + p);
                p.fields.put('PrefaMade', prefaMade);
                if (!(String.isNotBlank(query) && filterRecord(p,query)))
                {
                    recordsResult.add(p);
                    Map<String, Object> product = (Map<String, Object>)p.fields.get('ProductCode');
                    if (product != null)
                    {
                        System.debug('product: ' + product);
                        String nmuCart = (String) product.get('value');
                        System.debug('nmuCart: ' + nmuCart);
                        Integer stockAmmount = getStock(nmuCart, existencias, stocks);

                        System.debug('stockAmmount: ' + stockAmmount);

                        Map<String, Object> stock = new Map<String, Object>();
                        stock.put('Ammount', stockAmmount);

                        p.fields.put('Stock', stock);
                    }
                }
            }

            result.records = recordsResult;

            //BAF & Voice filter
            if (prefaMade)
            {
                recordsResult = new List<vlocity_cmt.JSONRecord>();
                for (vlocity_cmt.JSONRecord p : result.records)
                {
                    System.debug('records: ' + p);
                    if (!filterPrefaRecord(p))
                    {
                        recordsResult.add(p);
                    }
                }
                result.records = recordsResult;
            }
            system.debug('final list '+ result);
        }
        catch(Exception e)
        {
            throw e;
        }

    }

    private Integer getStock(String nmuCart, List<Object> existencias, List<String> stocksCode)
    {
        System.debug('getStock');
        System.debug('existencias: ' + existencias);
        System.debug('LRO -- NMU Cart: ' + nmuCart);
        Integer stockAmmount = 0;
        try
        {
            Boolean nmuFound = false;
            Integer nmuCount = 0;
            while (!nmuFound && nmuCount < existencias.size())
            {
                Map<String, Object> producto = (Map<String, Object>) existencias[nmuCount];
                System.debug('producto: ' + producto);
                String NMU = (String) producto.get('codNMU');
                System.debug('NMU: ' + NMU);

                if (nmuCart == NMU)
                {
                    nmuFound = true;
                    List<Object> stocks = (List<Object>)producto.get('ListaPorCodigoStock');
                    System.debug('stocks: ' + stocks);
                    Boolean stockFound = false;
                    Integer stockCount = 0;
                    while (!stockFound && stockCount < stocks.size())
                    {
                        Map<String, Object> stock = (Map<String, Object>) stocks[stockCount];
                        System.debug('stock: ' + stock);
                        String codigoStock = (String) stock.get('stockProducto');
                        System.debug('codigoStock: ' + codigoStock);
                        /* PFTA-6033 PARA SUMAR TODOS LOS STOCKS  */ 
                        Set<String> setStocksCode = new Set<String>(stocksCode);
                        System.debug(setStocksCode);
                        if (setStocksCode.contains(codigoStock)) {
                             stockAmmount += integer.valueof(stock.get('CantidadDisponible'));
                             System.debug('stockAmmount: ' + stockAmmount);
                        }
                       /* if (codigoStock == 'MTPL')
                        {
                            stockAmmount = integer.valueof(stock.get('CantidadDisponible'));
                            System.debug('stockAmmount: ' + stockAmmount);
                            stockFound = true;
                        }*/
                        stockCount++;
                    }
                }
                nmuCount++;
            }
            System.debug('Final: ' + stockAmmount);
            return stockAmmount;
        }
        catch(Exception e)
        {
            throw e;
            //return 0;
        }

    }

    private Boolean filterRecord(vlocity_cmt.JSONRecord record, String query)
    {
        System.debug('filterRecord');
        try
        {
            String productCode = '';
            String description = '';
            String type = '';
            String brand = '';
            Map<String, Object> nameNode = (Map<String, Object>)record.fields.get('Name');
            String name = (String) nameNode.get('value');
            System.debug('name: ' + name);
            Map<String, Object> productCodeNode = (Map<String, Object>)record.fields.get('ProductCode');

            if (productCodeNode != null)
            {
                productCode = (String) productCodeNode.get('value');
                System.debug('productCode: ' + productCode);
            }

            Map<String, Object> priceNode = (Map<String, Object>)record.fields.get('UnitPrice');
            //Decimal priceD = (Decimal) priceNode.get('value');
            //String price = String.valueOf(priceD);
            String price = (String) priceNode.get('value');
            System.debug('price: ' + price);

            Product2 product2 = (Product2)record.fields.get('Product2');

            if (product2.Description != null)
            {
                description = product2.Description;
                System.debug('description: ' + description);
            }

            if (product2.Tipo_de_Bien_de_Uso__c != null)
            {
                type = product2.Tipo_de_Bien_de_Uso__c;
                System.debug('type: ' + type);
            }

            if (product2.Marca__c != null)
            {
                brand = product2.Marca__c;
                System.debug('brand: ' + brand);
            }

            if (name.containsIgnoreCase(query) || price.containsIgnoreCase(query)
                    || description.containsIgnoreCase(query) || productCode.containsIgnoreCase(query)
                    || type.containsIgnoreCase(query) || brand.containsIgnoreCase(query))
            {
                System.debug('filterRecord = false');
                return false;
            }
            else
            {
                vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)record.nameResult.get('childProducts');
                System.debug('result: ' + result);
                if (result == null)
                {
                    System.debug('sin hijos');
                    System.debug('filterRecord = true');
                    return true;
                }
                else
                {
                    Integer i = 0;
                    Boolean continueLoop = true;
                    while (continueLoop && i < result.records.size())
                    {
                        continueLoop = filterRecord(result.records[i], query);
                        i++;
                    }
                    return continueLoop;
                }
            }
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    private Boolean filterPrefaRecord(vlocity_cmt.JSONRecord record)
    {
        System.debug('filterPrefaRecord');
        try
        {
            String prefaResult = '';
            Product2 product2 = (Product2)record.fields.get('Product2');

            if (product2.vlocity_cmt__HelpText__c != null)
            {
                prefaResult = product2.vlocity_cmt__HelpText__c;
                System.debug('prefaResult: ' + prefaResult);
            }

            if (String.isNotBlank(prefaResult))//El producto es BAF o Voz
            {
                if (prefaResult == 'Voz')//Es un producto de voz
                {
                    if(voiceService == 'NO') return true;//Si la no tiene disponibilidad de Voz
                }
                if (Integer.valueOf(prefaResult) > Integer.valueOf(maxDownstream))
                {
                    return true;
                }
            }

            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)record.nameResult.get('childProducts');
            System.debug('result: ' + result);
            if (result == null)
            {
                System.debug('sin hijos');
                System.debug('filterRecord = false');
                return false;
            }
            else
            {
                Integer i = 0;
                Boolean continueLoop = true;
                Boolean filterResult = false;
                while (continueLoop && i < result.records.size())
                {
                    filterResult = filterPrefaRecord(result.records[i]);
                    continueLoop = !filterResult;
                    i++;
                }
                return filterResult;
            }
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    public static String CreateOrder(List<Map<String, Object>> inputFields){ 
        try{
            String methodName = 'createCart';

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> outMap = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            input.put('objectType', 'Order');
            input.put('fields','Id');
            input.put('subaction','createOrder');
            input.put('inputFields', inputFields);

            vlocity_cmt.CpqAppHandler cpqHandler = new vlocity_cmt.CpqAppHandler();
            cpqHandler.invokeMethod(methodName, input, outMap, options);
            
            System.debug('taCpqAppHandler outMap: ' + outMap);

            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult) outMap.get('result');

            return (String) result.records[0].fields.get('Id');
        } catch(Exception ex){
            throw ex;
        }
    }

    public static String AddItemToOrder(String priceBookEntryId, String orderId){
        try{
            String methodName = 'postCartsItems';

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> outMap = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            List<Map<String, Object>> lstPriceBookEntry = new List<Map<String, Object>>();

            Map<String, Object> tempMapEntry = new Map<String, Object>();
            tempMapEntry.put('itemId', priceBookEntryId);

            lstPriceBookEntry.add(tempMapEntry);

            input.put('items', lstPriceBookEntry);
            input.put('cartId', orderId);

            vlocity_cmt.CpqAppHandler cpqHandler = new vlocity_cmt.CpqAppHandler();
            cpqHandler.invokeMethod(methodName, input, outMap, options);

            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult) outMap.get('result');
            vlocity_cmt.JSONMessage jsonMessage = result.messages[0];

            if(jsonMessage.message != null && jsonMessage.message != ''){
                if(jsonMessage.message.equals('Successfully added.')){
                    vlocity_cmt.JSONRecord jsonRecord = result.records[0];
                    Map<String,vlocity_cmt.JSONAction> jsonAction = jsonRecord.actions;
                    vlocity_cmt.JSONAction addtocart = jsonAction.get('addtocart');

                    vlocity_cmt.JSONAction.JSONRemoteAction remote = addtocart.remote;
                    Map<String, Object>  items = remote.params;
                    Object arrItems = items.get('items');
                    List<Map<String, Object>> retItemList = (List<Map<String, Object>>) arrItems;
                    
                    return (String) retItemList[0].get('parentId');
                }
            }

            return null;
        } catch(Exception ex){
            throw ex;
        }
    }

    public static Boolean RemoveOrderItem(String itemId, String orderId){
        try{
            String methodName = 'deleteCartsItems';

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> outMap = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            input.put('id', itemId);
            input.put('cartId', orderId);
            //input.put('methodName', methodName);

            vlocity_cmt.CpqAppHandler cpqHandler = new vlocity_cmt.CpqAppHandler();
            cpqHandler.invokeMethod(methodName, input, outMap, options);

            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult) outMap.get('result');
            vlocity_cmt.JSONMessage jsonMessage = result.messages[0];

            if(jsonMessage.message != null && jsonMessage.message != '')
                if(jsonMessage.message.equals('Successfully deleted.')){
                    return true;
                } else{
                    throw new FuncException(jsonMessage.message);
                }

            return false;
        } catch(Exception ex){
            throw ex;
        }
    }

}