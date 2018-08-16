global with sharing class ta_care_URL implements vlocity_cmt.VlocityOpenInterface{
    global ta_care_URL(){}
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
            if(methodName.equals('getURL')){
                getURL(methodName, input, outMap, options);
            }
        }
        catch(Exception e)
        {
            System.debug('ta_URL:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    void getURL(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        try
        {
			string URL = ApexPages.currentPage().getHeaders().get('Host');
			System.debug('URL'+URL);
            outMap.put('URL', URL);
        }
        catch(Exception ex)
        {
            throw ex;
        }
    }
}