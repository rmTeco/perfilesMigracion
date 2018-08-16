global with sharing class ta_techCare_Account implements vlocity_cmt.VlocityOpenInterface{
  public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            if(methodName.equals('GetAccounts')) GetAccounts(outMap);

        } catch(Exception ex){
            options.put('error', ex.getMessage());
            outMap.put('error', ex.getMessage());
            return false;
        }
        return true;
    }
    
    private void GetAccounts(Map<String, Object> outMap){
        try{
            List<Map<String,String>> options = new List<Map<String, String>>();
            
            for (Account account :[SELECT Id, Name FROM Account WHERE Name != NULL])
                
            { 
                Map<String, String> tempMap = new Map<String, String>();
                
                tempMap.put('name', (String) account.get('Id'));
                tempMap.put('value', (String) account.get('Id'));                
                tempMap.put('name', (String) account.get('Name'));
                tempMap.put('value', (String) account.get('Name'));
                
                options.add(tempMap);
            }
            outMap.put('options', options);
            
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener cuentas: ' + ex.getMessage());
        }
    }
    
}