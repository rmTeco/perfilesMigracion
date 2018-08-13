global with sharing class ta_sales_NewAccount implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try {
            if (methodName.equals('CalculateCreditRiskAndLimit')){
                CalculateCreditRiskAndLimit(inputMap, outMap, options);
            }
            result = false;
        } catch(Exception e) {
            System.debug('ta_sales_NewAccount:invokeMethod -> exception: '+e);
            throw e;
        }
        return result;
    }
    
    private void CalculateCreditRiskAndLimit(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('Calculate Credit Risk and Limit');

        Map<String, Object> contactJSON = (Map<String, Object>) inputMap.get('Contact');
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();
        if (contactJSON == null) {
            String accountType = (String)options.get('AccountType');
            
            if (accountType == 'Consumer') {
                String contactId = (String)options.get('ContactId');
                Contact contact = [SELECT Id, DocumentType__c, DocumentNumber__c, Gender__c, Name FROM Contact WHERE Id =: contactId LIMIT 1];            
                String name = contact.Name;
                String docType = contact.DocumentType__c;
                String docNumber = contact.DocumentNumber__c;
                String gender = contact.Gender__c;
                
                input = Generate_RequestS131(name, docType, docNumber, gender);
            } else if (accountType == 'Business') {
                Map<String, Object> accountDataMap = (Map<String, Object>) inputMap.get('AccountData');                
                String name = (String) accountDataMap.get('ContactName');
                String docType = (String) accountDataMap.get('NewAccountDocumentType');
                String docNumber = (String) accountDataMap.get('NewAccountDocumentNumber');
                String gender = 'I';
                
                input = Generate_RequestS131(name, docType, docNumber, gender);
            }
        } else {
            String name = ((String) contactJSON.get('FirstName')) + ' ' + ((String) contactJSON.get('LastName'));
            String docType = (String) contactJSON.get('DocumentType');
            String docNumber = (String) contactJSON.get('DocumentNumber');
            String gender = (String) contactJSON.get('Gender');
            
            input = Generate_RequestS131(name, docType, docNumber, gender);
        }
        
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S131', input, output, options2);
        outMap.put('IP_Response', output);

        System.debug('Response S131: ' + output);

        Map<String, Object> ipResult = (Map<String, Object>)output.get('IPResult');
        String riesgoCrediticio = String.valueOf(ipResult.get('codRespuesta'));
        String limiteDeCredito = String.valueOf(ipResult.get('limiteCreditoActual'));
        
        if (riesgoCrediticio != null) {
            outMap.put('AccountCreditRisk', riesgoCrediticio);
        }
        if (limiteDeCredito != null) {
            outMap.put('AccountCreditLimit', limiteDeCredito);
        }
    }
    
    private Map<String, Object> Generate_RequestS131(String name, String docType, String docNumber, String gender) {
        System.debug('Generate Request');
        
        Map<String, Object> body = new Map<String, Object>();
        Map<String, Object> auxMap = new Map<String, Object>();
        
        CreditScore__c creditScoreSetting = CreditScore__c.getInstance();
        String codAreaEmpresa = creditScoreSetting.codAreaEmpresa__c;
        auxMap.put('codAreaEmpresa', codAreaEmpresa);
        String codAccionNegocio = creditScoreSetting.codAccionNegocio__c;
        auxMap.put('codAccionNegocio', codAccionNegocio);
        String codCanal = creditScoreSetting.codCanal__c;
        auxMap.put('codCanal', codCanal);
        String codUsuario = 'u567117';
        auxMap.put('codUsuario', codUsuario);
        String excepcion = creditScoreSetting.excepcion__c;
        auxMap.put('excepcion', excepcion);

        auxMap.put('nombreActor', name);
        auxMap.put('tipoDocumento', docType);
        auxMap.put('numeroDocumento', docNumber);
        auxMap.put('genero', gender);

        body.put('body', auxMap);
        return body;
    }
}