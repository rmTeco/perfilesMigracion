global with sharing class LinesManager implements vlocity_cmt.VlocityOpenInterface
{
    static final String reserveWSNumbersList = 'listaNumeros';//'listaNumeros';
    static final String reserveWSLineNumber = 'nroLinea';//'numero';
    static final String freeWSLineNumber = 'codigoResultado';
    static final String DESBLOQUEAR = 'DESBLOQ';

    public class ServiceException extends Exception {}

    global LinesManager() {}
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
         try
         {
            if (methodName.equals('GetLines'))
            {
                GetLines(inputMap, outMap, options);
            }
            if (methodName.equals('GetLinesForGeography'))
            {
                GetLinesForGeography(inputMap, outMap, options);
            }
            if (methodName.equals('GetLinesForGeographyTypeAhead'))
            {
                GetLinesForGeographyTypeAhead(inputMap, outMap, options);
            }
            if (methodName.equals('ValidateLinesQtty'))
            {
                ValidateLinesQtty(inputMap, outMap, options);
            }
            if (methodName.equals('UpdateOrderLineItems'))
            {
                UpdateOrderLineItems(inputMap, outMap, options);
            }
            if (methodName.equals('CreditRecharge'))
            {
                CreditRecharge(inputMap, outMap, options);
            }
            if (methodName.equals('ValidateLineAssignmentRequired'))
            {
                ValidateLineAssignmentRequired(inputMap, outMap, options);
            }
            result = false;
        }
         catch(Exception e)
        {
            System.debug('LinesManager:invokeMethod -> exception: '+e+e.getLineNumber());
            result = false;
        }
        return result;
    }

    void GetLines(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options)
    {
       System.debug('GetLines');
        Map<String, Object> order = (Map<String, Object>) options.get('Order');
        List<Object> planslist = (List<Object>) order.get('planes');

        Map<String,Object> account = (Map<String,Object>) options.get('Account');
        String province = (String) account.get('BillingState');
        String location = (String) account.get('BillingCity');

        order.put('lineasReservadas', true);
        for (Object p : planslist)
        {
            Map<String, Object> plan = (Map<String, Object>) p;
            plan.put('isSelected',true);
            List<Object> lines = (List<Object>)plan.get('lineas');
            List<Object> obtainedLines = ObtainLines(lines.size(),province, location, null);
            Integer countReserveLines = 0;
            for (Object l : lines)
            {
                Map<String, Object> line = (Map<String, Object>) l;
                line.put('isSelected',true);
                if (countReserveLines < obtainedLines.size())
                {
                    Map<String, Object> returnedLineNode = (Map<String, Object>) obtainedLines[countReserveLines];
                    String returnedLine = (String) returnedLineNode.get(reserveWSLineNumber);
                    line.put('linea', returnedLine);
                    line.put('location', location);
                    line.put('validacionLinea', null);
                }
                else
                {
                    order.put('lineasReservadas', false);
                    line.put('linea', null);
                    line.put('location', null);
                    line.put('validacionLinea', 'No se encontro linea disponible');
                }
                countReserveLines++;
            }
        }

        List<Map<String, Object>>  returnList = new List<Map<String,Object>>();
        returnList.add(order);
        outMap.put('options', returnList[0]);
    }

    void GetLinesForGeography(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options)
    {
        System.debug('GetLinesForGeography');
        Map<String,Object> dataInput = (Map<String,Object>) inputMap.get('LineAssignment');
        Map<String,Object> searchBlock = (Map<String,Object>) dataInput.get('SearchBlock');
        String province = (String) searchBlock.get('SelectProvincia');
        String location = (String) searchBlock.get('SelectLocalidad');
        String sufix = (String) searchBlock.get('Sufijo');
        /* Changes for US-6642
        Map<String,Object> dataInput = (Map<String,Object>) inputMap.get('LineAssignment');
        String province = (string)((Map<String,Object>) dataInput.get('SelectProvincia-Block')).get('SelectProvincia');
        String location = (string)((Map<String,Object>) dataInput.get('SelectLocalidad-Block')).get('SelectLocalidad');
        String sufix = (String) dataInput.get('Sufijo');
        */

        System.debug('province: ' + province);
        System.debug('location: ' + location);
        System.debug('sufix: ' + sufix);

        Map<String, Object> order = (Map<String, Object>) inputMap.get('Order');
        List<Object> planslist = (List<Object>) order.get('planes');
        System.debug('order: ' + (Map<String, Object>) inputMap.get('Order'));
        System.debug('planslist: ' + planslist.size());

        Map<String, String> linesForRelease = new Map<String, String>();

        order.put('lineasReservadas', true);
        for (Object p : planslist)
        {
            Map<String, Object> plan = (Map<String, Object>) p;
            System.debug('plan: ' + plan);

            List<Object> lines = (List<Object>)plan.get('lineas');
            System.debug('lines: ' + lines);
            Integer countSelectedLines = 0;
            for (Object l : lines)
            {
                Map<String, Object> line = (Map<String, Object>) l;
                System.debug('line: ' + line);
                Boolean lineIsSelected = (Boolean)line.get('isSelected');
                if (lineIsSelected) countSelectedLines++;
            }
            if (countSelectedLines > 0)
            {
                List<Object> obtainedLines = ObtainLines(countSelectedLines,province, location, sufix);
                Integer countReserveLines = 0;
                System.debug('obtainedLines: ' + obtainedLines);
                for (Object l : lines)
                {
                    Map<String, Object> line = (Map<String, Object>) l;
                    System.debug('line: ' + line);
                    Boolean lineIsSelected = (Boolean)line.get('isSelected');
                    if (lineIsSelected)
                    {
                        String lineAux = (String)line.get('linea');
                        System.debug('lineAux: ' + lineAux);
                        if ( lineAux !=null && String.isNotBlank(lineAux) )
                            linesForRelease.put(lineAux, DESBLOQUEAR);
                        if (obtainedLines != null && (countReserveLines < obtainedLines.size()))
                        {
                            Map<String, Object> returnedLineNode = (Map<String, Object>) obtainedLines[countReserveLines];
                            String auxLine = (String) returnedLineNode.get(reserveWSLineNumber);
                            line.put('linea', auxLine);
                            line.put('location', location);
                            line.put('validacionLinea', null);
                        }
                        else
                        {
                            order.put('lineasReservadas', false);
                            line.put('linea', null);
                            line.put('location', null);
                            line.put('validacionLinea', 'No se encontro linea disponible');
                        }
                        countReserveLines++;
                    }
                }
                for (Object l : lines) {

                    Map<String, Object> line = (Map<String, Object>) l;
                    system.debug('line'+line);
                    if(line.get('validacionLinea')!=null&&line.containsKey('validacionLinea'))
                    if (line.get('validacionLinea').equals('No se encontro linea disponible')) {
                        order.put('lineasReservadas', false);
                        break;
                    }
                }
           }
        }
        if (linesForRelease.KeySet().size() > 0)
            FreeReservedLines(linesForRelease);
        List<Map<String, Object>> returnList = new List<Map<String,Object>>();
        returnList.add(order);
        // Commented as part of bug fix PFTA-3553 (US:PFTA-696)
       // order.put('lineasReservadas', true);//SACAR
        system.debug('returnList'+returnList);
        outMap.put('options', returnList);
    }

    void GetLinesForGeographyTypeAhead(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options)
    {
        System.debug('GetLinesForGeographyTypeAhead');
        Map<String,Object> dataInput = (Map<String,Object>) inputMap.get('LineAssignment');
        Map<String,Object> searchBlock = (Map<String,Object>) dataInput.get('TypeAhead2-Block');
        String province = (String) dataInput.get('SeProvincia');
        String location = (String) searchBlock.get('LocationCode__c');
        String sufix = (String) dataInput.get('Sufijo2');


        Map<String, Object> order = (Map<String, Object>) inputMap.get('Order');
        System.debug('Orderrrr: ' + order);
        List<Object> planslist = (List<Object>) order.get('planes');
        System.debug('order: ' + (Map<String, Object>) inputMap.get('Order'));
        System.debug('planslist: ' + planslist.size());

        Map<String, String> linesForRelease = new Map<String, String>();

        order.put('lineasReservadas', true);

        for (Object p : planslist)
        {
            Map<String, Object> plan = (Map<String, Object>) p;
            System.debug('plan: ' + plan);

            List<Object> lines = (List<Object>)plan.get('lineas');
            System.debug('lines: ' + lines);
            Integer countSelectedLines = 0;
            for (Object l : lines)
            {
                Map<String, Object> line = (Map<String, Object>) l;
                System.debug('line: ' + line);
                Boolean lineIsSelected = (Boolean)line.get('isSelected');
                if (lineIsSelected) countSelectedLines++;
            }
            if (countSelectedLines > 0)
            {
                System.debug('LineNumber Search call'+countSelectedLines);
                List<Object> obtainedLines = ObtainLines(countSelectedLines,province, location, sufix);
                System.debug('LineNumber Search call Res'+obtainedLines);
                Integer countReserveLines = 0;
                System.debug('obtainedLines: ' + obtainedLines);
                for (Object l : lines)
                {
                    Map<String, Object> line = (Map<String, Object>) l;
                    System.debug('line: ' + line);
                    Boolean lineIsSelected = (Boolean)line.get('isSelected');
                    if (lineIsSelected)
                    {
                        String lineAux = (String)line.get('linea');
                        System.debug('lineAux: ' + lineAux);
                        if ( lineAux !=null && String.isNotBlank(lineAux) )
                            linesForRelease.put(lineAux, DESBLOQUEAR);
                        if (obtainedLines != null && (countReserveLines < obtainedLines.size()))
                        {
                            Map<String, Object> returnedLineNode = (Map<String, Object>) obtainedLines[countReserveLines];
                            String auxLine = (String) returnedLineNode.get(reserveWSLineNumber);
                            line.put('linea', auxLine);
                            line.put('location', location);
                            line.put('validacionLinea', null);
                        }
                        else
                        {
                            order.put('lineasReservadas', false);
                            line.put('linea', null);
                            line.put('location', null);
                            line.put('validacionLinea', 'No se encontro linea disponible');
                        }
                        countReserveLines++;
                    }
                }
                for (Object l : lines) {
                    Map<String, Object> line = (Map<String, Object>) l;
                    if(line.get('validacionLinea')!=null&&line.containsKey('validacionLinea'))
                    if (line.get('validacionLinea').equals('No se encontro linea disponible')) {
                        order.put('lineasReservadas', false);
                        break;
                    }
                }
            }
        }
        if (linesForRelease.KeySet().size() > 0)
            FreeReservedLines(linesForRelease);
        List<Map<String, Object>> returnList = new List<Map<String,Object>>();
        returnList.add(order);
        outMap.put('options', returnList);
    }

    private List<Object> ObtainLines(Integer ammount, String state, String city, String sufix)
    {
        System.debug('ObtainLines');
        try
        {
            List<Object> lineas = new List<Object>();

            CpqMobileNumbering__c mobileNumberingSetting = CpqMobileNumbering__c.getInstance('Default');
            system.debug('llamando a IFS_S121_numerosDisponibles');
            String idUnicoTransaccion = GuidUtil.NewGuid();
            System.debug('LinesManager:idUnicoTransaccion: ' + idUnicoTransaccion);
            Map<String,Object> numerosDisponibles = IFS_S121_numerosDisponibles.numerosDisponibles(ammount, state, city, sufix, null, null, null, mobileNumberingSetting.MobileNumberType__c, idUnicoTransaccion);
            system.debug('IFS_S121'+ numerosDisponibles);
            String httpStatusCode = (String) numerosDisponibles.get('httpStatusCode');
            System.debug('lineas ObtainLines: ' + lineas);
            if (httpStatusCode == '200')
            {
               lineas = (List<Object>) numerosDisponibles.get(reserveWSNumbersList);
              // lineas = (List<Object>) JSON.deserializeUntyped('[ { "nroLinea":"1151090838", "IdReserva":"" }, { "nroLinea":"1151091200", "IdReserva":"" }, { "nroLinea":"1151091488", "IdReserva":"" } ]') ;
            }

            System.debug('lineas ObtainLines: ' + lineas);
            return lineas;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    public void UpdateOrderLineItems(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options)
    {
        System.debug('UpdateOrderLineItems');
        try
        {
            Map<String, Object> order = (Map<String, Object>) options.get('Order');
            List<Object> planslist = (List<Object>) order.get('planes');
            List<String> locationsCodes = new List<String>();
            Map<Id, Map<String, String>> linesNumbers = new Map<Id, Map<String, String>>();

            for (Object p : planslist)
            {
                Map<String, Object> plan = (Map<String, Object>) p;
                List<Object> lines = (List<Object>)plan.get('lineas');
                for (Object l : lines)
                {
                    Map<String, Object> line = (Map<String, Object>) l;
                    Id itemId = (Id) line.get('orderItemParentId');
                    String lineNumber = (String) line.get('linea');
                    String location = (String) line.get('location');
                    Map<String, String> lineLocationMap = new Map<String, String>();
                    lineLocationMap.put(lineNumber, location);
                    linesNumbers.put(itemId, lineLocationMap);
                    locationsCodes.add(location);
                }
            }
            System.debug('locationsCodes: ' + locationsCodes);
            List<Location__c> locations = [SELECT Id, LocationCode__c FROM Location__c WHERE LocationCode__c IN :locationsCodes];
            Map<String, String> locationsMap = new Map<String, String>();
            for (Location__c location : locations)
            {
                locationsMap.put(location.LocationCode__c, location.Id);
            }
            System.debug('locationsMap: ' + JSON.serialize(locationsMap));
            List<OrderItem> orderItems = [SELECT Id, LocationCode__c, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE Id IN :linesNumbers.KeySet()];
            for (OrderItem item : orderItems)
            {
                Map<String, String> lineLocationMap = (Map<String, String>) linesNumbers.get(item.Id);
                String lineNumber;
                for (String lineNumberAux : lineLocationMap.KeySet()) lineNumber = lineNumberAux;
                String location = (String) lineLocationMap.get(lineNumber);
                System.debug('item.Id: ' + item.Id);
                System.debug('lineNumber: ' + lineNumber);
                System.debug('location: ' + location);
                Map<String,String> attribs = new Map<String,String>();
                attribs.put('Numero de Linea', lineNumber);
                String jsonAttribute = AssetAttributesUtils.setValuesOnJSON(item.vlocity_cmt__JSONAttribute__c, attribs);
                item.vlocity_cmt__JSONAttribute__c = jsonAttribute;
                item.LocationCode__c = (Id) locationsMap.get(location);
                System.debug('item.LocationCode__c: ' + item.LocationCode__c);
            }

            update orderItems;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    public String FreeReservedLines(Map<String, String> linesForRelease)
    {
        System.debug('FreeReservedLines');
        try
        {
            String integProcName = 'IFS_S326';
            Map<String, Object> input2 = new Map<String, Object>();
            Map<String, Object> output2 = new Map<String, Object>();
            Map<String, Object> options2 = new Map<String, Object>();
            String body = IntegrationUtils.GenerateBodyS326(linesForRelease);
            System.debug('body: '+body);
            input2 = (Map<String, Object>) JSON.deserializeUntyped(body);
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod(integProcName, input2, output2, options2);
            System.debug('output: ' + output2);
            Map<String, Object> IPResult = (Map<String, Object>) output2.get('IPResult');
            if (IPResult != null && IPResult.KeySet().size() > 0)
            {
                System.debug('response: '+IPResult);
                String codigo = (String) IPResult.get('codigo');
                String mensaje = (String) IPResult.get('mensaje');
                String errorMessage = 'ERROR LinesManager.FreeReservedLines(';
                for(String linea : linesForRelease.KeySet())
                    errorMessage += linea + ',';
                errorMessage += '). Codigo: ' + codigo + ', mensaje: ' + mensaje;
                System.debug('ErrorMessage: '+ errorMessage);

                if(!Test.isRunningTest()){
                    throw new FuncException(errorMessage);
                }
            }
            return JSON.serialize(IPResult);
        }
        catch(Exception e)
        {
            throw e;
        }
    }
    
    void ValidateLinesQtty(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        System.debug('Validate Lines Qtty');
        //Get the value of the permited qtty from a custom setting
        LinesSetting__c linesSetting = LinesSetting__c.getInstance();
        Integer maxLinesQtty = Integer.valueOf(linesSetting.CantidadDeLineas__c);
        Boolean IsPrepaidPlan = true;
        Id orderId = (Id) options.get('IdOrder');
        Id itemToAddProductId = (Id) options.get('ItemToAddProductId');
        String itemToAddProductType = (String) options.get('ItemToAddProductType');
        System.debug('orderId : ' + orderId);
        System.debug('maxLinesQtty : ' + maxLinesQtty);

        Order Ord = [SELECT Id, AccountId,Account.vlocity_cmt__RootAccountId__c FROM Order WHERE Id =: orderId LIMIT 1] ;

        Map<Id, Order> mapOrderIdsOfClient = new Map<Id, Order>([SELECT Id FROM Order WHERE AccountId =: ord.accountId]);

        //List<Asset> assetsOfClient = [SELECT id FROM Asset WHERE Product2.Family = 'prepaid' AND AccountId =: ord.accountId];
        List<Asset> assetsOfClient = [SELECT id FROM Asset WHERE Product2.vlocity_cmt__Type__c = 'Plan Prepago' AND AccountId =: ord.accountId];

        //List<OrderItem> orderItems = [SELECT Id, OrderId FROM OrderItem WHERE Product2.Family = 'prepaid' AND OrderId IN :mapOrderIdsOfClient.keySet()];
        List<OrderItem> orderItems = [SELECT Id, OrderId FROM OrderItem WHERE Product2.vlocity_cmt__Type__c = 'Plan Prepago' AND OrderId IN :mapOrderIdsOfClient.keySet()];

        List<OrderItem> actualorderItems = new List<OrderItem>();
        for (OrderItem ordItem : orderItems) {
            if (ordItem.OrderId == orderId)
                actualorderItems.add(ordItem);
        }

        Integer simcardToAdd = 0;
        if (itemToAddProductType == 'Simcard')  simcardToAdd++;
        else
        {
            List<vlocity_cmt__ProductChildItem__c> itemToAdd = [SELECT Id FROM vlocity_cmt__ProductChildItem__c WHERE vlocity_cmt__ParentProductId__c = :itemToAddProductId AND vlocity_cmt__ChildProductId__r.vlocity_cmt__Type__c = 'Simcard'];
            simcardToAdd = itemToAdd.size();
        }

        if (simcardToAdd > 0)
        {
            //Validate Lines Qtty all Assets
            if (assetsOfClient.size() + simcardToAdd > maxLinesQtty) {
                outMap.put('LinesError', Label.LinesQttyAllAssetsValidation);
            }
            //Validate Lines Qtty all Orders
            else if (orderItems.size() > maxLinesQtty) {
                outMap.put('LinesError', Label.LinesQttyAllOrdersValidation);
            }
            //Validate Lines Qtty actual Order
            else if (simcardToAdd > maxLinesQtty) {
                outMap.put('LinesError', Label.LinesQttyActualOrderValidation);
            }
        }

        System.debug('simcardToAdd: ' + simcardToAdd);
        System.debug('assetsOfClient: ' + assetsOfClient.size());
        System.debug('orderItems.size(): ' + orderItems.size());

        //PFTA - 10409 - Se limita temporalmente la activacion de 1 linea por orden
        List<OrderItem> itemsAdded = [SELECT Id FROM OrderItem WHERE OrderId = :orderId AND Product2.vlocity_cmt__Type__c = 'Simcard'];
        if (itemsAdded.size() + simcardToAdd > 1) {
            outMap.put('LinesError', 'No es posible agregar mas de una línea por orden');
        }
    }

    void CreditRecharge(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        System.debug('CreditRecharge');
        try
        {
            String integProcName = 'IFS_S143';
            Map<String, Object> input2 = new Map<String, Object>();
            Map<String, Object> output2 = new Map<String, Object>();
            Map<String, Object> options2 = new Map<String, Object>();
            //String nroLinea = '13800010031';
            //String importeRecarga = '100';//options.get('ChargeAmmount');
            //DA - 9/1/18: Conecto los parametros de entrada
            String nroLinea = (String) options.get('nroLinea');
            String subscriptionId = (String) options.get('subscriptionId');
            Decimal dimporteRecarga = (Decimal) options.get('ChargeAmmount');
            String importeRecarga = dimporteRecarga.toPlainString();
            System.debug('inputs: nrolinea=' +nroLinea+' importe='+ importeRecarga+' subscriptionId='+subscriptionId);
            //String body = '{"body":{"listaNumeroSerie":[{"numeroSerie":"' + serial + '"}]}}';


            //String body = '{"body" :{"codigoAccesoSuscriptor": {"codSuscripcion":"' + nroLinea + '"},';
            String body = '{"body" :{"codigoAccesoSuscriptor": {"codSuscripcion":"' + subscriptionId + '"},';
            //PFTA-11363. No se debe enviar informacion de una recarga Scratch nula en una recarga de credito. Se agregó logica para clase test
            body += '"codMotivoRecarga": "62","infoRecarga": {';
            body += '"listPagoEfectivo": [{"montoRecarga": ' + importeRecarga + ',';
            body += '"infoBanco":{"codEntidadFinanciera": "","codSucursalEntidad": "","codMedioPago": "","ultimosDigitosTarjeta": "","codEntidadTC": "","nombreEntidadFinanciera": "","fechaVencimientoTarjeta": "","codSeguridadTarjeta": "","nroCheque": "","fechaEmisionCheque": "","cantidadCuotasTarjeta": ""}}]';
            body += '},"listaDatosAdicionales": [{"nombreParametro": "","valorParametro": ""}]}}';

            System.debug('body: '+body);
            //options2.put('body', body);
            //input2.put('body', body);
            input2 = (Map<String, Object>) JSON.deserializeUntyped(body);
            Map<String, Object> IPResult = new Map<String, Object>();
            String txId;
            if(!Test.isRunningTest()) {
                vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                integProcServ.invokeMethod(integProcName, input2, output2, options2);
                System.debug('output: ' + output2);
                IPResult = (Map<String, Object>) output2.get('IPResult');
                txId = (String) IPResult.get('txId');
                System.debug('response: '+IPResult);
            } else {
                txId = '260174721';
                outMap.put('Error','fallo el servicio');
            }
            System.debug('txId: ' + txId);

            if (txId == null) {
                String txError = (String) IPResult.get('mensaje');
                System.debug('txError: ' + txError);
                if (txError != null){
                    outMap.put('Error',txError);
                    //throw new ServiceException(txError);
                }
                else{
                    outMap.put('Error', 'Error al invocar el servicio 143: ' + output2);
                    //throw new ServiceException('Error al invocar el servicio 143 Recarga de Credito');
                }
            }
            else{
                outMap.put('txId',txId);
            }
        }
        catch(Exception e){
            System.debug('LinesManager:CreditRecharge -> exception: '+e);
        }
    }

    void ValidateLineAssignmentRequired(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Id orderId = (Id) options.get('IdOrder');
        Boolean required = false; 
        /*Busco si en la orden hay un simcard para asignar líneas */ 
        Order order = [
            SELECT Id,
            (SELECT Id, Product2.ProductCode, Product2.Name,
            Product2.vlocity_cmt__Type__c FROM OrderItems WHERE Product2.vlocity_cmt__Type__c='Simcard') FROM Order WHERE Id = :orderId LIMIT 1
        ];

        if(order.OrderItems.size() > 0){
            required = true; 
        }
        
        outMap.put('LineAssignmentRequired', required);

    }

}