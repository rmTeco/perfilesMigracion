trigger Gp_AccumulationTrigger on GP_ACCUMULATION_RECHARGE__c (before insert) {

    if(trigger.isBefore && trigger.isInsert){
        
        //Me fijo que exista el control de evento
        Set<String> tiposDeRecarga = new Set<String>{'Premio Recarga 3M','Castigo Recarga'};
        List<GP_Evento_descriptor__c> eventosDesc = 
            [Select Id, Tipo_de_evento__c, Frecuencia_permitida__c
             From GP_Evento_descriptor__c
             Where Tipo_de_evento__c in : tiposDeRecarga ];

        Set<String> setEventos = new Set<String>();
        if(eventosDesc.size() > 0) {
            for(GP_Evento_descriptor__c ev : eventosDesc) {
                if(!setEventos.contains(ev.Tipo_de_evento__c)) {
                    setEventos.add(ev.Tipo_de_evento__c);
                }
            }
        }
        GP_Evento_descriptor__c eventoInsert = new GP_Evento_descriptor__c();
        List<GP_Evento_descriptor__c> eventosAInsertar = new List<GP_Evento_descriptor__c>();
        if(!setEventos.contains('Premio Recarga 3M')) {
            eventoInsert = new GP_Evento_descriptor__c();
            eventoInsert.Tipo_de_evento__c = 'Premio Recarga 3M';
            eventoInsert.Frecuencia_permitida__c = 'Tres Meses';
            eventosAInsertar.add(eventoInsert);
        }
        if(!setEventos.contains('Castigo Recarga')) {
            eventoInsert = new GP_Evento_descriptor__c();
            eventoInsert.Tipo_de_evento__c = 'Castigo Recarga';
            eventoInsert.Frecuencia_permitida__c = 'Tres Meses';
            eventosAInsertar.add(eventoInsert);
        }
        if(eventosAInsertar.size() > 0) {
            insert eventosAInsertar;
        }

        //Por un lado llamo al sumar y restar puntos por el evento Recarga por Monto.
        List<String> suscriberIds = new List<String>();
        for(GP_ACCUMULATION_RECHARGE__c batch : Trigger.new){
            
            if(batch.Monto__c == null){
                throw new GP_APIException('Error: ** El campo Monto__c es obligatorio.');
            }
            if( String.isBlank(batch.Categoria__c) ){
                throw new GP_APIException('Error: ** El campo Categoria__c es obligatorio.');
            }
            if( String.isBlank(batch.Suscripcion__c) ){
                throw new GP_APIException('Error: ** El campo Suscripcion__c es obligatorio.');
            }
            if( String.isBlank(batch.Tipo_de_Cliente__c) ){
                throw new GP_APIException('Error: ** El campo Tipo_de_Cliente__c es obligatorio.');
            }
            
            suscriberIds.add(batch.Suscripcion__c);
        }
        
        
        List<GP_Lista_de_Asset__c> assetsGP = new List<GP_Lista_de_Asset__c>();
        assetsGP = [select id, Puntos_acumulados_mes_0__c, Puntos_acumulados_mes_1__c, Puntos_acumulados_mes_2__c, Puntos_acumulados_mes_3__c, Total_Puntos_Acumulados__c,
                    suscriber_id__c, Socio__r.id_gp__c, Socio__r.cuenta__c, socio__r.Socio_padre__r.cuenta__c, Socio__c, socio__r.Saldo_total__c
                    from GP_Lista_de_Asset__c where suscriber_id__c in: suscriberIds];
                    
        Map<String, GP_Lista_de_Asset__c> mapaAssetsGPPorSuscriberId = new Map<String, GP_Lista_de_Asset__c>();
        Set<String> gpIdsCtrlEvento = new Set<String>();

        for(GP_Lista_de_Asset__c ass: assetsGP){
            mapaAssetsGPPorSuscriberId.put(ass.suscriber_id__c, ass);
            if(!gpIdsCtrlEvento.contains(ass.Socio__r.id_gp__c)) {
                gpIdsCtrlEvento.add(ass.Socio__r.id_gp__c);
            }
        }
        
        List<GP_sumarRestarPuntosItem> itemsSumarRestarPuntos = new List<GP_sumarRestarPuntosItem>();
        List<GP_Lista_de_Asset__c> assetsAActualizar = new List<GP_Lista_de_Asset__c>();
        List<GP_Historia_transaccion__c> transaccionesDeBajaACargar = new List<GP_Historia_transaccion__c>();
        List<String> idsSociosAEliminarSaldos = new List<String>();
        for(GP_ACCUMULATION_RECHARGE__c batch : Trigger.new){
            
            if(mapaAssetsGPPorSuscriberId.get(batch.Suscripcion__c) != null){
                
                String idSuscriptor = mapaAssetsGPPorSuscriberId.get(batch.Suscripcion__c).Socio__r.cuenta__c;
                String idTitular = mapaAssetsGPPorSuscriberId.get(batch.Suscripcion__c).socio__r.Socio_padre__r.cuenta__c;
                List<GP_AtributoValorDeUnEvento> listaDeAtributosValor = new List<GP_AtributoValorDeUnEvento>(); 
                
                listaDeAtributosValor.add( New GP_AtributoValorDeUnEvento('Categoria de Socio', 'String', batch.Categoria__c));    
                listaDeAtributosValor.add( New GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', batch.Tipo_de_Cliente__c));
                listaDeAtributosValor.add( New GP_AtributoValorDeUnEvento('Monto', 'Integer', Integer.valueOf(batch.Monto__c) ));
                
                if(batch.monto__c > 0){

                    if(idTitular == null){
                      itemsSumarRestarPuntos.add( new GP_sumarRestarPuntosItem( idSuscriptor, 
                      '0', 'Recarga por Monto', null, listaDeAtributosValor) );    
                    }else{
                      itemsSumarRestarPuntos.add( new GP_sumarRestarPuntosItem( idTitular, 
                      idSuscriptor, 'Recarga por Monto', null, listaDeAtributosValor) );                 
                    }
                
                }
                
                GP_Lista_de_Asset__c assetGP = mapaAssetsGPPorSuscriberId.get(batch.Suscripcion__c);
                
                assetGP.Puntos_acumulados_mes_0__c = assetGP.Puntos_acumulados_mes_1__c;
                assetGP.Puntos_acumulados_mes_1__c = assetGP.Puntos_acumulados_mes_2__c;
                assetGP.Puntos_acumulados_mes_2__c = assetGP.Puntos_acumulados_mes_3__c;
                assetGP.Puntos_acumulados_mes_3__c = batch.monto__c;
                
                if(assetGP.Total_Puntos_Acumulados__c != null){
                    assetGP.Total_Puntos_Acumulados__c += batch.monto__c;    
                }else{
                    assetGP.Total_Puntos_Acumulados__c = batch.monto__c;
                }
                
                if(assetGP.Puntos_acumulados_mes_3__c == null || assetGP.Puntos_acumulados_mes_1__c == null || assetGP.Puntos_acumulados_mes_2__c == null){
                    
                }else{
                    if(assetGP.Puntos_acumulados_mes_1__c > 0 &&  assetGP.Puntos_acumulados_mes_2__c > 0 && assetGP.Puntos_acumulados_mes_3__c > 0){
                        //Premiar ver que onda con el tema de que esta premiacion debe tener un control de eventos que si o si debe ser de 3 meses.
                        if(idTitular == null){
                          itemsSumarRestarPuntos.add( new GP_sumarRestarPuntosItem( idSuscriptor, '0', 'Premio Recarga 3M', null, listaDeAtributosValor) );    
                        }else{
                          itemsSumarRestarPuntos.add( new GP_sumarRestarPuntosItem( idTitular, idSuscriptor, 'Premio Recarga 3M', null, listaDeAtributosValor) );                 
                        }
                        
                    }else{
                        if(assetGP.Puntos_acumulados_mes_0__c == null && assetGP.Puntos_acumulados_mes_1__c == 0 &&  assetGP.Puntos_acumulados_mes_2__c == 0 
                        && assetGP.Puntos_acumulados_mes_3__c == 0){
                            //Avisar castigo.
                            batch.avisar_castigo__c = true;
                        }else{
                            if(assetGP.Puntos_acumulados_mes_0__c == 0 && assetGP.Puntos_acumulados_mes_1__c == 0 &&  assetGP.Puntos_acumulados_mes_2__c == 0 
                            && assetGP.Puntos_acumulados_mes_3__c == 0){
                                //Te castigo.
                                assetGP.Puntos_acumulados_mes_0__c = null;
                                assetGP.Puntos_acumulados_mes_1__c = null;
                                assetGP.Puntos_acumulados_mes_2__c = null;
                                assetGP.Puntos_acumulados_mes_3__c = null;

                                transaccionesDeBajaACargar.add(new GP_Historia_transaccion__c(socio__c = assetGP.Socio__c, 
                                                                 Puntos__c = assetGP.socio__r.Saldo_total__c, 
                                                                 Suma_o_resta__c = 'Resta',
                                                                 Tipo_de_evento__c = 'Castigo Recarga'));
                        
                                idsSociosAEliminarSaldos.add(assetGP.Socio__r.id_gp__c);                    
                                
                            }
                        }
                    }
                }
            
                assetsAActualizar.add(assetGP);
            }                    
        }
        
        if(assetsAActualizar.size()>0){
            update assetsAActualizar;
        }
        
        if(idsSociosAEliminarSaldos.size()>0){
            delete [select id from GP_Saldo_por_vencimiento__c where Socio__r.id_gp__c in: idsSociosAEliminarSaldos];
            insert transaccionesDeBajaACargar;
        }
        
        gp_api.sumarRestarPuntos(itemsSumarRestarPuntos);
    }

}