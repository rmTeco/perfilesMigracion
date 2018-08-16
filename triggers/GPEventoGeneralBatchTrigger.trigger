trigger GPEventoGeneralBatchTrigger on GP_Evento_General_Batch__c (before insert) {

    if(trigger.isBefore && trigger.isInsert){
        
        List<GP_sumarRestarPuntosItem> itemsSumarRestarPuntos = new List<GP_sumarRestarPuntosItem>();
        for(GP_Evento_General_Batch__c batch : Trigger.new){
            
            GP_AtributoBatchJson atributo = (GP_AtributoBatchJson)JSON.deserializeStrict(batch.JsonAtribute__c,GP_AtributoBatchJson.class);
            
            List<GP_AtributoValorDeUnEvento> listaDeAtributosValor = new List<GP_AtributoValorDeUnEvento>(); 
            System.debug('ATRIBUTOS: ' + atributo);
            for(GP_AtributoBatchJson.gp_atributos atr: atributo.listaDeAtributos){
                
                if(atr.TipoDeAtributo.equalsIgnoreCase('String')){
                    listaDeAtributosValor.add( New GP_AtributoValorDeUnEvento(atr.NombreDelAtributo, atr.TipoDeAtributo, atr.Valor));    
                }
                
                if(atr.TipoDeAtributo.equalsIgnoreCase('Boolean')){
                    listaDeAtributosValor.add( New GP_AtributoValorDeUnEvento(atr.NombreDelAtributo, atr.TipoDeAtributo, Boolean.valueOf(atr.Valor) ) );    
                }
                
                if(atr.TipoDeAtributo.equalsIgnoreCase('Integer')){
                    listaDeAtributosValor.add( New GP_AtributoValorDeUnEvento(atr.NombreDelAtributo, atr.TipoDeAtributo, Integer.valueOf(atr.Valor) ) );    
                }
            
                if(!atr.TipoDeAtributo.equalsIgnoreCase('String') && !atr.TipoDeAtributo.equalsIgnoreCase('Boolean') && !atr.TipoDeAtributo.equalsIgnoreCase('Integer')){
                    //Mostrar error.
                }
                
            }
            
            itemsSumarRestarPuntos.add( new GP_sumarRestarPuntosItem(batch.ID_Titular__c, batch.ID_Suscriptor__c, batch.Tipo_de_evento__c, null, listaDeAtributosValor) );                
                                    
        }
        System.debug('ITEMS: ' + itemsSumarRestarPuntos);
        
        gp_api.sumarRestarPuntos(itemsSumarRestarPuntos);
        
    }
    
    
}