public class gp_datosSociosTriggerUtils {

    public static void darAlta(List<GP_Dato_Socio_FAN__c> datosSocios){

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
            
            String error = '';
            for(GP_Dato_Socio_FAN__c datoSocio : datosSocios){
                if(!idsCuentasQueExisten.contains(datoSocio.account_id__c)){
                    error += ' * la cuenta con id: '+datoSocio.account_id__c+' no existe.';
                }
            }
            
            if(error != ''){
                throw new GP_APIException(error);
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
        List<GP_datosTransaccion> Transferencias = new List<GP_datosTransaccion>();
        
        
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
            Transferencias.add(new GP_datosTransaccion(null, datoSocio.account_id__c, '0', (Double) datoSocio.Puntos__c, 'Suma', 'Migracion', null, datoSocio.Fecha_de_vencimiento__c));
            datoSocio.Procesado__c = true;       
            
        }
        
        insert sociosAInsertar.values();

        
        for(GP_Dato_Socio_FAN__c datoSocio: datosSocios){
            //Genero el gp_asset.
                if(assetsPorMSISDN.get(datoSocio.MSISDN__c) == null && assetsAInsertar.get(datoSocio.MSISDN__c) == null ){
                    GP_Lista_de_Asset__c assetGP = new GP_Lista_de_Asset__c();
                    
                    if(sociosPorCuenta.get(datoSocio.account_id__c) != null){
                        assetGP.Socio__c = sociosPorCuenta.get(datoSocio.account_id__c).id;
                    }else{
                        assetGP.Socio__c = sociosAInsertar.get(datoSocio.account_id__c).id;
                    }
                    
                       
                    assetGP.Asset__c = assetPorMSISDN.get(datoSocio.MSISDN__c).id;
                    if(assetGP.Asset__c == null){
                        throw new GP_APIException('No hay un asset creado para el MSISDN: '+datoSocio.MSISDN__c);
                    }
                    
                    assetsAInsertar.put(datoSocio.MSISDN__c, assetGP);
                    datoSocioPorAssetGP.put(assetGP, datoSocio);
                }
        }
        
        insert assetsAInsertar.values();
        
        if(Transferencias.size()>0){
            GP_Saldos_Transacciones.generarTransaccionActualizarSaldo(Transferencias);
        }
    }
    
    public static void darBaja(List<GP_Dato_Socio_FAN__c> datosSocios){
        
        List<String> idCuentas = new List<String>();
        for(GP_Dato_Socio_FAN__c datoSocio: datosSocios){
            idCuentas.add(datoSocio.Account_Id__c);
        }
        
        List<GP_Socio__c> sociosAEliminar = [select id, 
                                            (select id from GP_Historia_transacciones__r),
                                            (select id from GP_Lista_de_Assets__r)
                                            from GP_Socio__c where cuenta__c in: idCuentas];

        List<GP_Lista_de_Asset__c> assetsAEliminar = new List<GP_Lista_de_Asset__c>();
        List<GP_Historia_transaccion__c> transaccionesAEliminar = new List<GP_Historia_transaccion__c>();
        
        for(GP_Socio__c socio: sociosAEliminar){
            assetsAEliminar.addAll(socio.GP_Lista_de_Assets__r);
            transaccionesAEliminar.addAll(socio.GP_Historia_transacciones__r);
        }
        
        delete transaccionesAEliminar;
        delete assetsAEliminar;
        delete sociosAEliminar;
    }
}