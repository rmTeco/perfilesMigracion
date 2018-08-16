global with sharing class ta_sales_productSearch implements vlocity_cmt.VlocityOpenInterface {

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        if(methodName.equals('PopulateProductsTypeAhead')){
            PopulateProductsTypeAhead(input, outMap, options);
        }
        return true;
    }

    public void PopulateProductsTypeAhead(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            List<Product2> products = [SELECT Id, Name, ProductCode, NMU__c FROM Product2 WHERE Product2.Tipo_de_Bien_de_Uso__c = 'Tangible' ORDER BY Name];

            outMap.put('products', products);
        }catch (Exception e){}
    }
}