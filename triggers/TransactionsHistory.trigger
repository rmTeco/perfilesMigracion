trigger TransactionsHistory on Transaction_History__c (
    after delete, after insert, after update,
    before delete, before insert, before update) {
    
    ApplicationDomain.TriggerHandler(TransactionsHistory.Class);
}