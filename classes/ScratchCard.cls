global with sharing class ScratchCard implements vlocity_cmt.VlocityOpenInterface
{
    global ScratchCard() {}
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
      
        Boolean result = true;
        try
        {
        
            if (methodName.equals('getCardInfo'))
            {
                 
                getCardInfo(input, outMap, options);
            }
            
            result = false; 
          
        } 
        catch(Exception e)
        {
            System.debug('AutomaticDebitSubscription:invokeMethod -> exception: '+e);
            result = false;
        }
        return result; 
    }
       public  void getCardInfo(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> options)
       {
                //Map<String,Object> inputMap = new Map<String, Object>();
                Map<String, String> obj = new Map<String, String>();
                obj.put('Amount', '$200');
                obj.put('Status', 'Activo');
                obj.put('LineNumber', '18765467897');
                obj.put('Type', 'Recarga full');
                obj.put('DatePin', '26/07/2018');
                obj.put('DateActivation', '26/07/2018');
                obj.put('DateExpiration', '26/07/2018');
                outMap.put('dataInput', obj);

        }
}