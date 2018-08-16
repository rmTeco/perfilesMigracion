@IsTest
public class BillingGroupCloseCaseControllerTest {
   @IsTest static void closeCaseTest(){ 
       system.debug('ENTRO BillingGroupCloseCaseControllerTest.closeCaseTest');
       Id caseRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Diagnosis' AND SobjectType = 'Case' LIMIT 1].Id;
       
       system.debug('caseRecordTypeId =' + caseRecordTypeId);
       
       Account acc = new Account(Name = 'testLagertha',Phone = '0800'); 
        insert acc;
	
		Contact con = new Contact(FirstName = 'Ragnar', LastName = 'Lodbrok', Phone = '0900', MobilePhone = '0400', Email = 'ragnar.lodbrok@gmail.com');
		con.AccountId = acc.Id;  //account id 
		insert con;
		
		Case test_case = new Case(Subject = 'test_subject_vikings', AccountID = acc.Id, ContactId = con.Id, Status = 'Nueva', Origin = 'Telefónico', RecordTypeId = caseRecordTypeId);
		insert test_case;
       
        //BillingGroupCloseCaseController testedClass = new BillingGroupCloseCaseController();
       
       String caseCaseNumber = [SELECT CaseNumber FROM Case WHERE Id =: test_case.Id].CaseNumber;
        
       system.debug('test_case.Id =' + test_case.Id); 
       system.debug('caseCaseNumber.Id =' + caseCaseNumber); 
       
       Test.startTest();
       Boolean resultTest = BillingGroupCloseCaseController.closeCase(caseCaseNumber);
       Test.stopTest();
       
       List<Case> caseResult = [SELECT Id, Status, Resolution_Comment__c FROM Case WHERE Id =: test_case.Id];
       
       system.debug('caseResult[0].Id =' + caseResult[0].Id);
       system.debug('resultTest =' + resultTest);
       system.debug('caseResult[0].Status =' + caseResult[0].Status); 
       system.debug('caseResult[0].Resolution_Comment__c =' + caseResult[0].Resolution_Comment__c); 
       
       system.assertEquals(true, resultTest);
       system.assertEquals('Cancelada', caseResult[0].Status);
       system.assertEquals('El proceso fue cancelado.', caseResult[0].Resolution_Comment__c);
       
       
	}
    
    @IsTest static void closeCaseCatchTest(){ 
       system.debug('ENTRO BillingGroupCloseCaseControllerTest.closeCaseCatchTest');
       Id caseRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Diagnosis' AND SobjectType = 'Case' LIMIT 1].Id;
       
       Account acc = new Account(Name = 'testLagertha',Phone = '0800'); 
        insert acc;
	
		Contact con = new Contact(FirstName = 'Ragnar', LastName = 'Lodbrok', Phone = '0900', MobilePhone = '0400', Email = 'ragnar.lodbrok@gmail.com');
		con.AccountId = acc.Id;  //account id 
		insert con;
		
		Case test_case = new Case(Subject = 'test_subject_vikings', AccountID = acc.Id, ContactId = con.Id, Status = 'Nueva', Origin = 'Telefónico', RecordTypeId = caseRecordTypeId);
		insert test_case;
       
       Test.startTest();
       Boolean resultTest = BillingGroupCloseCaseController.closeCase(test_case.Id);
       Test.stopTest();
       
       List<Case> caseResult = [SELECT Id, Status, Resolution_Comment__c FROM Case WHERE Id =: test_case.Id];
       /*  Se espera false ya que el método espera un string y se envía un Id*/
       
        system.assertEquals(false, resultTest);
       
       
	}
    
@IsTest static void addLineItemToOrderTest(){ 
       system.debug('ENTRO BillingGroupCloseCaseControllerTest.addLineItemToOrder');
        
       Account acc = new Account(Name = 'testLagertha',Phone = '0800'); 
       insert acc;
        
       List<Order> testOrder = TestDataFactory.createOrders(1,acc);
        
       system.debug('testOrder[0].Pricebook2Id =' + testOrder[0].Pricebook2Id);
        
       List<Order> testOrder2 = [SELECT Id,Pricebook2Id FROM Order WHERE Pricebook2Id =: testOrder[0].Pricebook2Id];
        
       system.debug('testOrder2[0].Id =' + testOrder2[0].Id);
       
       List<Product2> testProduct2 = TestDataFactory.createProduct(1);
    
       List<OrderItem> testOrderItem = TestDataFactory.createOrderItem(1,testOrder2[0]);
    
       List<PricebookEntry> TestPricebookEntry =[SELECT Id,ProductCode,Pricebook2Id,Product2Id FROM PricebookEntry WHERE ProductCode =: testProduct2[0].ProductCode];
    
       system.debug('TestPricebookEntry[0].Pricebook2Id =' + TestPricebookEntry[0].Pricebook2Id);	
       system.debug('TestPricebookEntry.Product2Id =' + TestPricebookEntry[0].Product2Id);
       system.debug('TestPricebookEntry.ProductCode =' + TestPricebookEntry[0].ProductCode);
        
       Test.startTest();
       Map<String, Object> resultTest = BillingGroupCloseCaseController.addLineItemToOrder(testOrder2[0].Id,TestPricebookEntry[0].Pricebook2Id,TestPricebookEntry[0].ProductCode);
       Test.stopTest();
    
       system.debug('RESULTTEST =' + resultTest);
	}
    
}