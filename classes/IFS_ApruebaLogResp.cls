global with sharing class IFS_ApruebaLogResp implements vlocity_cmt.VlocityOpenInterface2
{
public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
         Boolean result = true; 

        if (outMap == null) {
            //-- Verifico si viene nulo para crearlo, aqui va la respuesta.
            outMap = new Map<String, Object>();
        }

        try {
            if(methodName.equals('logResp')){   
                logResp(input, outMap);
            }
            else {
                throw new CalloutException('El metodo ' + methodName + ' no existe.');
            }
        }
        catch(Exception e) {
            System.debug('TransformParam:invokeMethod -> exception: ' + e);
            result = false;
        }
        return result;
    }
    
    /**
     * Objetivo: Recibe el  request en pInputMap y lo devuelve en pOutputMap, con 
     *           las transformaciones procesadas.
     */
    private void logResp (Map<String, Object> pInputMap, Map<String, Object> pOutputMap) {
        System.debug('----------------------- Metodo: logResp');
///////////////////////////////////////////////////////////////////////////////////////////////////////////
        try {
            System.debug('---------------------- ESTA LUEGO RESPONSE    ');
            if (pInputMap == null || pInputMap.isEmpty()) {
                throw new CalloutException('El inputMap vino nulo o vacio');
            }
            String ljson = JSON.serialize(pInputMap);
            System.debug('---------------------- Json recibido'); 
            System.debug(ljson);
         //   Map<String, Object> m = (Map<String, Object>)pInputMap.get('Response');
         //   System.debug('XXXXXXXXXXXXXXXXXXXXXXXX  '   + m);
            Map<String, Object> mapSetIDServicio = (Map<String, Object>)pInputMap.get('SetIDServicio');
            if (mapSetIDServicio == null || mapSetIDServicio.isEmpty()) {
                throw new CalloutException('------------------  No se encontro el TAG: SetIDServicio');
            }
 //           Map<String, Object> mapIdservicio = (Map<String, Object>) mapSetIDServicio.get('codServicio');
//            if (mapIdservicio == null || mapIdservicio.isEmpty()) {
//                throw new CalloutException('------------------  No se encontro el TAG: codServicio');
//            }
            String strIdServicio = (String)mapSetIDServicio.get('codServicio');
            System.debug('---------------------- codServicio recibido');
            System.debug(strIdServicio);

            Map<String, Object> mapOptions = (Map<String, Object>)pInputMap.get('options');
            if(mapOptions == null || mapOptions.isEmpty()) {
                throw new CalloutException('------------------  options vacio o nulo');
            }

            String idUnico = (String) mapOptions.get('idUnico');

            String fechaTiempo = (String)mapOptions.get('fechaTiempo');
            String origen = (String)mapOptions.get(strIdServicio);
            String reqResp = (String)mapOptions.get('reqResp');
            Map<String, Object> mapParams = (Map<String, Object>)pInputMap.get('params');
            String strParams = null;
            if (mapParams == null || mapParams.isEmpty())
            {
                strParams = '  ';
            }
            else
            {
                strParams = JSON.serialize(mapParams);
            }
            //Registra el log del request en el objeto Log
            System.debug('------------------ Datos que se pasarán a la clase que registra el request en el objeto LOG');
            System.debug('------------------ TimeStamp : ' + fechaTiempo);
            System.debug('------------------ Origen : ' + strIdServicio); 
            System.debug('------------------ X-Consumer-Transaction-ID : ' + idUnico);
            System.debug('------------------ Indicativo req o resp : REQ');
            System.debug('------------------ Parametros : ' + strParams);
            System.debug('------------------ Payload :' );



            IFS_LogRecord.record(fechaTiempo, 'SERVICIO', strIdServicio, 'REQ', idUnico, strParams, '' );

            Map<String,Object> mapRequestInfo = (Map<String, Object>)pInputMap.get('RequestInfo');
            System.debug('--------------------- LUEGO DE GET DE RequestInfo' + mapRequestInfo );
            if (mapRequestInfo == null)
            {
                Set<String> keyValues = pInputMap.keySet();
                for (String key : keyValues)
                {
                    System.debug('--------------------- FOR DE LOS KEY' + key);
                    if (key.contains('Request') && key.endsWith('Info'))
                    {
                        mapRequestInfo = (Map<String, Object>)pInputMap.get(key);
                    }
                }
            }
            String strStatusCode = ' ';
            String strStatus = '';
            Integer intStatusCode = 0;
            if (!(mapRequestInfo == null  || mapRequestInfo.isEmpty()))
            {
                intStatusCode = (Integer) mapRequestInfo.get('statusCode');
                strStatusCode = String.valueOf(intStatusCode);
                strStatus = (String)mapRequestInfo.get('status');
            }
 
            String payload = 'status code = ' + strStatusCode + ' ; status = ' + strStatus;
           System.debug('--------------------- LUEGO DE PONER EL PAYLOAD');
            // Map<String, Object> body = (Map<String, Object>)pInputMap.get('body');
            // if (body == null || body.isEmpty()) {
            //     throw new CalloutException('------------------  No se encontro el TAG: body');
            // }
//            String valorConsulta = (String)body.get('valorConsulta');
//            if (valorConsulta == null || String.IsBlank(valorConsulta)) {
//                throw new CalloutException('No se encontro el Campo: valorConsulta');
//            }

//            body.put('valorConsulta', valorConsulta);
//            pInputMap.put('body',body);
//            String ijson = JSON.serialize(pInputMap); 
//            System.debug('..... Json pInputMap');
//            System.debug(ijson); 

            // Invoca a la clase que hace el log por ahora sale en el log de salesg=force
            String tZ = 'America/Argentina/Buenos_Aires';
            fechaTiempo = datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', tZ);
          //  fechaTiempo = datetime.now().format('yyyy-MM-ddTHH:mm:ss.SSSZ', tZ);
         //   System.debug(datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
            //obtengo los parametros para mostrarlos
            System.debug('--------------------- LUEGO DE FECHA TIEMPO ');
            String strBody = '';
            Map<String,Object> bodyMap = (Map<String,Object>) pInputMap.get('body');
             System.debug('--------------------- LUEGO DE GET DE BODY ');
            if (!(bodyMap == null || bodyMap.isEmpty()))
            {
                strBody = JSON.serialize(bodyMap);
                System.debug('--------------------- strBody : ' + strBody);
            }
            Map<String, Object> m = (Map<String, Object>)pInputMap.get('Response');
            System.debug('--------------------- LUEGO OBTENER DE PiNPUTmAP EL GET DE Response ');
            Object oRequest = (Object)pInputMap.get('Request');
            System.debug('--------------------- LUEGO OBTENER oRequest EL GET DE Request ' + oRequest);
            if (oRequest == null)
            {
                System.debug('--------------------- oRequest ES NULL');
                 Set<String> keyValues = pInputMap.keySet();
                for (String key : keyValues)
                {
                    System.debug('--------------------- eSTA EN CICLO ' + key);
                    if (key.contains('Request') && key.indexOf('Request') == 0)
                    {
                        oRequest = pInputMap.get(key); 
                        System.debug('--------------------- ENCUENTRA ' + oRequest);
                    }
                }
            }
            
            System.debug('------------------ oRequest : ' + oRequest);
            boolean logBody = false;
            String strRequest = '';
            String strRequestError = '';
            if (oRequest == null)
            {
                logBody = true;
            }
            else if (oRequest instanceof String)
            {
                if( String.IsBlank((String)oRequest))
                    logBody = true;
                else
                    strRequest = (String) oRequest;
            }
            else if(oRequest instanceof Map<String,Object>)
            {
                Map<String,Object> mapRequest = (Map<String,Object>)oRequest;
                if(mapRequest.isEmpty())
                    logBody = true;
            }
            if (!String.IsBlank(strRequest) )
            {
                logBody = true;
            }
       
            if (intStatusCode > 399)  
            {
                logBody = true; 
                if (oRequest instanceof Map<String,Object>)
                    strRequest = JSON.serialize(oRequest);
            }
            if (logBody && !(intStatusCode == 200 || intStatusCode == 201))
            {
                payload = payload + ' ; request to DPW  FAIL ; request body = ' + strBody + ' ; Response = ' + strRequest ;
            }
            else
            {
                payload = payload + ' ; request to DPW  OK';
            }

            System.debug('------------------ logBody : ' + logBody);
            System.debug('------------------ strBody : ' + strBody);    

            System.debug('------------------ Datos que se pasarán a la clase que registra el response en el objeto LOG');
            System.debug('------------------ TimeStamp : ' + fechaTiempo);
            System.debug('------------------ Origen : ' + strIdServicio); 
            System.debug('------------------ X-Consumer-Transaction-ID : ' + idUnico);
            System.debug('------------------ Indicativo req o resp : RES');
            System.debug('------------------ Parametros : ' + strParams);
            System.debug('------------------ Payload : ' + payload);

            //Registra en el objeto log
            IFS_LogRecord.record(fechaTiempo, 'SERVICIO', strIdServicio, 'RES', idUnico, strParams, payload );
            System.debug('--------------JUSTO despues de el record ' );
            String ijson = JSON.serialize(pInputMap);         
            System.debug('..... Json input nuevo');
            System.debug(ijson);
            
            bodyMap = (Map<String,Object>) pInputMap.get('body');
            String oB = JSON.serialize(bodyMap);
            System.debug('..... obtenido como body');
            System.debug(oB);
            Map<String,Object> RequestVar = (Map<String,Object>)pInputMap.get('Request');

        //    RequestVar.put('status_code',strStatusCode);     OJO ACTIVAR EN EL FUTURO

            pOutputMap = pInputMap;
    
  

            String ojson = JSON.serialize(pOutputMap);
            System.debug('..... Json devuelto');
            System.debug(ojson);
        }
        catch (CalloutException ce) {
            throw ce;
        }
        catch (Exception e) {
            throw e;
        }
    
    
    }
    }