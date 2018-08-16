global virtual class LoggingSystemInterface extends vlocity_cmt.DefaultSystemInterface
{    
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
        
        super.processResponse(item, url, path, orderObj, res);
    }    
}