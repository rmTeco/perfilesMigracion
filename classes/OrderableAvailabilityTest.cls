@IsTest
public class OrderableAvailabilityTest {

    @IsTest public static void getAvailableProductsTest(){
        
        Pricebook2 pricebook = TestDataFactory.createPriceBook('Telecom Pricebook');
        sObject sObj = Schema.getGlobalDescribe().get('Order').newSObject();
        sObj.put('Pricebook2Id', pricebook.Id);
        vlocity_cmt__PriceList__c pricelist = TestDataFactory.createPriceList('TA Pricelist', pricebook.id);
        
        String it = '{"Pricebook2Id":"'+ pricebook.id +'"}';
        List<PriceBookEntry> retval = new List<PriceBookEntry>();
        
        OrderableAvailability oa = new OrderableAvailability();
        List<PriceBookEntry> prien = oa.getAvailableProducts(sObj,retval);
    }
}