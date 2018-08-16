global class GP_CreacionDeAcumuladoresBatch implements Database.Batchable<sObject>{


    global Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('aa');
         return Database.getQueryLocator('select id, Account_Id__c, Descripcion_del_error__c, Fecha_de_vencimiento__c, HayError__c, MSISDN__c, Procesado__c, Puntos__c from GP_Dato_Socio_FAN__c where Procesado__c = false');
    }

    
    global void execute(Database.BatchableContext BC, list<GP_Dato_Socio_FAN__c> datosSocios){
        
        system.debug(datosSocios);
        
        List<GP_Dato_Socio_FAN__c> datosSocioConError = new List<GP_Dato_Socio_FAN__c>();
        
        Set<String> accountsIds = new Set<String>();
        List<String> MSISDNs = new List<String>();
        for(GP_Dato_Socio_FAN__c datoSocio : datosSocios){
            accountsIds.add(datoSocio.account_id__c);
            MSISDNs.add(datoSocio.MSISDN__c);
        }
        
        List<Account> cuentas = [select id from account where id in: accountsIds];
        if(cuentas.size()!=accountsIds.size()){
            
            Set<String> idsCuentasQueExisten = new Set<String>();
            for(Account cuenta: cuentas){
                idsCuentasQueExisten.add(cuenta.id);
            }
            
            
            for(GP_Dato_Socio_FAN__c datoSocio : datosSocios){
                if(!idsCuentasQueExisten.contains(datoSocio.account_id__c)){
                    datoSocio.HayError__c = true;
                    datoSocio.Descripcion_del_error__c = 'la cuenta con id: '+datoSocio.account_id__c+' no existe.';
                    datosSocioConError.add(datoSocio);
                }
            }
        }
        
        List<GP_Socio__c> sociosYaExistentes = [select id, Cuenta__c from GP_Socio__c where Cuenta__c in: accountsIds];
        List<GP_Lista_de_Asset__c> GPAssetsYaExistentes = [select id, MSISDN__c from GP_Lista_de_Asset__c where MSISDN__c in: MSISDNs];
        List<Asset> assetsExistentes = [select id, MSISDN__c from asset where MSISDN__c in: MSISDNs];
        
        Map<String, GP_Socio__c> sociosPorCuenta = new Map<String, GP_Socio__c>();
        for(GP_Socio__c socio: sociosYaExistentes){
            sociosPorCuenta.put(socio.cuenta__c, socio);
        }
        
        Map<String, Asset> assetPorMSISDN = new Map<String, Asset>();
        for(Asset asst: assetsExistentes){
            assetPorMSISDN.put(asst.MSISDN__c, asst);
        }
        
        Map<String, GP_Lista_de_Asset__c> assetsPorMSISDN = new Map<String, GP_Lista_de_Asset__c>();
        for(GP_Lista_de_Asset__c asst: GPAssetsYaExistentes){
            assetsPorMSISDN.put(asst.MSISDN__c, asst);
        }
        
        //Cosas a Insertar/Actualizar.
        Map<String, GP_Socio__c> sociosAInsertar = new Map<String, GP_Socio__c>();
        Map<String, GP_Lista_de_Asset__c> assetsAInsertar = new Map<String, GP_Lista_de_Asset__c>();
        Map<String, GP_datosTransaccion> Transferencias = new Map<String, GP_datosTransaccion>();
        
        
        //MapasParaVerificarError
        Map<GP_socio__c, GP_Dato_Socio_FAN__c> datoSocioPorSocioAux = new Map<GP_socio__c, GP_Dato_Socio_FAN__c>();
        Map<GP_Lista_de_Asset__c, GP_Dato_Socio_FAN__c> datoSocioPorAssetGP = new Map<GP_Lista_de_Asset__c, GP_Dato_Socio_FAN__c>();
        
        for(GP_Dato_Socio_FAN__c datoSocio : datosSocios){
            
            //Doy de alta al socio;
            GP_socio__c socioAux;
            
            if(sociosPorCuenta.get(datoSocio.account_id__c) != null){
                socioAux = sociosPorCuenta.get(datoSocio.account_id__c);
            }else{
                if(sociosAInsertar.get(datoSocio.account_id__c) != null){
                    socioAux = sociosAInsertar.get(datoSocio.account_id__c);
                }else{
                    socioAux = new GP_socio__c();
                    socioAux.Activo__c = true;
                    socioAux.Cuenta__c = datoSocio.Account_Id__c;
                    socioAux.Saldo_total__c = 0;
                    
                    sociosAInsertar.put(datoSocio.Account_Id__c, socioAux);
                    datoSocioPorSocioAux.put(socioAux, datoSocio);
                }
            }
            
            

            
            //Genero Puntos.
            system.debug(datoSocio.account_id__c);
            Transferencias.put(datoSocio.msisdn__c, new GP_datosTransaccion(null, datoSocio.account_id__c, '0', (Double) datoSocio.Puntos__c, 'Suma', 'Transferencia', null, datoSocio.Fecha_de_vencimiento__c));
            datoSocio.Procesado__c = true;       
            
        }
        
        for(GP_Dato_Socio_FAN__c datoSocio: datosSocioConError){
            sociosAInsertar.remove(datoSocio.account_id__c);
        }
        
        Database.SaveResult[] lsr = Database.insert(
        sociosAInsertar.values(),
        false);
        
        system.debug(sociosAInsertar.values());
        system.debug(lsr);
        
        Boolean hayErroresEnElInsertDeSocios = false;
        String elErroEs = '';
        for(Database.SaveResult svr: lsr){
            if(!svr.isSuccess()){
                hayErroresEnElInsertDeSocios = true;
                elErroEs = svr.getErrors()[0].getMessage();
            }
        }
        
        if(hayErroresEnElInsertDeSocios){
            for(GP_socio__c socio: sociosAInsertar.values()){
                
                if(socio.id == null){
                    
                    datoSocioPorSocioAux.get(socio).hayError__c = true;
                    datoSocioPorSocioAux.get(socio).Descripcion_del_error__c = 'Error insertando GP_Socio: '+elErroEs;
                    system.debug(datoSocioPorSocioAux.get(socio));
                    datosSocioConError.add(datoSocioPorSocioAux.get(socio));
                    
                }
            }
        }
        
        for(GP_Dato_Socio_FAN__c datoSocio: datosSocios){
            //Genero el gp_asset.
            if(!datoSocio.hayError__c){
                if(assetsPorMSISDN.get(datoSocio.MSISDN__c) == null && assetsAInsertar.get(datoSocio.MSISDN__c) == null ){
                    GP_Lista_de_Asset__c assetGP = new GP_Lista_de_Asset__c();
                    
                    if(sociosPorCuenta.get(datoSocio.account_id__c) != null){
                        assetGP.Socio__c = sociosPorCuenta.get(datoSocio.account_id__c).id;
                    }else{
                        assetGP.Socio__c = sociosAInsertar.get(datoSocio.account_id__c).id;
                    }
                    
                       
                    assetGP.Asset__c = assetPorMSISDN.get(datoSocio.MSISDN__c).id;
                    if(assetGP.Asset__c == null){
                        datoSocio.HayError__c = true;
                        datoSocio.Descripcion_del_error__c = 'No hay un asset creado para el MSISDN: '+datoSocio.MSISDN__c;
                        datosSocioConError.add(datoSocio);
                    }
                    
                    assetsAInsertar.put(datoSocio.MSISDN__c, assetGP);
                    datoSocioPorAssetGP.put(assetGP, datoSocio);
                }
            }
        }
        
        
        Database.SaveResult[] svResultAsset = Database.insert(
        assetsAInsertar.values(),
        false);
        
        Boolean hayErroresEnElInsertDeAssets = false;
        elErroEs = '';
        for(Database.SaveResult svr: svResultAsset){
            if(!svr.isSuccess()){
                hayErroresEnElInsertDeAssets = true;
                elErroEs = svr.getErrors()[0].getMessage();
            }
        }
        
        if(hayErroresEnElInsertDeAssets){
            for(GP_Lista_de_Asset__c gpAsset: assetsAInsertar.values()){
                if(gpAsset.id == null){
                    
                    datoSocioPorAssetGP.get(gpAsset).hayError__c = true;
                    datoSocioPorAssetGP.get(gpAsset).Descripcion_del_error__c = 'Error insertando GP_Socio: '+elErroEs;
                    datosSocioConError.add(datoSocioPorAssetGP.get(gpAsset));
                }
            }
        }
        
        for(GP_Dato_Socio_FAN__c datoSocio: datosSocioConError){
            Transferencias.remove(datoSocio.MSISDN__c);
        }
 
        
        update datosSocios;
        if(Transferencias.values().size()>0){
            GP_Saldos_Transacciones.generarTransaccionActualizarSaldo(Transferencias.values());
        }
    }

    global void finish(Database.BatchableContext BC){
        
    }


}