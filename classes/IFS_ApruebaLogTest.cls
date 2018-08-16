@isTest
public class IFS_ApruebaLogTest
{
    
    @isTest static void logCompleto()
    {
        IFS_ApruebaLog aplog = new IFS_ApruebaLog();
        String jsonReq = '{"SetIDServicio":{"codServicio":"S999"},"SetIDServicioStatus":true,"options":{},"params":{"X-Consumer-Transaction-ID":"22222222"},"body":{"pepe":"conejo"}}';
        Map<String, Object> pInputMap = (Map<String, Object>)JSON.deserializeUntyped(jsonReq);
        Map<String, Object> pOutputMap  = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>(); 
        aplog.invokeMethod('logReq',pInputMap,pOutputMap,options);  
  //      public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, 
  //      Object> outMap, Map<String, Object> options)
    }
    @isTest static void logSinParam()
    {
        IFS_ApruebaLog aplog = new IFS_ApruebaLog();
        String jsonReq = '{"SetIDServicio":{"codServicio":"S999"},"SetIDServicioStatus":true,"options":{},"body":{"pepe":"conejo"}}';
        Map<String, Object> pInputMap = (Map<String, Object>)JSON.deserializeUntyped(jsonReq);
        Map<String, Object> pOutputMap  = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>(); 
        aplog.invokeMethod('logReq',pInputMap,pOutputMap,options);  
    }
}