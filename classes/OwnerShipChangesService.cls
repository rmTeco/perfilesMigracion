global with sharing class OwnerShipChangesService implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            if (methodName.equals('GetOrdersToCreate')) {
                GetOrdersToCreate(inputMap, outMap, options);
            } else if (methodName.equals('createCases')) {
                createCases(inputMap, outMap, options);
            } else if (methodName.equals('checkoutOrders')) {
                checkoutOrders(inputMap, outMap, options);
            } else if (methodName.equals('updateOrderAccount')) {
                updateOrderAccount(inputMap, outMap, options);
            } else if (methodName.equals('GetAditionalPrepaidPlanAssetInfo')) {
                GetAditionalPrepaidPlanAssetInfo(inputMap, outMap, options);
            } else if (methodName.equals('addOrderLineRest')) {
                addOrderLineRest(inputMap, outMap, options);
            }

            return true;
            
        } catch(Exception ex) {
            system.debug('Error***' + ex.getStackTraceString());
            outMap.put('Error***', ex.getStackTraceString());
            return false;
        }
    }
    
    private void GetOrdersToCreate(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        try {
            
            List<Object> selectedAssets = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'SelectedAssets'); 
            List<Map<String, Object>> orders = new List<Map<String, Object>>();
            Id orderId = (Id) options.get('OrderId');
            Boolean firstTime = true;
            
            for (Object assetObj : selectedAssets) {
                Map<String, Object> asset = (Map<String, Object>)assetObj;
                Map<String, Object> orderElement = new Map<String, Object>();
                Map<String, Object> orderItem = new Map<String, Object>();
                List<Map<String, Object>> orderItems = new List<Map<String, Object>>();
                
                orderItem.put('ProductCode', (String)options.get('ProductCode'));
                orderItems.add(orderItem);
                
                orderElement.put('OrderItems', orderItems);
                orderElement.put('AssetName', String.valueOf(asset.get('Product Name')));
                orderElement.put('AssetId', String.valueOf(asset.get('Id')));
                orderElement.put('MSISDN', String.valueOf(asset.get('MSISDN')));
                
                if (firstTime) {
                    orderElement.put('OrderId', orderId);
                }
                
                orders.add(orderElement);
                
                firstTime = false;
            }
            
            outMap.put('Orders', orders);
        }
        catch(Exception ex) {
            throw ex;
        }
    }
    
    private void GetAditionalPrepaidPlanAssetInfo(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        try {
            List<Object> allAssets = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'AllAssets');
            Set<Id> assetIds = new Set<Id>();
            for (Object ob : allAssets) {
                assetIds.add(String.valueOf((( Map<String, Object> ) ob).get('Id')));
            }
            Asset[] assetList = [SELECT Id, MSISDN__c FROM Asset WHERE Id IN :assetIds];
            for (Object ob : allAssets){
                for (Asset a : assetList) {
                    if ((( Map<String, Object> ) ob).get('Id').equals(a.Id) ) {
                        (( Map<String, Object> ) ob).put('MSISDN', a.MSISDN__c);
                    }
                }
            }
            outMap.put('AllAssets', allAssets);
        } catch (Exception ex) {
            throw ex;
        }
    }
    
    private void createCases(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        try {
            
            List<Object> accountId = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'AccountId');
            List<Object> selectedOrders = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'Orders');
            List<Case> casesList = new List<Case>();
            
            for (Object orderObject : selectedOrders) {
                
                String assetId = String.valueOf( ( ( Map<String, Object> ) orderObject ).get( 'AssetId' ) );
                Case newCase = new Case( Subject = 'Cambio de Titularidad', vlocity_cmt__ServiceId__c = assetId, AccountId = (Id)accountId.get(0));
                casesList.add( newCase );
            }
            Set<Id> caseIds = new Set<Id>();
            Database.SaveResult[] srList = Database.insert(casesList);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    caseIds.add(sr.getId());
                }
            }
            for(Case c : [SELECT Id, CaseNumber, vlocity_cmt__ServiceId__c FROM Case WHERE Id IN :caseIds]){
                for (Object orderObject : selectedOrders) {
                    String assetId = String.valueOf( ( ( Map<String, Object> ) orderObject ).get( 'AssetId' ) );
                    if (assetId == c.vlocity_cmt__ServiceId__c) {
                        ( ( Map<String, Object> ) orderObject ).put( 'CaseId', c.Id );
                        ( ( Map<String, Object> ) orderObject ).put( 'CaseNumber', c.CaseNumber );
                    }
                }
            }
            outMap.put('Orders', selectedOrders);
        } catch(Exception ex) {
            system.debug('Error: ' + ex);
            throw ex;
        }
    }
    
    private void updateOrderAccount(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            List<Object> selectedOrders = VlocityOpenInterfaceHelper.getListObjectsFromMap(inputMap, 'Orders');
            List<Order> orderList = new List<Order>();
            List<OrderItem> ordIList = new List<OrderItem>();
            String accountId = (String) options.get('AccountId');
            
            for (Object orderItem : selectedOrders) {
                String orderId = (String) ((Map<String,Object>)orderItem).get('OrderId');
                Order ord = new Order(Id = orderId, AccountId = accountId);
                orderList.add(ord);
            }
            update orderList;
        } catch(Exception ex) {
            system.debug('Error: ' + ex);
            throw ex;
        }
    }

    private void checkoutOrders(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        try {
            List<Map<String, Object>> orders = new List<Map<String, Object>>();
            List<Object> selectedOrders = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'Orders');
            Set<Id> ordersSet = new Set<Id>();
            List<Asset> assets = new List<Asset>();
            
            for (Object orderObject : selectedOrders) {
                String orderId = (String) ((Map<String,Object>)orderObject).get('OrderId');
                String assetId = (String) ((Map<String,Object>)orderObject).get('AssetId');
                assets.add(new Asset(Id = assetId, vlocity_cmt__OrderId__c = orderId));
                ordersSet.add((Id)orderId);
            }
            try {
                update assets;
            } catch (DMLException dmlEx){
                throw dmlEx;
            }
            
            //vlocity_cmt.CpqAppHandler appHandler = new vlocity_cmt.CpqAppHandler();
            
            //Map<String,Object> inputs = new Map<String,Object>();
            //Map<String,Object> output = new Map<String,Object>();
            //Map<String,Object> opt = new Map<String,Object>();
            
            //List<Id> orderList = new List<Id>();

            for (Id idItem : ordersSet) {
                vlocity_cmt.SimpleDecompositionManager.startOrderProcessing(idItem);
                vlocity_cmt.SimpleDecompositionController.decomposeOrder(idItem);
            }
        }
        catch(Exception ex) {
            system.debug('Error: ' + ex);
            throw ex;
        }
    }

    private void addOrderLineRest(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        try {
            
            String orderId = (String)inputMap.get('OrderId');
	        String accountId = (String)inputMap.get('AccountId');
	        String contextId = (String)inputMap.get('ContextId');
	        Object assetMap = (Object)inputMap.get('Asset');
            
            Map<String, Object> dateMap = new Map<String, Object>();
            dateMap.put('MoveOutDate', String.valueOf(Date.today()));
            dateMap.put('MoveInDate', String.valueOf(Date.today()));
            
            List<Object> itemList = new List<Object>();
            itemList.add(assetMap);
            options.put('JSON Node', 'AllAssets');
            inputMap.put('AllAssets',  itemList);
            options.put('jsonPath', '');
            inputMap.put('MoveInDate', Date.today());
            inputMap.put('MoveOutDate', Date.today()); 
            inputMap.put('moveInAccountId', AccountId);
            inputMap.put('moveOutAccountId', contextId);
            
            inputMap.put('OrderId', orderId);
            inputMap.put('SelectInOutDate',dateMap);
            
            vlocity_cmt.OmniMoveAssetWrapper moveAsset = new vlocity_cmt.OmniMoveAssetWrapper();
            moveAsset.invokeMethod('moveNewAssets', inputMap, outMap, options);
        } catch(Exception ex) {
            system.debug('Error: ' + ex);
            throw ex;
        }
    }
}