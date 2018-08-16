@isTest
public class IFS_S461Test {

    static testMethod void getLoyaltyPointsTestPorSubscriptionID() {
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        insert cuenta;
        
        Asset unAsset = new Asset();
		unAsset.MSISDN__c = '111111';
        unAsset.name = 'asd';
        unAsset.accountId = cuenta.id;
        unAsset.Subscription_Id__c = '123';
        unAsset.vlocity_cmt__BillingAccountId__c = cuenta.id;
        unAsset.vlocity_cmt__ServiceAccountId__c = cuenta.id;
        insert unAsset;
        
        GP_Socio__c socioTitular = new GP_Socio__c();
        socioTitular.activo__c = true;
        socioTitular.cuenta__c = cuenta.id;
        socioTitular.Saldo_total__c = 0;
        insert socioTitular;
        
        GP_Lista_de_Asset__c UnAssetGP = new GP_Lista_de_Asset__c();
        UnAssetGP.Asset__c = unAsset.id;
        unAssetGP.Socio__c = socioTitular.id;
        insert unAssetGP;
        
        IFS_S461.choice choices = new IFS_S461.choice();
        choices.subscriberId = '123';
        
        IFS_S461.Request pedido = new IFS_S461.Request();
        pedido.choiceID = choices;
        
        IFS_S461.getLoyaltyPoints(pedido);
    }
    
    static testMethod void getLoyaltyPointsTestPorMSISDN() {
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        insert cuenta;
        
        Asset unAsset = new Asset();
		unAsset.MSISDN__c = '111111';
        unAsset.name = 'asd';
        unAsset.accountId = cuenta.id;
        unAsset.Subscription_Id__c = '123';
        unAsset.vlocity_cmt__BillingAccountId__c = cuenta.id;
        unAsset.vlocity_cmt__ServiceAccountId__c = cuenta.id;
        insert unAsset;
        
        GP_Socio__c socioTitular = new GP_Socio__c();
        socioTitular.activo__c = true;
        socioTitular.cuenta__c = cuenta.id;
        socioTitular.Saldo_total__c = 0;
        insert socioTitular;
        
        GP_Lista_de_Asset__c UnAssetGP = new GP_Lista_de_Asset__c();
        UnAssetGP.Asset__c = unAsset.id;
        unAssetGP.Socio__c = socioTitular.id;
        insert unAssetGP;
        
        IFS_S461.choice choices = new IFS_S461.choice();
        choices.numeroLinea = '111111';
        
        IFS_S461.Request pedido = new IFS_S461.Request();
        pedido.choiceID = choices;
        
        IFS_S461.getLoyaltyPoints(pedido);
    }
}