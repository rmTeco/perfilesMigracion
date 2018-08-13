global with sharing class GP_Adapter implements vlocity_cmt.VlocityOpenInterface{
    
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            
            if(methodName.equals('crearAcumuladorSocioTitular')) crearAcumuladorSocioTitular(input);
            else if(methodName.equals('crearAcumuladorSubscriptorNuevo')) crearAcumuladorSubscriptorNuevo(input);
            else if(methodName.equals('sumarRestarPuntos')) sumarRestarPuntos(input, outMap);
            else if(methodName.equals('consultarTransacciones')) consultarTransacciones(input, outMap);
            else if(methodName.equals('consultarEstadoAcumulador')) consultarEstadoAcumulador(input, outMap);
            else if(methodName.equals('eliminarAcumuladores')) eliminarAcumuladores(input);
            else if(methodName.equals('consultarPuntos')) consultarPuntos(input, outMap);
            else if(methodName.equals('transferirPuntos')) transferirPuntos(input, outMap);
            else if(methodName.equals('anularCanje')) anularCanje(input, outMap);
            else if(methodName.equals('agregarAsset')) agregarAsset(input);
            else if(methodName.equals('eliminarAsset')) eliminarAsset(input);
            else throw new GP_APIException('El metodo '+methodName+ ' no existe.'); 
            
        } catch(GP_APIException ex){
            system.debug(ex.getStackTraceString()+ex.getMessage());
            outMap.put('error', ex.getMessage());
            options.put('error', ex.getMessage());
        }
        
        return true;
    }


    public static void crearAcumuladorSocioTitular(Map<String,Object> input){
        List<Object> datosSocio = (List<Object>) input.get('datosSocio');

        List<String> idsCuentas = new List<String>();
        for(Object aux: datosSocio){
            Map<String,Object> mapa = (Map<String,object>) aux; 
            idsCuentas.add((String) mapa.get('cuenta')); 
        }

        List<Account> cuentas = [select id, 
                                 (select id, vlocity_cmt__ServiceAccountId__c from vlocity_cmt__BillingAccountAssets__r) 
                                 from account 
                                 where id in: idsCuentas];

        List<GP_socioAAdherir> sociosAAdherir = new List<GP_socioAAdherir>();
        for(Account cuenta: cuentas){
            
            GP_socioAAdherir nuevoSocioTitular = new GP_socioAAdherir(cuenta.id, '0', new List<String>());
            
            Map<String, GP_socioAAdherir> socioAdherentePorCuenta = new Map<String, GP_socioAAdherir>();

            for(Asset a: cuenta.vlocity_cmt__BillingAccountAssets__r){
                if(a.vlocity_cmt__ServiceAccountId__c == cuenta.id){
                    nuevoSocioTitular.assets.add(a.id);
                }else{
                    GP_socioAAdherir socioAux = socioAdherentePorCuenta.get(a.vlocity_cmt__ServiceAccountId__c);

                    if(socioAux == null){
                      List<String> idAssetAdherente = new List<String>();
                      idAssetAdherente.add(a.id);
                      socioAdherentePorCuenta.put(a.vlocity_cmt__ServiceAccountId__c, 
                                                  new GP_socioAAdherir(a.vlocity_cmt__ServiceAccountId__c, cuenta.id, idAssetAdherente));
                    }else{
                        socioAux.assets.add(a.id);
                    }

                }
            }

            sociosAAdherir.add(nuevoSocioTitular);
            if(socioAdherentePorCuenta.values().size()>0){
                sociosAAdherir.addAll(socioAdherentePorCuenta.values());
            }
        }

        GP_API.crearAcumuladorSocioTitular(sociosAAdherir); 
    }
    
    public static void crearAcumuladorSubscriptorNuevo(Map<String,Object> input){
        system.debug('entre a acumuladorSubscriptorNuevo');
        system.debug(input);
        
        Map<String, Object> datosSocio = (Map<String, Object>) input.get('datosSocio');
        
        String idCuentaTitular = (String) datosSocio.get('titularID');
        String idSuscriptor = (String) datosSocio.get('suscriptorID');

        List<String> assets = (List<String>) datosSocio.get('assetsID');

        system.debug(idCuentaTitular);
        system.debug(idSuscriptor);
        system.debug(assets);
        
        GP_API.crearAcumuladorSuscriptorNuevo(idCuentaTitular, idSuscriptor, assets);  
    }

    public static void sumarRestarPuntos(Map<String, Object> input, Map<String, Object> outMap){
        
        system.debug('entre a sumar restar puntos');
        
        List<Object> datosSumarRestarPuntos = (List<Object>) input.get('sumarRestarPuntos');

         List<GP_sumarRestarPuntosItem> itemsSumarRestar = new List<GP_sumarRestarPuntosItem>();
         for(Object mapaAux: datosSumarRestarPuntos){
             
             
            Map<String,Object> mapa = (Map<String,Object>) mapaAux;
            String idTitular = (String) mapa.get('titularID');
            String idSuscriptor = (String) mapa.get('suscriptorID');
            /*
            Double puntos = 0;
            if((Double) mapa.get('puntos') != null) {
                puntos = (Double) mapa.get('puntos');
            }
            */
            String tipoDeEvento = (String) mapa.get('tipoDeEvento');
            Integer numeroDeOrden = (Integer) mapa.get('numeroDeOrden');
            List<Object> mapaVariables = (List<Object>) mapa.get('atributosEvento');

            /*system.debug(idTitular);
            system.debug(idSuscriptor);
            system.debug(tipoDeEvento);
            system.debug(numeroDeOrden);*/

            List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
            for(Object itemAux: mapaVariables){
                Map<String,Object> item = (Map<String,Object>) itemAux;
                String variable = (String) item.get('variable');
                String tipo = (String) item.get('tipo');
                String valorString = (String) item.get('valorString');
                Integer valorNumerico = (Integer) item.get('valorInteger');
                Boolean valorBooleano = (Boolean) item.get('valorBooleano'); 

                if(valorString != null) atributos.add(new GP_AtributoValorDeUnEvento(variable, tipo, valorString));
                else if(valorNumerico != null) atributos.add(new GP_AtributoValorDeUnEvento(variable, tipo, valorNumerico));
                else if(valorBooleano != null) atributos.add(new GP_AtributoValorDeUnEvento(variable, tipo, valorBooleano));
                else throw new GP_APIException ('Uno de los campos valor debe ser completado obligatoriamente');
            }

            itemsSumarRestar.add( new GP_sumarRestarPuntosItem(idTitular, idSuscriptor, tipoDeEvento, numeroDeOrden, atributos)); 
         }

         Gp_api.sumarRestarPuntos(itemsSumarRestar); 

    }

    public static void consultarTransacciones(Map<String, Object> input, Map<String, Object> outMap) {
        Map<String, Object> consultarTransac = (Map<String, Object>) input.get('datosSocio');

        String IdTitular = (String) consultarTransac.get('titularID');
        String IdSuscriptor = (String) consultarTransac.get('suscriptorID');
        Date desde = (Date) consultarTransac.get('fechaDesde');
        Date hasta = (Date) consultarTransac.get('fechaHasta');

        List<GP_Historia_transaccion__c> lista = GP_API.consultarTransacciones(IdTitular,IdSuscriptor,desde,hasta);
        outMap.put('transacciones',lista);
    }

    public static void consultarEstadoAcumulador(Map<String, Object> input, Map<String, Object> outMap) {
        Map<String, Object> consultarEstadoAcumuladorMap = (Map<String, Object>) input.get('datosSocio');
        
        String idTitular = (String) consultarEstadoAcumuladorMap.get('titularID');
        String IdSuscriptor = (String) consultarEstadoAcumuladorMap.get('suscriptorID');
        
        Map<String,Object> respuesta = new Map<String,Object>();
        respuesta = GP_API.consultarEstadoAcumulador(idTitular, IdSuscriptor);
        system.debug(respuesta);
        outMap.put('transacciones', respuesta);
    }

    public void eliminarAcumuladores(Map<String, Object> input) { 
        
        system.debug(input);
        
        List<Object> listaDeMapas = (List<Object>) input.get('datosSocio');
        
        List<String> mergeIDs = new List<String>();
        for(Object mapa: listaDeMapas){

            Map<String,Object> mapaAux = (Map<String,object>) mapa;
            String titular = (String) mapaAux.get('titularID');
            system.debug(titular);
            String suscriptor = (String) mapaAux.get('suscriptorID');
            system.debug(suscriptor);
            
            if(String.isBlank(titular)){
                    throw new GP_APIException('El campo titular es obligatorio');
            }
            
            if(suscriptor == '0' || string.isBlank(suscriptor)){
                    mergeIDs.add(titular+'0');    
            }else{
                    mergeIDs.add(suscriptor+titular);
            }

        }

        GP_API.eliminarAcumuladores(mergeIds);
    }

    public void consultarPuntos(Map<String, Object> input, Map<String, Object> outMap) {
        Map<String, Object> consultarPuntos = (Map<String, Object>) input.get('datosSocio');
        
        String idTitular = (String) consultarPuntos.get('titularID');
        String IdSuscriptor = (String) consultarPuntos.get('suscriptorID');

        Map<String, Object> saldoResult = GP_API.consultarPuntos(idTitular, IdSuscriptor);
        
        outMap.put('resultadoSaldoTotal', saldoResult);
    }

    public void transferirPuntos(Map<String, Object> input, Map<String, Object> outMap){
        Map<String, Object> datosTransferirPuntos = (Map<String, Object>) input.get('datosTransferirPuntos');

        String titularID = (String)datosTransferirPuntos.get('titularIDdesde');
        String suscriptorHaciaID = (String)datosTransferirPuntos.get('suscriptorHacia');
        String suscriptorDesdeID = (String)datosTransferirPuntos.get('suscriptorDesde');

        Double puntos = (Double)datosTransferirPuntos.get('puntos');

        GP_api.transferirPuntos(titularID, suscriptorDesdeID, suscriptorHaciaID, puntos);
    }

    public void anularCanje(Map<String, Object> input, Map<String, Object> outMap){
        Map<String, Object> datosAnularCanje = (Map<String, Object>) input.get('datosAnularCanje');
        system.debug('DATOS: ' + datosAnularCanje);

        String titularID = (String)datosAnularCanje.get('titularID');
        String suscriptorID = (String)datosAnularCanje.get('suscriptorID');
        Integer numeroDeOrden = (Integer)datosAnularCanje.get('numOrdenServicio');

        Gp_api.anularCanje(titularID, suscriptorID, numeroDeOrden);
    }
    
    public void agregarAsset(Map<String, Object> input){
        
        Map<String, Object> datosAgregarAsset = (Map<String, Object>) input.get('datosSocio');

        String titularID = (String)datosAgregarAsset.get('titularID');
        String suscriptorID = (String)datosAgregarAsset.get('suscriptorID');
        String assetID = (String)datosAgregarAsset.get('assetID');

        GP_api.agregarAsset(titularID, suscriptorID, assetID);        
    }
    
    public void eliminarAsset(Map<String, Object> input){
        List<Object> datosAssets = (List<Object>) input.get('datosAssets');

        List<String> idsAssets = new List<String>();
        for(Object aux: datosAssets){
            Map<String,Object> mapa = (Map<String,object>) aux; 
            idsAssets.add((String) mapa.get('assetID')); 
        }
        
        GP_api.eliminarAsset(idsAssets);
    }

}