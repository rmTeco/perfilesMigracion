global with sharing class taSalesChangeTerminalInWarrantyHandler implements vlocity_cmt.VlocityOpenInterface
{
    public static final String CONST_CHANNEL_PRESENTIAL = 'Presencial';
    public static final String CONST_TANGIBLE_CONSIGNADO = 'MTPL';
    
    global static Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
            {
            if (methodName.equals('ValidateRazonSocial')){
                Id assetId = (Id)options.get('assetId');
                outMap.put('data', ValidateRazonSocial(assetId));
            }
            if (methodName.equals('ValidateTangibleConsignado')){
                Id assetId = (Id)options.get('assetId');
                outMap.put('data', ValidateTangibleConsignado(assetId));
            }
            if (methodName.equals('GetOrderByAsset')){
                Id assetId = (Id)options.get('assetId');
                Order order = AssetUtils.getOrderByAsset(assetId);
                outMap.put('data', order);
            }
            if (methodName.equals('ValidateClientMaterial')){
                Id assetId = (Id)options.get('assetId');
                options.put('data', ValidateClientMaterial(assetId));
            }
            // if (methodName.equals('ValidateOrdenST')){
            //     ValidateOrdenST(inputMap, outMap, options);
            // }
            if (methodName.equals('GetTypesChangeTerminal')){
                System.debug('methodName: ' + methodName);
                System.debug('inputMap: ' + JSON.serialize(inputMap));
                System.debug('outMap: ' + JSON.serialize(outMap));
                System.debug('options: ' + JSON.serialize(options));
                
                Id assetId = (Id)inputMap.get('assetId');
                system.debug('assetId: ' + assetId);
                List<Map<String, String>> availableMethods = GetTypesChangeTerminal(assetId);
                outMap.put('options', availableMethods);
            }
            if (methodName.equals('GetOrderByAsset')){
                
                Id assetId = (Id)inputMap.get('assetId');
                Order order = AssetUtils.getOrderByAsset(assetId);
                outMap.put('data', order);
            }

            result = false;
        }
        catch(Exception e)
        {
            System.debug('invokeMethod -> exception: '+e);
            throw e;
        }
        return result;
    }

    public static Boolean ValidateRazonSocial(Id assetId)
    {
        try
        {        
            // Id assetId = (Id) options.get('assetId');
            Boolean mismaRazonSocial = false;

            // En vlocity_cmt__OrderProductId__c se guarda la instancia de order item de la order creadora de asset.
            System.debug('1');
            Order order = AssetUtils.getOrderByAsset(assetId);
            System.debug('2');
            vlocity_cmt__BusinessSite__c orderStore = [
                SELECT Id, Name, Channel__c, Channel_Type__c, Channel_Type_2__c, Channel_Type_3__c
                FROM vlocity_cmt__BusinessSite__c
                WHERE Id = :order.OriginStoreLocation__c];
            System.debug('1');
            system.debug('Origin store location =====> '+ order.OriginStoreLocation__c);
            vlocity_cmt__BusinessSite__c userStore = [
                SELECT Id, Name, Channel__c, Channel_Type__c, Channel_Type_2__c, Channel_Type_3__c
                    FROM vlocity_cmt__BusinessSite__c
                WHERE Id = :[
                    SELECT Id, Work_Place__c
                    FROM WorkTeam__c
                    WHERE Id = :[
                                    SELECT Id, Work_Team__c
                                        FROM Team_Member__c
                                    WHERE User_member__c = :UserInfo.getUserId()
                    ].Work_Team__c
            ].Work_Place__c];
            system.debug('userStore =====> '+userStore);
            
            // Misma razón social
            if(orderStore.Name == userStore.Name){
                mismaRazonSocial = true;
            } 

            return mismaRazonSocial;
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    public static Boolean ValidateTangibleConsignado(Id assetId)
    {
        try
        {
            Boolean existTangibleConsignado = false;

            Order order = AssetUtils.getOrderByAsset(assetId);
            
            //Se comprueban si existen TANGIBLES en orden
            List<OrderItem> orderItems = new List<OrderItem>();
            orderItems = [SELECT Id, Product2.ProductCode, Product2.Name, FromStock__c, Product2.Tangible__c
                        FROM OrderItem
                        WHERE OrderId = :order.Id];
            for(OrderItem item : orderItems)
            {
                //Se comprueba si es tangible
                if(item.Product2.Tangible__c)
                {
                    //Se comprueba si es un tangible CONSIGNADO
                    if(item.FromStock__c.equals(CONST_TANGIBLE_CONSIGNADO))
                    {
                        existTangibleConsignado = true;
                    }
                }
            }

            return existTangibleConsignado;
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
    
    public static Boolean ValidationTimeDefenseConsumer(Id assetId){
        try{
            Decimal timeLimit = 0;
            Date dateStart;      
            System.debug('assetId: ' + assetId);
            Order order = AssetUtils.getOrderByAsset(assetId);
            System.debug('order' + order);
            vlocity_cmt__BusinessSite__c storeLocation = [SELECT Id, Channel__c, vlocity_cmt__State__c
                                                        FROM vlocity_cmt__BusinessSite__c
                                                        WHERE Id = :order.OriginStoreLocation__c];
            System.debug(storeLocation.Channel__c);
            System.debug(storeLocation.vlocity_cmt__State__c);
            if([SELECT count() FROM WarrantyTimeLimit__c WHERE Channel__c = :storeLocation.Channel__c AND LocationCode__c = :storeLocation.vlocity_cmt__State__c] > 0)
                timeLimit = [SELECT TimeLimit__c
                            FROM WarrantyTimeLimit__c
                            WHERE LocationCode__c = :storeLocation.vlocity_cmt__State__c
                                AND Channel__c = :storeLocation.Channel__c].TimeLimit__c;
            else if([SELECT count() FROM WarrantyTimeLimit__c WHERE LocationCode__c = :storeLocation.vlocity_cmt__State__c AND Channel__c = null] > 0)
                timeLimit = [SELECT TimeLimit__c
                            FROM WarrantyTimeLimit__c
                            WHERE LocationCode__c = :storeLocation.vlocity_cmt__State__c
                                AND Channel__c = null].TimeLimit__c;
            else
                timeLimit = [SELECT TimeLimit__c
                                FROM WarrantyTimeLimit__c
                                WHERE Channel__c = null
                                AND LocationCode__c = null].TimeLimit__c;
            System.debug(order.Delivery_Method__c);
            if(order.Delivery_Method__c.equals(CONST_CHANNEL_PRESENTIAL)){
                System.debug('131');
                dateStart = date.newinstance(order.CreatedDate.year(), order.CreatedDate.month(), order.CreatedDate.day());
            }else{
                System.debug('132');
                dateStart = date.newinstance(order.DeliveryDate__c.year(), order.DeliveryDate__c.month(), order.DeliveryDate__c.day());
            }

            System.debug('14');
            Boolean validTime = dateStart.daysBetween(system.today()) <= timeLimit;

            return validTime;

        }catch(Exception e){
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    public static Boolean ValidateClientMaterial(Id assetId){
        try
        {
            boolean isValid = false;
            System.debug(assetId);
            String inputSerial = [SELECT SerialNumber FROM Asset WHERE Id = : assetId].SerialNumber;
            System.debug(inputSerial);
            Map<String, Object> serialsMap = new Map<String, Object>();
            serialsMap.put(inputSerial, new Map<String, Object>());
            //accedo a los valores del nuevo custom setting StockMovementConfiguration__c
            StockMovementConfiguration__c stockConf = StockMovementConfiguration__c.getInstance(UserInfo.getProfileId());
            
            String codDeposito = stockConf.Codigo_Deposito__c;
            String matClient = stockConf.Material_del_Cliente__c;
            List<String> stocks =  new  List<String> { matClient };
            
            IccidManager manager = new IccidManager();
            manager.ValidateSerialNumbers(serialsMap, codDeposito, stocks);
            Map<String,Object> inputserial2 = (Map<String,Object>)serialsMap.get(inputSerial);

            //Object serialValidado = serialsMap.get('serialValidado');
            System.debug(JSON.serialize(inputserial2));
            system.debug('inputSerial2 =====> '+inputserial2.get('serialValidado'));
            if(inputserial2.get('serialValidado') != null){
                isValid = true;
            }
            system.debug('isValid =====> '+isValid);
            return isValid;
        }
        catch(Exception e){
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
    
    public static Boolean ValidateOrdenST(Id assetId)
    {
        try
        {
            System.debug('assetId: ' + assetId);
            // Id assetId = (Id) options.get('assetId');
            List<String> atributoABuscar = new List<String>();
            atributoABuscar.add('Susceptible de Servicio Tecnico');
            Map<String,Object> valorAtributo = AssetAttributesUtils.getAssetAttribute(assetId, atributoABuscar);
            Boolean stValidation = Boolean.valueOf((String)valorAtributo.get('Susceptible de Servicio Tecnico'));
            return stValidation;
        }
        catch(Exception e){
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    // public static void GetTypesChangeTerminal(Map<String,Object> inputMap, Map<String, Object> outMap){
    //     Id assetId = (Id)inputMap.get('assetId');
    //     List<Map<String, String>> availableMethods = getTypesChangeTerminal(assetId);
    //     outMap.put('options', availableMethods);
    // }    
    
    public static List<Map<String, String>> GetTypesChangeTerminal(Id assetId){
        List<Map<String, String>> availableMethods = new List<Map<String, String>>();
        System.debug('assetId: ' + assetId);
        Map<String, String> tempMap = new Map<String, String>();
        System.debug('1');
        if(ValidateOrdenST(assetId)){
            tempMap.put('name', 'Orden de ST');
            tempMap.put('value', 'Orden de ST');
            availableMethods.add(tempMap);
        } else {
            tempMap.put('name', 'Terminal sin ST');
            tempMap.put('value', 'Terminal sin ST');
            availableMethods.add(tempMap);
        }
        System.debug('2');
        
        // tempMap = new Map<String, String>();
        // tempMap.put('name', 'Fallas reiteradas');
        // tempMap.put('value', 'Fallas reiteradas');
        // availableMethods.add(tempMap);
        System.debug('3');
        if(ValidationTimeDefenseConsumer(assetId)){
            tempMap = new Map<String, String>();
            tempMap.put('name', 'Ley de defensa del consumidor');
            tempMap.put('value', 'Ley de defensa del consumidor');
            availableMethods.add(tempMap);
        }
        
        System.debug(JSON.serialize(availableMethods));
        
        return availableMethods;
    }
    
}