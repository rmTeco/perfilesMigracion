@isTest
public class SaleManagerInputMapFactoryTest {
    
    public static Map<String, Object> generateInputMap() {
        generateMockupData();
        Order order = [SELECT Id FROM Order LIMIT 1];
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('IdOrder', order.Id);

        Map<String, Object> billingOrder = new Map<String, Object>();
        String pickUpStore;
        List<vlocity_cmt__BusinessSite__c> business = [SELECT PointOfSaleId__c FROM vlocity_cmt__BusinessSite__c LIMIT 1];
        if (business!=null && business.size() >0){
            pickUpStore=business[0].PointOfSaleId__c.toPlainString();
        }
        billingOrder.put('PickUpStore', pickUpStore);
        inputMap.put('BillingOrder', billingOrder);

        return inputMap;
    }
    
    public static void generateMockupData() {
        List<Product2> productsList = [SELECT Id FROM Product2 where Name = 'Sample Product 1'];
        for(Product2 prod : productsList) {
            prod.ProductCode = 'PTNAC';
            prod.Family = 'Simcard';
        }
        update productsList;

        productsList = [SELECT Id FROM Product2 where Name = 'Sample Product 2'];
        for(Product2 prod : productsList) {
            prod.ProductCode = 'PTNAC';
            prod.Family = 'Internet';
            prod.Tipo_de_Bien_de_Uso__c = 'Tangible';

        }
        update productsList;
    }

    public static Map<String, Object> generateOptionsMap() {
        Map<String, Object> options = new Map<String, Object>();
        options.put('IdOrder',generateInputMap().get('IdOrder'));
        Account acc = [SELECT Id FROM Account LIMIT 1];
        options.put('accountId', acc.Id);
        options.put('FieldEmail', 'anemail@email.com');
        options.put('DeliveryMethod', 'Delivery');
        
        return options;
    }
}