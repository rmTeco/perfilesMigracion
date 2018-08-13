global with sharing class taNewContact implements vlocity_cmt.VlocityOpenInterface{

    global taNewContact(){}
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
            if(methodName.equals('getDocumentTypes')){
                getDocumentTypes(outMap);
            }
        }
        catch(Exception e)
        {
            System.debug('taNewContact:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    public void getDocumentTypes(Map<String, Object> outMap)
    {
        List<Map<String, String>> options = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Contact.DocumentType__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        { 
            if(f.value == 'DNI' || f.value == 'PAS')
            {
                Map <String, String> tempMap = new Map<String, String>();  
                tempMap.put('name', f.getValue());
                tempMap.put('value', f.getLabel());
                //tempMap.put('value', f.getValue()); 
                options.add(tempMap);
            }
        }
        
        System.debug('options: ' + options);

        outMap.put('options', options);
    }
}