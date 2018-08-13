public with sharing class EntitlementManager {
    
    public static Entitlement CreateEntitlement(String entitleName,ID accId, Date startDate, ID entitlementProcessId){
        Entitlement entitleObj = New Entitlement(name=entitleName , AccountId=accId, StartDate=startDate, SlaProcessId=entitlementProcessId);
        return entitleObj;
    }
    
    /*public static Entitlement GetExistentEntitlement (ID accId, ID entitlementProcessId){
        Entitlement entitle = [SELECT id,AccountId,SlaProcessId,name FROM Entitlement WHERE AccountId=:accId AND SlaProcessId=:entitlementProcessId LIMIT 1];
        return entitle;
    }*/
    
    public static Map<Id,Entitlement> GetExistentEntitlementMap (Set<Id> accIdSet, ID entitlementProcessId){
        Map<Id,Entitlement> resultMap = New Map<Id,Entitlement>();
        List<Entitlement> entitle = [SELECT id,AccountId,SlaProcessId,name FROM Entitlement WHERE AccountId IN: accIdSet AND SlaProcessId=:entitlementProcessId LIMIT 1];
        if(entitle.size() > 0){
            for(Entitlement ent: entitle){
                resultMap.put(ent.AccountId,ent);
            }
        }
        return resultMap;
    }
    
    public static void UpdateCompletionDateMilestone (String milestoneName, Set<Id> setIds){
        try{
            List<CaseMilestone> cmsToUpdate = [SELECT Id, completionDate FROM CaseMilestone cm WHERE caseId IN: setIds  AND cm.MilestoneType.Name =: milestoneName AND completionDate = null];
            if (cmsToUpdate.size() > 0){
                for (CaseMilestone cm : cmsToUpdate){
                    cm.completionDate = System.now();
                }
                update cmsToUpdate;
            }
        }
        catch(Exception ex) 
        {
            System.debug('Error:' + ex.getMessage());
        }
    }
    
}