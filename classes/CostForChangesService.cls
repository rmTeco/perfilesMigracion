global with sharing class CostForChangesService implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;

        try {
            if (methodName.equals('CreateOrders'))
                CreateOrders(inputMap, outMap, options);
            else if (methodName.equals('ApplyDiscountToOrderItems'))
                ApplyDiscountToOrderItems(inputMap, outMap, options);
            else if (methodName.equals('GetCostDetails'))
                GetCostDetails(inputMap, outMap, options);
            else if (methodName.equals('AddLineItemsToOrders'))
                AddLineItemsToOrders(inputMap, outMap, options);
            else if (methodName.equals('GetPriceBookEntriesIds'))
                GetPriceBookEntriesIds(inputMap, outMap, options);
            
            result = true;
        }
        catch(Exception ex) {
            outMap.put('error', ex.getMessage());
            result = false;
        }
        return result;
    }

    private void CreateOrders(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            List<Object> orders = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'Orders');
            Id priceListId = (Id)inputMap.get('PriceListId');
            
            List<Order> listOrderToUpdate = new List<Order>();

            for (Object orderObj : orders) {
                Map<String, Object> order = (Map<String, Object>) orderObj;
                String orderId = (String)order.get('OrderId');
                
                if (String.isEmpty(orderId)) {
                    orderId = CreateOrder(outMap, options, order);
                    
                    order.put('OrderId', orderId);
                }
                else {
                    Order orderToUpdate = new Order(Id=orderId);

                    orderToUpdate.vlocity_cmt__PriceListId__c = priceListId;

                    listOrderToUpdate.add(orderToUpdate);
                    //update orderToUpdate;
                }

                //AddLineItemToOrder(order, options);
            }
            
            If (listOrderToUpdate.size()>0){
              Update listOrderToUpdate;
            }


            outMap.put('Orders', orders);
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    private Id CreateOrder(Map<String,Object> outMap, Map<String,Object> options, Map<String, Object> order) {
        try {
            Map<String, Object> output = new Map<String, Object>();

            vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
            cpqAppHandler.invokeMethod('createCart', options, output, options);

            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult) output.get('result');
            Map<String, Object> fields = (Map<String, Object>) result.records[0].fields;
            String orderId = (String) fields.get('Id');
            
            return (Id)orderId;
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    
  @TestVisible private Map<String, Object> GetInputJson(Map<String, Object> order, Map<String, Object> options) {
        try {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> item = new Map<String, Object>();
            List<Map<String, Object>> items = new List<Map<String, Object>>();
            String productCode = (String)order.get('ProductCode');
            String priceBookId = (String)options.get('PriceBookId');

            /*PriceBookEntry priceBookEntry = [SELECT Id,
                                                    ProductCode,
                                                    Pricebook2Id
                                                FROM PriceBookEntry
                                                WHERE ProductCode = :productCode
                                                        AND Pricebook2Id = :priceBookId];*/
                                          
            //item.put('itemId', priceBookEntry.Id);
            item.put('itemId', '01u6C000000xL46QAE');
            
            items.add(item);

            input.put('cartId', order.get('OrderId'));
            input.put('items', items);

            return input;
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    private Map<String, Object> GetInputJson2(Map<String, Object> order, Map<String, Object> options) {
        try {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> item2 = new Map<String, Object>();
            List<Map<String, Object>> items = new List<Map<String, Object>>();

            item2.put('itemId', '01u6C000000xL46QAE');

            System.debug('item2: ' + item2);
            items.add(item2);

            input.put('cartId', order.get('OrderId'));
            input.put('items', items);

            return input;
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    private void ApplyDiscountToOrderItems(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            List<Object> orders = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'Orders');
            List<OrderItem> orderItemsToUpdate = new List<OrderItem>();

            for (Object orderObj : orders) {
                Map<String, Object> order = (Map<String, Object>) orderObj;

                List<Object> orderItems = VlocityOpenInterfaceHelper.getListObjectsFromMap(order, 'OrderItems');

                for (Object orderItemObj : orderItems) {
                    Map<String, Object> orderItemMap = (Map<String, Object>) orderItemObj;

                    Id orderItemId = (Id)orderItemMap.get('OrderItemId');

                    OrderItem orderItem = new OrderItem(Id = orderItemId);
                    orderItem.vlocity_cmt__OneTimeTotal__c = 0;

                    orderItemsToUpdate.add(orderItem);
                }
            }

            update orderItemsToUpdate;
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    private void GetPriceBookEntriesIds(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            List<Object> orders = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'Orders');
            String priceBookId = (String)options.get('PriceBookId');

            for (Object orderObj : orders) {
                Map<String, Object> order = (Map<String, Object>)orderObj;

                List<Object> orderItems = VlocityOpenInterfaceHelper.getListObjectsFromMap(order, 'OrderItems');
                
                List<Map<String, Object>> priceBookEntryList = new List<Map<String, Object>>();
                for(PriceBookEntry pbe: [SELECT Id, ProductCode, Pricebook2Id FROM PriceBookEntry Where Pricebook2Id = :priceBookId]){
                        Map<String, Object> pbeMapList = new Map<String, Object>();
                        pbeMapList.put('Id', pbe.Id);
                        pbeMapList.put('ProductCode', pbe.ProductCode);
    
                        priceBookEntryList.add(pbeMapList);
                }


                for (Object orderItemObj : orderItems) {
                    Map<String, Object> orderItem = (Map<String, Object>)orderItemObj;
                    String productCode = (String)orderItem.get('ProductCode');

                    for(integer i=0;i<priceBookEntryList.size();i++){
                        if(priceBookEntryList[i].get('ProductCode') == productCode){
                          orderItem.put('PriceBookEntryId', priceBookEntryList[i].get('Id')); 
                        }
                    }

                    
                }
            }

            outMap.put('Orders', orders);
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    private void GetCostDetails(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            List<Object> orders = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'Orders');
            List<Map<String, Object>> costDetails = new List<Map<String, Object>>();

            for (Object orderObj : orders) {
                Map<String, Object> order = (Map<String, Object>) orderObj;

                List<Object> orderItems = VlocityOpenInterfaceHelper.getListObjectsFromMap(order, 'OrderItems');

                for (Object orderItemObj : orderItems) {
                    Map<String, Object> orderItem = (Map<String, Object>) orderItemObj;
                    
                    Map<String, Object> costDetailRow = new Map<String, Object>();
                    costDetailRow.put('Service', order.get('ProductName'));
                    costDetailRow.put('Price', orderItem.get('UnitPrice'));

                    costDetails.add(costDetailRow);
                }                
            }
            
            outMap.put('CostDetails', costDetails);
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    private void AddLineItemsToOrders(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            List<Object> orders = (List<Object>)options.get('Orders');

            for (Object orderObj : orders) {
                Map<String, Object> order = (Map<String, Object>)orderObj;

                AddLineItemToOrder2(order, options);
            }
            
            outMap.put('Orders', orders);
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    private void AddLineItemToOrder2(Map<String, Object> order, Map<String, Object> options) {
        try {
            Map<String, Object> input = GetInputJson2(order, options);
            Map<String, Object> output = new Map<String, Object>();

            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod('Care_TestMultipleCATIToperations', input, output, options);

            input = null;

            order.put('OrderItems', output);
        }
        catch(Exception ex) {
            throw ex;
        }
    }
    
    //#### Estos métodos fueron comentados porque el OS CostForChanges no estaba calculando los costos de las operaciones
    //#### Hace falta validar si esta porción de código comentado se puede eliminar
    //#### Se trajo nuevamente la clase de SIT y se copió tal y como estaba allí
    //#### Cambio realizado el día 06 de marzo del 2018
    
    
    /*global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;

        try {
            if (methodName.equals('CreateOrders'))
                CreateOrders(inputMap, outMap, options);
            else if (methodName.equals('ApplyDiscountToOrderItems'))
                ApplyDiscountToOrderItems(inputMap, outMap, options);
            else if (methodName.equals('GetCostDetails'))
                GetCostDetails(inputMap, outMap, options);
            else if (methodName.equals('AddLineItemsToOrders'))
                AddLineItemsToOrders(inputMap, outMap, options);
            else if (methodName.equals('GetPriceBookEntriesIds'))
                GetPriceBookEntriesIds(inputMap, outMap, options);

            result = true;
        }
        catch(Exception ex) {
            outMap.put('error', ex.getMessage());
            result = false;
        }
        return result;
    }

    private void CreateOrders(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
           	System.debug('inputMap: '+ inputMap);
            System.debug('options: '+ options);
            List<Object> orders = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'Orders');
            Id priceListId = (Id)inputMap.get('PriceListId');

            for (Object orderObj : orders) {

                Map<String, Object> order = (Map<String, Object>) orderObj;
                String orderId = (String)order.get('OrderId');

                if (String.isEmpty(orderId)) {
                    orderId = CreateOrder(outMap, options, order);
                    order.put('IFOrderId', orderId);

                }
                else {
                    Order orderToUpdate = new Order(Id=orderId);

                    orderToUpdate.vlocity_cmt__PriceListId__c = priceListId;
                    update orderToUpdate;
                }

                //AddLineItemToOrder(order, options);
            }

            outMap.put('Orders', orders);
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    @TestVisible private static Id CreateOrder(Map<String,Object> outMap, Map<String,Object> options, Map<String, Object> order) {
        try {
            
            Id orderId = null;
            //if(!Test.isRunningTest()) {
	            Map<String, Object> output = new Map<String, Object>();
	
	            vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
	            cpqAppHandler.invokeMethod('createCart', options, output, options);
	
	            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult) output.get('result');
	            Map<String, Object> fields = (Map<String, Object>) result.records[0].fields;
	            orderId = (Id) fields.get('Id');
            //}
            return orderId;
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    /*
    @TestVisible private static void AddLineItemToOrder(Map<String, Object> order, Map<String, Object> options) {
        try {
            Map<String, Object> input = GetInputJson(order, options);
            Map<String, Object> output = new Map<String, Object>();

            vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
            cpqAppHandler.invokeMethod('postCartsItems', input, output, options);

            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult) output.get('result');

            for (vlocity_cmt.JSONRecord record : result.records) {
                Map<String, Object> orderItem  = new Map<String, Object>();
                List<Map<String, Object>> orderItems = new List<Map<String, Object>>();
                Map<String, Object> fields = (Map<String, Object>) record.fields;

                vlocity_cmt.JSONField oneTimeCharge = (vlocity_cmt.JSONField)fields.get('vlocity_cmt__OneTimeCharge__c');
                vlocity_cmt.JSONField unitPrice = (vlocity_cmt.JSONField)fields.get('UnitPrice');
                vlocity_cmt.JSONField orderItemId = (vlocity_cmt.JSONField)fields.get('Id');
                String productName = (String)fields.get('Name');

                orderItem.put('OneTimeCharge', oneTimeCharge.value);
                orderItem.put('UnitPrice', unitPrice.value);
                orderItem.put('OrderItemId', orderItemId.value);
                orderItem.put('ProductName', productName);

                orderItems.add(orderItem);
                order.put('OrderItems', orderItems);
            }
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    @TestVisible private static Map<String, Object> GetInputJson(Map<String, Object> order, Map<String, Object> options) {
        try {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> item = new Map<String, Object>();
            List<Map<String, Object>> items = new List<Map<String, Object>>();
            String productCode = (String)order.get('ProductCode');
            String priceBookId = (String)options.get('PriceBookId');

            /*PriceBookEntry priceBookEntry = [SELECT Id,
                                                    ProductCode,
                                                    Pricebook2Id
                                                FROM PriceBookEntry
                                                WHERE ProductCode = :productCode
                                                        AND Pricebook2Id = :priceBookId];

            //item.put('itemId', priceBookEntry.Id);
            item.put('itemId', '01u6C000000xL46QAE');

            items.add(item);

            input.put('cartId', order.get('OrderId'));
            input.put('items', items);

            return input;
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    @TestVisible private static Map<String, Object> GetInputJson2(Map<String, Object> order, Map<String, Object> options) {
        try {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> item2 = new Map<String, Object>();
            List<Map<String, Object>> items = new List<Map<String, Object>>();

            item2.put('itemId', '01u6C000000xL46QAE');

            System.debug('item2: ' + item2);
            items.add(item2);

            input.put('cartId', order.get('OrderId'));
            input.put('items', items);

            return input;
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    private void ApplyDiscountToOrderItems(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            List<Object> orders = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'Orders');
            List<OrderItem> orderItemsToUpdate = new List<OrderItem>();

            for (Object orderObj : orders) {
                Map<String, Object> order = (Map<String, Object>) orderObj;

                List<Object> orderItems = VlocityOpenInterfaceHelper.getListObjectsFromMap(order, 'OrderItems');

                for (Object orderItemObj : orderItems) {
                    Map<String, Object> orderItemMap = (Map<String, Object>) orderItemObj;

                    Id orderItemId = (Id)orderItemMap.get('OrderItemId');

                    OrderItem orderItem = new OrderItem(Id = orderItemId);
                    orderItem.vlocity_cmt__OneTimeTotal__c = 0;

                    orderItemsToUpdate.add(orderItem);
                }
            }

            update orderItemsToUpdate;
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    private void GetPriceBookEntriesIds(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            List<Object> orders = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'Orders');
            String priceBookId = (String)options.get('PriceBookId');

            for (Object orderObj : orders) {
                Map<String, Object> order = (Map<String, Object>)orderObj;

                List<Object> orderItems = VlocityOpenInterfaceHelper.getListObjectsFromMap(order, 'OrderItems');
                List<String> productCodes = new List<String>();

                for (Object orderItemObj : orderItems) {
                    Map<String, Object> orderItem = (Map<String, Object>)orderItemObj;
                    String productCode = (String)orderItem.get('ProductCode');
                    productCodes.add(productCode);

                    /*PriceBookEntry priceBookEntry = [SELECT Id,
                                                            ProductCode,
                                                            Pricebook2Id
                                                        FROM PriceBookEntry
                                                        WHERE ProductCode = :productCode
                                                                AND Pricebook2Id = :priceBookId];

                    //orderItem.put('PriceBookEntryId', priceBookEntry.Id);
                }
                List<PriceBookEntry> priceBookEntries = [SELECT Id,
                                                            ProductCode,
                                                            Pricebook2Id
                                                        FROM PriceBookEntry
                                                        WHERE ProductCode IN :productCodes
                                                                AND Pricebook2Id = :priceBookId];
                for(Object orderItemObj : orderItems){
                	Map<String, Object> orderItem = (Map<String, Object>)orderItemObj;
                	String productCode = (String)orderItem.get('ProductCode');
                	for(PriceBookEntry priceBookEntry: priceBookEntries){
                		if(productCode == priceBookEntry.ProductCode){
	                		orderItem.put('PriceBookEntryId', priceBookEntry.Id);
	                		continue;
                		}
	                }
                }

            }

            outMap.put('Orders', orders);
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    private void GetCostDetails(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            List<Object> orders = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'Orders');
            List<Map<String, Object>> costDetails = new List<Map<String, Object>>();

            for (Object orderObj : orders) {
                Map<String, Object> order = (Map<String, Object>) orderObj;

                List<Object> orderItems = VlocityOpenInterfaceHelper.getListObjectsFromMap(order, 'OrderItems');

                for (Object orderItemObj : orderItems) {
                    Map<String, Object> orderItem = (Map<String, Object>) orderItemObj;

                    Map<String, Object> costDetailRow = new Map<String, Object>();
                    costDetailRow.put('Service', order.get('ProductName'));
                    costDetailRow.put('Price', orderItem.get('UnitPrice'));

                    costDetails.add(costDetailRow);
                }
            }

            outMap.put('CostDetails', costDetails);
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    private void AddLineItemsToOrders(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            List<Object> orders = (List<Object>)options.get('Orders');

            for (Object orderObj : orders) {
                Map<String, Object> order = (Map<String, Object>)orderObj;

                AddLineItemToOrder2(order, options);
            }

            outMap.put('Orders', orders);
        }
        catch(Exception ex) {
            throw ex;
        }
    }

    @TestVisible private static void AddLineItemToOrder2(Map<String, Object> order, Map<String, Object> options) {
        try {
            Map<String, Object> input = GetInputJson2(order, options);
            Map<String, Object> output = new Map<String, Object>();

            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            if(!Test.isRunningTest())integProcServ.invokeMethod('Care_TestMultipleCATIToperations', input, output, options);

            input = null;

            order.put('OrderItems', output);
        }
        catch(Exception ex) {
            throw ex;
        }
    }*/
}