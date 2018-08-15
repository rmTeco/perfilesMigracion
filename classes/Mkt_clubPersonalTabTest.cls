@isTest
public class Mkt_clubPersonalTabTest {
    
    @TestSetup
    static void prepareData(){
        Account ac = new Account(Name = 'Alberto', PersonalClubCategory__c = 'Classic');
        insert ac;
        
        Asset unAsset = new Asset();
        unAsset.MSISDN__c = '111111';
        unAsset.name = 'asd';
        unAsset.accountId = ac.id;
        unAsset.vlocity_cmt__BillingAccountId__c = ac.id;
        unAsset.vlocity_cmt__ServiceAccountId__c = ac.id;
        insert unAsset;
        
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('cuenta',ac.id);

        List<object> todosLosSocios = new List<object>();
        todosLosSocios.add(datosPrimerCuenta);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio',todosLosSocios);
        
        gp_adapter adapter = new gp_adapter();
        adapter.invokeMethod('crearAcumuladorSocioTitular', input, new Map<String,Object>(), new Map<String,Object>() );
    }
    
    @isTest
    static void invokeMethodTest() {
        try {
            Mkt_clubPersonalTab mkt = new Mkt_clubPersonalTab();
            mkt.invokeMethod('getAccountHeader', null, null, null);
        } catch (System.AssertException aex) {
            system.debug('Error');
        }
    }
    
    @isTest
    static void invokeMethodElseTest() {
        try {
            Mkt_clubPersonalTab mkt = new Mkt_clubPersonalTab();
            mkt.invokeMethod(null, null, null, null);
        } catch (System.AssertException aex) {
            system.debug('Error');
        }
    }
    
    @isTest
    static void getAccountHeaderTest(){
        Mkt_clubPersonalTab mkt = new Mkt_clubPersonalTab();
        List<Account> accList = [SELECT Id, PersonalClubCategory__c FROM Account LIMIT 1];
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> out = new Map<String, Object>();
        input.put('ContextId', accList.get(0).Id);
        mkt.getAccountHeader(input, out);
    }
}