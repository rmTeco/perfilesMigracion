global with sharing class IFS_ApruebaLog implements vlocity_cmt.VlocityOpenInterface2
{
public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
         Boolean result = true; 

        if (outMap == null) {
            //-- Verifico si viene nulo para crearlo, aqui va la respuesta.
            outMap = new Map<String, Object>();
        }

        try {  
            if(methodName.equals('logReq')){
                logReq(input, outMap);
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
     * Objetivo: Recibe el body del request en pInputMap y lo devuelve en pOutputMap, con 
     *           las transformaciones procesadas.
     */
    private void logReq (Map<String, Object> pInputMap, Map<String, Object> pOutputMap) {
        System.debug('----------------------- Metodo: logRec');

        try {
            if (pInputMap == null || pInputMap.isEmpty()) {
                throw new CalloutException('El inputMap vino nulo o vacio');
            }
            String ljson = JSON.serialize(pInputMap);
            System.debug('---------------------- Json recibido');
            System.debug(ljson);
            Map<String, Object> mapSetIDServicio = (Map<String, Object>)pInputMap.get('SetIDServicio');
            if (mapSetIDServicio == null || mapSetIDServicio.isEmpty()) {
                throw new CalloutException('------------------  No se encontro el TAG: SetIDServicio');
            }

            String strIdServicio = (String)mapSetIDServicio.get('codServicio');
            System.debug('---------------------- codServicio recibido');
            System.debug(strIdServicio);

            Map<String, Object> mapOptions = (Map<String, Object>)pInputMap.get('options');
            String idUnico = null;

            Map<String, Object> mapParams = (Map<String, Object>)pInputMap.get('params');
            if(mapParams == null || mapParams.isEmpty()) {
                System.debug('--------------------mapParams nulo o vacio');
                idUnico = GuidUtil.NewGuid();
            }
            else
            {
                idUnico =(String) mapParams.get('X-Consumer-Transaction-ID');
                System.debug('--------------------idUnico : ' + idUnico);
                if (idUnico == null)
                {
                    idUnico = GuidUtil.NewGuid();
                }
            }

            // mapOptions.put('idUnico',idUnico);
            // pInputMap.put('options',mapOptions);


            Map<String, Object> body = (Map<String, Object>)pInputMap.get('body');


// -------------------------------------------------------------------------------------
            // Invoca a la clase que hace el log por ahora sale en el log de salesg=force
            String tZ = 'America/Argentina/Buenos_Aires';
            String fechaTiempo = datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', tZ);
         //   System.debug(datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
            //obtengo los parametros para mostrarlos
            String strParams = null;
            if (mapParams == null || mapParams.isEmpty())
            {
                strParams = '  ';
            }
            else     
            {
                strParams = JSON.serialize(mapParams);
            }
            System.debug('------------------ Datos que se pasarán a la clase que registra el objeto LOG');
            System.debug('------------------ TimeStamp : ' + fechaTiempo);
            System.debug('------------------ Origen : ' + strIdServicio); 
            System.debug('------------------ X-Consumer-Transaction-ID : ' + idUnico);
            System.debug('------------------ Indicativo req o resp : REQ');
            System.debug('------------------ Parametros : ' + strParams);
            System.debug('------------------ Payload : ');

            //llama a la registración del log
//          //  IFS_LogRecord.record(fechaTiempo, 'SERVICIO', strIdServicio, 'REQ', idUnico, strParams, '' );
            //Pone en options lo que se debe registrar del request en el log (se registra en la otra clase al final)
            mapOptions.put('fechaTiempo',fechaTiempo);
            mapOptions.put('origen',strIdServicio);
            mapOptions.put('idUnico',idUnico);
            mapOptions.put('reqResp','REQ');
            mapOptions.put('strParams',strParams);
            pInputMap.put('options',mapOptions);
            
            pOutputMap = pInputMap; //-- lo copio al outMap
    
  

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