public with sharing class TransactionsTriggers {
        
    public Static void recalculateLoyaltyAccountPoints(){
        Set<Id> accountIds = new Set<Id>();
        List<Account> accountsUpdateList = new List<Account>();
        List<LoyaltyTransaction__c> transactionsAccounts = new List<LoyaltyTransaction__c>();
		
        try{
            for(LoyaltyTransaction__c lt : [select LoyaltyAccount__c from LoyaltyTransaction__c where Id IN : Trigger.new]){
                accountIds.add((Id) lt.get('LoyaltyAccount__c'));
            }
            
            System.debug('accountIds ' + accountIds);
            
            List<AggregateResult> pointsXAccount = [select LoyaltyAccount__c, SUM(Points__c) from LoyaltyTransaction__c 
                                                    where LoyaltyAccount__c IN :accountIds 
                                                    and Status__c = 'Approved' 
                                                    GROUP BY LoyaltyAccount__c];
        
            for(AggregateResult ar : pointsXAccount){
                Account loyaltyAccount = new Account(Id = (Id) ar.get('LoyaltyAccount__c'), PersonalClubPoints__c = (Decimal) ar.get('expr0'));
                accountsUpdateList.add(loyaltyAccount) ;
            }

            update accountsUpdateList;
        }catch(Exception e){
            System.debug('TransactionsTriggers:recalculateLoyaltyAccountPoints -> exception: '+e);
        }
    }
}