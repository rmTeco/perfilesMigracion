global with sharing class IFS_S132_TransformMSISDN implements vlocity_cmt.VlocityOpenInterface2 {
    
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
         Boolean result = true; 

        if (outMap == null) {
            //-- Verifico si viene nulo para crearlo, aqui va la respuesta.
            outMap = new Map<String, Object>();
        }

        try {
            if(methodName.equals('getTransformParam')){
                getTransformParam(input, outMap);
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
    private void getTransformParam (Map<String, Object> pInputMap, Map<String, Object> pOutputMap) {
        System.debug('Metodo: getTransformParam');

        try {
            if (pInputMap == null || pInputMap.isEmpty()) {
                throw new CalloutException('El inputMap vino nulo o vacio');
            }
            String ljson = JSON.serialize(pInputMap);
            System.debug('..... Json recibido');
            System.debug(ljson);

            Map<String, Object> body = (Map<String, Object>)pInputMap.get('body');
            if (body == null || body.isEmpty()) {
                throw new CalloutException('No se encontro el TAG: body');
            }

            String valorConsulta = (String)body.get('valorConsulta');
            if (valorConsulta == null || String.IsBlank(valorConsulta)) {
                throw new CalloutException('No se encontro el Campo: valorConsulta');
            }

            
            if (valorConsulta.length() == 10) {
                valorConsulta = '54' + valorConsulta;
            } else{
                if (valorConsulta.length() < 10) {
                    throw new CalloutException('El Campo valorConsulta tiene una longitud erronea');
                }
            }



            body.put('valorConsulta', valorConsulta);
            pInputMap.put('body',body);
            String ijson = JSON.serialize(pInputMap);
            System.debug('..... Json pInputMap');
            System.debug(ijson);

            pOutputMap = pInputMap; //-- Modifique el inputMap y lo copio al outMap

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