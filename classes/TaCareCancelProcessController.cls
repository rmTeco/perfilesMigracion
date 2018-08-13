global with sharing class TaCareCancelProcessController {

    @RemoteAction
    global static Boolean closeCase (Id caseId) {
        try {
            Case selectedCase = [
                SELECT Id,
                        CaseNumber,
                        Status
                FROM Case
                WHERE Id = :caseId
            ];

            selectedCase.Status = 'Anulada';
            selectedCase.Resolution_Comment__c = 'La gestión fue cancelada.';

            update selectedCase;
            
            return true;
        }
        catch(Exception ex) {
            System.debug(ex.getMessage());
            return false;       
        }
    }
}