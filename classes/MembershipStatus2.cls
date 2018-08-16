global with sharing class MembershipStatus2 implements vlocity_cmt.VlocityOpenInterface{
    global MembershipStatus2() {}

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
        
        String cuenta = (String) inputMap.get('ContextId');
        
        Map<Id,Account> billingAccountsMap = new Map<Id,Account>([select Id, Name from Account where RecordType.developername = 'Billing' and ParentId = :cuenta]);

		List<AggregateResult> pointsXAccount = [select sum(Points__c), Asset__r.accountId from LoyaltyTransaction__c 
        									    where Asset__r.AccountId IN :billingAccountsMap.keySet() 
            								    group by Asset__r.accountId];

        system.debug(pointsXAccount);
        
        List<MembershipStatusWrapper> pointsXAccoutWR = new List<MembershipStatusWrapper>();
        
        for(AggregateResult ar : pointsXAccount){
            MembershipStatusWrapper mw = new MembershipStatusWrapper();
            
            Id accountId = (Id) ar.get('AccountId');
            
            Account ac = billingAccountsMap.get(accountId);
            
            mw.account = ac.Name;
            //mw.asset = (String) ar.get('Name');
            mw.puntos = (Decimal) ar.get('expr0');
            mw.puntosXVencer = 0;
            
            system.debug(mw);
            
            pointsXAccoutWR.add(mw);
        }
        
        outMap.put('bAccounts', pointsXAccoutWR);

        List<MembershipStatusWrapper> pointsXAssetWR = new List<MembershipStatusWrapper>();
        
		List<AggregateResult> pointsXAsset = [select sum(Points__c), Asset__c 
                                              from LoyaltyTransaction__c 
                                              where Asset__r.AccountId IN :billingAccountsMap.keySet()
                                              group by Asset__c];
                
        system.debug('Points por asset:' + pointsXAsset);

        set<Id> assetsIds = getAssetsIds(pointsXAsset);
        
        Map<Id,Asset> assetsMap = new Map<Id,Asset>([select Id, Name, AccountId from Asset where Id IN :assetsIds]);
        
        system.debug('assetsMap ' + assetsMap);

        for(AggregateResult ar : pointsXAsset){
            MembershipStatusWrapper mw = new MembershipStatusWrapper();
             
            Asset assetRecord = assetsMap.get((Id) ar.get('Asset__c'));
            
            Id accountId = (Id) assetRecord.get('AccountId');
            
            Account ac = billingAccountsMap.get(accountId);
            
            mw.account = ac.Name;
            mw.asset = (String) assetRecord.get('Name');
            mw.puntos = (Decimal) ar.get('expr0');
            mw.puntosXVencer = 0;
            
            system.debug(mw);
            
            pointsXAssetWR.add(mw);
        }
        
        outMap.put('assets', pointsXAssetWR);
        
        system.debug(pointsXAccount);
        system.debug(pointsXAsset);
    }
    
    global void getTransactions(Map<String, Object> inputMap, Map<String, Object> outMap){
        
        String cuenta = (String) inputMap.get('ContextId');
        Date fechaDesde;
        Date fechaHasta;
        
        //Map<String,Object> RPC = (Map<String,Object>) inputMap.get('ResumenDePuntosDeCuenta');
                                           
        //Object fd = (Object) RPC.get('DateDesde');
        //Object fh = (Object) RPC.get('DateHasta');
        /*
        if(fd != null && fh != null){
            fechaDesde = Date.valueOf((String) fd);
            fechaHasta = Date.valueOf((String) fh);
        }
        
        system.debug(inputMap);
        system.debug((String) fd);
        system.debug((String) fh);*/

        List<Account> billingAccounts = [select Id, Name from Account where RecordType.developername = 'Billing' and ParentId = :cuenta];
        
        List<LoyaltyTransaction__c> transactions = [select Name, Asset__r.Accountid,Asset__r.Name, Points__c, Description__c, TransactionDate__c
                                                    from LoyaltyTransaction__c
                                                    where Asset__r.AccountId IN :billingAccounts
													//and TransactionDate__c >= :fechaDesde
                                                    //and TransactionDate__c <= :fechaHasta 
                                                    order by TransactionDate__c desc
                                                  ];
        
        //List<MembershipStatusWrapper> pointsXTransWR = new List<MembershipStatusWrapper>();
        
        /*for(LoyaltyTransaction__c lt : transactions){
            MembershipStatusWrapper mw = new MembershipStatusWrapper();

            mw.account = (String) lt.get('AccountId');
            mw.asset = (String) lt.get('Asset__r.Name');
            mw.puntos = 0;
            mw.puntosXVencer = 0;
            
            system.debug(mw);
            
            pointsXTransWR.add(mw);
            
        }*/
        
		outMap.put('transactions', transactions);
    }
    
    public set<Id> getAssetsIds (List<AggregateResult> assets){
        set<Id> assetsIds = new set<Id>();
        Id astId;

        for(AggregateResult ast: assets){
            astId = (Id) ast.get('Asset__c');
            assetsIds.add(astId);
        }
        
        return assetsIds;
    }
    
    public class MembershipStatusWrapper{
        public String nombre {get;set;}
        public String account {get;set;}
        public String asset {get;set;}
        public Decimal puntos {get;set;}
        public Decimal puntosXVencer {get;set;}
        
        public MembershipStatusWrapper(){}
    }
}