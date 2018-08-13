@isTest
public class normalizarCuitTest {

    @isTest 
    public static void InsertoUnaCuentaConCuitVlocity(){
        
        Account cuenta = new Account();
        cuenta.name = 'ter';
        cuenta.CuitNumber__c = 2037000000;
        insert cuenta;
        
    }
    
    @isTest 
    public static void InsertoUnaCuentaConSCP(){
        
        Account cuenta = new Account();
        cuenta.name = 'ter';
        cuenta.SCP_Certa_GC__CUIT__c = 2037000000;
        insert cuenta;
        
    }
    
    @isTest
    public static void ActualizoUnaCuentaConCuitVlocity(){
        
        Account cuenta = new Account();
        cuenta.name = 'ter';
        insert cuenta;
        
        cuenta.CuitNumber__c = 2037000000;
        update cuenta;
        
    }
    
    @isTest
    public static void ActualizoUnaCuentaConCuitSCP(){
        
        Account cuenta = new Account();
        cuenta.name = 'ter';
        insert cuenta;
        
        cuenta.SCP_Certa_GC__CUIT__c = 2037000000;
        update cuenta;
        
    }

}