global with sharing class MembershipStatus implements vlocity_cmt.VlocityOpenInterface{
    global MembershipStatus() {}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        Boolean result = true; 

        try{
            if (methodName.equals('getMembershipStatus')){
                getMembershipStatus(inputMap,outMap);
            }
            else if(methodName.equals('getTransactions')){
                getTransactions(inputMap,outMap);
            }
            else{
                result = false;
            }   
        } 
        catch(Exception e){
            System.debug('BodyCPMail:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }
 
    public void getMembershipStatus(Map<String, Object> inputMap, Map<String, Object> outMap){
        try{
            String cuenta = (String) inputMap.get('ContextId');
            
            Map<Id,Account> billingAccountsMap = new Map<Id,Account>([select Id, Name 
                                                                      from Account 
                                                                      where RecordType.developername = 'Billing' and ParentId = :cuenta
                                                                      order by Name Desc
                                                                     ]);
    
            List<AggregateResult> pointsXAccount = [select sum(Points__c), Asset__r.accountId from LoyaltyTransaction__c 
                                                    where Asset__r.AccountId IN :billingAccountsMap.keySet()
                                                    and Status__c = 'Approved'
                                                    group by Asset__r.accountId
                                                   ];
    
            system.debug(pointsXAccount);
            
            List<BillingAccountWrapper> pointsXAccoutWR = new List<BillingAccountWrapper>();
            
            for(AggregateResult ar : pointsXAccount){
                BillingAccountWrapper billingAccountWrp = new BillingAccountWrapper();
                
                Id accountId = (Id) ar.get('AccountId');
                
                Account ac = billingAccountsMap.get(accountId);
                
                billingAccountWrp.accountName = ac.Name;
                billingAccountWrp.points = (Decimal) ar.get('expr0');
                billingAccountWrp.pointsToExpire = 0;
    
                pointsXAccoutWR.add(billingAccountWrp);
            }
            
            outMap.put('billingAccounts', pointsXAccoutWR);
    
            
            
            List<AssetWrapper> pointsXAssetWR = new List<AssetWrapper>();
            
            List<AggregateResult> pointsXAsset = [select sum(Points__c), Asset__c 
                                                  from LoyaltyTransaction__c 
                                                  where Asset__r.AccountId IN :billingAccountsMap.keySet()
                                                  and Status__c = 'Approved'
                                                  group by Asset__c];
                    
            system.debug('Points por asset:' + pointsXAsset);
    
            set<Id> assetsIds = getAssetsIds(pointsXAsset);
            
            Map<Id,Asset> assetsMap = new Map<Id,Asset>([select Id, Name, AccountId from Asset where Id IN :assetsIds order by Name Desc]);
            
            system.debug('assetsMap ' + assetsMap);
    
            for(AggregateResult ar : pointsXAsset){
                AssetWrapper assetWrp = new AssetWrapper();
                 
                Asset assetRecord = assetsMap.get((Id) ar.get('Asset__c'));
                
                Id accountId = (Id) assetRecord.get('AccountId');
                
                Account ac = billingAccountsMap.get(accountId);
                
                assetWrp.name = (String) assetRecord.get('Name');
                assetWrp.billingAccount = ac.Name;
                assetWrp.points = (Decimal) ar.get('expr0');
                assetWrp.pointsToExpire = 0;
                
                system.debug(assetWrp);
                
                pointsXAssetWR.add(assetWrp);
            } 

            pointsXAssetWR.sort();
            
            outMap.put('assets', pointsXAssetWR);
            
            system.debug(pointsXAccount);
            system.debug(pointsXAsset);
        }catch(Exception e){
            System.debug('getMembershipStatus:invokeMethod -> exception: '+e);
        }
    }
    
    void getTransactions(Map<String, Object> inputMap, Map<String, Object> outMap){
        try{
            String cuenta = (String) inputMap.get('ContextId');
            Set<Id> transactionsAccounts = new Set<Id>();
            Account billingAccount;
            
            List<Account> billingAccounts = [select Id, Name from Account where RecordType.developername = 'Billing' and ParentId = :cuenta];
    
            List<transactionWrapper> transactionsList = new List<transactionWrapper>();
                
            List<LoyaltyTransaction__c> transactions = [select Name, Asset__r.Accountid,Asset__r.Name, Points__c, Description__c, TransactionDate__c
                                                        from LoyaltyTransaction__c
                                                        where Asset__r.AccountId IN :billingAccounts
                                                        and Asset__r.Accountid != null
                                                        and Status__c = 'Approved'
                                                        order by TransactionDate__c desc, Name desc
                                                      ];
            
            for(LoyaltyTransaction__c tr : transactions){
                transactionsAccounts.add((Id) tr.getSobject('Asset__r').get('Accountid'));

            }
            System.debug('transactionsAccounts' + transactionsAccounts);
            
            Map<Id,Account> accountsMap = new Map<Id,Account>([select Id, Name from Account where Id IN :transactionsAccounts]);
            
            System.debug('accountsMap' + accountsMap);
            
            for(LoyaltyTransaction__c tran : transactions){
                transactionWrapper transactionWrp = new transactionWrapper();
                
                billingAccount = accountsMap.get((Id) tran.getSobject('Asset__r').get('Accountid'));
                    
                transactionWrp.transactionNumber = (String) tran.get('Name');
                transactionWrp.reason = (String) tran.get('Description__c');
                transactionWrp.transactionDate = (Date) tran.get('TransactionDate__c');
                transactionWrp.billingAccount = billingAccount.Name;
                transactionWrp.asset = (String) tran.getSobject('Asset__r').get('Name');
                transactionWrp.points = (Decimal) tran.get('Points__c');
                transactionWrp.pointsToExpire = 0;
                
                transactionsList.add(transactionWrp);
            }
            
            outMap.put('transactions', transactionsList);
    	}catch(Exception e){
            System.debug('getTransactions:invokeMethod -> exception: '+e);
        }
    }
    
    public set<Id> getAssetsIds (List<AggregateResult> assets){
        set<Id> assetsIds = new set<Id>();
        Id astId;
		
        try{
            for(AggregateResult ast: assets){
                astId = (Id) ast.get('Asset__c');
                assetsIds.add(astId);
            }
        }catch(Exception e){
            System.debug('getAssetsIds:invokeMethod -> exception: '+e);
        }
        return assetsIds;
    }

    public class BillingAccountWrapper{
        public String accountName {get;set;}
        public Decimal points {get;set;}
        public Decimal pointsToExpire {get;set;}
        
        public BillingAccountWrapper(){}
    }
    
    public class AssetWrapper implements Comparable{
        public String name {get;set;}
        public String billingAccount {get;set;}
        public Decimal points {get;set;}
        public Decimal pointsToExpire {get;set;}
        
        public AssetWrapper(){}
        
        public Integer compareTo(Object compareTo) {
            AssetWrapper compareToTran = (AssetWrapper)compareTo;
            if (this.billingAccount == compareToTran.billingAccount){
                if (this.name == compareToTran.name) return 0;
                if (this.name > compareToTran.name) return 1;
                return -1;
            }
            
            if (this.billingAccount > compareToTran.billingAccount) return 1;
            
            return -1;        
        }

    }
    
    public class TransactionWrapper {
        public String transactionNumber {get;set;}
        public String reason {get;set;}
        public Date transactionDate {get;set;}
        public String billingAccount {get;set;}
        public String asset {get;set;}
        public Decimal points {get;set;}
        public Decimal pointsToExpire {get;set;}
        
        public TransactionWrapper(){}
    }
}