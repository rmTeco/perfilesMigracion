global with sharing class taIdentityValidationHandler implements vlocity_cmt.VlocityOpenInterface {
    private static final String orgId = UserInfo.getOrganizationId();
    private static final List<String> iconsValidationRadios = new List<String>{'attach_png', 'dialogPNG', 'sms_png'};
    
    global taIdentityValidationHandler() {}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try {
            if (methodName.equals('getQuestions')) {
                getQuestions(inputMap, outMap, options);
            }

            if (methodName.equals('verifyAnswers')) {
                verifyAnswers(inputMap, outMap, options);
            }

            if (methodName.equals('getValidationOptions')) {
                getValidationOptions(inputMap, outMap);
            }

            if (methodName.equals('getValidationOptionsForValidatedContact')) {
                getValidationOptionsForValidatedContact(inputMap, outMap);
            }

            if (methodName.equals('getNominationValidationOptions')) {
                getNominationValidationOptions(inputMap, outMap, options);
            }

            if (methodName.equals('getRetriesNumber')) {
                getRetriesNumber(inputMap, outMap);
            }

            if(methodName.equals('getValidationOptionsPas')) {
                getValidationOptionsPas(inputMap, outMap);
            }

            result = false;
        }
        catch (Exception e) {
            System.debug('taIdentityValidationHandler:invokeMethod -> exception: ' + e);
            throw e;
        }

        return result;
    }
    
    public static void getQuestions(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        try
        {
            Contact contact = [SELECT Id, DocumentNumber__c, DocumentType__c, Gender__c, FirstName, LastName FROM Contact WHERE Id = :String.valueOf(options.get('contactId'))];

            //IFS_S498 - INI
            Map<String, Object> body = new Map<String, Object>();
            body.put('numeroDocumento', contact.DocumentNumber__c);
            body.put('genero', IntegrationUtils.ParseGender(contact.Gender__c));
            body.put('codCuestionario', '7372');

            Map<String, Object> inputS498 = new Map<String, Object>();
            inputS498.put('body', body);
            Map<String, Object> outputS498 = new Map<String, Object>();
            Map<String, Object> optionsS498 = new Map<String, Object>();
            Map<String, Object> ipResult = new Map<String, Object>();

            if(Test.isRunningTest())
            {
                ipResult = (Map<String, Object>) options.get('IPResult');
            }
            else
            {
                vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
                integProcService.invokeMethod('IFS_S498', inputS498, outputS498, optionsS498);
                ipResult = (Map<String, Object>) outputS498.get('IPResult');
            }
            //IFS_S498 - FIN

            if(!ipResult.containsKey('codigo'))
            {
                //COMPARACION NOMBRE - INI
                String nombreCRM = contact.LastName + ', ' + contact.FirstName;
                String nombreEquifax = (String) ipResult.get('nombreActor');

                Decimal nameComparisonPercentage = CompareName(nombreCRM, nombreEquifax);
                List<NameComparisonPercentage__c> paramComparisonPercentageList = [SELECT Percentage__c FROM NameComparisonPercentage__c];
                Decimal paramComparisonPercentage = paramComparisonPercentageList[0].Percentage__c;
                Boolean nameComparisonResult = false;
                if (nameComparisonPercentage > paramComparisonPercentage)
                    nameComparisonResult = true;
                ipResult.put('nameComparisonResult', nameComparisonResult);
                //COMPARACION NOMBRE - FIN

                ipResult.put('descripcionIntervaloTiempo', 5);

                outMap.put('data', ipResult);
            }
            else
            {
                outMap.put('data', ipResult);
            }
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    public static void verifyAnswers(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        try
        {
           Map<String,Object> data = (Map<String,Object>) inputMap.get('data');

            String ticket = (String) data.get('ticket');
            String codCuestionario = (String) data.get('codCuestionario');

            List<Object> listaPreguntas = (List<Object>) data.get('listaPreguntas');
            List<Object> listaRespuestas = new List<Object>();
            Map<String, Object> body = new Map<String, Object>();
            for(Object pregunta : listaPreguntas)
            {
                Map<String, Object> respuesta = new Map<String,Object>();
                Map<String, Object> respuestaAux = new Map<String, Object>();
                Map<String, Object> preguntaMap = (Map<String, Object>) pregunta;
                String codConsulta = (String) preguntaMap.get('codConsulta');
                String codRespuesta = (String) preguntaMap.get('codRespuesta');
                respuestaAux.put('codConsulta', codConsulta);
                respuestaAux.put('codRespuesta', codRespuesta);
                respuesta.put('respuesta', respuestaAux);

                listaRespuestas.add((Object) respuesta);
            }

            
            body.put('ticket', ticket);
            body.put('codCuestionario', codCuestionario);
            body.put('listaRespuestas', listaRespuestas);
            Map<String, Object> inputMapS499 = new Map<String, Object>();
            inputMapS499.put('body', body);
            system.debug('request s499: '+ JSON.serialize(body));
            Map<String, Object> outputMapS499 = new Map<String, Object>();
            Map<String, Object> optionsS499 = new Map<String, Object>();

            if(Test.isRunningTest())
            {
                outMap.put('ValidationResult', options.get('outputMapS499'));
            }
            else
            {
                vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
                integProcService.invokeMethod('IFS_S499', inputMapS499, outputMapS499, optionsS499);
                outMap.put('ValidationResult', (Map<String, Object>) outputMapS499.get('IPResult'));
                system.debug('response s499: '+ JSON.serialize(outputMapS499));
            }            
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    public static Decimal CompareName(String nameA, String nameB)
    {
        System.debug('CompareName');
        try
        {
            nameA = nameA.toUpperCase();
            nameB = nameB.toUpperCase();
            List<String> namesList1 = nameA.split(' ');
            List<String> namesList2 = nameB.split(' ');
            Integer maxSize = Math.max(namesList1.size(),namesList2.size());
            Decimal percentage = 0;
            for (Integer i = 0; i < maxSize ; i++)
            {
                Decimal rowCount = 0;
                if(i < namesList1.size())
                {
                    for (Integer j = 0; j < maxSize ; j++)
                    {
                        if(j < namesList2.size())
                        {
                            rowCount = Math.max(rowCount,CompareStrings(namesList1[i], namesList2[j]));
                        }
                    }
                }
                percentage += rowCount;
            }
            if (percentage > 0)
                percentage = percentage / maxSize;
            
            System.debug('CompareName percentage: ' + percentage);
            return percentage;
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    private static Decimal CompareStrings(String input1, String input2)
    {
        System.debug('CompareStrings');
        try
        {
            Integer distancia = input1.getLevenshteinDistance(input2);
            System.debug('distancia: ' + distancia);
            Integer maxSize = Math.max(input1.length(),input2.length());
            Integer cercania = maxSize - distancia;
            Decimal porcentual = Math.abs((cercania * 100 ) /  maxSize);
            System.debug('porcentual: ' + porcentual);
            return porcentual;
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    public static void getValidationOptions(Map<String,Object> inputMap, Map<String, Object> outMap)
    {
        system.debug('EXECUTING getValidationOptions');
        Map<String,String> imagesMap = getImagesForRadioButtons(iconsValidationRadios);

        vlocity_cmt__BusinessSite__c storeLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());
        String channel = storeLocation.Channel__c;

        ValidationMethodsByChannel__c methods = ValidationMethodsByChannel__c.getInstance(channel);

        List<Map<String, String>> availableMethods = new List<Map<String, String>>();
        
        if(methods.AdjuntarDocumentacion__c)
        {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', 'DOC');
            tempMap.put('value', 'Validación por Documento de Identidad');
            tempMap.put('imgId', '../servlet/servlet.ImageServer?id=' + imagesMap.get('attach_png') + '&&docName=attach_png&&oid=' + orgId);
            availableMethods.add(tempMap);
        }
       
        if(methods.LineaDecisora__c)
        {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', 'SMS');
            tempMap.put('value', 'Validación por Línea Decisora');
            tempMap.put('imgId', '../servlet/servlet.ImageServer?id=' + imagesMap.get('sms_png') + '&&docName=sms_png&&oid=' + orgId);
            availableMethods.add(tempMap);
        }

        if(methods.QA__c)
        {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', 'QA');
            tempMap.put('value', 'Validación por Preguntas y Respuestas');
            tempMap.put('imgId', '../servlet/servlet.ImageServer?id=' + imagesMap.get('dialogPNG') + '&&docName=dialogPNG&&oid=' + orgId);
            availableMethods.add(tempMap);
        }

        outMap.put('options', availableMethods);
    }

    public static Boolean getValidationOptionsForValidatedContact(Map<String,Object> inputMap, Map<String, Object> outMap)
    {
        system.debug('EXECUTING getValidationOptionsForValidatedContact');
        Map<String,String> imagesMap = getImagesForRadioButtons(iconsValidationRadios);
        System.debug('>>>>>> inputMap :' + inputMap);
        Contact contactInfo = (Contact) inputMap.get('Contact');
        System.debug('>>>>>> contactInfo :' + contactInfo);
        ID ContactId = (String)  inputMap.get('ContactId');
        System.debug('>>>>>> ContactId :' + ContactId);
        Boolean contactValidatedStatus;
        if (contactInfo != null) {
            contactValidatedStatus = (boolean) contactInfo.get('Validated__c');
        }
        System.debug('>>>>>> contactValidatedStatus :' + contactValidatedStatus);
        vlocity_cmt__BusinessSite__c storeLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());
        String channel = storeLocation.Channel__c;
        System.debug('channel' + channel);
        List<Map<String, String>> availableMethods = new List<Map<String, String>>();
        ValidationMethodsByChannel__c methods = ValidationMethodsByChannel__c.getInstance(channel);
       
        if(methods.LineaDecisora__c){
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', 'SMS');
            tempMap.put('value', 'Validación por Línea Decisora');
            tempMap.put('imgId', '../servlet/servlet.ImageServer?id=' + imagesMap.get('sms_png') + '&&docName=sms_png&&oid=' + orgId);
            availableMethods.add(tempMap);
        }
        if(methods.QA__c){
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', 'QA');
            tempMap.put('value', 'Validación por Preguntas y Respuestas');
            tempMap.put('imgId', '../servlet/servlet.ImageServer?id=' + imagesMap.get('dialogPNG') + '&&docName=dialogPNG&&oid=' + orgId);
            availableMethods.add(tempMap);
        }
        outMap.put('options', availableMethods);
        return true;
    }
    
    public static void getNominationValidationOptions(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        Map<String,String> imagesMap = getImagesForRadioButtons(iconsValidationRadios);

        vlocity_cmt__BusinessSite__c storeLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());
        String channel = storeLocation.Channel__c;     
        System.debug('channel' + channel);
        List<Map<String, String>> availableMethods = new List<Map<String, String>>();
        if(channel == 'Físico'){
            
            availableMethods.clear();
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', 'DOC');
            tempMap.put('value', 'Validación por Documento de Identidad');
            tempMap.put('imgId', '../servlet/servlet.ImageServer?id=' + imagesMap.get('attach_png') + '&&docName=attach_png&&oid=' + orgId);
            availableMethods.add(tempMap);
            Map<String, String> tempMap2 = new Map<String, String>();
            tempMap2.put('name', 'QA');
            tempMap2.put('value', 'Validación por Preguntas y Respuestas');
            tempMap2.put('imgId', '../servlet/servlet.ImageServer?id=' + imagesMap.get('dialogPNG') + '&&docName=dialogPNG&&oid=' + orgId);
            availableMethods.add(tempMap2);
            system.debug('Opciones Presencial: '+ availableMethods);
        }
        if (channel == 'Telefónico'){
            
            availableMethods.clear();
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', 'QA');
            tempMap.put('value', 'Validación por Preguntas y Respuestas');
            tempMap.put('imgId', '../servlet/servlet.ImageServer?id=' + imagesMap.get('dialogPNG') + '&&docName=dialogPNG&&oid=' + orgId);
            availableMethods.add(tempMap);
            system.debug('Opciones Telefonico: '+ availableMethods);
         
        }
        outMap.put('options', availableMethods);
        system.debug('Opciones Finales: '+ outMap);
    }

    private static String getErrorMessage(Map<String, Object> outMap, Exception ex) 
    {
        System.debug('Get Error Message');

        String httpStatusCode = (String) outMap.get('httpStatusCode');
        String errorMessage = '';
        if (httpStatusCode != '200') {
            errorMessage = 'Error en el llamado al servicio S150';
        } else {
            String errorCode = (String) outMap.get('codigo');
            System.debug('Error Code: ' + errorCode);
            if (errorCode != '200') {
                List<ServiceErrorHandling__c> errorHandlingList = [SELECT Id, Code__c, Type__c, Message__c FROM ServiceErrorHandling__c WHERE Name =: errorCode];
                System.debug('Error Handling List: ' + errorHandlingList);
                if (!errorHandlingList.isEmpty())
                    errorMessage = errorHandlingList.get(0).Message__c;
                else
                        errorMessage = ServiceErrorHandling__c.getInstance('DP-999999').Message__c;
            } else
                    errorMessage = 'Error con el servicio S150 no controlado. ' + ex.getMessage();
        }

        return errorMessage;
    }
    
    private static void getRetriesNumber(Map<String,Object> inputMap, Map<String, Object> outMap)
    {
        System.debug('getRetriesNumber');
        try
        {
            List<ContactValidationRetries__c> valRetries = ContactValidationRetries__c.getall().values();
            
            System.debug('retriesNumber: ' + valRetries[0].Retries__c);
            
            outMap.put('retriesNumber', valRetries[0].Retries__c);

        }
        catch(Exception e)
        {
            e.setMessage('Error en getRetriesNumber');
            throw e;
        }
    }

    private static Boolean getValidationOptionsPas(Map<String,Object> inputMap, Map<String, Object> outMap)
    {
        System.debug('EXECUTING getValidationOptionsPas');

        Map<String,String> imagesMap = getImagesForRadioButtons(iconsValidationRadios);

        vlocity_cmt__BusinessSite__c storeLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());
        String channel = storeLocation.Channel__c;
        System.debug('channel' + channel);
        List<Map<String, String>> availableMethods = new List<Map<String, String>>();
        if(channel == 'Físico'){
            availableMethods.clear();
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', 'DOC');
            tempMap.put('value', 'Validación por Documento de Identidad');
            tempMap.put('imgId', '../servlet/servlet.ImageServer?id=' + imagesMap.get('attach_png') + '&&docName=attach_png&&oid=' + orgId);
            availableMethods.add(tempMap);
            system.debug('Opciones Presencial: '+ availableMethods);
        }
        if (channel == 'Telefónico'){
            availableMethods.clear();
            //Map<String, String> tempMap = new Map<String, String>();
        }
        outMap.put('options', availableMethods);
        system.debug('Opciones Finales: '+ outMap);
        return true;

    }

    private static Map<String, String> getImagesForRadioButtons(List<String> images) {
        Map<String, String> imagesMap = new Map<String, String>();
        for (Document doc : [SELECT Id, DeveloperName FROM Document WHERE DeveloperName IN :images]){
            imagesMap.put(doc.DeveloperName, doc.Id);
        }
        return imagesMap;
    }
}