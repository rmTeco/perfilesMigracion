global with sharing class ta_techCare_selfManagement implements vlocity_cmt.VlocityOpenInterface{
	public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            if(methodName.equals('GetChannels')) GetChannels(outMap);
            else if(methodName.equals('GetServices')) GetServices(outMap, input);
            else if(methodName.equals('GetIncidents')) GetIncidents(outMap, input);

        } catch(Exception ex){
            options.put('error', ex.getMessage());
            outMap.put('error', ex.getMessage());
            return false;
        }
        return true;
    }
    
    private void GetChannels(Map<String, Object> outMap){
        try{
            List<Map<String,String>> options = new List<Map<String, String>>();
            
            for (AggregateResult channel : [SELECT Channel__c 
                                              FROM Contact_Motive__c 
                                             WHERE RecordType.Name = 'Service Incident'
                                               AND Is_Active__c = true
                                          GROUP By Channel__c])
                
            { 
                Map<String, String> tempMap = new Map<String, String>();
                
                tempMap.put('name', (String) channel.get('Channel__c'));
                tempMap.put('value', (String) channel.get('Channel__c'));
                
                options.add(tempMap);
            }
            outMap.put('options', options);
            
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener canales: ' + ex.getMessage());
        }
    }
    
    private void GetServices(Map<String, Object> outMap, Map<String, Object> input){
        try{
            Map<String, Object> step = (Map<String, Object>) input.get('SelfManagementStep');
            Map<String, Object> block = (Map<String, Object>) step.get('SelfManagementFields');
            String channel = (String) block.get('ChannelSelection');
                
            List<Map<String,String>> options = new List<Map<String, String>>();
            
            for (AggregateResult service : [SELECT Service__c FROM Contact_Motive__c
                                             WHERE RecordType.Name = 'Service Incident'
                                               AND Channel__c = :channel
                                               AND Is_Active__c = true
                                          GROUP By Service__c])
                
            { 
                Map<String, String> tempMap = new Map<String, String>();
                
                tempMap.put('name', (String) service.get('Service__c'));
                tempMap.put('value', (String) service.get('Service__c'));
                
                options.add(tempMap);
            }
            outMap.put('options', options);
            
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener canales: ' + ex.getMessage());
        }
    }
    
    private void GetIncidents(Map<String, Object> outMap, Map<String, Object> input){
        try{
            Map<String, Object> step = (Map<String, Object>) input.get('SelfManagementStep');
            Map<String, Object> block = (Map<String, Object>) step.get('SelfManagementFields');
            String channel = (String) block.get('ChannelSelection');
            String service = (String) block.get('ServiceSelection');
                
            List<Map<String,String>> options = new List<Map<String, String>>();
            
            for (AggregateResult incident : [SELECT Incident__c FROM Contact_Motive__c
                                             WHERE RecordType.Name = 'Service Incident'
                                               AND Channel__c = :channel
                                               AND Service__c = :service
                                               AND Is_Active__c = true
                                          GROUP By Incident__c])
                
            { 
                Map<String, String> tempMap = new Map<String, String>();
                
                tempMap.put('name', (String) incident.get('Incident__c'));
                tempMap.put('value', (String) incident.get('Incident__c'));
                
                options.add(tempMap);
            }
            outMap.put('options', options);
            
        } catch(Exception ex){
            throw new FuncException('Error inesperado al obtener canales: ' + ex.getMessage());
        }
    }
}