@isTest
public class IFS_ApruebaLogRespTest
{
    
    @isTest static void logCompleto()
    {
        IFS_ApruebaLogResp aplog = new IFS_ApruebaLogResp();
        String jsonReq = '{"Request":{"status":"OK"},"RequestStatus":true,"RequestInfo":{"statusCode":200,"status":"OK","Content-Type":"application/json","Date":"Wed, 27 Jun 2018 18:17:36 GMT","Connection":"close","X-Cache-Lookup":"MISS from proxy-phx.net.salesforce.com:8080","X-Cache":"MISS from proxy-phx.net.salesforce.com"},"RemoteActionLogRequest":{"errorCode":"INVOKE-200","error":"OK"},"RemoteActionLogRequestStatus":true,"SetIDServicio":{"codServicio":"S999"},"SetIDServicioStatus":true,"options":{"idUnico":"22222222"},"params":{"X-Consumer-Transaction-ID":"22222222"},"body":{"pepe":"conejo"}}';
        Map<String, Object> pInputMap = (Map<String, Object>)JSON.deserializeUntyped(jsonReq);
        Map<String, Object> pOutputMap  = new Map<String, Object>();
        Map<String, Object> mapOptions = (Map<String, Object>)pInputMap.get('options');
        if(mapOptions == null || mapOptions.isEmpty()) {
            throw new CalloutException('------------------  options vacio o nulo');
        }

        aplog.invokeMethod('logResp',pInputMap,pOutputMap,mapOptions);  

    }
    @isTest static void logSinRequest() //caso en que no puede obtener respuesta del servicio
    {
        IFS_ApruebaLogResp aplog = new IFS_ApruebaLogResp();
        String jsonReq = '{"Request":{},"RequestStatus":true,"RequestInfo":{"statusCode":200,"status":"OK","Content-Type":"application/json","Date":"Wed, 27 Jun 2018 18:17:36 GMT","Connection":"close","X-Cache-Lookup":"MISS from proxy-phx.net.salesforce.com:8080","X-Cache":"MISS from proxy-phx.net.salesforce.com"},"RemoteActionLogRequest":{"errorCode":"INVOKE-200","error":"OK"},"RemoteActionLogRequestStatus":true,"SetIDServicio":{"codServicio":"S999"},"SetIDServicioStatus":true,"options":{"idUnico":"22222222"},"params":{"X-Consumer-Transaction-ID":"22222222"},"body":{"pepe":"conejo"}}';
        Map<String, Object> pInputMap = (Map<String, Object>)JSON.deserializeUntyped(jsonReq);
        Map<String, Object> pOutputMap  = new Map<String, Object>();
        Map<String, Object> mapOptions = (Map<String, Object>)pInputMap.get('options');
        if(mapOptions == null || mapOptions.isEmpty()) {
            throw new CalloutException('------------------  options vacio o nulo');
        }

        aplog.invokeMethod('logResp',pInputMap,pOutputMap,mapOptions);  

    }
}