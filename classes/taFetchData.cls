global with sharing class taFetchData implements vlocity_cmt.VlocityOpenInterface{

    global taFetchData(){}
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> optionsMap)
    {
        Boolean result = true;
        try
        {
            if(methodName.equals('getStateCode')){
                getStateCode(methodName, input, outMap, optionsMap);
            }
            /*if(methodName.equals('getLocationCode')){
                getLocationCode(methodName, input, outMap, optionsMap);
            }*/
        }
        catch(Exception e)
        {
            System.debug('taFetchData -> exception: '+e);
            result = false;
        }
        return result;
    }
    void getStateCode(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> optionsMap)
    {
        try
        {      
   Schema.DescribeFieldResult BillingRes = Account.BillingStateCode.getDescribe();
   List<Schema.PicklistEntry> ple = BillingRes.getPicklistValues();
   list<string> optionList = new list<string>();    
   for( Schema.PicklistEntry f : ple)
   {
      optionList.add(f.getLabel());
   }       
   
            outMap.put('Options', optionList);
        }
        catch(Exception ex)
        {
            throw ex;
        }
    }
    /*void getLocationCode(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> optionsMap)
    {
        try
        {      
           
           
        }
        catch(Exception ex)
        {
            throw ex;
        }
    }*/
    
}