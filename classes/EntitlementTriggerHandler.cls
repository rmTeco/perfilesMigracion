public class EntitlementTriggerHandler {
	
    public static void assignEntitlementToTechServiceCase(List<Entitlement> triggerNew){
        try{
            Set<Id> setCaseIds = New Set<Id>();
            Map<Id,Id> accIdAndEntitleIdMap = New Map<Id,Id>();
            List<Case> casesToUpdate = New List<Case>();
            for(Entitlement entitle: triggerNew){
                setCaseIds.add(entitle.AccountId);
                accIdAndEntitleIdMap.put(entitle.AccountId,entitle.Id);
            }
            List<Case> caseList = [SELECT id,status,AccountId,subject,EntitlementId FROM Case WHERE AccountId IN:setCaseIds AND status = 'En espera del cliente' AND subject ='Gestión de Servicio Técnico'];
            if(caseList.size() > 0){
                for(Case cs: caseList){
                    cs.EntitlementId = accIdAndEntitleIdMap.get(cs.AccountId);
                    casesToUpdate.add(cs);
                }
            }
            if(casesToUpdate.size() > 0){
                update casesToUpdate;
            }
        }
        catch(Exception ex) 
        {
            System.debug('Error:' + ex.getMessage());
        }
    }
}