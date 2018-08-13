global with sharing class TransformParam implements vlocity_cmt.VlocityOpenInterface2 {
    
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true; 

        if (outMap == null) {
            //-- Verifico si viene nulo para crearlo, aqui va la respuesta.
            outMap = new Map<String, Object>();
        }

        try {
                if(methodName.equals('getTransformDecimales')){
                    getTransformDecimales(input, outMap);
                }else {
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
     * Objetivo: Recibe el body del request del S143 refill y transforma el montoRecarga en  
     *           monto con 2 decimales
     */
    private void getTransformDecimales (Map<String, Object> pInputMap, Map<String, Object> pOutputMap) {
        System.debug('Metodo: getTransformDecimales');
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

            Map<String, Object> infoRecarga = (Map<String, Object>)body.get('infoRecarga');
            if (infoRecarga == null || infoRecarga.isEmpty()) {
                throw new CalloutException('No se encontro el TAG: infoRecarga');
            }
            System.debug('..... infoRecarga recibido');
            System.debug(JSON.serialize(infoRecarga));

            List<Object> listPagoEfectivo = (List<Object>)infoRecarga.get('listPagoEfectivo');
            System.debug(JSON.serialize(listPagoEfectivo));
            if (listPagoEfectivo == null || listPagoEfectivo.isEmpty()) {
                pOutputMap = pInputMap; //-- Modifique el inputMap y lo copio al outMap
            } else {
                System.debug('Entro en setMontoRecarga');
                infoRecarga.put('listPagoEfectivo', setMontoRecarga(listPagoEfectivo));    
                pOutputMap = pInputMap;
                System.debug('onputMap');
                System.debug(JSON.serialize(pOutputMap));
            }
        }
        catch (CalloutException ce) {
            throw ce;
        }
        catch (Exception e) {
            throw e;
        }
    }

    /**
     * Objetivo: Recorrer la lista pListPagoEfectivo y setear el campo montoRecarga con 2 decimales
     *           
     */
    private List<Object> setMontoRecarga (List<Object> plistPagoEfectivo) {
        System.debug('Metodo: setMontoRecarga');
        // Map<String, Object> result = new Map<String, Object>();
        for (Object obj : plistPagoEfectivo){
            Map<String,Object> mapa = (Map<String,Object>)obj;
            Decimal value = (Decimal)mapa.get('montoRecarga');
            // System.debug('Value montoRecarga: ' + value);
            mapa.put('montoRecarga',formatPlaces(value, 2));
        }

        return plistPagoEfectivo;
    }

    public static String formatPlaces(decimal dec, integer places) {
        String formatedString = dec.setScale(places).ToPlainString(); 
        return formatedString;
    }
}