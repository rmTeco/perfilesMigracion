trigger GP_DatosSociosFanTrigger on GP_Dato_Socio_FAN__c (before insert) {
        
        List<GP_Dato_Socio_FAN__c> itemsAInsertar = new List<GP_Dato_Socio_FAN__c>();
        List<GP_Dato_Socio_FAN__c> itemsABorrar = new List<GP_Dato_Socio_FAN__c>();
        for(GP_Dato_Socio_FAN__c item: trigger.new){
            if(item.Operacion__c == 'Insert'){
                itemsAInsertar.add(item);
            }
            if(item.Operacion__c == 'Delete'){
                itemsABorrar.add(item);
            }
        }
        
        if(itemsAInsertar.size()>0){
            gp_datosSociosTriggerUtils.darAlta(itemsAInsertar);
        }
        if(itemsABorrar.size()>0){
            gp_datosSociosTriggerUtils.darBaja(itemsABorrar);
        }
            
     
}