global with sharing class ta_techCare_Model implements vlocity_cmt.VlocityOpenInterface{
  public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            if(methodName.equals('GetModels')) GetModels(outMap);

        } catch(Exception ex){
            options.put('error', ex.getMessage());
            outMap.put('error', ex.getMessage());
            return false;
        }
        return true;
    }
    
    private void GetModels(Map<String, Object> outMap){
        try{
            List<Map<String,String>> options = new List<Map<String, String>>();
            
            for (Asset model :[SELECT assetModel__c FROM Asset WHERE assetModel__c != NULL])
                
            { 
                Map<String, String> tempMap = new Map<String, String>();
                
                tempMap.put('name', (String) model.get('assetModel__c'));
                tempMap.put('value', (String) model.get('assetModel__c'));
                
                options.add(tempMap);
            }
            outMap.put('options', options);
            
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener objetos: ' + ex.getMessage());
        }
    }
    
}