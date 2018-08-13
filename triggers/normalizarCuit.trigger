trigger normalizarCuit on Account (Before insert, Before update) {
    
    if(trigger.isBefore){
        
        if(trigger.isInsert){
            
            for(Account cuenta : trigger.new){
                
                if(cuenta.CuitNumber__c != null){
                    cuenta.SCP_Certa_GC__CUIT__c = cuenta.CuitNumber__c;
                }else{
                    if(cuenta.SCP_Certa_GC__CUIT__c != null){
                        cuenta.CuitNumber__c = cuenta.SCP_Certa_GC__CUIT__c;    
                    }
                }
                
            }

        }
        
       if(trigger.isUpdate){
           
           for(Account cuenta : trigger.new){
               
               if(trigger.oldMap.get(cuenta.id).CuitNumber__c != cuenta.CuitNumber__c){
                  cuenta.SCP_Certa_GC__CUIT__c = cuenta.CuitNumber__c;
               }else{
                   if(trigger.oldMap.get(cuenta.id).SCP_Certa_GC__CUIT__c != cuenta.SCP_Certa_GC__CUIT__c){
                      cuenta.CuitNumber__c = cuenta.SCP_Certa_GC__CUIT__c;
                    }
               }
               
           }
       }
           
         
        
    }
    
}