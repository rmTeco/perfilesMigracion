global with sharing class ta_techCare_Contact implements vlocity_cmt.VlocityOpenInterface{
  public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            if(methodName.equals('GetContacts')) GetContacts(outMap);

        } catch(Exception ex){
            options.put('error', ex.getMessage());
            outMap.put('error', ex.getMessage());
            return false;
        }
        return true;
    }
    
    private void GetContacts(Map<String, Object> outMap){
        try{
            List<Map<String,String>> options = new List<Map<String, String>>();
            
            for (Contact contact :[SELECT Name FROM Contact WHERE Name != NULL])
                
            { 
                Map<String, String> tempMap = new Map<String, String>();
                
                tempMap.put('name', (String) contact.get('Name'));
                tempMap.put('value', (String) contact.get('Name'));
                
                options.add(tempMap);
            }
            outMap.put('options', options);
            
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener contactos: ' + ex.getMessage());
        }
    }
    
}