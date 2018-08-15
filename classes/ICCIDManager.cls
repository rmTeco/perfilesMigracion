global with sharing class ICCIDManager implements vlocity_cmt.VlocityOpenInterface{

    public static final String INSTANCE_VENTA_NORMAL = 'VTAN';
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
            if (methodName.equals('SerialValidation')){
                SerialValidation(inputMap, outMap);
            }
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

    void SerialValidation(Map<String,Object> inputMap, Map<String, Object> outMap){
        Boolean valAux = true;
        Map<String, Object> order = (Map<String, Object>) inputMap.get('Order');
        List<Object> plansList = (List<Object>) order.get('planes');
        for (Object p : plansList){
            Map<String, Object> plan = (Map<String, Object>) p;
            List<Object> lines = (List<Object>) plan.get('lineas');
            for (Object l : lines){
                Map<String, Object> line = (Map<String, Object>) l;
                string serial = (string) line.get('serial');
                string serialVal = (string) line.get('validacionSerial');

                //Simulación validación MM
                if(serial != ''){
                    if(serial.length() == 10){
                        if(serial == '1234567890'){
                            serialVal = 'El ICCID ingresado no se encuentra disponible para la venta';
                            valAux = false;
                        }else{
                            serialVal = 'El ICCID fue asignado';
                        }
                    }
                    else{
                        serialVal = 'Error de formato';
                        valAux = false;
                    }
                }else{
                    serialVal = 'Ingrese serial';
                    valAux = false;
                }

                if(valAux){
                    order.put('serialesReservados', true);
                }else{
                    order.put('serialesReservados', false);
                }
                //Fin Simulacion validación MM

                line.put('validacionSerial', serialVal);
            }
        }

        outMap.put('options', order);
    }

    private void SerialAssingment(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options){
        System.debug('SerialAssingment');
        Map<String, Map<String, Object>> nmusMap = new Map<String, Map<String, Object>>();
        Map<String, String> oldSerialNumbers = new Map<String, String>();
        Map<String, String> newSerialNumbers = new Map<String, String>();
        Boolean deReserveDone = false;
        Boolean reserveDone = false;
        Boolean nmusReserveFree = false;
        String codPuntoDeVenta;
        String codDeposito;
        String deliveryMethod;
        Id orderId;
        try{
            Boolean valAux = true;
            Map<String, Object> order = (Map<String, Object>) options.get('Order');
            orderId = (Id) options.get('IdOrder');
            System.debug('orderId: ' + orderId);
            Map<String,String> getPointOfSaleWarehouseResponse = taOrderController.GetPointOfSaleWarehouse(orderId);
            codPuntoDeVenta = getPointOfSaleWarehouseResponse.get('codPuntoDeVenta');
            codDeposito = getPointOfSaleWarehouseResponse.get('codDeposito');
            Order dbOrder = [SELECT Delivery_Method__c, Gestion__c FROM Order WHERE Id = :orderId LIMIT 1];
            Boolean cambioDeSim = (dbOrder.Gestion__c == 'Cambio de SIM' || dbOrder.Gestion__c == 'Cambio de SIM por siniestro');
            List<OrderItem> orderItems = taOrderController.GetOrderSerials(orderId);
            if(Test.isRunningTest()) orderItems = [SELECT Id, Product2.ProductCode, Product2.Name, Product2.vlocity_cmt__Type__c, vlocity_cmt__SerialNumber__c, vlocity_cmt__JSONAttribute__c, FromStock__c FROM OrderItem WHERE OrderId = :orderId];
            deliveryMethod = dbOrder.Delivery_Method__c;

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
            // PFTA-7892

            for(OrderItem item : orderItems){
                String stockProducto = stockProductoBK;
                Map<String,Object> serialNode = new Map<String, Object>();
                serialNode.put('itemId', item.Id);
                serialNode.put('productName', item.Product2.Name);
                System.debug('OrderItemId' + item.Id);

                if (item.Product2.vlocity_cmt__Type__c == 'Simcard')
                {
                    System.debug('va por Simcard ' + serialNode);
                    String nmuCode = (String) serialNode.get('productCode');
                    //String stockDef = GetStockDef(stocksCode, nmuCode, existences);
                    // String stockDef = 'MTPL';
                    // System.debug('stocksCode: ' + stockDef);
                    // if(GetSimcardsSerial(item, codPuntoDeVenta, codDeposito, stockDef,  serialNode))
                    if(GetSimcardsSerial(item, codPuntoDeVenta, codDeposito, stockProducto, serialNode))
                    {
                        String serial = (String) serialNode.get('serial');
                        String nmu = (String) serialNode.get('productCode');
                        
                        stockProducto = (String) serialNode.get('stockProducto');
                        System.debug('stockProducto: ' + stockProducto);
                        //Si habia seriales cargados, y no es cambio de sim, los libero
                        if (String.isNotBlank(item.vlocity_cmt__SerialNumber__c) && !cambioDeSim)
                        {
                            oldSerialNumbers.put(item.vlocity_cmt__SerialNumber__c, item.FromStock__c);
                        }
                        item.vlocity_cmt__SerialNumber__c = serial;
                        //DA 29/12/2017 - Actualiza seriales en el json atributs
                        SetSerialItemAttributes (item, serial, (String) serialNode.get('IMSI'), (String) serialNode.get('KI'), (String) serialNode.get('aduanaIngreso'), (String) serialNode.get('paisOrigen'), (String) serialNode.get('codOrdenDespacho'));

                        item.FromStock__c = stockProducto;
                        //taOrderController.AddNmuToRelease(nmusMap,nmu,codDeposito);//Validar si se deben reservar los simcards
                        //newSerialNumbers.add(serial);
                        newSerialNumbers.put(serial, stockProducto);
                    } else {
                        serialNode.put('serial', null);
                        serialNode.put('serialValidado', null);
                        serialNode.put('validacionSerial', 'No se encontraron seriales disponibles para la venta');
                        valAux = false;
                    }
                }
                else
                {
                    System.debug('va por no Simcard');

                    // String nmu = taOrderController.GetNMU(item.vlocity_cmt__JSONAttribute__c);
                    // String nmu = item.Product2.StockKeepingUnit;
                    String nmu = '1231312';

                    //String stockDef = GetStockDef(stocksCode, nmu, existences);
                    // String stockDef = 'MTPL';
                    // System.debug('stocksCode: ' + stockDef);
                    serialNode.put('productCode', nmu);
                    //PFTA - 10326 - Se envia siempre punto de venta 0
                    Map<String, Object> input = Generate_RequestS094(codDeposito, '0', nmu, stockProducto);
                    Map<String, Object> output = new Map<String, Object>();
                    Map<String, Object> options2 = new Map<String, Object>();
                    System.debug('request s094: ' + JSON.serialize(input));
                    vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
                    
                    if(!Test.isRunningTest()){
                        integProcService.invokeMethod('IFS_S094', input, output, options2);
                    } else {
                        Map<String,Object> IPResultTest = new Map<String,Object>();
                        List<Object> listaDeSeriadosTest = new List<Object>();
                        Map<String,Object> seriadoTest = new Map<String,Object>();
                        seriadoTest.put('numeroSerie','numeroSerie');
                        seriadoTest.put('stockProducto','stockProducto');
                        seriadoTest.put('aduanaIngreso','aduanaIngreso');
                        seriadoTest.put('paisOrigen','paisOrigen');
                        seriadoTest.put('codOrdenDespacho','codOrdenDespacho');
                        if(!options.containsKey('isTestListaDeSeriadosTestEmpty'))listaDeSeriadosTest.add(seriadoTest);
                        IPResultTest.put('listaDeSeriados',listaDeSeriadosTest);
                        output.put('IPResult',IPResultTest);
                    }
                    System.debug('response s094: ' + output);

                    Map<String, Object> s094_response = (Map<String, Object>)output.get('IPResult');
                    List<Object> listaDeSeriados = (List<Object>) s094_response.get('listaDeSeriados');
                    if (listaDeSeriados.size() > 0){
                        Map<String,Object> seriado = (Map<String,Object>) listaDeSeriados[0];
                        string serial = (string) seriado.get('numeroSerie');
                        stockProducto = (string) seriado.get('stockProducto');
                        serialNode.put('serial', serial);
                        serialNode.put('serialValidado', serial);
                        serialNode.put('stockProducto', stockProducto);
                        serialNode.put('validacionSerial', 'El ICCID fue asignado');
                        if (String.isNotBlank(item.vlocity_cmt__SerialNumber__c))//Si habia seriales cargados, los libero
                        {
                            oldSerialNumbers.put(item.vlocity_cmt__SerialNumber__c, item.FromStock__c);
                        }

                        SetSerialItemAttributes (item, null, null, null, (String) seriado.get('aduanaIngreso'), (String) seriado.get('paisOrigen'), (String) seriado.get('codOrdenDespacho'));

                        item.vlocity_cmt__SerialNumber__c = serial;
                        item.FromStock__c = stockProducto;

                        //taOrderController.AddNmuToRelease(nmusMap,nmu,codDeposito);//DESCOMENTAR - Volver a activar cuando ande el S101
                        newSerialNumbers.put(serial, stockProducto);
                    }else{
                        System.debug('response: ' + output);
                        serialNode.put('serial', null);
                        serialNode.put('serialValidado', null);
                        serialNode.put('validacionSerial', 'No se encontraron seriales disponibles para la venta');
                        valAux = false;
                    }  
                }

                // aca tengo q evaluar si es facturado o no el tangible de acuerdo a la matriz y al dato de FromStock
                if(item.FromStock__c != null){
                    // llamada a la matriz y actualizacion del campo IsBillable
                    Map<String, Object> responseMatrix = TaMatrixUtils.GetStockBillable(item.FromStock__c);
                    if(Test.isRunningTest()) { responseMatrix = new Map<String,Object>();responseMatrix.put('StockBillable__Billable',true);}
                    System.debug('StockBillable: ' + responseMatrix);
                    item.IsBillable__c = Boolean.ValueOf(responseMatrix.get('StockBillable__Billable'));
                }

                serialList.add(serialNode);
            }
            if(deliveryMethod == 'Presencial' || deliveryMethod == 'Store Pick Up')//Solo en estos casos se realiza la reserva
            {
                if (oldSerialNumbers.KeySet().size() > 0)
                {
                    System.debug('1');
                    taOrderController.MoveSerialsStock(INSTANCE_VENTA_NORMAL,INSTANCE_ANULAR_RESERVA,oldSerialNumbers, codDeposito, deliveryMethod);
                    deReserveDone = true;
                }
                if (newSerialNumbers.KeySet().size() > 0)
                {
                    System.debug('2');
                    Map<String, String> newSerialNumbersForReserve = ClearStockOrigin(newSerialNumbers);//Para reservar se debe enviar NOAPLICA
                    if(!Test.isRunningTest())taOrderController.MoveSerialsStock(INSTANCE_VENTA_NORMAL,INSTANCE_RESERVA,newSerialNumbersForReserve, codDeposito, deliveryMethod);
                    reserveDone = true;
                }
            }
            if (nmusMap.size() > 0)
            {
                System.debug('3');
                taOrderController.ManageReservedNmus('L',nmusMap,codPuntoDeVenta,codDeposito, orderId);
                nmusReserveFree = true;
            }
            
            update orderItems;
            order.put('serialesReservados', valAux);
            order.put('serialList', serialList);
            System.debug('serialList: ' + serialList);
            System.debug('serialesReservados: ' + valAux);
            outMap.put('options', order);
        }
        catch(Exception e){
            System.debug('ICCIDManager:SerialAssingment -> exception: '+e);
            if (nmusReserveFree) taOrderController.ManageReservedNmus('R',nmusMap,codPuntoDeVenta,codDeposito, orderId);
            if (reserveDone) taOrderController.MoveSerialsStock(INSTANCE_VENTA_NORMAL,INSTANCE_ANULAR_RESERVA,newSerialNumbers, codDeposito, deliveryMethod);
            if (deReserveDone)
            {
                Map<String, String> oldSerialNumbersForReserve = ClearStockOrigin(oldSerialNumbers);//Para reservar se debe enviar NOAPLICA
                taOrderController.MoveSerialsStock(INSTANCE_VENTA_NORMAL,INSTANCE_RESERVA,oldSerialNumbersForReserve, codDeposito, deliveryMethod);
            }
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

    public static List<Object> IFS_S089Call(String codPuntoDeVenta, String codDeposito, String codeMarc, String codFamProd, String nmuCart){
        Map<String, Object> jSonResponse;
        jSonResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad(codPuntoDeVenta, codDeposito, codeMarc, codFamProd, nmuCart, null);
        List<Object> existencias = new List<Object>();
        existencias = (List<Object>) jSonResponse.get('ListaExistencias');
        return existencias;
    }                    

    public static String GetStockDef(List<String> stocksCode, String nmuCart, List<Object> existences)
    {
        System.debug('GetStockDef');
        try
        {
            String stockDef = 'MTPL';
            
            if (stocksCode.size() == 1)
                stockDef = stocksCode[0];
            else
            {
                Boolean find = false;
                Integer i = 0;
                while (!find && i < stocksCode.size()) //MTPL,MTCA, etc
                {
                    Integer stockAmmount = 0;                            
                    String stockAux = stocksCode[i];
                    Boolean nmuFound = false;
                    Integer nmuCount = 0;
                    while (!nmuFound && nmuCount < existences.size()) //Lista Respuesta 89
                    {
                        Map<String, Object> producto = (Map<String, Object>) existences[nmuCount];
                        List<Object> stocks = (List<Object>)producto.get('ListaPorCodigoStock');
                        System.debug('stocks: ' + stocks);
                        String NMU = (String) producto.get('codNMU');
                        System.debug('NMU: ' + NMU);

                        if (nmuCart == NMU)
                        {
                            Boolean stockFound = false;
                            Integer stockCount = 0;
                            while (!stockFound && stockCount < stocks.size()) //Lista de stocks productod
                            {
                                Map<String, Object> stock = (Map<String, Object>) stocks[stockCount];
                                System.debug('stock: ' + stock);
                                String codigoStock = (String) stock.get('stockProducto');
                                System.debug('codigoStock: ' + codigoStock);
                                if(codigoStock==stockAux){
                                    stockAmmount = integer.valueof(stock.get('CantidadDisponible'));
                                    System.debug('stockAmmount: ' + stockAmmount);
                                    stockFound = true;
                                    nmuFound = true;
                                }

                                stockCount++;
                            }
                        }
                        
                        nmuCount++;                        
                    }
                    
                    if (stockAmmount > 0)
                    {
                        stockDef = stockAux;
                        find = true;
                    }
                    i++;
                }
            }
            return stockDef;
        }
        catch(Exception e){
            System.debug('ICCIDManager:GetStockDef -> exception: '+e);
            return null;
        }
    }

    private Boolean GetSimcardsSerial(OrderItem item, String codPuntoDeVenta, String codDeposito, String stockProducto, Map<String,Object> serialNode)
    {
        System.debug('GetSimcardsSerial');
        try {            
            List<String> listNmus = AssetAttributesUtils.GetJSONAttributePickListValues(item.vlocity_cmt__JSONAttribute__c, 'NMU Simcard');
            
            System.debug('PRINT DATA');
            System.debug(codPuntoDeVenta);
            System.debug(stockProducto);
            //PFTA - 10326 - Se envia siempre punto de venta 0
            String reqBody = '{"params": {"codDeposito": "' + codDeposito + '"},"body": {"codPuntoDeVenta": "' + '0' + '","cantidad": "1"';
            
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


            //String reqBody = '{"params": {"codDeposito": "CA0001001"},"body": {"codPuntoDeVenta": "1111","cantidad": 1,"stockProducto": "' + stockProducto + '","listaCodNMU": [{"codNMU": "PSGS8PVLN"}]}}';
            //String reqBody = '{"params": {"codDeposito": "CS0134001"},"body": {"codPuntoDeVenta": "134","cantidad": 1,"stockProducto": "' + stockProducto + '","listaCodNMU": [{"codNMU": "PTPC64PSI"}]}}';
            //String reqBody = '{"params": {"codDeposito": "CS0134001"},"body": {"codPuntoDeVenta": "134","cantidad": "1","listaCodNMU": [{"codNMU": "PTP23FFCI"},{"codNMU": "PTP2FFCCI"},{"codNMU": "PTP3FFMMI"},{"codNMU": "PTP4FFVNI"},{"codNMU": "PTPBOLTCI"},{"codNMU": "PTPC64PSI"}]}}';
            
            
            Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(reqBody);
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            System.debug('IFS_S444 - request : ' + JSON.serialize(input));
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            if(!Test.isRunningTest()){
                integProcServ.invokeMethod('IFS_S444', input, output, options);
            } else {
                if(item.Product2.Name == 'IsGetSimcardsSerialTest'){
                    Map<String,Object> IPResult = new Map<String,Object>();
                    List<Object> listaNumeroSerie = new List<Object>();
                    Map<String,Object> responseNmu = new Map<String,Object>();
                    responseNmu.put('codNMU','codNMU');
                    responseNmu.put('stockProducto','stockProducto');
                    responseNmu.put('numeroSerie','numeroSerie');
                    responseNmu.put('imsi','imsi');
                    responseNmu.put('ki','ki');
                    responseNmu.put('aduanaIngreso','aduanaIngreso');
                    responseNmu.put('paisOrigen','paisOrigen');
                    responseNmu.put('codOrdenDespacho','codOrdenDespacho');
                    listaNumeroSerie.add(responseNmu);
                    IPResult.put('listaNumeroSerie',listaNumeroSerie);
                    output.put('IPResult',IPResult);
                }
                
            }
            System.debug('response S444: ' + JSON.serialize(output));

            Map<String,Object> ipResult = (Map<String,Object>) output.get('IPResult');
            List<Object> ipResultList = null;
            if(ipResult != null){
                ipResultList = (List<Object>) ipResult.get('listaNumeroSerie');
            }

            if (ipResult != null && ipResultList != null){
                Map<String,Object> responseNmu = (Map<String,Object>) ipResultList[0];
                System.debug('responseNmus: ' + ipResultList);
                serialNode.put('productCode', (String) responseNmu.get('codNMU'));
                serialNode.put('stockProducto', (String) responseNmu.get('stockProducto'));
                String serial = (String) responseNmu.get('numeroSerie');
                //<DA> - 29/12/2017: Devuelvo tambien el IMSI y el KI
                String imsi = (String) responseNmu.get('imsi');
                String ki = (String) responseNmu.get('ki');

                System.debug('IMSI: ' + imsi);
                System.debug('KI: ' + ki);
                serialNode.put('IMSI', imsi);
                serialNode.put('KI', ki);
                serialNode.put('aduanaIngreso', (String) responseNmu.get('aduanaIngreso'));
                serialNode.put('paisOrigen', (String) responseNmu.get('paisOrigen'));
                serialNode.put('codOrdenDespacho', (String) responseNmu.get('codOrdenDespacho'));
                //</DA>
                serialNode.put('serial', serial);
                serialNode.put('serialValidado', serial);
                serialNode.put('validacionSerial', 'El ICCID fue asignado');
                return true;
            }else{
                System.debug('response: ' + output);
                serialNode.put('serial', null);
                //<DA> 29/12/2017
                serialNode.put('IMSI', null);
                serialNode.put('KI', null);
                serialNode.put('aduanaIngreso', null);
                serialNode.put('paisOrigen', null);
                serialNode.put('codOrdenDespacho', null);
                //</DA> 29/12/2017
                serialNode.put('serialValidado', null);
                serialNode.put('validacionSerial', 'No se encontraron seriales disponibles para la venta');
                return false;
            }
        }
        catch(Exception e){
            System.debug('ICCIDManager:GetSimcardsSerial -> exception: '+e);
            return null;
        }
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
            String body = '{"body":{"listaNumeroSerie":[';
            Integer count = 0;
            for(String serial : serials.KeySet())
            {
                if (count > 0) body += ',';
                body += '{"numeroSerie":"' + serial + '"}';
                count++;
            }
            body += ']}}';
            input = (Map<String, Object>)JSON.deserializeUntyped(body);
            
            System.debug('IFS_S095 - request: ' + input);
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            // if(!Test.isRunningTest()){
                integProcServ.invokeMethod(integProcName, input, output, options);
            // } else {
            //     Map<String,Object> IPResult = new Map<String,Object>();
                
            //     List<Object> listaNumeroSeries = new List<Object>();
            //     Map<String,Object> serialNode = new Map<String,Object>();
            //     serialNode.put('codNMU','codNMU');
            //     serialNode.put('imsi','imsi');
            //     serialNode.put('aduanaIngreso','aduanaIngreso');
            //     serialNode.put('paisOrigen','paisOrigen');
            //     serialNode.put('codOrdenDespacho','codOrdenDespacho');
            //     serialNode.put('codDeposito','codDeposito');
            //     serialNode.put('stockProducto','stockProducto');
            //     serialNode.put('numeroSerie','serial');
            //     listaNumeroSeries.add(serialNode);
            //     IPResult.put('listaNumeroSeries',listaNumeroSeries);
            //     output.put('IPResult',IPResult);
            // }
            System.debug('response s095: ' + JSON.serialize(output));
            System.debug('serials: ' + JSON.serialize(serials));
            
            Map<String, Object> response = (Map<String, Object>) output.get('IPResult');
            List<Object> listaNumeroSerie = (List<Object>) response.get('listaNumeroSerie');
            System.debug('listaNumeroSerie: ' + JSON.serialize(listaNumeroSerie));
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
        Map<String, String> oldSerialNumbers = new Map<String, String>();
        Map<String, String> newSerialNumbers = new Map<String, String>();
        Boolean deReserveDone = false;
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
            
            /*PTFA-6033*/
            //String stockProducto = 'MTPL';            
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
                        oldSerialNumbers.put(oldSerial, (String) serialNode.get('oldStock'));
                    String stock = (String)serialNode.get('stockProducto');
                    newSerialNumbers.put(validatedSerial,stock);
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
            if (oldSerialNumbers.KeySet().size() > 0 && makeReserves)
            {
                if(!Test.isRunningTest())taOrderController.MoveSerialsStock(INSTANCE_VENTA_NORMAL,INSTANCE_ANULAR_RESERVA,oldSerialNumbers, codDeposito, deliveryMethod);
                deReserveDone = true;
            }
            if (newSerialNumbers.KeySet().size() > 0)
            {
                if (makeReserves)
                {
                    Map<String, String> newSerialNumbersForReserve = ClearStockOrigin(newSerialNumbers);//Para reservar se debe enviar NOAPLICA
                    if(!Test.isRunningTest())taOrderController.MoveSerialsStock(INSTANCE_VENTA_NORMAL,INSTANCE_RESERVA,newSerialNumbersForReserve, codDeposito, deliveryMethod);
                    reserveDone = true;
                }
                List<OrderItem> orderItems = [ SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE Id in :wrapOrderItemsMap.KeySet()];
                for(OrderItem item : orderItems)
                {
                    WrapOrderItem wrapOrderItem = (WrapOrderItem) wrapOrderItemsMap.get(item.Id);
                    SetSerialItemAttributes (item, wrapOrderItem.ICCID, wrapOrderItem.IMSI, wrapOrderItem.KI, wrapOrderItem.AduanaIngreso, wrapOrderItem.PaisOrigen, wrapOrderItem.CodOrdenDespacho);
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
            if (reserveDone) taOrderController.MoveSerialsStock(INSTANCE_VENTA_NORMAL,INSTANCE_ANULAR_RESERVA,newSerialNumbers, codDeposito, deliveryMethod);
            if (deReserveDone)
            {
                Map<String, String> oldSerialNumbersForReserve = ClearStockOrigin(oldSerialNumbers);//Para reservar se debe enviar NOAPLICA
                if(!Test.isRunningTest())taOrderController.MoveSerialsStock(INSTANCE_VENTA_NORMAL,INSTANCE_RESERVA,oldSerialNumbersForReserve, codDeposito, deliveryMethod);
            }
            throw e;
        }
    }

    private void SetSerialItemAttributes (OrderItem item, String ICCID, String IMSI, String KI, String AduanaIngreso, String PaisOrigen, String CodOrdenDespacho){
        try
        {
            Map<String,String> attribs = new Map<String,String>();
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

    private Map<String,String> ClearStockOrigin (Map<String,String> oldSerialNumbersForReserve){
        Map<String, String> newSerialNumbersForReserve = new Map<String, String>();
        for(String serialForReserve : oldSerialNumbersForReserve.KeySet())
            newSerialNumbersForReserve.put(serialForReserve, STOCK_ORIGIN_NOAPLICA);
        return newSerialNumbersForReserve;
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

        Map<String, Object> request = new Map<String, Object>();

        //-----Datos para probar-------
        codDeposito = '1111';
        codPuntoDeVenta = null;
        codNMU = null;
        stockProducto = null;
        //-----------------------------

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

        String numeroComprobante = '123467989hfj';//order.vlocity_cmt__TrackingNumber__c;
        String reqBody = '{"body": {"numeroComprobante": "' + numeroComprobante + '",';
        reqBody += '"listaDetalleModificar": [';
        Boolean firstReg = true;
        if(Test.isRunningTest()) {
            serialsList = [SELECT Id, Product2.ProductCode, Product2.Name, Product2.vlocity_cmt__Type__c, vlocity_cmt__SerialNumber__c, vlocity_cmt__JSONAttribute__c, FromStock__c FROM OrderItem WHERE OrderId = :idOrder];
        }
        //
        for(OrderItem serialItem : serialsList)
            {
                String valorParametro = 'Linea:3886827428 Serie: 358176005195470 N. Desp IC04';
                String secuenciaProductoAdquirido = '12345601';//serialItem.Huawei_Invoice_Item_Sequence__c;
                Map<String,Object> jsonAttribute = AssetAttributesUtils.GetJSONAttribute(serialItem.vlocity_cmt__JSONAttribute__c, 'Charge Code');
                String codCargo = 'C_OT_MB_EQUIPMENT_SIM';
                /*
                if(jsonAttribute != null && jsonAttribute.get('value__c') != null){
                        codCargo = String.valueOf(jsonAttribute.get('value__c'));
                    }
                */
                if (!firstReg) reqBody += ',';
                firstReg = false;

                reqBody += '{"datosAdicionales":[{"nombreParametro":"IMEI","valorParametro":"' + valorParametro + '"}],';
                reqBody += '"codCargo": "' + codCargo + '","secuenciaProductoAdquirido": "' + secuenciaProductoAdquirido + '"}';
            }
        String impDiferida = 'N';
        String impFiscal = 'Y';
        String fechaAltaComprobante = '20170606121212';
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