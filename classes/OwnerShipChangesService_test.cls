@IsTest
public class OwnerShipChangesService_test {

     @IsTest static void invoke_GetOrdersToCreateOk(){
        
        String methodName = 'GetOrdersToCreate'; 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        OwnerShipChangesService testedClass = new OwnerShipChangesService();

        List<Order> orders = TestDataFactory.createOrders(1, TestDataFactory.createAccounts(1)[0]);

        List<Map<String, Object>> selectedAssets = new List<Map<String, Object>>();
        Map<String, Object> tmpAsset1 = new Map<String, Object>();
        tmpAsset1.put('Product Name', 'Product Name');
        tmpAsset1.put('AssetId', '32323');
        tmpAsset1.put('MSISDN', '123123');

        selectedAssets.add(tmpAsset1);
        selectedAssets.add(tmpAsset1);

        options.put('OrderId', orders[0].Id);
        options.put('ProductCode', 'FAN_PSERV_00001');
        options.put('SelectedAssets', selectedAssets);

        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        List<Map<String, Object>> retOrders = (List<Map<String, Object>>) outMap.get('Orders');

        System.assertEquals(2, retOrders.size());
        System.assertEquals(null, outMap.get('Error***'));
     }

    @IsTest static void invoke_GetOrdersToCreate_Exception(){
        
        String methodName = 'GetOrdersToCreate'; 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        OwnerShipChangesService testedClass = new OwnerShipChangesService();

        options.put('OrderId', '123');

        Test.startTest();
        Boolean resp = testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        List<Map<String, Object>> retOrders = (List<Map<String, Object>>) outMap.get('Orders');

        System.assertNotEquals(null, outMap.get('Error***'));
        System.assertEquals(false, resp);
    }

    @IsTest static void invoke_createCases_OK(){
        String methodName = 'createCases'; 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        OwnerShipChangesService testedClass = new OwnerShipChangesService();

        List<Account> lstAcc = TestDataFactory.createAccounts(1);
        List<Product2> lstProd = TestDataFactory.createProduct(1);
        List<Asset> lstAsset = TestDataFactory.createAssets(10, lstProd[0],lstAcc[0]);

        options.put('AccountId', lstAcc[0].Id);

        List<Map<String, Object>> orders = new List<Map<String, Object>>();
        Map<String, Object> tempOrd;

        for(Asset ast : lstAsset){
            tempOrd = new Map<String,Object>();
            tempOrd.put('assetId', ast.Id);
            orders.add(tempOrd);
        }

        options.put('Orders', orders);

        Test.startTest();
        Boolean resp = testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        List<Map<String, Object>> retOrders = (List<Map<String, Object>>) outMap.get('Orders');

        System.assertEquals(10, retOrders.size());
        System.assertEquals(null, outMap.get('Error***'));
    }

    @IsTest static void invoke_createCases_Excep(){
        String methodName = 'createCases'; 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        OwnerShipChangesService testedClass = new OwnerShipChangesService();

        options.put('Orders', null);

        Test.startTest();
        Boolean resp = testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        System.assertNotEquals(null, outMap.get('Error***'));
    }

    @IsTest static void invoke_checkoutOrders_OK(){
        String methodName = 'checkoutOrders'; 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        OwnerShipChangesService testedClass = new OwnerShipChangesService();

        List<Map<String, Object>> orders = new List<Map<String, Object>>();
        List<Account> lstAccs = TestDataFactory.createAccounts(1);

        Map<String, Object> tempOrd = new Map<String, Object>();
        tempOrd.put('AssetId', TestDataFactory.createAssets(1, TestDataFactory.createProduct(1)[0], lstAccs[0])[0].Id);
        tempOrd.put('OrderId', TestDataFactory.createOrders(1, lstAccs[0])[0].Id);

        orders.add(tempOrd);

        options.put('Orders', orders);

        Test.startTest();
        Boolean resp = testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        System.assertNotEquals(null, outMap.get('Error***'));
    }

    @IsTest static void invoke_addOrderLineRest_Error(){
        String methodName = 'addOrderLineRest'; 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        OwnerShipChangesService testedClass = new OwnerShipChangesService();

        List<Account> lstConsAccs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Account> lstBillAccs = TestDataFactory.createAccounts(1, 'Billing');


        List<Product2> lstProd = TestDataFactory.createProduct(1);
        List<Asset> lstAsst = TestDataFactory.createAssets(1, lstProd[0], lstConsAccs[0]);
        List<Order> lstOrder = TestDataFactory.createOrders(1, lstConsAccs[0]);

        inputMap.put('OrderId', lstOrder[0].id);
        inputMap.put('AccountId', lstConsAccs[0].id);
        inputMap.put('ContextId', lstBillAccs[0].id);
        inputMap.put('Asset', lstAsst[0].Id);

        Test.startTest();
        Boolean resp = testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        System.assertNotEquals(null, outMap.get('Error***'));
    }

    @IsTest static void invoke_updateOrderAccount_ok(){
        String methodName = 'updateOrderAccount'; 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        OwnerShipChangesService testedClass = new OwnerShipChangesService();

        Account billAcc = TestDataFactory.createAccounts(1, 'Billing')[0];
        Account consAcc = TestDataFactory.createAccounts(1, 'Consumer')[0];
        Order billOrd = TestDataFactory.createOrders(1, billAcc)[0];

        List<Map<String, Object>> orders = new List<Map<String, Object>>();

        Map<String, Object> tempMap = new Map<String, Object>();

        tempMap.put('OrderId', billOrd.Id);

        orders.add(tempMap);

        inputMap.put('Orders', orders);
        
        options.put('AccountId', consAcc.Id);

        Test.startTest();
        Boolean resp = testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        billOrd = [SELECT AccountId FROM Order WHERE Id = :billOrd.Id][0];

        System.assertEquals(null, outMap.get('Error***'));
        System.assertEquals(consAcc.Id, billOrd.AccountId);
    }

    @IsTest static void invoke_updateOrderAccount_Excep(){
        String methodName = 'updateOrderAccount'; 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        OwnerShipChangesService testedClass = new OwnerShipChangesService();

        Test.startTest();
        Boolean resp = testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        System.assertNotEquals(null, outMap.get('Error***'));
    }

    @IsTest static void invoke_GetAditionalPrepaidPlanAssetInfo_OK(){
        String methodName = 'GetAditionalPrepaidPlanAssetInfo'; 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        OwnerShipChangesService testedClass = new OwnerShipChangesService();

        List<Asset> lstAssets = TestDataFactory.createAssets(5, TestDataFactory.createProduct(1)[0], TestDataFactory.createAccounts(1)[0]);

        List<Map<String, Object>> allAssets = new List<Map<String, Object>>();

        Map<String, Object> tempMap;

        for(Asset ast : lstAssets){
            tempMap = new Map<String, Object>();
            tempMap.put('Id', ast.Id);
            allAssets.add(tempMap);
        }

        options.put('AllAssets', allAssets);

        Test.startTest();
        Boolean resp = testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        List<Object> allAssetsResp = (List<Object>) outMap.get('AllAssets');

        System.assertEquals(5, allAssetsResp.size());
        System.assertEquals(null, outMap.get('Error***'));
    }

}