public class KAL_datosEntradaController{

    @AuraEnabled
    public static Order getOrdenActualUsuario(){
       try{
            String uId = UserInfo.getUserId();
            Order ordenUsuario = KAL_utils.obtenerOrdenActualDelUsuario(uId);        
            return ordenUsuario;
        } catch(Exception ex) {
            throw new KAL_Exception(ex.getMessage());
        }
    }

    @AuraEnabled
    public static void updateDatosAutorizado(String param, String email, String telefono, String direccionNumeradaI, String provinciaI, String cityI, String codPostalI, Boolean checkboxDomicilio)
    {    
        try{
            Order orden =  KAL_datosEntradaController.getOrdenActualUsuario();
            //system.debug(ordenn);
            if(!String.isBlank(param)) {
                orden.vlocity_cmt__ShippingName__c = param;
            }
            if(!String.isBlank(email)) {
                orden.ShippingEmailContact__c = email;
            }
            
            //Aregado KAL-67
            if(!String.isBlank(telefono)) {
                //Guardado en campo Shipping Home Phone
                orden.ShippingHomePhone__c = telefono;
            }

            if(!String.isBlank(direccionNumeradaI)) {
                //Guardado en campo ShippingStreet
                orden.ShippingStreet = direccionNumeradaI;
            }

            if(!String.isBlank(cityI)) {
                //Guardado en campo vlocity_cmt__ShippingState__c el cual es tipo fórmula y se usa ShippingState
                //Es una picklist entonces el valor a setear en el campo tiene que sear idéntico al value de una opción de la picklist
                orden.ShippingState = cityI;
            }

            if(!String.isBlank(provinciaI)) {
                //Guardado en campo ShippingCity
                orden.ShippingCity = provinciaI;
            }

            if(!String.isBlank(codPostalI)) {
                //Guardado en campo vlocity_cmt__ShippingPostalCode__c el cual es tipo fórmula y se usa ShippingPostalCode
                orden.ShippingPostalCode = codPostalI;
            }
            
                //Guardado en campo Shipping Home Phone
                //Boolean checkBool = Boolean.ValueOf(checkboxDomicilio);
                
                if(checkboxDomicilio == true){
                    orden.Delivery_Method__c = 'Delivery';
                }else{
                    orden.Delivery_Method__c = 'Store Pick Up';
                }
            
            //Agregado KAL-67
            
            update orden;            
        } catch(Exception ex) {
            throw new KAL_Exception(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<Object> getDocumentTypes(){
       List<PicklistEntry> entries = SObjectType.contact.fields.DocumentType__c.getSObjectField().getDescribe().getPicklistValues();
       List<Object> tipoDocumento = new List<Object>();
       Map<String,Object> opcion = new Map<String,Object>();

       for(PicklistEntry dT :entries)
       {
           if(dT.isActive()){
            opcion =  new Map<String,Object>();
            
            opcion.put('label', dT.getLabel());
            opcion.put('value', dT.getValue());
            tipoDocumento.add(opcion);
           }
       }
       return tipoDocumento;        
    }

     @AuraEnabled
    public static Map<String,String> getUserComunidad() {
        
        Map<String,String> datosUsuarioComu = new Map<String,String>();
        
        String uId = UserInfo.getUserId();
        User usuarioComu = [Select Id, Name, AccountId, ContactId From User Where Id =: uId];
        Contact contactoDelUsuario = [Select Id, Email, MobilePhone, Phone From Contact Where Id =: usuarioComu.ContactId];
        String accId = usuarioComu.AccountId; 
        Account cuentaUsuario = [Select BillingStreet, BillingState, BillingCity, BillingPostalCode From Account Where Id =: accId];
        String laStreet = cuentaUsuario.BillingStreet;
        List<String> streetList = laStreet.split(' ');
        Integer tam = streetList.size();
        Integer i = 0;
        String calle = '';
        while(i < tam-1){
            calle = calle + ' ' + streetList[i];
            i++;
        }        String numero = streetList[tam-1];
        datosUsuarioComu.put('Calle', calle);
        datosUsuarioComu.put('Numero',numero);
        datosUsuarioComu.put('Provincia',cuentaUsuario.BillingCity);
        datosUsuarioComu.put('Localidad',cuentaUsuario.BillingState);
        datosUsuarioComu.put('CodigoPostal', cuentaUsuario.BillingPostalCode);
        if(contactoDelUsuario.MobilePhone!=null){
            datosUsuarioComu.put('MobilePhone', contactoDelUsuario.MobilePhone);    
        } else if(contactoDelUsuario.Phone!=null){
            datosUsuarioComu.put('MobilePhone', contactoDelUsuario.Phone);    
        }                
        datosUsuarioComu.put('Email', contactoDelUsuario.Email);
        return datosUsuarioComu;      
    }

    @AuraEnabled
    public static void agregarProductoEnvio() {
        String uId = UserInfo.getUserId();

        Order orden = KAL_utils.obtenerOrdenActualDelUsuario(uId);

        List<String> listaIds = new List<String>();

        List<PriceBookEntry> ListPBE = [
            Select 
                id, pricebook2Id, PRICEBOOK2.NAME, PRODUCT2.NAME 
            From PriceBookEntry 
            Where productcode = 'FAN_ENV_001' 
            AND PRICEBOOK2.NAME = 'TA Price book'
            Limit 1
        ];
        if(ListPBE.size() > 0) {
            // Agrego el producto a la orden
            for(PriceBookEntry PBE : ListPBE){
                String pbeId = PBE.pricebook2Id;
                listaIds.add(pbeId);
            }
            if(listaIds.size() > 0) {
                KAL_utils.agregarProductosAOrden(orden.Id, listaIds);
            }
        }

    }


    @AuraEnabled
    public static Map<String,Object> GetTaxes(String delivery){

        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options= new Map<String, Object>();
        Map<String,Object> response= new Map<String, Object>();
        Order currentOrder = null;
        Id orderId=null;        
        
        try{
            currentOrder = getOrdenActualUsuario();
            orderId= currentOrder.Id;
            options.put('OrderId', orderId);
            inputMap.put('delivery', delivery);            
            response = KAL_integrationGetTaxes.GetCalculatedTaxes(inputMap, options);
        }catch (Exception ex){
            System.debug('KAL_datosEntradaController:GetTaxes -> exception: '+ex);
            throw ex;    
        }
                
        if(!Test.isRunningTest()){
            Map<String, Object> calculoImpuestosRespuesta = (Map<String, Object>)response.get('calculoImpuestosRespuesta');
            if(response == null || calculoImpuestosRespuesta == null){
                throw new FuncException('Respuesta incorrecta en el servicio S013');            
            }
            currentOrder.BillSimulationDate__c = System.now();
            currentOrder.BillSimulationPayload__c = JSON.serialize(response);
            update currentOrder;    
        }        
        
        return response;      
    }

    @AuraEnabled
    public static Map<String, Object> getPlazosEntrega(){

        try{
            List<vlocity_cmt__CalculationMatrix__c> matriz = [
                Select Id, Name
                From vlocity_cmt__CalculationMatrix__c
                Where Name = 'ShippingTimeConfiguration'
            ];

            Integer versionCount = [
                Select Count()
                From vlocity_cmt__CalculationMatrixVersion__c
                Where vlocity_cmt__CalculationMatrixId__c = :matriz[0].Id
            ];
            String version = matriz[0].Name + ' v' + versionCount;
                
            List<vlocity_cmt__CalculationMatrixVersion__c> matrixVersion = [SELECT id, name
                                                        FROM vlocity_cmt__CalculationMatrixVersion__c
                                                        where name = :version
                                                        limit 1];
            List<vlocity_cmt__CalculationMatrixRow__c> rowsTotales = [select id, vlocity_cmt__InputData__c,
                                                        vlocity_cmt__OutputData__c
                                                        from vlocity_cmt__CalculationMatrixRow__c
                                                        where vlocity_cmt__CalculationMatrixVersionId__c =: matrixVersion[0].id];
                    
            Map<String, Object> result = new  Map<String, Object>(); 
            Map<String, Object> standar = new  Map<String, Object>();
            List<Object> listaDeMapas = new List<Object>();
        
            for(vlocity_cmt__CalculationMatrixRow__c row : rowsTotales){
                standar = new  Map<String, Object>();

                Map<String,Object> inputData;
                Map<String,Object> outputData;
                if(!String.isBlank(row.vlocity_cmt__InputData__c)){
                    inputData = (Map<String,Object>) JSON.deserializeUntyped(row.vlocity_cmt__InputData__c);                
                }
                if(!String.isBlank(row.vlocity_cmt__OutputData__c)){
                    outputData = (Map<String,Object>) JSON.deserializeUntyped(row.vlocity_cmt__OutputData__c);                    
                }

                Boolean shipping = inputData.containsKey('ShippingMode');
                if(shipping == true){
                    standar.put('in', inputData);
                    standar.put('out', outputData);
                }
                listaDeMapas.add(standar);            
            }        

            result.put('matrizEnvio', listaDeMapas);
            return result;
        } catch (Exception ex) {
            System.debug(ex.getLineNumber() + '--' + ex.getMessage());
            return new Map<String,Object>();
        }      
    }

    // Historia 132
    @AuraEnabled
    public static List<String> APEXconseguirDominios() {
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        String methodName = 'getEmails';

        taEmails claseDeEmailsTA = new taEmails();
        claseDeEmailsTA.invokeMethod(
            methodName, input, output, options
        );

        List<String> listaDominios = new List<String>();
        List<Map<String, Object>> listaDominiosMails = new List<Map<String, Object>>();

        listaDominiosMails = (List<Map<String, Object>>) output.get('Emails');
        for(Map<String, Object> mapa : listaDominiosMails) {
            String dominio = (String) mapa.get('mail');
            listaDominios.add(dominio);
        }

        return listaDominios;
    }
    
}