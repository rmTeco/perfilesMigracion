global virtual class CorrelationIdSystemInterface extends vlocity_cmt.DefaultSystemInterface
{    
    private static Set<Integer> successStatusCode1=new Set<Integer>
    {
        200, 201, 202, 203, 204, 205, 206, 302, 304
    };

    private static Set<Integer> recoverableErrorStatusCodes1=new Set<Integer>
    {
        408, 426 /* Upgrade is required */, 500, 502, 503, 504, 440, 444, 520, 522, 523, 524, 525
    };

    global virtual override String generatePayload(vlocity_cmt__OrchestrationItem__c item, vlocity_cmt.XOMOrderDomainObject orderObj)
    {
        System.debug('item: '+item + 'orderOBJ' + orderObj);
        String request = super.generatePayload(item, orderObj);
        System.debug('request: ' + request);
        if (request != null)
        {
          item.request__c = JSON.serializePretty(JSON.deserializeUntyped(request));
        }
        System.debug('item.request__C' + item.request__c);
        return request;
    }
    
    global virtual override void processResponse(vlocity_cmt__OrchestrationItem__c item, String url, String path, vlocity_cmt.XOMOrderDomainObject orderObj, HttpResponse res)
    {
        String response = res.getBody();
        System.debug('processResponse - response' + response);
        if (response != null)
        {
          item.response__c = JSON.serializePretty(JSON.deserializeUntyped(response));
        }

        // inject correlation id
        Map<String, Object> responseObj = (Map<String, Object>)JSON.deserializeUntyped(response);
        if(responseObj.containsKey('ROOT')) {
          List<Object> rootContentsList = (List<Object>) responseObj.get('ROOT');

          Map<String, Object> rootContents = (Map<String, Object>) rootContentsList[0];

          if(item.vlocity_cmt__FulfilmentRequestLineId__c != null) {
            rootContents.put('id', item.vlocity_cmt__FulfilmentRequestLineId__c);
          }
        }
        else {
          if(item.vlocity_cmt__FulfilmentRequestLineId__c != null) {
            responseObj.put('id', item.vlocity_cmt__FulfilmentRequestLineId__c);
          }
        }
        
        res.setBody(JSON.serialize(responseObj));
        System.debug('processResponse - response with id' + res.getBody());

        
        super.processResponse(item, url, path, orderObj, res);
    }


    global List<Map<String, Object>> getJsonAttributes(string fullfilmentRequstLineId)
    {
        try{

            List<Map<String, Object>> outputJsonAttributes = new List<Map<String, Object>>();
            Map<String, Object> attributeValue;
            string jsonAttributeNode='';

            List<vlocity_cmt__fulfilmentRequestLine__c> fullfilmentRequstLineList = 
                [SELECT vlocity_cmt__JSONAttribute__c 
                 FROM vlocity_cmt__fulfilmentRequestLine__c 
                 WHERE vlocity_cmt__fulfilmentRequestLine__c.id = :fullfilmentRequstLineId];
           
            for(vlocity_cmt__fulfilmentRequestLine__c attribute : fullfilmentRequstLineList){
                Map<String, Object> jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(attribute.vlocity_cmt__JSONAttribute__c);
                for(string node : jsonAttribute.keySet())
                {
                    jsonAttributeNode = node;                        
                }
                List<Object> attributesList = (List<Object>)jsonAttribute.get(jsonAttributeNode);
                for(Object attribs : attributesList ){
                    attributeValue = new  Map<String, Object>();
                    Map<String, Object> attr = (Map<String, Object>)attribs;
                  
                    attributeValue.put('Name',attr.get('Name'));
                    object x = ((Map<String, Object>)(attr.get('attributeRunTimeInfo'))).get('value');
                    attributeValue.put('value',x);
                    outputJsonAttributes.add(attributeValue);   
                }
            }

            return outputJsonAttributes;
        }
        catch(exception ex){
            system.debug(ex);
            return new List<Map<String, Object>>();     
        }
    } 

    global string getValueFromAttrs(List<Map<String, Object>> attributes, string nodo)
    {
        try{
            for(object attribute:attributes){
                Map<String, Object> attr = (Map<String, Object>)attribute; 
                if(attr.get('Name') == nodo){
                    return String.valueOf(attr.get('value'));
                }
            }
            return '';
        }
        catch(exception ex){
            system.debug(ex);
            return '';
        }   
    }


    global virtual override void executeItem (String url, String path, vlocity_cmt__OrchestrationItem__c item)
    {
        
        Id orderId=null;
        vlocity_cmt.XOMOrderDomainObject orderObj=null;
        string replaceURL='';
        
        if (item.vlocity_cmt__orderItemId__c!=null) {
            orderId=item.vlocity_cmt__orderItemId__r.orderId;
            orderObj=  ((vlocity_cmt.XOMOrderService)vlocity_cmt.XOMObjectFactory.getService(Order.SobjectType)).getObject(orderId, true);
        } else {
            orderId=item.vlocity_cmt__fulfilmentRequestLineId__r.vlocity_cmt__fulfilmentRequestId__c;
            
            
            //========================
            // OrderDomainServiceImpl.getFulfilmentRequest() is not global hence not visible outside of package so need to work around it
            // but there is global getFulfilmentRequests() method which we can use
            // so instead of a 1 liner we have a small piece of code
            // orderObj= ((XOMOrderService)XOMObjectFactory.getService(Order.SobjectType)).getFulfilmentRequest(orderId, true);
            Set<Id> orderIds = new Set<Id>();
            orderIds.add(orderId);
            List<vlocity_cmt.XOMOrderDomainObject> orderObjs = ((vlocity_cmt.XOMOrderService)vlocity_cmt.XOMObjectFactory.getService(Order.SobjectType)).
                getFulfilmentRequests(orderIds, true);
            if (orderObjs!=null && orderObjs.size()>0)
            {
                orderObj = orderObjs.get(0);
                if(path.contains('{')){
                    string regexp = '[{]+[a-zA-Z0-9]+[}]';
                    List<Map<String, Object>> jsonAttributes = getJsonAttributes(item.vlocity_cmt__fulfilmentRequestLineId__r.id);
                    replaceURL = getValueFromAttrs(jsonAttributes,'UrlParam');
                    path = path.replaceAll(regexp, replaceURL);
                }
            }
            else 
                throw new DefaultInterfaceUnrecoverableException  ('Fulfilment request could not be loaded for FR Line '+orderId);
            //=================
        }
        
        String requestPayload = generatePayload(item, orderObj);
        
        System.debug ('Request payload: '+requestPayload);
        
        //Changing url here as we want==========
        
        system.debug(path);
        //url='https://google.com';
        //=================
        
        HttpRequest req = createHttpRequest(url, path, requestPayload);
        
        if (item.vlocity_cmt__timeoutMs__c != null && item.vlocity_cmt__timeoutMs__c >0)
        {
            req.setTimeout ( item.vlocity_cmt__timeoutMs__c.intValue() );
        }
        
        try
        {
            
            Http h=new Http();
            HttpResponse resp=h.send(req);
            
            // TODO: Set returned ID as external ID
            
            Integer statusCode=resp.getStatusCode();
            
            if (!successStatusCode1.contains(statusCode))
            {
                
                if (recoverableErrorStatusCodes1.contains(statusCode))
                {
                    throw new vlocity_cmt.XOMOrchestrationInterfaces.SystemInterfaceRecoverableException ('Recoverable status code '+statusCode+' in response '+resp+' as a request to '+req);
                }
                else
                {
                    throw new DefaultInterfaceUnrecoverableException  ('Unrecoverable status code '+statusCode+' in response '+resp+' as a request to '+req);
                }
                
            }
            
            // The call is successful, let's give subclasses a chance to process response
            processResponse(item, url, path, orderObj, resp);
            
        }
        catch (CalloutException e)
        {
            throw new vlocity_cmt.XOMOrchestrationInterfaces.SystemInterfaceRecoverableException ('Callout exception '+e+': trying to retry');
        }
        
    }

    global virtual override HttpRequest createHttpRequest (String url, String path, String requestPayload)
    {
        HttpRequest req = super.createHttpRequest(url, path, requestPayload);

        //IFS_TokenRequest tokens = new IFS_TokenRequest();
        //List<String> results = tokens.makeTokenRequest();
        //String accessToken=results.get(0);
        //String tokenType=results.get(1);
        //req.setHeader('Authorization', tokenType+' '+accessToken);
        //req.setHeader('Authorization', 'Basic d2VidmFzOndlYnZhcw==');

        return req;
    }

    
    
}