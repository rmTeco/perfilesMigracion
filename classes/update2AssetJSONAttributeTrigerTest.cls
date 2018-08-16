global class update2AssetJSONAttributeTrigerTest {
    public static void testUpdateConMiniJson()
    {
        Asset a = new Asset();
        a.AccountId = '0016C000009OLhhQAG';
        a.Product2ID = '01t6C000000ZudJQAS';
        a.Name = 'Simcard_Json_Test';
        a.Migrated__c = true;
        a.vlocity_cmt__AttributeSelectedValues__c = '{"MSISDN":"1144447363"}';
        insert a;
      }
    
}