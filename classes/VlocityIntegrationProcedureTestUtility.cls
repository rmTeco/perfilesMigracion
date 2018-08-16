global class VlocityIntegrationProcedureTestUtility 
{
    // Will Return the Response as a Map
    // The Response here must Be a Map<String, Object>
    public static void mockIntegrationProcedure(String procedureKey, String responseString)
    {
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        
        mockIntegrationProcedure(procedureKey, response);
    }
    
    // Will Return the Response as a Map
    static void mockIntegrationProcedure(String procedureKey, Map<String, Object> response)
    {
        List<vlocity_cmt__TriggerSetup__c> trig = [Select Id from vlocity_cmt__TriggerSetup__c where Name = 'AllTriggers'];
        
        if (trig.size() == 0)
        {
            insert new vlocity_cmt__TriggerSetup__c(Name='AllTriggers', vlocity_cmt__IsTriggerOn__c=true);
        }
        
        vlocity_cmt__OmniScript__c proc = new vlocity_cmt__OmniScript__c(Name='Test', vlocity_cmt__Type__c=procedureKey.substringBefore('_'), vlocity_cmt__SubType__c=procedureKey.substringAfter('_'), vlocity_cmt__IsProcedure__c=true,vlocity_cmt__PropertySet__c='{}');
        insert proc;
    
        List<vlocity_cmt__Element__c> elementList = new List<vlocity_cmt__Element__c>{
            new vlocity_cmt__Element__c(Name='Response', vlocity_cmt__Type__c='Response Action', vlocity_cmt__Active__c=true, vlocity_cmt__OmniScriptId__c=proc.Id, vlocity_cmt__Order__c=1, vlocity_cmt__PropertySet__c='{"label":"Response","returnFullDataJSON":false,"responseDefaultData":'+ JSON.serialize(response) + ',"executionConditionalFormula":"","responseJSONPath":"","responseJSONNode":"","sendJSONPath":"","sendJSONNode":"","failureConditionalFormula":"","failOnStepError":true}')
        };
    
        insert elementList;
    
        vlocity_cmt.BusinessProcessController.bulkActivateBP(new List<Id>{ proc.Id });
    }
}