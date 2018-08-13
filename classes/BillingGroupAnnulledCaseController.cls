global with sharing class BillingGroupAnnulledCaseController{

    @RemoteAction
    global static Boolean closeCase(String Id){
        try
        {
            System.debug('El caseNumber es:' + Id);
            Case selectedCase = [SELECT Id, CaseNumber, Status FROM Case WHERE Id = :Id];
            selectedCase.Status = 'Anulada';
            selectedCase.Resolution_Comment__c = 'El proceso fue anulado.';
            update selectedCase;
            
            return true;
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage());
            return false;       
        }
        
    }
    
    global BillingGroupAnnulledCaseController(){
    
    }
}