@isTest
public class GPTriggerEventoGeneralTest {

    static testMethod void insertoUnEventoGeneral(){
        GP_Evento_General__c evento = new GP_Evento_General__c();
        evento.name = 'asd';
        insert evento;
        
        GP_Evento_General__c evento2 = new GP_Evento_General__c();
        evento2.name = 'asd';
        
        try{
            insert evento2;
        }catch(Exception e){
            system.debug(e.getCause());
        }
        
        GP_Evento_General__c evento3 = new GP_Evento_General__c();
        evento3.name = 'asd2';
        
        GP_Evento_General__c evento4 = new GP_Evento_General__c();
        evento4.name = 'asd2';
        
        List<GP_Evento_General__c> eventosAInsertar = new List<GP_Evento_General__c>();
        eventosAInsertar.add(evento3);
        eventosAInsertar.add(evento4);
        
        try{
            insert eventosAInsertar;
        }catch(Exception e){
            system.debug(e.getCause());
        }
        
        
        
    }
    
    static testMethod void UpdateoUnEventoGeneral(){
        GP_Evento_General__c evento = new GP_Evento_General__c();
        evento.name = 'asd';
        insert evento;
        
        GP_Evento_General__c evento2 = new GP_Evento_General__c();
        evento2.name = 'asdd';
        
        try{
            insert evento2;
        }catch(Exception e){
            system.debug(e.getCause());
        }
        
        evento2.name = 'asd';
        
        try{
            update evento2;
        }catch(Exception e){
            system.debug(e.getCause());
        }
        
        GP_Evento_General__c evento3 = new GP_Evento_General__c();
        evento3.name = 'asd2';
        
        GP_Evento_General__c evento4 = new GP_Evento_General__c();
        evento4.name = 'asd2';
        
        List<GP_Evento_General__c> eventosAInsertar = new List<GP_Evento_General__c>();
        eventosAInsertar.add(evento3);
        eventosAInsertar.add(evento4);
        
        try{
            insert eventosAInsertar;
        }catch(Exception e){
            system.debug(e.getCause());
        }
        
    }
}