trigger GPTriggerEventoGeneral on GP_Evento_General__c (before insert, before update) {
    
    if(trigger.isBefore){
        
        if(trigger.isInsert){
            
            Set<String> nombresDeEventosGenerales = new Set<String>();
            for(GP_Evento_General__c  eventoGeneral : trigger.new){
                
                if( nombresDeEventosGenerales.contains( eventoGeneral.name.toUpperCase() ) ){
                    throw new GP_APIException('Ya existe un evento con el nombre: '+eventoGeneral.name);
                }
                
                nombresDeEventosGenerales.add(eventoGeneral.name);
                
            }
            
            List<GP_Evento_General__c> eventosYaConEseNombre = [select id, name from GP_Evento_General__c where name in: nombresDeEventosGenerales];
            
            
            if(eventosYaConEseNombre.size()>0){
                String error = '';
                
                for(GP_Evento_General__c evento: eventosYaConEseNombre){
                   error += ' **Ya existe un evento con el nombre: '+evento.name; 
                }
                
                throw new GP_APIException(error);
            }
        
        }
        
       if(trigger.isUpdate){
           
           Set<String> nombresQueCambiaron = new Set<String>();
           for(GP_Evento_General__c  eventoGeneral : trigger.new){
               
               if(trigger.oldMap.get(eventoGeneral.id).name != eventoGeneral.name){
                  
                  if( nombresQueCambiaron.contains( eventoGeneral.name.toUpperCase() ) ){
                    throw new GP_APIException('Ya existe un evento con el nombre: '+eventoGeneral.name);
                  }
                  
                  nombresQueCambiaron.add(eventoGeneral.name);
               }
               
           }
           
           if(nombresQueCambiaron.size()>0){
               List<GP_Evento_General__c> eventosYaConEseNombre = [select id, name from GP_Evento_General__c where name in: nombresQueCambiaron];
            
            
               if(eventosYaConEseNombre.size()>0){
                    String error = '';
                
                    for(GP_Evento_General__c evento: eventosYaConEseNombre){
                        error += ' **Ya existe un evento con el nombre: '+evento.name; 
                    }
                
                    throw new GP_APIException(error);
                }
           }
       } 
        
    }
    
    
}