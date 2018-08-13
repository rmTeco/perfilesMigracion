global with sharing class taSalesCartContainerController implements vlocity_cmt.VlocityOpenInterface
{
    static final String prefaWStecnologiesAccesList = 'tecnologiasAcceso';

    public class ServiceException extends Exception {}

    public Boolean valor { get; set; }

    @RemoteAction
    global static Boolean CallPrefeasibility(string idOrder, string idAsset)
    {
        try
        {
            System.debug('CallPrefeasibility');
            System.debug(idOrder);
            Order order = [SELECT PrefeasibilityResult__c FROM ORDER WHERE Id = :idOrder];
            System.debug(order);
            if (!String.isNotBlank(order.PrefeasibilityResult__c))
            {
                String prefaResult = null;
                if (String.isNotBlank(idAsset))
                {
                    vlocity_cmt__Premises__c premise = GetAssetPremise(idAsset);
                    if (premise != null)
                        prefaResult = ObtainPrefeasibility(premise);
                }
                UpdateOrder(idOrder, prefaResult, null);
            }
            return true;
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            return false;
        }
    }

    private static vlocity_cmt__Premises__c GetAssetPremise(String idAsset)
    {
        System.debug('GetAssetPremise: ' + idAsset);
        try{
            Asset asset = [SELECT vlocity_cmt__PremisesId__r.Codigo_Localidad__c,
                vlocity_cmt__PremisesId__r.Codigo_Calle__c,
                vlocity_cmt__PremisesId__r.Altura__c,
                vlocity_cmt__PremisesId__r.Lote__c,
                vlocity_cmt__PremisesId__r.Numero_de_piso__c,
                vlocity_cmt__PremisesId__r.Departamento__c,
                vlocity_cmt__PremisesId__r.Edificio__c,
                vlocity_cmt__PremisesId__r.Manzana__c,
                vlocity_cmt__PremisesId__r.Codigo_Tipo_de_Zona__c,
                vlocity_cmt__PremisesId__r.vlocity_cmt__PremisesType__c,
                vlocity_cmt__PremisesId__r.Codigo_Calle_Rio_1__c,
                vlocity_cmt__PremisesId__r.Codigo_Calle_Rio_2__c,
                vlocity_cmt__PremisesId__r.Codigo_Calle_Rio_de_atras__c
                FROM Asset
                WHERE Id = :idAsset];
            System.debug('asset: ' + asset);
            return asset.vlocity_cmt__PremisesId__r;
        }
        catch(DmlException e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
    }

    private static String ObtainPrefeasibility(vlocity_cmt__Premises__c premise)
    {
        System.debug('ObtainPrefeasibility Premise');
        try
        {
            //String body = generateRequestBodyPrefactibilityService('null', 'CP', premise.Codigo_Localidad__c + premise.Codigo_Calle__c, String.valueof(premise.Altura__c), premise.Lote__c, '', premise.Numero_de_piso__c, premise.Departamento__c, premise.Edificio__c, premise.Manzana__c, premise.Codigo_Tipo_de_Zona__c, premise.vlocity_cmt__PremisesType__c, '', premise.Codigo_Calle_Rio_1__c, premise.Codigo_Calle_Rio_2__c, premise.Codigo_Calle_Rio_de_atras__c, '-34,549731', '-58,435258', '15CXV543', 'BEL','Voz', 'COBRE');
            //String jSonStringResponse = invokeRestService('http://52.67.109.234:8080/prefa/rest/prefeasibility/queryPrefeasibility', 'POST', body);
            String bodyFamilia = 'null';
            String bodyOperacion = 'CP';
            Map<String, Object> bodyDomicilio = new Map<String, Object>();
            bodyDomicilio.put('localizacion', premise.Codigo_Localidad__c + premise.Codigo_Calle__c);
            bodyDomicilio.put('altura', String.valueof(premise.Altura__c));
            bodyDomicilio.put('lote', premise.Lote__c);
            bodyDomicilio.put('torre', '');
            bodyDomicilio.put('piso', premise.Numero_de_piso__c);
            bodyDomicilio.put('departamento', premise.Departamento__c);
            bodyDomicilio.put('edificio', premise.Edificio__c);
            bodyDomicilio.put('manzana', premise.Manzana__c);
            bodyDomicilio.put('zona', premise.Codigo_Tipo_de_Zona__c);
            bodyDomicilio.put('tipoDomicilio', premise.vlocity_cmt__PremisesType__c);
            bodyDomicilio.put('sector', '');
            bodyDomicilio.put('entreCalle1', premise.Codigo_Calle_Rio_1__c);
            bodyDomicilio.put('entreCalle2', premise.Codigo_Calle_Rio_2__c);
            bodyDomicilio.put('calleAtras', premise.Codigo_Calle_Rio_de_atras__c);
            Map<String, Object> bodyCoord = new Map<String, Object>();
            bodyCoord.put('latitud', '-34,549731');
            bodyCoord.put('longitud', '-58,435258');
            Map<String, Map<String,Object>> bodyServicios = new Map<String, Map<String,Object>>();
            Map<String, Object> auxMap = new Map<String, Object>();
            auxMap.put('idServicio', '15CXV543');
            auxMap.put('ebos', 'BEL');
            auxMap.put('tipo', 'Voz');
            auxMap.put('tecnologia', 'COBRE');
            bodyServicios.put('servicios', auxMap);
            Map<String, Object> prefeseabilityResponse = new Map<String, Object>();

            System.debug('Calling Service 271: Prefeasibility');
            if(!Test.isRunningTest()){
                prefeseabilityResponse = IFS_S271_prefeseabilty.prefeseabilty(bodyFamilia, bodyOperacion, bodyDomicilio, bodyCoord, bodyServicios);
            } else {
                
                Map<String, Object> auxTecno1 = new Map<String, Object>();
                auxTecno1.put('medicionDeBajada', '1');
                auxTecno1.put('disponibilidad', 'SI');
                Map<String, Object> auxTecno = new Map<String, Object>();
                auxTecno.put('servicio', 'Internet');
                auxTecno.put('standardsTecnico',  new List<Object>());
                ((List<Object>)auxTecno.get('standardsTecnico')).add(auxTecno1);
                Map<String, Object> parentRecord = new Map<String, Object>();
                parentRecord.put('servicios', new List<Object>());
                ((List<Object>)parentRecord.get('servicios')).add(auxTecno);

                prefeseabilityResponse.put('httpStatusCode', '200');
                prefeseabilityResponse.put('tecnologiasAcceso', new List<Object>());
                ((List<Object>)prefeseabilityResponse.get('tecnologiasAcceso')).add(parentRecord);
            }

            System.debug('Return from Service 271: Prefeasibility');
            System.debug('Prefeseability Response: ' + prefeseabilityResponse);
            String jSonStringResponse = (String)prefeseabilityResponse.get('httpStatusCode');
            //Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jSonStringResponse);
            List<Object> tecnologiesAccesList = (List<Object>) prefeseabilityResponse.get(prefaWStecnologiesAccesList);
            System.debug('tecnologiesAccesList: ' + tecnologiesAccesList);

            
            if (tecnologiesAccesList.size() > 0)
                return PrefeasibilityFilter(tecnologiesAccesList);
            else return '0';
            //return jSonStringResponse;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    private static void UpdateOrder(string idOrder, string prefaResult, string installationAddress)
    {
        try{
            Order orderToUpdate = new Order();
            orderToUpdate.Id = idOrder;
            if (String.isNotBlank(prefaResult))
                orderToUpdate.PrefeasibilityResult__c = prefaResult;
            if (String.isNotBlank(installationAddress))
                orderToUpdate.InstalationAddress__c = installationAddress;
            update orderToUpdate;
        }
        catch(DmlException e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
    }

    global taSalesCartContainerController () {valor = false;}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            switch on methodName{
                when 'CallPrefeasibility'{
                    CallPrefeasibility(inputMap, outMap);
                }
                when 'CallStockMovement'{
                    CallStockMovement(inputMap, outMap);
                }
                when 'RetrievePrefeasibilityResult'{
                    RetrievePrefeasibilityResult(inputMap, outMap);
                }
                when 'DeleteCartItems'{
                    DeleteCartItems(inputMap, outMap, options);
                }
                when 'updateAttrib'{
                    updateAttrib(inputMap, outMap, options);
                }
                when 'AddToCartValidations'{
                    AddToCartValidations(inputMap, outMap, options);
                }
            }
            result = false;
        }
        catch(Exception e)
        {
            System.debug('taSalesCartContainerController:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    void AddToCartValidations(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        System.debug('AddToCartValidations');
        Id orderId = (Id) options.get('IdOrder');
        Id itemToAddProductId = (Id) options.get('ItemToAddProductId');
        String itemToAddProductType = (String) options.get('ItemToAddProductType');
        System.debug('orderId : ' + orderId);
        String cegErrorMessage = 'Solo se puede agregar un dispositivo para la gestión Cambio en Garantía';
        String cegErrorMessageTitle = 'Validación Cambio en Garantía';

        Order Ord = [SELECT Gestion__c FROM Order WHERE Id =: orderId LIMIT 1] ;

        if (Ord.Gestion__c == 'Cambio en Garantia')
        {
            if (itemToAddProductType == 'Dispositivo')
            {
                List<OrderItem> orderItems = [SELECT Id, OrderId FROM OrderItem WHERE Product2.vlocity_cmt__Type__c = 'Dispositivo' AND OrderId = :orderId];
                if (orderItems.size() > 1)
                {
                    outMap.put('ErrorMessage', cegErrorMessage);
                    outMap.put('ErrorMessageTitle', cegErrorMessageTitle);
                }
            }
            else
            {
                outMap.put('ErrorMessage', cegErrorMessage);
                outMap.put('ErrorMessageTitle', cegErrorMessageTitle);
            }
        }
        else
        {
            LinesManager linesManager = new LinesManager();
            String methodName = 'ValidateLinesQtty';
            linesManager.invokeMethod(methodName, inputMap, outMap, options);
            String linesError = (String) outMap.get('LinesError');
            if (String.isNotBlank(linesError))
            {
                outMap.put('ErrorMessage', linesError);
                outMap.put('ErrorMessageTitle', 'Máximo de Lineas');
            }
        }
    }

    public static void updateAttrib(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        System.debug('updateAttrib');

        Map<String, Object> jsonAttributeMap;
        Map<String, Object> lineItemsInCart;
        Map<String, Object> lineItems;     
    

        List<Object> records1;
        List<Object> records2;
        List<Object> records3;
        Map<String, Object> record1;
        Map<String, Object> record2;
        Map<String, Object> record3;
        Boolean notfound = true;
        Integer n=0;
        Integer m=0;
        Map<String, Object> attributeCategories;
        String sProdName; //current Item Name
        String sItemName; //Item Name to find for
        Map<String, Object> mAttribs;
        //String attribName = 'IMSI';
        //String attribValue = '1234';
        

        try{
            //jsonAttributeMap = (Map<String, Object>) JSON.deserializeUntyped(inputMap);
            //lineItemsInCart = (Map<String, Object>) jsonAttributeMap.get('lineItemsInCart');
            //Bajo hasta el plan padre (asumo que el unico plan, sino hay que recorrer el records1 para buscar el plan deseado)

            System.debug('Item Name: ' + options.get('itemName'));

            sItemName = (String) options.get('itemName');
            mAttribs = (Map<String, Object>) options.get('attribs');
            System.debug('mAttribs =' + mAttribs);

            System.debug('inputMap =' + inputMap);
            lineItemsInCart = (Map<String, Object>) inputMap.get('lineItemsInCart');
            System.debug('lineItemsInCart  =' + lineItemsInCart );
            records1 = (List<Object>) lineItemsInCart.get('records');
            record1 = (Map<String, Object>) records1.get(0);
            System.debug('record1  =' +  record1);
            //Me traigo los line items del plan
            lineItems = (Map<String, Object>) record1.get('lineItems');
            records2 = (List<Object>) lineItems.get('records');
            System.debug('records2  =' +  records2);
            //Busco el item deseado (simcard)
            n = 0;
            notfound = true;
            m = records2.size();
            while (notfound && n < m){

                record2 = (Map<String, Object>) records2.get(n);
                sProdName = (String) record2.get('Name');
                //Evaluo si el item actual es el buscado
                if (sProdName == sItemName){
                    notfound = false;
                }
                else{
                    n++;
                }
                
            }
            System.debug('n =' +  n);
            System.debug('notfound =' +  notfound);
            //Me traigo la lista de atributos
            attributeCategories = (Map<String, Object>) record2.get('attributeCategories');
            System.debug('attributeCategories  =' +  attributeCategories);
            records3 = (List<Object>) attributeCategories.get('records');

            System.debug('records3  =' +  records3);

            //Busco y actualizo el atributo deseado
            //update1Attrib(records3,attribName,attribValue);
            updateNAttribs(records3, mAttribs);

        }
        catch(Exception e){
            System.debug('taSalesStockAvailability:ParseIF221 -> exception: '+e);
        }
        finally{
            
            outMap.put('lineItemsInCartUpdated', lineItemsInCart);
        }  
    }


    public static void update1Attrib(List<Object> attribCats, String attrib, String attribValue){
        //Busca el atrrib en la lista de categorias attribCats y le setea el attribValue
        Integer i;
        Integer j;
        Integer n;
        Integer m;
        Boolean notfound;
        List<Object> prodAttribsRecords;
        Map<String, Object> attribCat;
        Map<String, Object> prodAttribs;
        Map<String, Object> attribMap;
        String label;
        try{    
                i = 0;
                notfound = true;
                n = attribCats.size();
                while (notfound && i < n){
                    //Recorre las categorias de atributos
                    attribCat = (Map<String, Object>) attribCats.get(i);
                    System.debug('attribCat  '+i+'=' +  attribCat);
                    prodAttribs = (Map<String, Object>) attribCat.get('productAttributes');
                    System.debug('prodAttribs '+i+'=' +  prodAttribs);
                    prodAttribsRecords = (List<Object>) prodAttribs.get('records');
                    System.debug('prodAttribsRecords '+i+'=' +  prodAttribsRecords);
                    if (prodAttribsRecords != null){
                        //Puede que la categoria no tenga atributos, en tal caso paso a la sig categoria
                        j = 0;
                        m = prodAttribsRecords.size();
                        while (notfound && j < m){
                            //Recorre los atributos de una categoria
                            attribMap = (Map<String, Object>) prodAttribsRecords.get(j);
                            System.debug('attribMap  '+j+'=' +  attribMap);
                            label = (String) attribMap.get('label');
                        
                            if (label == attrib){
                                attribMap.put('userValues',attribValue);
                                notfound = false;
                            }
                            else{
                                j++;
                            }
                        }
                    }
                    i++;
                    
                }

        }
        catch(Exception e){
            System.debug('update1Attrib -> exception: '+e);
        } 
    }

  public static void updateNAttribs(List<Object> attribCats, Map<String, Object> attribs){
        //Busca el atrrib en la lista de categorias attribCats y le setea el attribValue
        Integer i;
        Integer j;
        Integer n;
        Integer m;
        Boolean notfound;
        List<Object> prodAttribsRecords;
        Map<String, Object> attribCat;
        Map<String, Object> prodAttribs;
        Map<String, Object> attribMap;
        Map<String, Object> mAttribsToUpd;

        String label;
        try{    
                i = 0;
                notfound = true;
                n = attribCats.size();
                mAttribsToUpd = attribs.clone();
                while (notfound && i < n){
                    //Recorre las categorias de atributos
                    attribCat = (Map<String, Object>) attribCats.get(i);
                    System.debug('attribCat  '+i+'=' +  attribCat);
                    prodAttribs = (Map<String, Object>) attribCat.get('productAttributes');
                    System.debug('prodAttribs '+i+'=' +  prodAttribs);
                    prodAttribsRecords = (List<Object>) prodAttribs.get('records');
                    System.debug('prodAttribsRecords '+i+'=' +  prodAttribsRecords);
                    if (prodAttribsRecords != null){
                        //Puede que la categoria no tenga atributos, en tal caso paso a la sig categoria
                        j = 0;
                        m = prodAttribsRecords.size();
                        while (!mAttribsToUpd.isEmpty() && j < m){
                            //Recorre los atributos de una categoria
                            attribMap = (Map<String, Object>) prodAttribsRecords.get(j);
                            System.debug('attribMap  '+j+'=' +  attribMap);
                            label = (String) attribMap.get('label');

                            if (mAttribsToUpd.containsKey(label)){
                                attribMap.put('userValues',mAttribsToUpd.get(label));
                                mAttribsToUpd.remove(label);
                            }
                            else{
                                j++;
                            }
                        }
                    }
                    i++;
                    
                }

        }
        catch(Exception e){
            System.debug('update1Attrib -> exception: '+e);
        } 
    }


    global static Boolean DeleteCartItems(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        System.debug('DeleteCartItems');
        try
        {
            String orderId = (String) options.get('orderId');
            List<OrderItem> items = [SELECT Id from OrderItem where orderId = :orderId AND vlocity_cmt__Action__c = 'Add'];
            delete items;

            return true;
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            return false;
        }
    }

    global static Boolean CallPrefeasibility(Map<String,Object> inputMap, Map<String,Object> outMap)
    {
        try
        {
            System.debug('CallPrefeasibility ');
            String orderId = (string) inputMap.get('OrderID');
            System.debug('orderId: ' + orderId);
             System.debug('inputMap: ' + inputMap);
            String assetId = (string) inputMap.get('AssetID');
            String prefaResult;
            String installationAddress;
            if (String.isNotBlank(assetId))
            {
                vlocity_cmt__Premises__c premise = GetAssetPremise(assetId);
                if (premise != null)
                    prefaResult = ObtainPrefeasibility(premise);
            }
            else
            {
                Map<String, Object> instAddressMap = new Map<String, Object>();
                instAddressMap = (Map<String, Object>) inputMap.get('AddressInput');
                prefaResult = ObtainPrefeasibility(instAddressMap);
                installationAddress = JSON.serialize(instAddressMap);
                System.debug('InstallationAddress: ' + installationAddress);
            }

            if(String.isNotBlank(orderId)){
                UpdateOrder(orderId, prefaResult, installationAddress);
            }

            Map<String, Object> prefeasibilityResult = new Map<String, Object>();
            if (prefaResult != null)
                prefeasibilityResult = (Map<String, Object>) JSON.deserializeUntyped(prefaResult);
            System.debug('Prefeasibility Result: ' + prefeasibilityResult);
            outMap.put('PrefeasibilityResult', prefeasibilityResult);

            return true;
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            return false;
        }
    }

    global static Boolean CallStockMovement(Map<String,Object> inputMap, Map<String,Object> outMap)
    {
        System.debug('CallStockMovement');
        try
        {
            String codOperacion;
            String orderId = (String) inputMap.get('IdOrder');
            Order order = [SELECT Delivery_Method__c from Order where Id = :orderId];
            Map<String, Object> billingOrder = (Map<String, Object>) inputMap.get('BillingOrder');
            //if(billingOrder != null){
            if (order.Delivery_Method__c != null)
            {
                String deliveryMethod = order.Delivery_Method__c;
                //String deliveryMethod = (String) billingOrder.get('DeliveryMethod');
                System.debug('deliveryMethod: ' + deliveryMethod);
                if(deliveryMethod != null){
                    if(deliveryMethod == 'Store Pick Up'){
                        codOperacion = 'RMSP';
                    }else if(deliveryMethod == 'Presencial'){
                        codOperacion = 'RMPR';
                    }else if(deliveryMethod == 'Delivery'){
                        return true;
                    }
                }
                /*
                String pickUpStore = (String) billingOrder.get('PickUpStore');
                if(String.isNotBlank(pickUpStore)){
                    vlocity_cmt__BusinessSite__c storeLocation = [SELECT AssociatedWarehouseId__c FROM vlocity_cmt__BusinessSite__c WHERE PointOfSaleId__c =: Decimal.valueOf(pickUpStore)];
                    codDeposito = storeLocation.AssociatedWarehouseId__c;
                    System.debug('codDeposito: ' + codDeposito);
                }
                */
                Map<String,String> getPointOfSaleWarehouseResponse = taOrderController.GetPointOfSaleWarehouse(orderId);
                String codPuntoDeVenta = getPointOfSaleWarehouseResponse.get('codPuntoDeVenta');
                String codDeposito = getPointOfSaleWarehouseResponse.get('codDeposito');
                StockUtils.StockMovement(orderId, codOperacion, codDeposito);
                reserveLines(inputMap);
            }

            return true;
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            return false;
        }
    }

    private static void reserveLines(Map<String,Object> inputMap){
        List<String> linesForReserve = new List<String>();
        Map<String, Object> order = (Map<String, Object>) inputMap.get('Order');
        List<Object> planslist = (List<Object>) order.get('planes');
        for (Object p : planslist){
            Map<String, Object> plan = (Map<String, Object>) p;
            List<Object> lines = (List<Object>)plan.get('lineas');
            for (Object l : lines){
                Map<String, Object> line = (Map<String, Object>) l;
                String lineAux = (String)line.get('linea');
                linesForReserve.add(lineAux);
            }
        }

        Map<String,Object> listaNumerosMotivos = new Map<String,Object>();
        for(String linea : linesForReserve){
            listaNumerosMotivos.put(linea,'RESERVAR');
        }
        IFS_S326_updateNumberStatus.updateNumberStatus(listaNumerosMotivos);
    }

    global static Boolean RetrievePrefeasibilityResult(Map<String,Object> inputMap, Map<String,Object> outMap)
    {
        System.debug('RetrievePrefeasibilityResult');
        try
        {
            String orderId = (String) inputMap.get('OrderID');
            Order order = [SELECT PrefeasibilityResult__c FROM Order WHERE Id =: orderId LIMIT 1];
            Map<String, Object> prefeasibilityFromOrder = null;
            if (order.PrefeasibilityResult__c != null) {
                prefeasibilityFromOrder = (Map<String, Object>) JSON.deserializeUntyped(order.PrefeasibilityResult__c);
            }
            outMap.put('PrefeasibilityFromOrder', prefeasibilityFromOrder);

            return true;
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            return false;
        }
    }

    public static String ObtainPrefeasibility(Map<String,Object> instAddressMap)
    {
        System.debug('ObtainPrefeasibility Address Map');
        try
        {
            Map<String, Object> mainDoor = new Map<String, Object>();
            mainDoor = (Map<String, Object>) instAddressMap.get('MainDoor');
            System.debug('mainDoor: '+mainDoor);
      //      string localization = (string) mainDoor.get('State') + (string) mainDoor.get('Street');
            string localization = (string) mainDoor.get('City');
            string height = (string) mainDoor.get('StreetNumber');

            Map<String, Object> typeAndZone = new Map<String, Object>();
            typeAndZone = (Map<String, Object>) instAddressMap.get('Type&Zone');
            string zone = (string) typeAndZone.get('ZoneType');
            string addressType = (string) typeAndZone.get('HomeType');

            Map<String, Object> additionalInfo = new Map<String, Object>();
            additionalInfo = (Map<String, Object>) instAddressMap.get('AdditionalInfo');
            string lote = additionalInfo.get('Lot') == null ? '' : (string) additionalInfo.get('Lot');
            string tower = '';
            string floor = additionalInfo.get('FloorNumber') == null ? '' : (string) additionalInfo.get('FloorNumber');
            string department = additionalInfo.get('Department') == null ? '' : (string) additionalInfo.get('Department');
            string building = additionalInfo.get('BuildingNumber') == null ? '' : (string) additionalInfo.get('BuildingNumber');
            string street1 = additionalInfo.get('SidestreetA') == null ? '' : (string) additionalInfo.get('SidestreetA');
            string street2 = additionalInfo.get('SidestreetB') == null ? '' : (string) additionalInfo.get('SidestreetB');
            string backstreet = additionalInfo.get('Backstreet') == null ? '' : (string) additionalInfo.get('Backstreet');

            Map<String, Object> privateAreaDetails = new Map<String, Object>();
            privateAreaDetails = (Map<String, Object>) instAddressMap.get('PrivateAreaDetails');
            string block = additionalInfo.get('Block') == null ? '' : (string) additionalInfo.get('Block');
            string sector = additionalInfo.get('SectorType') == null ? '' : (string) additionalInfo.get('SectorType');

            //String body = generateRequestBodyPrefactibilityService(''/*FAMILIA*/, 'CP' /*OPERACION*/, localization, height, lote, tower, floor, department, building, block, zone, addressType, sector, street1, street2, backstreet, '-34,549731' /*LATITUD*/, '-58,435258' /*LONGITUD*/, '15CXV543' /*IDSERVICE*/, 'BEL' /*EBOS*/, 'Voz' /*SERVICETYPE*/, 'COBRE' /*TECNOLOGIA*/);
            //String jSonStringResponse = taSalesCartContainerController.invokeRestService('http://52.67.109.234:8080/prefa/rest/prefeasibility/queryPrefeasibility', 'POST', body);
            String bodyFamilia = 'null';
            String bodyOperacion = 'CP';
            Map<String, Object> bodyDomicilio = new Map<String, Object>();
            bodyDomicilio.put('localizacion', localization);
            bodyDomicilio.put('altura', height);
            bodyDomicilio.put('lote', lote);
            bodyDomicilio.put('torre', tower);
            bodyDomicilio.put('piso', floor);
            bodyDomicilio.put('departamento', department);
            bodyDomicilio.put('edificio', building);
            bodyDomicilio.put('manzana', block);
            bodyDomicilio.put('zona', zone);
            bodyDomicilio.put('tipoDomicilio', addressType);
            bodyDomicilio.put('sector', sector);
            bodyDomicilio.put('entreCalle1', street1);
            bodyDomicilio.put('entreCalle2', street2);
            bodyDomicilio.put('calleAtras', backstreet);
            Map<String, Object> bodyCoord = new Map<String, Object>();
            bodyCoord.put('latitud', '-34,549731');
            bodyCoord.put('longitud', '-58,435258');
            Map<String, Map<String,Object>> bodyServicios = new Map<String, Map<String,Object>>();
            Map<String, Object> auxMap = new Map<String, Object>();
            auxMap.put('idServicio', '15CXV543');
            auxMap.put('ebos', 'BEL');
            auxMap.put('tipo', 'Voz');
            auxMap.put('tecnologia', 'COBRE');
            bodyServicios.put('servicios', auxMap);

            System.debug('Calling Service 271: Prefeasibility');
            Map<String, Object> prefeseabilityResponse = IFS_S271_prefeseabilty.prefeseabilty(bodyFamilia, bodyOperacion, bodyDomicilio, bodyCoord, bodyServicios);
            System.debug('Return from Service 271: Prefeasibility');
            System.debug('Prefeseability Response: ' + prefeseabilityResponse);
            String jSonStringResponse = (String)prefeseabilityResponse.get('httpStatusCode');
            if(jSonStringResponse.equalsIgnoreCase('200')){
                //Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jSonStringResponse);
                List<Object> tecnologiesAccesList = (List<Object>) prefeseabilityResponse.get(prefaWStecnologiesAccesList);
                System.debug('tecnologiesAccesList: ' + tecnologiesAccesList);

                if (tecnologiesAccesList.size() > 0)
                    return (String)tecnologiesAccesList.get(0);
                else return null;
            }
            return null;
            //return jSonStringResponse;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    /*
    public static String generateRequestBodyPrefactibilityService(String family, String operation, String localization, String hight, String lote, String tower, String floor, String department, String building, String block, String zone, String addressType, String sector, String street1, String street2, String backstreet, String latitude, String longitude, String idService, String ebos, String serviceType, String tecno)
    {
        try
        {
            String body = '{';
            body += createStringWSParam('familia', family) + ',';
            body += createStringWSParam('operacion', operation) + ',';
            body += '"domicilio":{';
                body += createStringWSParam('localizacion', localization) + ',';
                body += createStringWSParam('altura', hight) + ',';
                body += createStringWSParam('lote', lote) + ',';
                body += createStringWSParam('torre', tower) + ',';
                body += createStringWSParam('piso', floor) + ',';
                body += createStringWSParam('departamento', department) + ',';
                body += createStringWSParam('edificio', building) + ',';
                body += createStringWSParam('manzana', block) + ',';
                body += createStringWSParam('zona', zone) + ',';
                body += createStringWSParam('tipoDomicilio', addressType) + ',';
                body += createStringWSParam('sector', sector) + ',';
                body += createStringWSParam('entreCalle1', street1) + ',';
                body += createStringWSParam('entreCalle2', street2) + ',';
                body += createStringWSParam('calleAtras', backstreet);
            body += '}';
            body += ',"coordenadas":{';
                body += createStringWSParam('latitud', latitude) + ',';
                body += createStringWSParam('longitud', longitude);
            body += '}';
            body += ',"servicios":[{';
                body += createStringWSParam('idServicio', idService) + ',';
                body += createStringWSParam('ebos', ebos) + ',';
                body += createStringWSParam('tipo', serviceType) + ',';
                body += createStringWSParam('tecnologia', tecno);
            body += '}]';
            body += '}';
            System.debug('body: ' + body);

            return body;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    public static String createStringWSParam(String key, String value)
    {
        try
        {
            String param;
            if (String.isNotBlank(value))
                param = '"' + key + '":"' + value + '"';
            else
                param = '"' + key + '":""';
            return param;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    public static String invokeRestService(String endPoint, String method, String body)
    {
        String responseBody;
        try
        {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endPoint);
            request.setMethod(method);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            request.setBody(body);
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if (response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
                throw new ServiceException('Error al invocar al servicio de obtencion de lineas');
            } else {
                responseBody = response.getBody();
            }

            return responseBody;
        }
        catch(Exception e)
        {
            throw e;
        }
    }*/

    private static string PrefeasibilityFilter(List<Object> AccesTechs)
    {
        try
        {
            Integer maxDownstream = 0;

            for (Object t : AccesTechs)
            {
                Map<string, Object> technology = (Map<string, Object>) t;
                List<Object> services = (List<Object>) technology.get('servicios');
                for (Object  s : services)
                {
                    string serviceType = (string)(((Map<string,Object>)s).get('servicio'));
                    if(serviceType=='Internet')
                    {
                        Map<string,object> service = (Map<string,Object>) s;
                        List<object> technicalStandards = (List<object>) service.get('standardsTecnico');
                        for(Object ts : technicalStandards)
                        {
                            Map<string,Object> techStandard = (Map<string,Object>) ts;
                            string disponibilidad = (string) techStandard.get('disponibilidad');
                            string medicionDeBajada = String.valueof(techStandard.get('medicionDeBajada'));
                            if(String.isNotBlank(medicionDeBajada) && disponibilidad == 'SI')
                            {
                                Integer Downstream = Integer.valueOf(medicionDeBajada);
                                if(Downstream > maxDownstream)
                                    maxDownstream = Downstream;
                            }
                        }
                    }
                }
            }

            return String.valueof(maxDownstream);
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    @RemoteAction
    global static Integer getCreditLimit(string accountId){
        try{
            String methodName = 'IFS_S018';
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();

            integProcServ.invokeMethod(methodName, input, output, options);

            Map<String, Object> ipResult = (Map<String, Object>) output.get('IPResult');
            List<Object> listInfoBalance = (List<Object>) ipResult.get('listaInfoBalance');
            Map<String, Object> maplistInfoBalance = (Map<String, Object>) listInfoBalance[0];
            List<Object> objListInfoCredito= (List<Object>) maplistInfoBalance.get('listaInfoCredito');
            

            Map<String, Object> mapListInfoCredito = (Map<String, Object>) objListInfoCredito[0];
            String limiteCreditoRemanente = (String) mapListInfoCredito.get('limiteCreditoRemanente');

            System.debug('Response: ' + output);  

            return Integer.valueOf(limiteCreditoRemanente);
        } catch(Exception e){
            system.debug('An unexpeted error has ocurred: ' + e.getMessage());
            system.debug(e.getStackTraceString());
            return null;
        }
    }

    @RemoteAction
    global static Boolean getDunningMark(string accountId){
        Account account = [SELECT Dunning__c FROM Account WHERE Id = :accountId];
        return account.Dunning__c;
    }
}