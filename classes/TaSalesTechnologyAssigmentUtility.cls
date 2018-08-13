global with sharing class TaSalesTechnologyAssigmentUtility implements vlocity_cmt.VlocityOpenInterface
{
    global TaSalesTechnologyAssigmentUtility() {}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        Boolean result = true;
        try
        {
            if (methodName.equals('GetHighestPriority'))
            {
                GetHighestPriority(inputMap, outMap);
            }
            if (methodName.equals('GetPrefeasibilityResultTransform'))
            {
                GetPrefeasibilityResultTransform(inputMap, outMap, options);
            }
            if (methodName.equals('AssingTechnology'))
            {
                AssingTechnology(inputMap, outMap, options);
            }
            result = false;
            
        } 
        catch(Exception e)
        {
            System.debug('TaSalesTechnologyAssigmentUtility:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }


    //Given a list of priority elements (from Technology Assigment Matrix), 
    //this method gets the highest priority technology and access media 
    //(been 1 the highest priority)
    void GetHighestPriority(Map<String,Object> inputMap, Map<String, Object> outMap)
    {
        Map<String, Object> priorityMap, resultMap;
        Integer priority;
        Integer maxPriority = 1000;
        String maxTechnology, maxAccess;
        
        
        List<Object> priorityList = (List<Object>) inputMap.get('priorities');
                
        for (Object p : priorityList) {
            priorityMap = (Map<String, Object>) p;
            if (priorityMap != null) {
                priority = Integer.valueOf(priorityMap.get('Prioridad'));
                if (priority < maxPriority) {
                    maxPriority = priority;
                    maxTechnology = (String) priorityMap.get('TecnologiaPriorizado');
                    maxAccess = (String) priorityMap.get('AccesoPriorizado');
                }
            }
        }
        
        resultMap = new Map<String,Object>();
        resultMap.put('tecnologia', maxTechnology);
        resultMap.put('acceso', maxAccess);
        
        outMap.put('resultado', resultMap);

    }

    public void GetPrefeasibilityResultTransform(Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options){
        System.debug('GetPrefeasibilityResultTransform');
        List<Object> result = new List<Object>();
        System.debug('FilterPrefaResults');
        System.debug('input: ' + input);
        System.debug('options: ' + options);
        String categoryService = (String) options.get('CategoryService');
        String idOrder = (String) options.get('OrderId');
        Order order = [SELECT PrefeasibilityResult__c FROM Order where Id = :idOrder];
        Map<String, Object> prefa = (Map<String, Object>) JSON.deserializeUntyped(order.PrefeasibilityResult__c);
        List<Object> accesTechs = (List<Object>) prefa.get('tecnologiasAcceso');
        for (Object t : accesTechs){
            Map<string, Object> technology = (Map<string, Object>) t;
            String tecnologia = (String) technology.get('tecnologia');
            List<Object> services = (List<Object>) technology.get('servicios');
            String codigoMensaje = (String) technology.get('codigoMensaje');
            for (Object  s : services){
                String serviceType = (string)(((Map<string,Object>)s).get('servicio'));
                Map<string,object> service = (Map<string,Object>) s;
                List<object> technicalStandards = (List<object>) service.get('standardsTecnico');
                for(Object ts : technicalStandards){
                    Map<string,Object> techStandard = (Map<string,Object>) ts;
                    String disponibilidad = (string) techStandard.get('disponibilidad');
                    
                    if(disponibilidad == 'F'){
                        disponibilidad = TaMatrixUtils.checkPrefa(codigoMensaje, tecnologia, serviceType);
                    }
                    
                    if(serviceType == categoryService && disponibilidad == 'SI'){
                        Map<String, String> node = new Map<String, String>();
                        node.put('Tecnologia', String.valueof(techStandard.get('standardTecnico')));
                        String standardTecnico = String.valueof(techStandard.get('standardTecnico'));
                        if(serviceType == 'Internet'){
                            node.put('Categoria', 'Internet + Voz');
                        }else{
                            node.put('Categoria', serviceType);
                        }
                        node.put('Acceso', tecnologia);
                        result.add(node);
                    }
                }
            }
        }
        outMap.put('Result', result);
    }

    void AssingTechnology(Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options){
      System.debug('AssingTechnology');
      String idOrder = (String) options.get('OrderId');
      System.debug('idOrder: ' + idOrder);
      System.debug('input: ' + input);
      Map<String, Object> getHighestPriority = (Map<String, Object>) input.get('GetHighestPriority');
      Map<String, Object> resultado = (Map<String, Object>) getHighestPriority.get('resultado');
      String tecnologiaMatrix = (String) resultado.get('tecnologia');
      String accesoMatrix = (String) resultado.get('acceso');
      System.debug('tecnologiaMatrix: ' + tecnologiaMatrix);
      System.debug('accesoMatrix: ' + accesoMatrix);
      List<OrderItem> items = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem where OrderId = :idOrder and Product2.ProductCode = 'MODEMWIFI'];
      for(OrderItem item : items)
      {
        Map<String, Object> mapa = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__JSONAttribute__c);
        System.debug('mapa: ' + mapa);
        List<Object> lineaBasicaL = (List<Object>) mapa.get('TA Linea Basica');
        Map<String, Object> lineaBasica = (Map<String, Object>) lineaBasicaL[0];
        lineaBasica.put('value__c',tecnologiaMatrix);
        item.vlocity_cmt__JSONAttribute__c = JSON.serialize(mapa);
      }
      System.debug('Update Modem');
      update items;
      //BAF
      items = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem where OrderId = :idOrder and Product2.Family = 'Internet'];
      for(OrderItem item : items)
      {
        Map<String, Object> mapa = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__JSONAttribute__c);
        System.debug('mapa: ' + mapa);
        List<Object> lineaBasicaL = (List<Object>) mapa.get('TA Linea Basica');
        Map<String, Object> lineaBasica = (Map<String, Object>) lineaBasicaL[0];
        lineaBasica.put('value__c',tecnologiaMatrix);
        lineaBasica = (Map<String, Object>) lineaBasicaL[1];
        lineaBasica.put('value__c',accesoMatrix);
        item.vlocity_cmt__JSONAttribute__c = JSON.serialize(mapa);
      }
      System.debug('Update Internet');
      update items;
      //Linea fija
      items = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem where OrderId = :idOrder and Product2.Family = 'Fixed'];
      if (items.size() > 0)
      {
        String accessFixedLine;
        Order order = [SELECT PrefeasibilityResult__c FROM Order where Id = :idOrder];
        Boolean noEncontrado = true;
        Map<String, Object> prefa = (Map<String, Object>) JSON.deserializeUntyped(order.PrefeasibilityResult__c);
        List<Object> accesTechs = (List<Object>) prefa.get('tecnologiasAcceso');
        Integer tecnologiasAccesoCont = 0;
        while(noEncontrado && tecnologiasAccesoCont < accesTechs.size())
        {
            Map<string, Object> technology = (Map<string, Object>) accesTechs[tecnologiasAccesoCont];
            String tecnologia = (String) technology.get('tecnologia');
            System.debug('tecnologia:' + tecnologia);
            if (tecnologia == accesoMatrix)
            {
                List<Object> services = (List<Object>) technology.get('servicios');
                Integer servicesCont = 0;
                while(noEncontrado && tecnologiasAccesoCont < accesTechs.size() && servicesCont < services.size())
                {
                    Map<string,object> service = (Map<string,Object>) services[servicesCont];
                    String serviceType = (string)(((Map<string,Object>)service).get('servicio'));
                    System.debug('serviceType:' + serviceType);
                    if (serviceType == 'Voz')
                    {
                        List<object> technicalStandards = (List<object>) service.get('standardsTecnico');
                        while(noEncontrado && tecnologiasAccesoCont < accesTechs.size() && servicesCont < services.size())
                        {
                            Map<string,Object> techStandard = (Map<string,Object>) technicalStandards[0];
                            accessFixedLine = (String) techStandard.get('standardTecnico');
                            noEncontrado = false;
                        }
                    }
                    servicesCont++;
                }
            }
            tecnologiasAccesoCont++;
        }
        System.debug('accessFixedLine: ' + accessFixedLine);

        for(OrderItem item : items)
        {
            Map<String, Object> mapa = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__JSONAttribute__c);
            System.debug('mapa: ' + mapa);
            List<Object> lineaBasicaL = (List<Object>) mapa.get('TA Linea Basica');
            Map<String, Object> lineaBasica = (Map<String, Object>) lineaBasicaL[13];
            lineaBasica.put('value__c',accessFixedLine);
            lineaBasica = (Map<String, Object>) lineaBasicaL[14];
            lineaBasica.put('value__c',accesoMatrix);
            item.vlocity_cmt__JSONAttribute__c = JSON.serialize(mapa);
        }
        System.debug('Update Fija');
        update items;
      }
    }

}