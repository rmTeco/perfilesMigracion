global with sharing class ta_care_refundsGetWorrkTeamPermisess implements vlocity_cmt.VlocityOpenInterface{
    global ta_care_refundsGetWorrkTeamPermisess(){}
    
     public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
            if(methodName.equals('getQueueByWorkTeamPermisess')){
                getQueueByWorkTeamPermisess(outMap,options);
            }
            if(methodName.equals('CreateEntitlement')){
                CreateEntitlement(outMap,options);
            }
        }
        catch(Exception e)
        {
            System.debug('getQueueByWorkTeamPermisess:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }
    
    void getQueueByWorkTeamPermisess(Map<String, Object> outMap, Map<String,Object> options){
        List<Object> resultList = new List<Object>();
        List<Object> queueName = (List<Object>)options.get('PermissesName');
        System.debug('Name queue' + queueName);
        
        String queueNameTeam;
        for(Object obj: queueName){
            Map<String, Object> resultMap = (Map<String, Object>)obj;
            queueNameTeam = (String)resultMap.get('APIName');
        }
        String bb='_';
        String gg = ' ';
        String queueNameTeamComplete = queueNameTeam.replace(bb, gg);
        System.debug('really name:' + queueNameTeamComplete);
        
        Group groupQueue = [SELECT Id,Name,Type FROM Group where Name LIKE :('%'+ queueNameTeamComplete +'%') LIMIT 1];
        //ID idQueueTeam = groupQueue.Id;
        //resultList.add(idQueueTeam);
        system.debug('idQueueTeam'+groupQueue.id);
        //String idQueueTeamString = String.valueOf(idQueueTeam);
        
        //System.debug('resultList:' + resultList);
        
        //outMap.put('NewQueueTeam',resultList);
        outMap.put('NewQueueTeam',groupQueue.id);
        //outMap.put('idQueueTeam',idQueueTeamString);
        
    }
    
    void CreateEntitlement(Map<String, Object> outMap, Map<String,Object> options){
        try{
            String entitleProccess = (String)options.get('Entitlement');
            List<SlaProcess> entitleProccessId = [SELECT id,name,IsVersionDefault FROM SlaProcess WHERE name=:entitleProccess AND IsVersionDefault = true LIMIT 1];
            Id accId = (Id)options.get('Account');
            List<Entitlement> entitle = [SELECT id,name,SlaProcessId,AccountId FROM Entitlement WHERE AccountId=: accId AND SlaProcessId =:entitleProccessId[0].Id LIMIT 1];
            if(entitle.size() > 0){
                outMap.put('EntitlementId',entitle[0].Id);
            }else{
                Date startDate = Date.valueOf(date.today());
                Entitlement entitleObj = New Entitlement(name=entitleProccess+'Entitle' , AccountId=accId, StartDate=startDate, SlaProcessId=entitleProccessId[0].Id);
                insert entitleObj;
                outMap.put('EntitlementId',entitleObj.Id);
            }
        }
        catch(Exception ex) 
        {
            System.debug('Error:' + ex.getMessage());
        }
    }
}