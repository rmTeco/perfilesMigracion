global class GP_BatchSaldos implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC){
        Integer dias = 60;
        String hoy = String.valueOf(Date.Today());
        String query =  ' Select Id, Socio__c, Vencimiento__c, Puntos__c, Socio__r.Cuenta__c, Socio__r.Socio_padre__c' + 
                        ' From GP_Saldo_por_vencimiento__c' + 
                        ' Where Vencimiento__c >= ' + String.valueOf(Date.Today()) + 
                        ' AND Vencimiento__c <= ' + String.valueOf(Date.Today().addDays(dias)) +
                        ' AND Puntos__c > 0' +
                        ' AND (Socio__r.Socio_padre__r.Activo__c = true' +
                        ' OR Socio__r.Socio_padre__c = null)';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<GP_Saldo_por_vencimiento__c> scope){

        List<GP_Aviso_Vencimiento__c> avisos = generarRegistrosAvisoVencimiento(scope);

        if(avisos.size() > 0){
            upsert avisos;
        }
    }

    global void finish(Database.BatchableContext BC){
    }

    private Map<String, GP_Aviso_Vencimiento__c> mapAvisos{get;set;}
    private Map<String, List<GP_Saldo_por_vencimiento__c>> mapSaldosPorAcum{get;set;}
    private List<GP_Socio__c> listAcums{get;set;}

    private List<GP_Aviso_Vencimiento__c> generarRegistrosAvisoVencimiento(List<GP_Saldo_por_vencimiento__c> listVtos) {

        GP_Socio__c acumAux = new GP_Socio__c();
        GP_Aviso_Vencimiento__c aviso = new GP_Aviso_Vencimiento__c();
        List<GP_Saldo_por_vencimiento__c> saldosAux = new List<GP_Saldo_por_vencimiento__c>();

        List<GP_Aviso_Vencimiento__c> listAvisosAUX = new List<GP_Aviso_Vencimiento__c>();
        mapAvisos = new Map<String, GP_Aviso_Vencimiento__c>();

        mapSaldosPorAcum = new Map<String, List<GP_Saldo_por_vencimiento__c>>();
        
        Set<String> setCuentas = new Set<String>();
        Set<String> idsAcums = new Set<String>();
        listAcums = new List<GP_Socio__c>();
        Map<String, GP_Socio__c> mapAcums = new Map<String, GP_Socio__c>();

        for(GP_Saldo_por_vencimiento__c salVto : listVtos) {
            if(!idsAcums.contains(salVto.Socio__c)){
                idsAcums.add(salVto.Socio__c);
            }
            if(!idsAcums.contains(salVto.Socio__r.Socio_padre__c)) {
                //Busco al padre
                idsAcums.add(salVto.Socio__r.Socio_padre__c);
            }
            if(!mapSaldosPorAcum.containsKey(salVto.Socio__c)){
                //Primer saldo encontrado de un acumulador
                saldosAux = new List<GP_Saldo_por_vencimiento__c>();
                saldosAux.add(salVto);
                mapSaldosPorAcum.put(salVto.Socio__c, saldosAux);
            } else {
                //Agrego otro saldo a la lista
                mapSaldosPorAcum.get(salVto.Socio__c).add(salVto);
            }
        }
        if(idsAcums.size() > 0) {
            listAcums = [   Select Id, Cuenta__c, Saldo_total__c, Socio_padre__c, idCuentaDiesyochoCaracteres__c, Id_gp__c
                            From GP_Socio__c
                            Where Id in :idsAcums];
            if(listAcums.size() > 0) {
                for(GP_Socio__c sc : listAcums) {
                    if(!setCuentas.contains(sc.Cuenta__c)) {
                        setCuentas.add(sc.Cuenta__c);
                    }
                }
            }
        }
        if(setCuentas.size() > 0) {
            listAvisosAUX = [   Select Id, Puntos_que_vencen__c, Cuenta__c
                                From GP_Aviso_Vencimiento__c 
                                Where Cuenta__c in :setCuentas];
            if(listAvisosAUX.size() > 0) {
                for(GP_Aviso_Vencimiento__c av : listAvisosAUX) {
                    if(!mapAvisos.containsKey(av.Cuenta__c)) {
                        mapAvisos.put(av.Cuenta__c, av);
                    }
                }
            }
        }

        if(listAcums.size() > 0) {
            for(GP_Socio__c acum : listAcums) {
                //Datos
                if(!mapAcums.containsKey(acum.Id)) {
                    mapAcums.put(acum.Id, acum);
                } else {
                    acumAux = mapAcums.get(acum.Id);
                }
                if(acum.Id_gp__c == acum.idCuentaDiesyochoCaracteres__c + '0') { //Es Acumulador padre
                    //Creo los avisos para los padres.
                    gestionarAvisos(acum, True);
                } else {
                    //Creo los avisos para los hijos.
                    gestionarAvisos(acum, False);
                }
            }
        }
        return mapAvisos.values();
    }

    private void gestionarAvisos(GP_Socio__c acum, Boolean esPadre) {
        Integer puntos = 0;
        GP_Aviso_Vencimiento__c aviso = new GP_Aviso_Vencimiento__c();
        aviso.Puntos_que_vencen__c = 0;
        aviso.Cuenta__c = acum.Cuenta__c;

        if(mapSaldosPorAcum.containsKey(acum.Id)) {
            if(mapSaldosPorAcum.get(acum.Id).size() > 0) {
                //Si el acum tiene saldos que vencen en los prox 60 días -> sumo los puntos que vencen
                for(GP_Saldo_por_vencimiento__c sal : mapSaldosPorAcum.get(acum.Id)){
                    puntos += (Integer)sal.Puntos__c;
                }
            }
        }

        if(esPadre) {
            for(GP_Socio__c acumHijo : listAcums) {
                if(acumHijo.Id_gp__c == acumHijo.idCuentaDiesyochoCaracteres__c + acum.idCuentaDiesyochoCaracteres__c) {
                    //acumAux es acumulador Hijo de acum
                    if(mapSaldosPorAcum.containsKey(acumHijo.Id)) {
                        if(mapSaldosPorAcum.get(acumHijo.Id).size() > 0) {
                            //Si el hijo tiene saldos que vencen en los prox 60 días -> sumo los puntos que vencen
                            for(GP_Saldo_por_vencimiento__c sal : mapSaldosPorAcum.get(acumHijo.Id)){
                                puntos += (Integer)sal.Puntos__c;
                            }
                        }
                    }
                }
            }
        }

        if(mapAvisos.containsKey(acum.Cuenta__c)){
            aviso = mapAvisos.get(acum.Cuenta__c);
        } else {
            mapAvisos.put(acum.Cuenta__c, aviso);
        }
        aviso.Puntos_que_vencen__c += puntos;
    }
}