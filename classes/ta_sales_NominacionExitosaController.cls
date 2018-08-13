public class ta_sales_NominacionExitosaController {
	public boolean loaded = false;
    public Id crossId{get; set;}
    public vlocity_cmt__BusinessSite__c store {get;set;}
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
            loadedCro = [SELECT Id, Order__c, Order__r.PickUpStoreLocation__c, Order__r.Account.Name, Order__r.Delivery_Method__c, Order__r.OrderNumber, Order__r.ShippingPostalCode, Order__r.ShippingCity, Order__r.ShippingStreet, Order__r.ShippingState FROM CrossObject__c WHERE Id = :crossId];
            Id storeId = loadedCro.Order__r.PickUpStoreLocation__c;
            store = [SELECT Id, Name, vlocity_cmt__StreetAddress__c, vlocity_cmt__State__c, vlocity_cmt__City__c, vlocity_cmt__Country__c, vlocity_cmt__PostalCode__c, vlocity_cmt__OperatingHoursId__r.HoraEntrada__c, vlocity_cmt__OperatingHoursId__r.HoraSalida__c, PostOfficeHours__c, PostOfficePhone__c FROM vlocity_cmt__BusinessSite__c WHERE Id = :storeId];
            horas = 'Horario de ' + store.vlocity_cmt__OperatingHoursId__r.HoraEntrada__c + 'hs a ' + store.vlocity_cmt__OperatingHoursId__r.HoraSalida__c + 'hs';
        }catch(Exception e){}
    }
}