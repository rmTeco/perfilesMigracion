@isTest
public class TaIdentityValidationHandlerTest
{
    //Bug10904- Yamila Simoncini#I
    static User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
     //Bug10904- Yamila Simoncini#F
    @isTest static void getQuestions()
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        String numeroDocumento = '16208726';
        String tipoDocumento = 'DNI';
        String genero = 'Masculino';
        String nombre = 'Andrés';
        String apellido = 'Rotman';

        Contact contact = new Contact(FirstName = nombre, LastName = apellido, DocumentType__c = tipoDocumento, DocumentNumber__c = numeroDocumento, Gender__c = genero);
        insert contact;
        options.put('contactId', contact.Id);

        String json = '{"listaPreguntas": [{"listaRespuestas": [{"respuesta": "respuesta", "codRespuesta": "1"}], "consulta": "consulta", "codConsulta": "001"}]}';

        Map<String, Object> ipResult = (Map<String, Object>) System.JSON.deserializeUntyped(json);
        ipResult.put('genero', 'M');
        ipResult.put('nombreActor', 'APELLIDO, NOMBRE');
        ipResult.put('ticket', '123456789012345');
        ipResult.put('codCuestionario', '002');
        options.put('IPResult', ipResult);

        NameComparisonPercentage__c ncp = new NameComparisonPercentage__c();
        ncp.Percentage__c = Decimal.valueOf('33.33');
        insert ncp;
        
        Test.startTest();
            taIdentityValidationHandler ivh = new taIdentityValidationHandler();
            ivh.invokeMethod('getQuestions', inputMap, outMap, options);
        Test.stopTest();
    }

    @isTest static void verifyAnswers()
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        Map<String, Object> data = new Map<String, Object>();
        data.put('ticket', '123456789012345');
        data.put('codCuestionario', '001');

        Map<String, Object> pregunta = new Map<String, Object>();
        pregunta.put('codConsulta', '001');
        pregunta.put('codRespuesta', '1');
        List<Object> listaPreguntas = new List<Object>();
        listaPreguntas.add(pregunta);
        data.put('listaPreguntas', listaPreguntas);
        inputMap.put('data', data);

        options.put('outputMapS499', 'true');

        Test.startTest();
            taIdentityValidationHandler ivh = new taIdentityValidationHandler();
            ivh.invokeMethod('verifyAnswers', inputMap, outMap, options);
        Test.stopTest();
    }

    @isTest static void getValidationOptions()
    {
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        String firstName = 'Contact First Name';
        String lastName = 'Contact LastName';
        String accountName = 'Sample Account';
        String documentType = 'DNI';
        String documentNumber = '12345678';
        String accountNumber = '1234';
        String email = 'test@yopmail.com';
        //Bug10904- Yamila Simoncini#I
        System.runAs (thisUser) {

            Contact contact = new Contact(FirstName = firstName, LastName = lastName, DocumentType__c = documentType, DocumentNumber__c = documentNumber, Email = email, Validated__c= true);
            insert contact;
            
            ValidationMethodsByChannel__c ValidationMethod = new ValidationMethodsByChannel__c(Name= 'Físico', AdjuntarDocumentacion__c= true, LineaDecisora__c = true, QA__c = true);
            insert ValidationMethod;
            inputMap.put('Contact', contact);
            inputMap.put('ContactId', contact.id);
    
            Test.startTest();
                taIdentityValidationHandler ivh = new taIdentityValidationHandler();
                ivh.invokeMethod('getValidationOptions', inputMap, outMap, null);
                ivh.invokeMethod('getValidationOptionsForValidatedContact', inputMap, outMap, null);
            Test.stopTest();
        }//Bug10904- Yamila Simoncini#F
    }

    @isTest static void getNominationValidationOptions_test()
    {
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        System.runAs (thisUser) {

            ValidationMethodsByChannel__c ValidationMethod = new ValidationMethodsByChannel__c(Name= 'Físico', AdjuntarDocumentacion__c= true, LineaDecisora__c = true, QA__c = true);
            insert ValidationMethod;
            
            Test.startTest();
                taIdentityValidationHandler ivh = new taIdentityValidationHandler();
                ivh.invokeMethod('getNominationValidationOptions', inputMap, outMap, null);
            Test.stopTest();
        }
    }

    @isTest static void getValidationOptionsPas_test()
    {
        
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();

        
        ValidationMethodsByChannel__c ValidationMethod = new ValidationMethodsByChannel__c(Name= 'Telefónico', AdjuntarDocumentacion__c= true, LineaDecisora__c = true, QA__c = true);
        System.runAs(thisUser) {
            
            insert ValidationMethod;
        
            Test.startTest();
                taIdentityValidationHandler ivh = new taIdentityValidationHandler();
                ivh.invokeMethod('getValidationOptionsPas', inputMap, outMap, null);
            Test.stopTest();
        }
        //Bug10904- Yamila Simoncini#F
        
    }
    
    
    
    
}