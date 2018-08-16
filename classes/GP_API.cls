Global with sharing class GP_API {


    public static void crearAcumuladorSocioTitular(List<Gp_socioAAdherir> socios){

        //Verifico si ya existen los socios titulares para las cuentas.
        List<String> idsCuentasMerge = new List<String>();
        for(Gp_socioAAdherir socio: socios){
            idsCuentasMerge.add(socio.idGp);
        }
        
        //system.debug(socios); 

        validarQueLosSociosNoEstenCreados(socios);

        //Tomo los socios que fueron desactivados.
        List<GP_Socio__c> sociosYaExistentesNoActivos = [select id, cuenta__c, Id_GP__c, socio_padre__c,  Socio_padre__r.cuenta__c, Activo__c 
                                                         from GP_Socio__c where Id_GP__c in: idsCuentasMerge and Activo__c = false];
    
        //system.debug(sociosYaExistentesNoActivos);
        
        Map<String, Gp_Socio__c> sociosAActivarPorCuenta = new Map<String, Gp_Socio__c>();
        for(GP_Socio__c socio:sociosYaExistentesNoActivos){
            
            sociosAActivarPorCuenta.put(socio.Id_GP__c, socio);
        }

        List<GP_Socio__c> sociosAUpdatear = new List<GP_Socio__c>();
        List<Gp_socioAAdherir> sociosACrear = new List<Gp_socioAAdherir>();

        for(Gp_socioAAdherir socio: socios){
            if(sociosAActivarPorCuenta.get(socio.idGp) != null){
                GP_Socio__c socioAux = sociosAActivarPorCuenta.get(socio.idGp);
                socioAux.Activo__c = true;
                sociosAUpdatear.add(socioAux);
            }else{
                sociosACrear.add(socio);
            }
        }

        update sociosAUpdatear;
        
        //system.debug(sociosACrear);
        crearSocios(sociosACrear);
        generarAssets(socios);

    }

    public static void crearSocios(List<Gp_socioAAdherir> socios){
        
        List<GP_Socio__c> sociosAInsertar = new List<GP_Socio__c>();
        List<Gp_socioAAdherir> sociosAdherentesAInsertar = new List<Gp_socioAAdherir>();
        List<String> cuentasSociosPadres = new List<String>();

        for(Gp_socioAAdherir socio: socios){

            if(socio.tipoDeSocio == 'Titular'){
                GP_Socio__c SocioAux = new GP_socio__c();
                socioAux.cuenta__c = socio.idCuenta;
                socioAux.Saldo_total__c = 0;
                socioAux.activo__c = true;
                sociosAInsertar.add(socioAux); 
            }else{
                sociosAdherentesAInsertar.add(socio);
                cuentasSociosPadres.add(socio.idCuentaTitular);
            }
        }

        insert sociosAInsertar;

        List<GP_Socio__c> sociosPadres = [select id, cuenta__c from GP_Socio__c where cuenta__c in: cuentasSociosPadres and socio_padre__c = null];

        Map<String,String> cuentasPorIdSocio = new Map<String,String>();
        for(GP_Socio__c socio: sociosPadres){
            cuentasPorIdSocio.put(socio.cuenta__c, socio.id);
        }

        List<GP_Socio__c> sociosAdherentesCreados = new List<GP_Socio__c>();
        String error = '';
        for(Gp_socioAAdherir socio: sociosAdherentesAInsertar){
            
            if(cuentasPorIdSocio.get(socio.idCuentaTitular) != null){
                GP_Socio__c socioAux = new GP_Socio__c();
                socioAux.cuenta__c = socio.idCuenta;
                socioAux.socio_padre__c = cuentasPorIdSocio.get(socio.idCuentaTitular);
                socioAux.Saldo_total__c = 0;
                socioAux.activo__c = true;
                sociosAdherentesCreados.add(socioAux);
            }else{
                error += ' **Error: No se pudo crear el acumulador adherente para la cuenta: '+socio.idCuentaTitular+' por que este no posee un acumulador titular';
            }
            
        }

        if(error == ''){
            insert sociosAdherentesCreados;
        }else{
            throw new GP_APIException(error); 
        }
        

    }

    public static void validarQueLosSociosNoEstenCreados(List<Gp_socioAAdherir> socios){
        
        List<String> sociosTitulares = new List<String>();
        List<Gp_socioAAdherir> sociosAdherentes = new List<Gp_socioAAdherir>();
        
        for(Gp_socioAAdherir socio: socios){
            if(socio.tipoDeSocio == 'Titular'){
                sociosTitulares.add(socio.idCuenta);
            }else{
                sociosAdherentes.add(socio);
            }
        }

        String errorTitular = '';
        String errorAdherente = '';

        errorTitular = validarSociosTitulares(sociosTitulares);
        errorAdherente = validarSociosAdherentes(sociosAdherentes);

        String error = errorTitular+errorAdherente;
        if(error != '') {
            throw new GP_APIException(error);
        }
    }

    public static String validarSociosTitulares(List<String> idCuentas){
        String error = '';

        List<GP_Socio__c> sociosYaExistentes = [select id, cuenta__c from GP_Socio__c 
                                                where Cuenta__c in: idCuentas and Socio_padre__c = null and Activo__c = true];

        if(sociosYaExistentes.size()>0){
            for(GP_Socio__c socio: sociosYaExistentes){
                error += ' **Error: la cuenta: '+socio.cuenta__c+' ya posee un acumulador titular con id: '+socio.id;
            }
        }

        return error;
    }

    public static String validarSociosAdherentes(List<Gp_socioAAdherir> socios){
        String error = '';

        List<String> idsMerge = new List<String>();
        for(Gp_socioAAdherir socio: socios){
            idsMerge.add(socio.idCuenta+socio.idCuentaTitular);
        }

        List<GP_Socio__c> sociosYaExistentes = [select id, cuenta__c, Socio_padre__r.cuenta__c from GP_Socio__c 
                                                where Id_GP__c in: idsMerge and Activo__c = true];

        if(sociosYaExistentes.size()>0){
            for(GP_Socio__c socio: sociosYaExistentes){
                error += ' **Error: la cuenta: '+socio.cuenta__c+' ya posee un acumulador adherente relacionado con la cuenta titular: '+socio.Socio_padre__r.cuenta__c+' (Socio id: '+socio.id+').';
            }
        }

        return error; 
    }

    public static void crearAcumuladorSuscriptorNuevo(String idTitular, String idSuscriptor, List<String> assets){
        
        //system.debug('gp_api');
        
        if(String.isBlank(idTitular) || String.isBlank(idSuscriptor)){
            throw new GP_APIException('Los datos idTitular y idSuscriptor son obligatorios.');
        }

        /*system.debug(idTitular);
        system.debug(idSuscriptor);
        system.debug(assets);*/
        
        String idMerge = '';
        if(idSuscriptor == '0') {
            idMerge = idTitular + idSuscriptor;
        } else {
            idMerge = idSuscriptor+idTitular;
        }
        List<GP_Socio__c> socios = [select id from GP_Socio__c where Id_GP__c =: idMerge and activo__c = true limit 1];
        if( socios.size() > 0 ){
            throw new GP_APIException('Ya existe un acumulador adherente para esta convinacion de idTitular e idSuscriptor.');
        }

        List<GP_Socio__c> sociosNoActivo = [select id from GP_Socio__c where Id_GP__c =: idMerge and activo__c = false limit 1];
        GP_Socio__c socioAux = new GP_Socio__c();

        String idGpTitular = idTitular+'0';
        //system.debug(idGpTitular);
        List<GP_Socio__c> socioPadre = [select id from GP_Socio__c where activo__c = true and id_gp__c =: idGpTitular limit 1];

        if(sociosNoActivo.size()>0){
            sociosNoActivo[0].activo__c = true;
            update sociosNoActivo;
        }else{
            
            if(socioPadre.size()>0){
                
                socioAux.cuenta__c = idSuscriptor;
                socioAux.socio_padre__c = socioPadre[0].id;
                socioAux.Saldo_total__c = 0;
                socioAux.activo__c = true;
    
                insert socioAux;
            }else{
                throw new GP_APIException(' **Error: la cuenta titular id: '+idTitular+' no posee un acumulador titular activo o existente.');
            }
        }

        //Inserto los assets.
        List<GP_Lista_de_Asset__c> assetsGPCreados = [select id, socio__c, socio__r.Id_GP__c 
                                               from GP_Lista_de_Asset__c where Asset__c in: assets];
        List<GP_Lista_de_Asset__c> assetsUpdate = new List<GP_Lista_de_Asset__c>();
        List<String> idsAssetsUpdate = new List<String>();
        String socioId = [select id from GP_Socio__c where id_gp__c =: idMerge limit 1].id;
        if(assetsGPCreados.size()>0){
            /*Actualizado 25/06/2018 - Nehuen Sola
            String error = '';
            for(GP_Lista_de_Asset__c a: assetsGPCreados){
                error += ' **Error: El asset con Id: '+a.id+' ya esta asociado a un socio: '+a.socio__c; 
            }
            throw new GP_APIException(error);
            */
            String error = '';
            for(GP_Lista_de_Asset__c a: assetsGPCreados){
                if(a.socio__c == socioPadre[0].Id) {
                    a.socio__c = socioId;
                    assetsUpdate.add(a);
                    idsAssetsUpdate.add(a.Id);
                } else {
                    error += ' **Error: El asset con Id: '+a.id+' ya esta asociado a un socio: '+a.socio__c;
                }
            }
            if(assetsUpdate.size() > 0) {
                update assetsUpdate;
            }
            if(error != '') {
                throw new GP_APIException(error);
            }
        }
        List<GP_Lista_de_Asset__c> assetsGP = new List<GP_Lista_de_Asset__c>();
        for(String idAsset: assets){
            if(!idsAssetsUpdate.contains(idAsset)) {
                GP_Lista_de_Asset__c assetGp = new GP_Lista_de_Asset__c();

                if(sociosNoActivo.size()>0){
                    assetGp.Socio__c = sociosNoActivo[0].id; 
                }else{
                    assetGp.Socio__c = socioId;
                }
                
                assetGp.Total_Puntos_Acumulados__c = 0;
                assetGp.Asset__c = idAsset; 
                assetsGP.add(assetGp);
            }
        }
        if(assetsGP.size() > 0) {
            insert assetsGP;
        }
    }
    
    private static void generarAssets(List<GP_socioAAdherir> sociosAAdherir){
        
        //system.debug(sociosAAdherir);
        
        List<String> idsAssets = new List<String>();
        List<String> idsGpMerge = new List<String>();
        for(GP_socioAAdherir socio: sociosAAdherir){
            idsAssets.addAll(socio.assets);
            idsGpMerge.add(socio.idGp);
        }

        //Verifico que no exista ya un gp_asset para ese asset.
        List<GP_Lista_de_Asset__c> assetsGP = [select id, socio__c, socio__r.Id_GP__c 
                                               from GP_Lista_de_Asset__c where Asset__c in: idsAssets];
        if(assetsGP.size()>0){
            String error = '';
            for(GP_Lista_de_Asset__c a: assetsGP){
                error += ' **Error: El asset con Id: '+a.id+' ya esta asociado a un socio: '+a.socio__c; 
            }
            throw new GP_APIException(error);
        }


        List<GP_Socio__c> socios = [select id, Id_GP__c from Gp_socio__c where Id_GP__c in: idsGpMerge];

        //system.debug(socios);
        
        Map<String, String> idsGPPorSocio = new Map<String,String>();
        for(GP_Socio__c socio: socios){
            idsGPPorSocio.put(socio.Id_GP__c, socio.id);
        }
        
        //system.debug(idsGPPorSocio);
        
        List<GP_Lista_de_Asset__c> assetsGpAInsertar = new List<GP_Lista_de_Asset__c> ();
        for(GP_socioAAdherir socio: sociosAAdherir){
            for(String asset : socio.assets){
               
               GP_Lista_de_Asset__c assetGp = new GP_Lista_de_Asset__c();
               assetGp.Socio__c = idsGPPorSocio.get(socio.idGp);
               assetGp.Total_Puntos_Acumulados__c = 0;
               assetGp.Asset__c = asset; 

               assetsGpAInsertar.add(assetGp);
            }
        }
        
        //system.debug(assetsGpAInsertar);
        
        if(assetsGpAInsertar.size()>0){
            insert assetsGpAInsertar;  
        }
    }

    //Validaciones
    
    public static GP_Socio__c verificarSiUnSocionExisteYEstaActivo(String idMerge){
            
            List<GP_Socio__c> sociosYaExistente = [select id, Activo__c, Cuenta__c, Saldo_total__c, Socio_padre__c,
                                                   Id_GP__c,
                                                   (select id, Activo__c, Id_GP__c, Cuenta__c, Saldo_total__c, Socio_padre__c
                                                   from GP_Socios__r)
                                                   from GP_Socio__c 
                                                   where Id_GP__c =: idMerge limit 1];
            
            if(sociosYaExistente.size()>0){
                if(!sociosYaExistente[0].Activo__c){
                    throw new GP_APIException('El acumulador de id: '+idMerge+' no se encuentra activo.');    
                }
            }else{
                throw new GP_APIException('No existe un acumulador para el id: '+idMerge);
            }

        return sociosYaExistente[0];
    }
    
    
    public static list<GP_Socio__c> verificarSocios(List<String> idsSocios){ 
        
        String descError = '';
        Boolean hayError = false;
        List<GP_Socio__c> socios = [select id, id_gp__c, Activo__c, Cuenta__c, Saldo_total__c, Socio_padre__c,
                                   (select id, id_gp__c, Activo__c, Cuenta__c, Saldo_total__c, Socio_padre__c
                                    from GP_Socios__r)
                                    from GP_Socio__c  
                                    where id_gp__c in: idsSocios];  


        Map<String, GP_Socio__c> mapaSocios = new Map<String, Gp_socio__c>();

        for(GP_Socio__c socio: socios){
            mapaSocios.put(socio.id_gp__c, socio);
        }

        for(String ids: idsSocios){
            if(mapaSocios.get(ids) == null){
                hayError = true;
                descError += ' * No existe un socio para el id: '+ids+' .';
            }
        }

        if(hayError){
            throw new GP_APIException(descError);
        }

        return mapaSocios.values();

    }

    //sumarRestarPuntos -- 19/02
    public static void sumarRestarPuntos(List<GP_sumarRestarPuntosItem> items){
       
        //system.debug(items);
        if(items.size() == 0) {
            throw new GP_APIException('No se ingresaron datos para procesar.');
        }
        //Verificar que los socios existen y estan activos
        Set<String> idsGPSocios = new Set<String>();
        for(GP_sumarRestarPuntosItem item: items){

            if(item.suscriptorID == '0' || String.isBlank(item.suscriptorID)){
                idsGPSocios.add(item.titularID + '0');
            }else{
                idsGPSocios.add(item.suscriptorID+item.titularID);
            }
            
        }

        List<GP_socio__c> SociosExistentes = verificarSocios(new List<String>(idsGPSocios));

         
        //Creo los items.
        List<GP_itemMotorDeReglas> itemsMotorRegla = new List<GP_itemMotorDeReglas>();
        List<GP_sumarRestarPuntosItem> itemsFiltradosPorControlDeEvento = GP_ControlDeEventos.controlarSocios(items);
        //Saque Items.
        For(GP_sumarRestarPuntosItem item: itemsFiltradosPorControlDeEvento){
            GP_itemMotorDeReglas itemMR = new GP_itemMotorDeReglas(item.titularID, item.suscriptorID, item.puntos, item.tipoDeEvento, item.variablesDelEvento, item.numeroDeOrden);
            itemsMotorRegla.add(itemMR);
        }
        
        //Los paso por las reglas.
        //System.debug(itemsMotorRegla);
        GP_MotorDeReglas.pasarPorLasReglas(itemsMotorRegla);
        system.debug(itemsMotorRegla);

        //creo los items para el generador de transacciones.
        List<GP_datosTransaccion> itemsTransaccion = new List<GP_datosTransaccion>();
        for(GP_itemMotorDeReglas item: itemsMotorRegla){
            if(item.puntos != 0){
               //hacer otro constructor que no reciba suma o resta, si no que lo dedusca de si los puntos son positivos o negaticos
               itemsTransaccion.add(new GP_datosTransaccion(item.idRegla, item.titularID, item.suscriptorID, (Double) item.Puntos, item.tipoDeEvento , item.numeroDeOrden, item.vencimiento)); 
            }
        }

        //Llamo al generador de saldos y transacciones.
        if(itemsTransaccion.size()>0){
            GP_Saldos_Transacciones.generarTransaccionActualizarSaldo(itemsTransaccion);
        }

    }

    //ConsultarTransacciones -- 05/03
    public static List<GP_Historia_transaccion__c> consultarTransacciones (String idTitular, String idSuscriptor, Date fechaDesde, Date fechaHasta){
        
        //CamposObligatorios
        if(String.isBlank(idTitular) || fechaDesde == null || fechaHasta == null){
            throw new GP_APIException('Los campos idTitular, fechaDesde y fechaHasta son obligatorios.');
        }
        
        //FechaDesde menor a fecha hasta.
        if(fechaDesde>fechaHasta){
            throw new GP_APIException('La fecha desde debe ser menor que la fecha hasta. Fecha desde: '+fechaDesde+' Fecha hasta: '+fechaHasta);
        }

        //Validacion sobre el socio.
        String idMerge = '';
        if(idSuscriptor == '0' || String.isBlank(idSuscriptor)){
            idMerge = idTitular+'0';
        }else{
           idMerge = idSuscriptor+idTitular;
        }
        
        verificarSiUnSocionExisteYEstaActivo(idMerge);

        List<GP_Historia_transaccion__c> listaDeTransacciones = new List<GP_Historia_transaccion__c>();
        listaDeTransacciones = [select id, Fecha_transaccion__c, Generado_por__c, Nombre_de_la_Regla_que_lo_genero__c, Nuevo_saldo__c, Numero_de_orden__c, Puntos__c,
                                Saldo_a_consumir__c, Saldo_anterior__c, Socio__c, Suma_o_resta__c, Tipo_de_evento__c, Vencimiento__c
                                from GP_Historia_transaccion__c
                                where Socio__r.id_gp__c =: idMerge and createdDate >=: fechaDesde and createdDate<=: fechaHasta];

        return listaDeTransacciones;
    }

    //consultarEstadoSocio -- 05/03
    public static Map<String,Object> consultarEstadoAcumulador (String idTitular, String idSuscriptor){
        
        //CamposObligatorios
        if(String.isBlank(idTitular)){ 
            throw new GP_APIException('El campo idSocio es obligatorio.');
        }
        
        String idMerge = '';
        if(idSuscriptor == '0' || String.isBlank(idSuscriptor)){
            idMerge = idTitular+'0';
        }else{
           idMerge = idSuscriptor+idTitular;
        }
        
        GP_Socio__c socio = verificarSiUnSocionExisteYEstaActivo(idMerge);

        Map<String,Object> mapaRespuesta = new Map<String, Object>();
        String estado = 'Inactivo';

        if(socio.activo__c){
            estado = 'Activo';
        }
        
        mapaRespuesta.put('Estado', estado);
        mapaRespuesta.put('totalPuntosDisponible', String.valueOf(socio.Saldo_total__c));
        return mapaRespuesta;

    }

    //EliminarSocio -- 05/03
    public static void eliminarAcumuladores (List<String> idsAEliminar){

        if(idsAEliminar == null || idsAEliminar.size() == 0){
            throw new GP_APIException('La lista de ids a eliminar es obligatoria.');    
        }

        List<GP_Socio__c> sociosYaExistente = [select id, Activo__c, Saldo_total__c
                                               from GP_Socio__c 
                                               where id_gp__c in: idsAEliminar];

        List<GP_Historia_transaccion__c> transaccionesDeBajaACargar = new list<GP_Historia_transaccion__c>();
        for(GP_Socio__c socio:sociosYaExistente){
            socio.activo__c = false;
            socio.Saldo_total__c = 0;
            //Transaccion de quita de puntos para cada socio.
            transaccionesDeBajaACargar.add(new GP_Historia_transaccion__c(Socio__c = socio.Id, 
                                         Puntos__c = socio.Saldo_total__c, 
                                         Suma_o_resta__c = 'Resta',
                                         Tipo_de_evento__c = 'Baja'));
        }

        //Borrar todos los saldos.
        delete [select id from GP_Saldo_por_vencimiento__c where Socio__r.id_gp__c in: idsAEliminar];

        //Borrar assets gp
        delete [select id from GP_Lista_de_Asset__c where socio__r.id_gp__c in: idsAEliminar ];

        //Cargar transaccion de baja
        insert transaccionesDeBajaACargar;

        //Poner inactivo los socios.
        update sociosYaExistente;                                             
    }

    //TransferirPuntos -- 08/03
    public static void transferirPuntos (String unTitularId, String suscriptorIDDesde, String suscriptorIDHacia, Double puntos){
        
        if(String.isBlank(unTitularId) || String.isBlank(suscriptorIDDesde) || String.isBlank(suscriptorIDHacia) || puntos == null){
            throw new GP_APIException('Los campos SociosDesdeID, socioHaciaID, puntos, son obligatorios.');    
        }

        String mergeDesde = '';
        if(suscriptorIDDesde == '0' || String.isBlank(suscriptorIDDesde)){
            mergeDesde = unTitularId+'0';
        }else{
            mergeDesde = suscriptorIDDesde+unTitularId;    
        }
        
        String mergeHacia = '';
        if(suscriptorIDHacia == '0' || String.isBlank(suscriptorIDHacia)){
            mergeHacia = unTitularId+'0'; 
        }else{
            mergeHacia = suscriptorIDHacia+unTitularId;    
        }
        
        GP_Socio__c socioDesde = verificarSiUnSocionExisteYEstaActivo(mergeDesde);
        GP_Socio__c socioHasta = verificarSiUnSocionExisteYEstaActivo(mergeHacia);

        //Consumo de puntos socio desde
        List<GP_datosTransaccion> datosSocioDesde = new List<GP_datosTransaccion>();
        system.debug(puntos);
        system.debug(new GP_datosTransaccion(null, unTitularId, suscriptorIDDesde, puntos, 'Resta', 'Transferencia', null, null));
        datosSocioDesde.add(new GP_datosTransaccion(null, unTitularId, suscriptorIDDesde, puntos, 'Resta', 'Transferencia', null, null));

        List<GP_Historia_transaccion__c> transaccionesGeneradas = GP_Saldos_Transacciones.generarTransaccionActualizarSaldo(datosSocioDesde);
        
        system.debug(transaccionesGeneradas);
        
        //Acreditacion de puntos socio hacia
        List<GP_datosTransaccion> datosSocioHacia = new List<GP_datosTransaccion>();
        //Falta definir la fecha de vencimiento.
        //system.debug(transaccionesGeneradas); 
        for(GP_Historia_transaccion__c tran:transaccionesGeneradas){
            system.debug((Double) tran.Puntos__c);
            datosSocioHacia.add(new GP_datosTransaccion(null, unTitularId, suscriptorIDHacia, (Double) tran.Puntos__c, 'Suma', 'Transferencia', null, tran.vencimiento__c));
        }

        GP_Saldos_Transacciones.generarTransaccionActualizarSaldo(datosSocioHacia);
        

    }
    
    //anularCanje -- 15/03
    public static void anularCanje (String titularID, String suscriptorID, Integer numeroDeOrden){

        if(String.isBlank(titularID) || String.isBlank(suscriptorID) || numeroDeOrden == null){
            throw new GP_APIException('Los campos idSocio y numeroDeOrden son obligatorios.');    
        }
        
        String idMerge = '';
        if(suscriptorID == '0' || String.isBlank(suscriptorID)){
            idMerge = titularID+'0';
        }else{
           idMerge = suscriptorID+titularID;
        }
        GP_Socio__c socioDesde = verificarSiUnSocionExisteYEstaActivo(idMerge);

        //Busco la transacciones.
        Date hoy = Date.today();
        List<GP_Historia_transaccion__c> transacciones = [select id, Vencimiento__c, Puntos__c 
                                                          from GP_Historia_transaccion__c 
                                                          where Socio__r.id_gp__c =: idMerge and 
                                                          Numero_de_orden__c =: numeroDeOrden and 
                                                          (Vencimiento__c >=: hoy OR Vencimiento__c = null) and 
                                                          Suma_o_resta__c = 'Resta']; 

        if(transacciones.size()==0){
            throw new GP_APIException('No hay una transaccion para la convinación de este numero de orden y de este id de socio, con una fecha de vencimiento mayor a hoy.');
        }

        List<GP_datosTransaccion> transferenciaAnularCanje = new List<GP_datosTransaccion>();
        for(GP_Historia_transaccion__c trans: transacciones){
            transferenciaAnularCanje.add(new GP_datosTransaccion(null, titularID, suscriptorID, (Double) trans.Puntos__c, 'Suma', 'Transferencia', null, trans.vencimiento__c));
        }

        GP_Saldos_Transacciones.generarTransaccionActualizarSaldo(transferenciaAnularCanje);


    }

    public static void agregarAsset (String titularID, String suscriptorID, String assetID ){

        List<Asset> listAsset = [Select Id From Asset Where Id = :assetID];
        if(listAsset.size() == 0) {
            throw new GP_APIException('No se encontró el Asset de Id: \'' + assetID + '\'');
        }

        List<GP_Lista_de_Asset__c> assetsGP = [select id, socio__c, socio__r.Id_GP__c 
                                               from GP_Lista_de_Asset__c where Asset__c =: assetID];
        if(assetsGP.size()>0){
            String error = '';
            for(GP_Lista_de_Asset__c a: assetsGP){
                error += ' **Error: El asset con Id: '+a.id+' ya esta asociado a un socio: '+a.socio__c; 
            }
            throw new GP_APIException(error);
        }
        String idgp;
        if(suscriptorID == '0' || String.isBlank(suscriptorID)) {
            idgp = titularID + '0';
        } else {
            idgp = suscriptorID + titularID;
        }

        GP_Socio__c socio = verificarSiUnSocionExisteYEstaActivo(idgp);
        
        GP_Lista_de_Asset__c assetGp = new GP_Lista_de_Asset__c();
        assetGp.Socio__c = socio.id;
        assetGp.Total_Puntos_Acumulados__c = 0;
        assetGp.Asset__c = assetID; 
        
        insert assetGP;
    }
    
    public static void eliminarAsset(List<String> idsAssets){
        if(idsAssets.size() == 0) {
            throw new GP_APIException('La lista de Ids de Assets del Gestor de Puntos es obligatoria y no debe estar vacía.');
        }

        List<GP_Lista_de_Asset__c> assets = [select id from GP_Lista_de_Asset__c where Asset__c in: idsAssets];
        if(assets.size() > 0) {
            delete assets;
        } else {
            throw new GP_APIException('No se encontraron Assets del Gestor de Puntos con los Ids ingresados.' );
        }
    }
    
    //PADRE: titularId + '0';
    //HIJOS: suscriptorId + titularId;
    //Actualizado: 16/04/2018
    public static Map<String,Object> consultarPuntos(String titularId, String suscriptorId) {
        if(String.isBlank(titularId)) {
            throw new GP_Saldos_TransaccionesException('El Id de cuenta del titular no puede ser nulo');
        }

        List<GP_Socio__c> socioQuery = new List<GP_Socio__c>();
        String idGP = '';
        if(suscriptorId == '0' || String.isBlank(suscriptorId)) {
            idGP = titularId + '0';
            socioQuery = [  Select Id, Saldo_total__c, Cuenta__c, Id_GP__c, Activo__c
                            From GP_Socio__c 
                            Where Id_GP__c = :idGP Or Socio_padre__r.Id_GP__c = :idGP
                            Order By Socio_padre__c NULLS FIRST];
        } else {
            idGP = suscriptorId + titularId;
            socioQuery = [  Select Id, Saldo_total__c, Cuenta__r.Id, Id_GP__c, Activo__c
                            From GP_Socio__c 
                            Where Id_GP__c = :idGP
                            Order By Socio_padre__c NULLS FIRST];
        }

        Map<String,Object> result = new Map<String,Object>();
        Map<String,Object> socioSaldosAssets = new Map<String,Object>();
        
        List<Map<String,Object>> listaSocios = new List<Map<String,Object>>();
        List<Map<String,Object>> puntosxVto = new List<Map<String,Object>>();
        List<Map<String,Object>> listaAssetSocio = new List<Map<String,Object>>();

        Double totalPuntosDisponibles = 0;

        if (socioQuery.size() > 0) {
            for (GP_Socio__c socio : socioQuery) {
                if(socio.Activo__c == true) {

                    socioSaldosAssets = new Map<String,Object>();
                    puntosxVto = new List<Map<String,Object>>();
                    listaAssetSocio = new List<Map<String,Object>>();

                    socioSaldosAssets.put('idCuenta',socio.Cuenta__c);
                    socioSaldosAssets.put('puntosSocio',socio.Saldo_total__c);
                    totalPuntosDisponibles += socio.Saldo_total__c;

                    //Consigo los próximos saldos a vencer
                    List<GP_Saldo_por_vencimiento__c> saldosAVencer = [ Select Id, Puntos__c, Vencimiento__c 
                                                                        From GP_Saldo_por_vencimiento__c 
                                                                        Where Socio__c = :socio.Id AND (Vencimiento__c > :Date.Today() OR Vencimiento__c = null) AND (Puntos__c > 0) 
                                                                        Order By Vencimiento__c ASC NULLS LAST];
                    if (saldosAVencer.size() > 0) {
                        for (GP_Saldo_por_vencimiento__c saldo : saldosAVencer) {
                            Map<String,Object> auxMap = new Map<String,Object>();

                            auxMap.put('puntos',saldo.Puntos__c);
                            auxMap.put('fechaVto',saldo.Vencimiento__c);
                            puntosxVto.add(auxMap);
                        }
                    }
                    socioSaldosAssets.put('saldos',puntosxVto);

                    List<GP_Lista_de_Asset__c> listaAssets = [  Select Id, Socio__c, Socio__r.Id_GP__c, MSISDN__c, Asset__c, Suscriber_id__c
                                                                From GP_Lista_de_Asset__c 
                                                                Where socio__c = :socio.Id];
                    if (listaAssets.size() > 0) {
                        for (GP_Lista_de_asset__c assetAux : listaAssets) {
                            Map<String,Object> assetMap = new Map<String,Object>();
                            assetMap.put('AssetId',assetAux.Asset__c);
                            assetMap.put('MSISDN',assetAux.MSISDN__c);
                            assetMap.put('SuscriberId',assetAux.Suscriber_id__c);
                            listaAssetSocio.add(assetMap);
                        }
                    }
                    socioSaldosAssets.put('assets',listaAssetSocio);

                    listaSocios.add(socioSaldosAssets);
                } else if(socio.Id_GP__c == idGP) {
                    throw new GP_Saldos_TransaccionesException('El acumulador de Id \''+socio.Id+'\' no se encuentra activo.');
                }
            }
        } else {
            throw new GP_APIException('No se encontró ningún Socio con el titularId: \'' + titularId + '\' y suscriptorId: \'' + suscriptorId + '\'.');
        }

        result.put('totalPuntosDisponibles', totalPuntosDisponibles);
        result.put('puntosxSocios', listaSocios);

        return result;
    }
    /* {
        'totalPuntosDisponibles': 6360,
        'puntosxSocios': [
            {
                'idCuenta': '0015000000Gv703',
                'puntosSocio': 5360,
                'saldos': [{puntos: 360, fechaVto: '31-12-2018'}, {puntos: 5000, fechaVto: '31-12-2019'} ],
                'assets': [{'GPAssetId':'0015000000VvWKA','AssetId':'0016000000VvAXO','MSISDN':'11'}, {'GPAssetId':'0015000000VvWKB','AssetId':'0016000000VvAXP','MSISDN':'22'}]
            },
            {
                'idCuenta': '0015000000Gv704',
                'puntosSocio': 1000,
                'saldos': [{puntos: 600, fechaVto: '31-12-2018'}, {puntos: 400, fechaVto: '30-03-2019'}],
                'assets': [{'GPAssetId':'0015000000VvWKC','AssetId':'0016000000VvAXN','MSISDN':'33'}]
            }
        ]
    } */
}