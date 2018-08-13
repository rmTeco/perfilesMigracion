public class ta_sales_DetallesDePickupController{

    public boolean loaded = false;
    public Id crossId{get; set;}
    public String address{get;set;}
    public String horas{get;set;}
    
    public CrossObject__c loadedCro{ get{
        if(!loaded){
            loadValues();
            loaded = true;
        }
        return loadedCro;
        }  set;
    }
     
    public void loadValues() {
        loaded = true;
        try{
            loadedCro = [SELECT Id, Order__c, Order__r.PickUpStoreLocation__c FROM CrossObject__c WHERE Id = :crossId];
            Id storeId = loadedCro.Order__r.PickUpStoreLocation__c;
            vlocity_cmt__BusinessSite__c store = [SELECT Id, vlocity_cmt__StreetAddress__c, vlocity_cmt__State__c, vlocity_cmt__City__c, vlocity_cmt__Country__c, vlocity_cmt__OperatingHoursId__r.HoraEntrada__c, vlocity_cmt__OperatingHoursId__r.HoraSalida__c FROM vlocity_cmt__BusinessSite__c WHERE Id = :storeId];
            address = store.vlocity_cmt__StreetAddress__c + ', ' + store.vlocity_cmt__City__c + ', ' + store.vlocity_cmt__State__c + ', ' + store.vlocity_cmt__Country__c;
            horas = 'Horario de ' + store.vlocity_cmt__OperatingHoursId__r.HoraEntrada__c + 'hs a ' + store.vlocity_cmt__OperatingHoursId__r.HoraSalida__c + 'hs';
            //vlocity_cmt__OperatingHours__c
        }catch(Exception e){}
    }
}