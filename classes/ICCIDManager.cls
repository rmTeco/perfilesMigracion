global with sharing class ICCIDManager implements vlocity_cmt.VlocityOpenInterface{

    public static final String OPERATION_VENTA_NORMAL = 'VTAN';
    public static final String INSTANCE_RESERVA = 'RESERVA';
    public static final String INSTANCE_ANULAR_RESERVA = 'ANULARESERVA';
    public static final String STOCK_ORIGIN_NOAPLICA = 'NOAPLICA';

    public class WrapOrderItem {
            public String ICCID {get;set;}
            public String IMSI {get;set;}
            public String KI {get;set;}
            public String AduanaIngreso {get;set;}
            public String PaisOrigen {get;set;}
            public String CodOrdenDespacho {get;set;}
            public String Stock {get;set;}
            public Boolean Billeable {get;set;}
     
            public WrapOrderItem(String newICCID, String newIMSI, String newKI, String newAduanaIngreso, String newPaisOrigen, String newCodOrdenDespacho, String newStock, Boolean newBilleable) {
                ICCID = newICCID;
                IMSI = newIMSI;
                KI = newKI;
                AduanaIngreso = newAduanaIngreso;
                PaisOrigen = newPaisOrigen;
                CodOrdenDespacho = newCodOrdenDespacho;
                Stock = newStock;
                Billeable = newBilleable;
            }
        }

    global ICCIDManager() {    }
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try{
            if (methodName.equals('SerialAssingment')){
                SerialAssingment(inputMap, outMap, options);
            }
            if (methodName.equals('SerialReAssingment')){
                SerialReAssingment(inputMap, outMap, options);
            }
            if (methodName.equals('ConsultingStockAvailableCode')){
                ConsultingStockAvailableCode(inputMap, outMap, options);
            }
            if (methodName.equals('UpdateSalesInvoice')){
                UpdateSalesInvoice(inputMap, outMap, options);
            }
            result = false;  
        } 
        catch(Exception e){
            System.debug('ICCIDManager:invokeMethod -> exception: '+e);
            result = false;
            throw e;
        }
        return result;
    }

    private void SerialAssingment(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options){
        System.debug('SerialAssingment');
        Map<String, Map<String, Object>> nmusMap = new Map<String, Map<String, Object>>();
        Map<String,Object> serialNumbersToMove = new Map<String,Object>();
        List<Object> simcardsSerialNodes = new List<Object>();
        List<Object> nonSimcardsSerialNodes = new List<Object>();
        Map<String,Integer> nonSimcardsNMUs = new Map<String,Integer>();
        Map<String,Boolean> stocksBillable = new Map<String,Boolean>();
        Boolean reserveDone = false;
        Boolean nmusReserveFree = false;
        Boolean nmusAlreadyDeReserve = false;
        Boolean simcardsSerialsValidated = true;
        Boolean nonSimcardsSerialsValidated = true;
        String codPuntoDeVenta;
        String codDeposito;
        String orderNumber;
        Id orderId;
        try{
            Map<String, Object> order = (Map<String, Object>) options.get('Order');
            orderId = (Id) options.get('IdOrder');
            nmusAlreadyDeReserve = order.get('nmusAlreadyDeReserve') == null ? false : (Boolean) order.get('nmusAlreadyDeReserve');
            System.debug('orderId: ' + orderId);
            Map<String,String> getPointOfSaleWarehouseResponse = taOrderController.GetPointOfSaleWarehouse(orderId);
            codPuntoDeVenta = getPointOfSaleWarehouseResponse.get('codPuntoDeVenta');
            codDeposito = getPointOfSaleWarehouseResponse.get('codDeposito');
            Order dbOrder = [SELECT Delivery_Method__c, Gestion__c, OrderNumber FROM Order WHERE Id = :orderId LIMIT 1];
            Boolean cambioDeSim = (dbOrder.Gestion__c == 'Cambio de SIM' || dbOrder.Gestion__c == 'Cambio de SIM por siniestro');
            List<OrderItem> orderItems = taOrderController.GetOrderSerials(orderId);
            String deliveryMethod = dbOrder.Delivery_Method__c;
            orderNumber = dbOrder.OrderNumber;

            List<Object> serialList = new List<Object>();

            String stockProductoBK = null;
            // PFTA-7892
            System.debug('input: ' + JSON.serialize(inputMap));
            if(deliveryMethod == 'Store Pick Up')
            {
                Map<String,Object> stockAvailableCode = (Map<String,Object>) inputMap.get('StockAvailableCode_Response');
                if (stockAvailableCode == null)
                {
                    Map<String,Object> optionsAux = new Map<String,Object>();
                    Map<String,Object> outMapAux = new Map<String,Object>();
                    String channel = (String)((Map<String,Object>) inputMap.get('BillingOrder')).get('Channel');
                    optionsAux.put('Channel',channel);
                    optionsAux.put('DeliveryMethod',deliveryMethod);
                    ConsultingStockAvailableCode(null, outMapAux, optionsAux);
                    stockProductoBK = (String) outMapAux.get('StockAvailableCode');
                }
                else
                stockProductoBK = (String)((Map<String,Object>) inputMap.get('StockAvailableCode_Response')).get('StockAvailableCode');
            }
            System.debug('Stock ProductoBK: ' + stockProductoBK);
            List<String> listNmus;

            for(OrderItem item : orderItems){
                Map<String,Object> serialNode = new Map<String, Object>();
                serialNode.put('itemId', item.Id);
                serialNode.put('itemObj', item);
                serialNode.put('productName', item.Product2.Name);
                System.debug('OrderItemId' + item.Id);

                if (item.Product2.vlocity_cmt__Type__c == 'Simcard')
                {
                    System.debug('va por Simcard ' + serialNode);
                    if (listNmus == null)
                        listNmus = AssetAttributesUtils.GetJSONAttributePickListValues(item.vlocity_cmt__JSONAttribute__c, 'NMU Simcard');
                    simcardsSerialNodes.add(serialNode);
                    //Si habia seriales cargados, y no es cambio de sim, los guardo para liberar
                    if (String.isNotBlank(item.vlocity_cmt__SerialNumber__c) && !cambioDeSim)
                        taOrderController.addSerialToMove(serialNumbersToMove, item.vlocity_cmt__SerialNumber__c, OPERATION_VENTA_NORMAL, INSTANCE_ANULAR_RESERVA, item.FromStock__c, codDeposito, deliveryMethod);
                }
                else
                {
                    System.debug('va por no Simcard');
                    serialNode.put('productCode', item.Product2.NMU__c);
                    nonSimcardsSerialNodes.add(serialNode);
                    Integer nmuCant = nonSimcardsNMUs.get(item.Product2.NMU__c) != null ? (Integer) nonSimcardsNMUs.get(item.Product2.NMU__c) : 0;
                    nmuCant += 1;
                    nonSimcardsNMUs.put(item.Product2.NMU__c, nmuCant);
                    if (String.isNotBlank(item.vlocity_cmt__SerialNumber__c))//Si habia seriales cargados, los guardo para liberar
                        taOrderController.addSerialToMove(serialNumbersToMove, item.vlocity_cmt__SerialNumber__c, OPERATION_VENTA_NORMAL, INSTANCE_ANULAR_RESERVA, item.FromStock__c, codDeposito, deliveryMethod);
                }
                serialList.add(serialNode);
            }

            if (simcardsSerialNodes.size()> 0)
            {
                simcardsSerialsValidated = GetSimcardsSerials(listNmus, '0', codDeposito, stockProductoBK, simcardsSerialNodes);
                if (simcardsSerialsValidated)
                    UpdateSerialNodes(simcardsSerialNodes, serialNumbersToMove, nmusMap, codDeposito, deliveryMethod, stocksBillable);
            }
            if (nonSimcardsSerialNodes.size()> 0)
            {
                nonSimcardsSerialsValidated = GetSerialsTangibles(nonSimcardsNMUs, '0', codDeposito, stockProductoBK, nonSimcardsSerialNodes);
                if (nonSimcardsSerialsValidated)
                    UpdateSerialNodes(nonSimcardsSerialNodes, serialNumbersToMove, nmusMap, codDeposito, deliveryMethod, stocksBillable);
            }

            if (simcardsSerialsValidated || nonSimcardsSerialsValidated)
            {
                if(deliveryMethod == 'Presencial' || deliveryMethod == 'Store Pick Up')//Solo en estos casos se realiza la reserva
                {
                    if (serialNumbersToMove.KeySet().size() > 0)
                    {
                        Map<String, Object> newSerialNumbersForReserve = ClearStockOriginForReserves(serialNumbersToMove);//Para reservar se debe enviar stock en null
                        taOrderController.MoveSerialsStock(newSerialNumbersForReserve);
                        reserveDone = true;
                    }
                }
                if (nmusMap.size() > 0 && nonSimcardsSerialsValidated && !nmusAlreadyDeReserve)
                {
                    taOrderController.ManageReservedNmus('L',nmusMap, orderNumber);
                    nmusReserveFree = true;
                    nmusAlreadyDeReserve = true;
                }
                
                update orderItems;
            }

            order.put('serialesReservados', simcardsSerialsValidated && nonSimcardsSerialsValidated);
            order.put('serialList', serialList);
            order.put('nmusAlreadyDeReserve', nmusAlreadyDeReserve);
            System.debug('serialList: ' + serialList);
            outMap.put('options', order);
        }
        catch(Exception e){
            System.debug('ICCIDManager:SerialAssingment -> exception: '+e);
            if (nmusReserveFree) taOrderController.ManageReservedNmus('R',nmusMap,orderNumber);
            if (reserveDone)
                StockMovementException(serialNumbersToMove);
        }
    }

    private void UpdateSerialNodes(List<Object> serialNodes, Map<String,Object> serialNumbersToMove, Map<String, Map<String, Object>> nmusMap, String codDeposito, String deliveryMethod, Map<String,Boolean> stocksBillable) {
        System.debug('UpdateSerialNodes');
        try
        {
            for(Object serialNodeObj : serialNodes)
                    {
                        Map<String,Object> serialNode = (Map<String,Object>) serialNodeObj;
                        OrderItem item = (OrderItem) serialNode.get('itemObj');
                        String serial = (String) serialNode.get('serial');
                        String stockProducto = (String) serialNode.get('stockProducto');
                        System.debug('stockProducto: ' + stockProducto);
                        item.vlocity_cmt__SerialNumber__c = serial;
                        item.FromStock__c = stockProducto;
                        SetSerialItemAttributes (item, (String) serialNode.get('IMEI'), (String) serialNode.get('ICCID'), (String) serialNode.get('IMSI'), (String) serialNode.get('KI'), (String) serialNode.get('aduanaIngreso'), (String) serialNode.get('paisOrigen'), (String) serialNode.get('codOrdenDespacho'));
                        taOrderController.addSerialToMove(serialNumbersToMove, serial, OPERATION_VENTA_NORMAL, INSTANCE_RESERVA, stockProducto, codDeposito, deliveryMethod);
                        if (item.Product2.vlocity_cmt__Type__c != 'Simcard')
                            taOrderController.AddNmuToRelease(nmusMap,item.Product2.NMU__c,codDeposito);
                        // aca tengo q evaluar si es facturado o no el tangible de acuerdo a la matriz y al dato de FromStock
                        if(item.FromStock__c != null){
                            Boolean billable = (Boolean) stocksBillable.get(item.FromStock__c);
                            if (billable == null)
                            {
                                // llamada a la matriz y actualizacion del campo IsBillable
                                Map<String, Object> responseMatrix = TaMatrixUtils.GetStockBillable(item.FromStock__c);
                                if(Test.isRunningTest()) { responseMatrix = new Map<String,Object>();responseMatrix.put('StockBillable__Billable',true);}
                                System.debug('StockBillable: ' + responseMatrix);
                                item.IsBillable__c = Boolean.ValueOf(responseMatrix.get('StockBillable__Billable'));
                                stocksBillable.put(item.FromStock__c,item.IsBillable__c);
                            }
                            else item.IsBillable__c = billable;
                        }

                        serialNode.remove('itemObj');
                    }
        }
        catch(Exception e){
            System.debug('ICCIDManager:UpdateSerialNodes -> exception: '+e);
            throw e;
        }
    }

    private Boolean GetSerialsTangibles(Map<String,Integer> nmus, String codPuntoDeVenta, String codDeposito, String stockProducto, List<Object> serialNodes)
    {
        System.debug('GetSerialsTangibles');
        try {
            Map<String,Object> map094CallOuts = new Map<String,Object>();
            Boolean allSerialsObtained = true;
            for(String nmu : nmus.KeySet())
            {
                Integer cant = (Integer) nmus.get(nmu);
                Map<String, Object> input = Generate_RequestS094(codDeposito, codPuntoDeVenta, nmu, stockProducto);
                Map<String, Object> output = new Map<String, Object>();
                Map<String, Object> options2 = new Map<String, Object>();
                System.debug('request s094: ' + JSON.serialize(input));
                vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
                    
                integProcService.invokeMethod('IFS_S094', input, output, options2);
                System.debug('response s094: ' + output);
                Map<String, Object> s094_response = (Map<String, Object>)output.get('IPResult');
                List<Object> listaDeSeriados = (List<Object>) s094_response.get('listaDeSeriados');

                if (listaDeSeriados != null && listaDeSeriados.size() >= cant) map094CallOuts.put(nmu,listaDeSeriados);
                else
                {
                    allSerialsObtained = false;
                    break;
                }
            }

            if (allSerialsObtained)
            {
                for (String nmu : map094CallOuts.KeySet())
                {
                    List<Object> listaDeSeriados = (List<Object>) map094CallOuts.get(nmu);
                    Integer count = 0;
                    for (Integer i = 0; i<serialNodes.size(); i++)
                    {
                        Map<String,Object> serialNode = (Map<String,Object>) serialNodes[i];
                        String nmuNode = (String) serialNode.get('productCode');
                        if (nmu == nmuNode)
                        {
                            Map<String,Object> seriado = (Map<String,Object>) listaDeSeriados[count];
                            string serial = (string) seriado.get('numeroSerie');
                            serialNode.put('serial', serial);
                            serialNode.put('serialValidado', serial);
                            serialNode.put('IMEI', serial);
                            serialNode.put('stockProducto', (string) seriado.get('stockProducto'));
                            serialNode.put('aduanaIngreso', (String) seriado.get('aduanaIngreso'));
                            serialNode.put('paisOrigen', (String) seriado.get('paisOrigen'));
                            serialNode.put('codOrdenDespacho', (String) seriado.get('codOrdenDespacho'));
                            serialNode.put('validacionSerial', 'El ICCID fue asignado');
                            count++;
                        }
                    }
                }
            }
            else
            {
                SetSerialNodesError(serialNodes);
            }
            return allSerialsObtained;
        }
        catch(Exception e){
            System.debug('ICCIDManager:GetSerialsTangibles -> exception: '+e);
            throw e;
        }
    }

    private void SetSerialNodesError(List<Object> serialNodes)
    {
        System.debug('SetSerialNodesError');
        try {
            for (Integer i = 0; i<serialNodes.size(); i++)
                {
                    Map<String,Object> serialNode = (Map<String,Object>) serialNodes[i];
                    serialNode.put('serial', null);
                    serialNode.put('serialValidado', null);
                    serialNode.put('validacionSerial', 'No se encontraron seriales disponibles para la venta');
                    serialNode.remove('itemObj');
                }
            }
        catch(Exception e){
            System.debug('ICCIDManager:SetSerialNodesError -> exception: '+e);
            throw e;
        }
    }

    private Boolean GetSimcardsSerials(List<String> listNmus, String codPuntoDeVenta, String codDeposito, String stockProducto, List<Object> serialNodes)
    {
        System.debug('GetSimcardsSerials');
        try {            
            System.debug(codPuntoDeVenta);
            System.debug(stockProducto);

            Map<String, Object> input = Generate_RequestS444(listNmus, codDeposito, codPuntoDeVenta, stockProducto, serialNodes.size());
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            System.debug('IFS_S444 - request : ' + JSON.serialize(input));
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod('IFS_S444', input, output, options);
            System.debug('response S444: ' + JSON.serialize(output));

            Map<String,Object> ipResult = (Map<String,Object>) output.get('IPResult');
            List<Object> ipResultList = null;
            if(ipResult != null){
                ipResultList = (List<Object>) ipResult.get('listaNumeroSerie');
            }

            if (ipResult != null && ipResultList != null && ipResultList.size() == serialNodes.size())
            {
                for (Integer i = 0; i<serialNodes.size(); i++)
                {
                    Map<String,Object> serialNode = (Map<String,Object>) serialNodes[i];
                    Map<String,Object> responseNmu = (Map<String,Object>) ipResultList[i];
                        System.debug('responseNmus: ' + ipResultList);
                        serialNode.put('productCode', (String) responseNmu.get('codNMU'));
                        serialNode.put('stockProducto', (String) responseNmu.get('stockProducto'));
                        String serial = (String) responseNmu.get('numeroSerie');
                        String imsi = (String) responseNmu.get('imsi');
                        String ki = (String) responseNmu.get('ki');
                        System.debug('IMSI: ' + imsi);
                        System.debug('KI: ' + ki);
                        serialNode.put('IMSI', imsi);
                        serialNode.put('KI', ki);
                        serialNode.put('aduanaIngreso', (String) responseNmu.get('aduanaIngreso'));
                        serialNode.put('paisOrigen', (String) responseNmu.get('paisOrigen'));
                        serialNode.put('codOrdenDespacho', (String) responseNmu.get('codOrdenDespacho'));
                        serialNode.put('serial', serial);
                        serialNode.put('ICCID', serial);
                        serialNode.put('serialValidado', serial);
                        serialNode.put('validacionSerial', 'El ICCID fue asignado');
                }
                return true;
            }
            else
            {
                SetSerialNodesError(serialNodes);
                return false;
            }
        }
        catch(Exception e){
            System.debug('ICCIDManager:GetSimcardsSerials -> exception: '+e);
            throw e;
        }
    }

    private Map<String, Object> Generate_RequestS444(List<String> listNmus, String codDeposito, String codPuntoDeVenta, String stockProducto, Integer cantidad) {
        System.debug('Generate_RequestS444');
        try
        {
            String reqBody = '{"params": {"codDeposito": "' + codDeposito + '"},"body": {"codPuntoDeVenta": "' + codPuntoDeVenta + '","cantidad": "' + cantidad + '"';
            
            if (stockProducto != null)
                reqBody += ',"stockProducto": "' + stockProducto + '"';
            
            reqBody += ',"listaCodNMU": [';
            Boolean firstReg = true;
            for(string nmuItem : listNmus)
            {
                if (!firstReg) reqBody += ',';
                    firstReg = false;
                    reqBody += '{"codNMU": "' + nmuItem + '"}';
            }            
            reqBody += ']}}';

            return (Map<String, Object>) JSON.deserializeUntyped(reqBody);
        }
        catch(Exception e){
            System.debug('ICCIDManager:Generate_RequestS444 -> exception: '+e);
            throw e;
        }
    }

    @TestVisible private String setValuesOnJSON2(String jsonString, String iccid) {
        System.debug('Reading JSON Attribute');
        Map<String, Object> jsonAttributeMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        for (String jsonAttributeKey : jsonAttributeMap.keySet()) {
            List<Object> jsonMapValuesList = (List<Object>) jsonAttributeMap.get(jsonAttributeKey);

            for (Object o : jsonMapValuesList) {
                Map<String, Object> stringObjectMap = (Map<String, Object>) o;
                String attribute = (String) stringObjectMap.get('attributedisplayname__c');

                if (attribute == 'ICCID') {
                    Map<String, Object> valueMap = (Map<String, Object>) stringObjectMap.get('attributeRunTimeInfo');
                    String value = (String) valueMap.get('value');
                    valueMap.put('value', iccid);
                }
            }
        }
        return JSON.serialize(jsonAttributeMap);
    }

    public void ValidateSerialNumbers(Map<String, Object> serials, String codDeposito, List<String> stocks)
    {
        System.debug('ValidateSerialNumbers');
        try
        {
            System.debug('codDeposito: ' + codDeposito);
            System.debug('stocks: ' + stocks);
            Set<String> setStocksCode = new Set<String>(stocks);
            System.debug(setStocksCode);
            GetSerialNumbersInformation(serials);
            for(String serial : serials.KeySet())
            {
                Map<String, Object> serialNode = (Map<String, Object>) serials.get(serial);
                String codDepositoReal = (String) serialNode.get('codDeposito');
                String stockProductoReal = (String) serialNode.get('stockProducto');
                serialNode.put('serial', serial);
                if (codDeposito == codDepositoReal && setStocksCode.contains(stockProductoReal))
                {
                    serialNode.put('serialValidado', serial);
                }
                else serialNode.put('serialValidado', null);
            }
        }
        catch(Exception ex){
            System.debug('ICCIDManager:ValidateSerialNumbers -> exception: '+ex);
            throw ex;
        }
    }

    //Obtiene informacion detallada de los seriales recibidos
    /*Estructura de entrada varible "serials"
    {
        "123412341234123":{},
        "567856785687788":{}
    }
    */
    public void GetSerialNumbersInformation(Map<String, Object> serials)
    {
        System.debug('GetSerialNumbersInformation');
        try
        {
            String integProcName = 'IFS_S095';
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();
            String body = '{"body":{"listaNumeroSeries":[';
            Integer count = 0;
            for(String serial : serials.KeySet())
            {
                if (count > 0) body += ',';
                body += '{"numeroSerie":"' + serial + '"}';
                count++;
            }
            body += ']}}';
            input = (Map<String, Object>)JSON.deserializeUntyped(body);
            
            System.debug('IFS_S095 - request: ' + body);
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod(integProcName, input, output, options);
            System.debug('response s095: ' + JSON.serialize(output));
            System.debug('serials: ' + JSON.serialize(serials));
            
            Map<String, Object> response = (Map<String, Object>) output.get('IPResult');
            List<Object> listaNumeroSerie = (List<Object>) response.get('listaNumeroSeries');
            System.debug('listaNumeroSeries: ' + JSON.serialize(listaNumeroSerie));
            for(Object serialOcurrence : listaNumeroSerie)
            {
                Map<String, Object> serialNode = (Map<String, Object>) serialOcurrence;
                String serialNumber = (String) serialNode.get('numeroSerie');
                System.debug('serialNumber: ' + serialNumber);
                Map<String, Object> itemNode = (Map<String, Object>) serials.get(serialNumber);
                System.debug('itemNode: ' + itemNode);

                itemNode.put('productCode', (String) serialNode.get('codNMU'));
                itemNode.put('IMSI', (String) serialNode.get('imsi'));
                itemNode.put('KI', (String) serialNode.get('ki'));
                itemNode.put('aduanaIngreso', (String) serialNode.get('aduanaIngreso'));
                itemNode.put('paisOrigen', (String) serialNode.get('paisOrigen'));
                itemNode.put('codOrdenDespacho', (String) serialNode.get('codOrdenDespacho'));
                itemNode.put('stockProducto', (String) serialNode.get('stockProducto'));
                itemNode.put('codDeposito', (String) serialNode.get('codDeposito'));
            }
        }
        catch(Exception ex){
            System.debug('ICCIDManager:GetSerialNumbersInformation -> exception: '+ex);
            throw ex;
        }
    }

    void SerialReAssingment(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        System.debug('SerialReAssingment');
        Map<String,Object> serialNumbersToMove = new Map<String,Object>();
        Boolean reserveDone = false;
        String codPuntoDeVenta;
        String codDeposito;
        String deliveryMethod;
        try{
            Boolean valAux = true;
            Map<String, Object> order = (Map<String, Object>) options.get('Order');
            List<Object> serialList = (List<Object>) order.get('serialList');
            String orderId = (String) options.get('IdOrder');
            Map<String,Object> billingOrder = (Map<String,Object>) inputMap.get('BillingOrder');
            deliveryMethod = (String) billingOrder.get('Delivery_Method');
            String channel = (String) billingOrder.get('Channel');
                     
            Map<string, Object> responseMatrix = TaMatrixUtils.getStockAvailableCode(channel, deliveryMethod);
            if(Test.isRunningTest()) {
                responseMatrix = new Map<String,Object>();
                responseMatrix.put('StockAvailableCode__StockAvailableCode','stockProducto');
            }
            String stockProducto= (String) responseMatrix.get('StockAvailableCode__StockAvailableCode');
            System.debug('RESPONSE getStockAvailableCode');
            System.debug('Codigo Tangible: ' + stockProducto);
            List<String> stocksCode = new List<String>();
            stocksCode = stockProducto.split(',', 0);
            /*PTFA-6033 FIN */
            System.debug('orderId: ' + orderId);
            Map<String,String> getPointOfSaleWarehouseResponse = taOrderController.GetPointOfSaleWarehouse(orderId);
            System.debug('getPointOfSaleWarehouseResponse: ' + getPointOfSaleWarehouseResponse);
            codPuntoDeVenta = getPointOfSaleWarehouseResponse.get('codPuntoDeVenta');
            codDeposito = getPointOfSaleWarehouseResponse.get('codDeposito');
            if(Test.isRunningTest()) {
                codDeposito = 'codDeposito';
            }
            Map<Id, WrapOrderItem> wrapOrderItemsMap = new Map<Id, WrapOrderItem>();
            List<Object> newSerialList = new List<Object>();
            Map<String, Object> serialsMap = new Map<String, Object>();
            for(Object item : serialList){
                Map<String, Object> itemMap = (Map<String, Object>) item;
                String validationResult = (String) itemMap.get('validacionSerial');
                if (validationResult != 'El ICCID fue asignado')
                {
                    String inputSerial = (String) itemMap.get('serial');
                    String oldSerial = (String) itemMap.get('serialValidado');
                    String oldStock = (String) itemMap.get('stockProducto');
                    Map<String,Object> serialNode = new Map<String, Object>();
                    serialNode.put('itemId', itemMap.get('itemId'));
                    serialNode.put('productName', itemMap.get('productName'));
                    serialNode.put('productCode', itemMap.get('productCode'));
                    serialNode.put('oldSerial', oldSerial);
                    serialNode.put('oldStock', oldStock);
                    System.debug('inputSerial: ' + inputSerial);
                    System.debug('oldSerial: ' + oldSerial);

                    serialsMap.put(inputSerial, serialNode);
                }
                else newSerialList.add(itemMap);
            }
            if (!serialsMap.KeySet().isEmpty())
                ValidateSerialNumbers(serialsMap, codDeposito, stocksCode);
            for(String serial : serialsMap.KeySet())
            {
                Map<String, Object> serialNode = (Map<String, Object>) serialsMap.get(serial);
                String validatedSerial = (String) serialNode.get('serialValidado');
                if(String.IsNotBlank(validatedSerial))
                {
                    System.debug('serialNode: ' + serialNode);
                    serialNode.put('validacionSerial', 'El ICCID fue asignado');
                    String oldSerial = (String) serialNode.get('oldSerial');
                    if (String.IsNotBlank(oldSerial))
                        taOrderController.addSerialToMove(serialNumbersToMove, oldSerial, OPERATION_VENTA_NORMAL, INSTANCE_ANULAR_RESERVA, (String) serialNode.get('oldStock'), codDeposito, deliveryMethod);
                    String stock = (String)serialNode.get('stockProducto');
                    taOrderController.addSerialToMove(serialNumbersToMove, validatedSerial, OPERATION_VENTA_NORMAL, INSTANCE_RESERVA, stock, codDeposito, deliveryMethod);
                    Map<String, Object> responseMatrix2 = TaMatrixUtils.GetStockBillable(stock);
                    if(Test.isRunningTest()){
                        responseMatrix2 = new Map<String, Object>();
                        responseMatrix2.put('StockBillable__Billable',true);
                    }
                    System.debug('StockBillable: ' + responseMatrix2);
                    Boolean billeable = Boolean.ValueOf(responseMatrix2.get('StockBillable__Billable'));
                    WrapOrderItem wrapOrderItem = new WrapOrderItem(validatedSerial, (String) serialNode.get('IMSI'), (String) serialNode.get('KI'), (String) serialNode.get('aduanaIngreso'), (String) serialNode.get('paisOrigen'), (String) serialNode.get('codOrdenDespacho'), stock, billeable);
                    wrapOrderItemsMap.put((Id) serialNode.get('itemId'), wrapOrderItem);
                }
                else
                {
                        serialNode.put('validacionSerial', 'El serial ingresado no se encuentra disponible para la venta');
                        valAux = false;
                }
                newSerialList.add(serialNode);
            }
            Boolean makeReserves = (deliveryMethod == 'Presencial' || deliveryMethod == 'Store Pick Up');//Solo en estos casos se realiza la reserva
            if (serialNumbersToMove.KeySet().size() > 0)
            {
                if (makeReserves)
                {
                    Map<String, Object> newSerialNumbersForReserve = ClearStockOriginForReserves(serialNumbersToMove);//Para reservar se debe enviar stock en null
                    taOrderController.MoveSerialsStock(newSerialNumbersForReserve);
                    reserveDone = true;
                }
                List<OrderItem> orderItems = [ SELECT Id, vlocity_cmt__JSONAttribute__c, Product2.vlocity_cmt__Type__c FROM OrderItem WHERE Id in :wrapOrderItemsMap.KeySet()];
                for(OrderItem item : orderItems)
                {
                    WrapOrderItem wrapOrderItem = (WrapOrderItem) wrapOrderItemsMap.get(item.Id);
                    if (item.Product2.vlocity_cmt__Type__c == 'Simcard')
                        SetSerialItemAttributes (item, null, wrapOrderItem.ICCID, wrapOrderItem.IMSI, wrapOrderItem.KI, wrapOrderItem.AduanaIngreso, wrapOrderItem.PaisOrigen, wrapOrderItem.CodOrdenDespacho);
                    else
                        SetSerialItemAttributes (item, wrapOrderItem.ICCID, null, null, null, wrapOrderItem.AduanaIngreso, wrapOrderItem.PaisOrigen, wrapOrderItem.CodOrdenDespacho);
                    item.vlocity_cmt__SerialNumber__c = wrapOrderItem.ICCID;
                    item.FromStock__c = wrapOrderItem.Stock;
                    item.IsBillable__c = wrapOrderItem.Billeable;
                }
                update orderItems;
            }
            order.put('serialesReservados', valAux);
            order.put('serialList', newSerialList);
            outMap.put('options', order);
        }
        catch(Exception e){
            System.debug('ICCIDManager:SerialReAssingment -> exception: '+e);
            if (reserveDone)
                StockMovementException(serialNumbersToMove);
            throw e;
        }
    }

    private Map<String, Object> ClearStockOriginForReserves(Map<String, Object> serialNumbersToMove){
        try
        {
            Map<String, Object> newSerialNumbersForReserve = new Map<String, Object>();
            for(String serial : serialNumbersToMove.KeySet())
            {
                Map<String,Object> serialNumbersItemOld = (Map<String,Object>) serialNumbersToMove.get(serial);
                Map<String,Object> serialNumbersItemNew = new Map<String,Object>();
                String instance = (String) serialNumbersItemOld.get('instance');
                serialNumbersItemNew.put('operation',(String) serialNumbersItemOld.get('operation'));
                serialNumbersItemNew.put('instance',instance);
                serialNumbersItemNew.put('codDeposito',(String) serialNumbersItemOld.get('codDeposito'));
                serialNumbersItemNew.put('deliveryMethod',(String) serialNumbersItemOld.get('deliveryMethod'));
                if (instance == INSTANCE_RESERVA)
                    serialNumbersItemNew.put('originStock',null);
                else
                    serialNumbersItemNew.put('originStock',(String) serialNumbersItemOld.get('originStock'));

                newSerialNumbersForReserve.put(serial,serialNumbersItemNew);
            }
            return newSerialNumbersForReserve;
        }
        catch (Exception ex)
        {
            System.debug('ICCIDManager:ClearStockOrigin -> exception: '+ ex);
            throw ex;
        }
    }

    private void StockMovementException(Map<String, Object> serialNumbersToMove){
        try
        {
            for(String serial : serialNumbersToMove.KeySet())
                {
                    Map<String,Object> serialNumbersItem = (Map<String,Object>) serialNumbersToMove.get(serial);
                    String originStock = (String) serialNumbersItem.get('originStock');
                    String instance = (String) serialNumbersItem.get('instance');
                    if (instance == INSTANCE_RESERVA)
                        serialNumbersItem.put('instance',INSTANCE_ANULAR_RESERVA);
                    else
                    {
                        serialNumbersItem.put('instance',INSTANCE_RESERVA);
                        serialNumbersItem.put('originStock',null);//Para reservar se debe enviar el stock en null
                    }
                }
                taOrderController.MoveSerialsStock(serialNumbersToMove);
        }
        catch(CallOutException e){
            System.debug('taOrderController:StockMovementException -> exception: '+e);
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
        catch (Exception ex)
        {
            System.debug('ICCIDManager:ClearStockOrigin -> exception: '+ ex);
            throw ex;
        }
    }

    private void SetSerialItemAttributes (OrderItem item, String IMEI, String ICCID, String IMSI, String KI, String AduanaIngreso, String PaisOrigen, String CodOrdenDespacho){
        try
        {
            Map<String,String> attribs = new Map<String,String>();
            if (String.IsNotBlank(IMEI)) attribs.put('IMEI', IMEI);
            if (String.IsNotBlank(ICCID)) attribs.put('ICCID', ICCID);
            if (String.IsNotBlank(IMSI)) attribs.put('IMSI', IMSI);
            if (String.IsNotBlank(KI)) attribs.put('KI', KI);
            attribs.put('Aduana Ingreso', AduanaIngreso);
            attribs.put('Pais Origen', PaisOrigen);
            attribs.put('Codigo Orden Despacho', CodOrdenDespacho);
            String jsonAttribute = AssetAttributesUtils.setValuesOnJSON(item.vlocity_cmt__JSONAttribute__c, attribs);
            System.debug('jsonAttribute: ' + jsonAttribute);
            item.vlocity_cmt__JSONAttribute__c = jsonAttribute;
        }
        catch (Exception ex)
        {
            System.debug('ICCIDManager:SetSerialItemAttributes -> exception: '+ ex);
            throw ex;
        }
    }

    void ConsultingStockAvailableCode(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options){
        System.debug('ConsultingStockAvailableCode');
        String channel = (String) options.get('Channel');
        System.debug(channel);
        String deliveryMethod = (String) options.get('DeliveryMethod');
        System.debug(deliveryMethod);        
        System.debug('>>>' +  TaMatrixUtils.getStockAvailableCode(channel, deliveryMethod));
        Map<string, Object> response = new Map<String,Object>();
        if(!Test.isRunningTest()) {
            response = TaMatrixUtils.getStockAvailableCode(channel, deliveryMethod);
        }else{
            response.put('StockAvailableCode__StockAvailableCode','StockAvailableCode__StockAvailableCode');
            response.put('StockAvailableCode__BeforeSimulation',true);
        }
        String codStock = (String) response.get('StockAvailableCode__StockAvailableCode');
        Boolean beforeSimulation = Boolean.valueOf(response.get('StockAvailableCode__BeforeSimulation'));
        System.debug('RESPONSE ConsultingStockAvailibleCode');
        System.debug(response);
        System.debug('Codigo Tangible: ' + codStock);
        outMap.put('StockAvailableCode', codStock);
        outMap.put('BeforeSimulation', beforeSimulation);
    }

    private Map<String, Object> Generate_RequestS094(String codDeposito, String codPuntoDeVenta, String codNMU, String stockProducto) {
        System.debug('Generate_RequestS094');
        System.debug('codNMU: ' + codNMU);
        Map<String, Object> request = new Map<String, Object>();
        /*
        //-----Datos para probar-------
        codDeposito = '1111';
        codPuntoDeVenta = null;
        codNMU = null;
        stockProducto = null;
        //-----------------------------
        */

        if(codDeposito != null){
            Map<String, Object> params = new Map<String, Object>();
            params.put('codDeposito', codDeposito);
            request.put('params', params);
        }

        Map<String, Object> body = new Map<String, Object>();
        if(codPuntoDeVenta != null){
            body.put('codPuntoDeVenta', codPuntoDeVenta);
        }
        if(codNMU != null){
            body.put('codNMU', codNMU);
        }
        if(stockProducto != null){
            body.put('stockProducto', stockProducto);
        }
        request.put('body', body);
        return request;
    }

    void UpdateSalesInvoice(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options){
        System.debug('UpdateSalesInvoice');
        String idOrder = (String) options.get('IdOrder');
        List<OrderItem> serialsList = taOrderController.GetOrderSerials(idOrder);
        Order order = [SELECT vlocity_cmt__TrackingNumber__c FROM Order WHERE Id = :idOrder];

        String numeroComprobante = order.vlocity_cmt__TrackingNumber__c;
        String reqBody = '{"body": {"numeroComprobante": "' + numeroComprobante + '",';
        reqBody += '"listaDetalleModificar": [';
        Boolean firstReg = true;
        if(Test.isRunningTest()) {
            serialsList = [SELECT Id, Product2.ProductCode, Product2.Name, Product2.vlocity_cmt__Type__c, vlocity_cmt__SerialNumber__c, Huawei_Invoice_Item_Sequence__c, vlocity_cmt__JSONAttribute__c, FromStock__c FROM OrderItem WHERE OrderId = :idOrder];
        }
        //
        for(OrderItem serialItem : serialsList)
            {
                String serial = serialItem.vlocity_cmt__SerialNumber__c;
                String nroOrdenDespacho;
                Map<String,Object> jsonAttribute = AssetAttributesUtils.GetJSONAttribute(serialItem.vlocity_cmt__JSONAttribute__c, 'Codigo Orden Despacho');
                if(jsonAttribute != null && jsonAttribute.get('value__c') != null){
                        nroOrdenDespacho = String.valueOf(jsonAttribute.get('value__c'));
                    }
                //String valorParametro = 'Linea:3886827428 Serie: 358176005195470 N. Desp IC04';
                String valorParametro = 'Serie: ' + serial + ' N. Desp ' + nroOrdenDespacho;
                String secuenciaProductoAdquirido = serialItem.Huawei_Invoice_Item_Sequence__c;
                jsonAttribute = AssetAttributesUtils.GetJSONAttribute(serialItem.vlocity_cmt__JSONAttribute__c, 'Charge Code');
                String codCargo;// = 'C_OT_MB_EQUIPMENT_SIM';
                if(jsonAttribute != null && jsonAttribute.get('value__c') != null){
                        codCargo = String.valueOf(jsonAttribute.get('value__c'));
                    }
                if (!firstReg) reqBody += ',';
                firstReg = false;

                reqBody += '{"datosAdicionales":[{"nombreParametro":"IMEI","valorParametro":"' + valorParametro + '"}],';
                reqBody += '"codCargo": "' + codCargo + '","secuenciaProductoAdquirido": "' + secuenciaProductoAdquirido + '"}';
            }
        String impDiferida = 'N';
        String impFiscal = 'Y';
        //String fechaAltaComprobante = '20170606121212';
        String fechaAltaComprobante = DateTime.now().formatGMT('yyyyMMddHHmmss');
        reqBody += '],"impDiferida": "' + impDiferida + '","impFiscal": "' + impFiscal + '","fechaAltaComprobante": "' + fechaAltaComprobante + '"}}';

        Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(reqBody);
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();

        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        integProcServ.invokeMethod('IFS_S451', input, output, options2);
        Map<String,Object> result = (Map<String,Object>) output.get('result');

        //Map<String, Object> response = (Map<String, Object>) output.get('IPResult');
        System.debug(result);
    }
}