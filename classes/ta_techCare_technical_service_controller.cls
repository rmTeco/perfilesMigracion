global with sharing class ta_techCare_technical_service_controller{

    public List<OrderItem> Repairs { get; set; }
    public Case tsCase { get; set; }
    public String valor { get; set; }
    public Contact contact { get; set; }
    public Order caseOrder { get; set; }
    public Product2 product { get; set; }
    public Asset protectionAsset { get; set; }
    public vlocity_cmt__BusinessSite__c workLocation{ get; set; }

    public String marcaProduct { get; set; }
    public String brand { get; set; }
    public String model { get; set; }
    public String saleWarranty { get; set; }
    public String saleDate { get; set; }
    public String imeiOld { get; set; }
    

    public ta_techCare_technical_service_controller(){
        try{
            Id caseId = apexpages.currentpage().getparameters().get('caseId');
            
            getCaseData(caseId);
            
            Apexpages.currentPage().getHeaders().put('content-disposition', 'filename=' + tsCase.CaseNumber + '.pdf');
            
        } catch(Exception e){}
    }
    
    private void getCaseData(Id caseId){
        this.tsCase = [SELECT CaseNumber, 
                              Asset.imei__c,
                              Asset.Id,
                              Asset.Name,
                              Asset.Invalid_Warranty__c,
                              Asset.Total_Destruction__c,
                              Asset.ContactId,
                              Asset.MSISDN__c,
                              Asset.Product2Id,
                              Repaired_With_Warranty__c,
                              Description,
                              Incident__c,
                              Operation_Type__c,
                              ContactMotive__r.Name,
                              Order__c,
                              Board_Change__c, 
                              Status,
                              CreatedById,
                              Protection__c,
                              Protection_Percent__c,
                              RelatedTechQuoteStatus__c
                         FROM Case
                        WHERE Id = :caseId];
        
        if(tsCase.Order__c != null){
            this.caseOrder = [SELECT Id,
                                      OrderNumber,
                                      (SELECT Product2.Name, 
                                              vlocity_cmt__EffectiveOneTimeTotal__c 
                                         FROM OrderItems) 
                                 FROM Order 
                                WHERE Id = :tsCase.Order__c];
            
            if(caseOrder.OrderItems.size() > 0){
                this.Repairs = caseOrder.OrderItems;
            }else{
                Repairs = new List<OrderItem>();
            }

            if(tsCase.Board_Change__c){
                getImeiOld(tsCase.Asset.imei__c, tsCase.Asset.Id);
            }

                
        }


        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        options.put('AssetId', tsCase.Asset.Id);

        Ta_techCare_technical_service techServ = new Ta_techCare_technical_service();
        techServ.invokeMethod('GetDeviceInfoByAssetId', input, outMap, options);

        Map<String, Object>  assetAttributes = (Map<String, Object>) outMap.get('Device');

        Map<String, Object> mapBrand = (Map<String, Object>) assetAttributes.get('Brand');
        String mapModel =  (String) assetAttributes.get('Model');
        Map<String, Object> mapSaleWarranty = (Map<String, Object>) assetAttributes.get('SaleWarranty');


        this.brand =  (String) mapBrand.get('displayText');
        this.model =  mapModel;
         

        String mapFromDate =  string.valueOf(mapSaleWarranty.get('from'));
        String dateFrom = (String) mapFromDate.split(' ')[0];
        String[] formatDateFrom = dateFrom.split('-');

        this.saleDate = formatDateFrom[2]+'-'+formatDateFrom[1]+'-'+formatDateFrom[0];
        this.saleWarranty =  (String) mapSaleWarranty.get('applies');
      


        this.contact = getContact (tsCase.Asset.ContactId);
       // this.product = getProduct (tsCase.Asset.Product2Id);


         this.protectionAsset = [SELECT Id, Name
                         FROM Asset
                        WHERE Id = :tsCase.Protection__c];


        this.workLocation = getWorkLocation(tsCase.CreatedById);

       // system.debug('this.workLocation: '+this.workLocation);
    }

    @RemoteAction
    global static Boolean NoAceptaPresup(String caseId){
        try{
            Case selCase = [SELECT Id, Subject FROM Case WHERE Id = :caseId];

            return true;
        } catch(Exception ex){
            return false;
        }
    } 

    @RemoteAction
    global static String getRemitoPDF(String paramImei, String paramNMU, String paramDesc, String paramBrand, String paramAccs) {
        PageReference pageRef = Page.ta_techCare_Remito_PDF;

        pageRef.getParameters().put('imei', paramImei);
        pageRef.getParameters().put('NMU', paramNMU);
        pageRef.getParameters().put('Descripcion', paramDesc);
        pageRef.getParameters().put('Marca', paramBrand);
        pageRef.getParameters().put('Accesorios', paramAccs);
        
      
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        String pageURL = baseUrl + pageRef.getURL();
     //   System.debug('URL: ' + pageUrl);

        return pageURL;
    }

    @RemoteAction
    //global static String getTechnicalCarePDF(String paramImei, String caseNumber, String inputType, String symptom) {
    global static String getTechnicalCarePDF(String caseId) {
        //PageReference pageRef = Page.ta_techCare_TechnicalService_PDF;
        
        PageReference pageRef = Page.ta_techCare_TS_RepairSummary_PDF;
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        String pageURL = baseUrl + pageRef.getURL();

        pageUrl += '?caseId=' + caseId;

        return pageURL;
    }

    @RemoteAction
    global static Boolean DeleteOrder(String orderId){
        try{
            List<Order> lstOrders = [SELECT Id FROM Order WHERE Id = :orderId];

            if(lstOrders.size() == 0)
                throw new FuncException('No existe la orden');

            Database.DeleteResult delRes = DataBase.delete(lstOrders[0], true);

            if(delRes.isSuccess())
                return true;
            
            return false;

        } catch(Exception ex){
            System.debug('ex: ' + ex.getMessage());
            System.debug('stackTrace: ' + ex.getStackTraceString());
            return false;
        }
    }

    @RemoteAction
    global static String CreateOrder(String accountId){
        try{
        
            Id recordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Presupuesto de Reparacion').getRecordTypeId();
            List<Map<String, Object>> lstOrderItems = new List<Map<String, Object>>();
            
            Map<String, Object> tempMapOrder; 

            tempMapOrder= new Map<String, Object>();
            tempMapOrder.put('effectivedate', Date.today());
            lstOrderItems.add(tempMapOrder);

            tempMapOrder = new Map<String, Object>();
            tempMapOrder.put('AccountId', accountId);
            lstOrderItems.add(tempMapOrder);            

            tempMapOrder = new Map<String, Object>();
            tempMapOrder.put('status', 'Draft');
            lstOrderItems.add(tempMapOrder);
            
            tempMapOrder = new Map<String, Object>();
            tempMapOrder.put('RecordTypeId', recordTypeId);
            lstOrderItems.add(tempMapOrder);  

            tempMapOrder = new Map<String, Object>();
            tempMapOrder.put('vlocity_cmt__PriceListId__c', ta_techCare_technical_service.getRepairsPricelist());
            lstOrderItems.add(tempMapOrder);

            return taCpqAppHandler.CreateOrder(lstOrderItems);

        } catch(Exception ex){
            System.debug('ex: ' + ex.getMessage());
            System.debug('stackTrace: ' + ex.getStackTraceString());
            return null;
        }
    }

    @RemoteAction
    global static Boolean AddRepairToOrder(String priceBookEntryId, String orderId, Boolean warranty){
        Boolean ret = false;
        String result = '';
        try{
            result = taCpqAppHandler.AddItemToOrder(priceBookEntryId, orderId);
             } catch(Exception ex){
            System.debug('ex: ' + ex.getMessage());
            System.debug('stackTrace: ' + ex.getStackTraceString());
            return false;
        }

        if(result != null){
                OrderItem ordit = [SELECT Id, vlocity_cmt__OneTimeCharge__c FROM OrderItem WHERE Id = :result];
                ordit.IsBillable__c = !warranty;
                if(warranty){
                    ordit.vlocity_cmt__EffectiveOneTimeTotal__c = 0.01;
                    ordit.vlocity_cmt__OneTimeDiscountPrice__c = ordit.vlocity_cmt__OneTimeCharge__c;
                }
                update ordit;

                ret = true;
            }

            return ret;
       
    }

    @RemoteAction
    global static Boolean RemoveItems(List<String> itemsId, String orderId){
        Savepoint sp = Database.setSavepoint();

        try{
            Boolean success = true;

            for(String itemId : itemsId){
                try{
                    Boolean result = taCpqAppHandler.RemoveOrderItem(itemId, orderId);

                    if(!result){
                        Database.rollback(sp);
                        success = false;
                        break;
                    }

                } catch(Exception ex){
                    System.debug('ex: ' + ex.getMessage());
                    System.debug('stackTrace: ' + ex.getStackTraceString());
                    Database.rollback(sp);
                    success = false;
                    break;
                }
            }

            return success;

        } catch(Exception ex){
            Database.rollback(sp);
            System.debug('ex: ' + ex.getMessage());
            System.debug('stackTrace: ' + ex.getStackTraceString());
            return false;
        }
    }

    @RemoteAction
    global static Boolean RemoveItem(String itemId, String orderId){
        try{
            Boolean result = taCpqAppHandler.RemoveOrderItem(itemId, orderId);

            return result;
        } catch(Exception ex){
            System.debug('ex: ' + ex.getMessage());
            System.debug('stackTrace: ' + ex.getStackTraceString());
            return false;
        }
    }
    

    public Contact getContact (Id idContact){ 
   
   
            try{
                
                Contact contactSel = [SELECT Id, Name, Email, OtherPhone FROM Contact WHERE Id = :idContact];

                return contactSel; 

            } catch(Exception ex){
                throw ex;
            }
    }


    public vlocity_cmt__BusinessSite__c getWorkLocation (Id idUser){ 

          
            try{
                
                User getUser = [SELECT  Id, Name, Work_Team__c FROM User WHERE Id = :idUser];
                

                WorkTeam__c getWork = [SELECT  Work_Place__c  FROM WorkTeam__c WHERE Id = :getUser.Work_Team__c];
                

                return [SELECT  name, vlocity_cmt__Country__c,  vlocity_cmt__City__c, CUIT__c, vlocity_cmt__State__c, vlocity_cmt__StreetAddress__c, vlocity_cmt__PostalCode__c, Date_of_activation__c FROM vlocity_cmt__BusinessSite__c WHERE Id= :getWork.Work_Place__c];

            } catch(Exception ex){
                throw ex;
            }

    }

    public void getImeiOld (String actIMEI, Id ByAssetId){ 

        
            try{
                

                List <AssetHistory> imeiList  = [SELECT Id, AssetId, Field, OldValue, NewValue from AssetHistory WHERE AssetId=:ByAssetId And Field = 'imei__c'  Order by Id Desc];
                
                system.debug('imeiList: '+ imeiList);

                for(AssetHistory imeiSel: imeiList ){

                    Object imeiGet = (String)imeiSel.NewValue ;

                   
                    if(imeiGet!=null && imeiGet.equals(actIMEI) &&  this.imeiOld == null){
                        this.imeiOld = (String) imeiSel.OldValue;
                    }
                }                    
                              

            } catch(Exception ex){
                throw ex;
            }
        
    }    
    


    /*private static String CreateOrder(List<Map<String, Object>> inputFields){ 
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

    private static Boolean AddItemToOrder(String priceBookEntryId, String orderId){
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

            if(jsonMessage.message != null && jsonMessage.message != '')
                if(jsonMessage.message.equals('Successfully added.'))
                    return true;

            return false;
        } catch(Exception ex){
            throw ex;
        }
    }

    private static Boolean RemoveOrderItem(String itemId, String orderId){
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
    }*/
}