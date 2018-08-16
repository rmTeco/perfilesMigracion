public with sharing class GP_ControlDeEventos{

    public static List<GP_sumarRestarPuntosItem> controlarSocios(List<GP_sumarRestarPuntosItem> datosTransaccion) {
        List<GP_sumarRestarPuntosItem> datosFiltrados = new List<GP_sumarRestarPuntosItem>();

        List<GP_Evento_descriptor__c> descEventos = new List<GP_Evento_descriptor__c>();
        Map<String,GP_Evento_descriptor__c> descEventoMap = new Map<String,GP_Evento_descriptor__c>();
        List<GP_Control_de_evento__c> ctrlEventos = new List<GP_Control_de_evento__c>();
        Map<String,GP_Control_de_evento__c> ctrlEventoMap = new Map<String,GP_Control_de_evento__c>();

        String error = '';
        String idGPAUX;
        Set<String> idGPSocios = new Set<String>();
        Set<String> idsSocios = new Set<String>();
        Map<String,GP_Socio__c> sociosMap = new Map<String,GP_Socio__c>();
        Set<String> tiposDeEvento = new Set<String>();

        //Contiene los datos socio y evento (concatenados) que ya fueron procesados en la ejecución actual.
        List<String> listaSocioEvento = new List<String>();
        listaSocioEvento.add('notNull');

        //Preparo los sets para las queries
        for(GP_sumarRestarPuntosItem datos : datosTransaccion) {
           
            if(!String.isBlank(datos.suscriptorID) && datos.suscriptorID != '0') {
                idGPAUX = datos.suscriptorID + datos.titularId;
            } else {
                idGPAUX = datos.titularId + '0';    //Quizas se borre el '0'
            }
            
            system.debug(idGPAUX);
            
            if(!idGPSocios.contains(idGPAUX)) {
                idGPSocios.add(idGPAUX);
            }
            
            if(datos.tipoDeEvento != null && !tiposDeEvento.contains(datos.tipoDeEvento)) {
                tiposDeEvento.add(datos.tipoDeEvento);
            }
        }

        //Consigo las reglas de control de eventos
        if(tiposDeEvento.size() > 0) {
            descEventos = [ Select Id,Tipo_de_evento__c,Frecuencia_permitida__c
                            From GP_Evento_descriptor__c 
                            Where Tipo_de_evento__c in: tiposDeEvento];
        } else {
            error += 'El Tipo de Evento es obligatorio y no acepta valor nulo ++ ';
        }
        if(descEventos.size() > 0) {
            for(GP_Evento_descriptor__c descriptor : descEventos) {
                if(!descEventoMap.containsKey(descriptor.Tipo_de_evento__c)) {
                    descEventoMap.put(descriptor.Tipo_de_evento__c, descriptor);
                }
            }
        }

        //Actualizado: 16/04/2018
        if(idGPSocios.size() > 0) {
            List<GP_Socio__c> socios = [Select Id, Id_GP__c
                                        From GP_Socio__c
                                        Where Id_GP__c in :idGPSocios];
                                        
                                        system.debug(idGPSocios);
                                        system.debug(socios);
            if(socios.size() > 0) {
                for(GP_Socio__c socio : socios) {
                    if(!idsSocios.contains(socio.Id)){
                        idsSocios.add(socio.Id);
                    }
                    if(sociosMap.size() > 0) {
                        if(!sociosMap.containsKey(socio.Id_GP__c)) {
                            sociosMap.put(socio.Id_GP__c,socio);
                        }
                    } else {
                        sociosMap.put(socio.Id_GP__c,socio);
                    }
                }
            } else {
                //error no se encontraron socios
                error += 'No se encontraron socios con los Ids ingresados ++ ';
            }
        }

        //Consigo los registros de control de evento de los socios
        if(idsSocios.size() > 0) {
            ctrlEventos = [ Select Id,Cant_consecutiva__c,Fecha_ultimo_evento__c,Socio__c,Tipo_de_evento__c 
                            From GP_Control_de_evento__c 
                            Where Socio__c in: idsSocios];
        }
        if(ctrlEventos.size() > 0) {
            for(GP_Control_de_evento__c ctrl : ctrlEventos) {
                if(!ctrlEventoMap.containsKey(ctrl.Socio__c + ctrl.Tipo_de_evento__c)) {
                    ctrlEventoMap.put(ctrl.Socio__c + ctrl.Tipo_de_evento__c, ctrl);
                }
            }
        }

        for(GP_sumarRestarPuntosItem datos : datosTransaccion) {

            if(!String.isBlank(datos.suscriptorID) && datos.suscriptorID != '0') {
                idGPAUX = datos.suscriptorID + datos.titularId;
            } else {
                idGPAUX = datos.titularId + '0';    //Quizas se borre el '0'
            }
            
            if(String.isBlank(datos.tipoDeEvento)) {
                error += 'El Tipo de Evento es obligatorio y no acepta valor nulo ++ ';
                break;
            }
            GP_Socio__c socioAUX = new GP_Socio__c();
            if(sociosMap.size() > 0) {
                socioAUX = sociosMap.get(idGPAUX);
                system.debug(sociosMap);
                system.debug(idGPAUX);
            } else {
                error += 'No se procesaron los socios requeridos ++';
                break;
            }
            GP_Control_de_evento__c ctrlEventoSocio = new GP_Control_de_evento__c();
            // existeSocioEvento = true; Si existe un control de evento para ese socio
            Boolean existeSocioEvento = false;
            if(ctrlEventoMap.size() > 0) {
                system.debug(datos.tipoDeEvento);
                system.debug(socioAUX);
                existeSocioEvento = ctrlEventoMap.containsKey(socioAUX.Id + datos.tipoDeEvento);
            }
            if(existeSocioEvento) {
                ctrlEventoSocio = ctrlEventoMap.get(socioAUX.Id + datos.tipoDeEvento);
            }

            GP_Evento_descriptor__c descEventoAUX = new GP_Evento_descriptor__c();
            Boolean existeTipoEvento = false;
            if(descEventoMap.size() > 0) {
                existeTipoEvento = descEventoMap.containsKey(datos.tipoDeEvento);
            }
            if(existeTipoEvento) {
                descEventoAUX = descEventoMap.get(datos.tipoDeEvento);
            } else {
                descEventoAUX = new GP_Evento_descriptor__c(Frecuencia_permitida__c = 'Sin restriccion');
            }
            //fueProcesadoHoy = true; Si el socio realizo el evento en ciclo anterior del for
            system.debug(socioAUX);
            Boolean fueProcesadoHoy = listaSocioEvento.contains(socioAUX.Id + datos.tipoDeEvento);

            if(descEventoAUX.Frecuencia_permitida__c == 'Diaria') {
                //veo si el evento ya sucedio en el día
                if(!fueProcesadoHoy && !existeSocioEvento) {
                    datosFiltrados.add(datos);
                    listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
                } else if(!fueProcesadoHoy && ctrlEventoSocio.Fecha_ultimo_evento__c < Date.Today()) {
                    datosFiltrados.add(datos);
                    listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
                }
            } else if(descEventoAUX.Frecuencia_permitida__c == 'Semanal') {
                //veo si el evento ya sucedio en la semana
                if(!fueProcesadoHoy && !existeSocioEvento) {
                    datosFiltrados.add(datos);
                    listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
                } else if(!fueProcesadoHoy && ctrlEventoSocio.Fecha_ultimo_evento__c < Date.Today().toStartOfWeek()) {
                    datosFiltrados.add(datos);
                    listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
                }
            } else if(descEventoAUX.Frecuencia_permitida__c == 'Mensual') {
                //veo si el evento ya sucedio en el mes
                if(!fueProcesadoHoy && !existeSocioEvento) {
                    datosFiltrados.add(datos);
                    listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
                } else if(!fueProcesadoHoy && ctrlEventoSocio.Fecha_ultimo_evento__c.Month() < Date.Today().Month()) {
                    datosFiltrados.add(datos);
                    listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
                }
            } else if(descEventoAUX.Frecuencia_permitida__c == 'Tres Meses') {
                //veo si el evento ya sucedio en los ultimos tres meses
                if(!fueProcesadoHoy && !existeSocioEvento) {
                    datosFiltrados.add(datos);
                    listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
                } else if(!fueProcesadoHoy && ctrlEventoSocio.Fecha_ultimo_evento__c.addMonths(3) < Date.Today()) {
                    datosFiltrados.add(datos);
                    listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
                }
            } else if(descEventoAUX.Frecuencia_permitida__c == 'Anual') {
                //veo si el evento ya sucedio en el año
                if(!fueProcesadoHoy && !existeSocioEvento) {
                    datosFiltrados.add(datos);
                    listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
                } else if(!fueProcesadoHoy && ctrlEventoSocio.Fecha_ultimo_evento__c.Year() < Date.Today().Year()) {
                    datosFiltrados.add(datos);
                    listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
                }
            } else if(descEventoAUX.Frecuencia_permitida__c == 'Unica Vez' && !existeSocioEvento) {
                //veo si el evento ya sucedio alguna vez
                if(!fueProcesadoHoy) {
                    datosFiltrados.add(datos);
                    listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
                }
            } else if(descEventoAUX.Frecuencia_permitida__c == 'Sin restriccion') {
                datosFiltrados.add(datos);
                listaSocioEvento.add(socioAUX.Id + datos.tipoDeEvento);
            }
        }
        if(error != '') {
            throw new GP_Saldos_TransaccionesException(error);
        }

        return datosFiltrados;
    }

}