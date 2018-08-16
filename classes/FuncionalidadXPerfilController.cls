public with sharing class FuncionalidadXPerfilController {
@AuraEnabled 
    
    public static List<Funcionalidad__c> getFuncionalidades() {
    	List<Funcionalidad__c> Funcs = [SELECT Id, Name FROM Funcionalidad__c];
        return Funcs;
    }    
    
    public static List<Profile> getProfiles(){
        List<Profile> Profiles = [SELECT Id, Name FROM Profile];
        return profiles;
    }
    
}