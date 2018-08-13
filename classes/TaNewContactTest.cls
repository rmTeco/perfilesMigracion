@isTest
public class TaNewContactTest {
    @isTest static void TestInvokeMethodReturnsTrue() {
        taNewContact newContact = new taNewContact();
        Boolean result = newContact.invokeMethod('someRandomString', null, null, null);
        System.assertEquals(result, true);
    }
    
    @isTest static void TestGetDocumentTypes() {
        taNewContact newContact = new taNewContact();
        Map<String, Object> outMap = new Map<String, Object>();
        
        Test.startTest();
        newContact.invokeMethod('getDocumentTypes', null, outMap, null);
        Test.stopTest();
        
        List<Map<String,Object>> myOutMap = (List<Map<String,Object>>) outMap.get('options');   
       	
       	for(Integer i=0;i<myOutMap.Size()-1;i++) {
            Map<String, String> contactDataElement = (Map<String, String>) taNewContactTestDataFactory.createNewContactSelectableData()[i];
            System.assertEquals(myOutMap[i].get('name'), contactDataElement.get('name'));           
            System.assertEquals(myOutMap[i].get('value'), contactDataElement.get('value'));
        }
    }
}