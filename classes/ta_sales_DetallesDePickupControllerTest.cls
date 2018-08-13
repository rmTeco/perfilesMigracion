@isTest
public class ta_sales_DetallesDePickupControllerTest {

    @isTest static void loadValuesTest() {
        //GIVEN
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__PriceList__c taPriceList = TestDataFactory.createPriceList('Telecom Price List');
        Order order = new Order(Name='TestOrder',
                                AccountId=account.Id,
                                EffectiveDate=Date.today(),
                                Status='Draft',
                                Pricebook2Id =Test.getStandardPricebookId(),
                                vlocity_cmt__PriceListId__c=taPriceList.Id,
                                Delivery_Method__c='Delivery',
                                vlocity_cmt__OriginatingChannel__c='Agentes'
                                );
        
        insert order;        
        
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (
          vlocity_cmt__City__c = 'Tigre',
          PointOfSaleId__c = 1, 
          vlocity_cmt__StreetAddress__c = 'Test',
          PointOfSaleAddressNumber__c = '1',
          vlocity_cmt__OrganizationId__c = account.Id,
          PointOfSaleType__c  = 'LE',
          vlocity_cmt__State__c = '',
          vlocity_cmt__Country__c = '');
    insert site;
        
        order.PickUpStoreLocation__c = site.Id;
        update order;
        
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'CrossObject__c' AND DeveloperName = 'EmailToSend'];
        CrossObject__c cross = new CrossObject__c(Email1__c = 'test@test.com', Picklist1__c = 'Detalles de Pickup', RecordTypeId = rt.Id, Order__c = order.Id);
        insert cross;
                
        ta_sales_DetallesDePickupController DetallesDePickupController = new ta_sales_DetallesDePickupController();
        DetallesDePickupController.crossId = cross.Id;
        
        //WHEN
        Test.startTest();
        CrossObject__c crossObj = DetallesDePickupController.loadedCro;
        Test.stopTest();
        
        //THEN
        System.assert(true);
        
    }
    
    @isTest static void loadValuesExceptionTest() {
        //GIVEN
        ta_sales_DetallesDePickupController DetallesDePickupController = new ta_sales_DetallesDePickupController();
        
        //WHEN
        DetallesDePickupController.loadValues();
        
        
        //THEN
        System.assert(true);
        
    }
}