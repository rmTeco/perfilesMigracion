global with sharing class ta_Techcare_OrderAcceptances implements vlocity_cmt.VlocityOpenInterface{
    global ta_Techcare_OrderAcceptances() {
    }
    
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
            if(methodName.equals('getQueue')){
                getQueue(input,outMap,options);
            }
            
        }
        catch(Exception e)
        {
            System.debug('ta_Techcare_OrderAcceptances:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }
    
    void getQueue (Map<String, Object> inputMap, Map<String, Object> outMap, Map<String,Object> options) {
        try{
            final String THREE_CHARACTERS_QUEUE = '00G';
            ID caseID = (ID)options.get('caseID');
            List<CaseHistory> caseHistoryList = [SELECT CreatedById,CreatedDate,Field,Id,NewValue,OldValue FROM CaseHistory WHERE CaseId =: caseID  AND Field = 'Owner' ORDER BY CreatedDate ASC NULLS LAST];
            Boolean found = false;
            for(CaseHistory ch: caseHistoryList){
                String oldValueString;
                oldValueString = String.valueOf(ch.OldValue);
                String threeFirstCharacters;
                threeFirstCharacters = oldValueString.left(3);
                if(!found && !oldValueString.isAlphaSpace() && oldValueString.length() == 18 && threeFirstCharacters == THREE_CHARACTERS_QUEUE){
                    found = true;
                    Id idQueue = Id.valueOf(oldValueString);
                    outMap.put('lastQueueID',idQueue);
                }
                
            }
        }
        catch(Exception e){
           System.debug('Error =' + e); 
        }
    }
}