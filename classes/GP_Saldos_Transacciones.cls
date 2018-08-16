Global with sharing class GP_Saldos_Transacciones {

    private static List<GP_Historia_transaccion__c> transaccionesAInsertar{get;set;}

    public static List<GP_Historia_transaccion__c> generarTransaccionActualizarSaldo(List<GP_datosTransaccion> datosTransaccion) {
        Set<String> idGPDeLosSocios = new Set<String>();
        Set<String> sociosQueRestan = new Set<String>();
        Set<String> EventosTotalesDeLosQueParticipan = new Set<String>();
        String idGPAUX;
        
        system.debug(datosTransaccion);
        
        for(GP_datosTransaccion datos : datosTransaccion) {
            
            EventosTotalesDeLosQueParticipan.add(datos.tipoEvento);
            
            if(datos.suscriptorID == '0' || String.isBlank(datos.suscriptorID)){
                idGPAUX = datos.titularId+'0';
            }else{
                idGPAUX = datos.suscriptorID + datos.titularId;
            }
            
            /*
            if(!String.isBlank(datos.suscriptorID)) {
                idGPAUX = datos.suscriptorID + datos.titularId;
            } else {
                idGPAUX = datos.titularId + '0';
            }*/
            
            if(!idGPDeLosSocios.contains(idGPAUX)){
                idGPDeLosSocios.add(idGPAUX);
                if (datos.operacion == 'Resta'){
                    sociosQueRestan.add(idGPAUX);
                }
            }
        }

        String error = '';
        Date hoy = Date.Today();
        transaccionesAInsertar = new List<GP_Historia_transaccion__c>();
        List<GP_Saldo_por_vencimiento__c> saldosActualizar = new List<GP_Saldo_por_vencimiento__c>();
        List<GP_Saldo_por_vencimiento__c> saldosAInsertar = new List<GP_Saldo_por_vencimiento__c>();
        List<GP_Control_de_evento__c> ctrlEventosAUpsertar = new List<GP_Control_de_evento__c>();
        List<GP_Socio__c> sociosActualizar = new List<GP_Socio__c>();

        //Consigo los socios que realizan las transacciones
        List<GP_Socio__c> socios = [Select Id, Name, Saldo_total__c, Id_GP__c
                                    From GP_Socio__c 
                                    Where Id_GP__c in: idGPDeLosSocios AND Activo__c = true];
        Map<String, GP_Socio__c> sociosMap = new Map<String, GP_Socio__c>();
        if(socios.size() > 0) {
            for(GP_Socio__c sc: socios) {
                if(!sociosMap.containsKey(sc.Id_GP__c)) {
                    sociosMap.put(sc.Id_GP__c,sc);
                }
            }
        } else {
            error += ' ** Error: No se encontró ningún socio con el o los Ids ingresados.';
            throw new GP_Saldos_TransaccionesException(error);
        }
        //System.debug('MAPA: ' + sociosMap);

        //Consigo las restricciones por frecuencia de eventos del socio
        List<GP_Control_de_evento__c> ctrlEventos = [   Select Id,Cant_consecutiva__c,Fecha_ultimo_evento__c,Socio__c,Tipo_de_evento__c, Socio__r.Id_GP__c 
                                                        From GP_Control_de_evento__c 
                                                        Where Socio__r.Id_GP__c in: idGPDeLosSocios and Tipo_de_evento__c in:EventosTotalesDeLosQueParticipan];
                                                        
        Map<String,GP_Control_de_evento__c> ctrlEventosMap = new Map<String,GP_Control_de_evento__c>();
        if(ctrlEventos.size() > 0) {
            for(GP_Control_de_evento__c cEvent : ctrlEventos) {
                if(cEvent.Tipo_de_evento__c != null) {
                    ctrlEventosMap.put(cEvent.Tipo_de_evento__c+cEvent.Socio__r.Id_GP__c,cEvent);
                }
            }
        }

        //Consigo los saldos de los socios que realicen uno o más consumos
        List<GP_Saldo_por_vencimiento__c> saldos = [Select Id, Puntos__c, Socio__c From GP_Saldo_por_vencimiento__c 
                                                    Where Socio__r.Id_GP__c in: sociosQueRestan AND (Vencimiento__c >=: hoy OR vencimiento__C = null) Order By Vencimiento__c ASC NULLS LAST];
        
        system.debug(saldos);
        
        Map<String, List<GP_Saldo_por_vencimiento__c>> saldosMap = new Map<String, List<GP_Saldo_por_vencimiento__c>>();
        if(saldos.size() > 0) {
            for(GP_Saldo_por_vencimiento__c saldo : saldos) {
                if(saldosMap.get(saldo.Socio__c) == null){
                    List<GP_Saldo_por_vencimiento__c> saldosAux = new List<GP_Saldo_por_vencimiento__c>();
                    saldosAux.add(saldo);
                    saldosMap.put(saldo.Socio__c, saldosAux);
                } else {
                    saldosMap.get(saldo.Socio__c).add(saldo);
                }
            }
        }
        
        for(GP_datosTransaccion datos : datosTransaccion) {

            GP_Socio__c socio = new GP_Socio__c();
            String gpIdAUX;
            if(datos.suscriptorID == '0' || String.isBlank(datos.suscriptorID)) {
                gpIdAUX = datos.titularId + '0';
            } else {
                gpIdAUX = datos.suscriptorId + datos.titularId;
            }
            //System.debug('IDGP:' + idGPAUX);
            
            if(sociosMap.containsKey(gpIdAUX)) {
                socio = sociosMap.get(gpIdAUX);
            }else{
                throw new GP_APIException('No existe un socio activo con el id: '+gpIdAUX); 
            }
            
            Double saldoAnterior = 0;
            if(socio.Saldo_total__c != null) {
                saldoAnterior = socio.Saldo_total__c;
            }
            if (sociosActualizar.contains(socio)) {
                sociosActualizar.remove(sociosActualizar.indexOf(socio));
            }
            if (datos.operacion == 'Suma') {
                GP_Saldo_por_vencimiento__c saldoIns = actualizaSaldos(socio, datos.puntos, datos.vencimiento);
                saldosAInsertar.add(saldoIns);

                /* System.debug('MAPA SOCIOS: ' + sociosMap);
                System.debug('SOCIO: '  + socio);
                System.debug('IDSGP: ' + gpIdAUX); */

                // Lo agrego a la lista de saldos para poder consumir en futuras transacciones.
                if(saldosMap.get(saldoIns.Socio__c) == null){
                    List<GP_Saldo_por_vencimiento__c> saldosAux = new List<GP_Saldo_por_vencimiento__c>();
                    saldosAux.add(saldoIns);
                    saldosMap.put(saldoIns.Socio__c, saldosAux);
                } else {
                    saldosMap.get(saldoIns.Socio__c).add(saldoIns);
                }
                //Actualizacion de saldo total del socio
                if (socio.Saldo_total__c != null) {
                    socio.Saldo_total__c += datos.puntos;
                } else {
                    socio.Saldo_total__c = datos.puntos;
                }
                crearTransaccion(datos, saldoAnterior, socio);
            } else if (datos.operacion == 'Resta') {
                /* System.debug('Socio : ' + socio);
                System.debug('Datos : ' + datos); */
                if(socio.Saldo_total__c >= datos.puntos) {
                    saldosActualizar.addAll( consumirSaldos(socio, datos, saldosMap) );
                } else {
                    error += ' ** Error: El socio de Id: \'' + socio.Id + '\' no posee puntos suficientes para realizar la transacción';
                }
            }

            //Sumar a la frecuencia del evento
            GP_Control_de_evento__c ctrlEventosAux = new GP_Control_de_evento__c();
            if (ctrlEventosMap.get(datos.tipoEvento+datos.idGP) != null) {
                ctrlEventosAux = ctrlEventosMap.get(datos.tipoEvento+datos.idGP);
                ctrlEventosAux.Fecha_ultimo_evento__c = hoy;
                ctrlEventosAux.Cant_consecutiva__c++;
            } else {
                ctrlEventosAux.Tipo_de_evento__c = datos.tipoEvento;
                ctrlEventosAux.Fecha_ultimo_evento__c = hoy;
                ctrlEventosAux.Cant_consecutiva__c = 0;
                ctrlEventosAux.Socio__c = socio.Id;
                
                ctrlEventosMap.put(datos.tipoEvento+datos.idGP, ctrlEventosAux);
            }
            
            sociosActualizar.add(socio);
        }
        ctrlEventosAUpsertar.addAll(ctrlEventosMap.values());
        
        if(error != ''){
           throw new GP_Saldos_TransaccionesException(error);
        }
        if (sociosActualizar.size() > 0) {
            system.debug(sociosActualizar);
            update sociosActualizar;
        }
        if (saldosAInsertar.size() > 0) {
            insert saldosAInsertar;
        }
        if (saldosActualizar.size() > 0) {
            upsert saldosActualizar;
        }
        if (transaccionesAInsertar.size() > 0) {
            insert transaccionesAInsertar;
        }
        if (ctrlEventosAUpsertar.size() > 0) {
            system.debug(ctrlEventosAUpsertar);
            upsert ctrlEventosAUpsertar;
            
        }
        return transaccionesAInsertar;
    }

    public static void crearTransaccion(GP_datosTransaccion datosTr, Double saldoAnterior, GP_Socio__c socio) {
            GP_Historia_transaccion__c transaccion = new GP_Historia_transaccion__c(
            Socio__c = socio.Id,                                //Socio
            Generado_por__c = datosTr.reglaId,                  //Regla que lo genera
            Puntos__c = datosTr.puntos,                         //Puntos calculados
            Saldo_anterior__c = saldoAnterior,                  //Saldo anterior a la transacción
            Nuevo_saldo__c = socio.Saldo_total__c,              //Saldo posterior a la transacción
            Fecha_transaccion__c = Datetime.now(),              //Fecha y hora de transacción
            Suma_o_resta__c = datosTr.operacion,                //Operación realizada (suma/resta)
            Tipo_de_evento__c = datosTr.tipoEvento,             //Evento de transacción
            Numero_de_orden__c = datosTr.numeroDeOrden,         //Numero de orden de operación
            Vencimiento__c = datosTr.vencimiento);              //Fecha de vencimiento de puntos

            transaccionesAInsertar.add(transaccion);
    }

    public static void crearTransaccion(GP_datosTransaccion datosTr, Double saldoAnterior, GP_Socio__c socio, Double puntos){
            GP_Historia_transaccion__c transaccion = new GP_Historia_transaccion__c(
            Socio__c = socio.Id,                                //Socio
            Generado_por__c = datosTr.reglaId,                  //Regla que lo genera
            Puntos__c = puntos,                                 //Puntos calculados
            Saldo_anterior__c = saldoAnterior,                  //Saldo anterior a la transacción
            Nuevo_saldo__c = socio.Saldo_total__c,              //Saldo posterior a la transacción
            Fecha_transaccion__c = Datetime.now(),              //Fecha y hora de transacción
            Suma_o_resta__c = datosTr.operacion,                //Operación realizada (suma/resta)
            Tipo_de_evento__c = datosTr.tipoEvento,             //Evento de transacción
            Numero_de_orden__c = datosTr.numeroDeOrden,         //Numero de orden de operación
            Vencimiento__c = datosTr.vencimiento);              //Fecha de vencimiento de puntos

            transaccionesAInsertar.add(transaccion);
    }

    public static GP_Saldo_por_vencimiento__c actualizaSaldos(GP_Socio__c socio, Double puntos, Date vencimiento) {
        GP_Saldo_por_vencimiento__c saldo = new GP_Saldo_por_vencimiento__c(Puntos__c = puntos, Socio__c = socio.Id, Vencimiento__c = vencimiento);
        return saldo;
    }

    public static List<GP_Saldo_por_vencimiento__c> consumirSaldos(GP_Socio__c socio, GP_datosTransaccion datos, Map<String, List<GP_Saldo_por_vencimiento__c>> saldosMap) {
        //Actualizacion de saldos por vencimiento
        system.debug(datos.puntos);
        List<GP_Saldo_por_vencimiento__c> saldosPorVencimiento = saldosMap.get(socio.Id);
        Double puntosAConsumirAUX = datos.puntos;
        Double puntosConsumidos = 0;
        Double saldoAnterior = 0;
        List<GP_Saldo_por_vencimiento__c> saldosActualizar = new List<GP_Saldo_por_vencimiento__c>();
        
        
        system.debug(saldosPorVencimiento);
        
        for (GP_Saldo_por_vencimiento__c saldo : saldosPorVencimiento) {
            
            if (puntosAConsumirAUX > 0) {
                if(saldo.puntos__c != 0){
                    if (saldo.Puntos__c < puntosAConsumirAUX) {
                        //El saldo es menor a los puntos a consumir
                        puntosAConsumirAUX -= (Integer)saldo.Puntos__c;
                        puntosConsumidos = saldo.Puntos__c;
                        saldo.Puntos__c = 0;
                    } else if(saldo.Puntos__c >= puntosAConsumirAUX) {
                        //El saldo es mayor o igual a los puntos a consumir
                        saldo.Puntos__c -= puntosAConsumirAUX;
                        puntosConsumidos = puntosAConsumirAUX;
                        puntosAConsumirAUX = 0;
                    }
                    
                    //Actualizacion de saldo total del socio y creación de Transacción
                    saldoAnterior = socio.Saldo_total__c;
                    socio.Saldo_total__c -= puntosConsumidos;
                    crearTransaccion(datos, saldoAnterior, socio, puntosConsumidos);
                    saldosActualizar.add(saldo);
                }
            } else {
                break;
            }
        }
        return saldosActualizar;
    }

}