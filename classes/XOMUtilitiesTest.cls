@isTest
private class XOMUtilitiesTest {
    
    @isTest static void test_method_one() {
        XOMUtilities.validatePaid('');
        XOMUtilities.validatePaid('notempty');

        XOMUtilities.evalueteRealization(XOMUtilities.INMEDIATO);
        XOMUtilities.evalueteRealization(XOMUtilities.PROXIMO_CICLO);
        XOMUtilities.evalueteRealization(XOMUtilities.TIEMPO_ESPECIFICADO);
        XOMUtilities.evalueteRealization('else');

        XOMUtilities.evaluateNetworkType(XOMUtilities.DESCONOCIDO);
        XOMUtilities.evaluateNetworkType(XOMUtilities.ONNET);
        XOMUtilities.evaluateNetworkType(XOMUtilities.OFFNET);
        XOMUtilities.evaluateNetworkType(XOMUtilities.INTERNACIONAL);
        XOMUtilities.evaluateNetworkType('else');

        List<Asset> assets = new List<Asset> {new Asset(Name = 'asset')};
        XOMUtilities xomu = new XOMUtilities();
        xomu.getJsonAttributesFromAnyObject(assets, 'Asset');
        xomu.getJsonAttributesFromAnyObject(assets, 'OrderItem');
        xomu.getJsonAttributesFromAnyObject(assets, 'vlocity_cmt__FulfilmentRequestLine__c');
        xomu.getJsonAttributesFromAnyObject(assets, 'Product2');
        xomu.getJsonAttributesFromAnyObject(assets, 'vlocity_cmt__InventoryItem__c');
        xomu.getJsonAttributesFromAnyObject(assets, 'else');

        List<Map<String, Object>> attributes = new List<Map<String, Object>>();
        attributes.add(new Map<String, Object>());
        xomu.getValueFromAttrs(attributes, 'string');
    }
    
    @isTest static void test_method_two() {
        // Implement test code
    }
    
}