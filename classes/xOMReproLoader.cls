public without sharing class xOMReproLoader {
    
    public static Integer LINES_PER_BULK_JOB = 1000;


    // First step: Receive the request and create XOMBatchLineJob records for each line
    public static ResultObj generateReproJobsFromJSON(ReproLinesRequestObject reproLineRequest) {
        if(!validateRequest(reproLineRequest)) {
            return new ResultObj(400, 'Request failed validations');
        }

        List<XOMBatchLineJob__c> reproLinesSObjectList = new List<XOMBatchLineJob__c>();
        
        for(ReproLine rl : reproLineRequest.payload) {
            XOMBatchLineJob__c xomBLJ = new XOMBatchLineJob__c();
            xomBLJ.Account__c = reproLineRequest.header.wholesaleId;
            xomBLJ.JSON__c = JSON.serialize(rl);
            xomBLJ.Lote_Id__c = reproLineRequest.header.loteId;
            xomBLJ.Type__c = 'Repro';
            reproLinesSObjectList.add(xomBLJ);
        }

        insert reproLinesSObjectList;

        return new ResultObj(202, 'Lines added to the queue.');
    }


    // Perform validations to the received request
    public static Boolean validateRequest(ReproLinesRequestObject reproLineRequest) {
        return reproLineRequest != null && 
                reproLineRequest.payload != null && 
                reproLineRequest.payload.size() <= 1000;
    }


    // Second step: creating orders for each job
    public static Boolean createOrdersFromBulkJob(List<XOMBatchLineJob__c> reproLines, Repro_Loader_Settings__c settings) {
        

        //Savepoint sp = Database.setSavepoint();
        
        // Retrieve and map all offers
        Map<String, Product2> offersMap = new Map<String, Product2>();

        for(XOMBatchLineJob__c reproLineSObject : reproLines) {
            ReproLine reproLineObj = (ReproLine) JSON.deserialize(reproLineSObject.JSON__c, ReproLine.class);
            offersMap.put(reproLineObj.offerId, null);
        }

        offersMap.putAll([Select Id From Product2 Where Id in :offersMap.keySet()]);

        // Create all orders
        Map<String, Order> ordersMap = new Map<String, Order>();

        for(XOMBatchLineJob__c reproLineSObject : reproLines) {
            try {
                ReproLine reproLineObj = (ReproLine) JSON.deserialize(reproLineSObject.JSON__c, ReproLine.class);
                System.debug(reproLineObj);
                if(!offersMap.keySet().contains(reproLineObj.offerId)) {
                    System.debug(reproLineObj.offerId);
                    reproLineSObject.Error_Message__c = 'Product not found';
                    continue;
                }

                Order o = new Order();
                o.vlocity_cmt__PriceListId__c = settings.Pricelist_Id__c;
                //o.vlocity_cmt__OriginatingChannel__c = 'Dealer';
                o.Gestion__c = 'Preactivacion Repro';
                o.Status = 'Draft';
                o.EffectiveDate = Date.today();
                o.AccountId = reproLineSObject.Account__c;

                ordersMap.put(reproLineSObject.Id, o);
            }
            catch(Exception ex) {
                reproLineSObject.Error_Message__c = ex.getStackTraceString() + ' : ' +  ex.getMessage();
                reproLineSObject.ProcessingFailed__c = true;
            }
            
        }

        insert ordersMap.values();

        List<OrderItem> orderItemsToUpdate = new List<OrderItem>();
        // Add offer to each order
        for(XOMBatchLineJob__c reproLineSObject : reproLines) {
            try {
                Order reproLineOrder = ordersMap.get(reproLineSObject.Id);

                reproLineSObject.Order__c = reproLineOrder.Id;

                reproLineSObject.OrderCreated__c = true;
            }
            catch(Exception ex) {
                reproLineSObject.Error_Message__c = ex.getStackTraceString() + ' : ' +  ex.getMessage();
                reproLineSObject.ProcessingFailed__c = true;
            }
        }

        return true;
    }



    public static Boolean addItemsToOrderFromBulkJob(List<XOMBatchLineJob__c> reproLines, Repro_Loader_Settings__c settings) {
        //Savepoint sp = Database.setSavepoint();
        
        List<OrderItem> orderItemsToUpdate = new List<OrderItem>();
        // Add offer to each order
        for(XOMBatchLineJob__c reproLineSObject : reproLines) {
            try {
                ReproLine reproLineObj = (ReproLine) JSON.deserialize(reproLineSObject.JSON__c, ReproLine.class);

                String offerId = reproLineObj.offerId;

                PriceBookEntry pbe = [Select Id From PriceBookEntry Where ProductCode = :offerId and IsActive = true and Pricebook2.Name = :settings.Pricebook_Name__c];
                system.debug(pbe);
                system.debug(reproLineSObject.Order__c);
                system.debug(reproLineObj);
                //Object postCartsItemsResponse = vlocity_cmt.CardCanvasController.doGenericInvoke('vlocity_cmt.CpqAppHandler', 'postCartsItems', JSON.serialize(getCartsProductsResponseParams), '{"vlcClass":" vlocity_cmt.CpqAppHandler"}');
                Object postCartsItemsResponse = vlocity_cmt.CardCanvasController.doGenericInvoke('vlocity_cmt.CpqAppHandler', 'postCartsItems','{"query":null,"hierarchy":-1,"lastRecordId":null,"pagesize":1,"includeAttachment":false,"validate":true,"price":true,"cartId":"'+reproLineSObject.Order__c+'","items":[{"itemId":"'+pbe.Id+'"}],"methodName":"postCartsItems"}', '{"vlcClass":" vlocity_cmt.CpqAppHandler"}');
                
                //Repro Pricebook Id: 01u0U000000LLElQAO

                //Object getCartsProductsResponse = vlocity_cmt.CardCanvasController.doGenericInvoke('vlocity_cmt.CpqAppHandler', 'getCartsProducts', '{"methodName": "getCartsProducts", "cartId": "8010U0000001jvT", "items": null, "pagesize": 99, "filters": null, "price": null, "validate": false, "includeAttachment": false, "lastRecordId": null, "hierarchy": -1}', '{"vlcClass":" vlocity_cmt.CpqAppHandler"}');
                
                // update attributes
                List<OrderItem> orderItems = [Select ProductCode__c, vlocity_cmt__JSONAttribute__c From OrderItem Where OrderId = :reproLineSObject.Order__c];

                // update status to Preactive
                for(OrderItem oi : orderItems) {
                    oi.vlocity_cmt__ProvisioningStatus__c = 'Preactive';
                    // update attributes just for the configured product
                    if(oi.ProductCode__c == settings.Attributes_Target_Product_Code__c) {
                        Map<String, Object> attributeCategories = (Map<String, Object>) JSON.deserializeUntyped(oi.vlocity_cmt__JSONAttribute__c);
                        attributeCategories = setValueFromAttrs(attributeCategories, 'MSISDN', reproLineObj.msisdn);
                        attributeCategories = setValueFromAttrs(attributeCategories, 'IMSI', reproLineObj.imsi);
                        attributeCategories = setValueFromAttrs(attributeCategories, 'ICCID', reproLineObj.iccid);
                        attributeCategories = setValueFromAttrs(attributeCategories, 'KI', reproLineObj.ki);
                        oi.vlocity_cmt__JSONAttribute__c = JSON.serialize(attributeCategories);
                    }
                }
                
                orderItemsToUpdate.addAll(orderItems);

                reproLineSObject.ItemsAddedToOrder__c = true;
            }
            catch(Exception ex) {
                reproLineSObject.Error_Message__c = ex.getStackTraceString() + ' : ' +  ex.getMessage();
                reproLineSObject.ProcessingFailed__c = true;
            }
        }

        update orderItemsToUpdate;

        return true;
    }

    public static Map<String, Object> setValueFromAttrs(Map<String, Object> attributeCategories, String attributeName, String newValue) {
        try {
            for(Object attributeCategory : attributeCategories.values()) {
                for(Object attribute: (List<Object>) attributeCategory) {
                    Map<String, Object> attr = (Map<String, Object>)attribute; 
                    if((attr.containsKey('attributedisplayname__c') && attr.get('attributedisplayname__c') == attributeName)
                        || (attr.containsKey('Name') && attr.get('Name') == attributeName)) {
                        Map<String, Object> attributeRunTimeInfo = (Map<String, Object>)(attr.get('attributeRunTimeInfo'));
                        attributeRunTimeInfo.put('value', newValue);
                        return attributeCategories;
                    }
                }
            }
        }
        catch(exception ex){
            system.debug(ex);
        }
        return attributeCategories;
    }

    public class CPQAppHandlerRemoteRequest {
        public String methodName;
        public String cartId;
        public List<Map<String, String>> items;
        public Integer pagesize;
        public String filters;
        public Boolean price;
        public Boolean validate;
        public Boolean includeAttachment;
        public String lastRecordId;
        public Integer hierarchy;

        public CPQAppHandlerRemoteRequest(String methodName, String cartId, List<Map<String, String>> items, Integer pagesize, String filters, Boolean price, Boolean validate, Boolean includeAttachment, String lastRecordId, Integer hierarchy) {
            this.methodName = methodName;
            this.cartId = cartId;
            this.items = items;
            this.pagesize = pagesize;
            this.filters = filters;
            this.price = price;
            this.validate = validate;
            this.includeAttachment = includeAttachment;
            this.lastRecordId = lastRecordId;
            this.hierarchy = hierarchy;
        }
    }


    // Third step: executing the orders created for each job
    public static Boolean executeOrdersFromBulkJob(List<XOMBatchLineJob__c> reproLines) {
        //Savepoint sp = Database.setSavepoint();
        
        for(XOMBatchLineJob__c reproLineSObject : reproLines) {
            try {
                vlocity_cmt.SimpleDecompositionController.decomposeOrder(reproLineSObject.Order__c);

                vlocity_cmt.SimpleDecompositionController.startOrchestrationPlan(reproLineSObject.Order__c);

                reproLineSObject.OrderDecomposed__c = true;
            }
            catch(Exception ex) {
                reproLineSObject.Error_Message__c = ex.getStackTraceString() + ' : ' +  ex.getMessage();
                reproLineSObject.ProcessingFailed__c = true;
            }
        }

        return true;
    }



    public class ResultObj {
        public Integer resultCode;
        public String resultMessage;

        public ResultObj(Integer code, String msg) {
            this.resultCode = code;
            this.resultMessage = msg;
        }
    }

    
    public class ReproLinesRequestObject {
        public ReproLineHeader header;
        public List<ReproLine> payload;
    }

    public class ReproLineHeader {
        public String loteId;
        public String loteSize;
        public String wholesaleId;
    }

    public class ReproLine {
        public String msisdn;
        public String imsi;
        public String iccid;
        public String ki;
        public String offerId;

        public ReproLine(String msisdn, String imsi, String iccid, String ki, String offerId) {
            this.msisdn = msisdn;
            this.imsi = imsi;
            this.iccid = iccid;
            this.ki = ki;
            this.offerId = offerId;
        }
    }
}

/*
131 characters: {"ws":"123456789012345","msisdn":"+5491144444444","imsi":"123456789012345","iccid":"12345678901234567890","oId":"123456789012345"},
1,000 lines on one text area (long) field
*/