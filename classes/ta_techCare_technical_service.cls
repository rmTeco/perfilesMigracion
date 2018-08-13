global with sharing class ta_techCare_technical_service implements vlocity_cmt.VlocityOpenInterface{

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        

        try{
            if(methodName.equals('ValidateImei')) ValidateImei(input, outMap, options);
            else if(methodName.equals('PopulateRepairs')) PopulateRepairs(input, outMap, options);
            else if(methodName.equals('GetTechnicalServiceCaseId')) GetTechnicalServiceCaseId(input, outMap, options);
            else if(methodName.equals('SendEmailPDF')) SendEmailPDF(input, outmap, options);
            else if(methodName.equals('GetCaseComments')) GetCaseComments(input, outmap, options);
            else if(methodName.equals('ValidateEmail')) ValidateEmail(input, outMap, options);
            else if(methodName.equals('GetDeviceInfoByAssetId')) GetDeviceInfoByAssetId(input, outMap, options);
            else if(methodName.equals('ValidatePhone')) ValidatePhone(input, outMap, options);
            else if(methodName.equals('SetWarrantyApplies')) SetWarrantyApplies(outMap, options);
            else if(methodName.equals('GetRepairProducts')) GetRepairProducts(outMap, options);
            else if(methodName.equals('GetPricebookEntryIdByProductCode')) GetPricebookEntryIdByProductCode(outMap, options); 
            else if(methodName.equals('SetZeroForWarrantyItems')) SetZeroForWarrantyItems(options);
            else if(methodName.equals('getWarrantyByAssetId')) ExcutegetWarrantyByAssetId(options);


        } catch(Exception ex){
            options.put('error', ex.getMessage());
            outMap.put('error', ex.getMessage());
            return false;
        }
        
        return true;
    }

    private void PopulateRepairs(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            List<Map<String, Object>> cases = new List<Map<String, Object>>();

            if(options.get('cases') != null){
                if(options.get('cases') instanceof Map<String, Object>){
                    cases.add((Map<String, Object>) options.get('cases'));
                }else if(options.get('cases') instanceof List<Object>){
                    List<Object> objCases = (List<Object>) options.get('cases');
                    for(Object o : objCases)
                        cases.add((Map<String, Object>) o);
                }

                //System.debug('Cases count: ' + cases.size());
                //System.debug('Original cases: ' + options.get('cases'));
                //Get CaseNumbers
                List<String> caseNumbers = new List<String>();                
                for(Map<String, Object> c : cases){
                    caseNumbers.add((String) c.get('CaseNumber'));
                }

               // System.debug('Cases numbers: ' + caseNumbers);

                List<String> caseOrders = new List<String>();

                for(Case objCase : [SELECT Id, CaseNumber, Order__c FROM Case WHERE CaseNumber IN :caseNumbers]){
                    caseOrders.add(objCase.Order__c);

                    for(Map<String, Object> c : cases){
                        if((String) c.get('CaseNumber') == objCase.CaseNumber){
                            c.put('OrderId', objCase.Order__c);
                        }
                    }
                }

                //System.debug('Case Orders: ' + caseOrders);

                //Get repairs
                List<Map<String,Object>> reps;
                Map<String,Object> rep;

                for(Order ord : [SELECT Id, (SELECT ProductName__c FROM OrderItems) FROM Order WHERE Id IN :caseOrders]){
                    for(Map<String, Object> c : cases){
                        if(c.get('OrderId') != null){
                            if(ord.Id == (String) c.get('OrderId')){
                                reps = new List<Map<String,Object>>();

                                for(OrderItem it : ord.OrderItems){
                                    rep = new Map<String,Object>();

                                    rep.put('Name', it.ProductName__c);

                                    reps.add(rep);
                                }
                                
                                c.put('Repairs', reps);
                            }
                        }
                    }
                }

                outMap.put('RepairHistoryCases', null);
                outMap.put('SelectableItemsRepairHistory', cases);
            }
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener reparaciones para historial de gestiones: ' + ex.getMessage());
        }
    }

    private void ValidateImei(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            Map<String, Object> tempElem = new Map<String, Object>();

            String imei = (String)options.get('imei');
                    
            List<Asset> assets = [SELECT Id, AccountId FROM Asset WHERE Imei__c = :imei.trim()];

            if(assets.size() > 0){
                tempElem.put('statusImei', 'OK');
                tempElem.put('imei', imei.trim());
                tempElem.put('AccountId', assets[0].AccountId);
                tempElem.put('AssetId', assets[0].Id);
            } else{
                tempElem.put('statusImei', 'ERROR');
                tempElem.put('imei', 'N/A');
                tempElem.put('AccountId', 'N/A');
                tempElem.put('AssetId', 'N/A');
            }
            outMap.put('infoImei', tempElem);
        } catch(Exception ex){
            throw ex;
        }
    }

    private void GetTechnicalServiceCaseId(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            Map<String, Object> tempElem = new Map<String, Object>();
            Map<String, String> estado = new Map<String, String>();

            String caseNumber = (String)options.get('caseNumber');
                    
            List<Case> caseInfo = [SELECT Id, AccountId, Asset.Imei__c FROM Case WHERE CaseNumber = :caseNumber.trim()];

            if(caseInfo.size() > 0){
                tempElem.put('statusCase', 'OK');
                tempElem.put('imei', caseInfo[0].Asset.Imei__c);
                tempElem.put('CaseId', caseInfo[0].Id);
                tempElem.put('AccountId', caseInfo[0].AccountId);
                tempElem.put('AssetId', caseInfo[0].Asset.Id);                
            } else{
                tempElem.put('statusCase', 'ERROR');
                tempElem.put('imei', 'N/A');
                tempElem.put('CaseId', 'N/A');
                tempElem.put('AccountId', 'N/A');
                tempElem.put('AssetId', 'N/A');
            }
            outMap.put('infoImei', tempElem);
        } catch(Exception ex){
            throw ex;
        }
    }
    
    private void SendEmailPDF(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            String addresses = (options.get('alternativeEmail')) != '' ? (String)options.get('alternativeEmail') : (String)options.get('addresses');
            String caseId = (String) options.get('caseId');
            String caseNumber = (String) options.get('caseNumber');

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            if(!Test.isRunningTest()){
                PageReference pdf = Page.ta_techCare_TS_RepairSummary_PDF;
                //pdf.getParameters().put('Imei',(String)paramImei);
                //pdf.getParameters().put('inputType',(String)paramInputType);
                //pdf.getParameters().put('symptom',(String)paramSymptom);
                pdf.getParameters().put('caseId', caseId);
                pdf.setRedirect(true);

                Blob b = pdf.getContent();

                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(caseNumber + '.pdf');
                efa.setBody(b);

                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            }

            String[] toAddresses = addresses.split(':', 0);
            //system.debug('Addresses: ' + toAddresses);
            String subject = 'Gestión de Servicio Técnico';
            String body = 'Gestión de Servicio Técnico\n\nSu Gestión ha sido procesada, el número es: ' + caseNumber;

            email.setSubject( subject );
            email.setToAddresses( toAddresses );
            email.setPlainTextBody( body );

            Messaging.SendEmailResult [] r =
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

            outMap.put('sendEmailStatus', 'OK');
            outMap.put('sendEmailTo', addresses);
        } catch(Exception ex){
            outMap.put('sendEmailStatus', 'ERROR');
            outMap.put('sendEmailTo', 'N/A');
            //throw ex;
        }
    }

    private void GetCaseComments(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            String caseId = (String)options.get('CaseId');

            Map<String, Object> tempComment;
            List<Map<String, Object>> lstComments = new List<Map<String, Object>>();

            for(CaseComment caseCom : [SELECT Id, CommentBody, CreatedBy.FirstName, CreatedBy.LastName, CreatedDate FROM CaseComment WHERE ParentId = :caseId])
            {
                tempComment = new Map<String, Object>();

                Datetime objCreatedDate = (Datetime) caseCom.CreatedDate;

                tempComment.put('Body', caseCom.CommentBody);
                tempComment.put('User', caseCom.CreatedBy.FirstName + ' ' + caseCom.CreatedBy.LastName);
                tempComment.put('Date', objCreatedDate);

                lstComments.add(tempComment);
            }

            Map<String, Object> caseNode = (Map<String, Object>) input.get('Case');
            caseNode.put('Comments', lstComments);
            outMap.put('Case', caseNode);

        } catch(Exception ex){
            outMap.put('error', ex.getMessage());
            throw ex;
        }
    }

    private void ValidateEmail(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            String email = (String)options.get('email');
            Map<String, Object> responseNode = IFS_S171_validateEMail.validateEMail(email);
            outMap.put('emailValidation', (String)responseNode.get('CodeEstado'));
            outMap.put('emailHistoryValidation', email);

        } catch(Exception ex){
            outMap.put('emailValidation', 'ERROR');
            outMap.put('emailHistoryValidation', 'N/A');
            throw ex;
        }
    }

    private void GetDeviceInfoByAssetId(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            String assetId = (String)options.get('AssetId');
            
            Map<String, Object> deviceInformation = new Map<String, Object>();
            
            Map<String, Object> tempElemMarca = GetDeviceBrandByAssetId(assetId, 'Marca');
            Map<String, Object> tempElemModelo = GetDeviceBrandByAssetId(assetId, 'Modelo');

            deviceInformation.put('Brand', tempElemMarca.get('Marca'));
            deviceInformation.put('Model', tempElemModelo.get('Modelo'));
            deviceInformation.put('SaleWarranty', getWarrantyByAssetId(assetId));

            OutMap.put('Device', deviceInformation);
            system.debug('GetDeviceInfoByAssetId-OutMap; '+OutMap);
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener datos del equipo: ' + ex.getMessage());
        }
    } 

    private Map<String, Object> GetDeviceBrandByAssetId(String assetId, String displayName)
    {
        try{
            List<Asset> objAssets = [Select vlocity_cmt__JSONAttribute__c from Asset where id = :assetId];

            if(objAssets.size() == 0 || objAssets[0].vlocity_cmt__JSONAttribute__c == null)
                throw new FuncException('No existen atributos cargados para el Asset');
            
            List<String> assetAttributes = new List<String>();
            assetAttributes.add(displayName);
            
            return AssetAttributesUtils.getAssetAttribute(assetId,assetAttributes);

        } catch(FuncException fex){
            throw new FuncException('Error al obtener la marca del equipo: ' + fex.getMessage());
        } catch(Exception ex){
            throw ex;
        }
    }

    private Map<String, Object> getWarrantyByAssetId(String assetId)
    {
        List<Asset> objAssets = null;
        Asset objAsset = null;
        Map<String, Object> tempElem =null;
                    
            try{
            //objAsset = [SELECT Id, vlocity_cmt__JSONAttribute__c, PurchaseDate FROM Asset WHERE Id =:assetId limit 1];
            objAssets = [SELECT vlocity_cmt__JSONAttribute__c, PurchaseDate FROM Asset WHERE id = :assetId];
            }catch(Exception ex){
                throw ex;
            }
           if(objAssets.size() == 0 || objAssets[0].vlocity_cmt__JSONAttribute__c == null){
             //   throw new FuncException('No existen atributos cargados para el Asset');
           }
            
            objAsset = objAssets[0];
            if(objAsset != null){
                if(objAsset.PurchaseDate == null){
                  //  throw new Exception('El asset no tiene Fecha de Venta');    
                }else{

                    String displayName = 'Periodo de Garantia';

                    List<String> assetAttributes = new List<String>();
                    assetAttributes.add(displayName);
                    
                    Map<String, Object> warrantyAttributes = AssetAttributesUtils.getAssetAttribute(assetId,assetAttributes);
                    tempElem = (Map<String, Object>)warrantyAttributes.get(displayName);
                    
                    Integer warrantyPeriod = Integer.ValueOf(String.ValueOf(tempElem.get('value')).substring(0, 2));
                    
                    DateTime dueDateWarranty = objAsset.PurchaseDate.addMonths(warrantyPeriod);

                    tempElem = new Map<String, Object>();
                    tempElem.put('from', (DateTime) objAsset.PurchaseDate);
                    tempElem.put('to', dueDateWarranty);
                    
                    if(dueDateWarranty >= DateTime.now()){
                        tempElem.put('applies', 'SI');
                    }
                    else{
                        tempElem.put('applies', 'NO');
                    }
                }                             
            }else{
                // throw new Exception('Asset no encontrado');    
            }
        /*}catch(FuncException fex){
            throw new FuncException('Error al obtener los datos de garantía: ' + fex.getMessage());
        } catch(Exception ex){
            throw ex;
        } */
           return tempElem;   
    }
    
    public void ValidatePhone(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            String phone = (String)options.get('phone');
            
            If(!String.isEmpty(phone.trim()))
                phone = GetValidatedPhone(phone);

            outMap.put('validatedPhone', phone);
            outMap.put('phoneHistoryValidation', (String)options.get('phone'));
            
        } catch(Exception ex){
            outMap.put('validatedPhone', 'ERROR');
            outMap.put('phoneHistoryValidation', 'N/A');
            throw ex;
        }
    }

    public static String GetValidatedPhone(String phoneNumber)
    {
        try{
            String validPhoneNumber = 'ERROR';

            Integer digitCount = phoneNumber.length();

            if(phoneNumber.substring(0, 4) == '+549')
            {
                phoneNumber = phoneNumber.substring(4, digitCount);
                digitCount = phoneNumber.length();
            }
            if (phoneNumber.substring(0, 3) == '+54') {
                phoneNumber = phoneNumber.substring(3, digitCount);
                digitCount = phoneNumber.length();
            }
            if (phoneNumber.substring(0, 3) == '549') {
                phoneNumber = phoneNumber.substring(3, digitCount);
                digitCount = phoneNumber.length();
            }
            if (phoneNumber.substring(0, 2) == '54') {
                phoneNumber = phoneNumber.substring(2, digitCount);
                digitCount = phoneNumber.length();
            }
            if (phoneNumber.substring(0, 1) == '0') {
                phoneNumber = phoneNumber.substring(1, digitCount);
                digitCount = phoneNumber.length();
            }
            if (digitCount == 10) {
                validPhoneNumber = phoneNumber;
            }
            else if (digitCount > 10)
            {
                if (phoneNumber.substring(digitCount - 10, digitCount - 8) == '15') {
                    validPhoneNumber = phoneNumber.substring(0, digitCount - 10) + phoneNumber.substring(digitCount - 8, digitCount);
                }
                else if (phoneNumber.substring(digitCount - 9, digitCount - 7) == '15') {
                    validPhoneNumber = phoneNumber.substring(0, digitCount - 9) + phoneNumber.substring(digitCount - 7, digitCount);
                }
                else if (phoneNumber.substring(digitCount - 8, digitCount - 6) == '15') {
                    validPhoneNumber = phoneNumber.substring(0, digitCount - 8) + phoneNumber.substring(digitCount - 6, digitCount);
                }
            }
            return validPhoneNumber;
        }
        catch(Exception ex){
            throw ex;
        }
    }

    private void SetWarrantyApplies(Map<String, Object> outMap, Map<String, Object> options){
        try{
            String imei = String.ValueOf(options.get('imei'));

            List<AggregateResult> reps = GetServiceWarranty(imei, Date.today());

            List<Object> items = new List<Object>();
           

            //Pre selección de items
            if(options.get('items') != null){
                if(options.get('items') instanceof Map<String, Object>){
                    items.add(options.get('items'));
                } else if(options.get('items') instanceof List<Object>){
                    items = (List<Object>) options.get('items');
                }
            }

            List<Map<String, Object>> retItems = new List<Map<String, Object>>();

            for(Object item : items){
                Boolean bApplies = false;

                Map<String, Object> mapItem = (Map<String, Object>) item;

                for(AggregateResult warrRep : reps){
                    if(warrRep.get('ProductCode') == mapItem.get('ProductCode')){
                        bApplies = true;
                        break;
                    }
                }

                mapItem.put('WarrantyApplies', bApplies);

                retItems.add(mapItem);
            }

            outMap.put('Items', retItems);

        } catch(FuncException fex){
            throw fex;
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener garantía de reparación: ' + ex.getMessage());
        }
    }

    private List<AggregateResult> GetServiceWarranty(String imei, Date warrantyLimitDate){
        try{
            if(imei == null || imei == '')
                throw new FuncException('Error al obtener garantía de reparación: No se encuentra el IMEI');

            List<String> ords = new List<String>();

            //Date today = Date.today();

            for(Case c : [SELECT Order__c FROM Case 
                           WHERE Status = 'Resuelta exitosa'
                             AND RepairWarrantyEndDate__c >= :warrantyLimitDate
                             AND Asset.Imei__c = :imei]){
                ords.add(c.Order__c);
            }

            //Traigo todas las reparaciones agrupadas
            List<AggregateResult> reps = [SELECT vlocity_cmt__Product2Id__r.ProductCode ProductCode 
                                            FROM OrderItem
                                           WHERE OrderId 
                                              IN :ords 
                                        GROUP BY vlocity_cmt__Product2Id__r.ProductCode];

            return reps;

        } catch(FuncException fex){
            throw fex;
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener garantía de reparación: ' + ex.getMessage());
        }

    }

    
    private void SetZeroForWarrantyItems(Map<String, Object> options){
        try{
            String orderId = (String) options.get('OrderId');

            List<OrderItem> ordersItems = new List<OrderItem>();

            for(OrderItem oi : [SELECT Id, IsBillable__c FROM OrderItem 
                           WHERE OrderId = :orderId]){
                if(!oi.IsBillable__c)
                {
                    oi.vlocity_cmt__EffectiveOneTimeTotal__c = 0;
                    oi.vlocity_cmt__OneTimeDiscountPrice__c = oi.vlocity_cmt__OneTimeCharge__c;

                    ordersItems.add(oi);
                }
            }

            update ordersItems;

        } catch(FuncException fex){
            throw fex;
        } catch(Exception ex){
            throw new FuncException('Error inesperado al aplicar garantía de reaparación en items: ' + ex.getMessage());
        }

    }

    private void GetRepairProducts(Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            List<Object> items = new List<Object>();
            String totalDestruction = String.ValueOf(options.get('totalDestructionCheck'));
            String warrantyApplied = options.get('warrantyAppliesCheck')==''? 'false' : String.ValueOf(options.get('warrantyAppliesCheck'));
            //Pre selección de items
            if(options.get('items') != null){
                if(options.get('items') instanceof Map<String, Object>){
                    items.add(options.get('items'));
                }
                else if(options.get('items') instanceof List<Object>){
                    items = (List<Object>) options.get('items');
                }
            }

            Date ticketCreatedDate = Date.today();

            if(options.get('ticketCreatedDate') != null)
                ticketCreatedDate = Date.valueOf((String) options.get('ticketCreatedDate'));

            //Service warranty - INI
            String imei;
            List<AggregateResult> reps;

            if(options.get('imei') != null){
                imei = String.ValueOf(options.get('imei'));
                reps = GetServiceWarranty(imei, ticketCreatedDate);
            }
            //Service warranty - FIN

            String priceListId = getRepairsPricelist();

            List<vlocity_cmt__PriceListEntry__c> lstPriceListEntry = 
                [SELECT vlocity_cmt__ProductId__r.Name,
                        vlocity_cmt__ProductId__r.ProductCode,
                        vlocity_cmt__PricingElementId__r.vlocity_cmt__Amount__c
                   FROM vlocity_cmt__PriceListEntry__c
                  WHERE vlocity_cmt__PriceListId__c = :priceListId];

            if(lstPriceListEntry.size() == 0)
                throw new FuncException('No hay productos cargados en la lista de precios');

            Map<String, Object> mapEntryItem = new Map<String, Object>();
            List<Map<String, Object>> listMapEntryItem = new List<Map<String, Object>>();

            for(vlocity_cmt__PriceListEntry__c entry : lstPriceListEntry){
                Boolean warrApplies = false;
                Boolean preSel = false;

                for(Object item : items){
                    Map<String, Object> mapItem = (Map<String, Object>) item;

                    if((String) mapItem.get('Name') == entry.vlocity_cmt__ProductId__r.Name){
                        preSel = true;
                        break;
                    }
                }

                if(reps != null){
                    for(AggregateResult rep : reps){
                        if(entry.vlocity_cmt__ProductId__r.ProductCode == (String) rep.get('ProductCode')){
                            if(totalDestruction == 'false' || warrantyApplied=='true'){
                                warrApplies = true;    
                            }
                            
                            break;
                        }
                    }
                }

                mapEntryItem = new Map<String, Object>();

                mapEntryItem.put('WarrantyApplies', warrApplies);
                mapEntryItem.put('Price', entry.vlocity_cmt__PricingElementId__r.vlocity_cmt__Amount__c);
                mapEntryItem.put('Name', entry.vlocity_cmt__ProductId__r.Name);
                mapEntryItem.put('ProductCode', entry.vlocity_cmt__ProductId__r.ProductCode);
                mapEntryItem.put('Description', entry.vlocity_cmt__ProductId__r.Name);
                mapEntryItem.put('PreSelected', preSel);

                listMapEntryItem.add(mapEntryItem);
            }

            outMap.put('Products', listMapEntryItem);
        } catch(FuncException fex){
            throw fex;
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener productos: ' + ex.getMessage());
        }
    }

    private void GetPricebookEntryIdByProductCode(Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            String imei = (String) options.get('imei');
            Date ticketCreatedDate = Date.today();

            if(options.get('CreatedDate') != null)
                ticketCreatedDate = (Date) options.get('CreatedDate');

            List<Object> products = new List<Object>();

            if(options.get('ProductList') instanceof Map<String, Object>)
                products.add(options.get('ProductList'));
            else if(options.get('ProductList') instanceof List<Object>)
                products = (List<Object>) options.get('ProductList');

            if(products == null || products.size() == 0)
                throw new FuncException('Error al obtener los productos seleccionados');

            List<String> productCodes = new List<String>();

            for(Object product : products){
                Map<String, Object> mapProduct = (Map<String, Object>) product;

                productCodes.add((String) mapProduct.get('ProductCode'));
            }

            if(productCodes.size() == 0)
                throw new FuncException('No se encontraron productos seleccionados');

            List<AggregateResult> serviceWarrantyProducts = GetServiceWarranty(imei, ticketCreatedDate);

            String priceBookId = getStandardPricebook();
            List<Map<String, Object>> pricebookEntryIds = new List<Map<String, Object>>();

            for(PricebookEntry entries : [SELECT Id, ProductCode
                                            FROM PricebookEntry
                                           WHERE Pricebook2Id = :priceBookId
                                             AND ProductCode IN :productCodes]){
                Map<String, Object> mapEntries = new Map<String, Object>();

                Boolean warrantyApplies = false;

                for(AggregateResult warrProd : serviceWarrantyProducts){
                    if((String) warrProd.get('ProductCode') == entries.ProductCode){
                        warrantyApplies = true;
                    }
                }

                mapEntries.put('itemId', entries.Id);
                mapEntries.put('productCode', entries.ProductCode);
                mapEntries.put('WarrantyApplies', warrantyApplies);

                pricebookEntryIds.add(mapEntries);
            } 

            outMap.put('priceBookEntryItems', pricebookEntryIds);
        } catch(FuncException fex){
            throw fex;
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener productos: ' + ex.getMessage());
        }
    }

    private String getStandardPricebook(){
        String standardPB = 'TA Price Book';

        try{
            List<Pricebook2> standardPriceBook = [SELECT Id 
                                                    FROM Pricebook2
                                                   WHERE Name = :standardPB];

            if(standardPriceBook.size() == 0)
                throw new FuncException('No existe');
            if(standardPriceBook.size() > 1)
                throw new FuncException('Existe más de un pricebook con el mismo nombre');

            return standardPriceBook[0].Id;
        } catch(FuncException fex){
            throw new FuncException('Error al obtener el pricebook standard: ' + fex.getMessage());
        } catch(Exception ex){
            throw ex;
        }
    }

    public static String getRepairsPricelist(){
        String priceListName = 'Reparacion Price List';

        try{

            List<vlocity_cmt__PriceList__c> listPriceList = [SELECT Id, vlocity_cmt__Pricebook2Id__c
                                                               FROM vlocity_cmt__PriceList__c
                                                              WHERE Name = :priceListName];

            if(listPriceList.size() == 0)
                throw new FuncException('No existe la lista de precios ' + priceListName);
            else if(listPriceList.size() > 1)
                throw new FuncException('Error de consistencia - Existe más de una lista de precios con el nombre: ' + priceListName);

            return listPriceList[0].Id;

        } catch(FuncException fex){
            throw new FuncException('Error al obtener la pricelist de reparaciones: ' + fex.getMessage());
        } catch(Exception ex){
            throw ex;
        }
    }

    private void ExcutegetWarrantyByAssetId(Map<String, Object> options){
        try{
            String assetId = String.valueOf(options.get('assetIdO'));
              //String assetId = '02i6C0000002Uu0QAE';
                getWarrantyByAssetId(assetId);
            }catch (Exception ex){
                throw ex;
                
            }
    }
}