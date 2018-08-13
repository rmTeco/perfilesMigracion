@IsTest
public class ChangesValidation_test {
   
    @testSetup static void setup() {
       Contact cont = new Contact();
        cont.FirstName = 'Test First Name';
        cont.LastName = 'Test contact';
        cont.DocumentType__c = 'DNI';
        cont.DocumentNumber__c = '12345678';
        date myDate = date.parse('04/12/2018');
        cont.ActivationDate__c = myDate;
        date birth = date.parse('11/04/1990');
        cont.Birthdate = birth;
        cont.Gender__c = 'Masculino';
        cont.Email = 'test@gmail.com';
        insert cont;
        
        Id consumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        Account parentAcc = new Account (Name='New Test Parent Account', RecordTypeId = consumerRecordTypeId);
        insert parentAcc;
        
        Case testCase = new Case();
        testCase.AccountId = parentAcc.Id;
        insert testCase;
     }
    
    
    @IsTest static void invoke_GetAccountHistory(){
        String methodName = 'GetAccountHistory';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
    
        ChangesValidation validations = new ChangesValidation();
        
        Contact cont= [SELECT id,FirstName,LastName,ActivationDate__c,DocumentNumber__c FROM Contact WHERE FirstName = 'Test First Name'];
        
        input.put('ContactId',cont.id);
        system.debug('CONTACT ID-->'+input.get('ContactId'));

        
    Test.startTest();
        validations.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertEquals(true,outMap.get('validationDNI'));
    }
    
        @IsTest static void invoke_CompareChangesDNI(){
          String methodName = 'CompareChangesDNI';

          Map<String, Object> input = new Map<String, Object>();
          Map<String, Object> outMap = new Map<String, Object>();
          Map<String, Object> options = new Map<String, Object>();
    
          ChangesValidation validations = new ChangesValidation();
            
            Contact cont= [SELECT id,FirstName,LastName,ActivationDate__c,DocumentNumber__c FROM Contact WHERE FirstName = 'Test First Name'];
            
            input.put('ContactId',cont.Id);
            Map<String, Object> clientInformation = new Map<String,Object>();
            clientInformation.put('DocumentNumber','20345678');
            
            input.put('ClientInformation',clientInformation);
            
            system.debug('INPUT MAP -->'+input);
            
            Test.startTest();
          validations.invokeMethod(methodName, input, outMap, options);
          Test.stopTest();
            
            system.assertEquals(true,outMap.get('validationDigits'));
            
        }
    
    @IsTest static void invoke_CountDataChanges(){
       String methodName = 'CountDataChanges';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
    
        ChangesValidation validations = new ChangesValidation();
          
        Contact cont= [SELECT id,FirstName,LastName,ActivationDate__c,DocumentNumber__c,Birthdate,Gender__c,Email FROM Contact WHERE FirstName = 'Test First Name'];
            
        input.put('ContactId',cont.Id);
        
        Map<String, Object> clientInformation = new Map<String,Object>();
        clientInformation.put('DocumentNumber','20202020');
        clientInformation.put('Gender','Femenino');
        clientInformation.put('Birthdate','04/06/1991');
        clientInformation.put('Email','testNew@gmail.com');
    
    input.put('ClientInformation',clientInformation);
        Test.startTest();
        validations.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertEquals(3,outMap.get('validationDataChanges'));
    }
    
    @IsTest static void invoke_CreateOrUpdateCase_update(){
        String methodName = 'CreateOrUpdateCase';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
    
        ChangesValidation validations = new ChangesValidation();
    
    Account acc = [SELECT id,name FROM Account WHERE name='New Test Parent Account'];
    Case testCase = [SELECT id,AccountId FROM Case WHERE AccountId =: acc.Id];
    Contact cont = [SELECT id,FirstName FROM Contact WHERE FirstName = 'Test First Name'];
    
    input.put('CaseId',testCase.Id);
    input.put('ContextId',acc.Id);
    input.put('ContactId',cont.Id);
    input.put('DigitChanges',false);
    input.put('CountChanges',3);
    
    Test.startTest();
        validations.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        Case updatedCase = [SELECT id,AccountId,Status FROM Case WHERE AccountId =: acc.Id];
        system.assertEquals('Closed',updatedCase.Status);
    
    }
    
    @IsTest static void invoke_CreateOrUpdateCase_create(){
        String methodName = 'CreateOrUpdateCase';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
    
        ChangesValidation validations = new ChangesValidation();
    
    Account acc = [SELECT id,name FROM Account WHERE name='New Test Parent Account'];
    //Case testCase = [SELECT id,AccountId FROM Case WHERE AccountId =: acc.Id];
    Contact cont = [SELECT id,FirstName FROM Contact WHERE FirstName = 'Test First Name'];
    
    //input.put('CaseId',testCase.Id);
    input.put('ContextId',acc.Id);
    input.put('ContactId',cont.Id);
    input.put('DigitChanges',false);
    input.put('CountChanges',3);
    
    Test.startTest();
        validations.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        Case testCase = [SELECT id,AccountId,Subject FROM Case WHERE AccountId =: acc.Id AND Subject = 'Actualización de Datos'];
        system.assertNotEquals(null,testCase);
    }
    
    @IsTest static void invoke_PhoneValidation(){
        String methodName = 'PhoneValidation';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
    
        ChangesValidation validations = new ChangesValidation();
        
        Map<String, Object> clientInformation = new Map<String,Object>();
        clientInformation.put('MobilePhone','+5491155555555');
        clientInformation.put('OtherPhone','+54911444444444');
            
        input.put('ClientInformation',clientInformation);
        
        Test.startTest();
        validations.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertEquals('1155555555',outMap.get('ValidmobilePhone'));
        system.assertEquals('Error',outMap.get('ValidotherPhone'));
    }
}