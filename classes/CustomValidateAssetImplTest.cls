@isTest
public class CustomValidateAssetImplTest {

   public static testmethod void validateSelectedAssetTest(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Object nodeJson = (Object)'{"objConsulta:valores":{"codigoAccesoCliente":{"Not Available":"1234","Line Number":"10","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}},"codigoDeProducto":{"codProducto":"string","secuenciaProductoAdquirido":"string"}}';
        List<Object> obj = new List<Object>();
        obj.add(options);
        Map<String, Object> toMap = new Map<String, Object>();
        toMap.put('valores', obj);
        inputMap.put('ObjConsulta', toMap);     
       
        options.put('JSON Node',nodeJson);
        options.put('Elem Name',nodeJson);
        options.put('jsonPath','ObjConsulta:valores');
        options.put('Not Available', 'True');
        options.put('Line Number', '10');
            
        Test.startTest();
        CustomValidateAssetImplementation customValidate = new CustomValidateAssetImplementation();
        customValidate.invokeMethod('validateSelectedAsset', inputMap, outMap, options);
        Test.stopTest();
    }
   
   public static testmethod void validateSelectedAssetExcTest(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Object nodeJson = (Object)'{"objConsulta:valores":{"codigoAccesoCliente":{"Not Available":"1234","Line Number":"10","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}},"codigoDeProducto":{"codProducto":"string","secuenciaProductoAdquirido":"string"}}';
        List<Object> obj = new List<Object>();
        obj.add(nodeJson);
        Map<String, Object> toMap = new Map<String, Object>();
        toMap.put('valores', obj);
        inputMap.put('ObjConsulta', toMap);     
       
        options.put('JSON Node',nodeJson);
        options.put('Elem Name',nodeJson);
        options.put('jsonPath','ObjConsulta:valores');
            
        Test.startTest();
        CustomValidateAssetImplementation customValidate = new CustomValidateAssetImplementation();
        customValidate.invokeMethod('validateSelectedAsset', inputMap, outMap, options);
        Test.stopTest();
    }
     
    public static testmethod void validateLineItemWrapper(){
        
        Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
        Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
        insert acc;

        Asset ass = new Asset(Name = 'asset1', vlocity_cmt__LineNumber__c = '1234567890', AccountId = acc.Id);
        insert ass;
        
        SObject sob = ass;
        
        Test.startTest();
        CustomValidateAssetImplementation.LineItemWrapper customValidate = new CustomValidateAssetImplementation.LineItemWrapper(sob);
        customValidate.compareTo(customValidate);
        Test.stopTest();
    }
     
    public static testmethod void validateLineItemWrapperSortBy1(){
        
        Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
        Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
        insert acc;

        Asset ass = new Asset(Name = 'asset1', vlocity_cmt__LineNumber__c = '1234567890', AccountId = acc.Id);
        insert ass;
        
        SObject sob = ass;
        String sortBy = 'Ascending';        
        
        Test.startTest();
        CustomValidateAssetImplementation.LineItemWrapper customValidate = new CustomValidateAssetImplementation.LineItemWrapper(sob);
        customValidate.sortBy = sortBy;
        customValidate.compareTo(customValidate);
        Test.stopTest();
    }
    
    public static testmethod void validateLineItemWrapperNull(){
        Map<String, Object> options = new Map<String, Object>();
        Object nodeJson = (Object)'{"objConsulta:valores":{"codigoAccesoCliente":{"Not Available":"1234","Line Number":"10","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}},"codigoDeProducto":{"codProducto":"string","secuenciaProductoAdquirido":"string"}}';
        options.put('JSON Node',nodeJson);
        options.put('Elem Name',nodeJson);
        
        
        Test.startTest();
        CustomValidateAssetImplementation.LineItemWrapper customValidate = new CustomValidateAssetImplementation.LineItemWrapper(options, null);
        customValidate.compareTo(customValidate);
        Test.stopTest();
    }
    
    public static testmethod void validateLineItemWrapperSortBy(){
        Map<String, Object> options = new Map<String, Object>();
        Object nodeJson = (Object)'{"objConsulta:valores":{"codigoAccesoCliente":{"Not Available":"1234","Line Number":"10","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}},"codigoDeProducto":{"codProducto":"string","secuenciaProductoAdquirido":"string"}}';
        options.put('JSON Node',nodeJson);
        options.put('Elem Name',nodeJson);
        
        String sortBy = 'Ascending';
        
        Test.startTest();
        CustomValidateAssetImplementation.LineItemWrapper customValidate = new CustomValidateAssetImplementation.LineItemWrapper(options, sortBy);
        customValidate.compareTo(customValidate);
        Test.stopTest();
    }
}