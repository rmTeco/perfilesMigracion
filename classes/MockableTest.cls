public class MockableTest implements vlocity_cmt.VlocityOpenInterface2 {
    
    public MockableTest() {
        
    }
    
    public Object invokeMethod(String methodName, Map<String,Object> inputs, Map<String,Object> output, Map<String,Object> options) {
        Boolean success = true;
        try {
            if(methodName == 'getAvailability')
            {
                Object obj = MockableTest.getAvailability(inputs);   
                output.put('result',obj);
            } else if(methodName == 'getQuestions')
            {
                Object obj = MockableTest.getAvailability(inputs);   
                output.put('result',obj);
            } else if(methodName == 'verifyAnswers')
            {
                Object obj = MockableTest.getAvailability(inputs);   
                output.put('result',obj);
            } else if(methodName == 'assetToOrder')
            {
                Object obj = MockableTest.getAvailability(inputs);   
                output.put('result',obj);
            } else {
                success = false;
            }
            
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR,'Error invoke method: ' + methodName + ' with error: '+ e);
            success = false;
        }
        return success;
    }
    
    public static Object getAvailability(Map<String,Object> inputs){
        //Endpoint and Method
        String endpoint = 'https://demo9538567.mockable.io/getAvailability', restMethod = 'POST';
        Map<String,String> headers = new Map<String,String>();
        
        //Setup Body
        String restBody = inputs.get('data') != null ? JSON.serialize(inputs.get('data')) : '';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(restMethod);

        if(headers != null) {
            for(String key : headers.keySet()) {
                req.setHeader(key, (String)headers.get(key));
            }
        }
        //If HTTP Method is POST then add body to the request and add Content-Length header
        if(restMethod == 'POST' || restMethod == 'PUT') {
            req.setBody(restBody);
            req.setHeader('Content-Length', String.valueOf(restBody.length()));
        }

        //make HTTP request
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res);
        if(res.getStatusCode() != 200) {
            String errMsg = String.valueof(res.getStatusCode()) + ': ' + (String)res.getStatus();
            return errMsg;
        } else {
            return res.getBody();
        }
    }
}