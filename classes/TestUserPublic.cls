@isTest(SeeAllData=true)
public class TestUserPublic {
    
    @isTest()
    public static void t(){

		Account cuenta = new Account();
		cuenta.name = 'a';
		cuenta.AccountIntegrationId__c = '998342333';
		cuenta.BillingIntegrationId__c = 62910;
		insert cuenta;

        Contact contacto = new Contact();
        contacto.lastname = 'contacto';
        contacto.accountid = cuenta.id; 
        insert contacto;
        
        User usuario = new User();
        
        usuario.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Telecom Personal Profile'].Id;
        usuario.LastName = 'last';
        usuario.Email = 'puser000@amamama.com';
        usuario.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        usuario.CompanyName = 'TEST';
        usuario.Title = 'title';
        usuario.Alias = 'alias';
        usuario.TimeZoneSidKey = 'America/Los_Angeles';
        usuario.EmailEncodingKey = 'UTF-8';
        usuario.LanguageLocaleKey = 'en_US';
        usuario.LocaleSidKey = 'en_US';
        usuario.isactive = true;
        insert usuario; 
        
        
        system.runAs(usuario){
            Map<String, Object> options = new Map<String, Object>();
            Map<String, Object> inputmap = new Map<String, Object>();
            Map<String, Object> outputmap = new Map<String, Object>();
            options.put('OrderId', '8016C0000000oCA');
            
            taSalesSimulationInvoiceHandler.Call_S013_Simulate_Calculate_Taxes(inputmap,outputmap,options);
            system.debug(outputmap);
        }
    }
}