global with sharing class ta_techCare_subscriptions implements vlocity_cmt.VlocityOpenInterface{

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        system.debug('ta_techCare_subscriptions-invokeMethod');
        try{
            if(methodName.equals('GetFilteredSubscriptions')) GetFilteredSubscriptions(input, outMap, options);
            else if(methodName.equals('UnsubscribeFromServices')) UnsubscribeFromServices(input, outMap, options);
            else if(methodName.equals('GetDaysAutoRemoveBlacklist')) GetDaysAutoRemoveBlacklist(input, outMap, options);
            else if(methodName.equals('getHistoryBlacklist')) getHistoryBlacklist(input, outMap, options);
            
        } catch(Exception ex){
            options.put('error', ex.getMessage());
            outMap.put('error', ex.getMessage());
        }
        return true;
    }

    private void GetDaysAutoRemoveBlacklist(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
       try{
            AutoRemoveBlacklistDays__c custSett = AutoRemoveBlacklistDays__c.getInstance();

            outMap.put('DaysAutoRemove', custSett.Days__c);
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener días para baja automática de Blacklist: ' + ex.getMessage());
        }
    }

    private void GetFilteredSubscriptions(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        
        try{
            
            system.debug('GetFilteredSubscriptions........................');
            
            string subscriptionsList = (String) options.get('subscriptionsList');
            subscriptionsList = subscriptionsList.replace('[', '');
            subscriptionsList = subscriptionsList.replace(']', '');
            
            Set<String> selectedSubscriptions = New Set<String>();
            selectedSubscriptions.addAll(subscriptionsList.split(','));
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('nroLinea', (String) options.get('msisdn'));
            params.put('codProveedor', '-1');
            params.put('marca', 0);

            Map<String, Object> input = new Map<String, Object>();
            input.put('params', params);

            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options2 = new Map<String, Object>();

            vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
            integProcService.invokeMethod('IFS_S087', input, output, options2);
            //Map<String,Object> response =  ErrorHandler.process('IFS_S087', input, output);  

            Map<String, Object> s087_response;
            if(Test.isRunningTest())
                s087_response = (Map<String, Object>) JSON.deserializeUntyped('{"Suscripciones":[{"DatosServicioSuscrip":{"ListadoNrosCortos":[{"numeroCortoSVA":"2524"}],"codServicio":"002","descripcionCortaServicio":"RingTone 222","nombreServicio":"RingTone 111","descripcionServicio":"RingTone 222","estadoServicio":"1","codProveedor":"515","cargoUso":"100.2500","tipoContratacion":"PACK","cantUnidadesProdAdquiridas":"24"},"fechaAltaSuscripcion":"2017-09-25 10:10:10","fechaDesactivacionSuscripcion":"2017-12-31 10:10:10","palabraClaveSVA":"SIEBEL","CanalAlta":{"codCanal":"WEB","descripcionCanal":"WEB"},"codEstadoSuscripcion":"1","CanalBaja":{"codCanal":"","descripcionCanal":""},"fechaVigenciaHastaProdAdq":"2017-12-30 11:11:11","cantUnidadesProdRemanentes":"11"},{"DatosServicioSuscrip":{"ListadoNrosCortos":[{"numeroCortoSVA":"2527"}],"codServicio":"003","descripcionCortaServicio":"Ring back tone","nombreServicio":"Ring back tone","descripcionServicio":"Ring back tone","estadoServicio":"0","codProveedor":"Proveedor","cargoUso":"81.45","tipoContratacion":"SUSCRIPCION","cantUnidadesProdAdquiridas":"21"},"fechaAltaSuscripcion":"2017-05-25 10:10:10","fechaDesactivacionSuscripcion":"2017-12-31 10:10:10","palabraClaveSVA":"SVA03","CanalAlta":{"codCanal":"IVR","descripcionCanal":"IVR"},"codEstadoSuscripcion":"0","CanalBaja":{"codCanal":"","descripcionCanal":""},"fechaVigenciaHastaProdAdq":"2017-12-30 11:11:11","cantUnidadesProdRemanentes":"10"}]}');
            else
                s087_response = (Map<String, Object>) output.get('IPResult');
            
            List<Object> subscriptions = new List<Object>();
            try{
                subscriptions = (List<Object>) s087_response.get('Suscripciones');
            } catch(Exception ex){
                throw new FuncException('Error al recuperar las suscripciones activas de la línea');
            }
            
            List<Object> filteredSubscriptions = new List<Object>();
            Map<String, Object> subscription, subscriptionServiceData;

            if (subscriptions.size() > 0)
            {
                for(Object subscriptionObj : subscriptions)
                {
                    subscription = (Map<String, Object>) subscriptionObj;
                    subscriptionServiceData = (Map<String, Object>) subscription.get('DatosServicioSuscrip');

                    if(selectedSubscriptions.contains((string)subscriptionServiceData.get('codServicio')))
                    {
                        filteredSubscriptions.add(subscription);
                    }
                }
            }
            else
                throw new FuncException('No existen suscripciones activas para la línea en cuestión');
            
            outMap.put('Suscripciones', filteredSubscriptions);
            
        } catch(Exception ex){

             // dependendiendo de la necesidad de la logica de negocio del servicio se debera validar si es necesario hacer un reintento o propagar la exception hasta las UI
            /*
               if(ex instanceof CommunicationException){
                   // execute communication error strategy
                   system.debug('ERROR-CommunicationException: '+ex.getMessage());
                   
               }

               if(ex instanceof DataErrorException){
                   // execute data error strategy
                   system.debug('ERROR-DataErrorException: '+ex.getMessage());
               }

               if(ex instanceof SecurityException){
                   // execute security error strategy
                   system.debug('ERROR-SecurityException: '+ex.getMessage());
               }

               if(ex instanceof DataValidationException){
                   // execute data validation error strategy
                   system.debug('ERROR-DataValidationException: '+ex.getMessage());
               }

               if(ex instanceof TechnicalException){
                   // execute technical error strategy
                   system.debug('ERROR-TechnicalException: '+ex.getMessage());
               }

               if(ex instanceof BusinessValidationException){
                   // execute business validation error strategy
                   system.debug('ERROR-BusinessValidationException: '+ex.getMessage());
               }

               if(ex instanceof UndefinedException){
                   // execute undefined error strategy
                   system.debug('ERROR-UndefinedException: '+ex.getMessage());
               }
            */
            throw new FuncException('Error inesperado al filtrar las suscripciones activas: ' + ex.getMessage());
          
        }
    }

    private void UnsubscribeFromServices(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            
            
                        List<Object> subscriptions = (List<Object>) options.get('filteredSubscriptions');
             
            
             
             
            if (subscriptions.size() > 0)
            {
                Map<String, Object> params = new Map<String, Object>();
                Map<String, Object> input = new Map<String, Object>();
                Map<String, Object> output = new Map<String, Object>();
                Map<String, Object> options2 = new Map<String, Object>();
                Map<String, Object> subscription, subscriptionServiceData, shortCode, suscribeChannelInfo,
                                    debt, serviceProviderData, serData, wrongUnsubscription,
                                    s113_response, s088_response, s350_response;
                                
                params.put('nroLinea', (String) options.get('msisdn'));
                input.put('params', params);

                List<Object> shortCodesList;
                List<Object> debtsList = new List<Object>();
                vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
                Transaction_History__c unsubscriptionEntry;
                String codSuscripcion, codProveedor, palabraClaveSVA, serCode;
                String motive = (String) options.get('motive');
                String caseId = (String) options.get('caseId');
                String needAdjustment = (String) options.get('needAdjustment');
                Boolean addToBlacklist = Boolean.valueof(options.get('addToBlacklist'));
                String codCanal = 'VENTAS'; //REVISAR

                if(motive == 'Desconocimiento')
                {
                    System.debug('IFS_S113 input: ' + JSON.serialize(input));
                    integProcService.invokeMethod('IFS_S113', input, output, options2);
                    System.debug('IFS_S113 output: ' + JSON.serialize(output));

                    if(Test.isRunningTest())
                        s113_response = (Map<String, Object>) JSON.deserializeUntyped('{"ListadoDeudas":[{"codInteraccionNegocio":"180511125854516414","identificadorRecurso":"1122334455","CodigoSER":{"codServicio":"5080061550118V7"},"codServicio":"15501","descripcionServicio":"Info textSIM 2020","codProveedor":"508","fechaDesde":"2018-05-11 12:28:59","fechaHasta":"2018-06-11 12:28:59","importeND":"7.8300","CodServicioProv":{"codServicio":"002"}},{"codInteraccionNegocio":"180511125854516414","identificadorRecurso":"1122334455","CodigoSER":{"codServicio":"19084961423402F1"},"codServicio":"61423","descripcionServicio":"Info textSIM 2020","codProveedor":"190","fechaDesde":"2018-05-11 12:28:59","fechaHasta":"2018-06-11 12:28:59","importeND":"7.8300","CodServicioProv":{"codServicio":"003"}}]}');
                    else
                        s113_response = (Map<String, Object>) output.get('IPResult');

                    try{
                        if (s113_response.get('ListadoDeudas') != null)
                            debtsList = (List<Object>) s113_response.get('ListadoDeudas');
                    }catch(Exception ex){
                        debtsList = new List<Object>();
                    }
                }

                List<Transaction_History__c> unsubscriptionsToInsert = new List<Transaction_History__c>();
                List<Object> wrongUnsubscriptions = new List<Object>();

                for(Object subscriptionObj : subscriptions)
                {
                    subscription = (Map<String, Object>) subscriptionObj;
                    subscriptionServiceData = (Map<String, Object>) subscription.get('DatosServicioSuscrip');
                    shortCodesList = (List<Object>) subscriptionServiceData.get('ListadoNrosCortos');
                    shortCode = (Map<String, Object>) shortCodesList.get(0);
                    suscribeChannelInfo = (Map<String, Object>) subscription.get('CanalAlta');

                    codSuscripcion = (String) subscriptionServiceData.get('codServicio');
                    codProveedor = (String) subscriptionServiceData.get('codProveedor');
                    palabraClaveSVA = (String) subscription.get('palabraClaveSVA');
                    
                    params = new Map<String, Object>();
                    params.put('codInteraccionNegocio', caseId);
                    params.put('codSuscripcion', codSuscripcion);
                    params.put('codProveedor', codProveedor);
                    params.put('numeroCortoSVA', (String) shortCode.get('numeroCortoSVA'));
                    params.put('palabraClaveSVA', palabraClaveSVA);
                    params.put('motivoBaja', motive);
                    params.put('codCanal', codCanal);
                    
                    input.put('body', params);
                    output = new Map<String, Object>();
                    options2 = new Map<String, Object>();
                    System.debug('IFS_S088 input: ' + JSON.serialize(input));
                    integProcService.invokeMethod('IFS_S088', input, output, options2);
                    System.debug('IFS_S088 output: ' + JSON.serialize(output));

                    if(Test.isRunningTest())
                        s088_response = (Map<String, Object>) JSON.deserializeUntyped('{"codInteraccionNegocio":"REALIZADO"}');
                    else
                        s088_response = (Map<String, Object>) output.get('IPResult');
                    
                    if(String.isNotBlank((String)s088_response.get('codInteraccionNegocio')))
                    {
                        if(motive == 'Desconocimiento' && debtsList.size() > 0)
                        {
                            params = new Map<String, Object>();
                            params.put('codServicioProv', codSuscripcion);

                            
                            for(Object debtObj : debtsList)
                            {
                                debt = (Map<String, Object>) debtObj;
                                serviceProviderData = (Map<String, Object>) debt.get('CodServicioProv');
                                serData = (Map<String, Object>) debt.get('CodigoSER');
                                
                                if((String)serviceProviderData.get('codServicio') == codSuscripcion)
                                {
                                    serCode = ((String)serData.get('codServicio')).trim();
                                    params.put('codProveedor', serCode.substring(0, 3));
                                    params.put('codFamiliaServicio', serCode.substring(3, 6));
                                    params.put('codServicio', serCode.substring(6, 11));
                                    params.put('codEvento', serCode.substring(11));
                                    break;
                                }
                            }
                            
                            
                            input.put('body', params);
                            output = new Map<String, Object>();
                            options2 = new Map<String, Object>();
                            System.debug('IFS_S350 input: ' + JSON.serialize(input));
                            integProcService.invokeMethod('IFS_S350', input, output, options2);
                            System.debug('IFS_S350 output: ' + JSON.serialize(output));

                            if(Test.isRunningTest())
                                s350_response = (Map<String, Object>) JSON.deserializeUntyped('{"respuesta":true}');
                            else
                                s350_response = (Map<String, Object>) output.get('IPResult');
                        }
                        
                        unsubscriptionEntry = new Transaction_History__c();
                        unsubscriptionEntry.RecordTypeID = Schema.SObjectType.Transaction_History__c.getRecordTypeInfosByName().get('Subscription History').getRecordTypeId();
                        unsubscriptionEntry.Adjustment__c = Boolean.valueOf(needAdjustment);
                        unsubscriptionEntry.Subscribe_Channel__c = (String) suscribeChannelInfo.get('codCanal');
                        unsubscriptionEntry.Unsubscribe_Channel__c = codCanal; //REVISAR!
                        unsubscriptionEntry.Case__c = caseId;
                        unsubscriptionEntry.Service_Code__c = codSuscripcion;
                        unsubscriptionEntry.Description__c = (String) subscriptionServiceData.get('descripcionServicio');
                        unsubscriptionEntry.Subscribe_Date__c = Datetime.valueOf((String)subscription.get('fechaAltaSuscripcion'));
                        unsubscriptionEntry.Blacklisted__c = addToBlacklist;
                        unsubscriptionEntry.Unsubscribe_Reason__c = motive;
                        unsubscriptionEntry.Keyword__c = palabraClaveSVA;
                        unsubscriptionEntry.Vendor__c = codProveedor;
                        
                        unsubscriptionsToInsert.add(unsubscriptionEntry);
                    }
                    else
                    {
                        wrongUnsubscription = new Map<String, Object>();

                        wrongUnsubscription.put('codSuscripcion', codSuscripcion);
                        wrongUnsubscription.put('codProveedor', codProveedor);
                        wrongUnsubscription.put('descripcionCortaServicio', (String) subscriptionServiceData.get('descripcionCortaServicio'));

                        wrongUnsubscriptions.add(wrongUnsubscription);
                    }
                }
                insert unsubscriptionsToInsert;
                
                if(wrongUnsubscriptions.size() > 0)
                    outMap.put('WrongUnsubscriptions', wrongUnsubscriptions);
            }
            
        } catch(Exception ex){
            throw new FuncException('Error inesperado al desuscribirse de los servicios: ' + ex.getMessage());
        }
    }

  private void getHistoryBlacklist ( Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){

        String assetId =  (String) inputMap.get('AssetId');
        Set<String> fieldFilter = new Set<String>();
        fieldFilter.add('Blacklist__c');
        fieldFilter.add('Blacklist_Remove_Date__c');

        DateTime nowDateTime = system.now();
        DateTime oldDateTime = nowDateTime.addMonths(-12);

        List<AssetHistory> listAssetHistory = [SELECT CreatedDate, CreatedById, Field, OldValue, NewValue FROM AssetHistory WHERE AssetId = :assetId And  Field IN :fieldFilter And CreatedDate >= :oldDateTime ORDER BY CreatedDate DESC];
        
        Set<Id> idUsuario = new Set<Id>();
        for(AssetHistory userH: listAssetHistory ){
                idUsuario.add(Id.valueOf(userH.CreatedById));
        }

        Map<Id,String> mapUser = new Map<Id,String>();
        List<User> getUsers = [SELECT Id, name FROM User WHERE Id IN :idUsuario];

        for(User getUser: getUsers ){
                mapUser.put(getUser.Id, getUser.name);
        }

            Datetime dateVerify;
            List<map<String,Object>> listMapAssetHistoryBlackList = new List<map<String,Object>>();
            map<String,String> mapAssetHistoryBlack = new map<String,String>();

            for(AssetHistory getAsset: listAssetHistory ){

                    dateVerify =  getAsset.CreatedDate;
                    String fielAsset = (String) getAsset.Field;
                 
                    mapAssetHistoryBlack = new map<String,String>();
                    mapAssetHistoryBlack.put('createdDate', dateVerify.format('yyyy-MM-dd HH:mm:ss'));
                    mapAssetHistoryBlack.put('createdById', mapUser.get(getAsset.CreatedById));


                    if(fielAsset.equals('Blacklist__c')){
                        if(Boolean.valueOf(getAsset.NewValue)){
                            mapAssetHistoryBlack.put('addBlackList' , 'Ingreso en Blacklist');
                        }else{
                            mapAssetHistoryBlack.put('addBlackList' , 'Egreso de Blacklist');
                        }
                        listMapAssetHistoryBlackList.add(mapAssetHistoryBlack);
                    }
                    
            } 
            outMap.put('resultGetAssetHistoryBlacklist', listMapAssetHistoryBlackList );
    }
}