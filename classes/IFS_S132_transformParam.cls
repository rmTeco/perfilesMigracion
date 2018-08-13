global with sharing class IFS_S132_transformParam implements vlocity_cmt.VlocityOpenInterface2 {
    
    public Boolean invokeMethod(String methodName, Map<String, Object> inMap, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true; 

        System.debug('inMap  --> ' + inMap);
        System.debug('outMap --> ' + outMap);

        try {
            if(methodName.equals('getTransformParam')){
                Map<String, Object> m = getTransformParam(inMap);
                if (outMap == null) {
                    outMap = new Map<String, Object>();
                }
                outMap.put('IPResult', m);
                System.debug(outMap);
            }
            else {
                throw new CalloutException('El metodo ' + methodName + ' no existe.');
            }
        }
        catch(Exception e) {
            System.debug('getTransformParam:invokeMethod -> exception: ' + e);
            result = false;
        }
        return result;
    }

    /**
     * Objetivo: Recibe el body del request en pInputMap y lo devuelve en pOutputMap, con 
     *           las transformaciones procesadas.
     */
    private  Map<String, Object> getTransformParam (Map<String, Object> pInputMap) {
        System.debug('Metodo: getTransformParam');

        try {
            if (pInputMap == null || pInputMap.isEmpty()) {
                throw new CalloutException('El inputMap vino nulo o vacio');
            }

            if (pInputMap != null) {
                String jsonInputMap = JSON.serialize(pInputMap);
                System.debug('..... Json pInputMap');
                System.debug(jsonInputMap);
            }

            Map<String, Object> inputMap = (Map<String, Object>) pInputMap.get('Request');

            String camelStr = (String)inputMap.get('camel');
            Map<String, Object> camel = null;
            if (!String.isBlank(camelStr)) {
                camel = (Map<String, Object>)JSON.deserializeUntyped(camelStr);
            }
            else {
                camel = new Map<String, Object>();
            }


            String estadoStr = (String)inputMap.get('estado');
            Map<String, Object> estado = (String.isBlank(estadoStr) ? new Map<String, Object>() : (Map<String, Object>)JSON.deserializeUntyped(estadoStr));

            String hlrSubscriberDataStr = (String)inputMap.get('hlrSubscriberData');
            Map<String, Object> hlrSubscriberData = (String.isBlank(hlrSubscriberDataStr) ? new Map<String, Object>() : (Map<String, Object>)JSON.deserializeUntyped(hlrSubscriberDataStr));

            Map<String, Object> hssSubscriberCategorias = (Map<String, Object>)JSON.deserializeUntyped((String)inputMap.get('hssSubscriberCategorias'));
            if (hssSubscriberCategorias == null) {
                throw new CalloutException('No se encontro el TAG: hssSubscriberCategorias');
            }

            Map<String, Object> hssSubscriberData = (Map<String, Object> )JSON.deserializeUntyped((String)inputMap.get('hssSubscriberData'));
            if (hssSubscriberData==null) {
                throw new CalloutException('No se encontro el TAG: hssSubscriberData');
            }

            Map<String, Object> restriccion = (Map<String, Object>)JSON.deserializeUntyped((String)inputMap.get('restriccion'));
            if (restriccion==null) {
                throw new CalloutException('No se encontro el TAG: restriccion');
            }

            Map<String, Object> serviciosActivos = (Map<String, Object> )JSON.deserializeUntyped((String)inputMap.get('serviciosActivos'));
            if (serviciosActivos==null) {
                throw new CalloutException('No se encontro el TAG: serviciosActivos');
            }

            Map<String, Object> smsEncolado = (Map<String, Object>)JSON.deserializeUntyped((String)inputMap.get('smsEncolado'));
            if (smsEncolado==null) {
                throw new CalloutException('No se encontro el TAG: smsEncolado');
            }

            //Map<String, Object> smobileSubscriberStat = (Map<String, Object>)inputMap.get('mtMobileSubscriberStat');
            String smobileSubscriberStat = (String)inputMap.get('mtMobileSubscriberStat');
            System.debug('smobileSubscriberStat --> ' + smobileSubscriberStat);
            if (smobileSubscriberStat==null) {
                throw new CalloutException('No se encontro el TAG: mtMobileSubscriberStat');
            }
            Map<String, Object> mtMobileSubscriberStat = getMtMobileSubscriberStat(smobileSubscriberStat); //-- Transformo el campo mtMobileSubscriberStat


            inputMap.put('mtMobileSubscriberStat', mtMobileSubscriberStat);
            inputMap.put('smsEncolado', smsEncolado);
            inputMap.put('serviciosActivos', getCleanedField(serviciosActivos));
            inputMap.put('restriccion', getCleanedField(restriccion));
            inputMap.put('hssSubscriberData', hssSubscriberData);
            inputMap.put('hssSubscriberCategorias', hssSubscriberCategorias);
            inputMap.put('hlrSubscriberData', hlrSubscriberData);
            inputMap.put('estado', getCleanedField(estado)); //--> Tranformo el campo estado.
            inputMap.put('camel', getCamel(camel));    //--> Limpio campo camel.

            pInputMap.put('request', inputMap);

        }
        catch (Exception e) {
            System.debug('Error al procesar el pInputMap: ' + e.getMessage());
            String stackTrace = e.getStackTraceString();
            System.debug('===========================================================================');
            System.debug(stackTrace);
            System.debug('===========================================================================');
            throw e;
        }

        return pInputMap;
    }


    /**
     * @Objetivo: Parsear, limpiar y devolverlo como objeto json.
     */
    private Map<String, Object> getMtMobileSubscriberStat (String pParam) {
            System.debug('metodo getMtMobileSubscriberStat');
            Map<String, Object> mapReturn = new Map<String, Object>();
            try {
                if (String.isBlank(pParam)) {
                    throw new CalloutException('El parametro a parsear vino nulo o vacio');
                }
                if (pParam.indexOf('\n')>-1) {
                    System.debug('Separador \n');
                }
                else if (pParam.indexOf('\r')>-1) {
                    System.debug('Separador \r');
                }
                else {
                    System.debug('Separador otro');
                }
                String [] aValues = pParam.split('\\n');
                if (aValues == null || aValues.size()==0) {
                     throw new CalloutException('Fallo al parsear el parametro, no se pudo transformar el string en array.');
                }
                for (Integer i=0; i<aValues.size(); i++) {
                    String valor = aValues[i];
                    String k, v = '';
                    System.debug('----- valor --> ' + valor);
                    String [] aValues2 = valor.split(':');
                    if (aValues2 != null && aValues2.size()==2) {
                        k = aValues2[0].trim();
                        v = aValues2[1].trim();
                    }
                    else if (aValues2 != null && aValues2.size()==1) {
                        k = aValues2[0].trim();
                        v = '';
                    } 
                    else {
                       k = valor;
                       v = ''; 
                    }  
                    mapReturn.put(k,v);
                }
                return mapReturn;
            }
            catch (Exception e) {
                System.debug('---- Error al parsear ' + pParam + ' - Error: ' + e.getMessage());
                return mapReturn;
            }
    }

    /**
     * @Objectivo: Limpio el campo Camel.
     */
    private Map<String, Object> getCamel (Map<String, Object> pCamel) {
        System.debug('--- Entre en getCamel()');
        try {
            return pCamel;
        }
        catch (Exception e) {
            System.debug('Error en metodo getCamel --> ' + e.getMessage());
            return pCamel;
        }
    }

    /**
     * @Objectivo: Recibo un json directo del HLR y lo transformo filtrando
     *             de acuerdo a definicion del Scrum.
     */
    private Map<String, Object> getCleanedField (Map<String, Object> pField) {
        System.debug('--- Entre en getCleanedField()');
        try {
            if (pField == null || pField.isEmpty()) {
                System.debug('Metodo: getCleanedField - Fallo al Deserializar en Map - Devuelvo Map que vino.');
                return pField;
            }

            Map<String, Object> lmapIn = pField.clone();

            Map<String, Object> lmapOut = new Map<String, Object>();
            List<Object> activo = (List<Object>)lmapIn.get('activo');
            List<Object> inactivo = (List<Object>)lmapIn.get('inactivo');

            if (activo != null && !activo.isEmpty()) {
                System.debug('---- Proceso los elementos activos del campo Estado');
                for (Integer i=0; i<activo.size(); i++) {
                    Map<String, Object> elemActivo = (Map<String, Object>)activo.get(i);
                    if (elemActivo != null && !elemActivo.isEmpty()) {
                        System.debug('------ elemActivo --> ' + elemActivo);
                        if (elemActivo.containsKey('vdesc')) {
                            List<Object> lstVDesc = (List<Object>)elemActivo.get('vdesc');
                            System.debug('-------------- vdesc --> ' + lstVDesc);
                            for (Integer j=0; lstVDesc != null && j<lstVDesc.size(); j++) {
                                List<Object> elemVDesc = (List<Object>) lstVDesc.get(j);
                                System.debug('------ elemVDesc --> ' + elemVDesc);
                                for (Integer h=0; elemVDesc != null && h<elemVDesc.size(); h++) {
                                    String elemento = (String) elemVDesc.get(h);
                                    System.debug('--------------- elemento --> ' + elemento);
                                    if (String.isBlank(elemento)) {
                                        elemVDesc.remove(h);
                                    }
                                    else if (elemento.indexOf('ó')>-1) {
                                        System.debug('------------- voy a procesar el elemento --> ' + elemento);
                                        Map<String, Object> jsonObj = new Map<String, Object>();
                                        String[] e = elemento.split('ó');
                                        if (elemento.indexOf('=')>-1) {
/*                                            
                                            for (Integer m=0; e!=null && m<e.size(); m++) {
                                                String valor = e[m];
                                                valor = valor.trim().remove('\'');
                                                if (valor.indexOf('=')>-1) {
                                                    String[] avalor = valor.split('=');
                                                    jsonObj.put(avalor[0].trim().remove('\''),avalor[1].trim().remove('\''));
                                                    elemVDesc.set(h, jsonObj);
                                                    System.debug('------------- nuevo elemento generado --> ' + jsonObj);
                                                }
                                                else {
                                                    jsonObj.put(valor,'');
                                                    elemVDesc.set(h, jsonObj);
                                                    System.debug('------------- nuevo elemento generado --> ' + jsonObj);
                                                }
                                            }
*/
                                            elemVDesc.set(h, elemento);
                                        }
                                        else {    
                                            jsonObj.put(e[0].trim().remove('\''),e[1].trim().remove('\''));
                                            //elemVDesc.set(h, jsonObj);
                                            elemVDesc.set(h, elemento); // nuevo
                                            System.debug('------------- nuevo elemento generado --> ' + jsonObj);
                                        }
                                    }    
                                    else if (elemento.indexOf('=')>-1) {
                                        System.debug('------------- voy a procesar el elemento --> ' + elemento);
                                        Map<String, Object> jsonObj = new Map<String, Object>();
                                        String[] e = elemento.split('=');
                                        jsonObj.put(e[0].trim().remove('\''),e[1].trim().remove('\''));
                                        //elemVDesc.set(h, jsonObj); 28-03-18
                                        elemVDesc.set(h, elemento); // nuevo
                                        System.debug('------------- nuevo elemento generado --> ' + jsonObj);
                                    }
                                }    
                            }    
                        }
                        else {
                            System.debug('------ No contiene vdesc');
                        }    
                    }
                    activo.set(i, elemActivo);
                }
            }
            else {
                System.debug('---- No vino el tag activo.');
            }

            if (inactivo != null && !inactivo.isEmpty()) {
                System.debug('---- Proceso los elementos inactivos del campo Estado');
                for (Integer i=0; i<inactivo.size(); i++) {
                    Map<String, Object> elemInActivo = (Map<String, Object>)inactivo.get(i);
                    System.debug('----- Voy a procesar elemento inactivo: ' + elemInActivo + ' nro: ' + i + ' de ' + inactivo.size());
                    if (elemInActivo != null && !elemInActivo.isEmpty()) {
                        if (elemInActivo.containsKey('vdesc')) {
                            List<Object> lstVDesc = (List<Object>)elemInActivo.get('vdesc');
                            for (Integer j=0; lstVDesc != null && j<lstVDesc.size(); j++) {
                                List<Object> elemVDesc = (List<Object>) lstVDesc.get(j);
                                if (elemVDesc != null && !elemVDesc.isEmpty()) {

                                    for (Integer p=0; p < elemVDesc.size(); p++) {
                                        String elem2 = (String) elemVDesc.get(p);
                                        if (!String.isBlank(elem2) && elem2.endsWithIgnoreCase('</font>')) {
                                            System.debug('Reemplazo o Blanqueo tag completo: ' + elem2);
                                            String replaceElem = getStatusValue (elem2);
                                            if (!String.isBlank(replaceElem)) {
                                                elemVDesc.set(p, replaceElem);
                                            }
                                            else {
                                                elemVDesc.remove(p);
                                            }
                                        }
                                        else if (!String.isBlank(elem2) && !elem2.endsWithIgnoreCase('</font>')) {
                                            System.debug('Voy a evaluar elemento: ' + elem2);
                                            Integer pos1 = elem2.indexOf('<font ');
                                            Integer pos2 = elem2.indexOf('</font>');
                                            if (pos1>-1 && pos2>-1) {
                                                System.debug('---- Voy a procesar: ' + elem2);
                                                String evalElem = elem2.substring(pos1, pos2+7);
                                                String replaceElem = getStatusValue (evalElem);
                                                if (!String.isBlank(replaceElem)) {
                                                    String linea = elem2.substring(0, pos1);
                                                    linea = linea + ' ' + replaceElem + ' ' + elem2.substring(pos2 + '</font>'.length());
                                                    elem2 = linea;
                                                }
                                                else {
                                                    String linea = elem2.substring(0, pos1);
                                                    linea = linea + elem2.substring(pos2 + '</font>'.length());
                                                    elem2 = linea;
                                                }
                                                System.debug('Blanqueo tag parcial: ' + elem2);
                                            }
                                            //-- 
                                            Map<String, Object> jsonObj = new Map<String, Object>();

                                            elem2 = elem2.trim().remove('\'');
/*                                            
                                            if (elem2.indexOf('=')>-1) {
                                                String[] evalor = elem2.split('=');
                                                System.debug('Luego del split = : valor 1 -> ' + evalor[0] + ' valor 2 -> ' + evalor[1]);
                                                jsonObj.put(evalor[0].trim().remove('\''),evalor[1].trim().remove('\''));
                                                System.debug('------------- nuevo elemento generado --> 1 ' + jsonObj);
                                            }
                                            else {
                                                jsonObj.put(elem2,'');
                                                System.debug('------------- nuevo elemento generado --> 2 ' + jsonObj);
                                            }
                                            elemVDesc.set(p,jsonObj);
*/
                                            elemVDesc.set(p, elem2);
                                        }    
                                    }    
                                }
                            }
                        }
                        inactivo.set(i, elemInActivo);
                    }
                }
            }
            else {
                System.debug('---- No vino el tag inactivo.');
            }

            System.debug(JSON.serialize(lmapIn));

            lmapOut = lmapIn;
            return lmapOut;
        }
        catch (Exception e) {
            System.debug('Error al procesar field. Error: ' + e.getMessage());
            String stackTrace = e.getStackTraceString();
            System.debug('===========================================================================');
            System.debug(stackTrace);
            System.debug('===========================================================================');
            
            return pField;
        }
        
    }

    /*
     * @Objetivo: Recibe un elemento y devuelve el valor
     *            que lo debe reemplazar.
     */
    private String getStatusValue (String pElem) {
        if (String.isBlank(pElem)) {
            return '';
        }
        if (pElem.indexOf('#10004')>-1) {
            return 'OK';
        }
        else if (pElem.indexOf('#10060')>-1) {
            return 'NO OK';
        }
        else {
            return '';
        }
    }
    
}