@isTest
public with sharing class Gp_AdapterTest {

    //CrearAcumuladorSocioTitular
    
    static testMethod void crearAcumuladorTitularConUnAsset(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        insert cuenta;
        
        Asset unAsset = new Asset();
		unAsset.MSISDN__c = '111111';
        unAsset.name = 'asd';
        unAsset.accountId = cuenta.id;
        unAsset.vlocity_cmt__BillingAccountId__c = cuenta.id;
        unAsset.vlocity_cmt__ServiceAccountId__c = cuenta.id;
        insert unAsset;
        
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('cuenta',cuenta.id);

        List<object> todosLosSocios = new List<object>();
        todosLosSocios.add(datosPrimerCuenta);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio',todosLosSocios);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('crearAcumuladorSocioTitular', input, new Map<String,Object>(), new Map<String,Object>() );
        
        system.assertEquals(1, [select id from GP_Socio__c].size());
        system.assertEquals(cuenta.id+'0', [select id, id_gp__c from GP_Socio__c].id_gp__c);
        system.assertEquals(cuenta.id, [select id, cuenta__c from GP_Socio__c].cuenta__c); 
        system.assert([select id, activo__c from GP_Socio__c].activo__c);
        system.assertEquals(0, [select id, Saldo_total__c from GP_Socio__c].Saldo_total__c);
        system.assertEquals(null, [select id, Socio_padre__c from GP_Socio__c].Socio_padre__c);
        
        system.assertEquals(1, [select id from GP_Lista_de_Asset__c].size());
        system.assertEquals(cuenta.id+'0', [select id, Socio__r.id_gp__c from GP_Lista_de_Asset__c].Socio__r.id_gp__c);
        system.assertEquals(unAsset.id, [select id, asset__c from GP_Lista_de_Asset__c].asset__c);
    }
    
    static testMethod void crearDosAcumuladoresConUnAssetCadaUno(){
        
        
        List<Account> lstAcc = new List<Account>();
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        lstAcc.add(cuenta);

        Account segundaCuenta = new Account();
        segundaCuenta.name = 'cuenta2';
        segundaCuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        segundaCuenta.AccountIntegrationId__c = '0000000000000000';
        lstAcc.add(segundaCuenta);
        
        insert lstAcc;
        
        Asset unAsset = new Asset();
		unAsset.MSISDN__c = '111111';
        unAsset.name = 'asd';
        unAsset.accountId = cuenta.id;
        unAsset.vlocity_cmt__BillingAccountId__c = cuenta.id;
        unAsset.vlocity_cmt__ServiceAccountId__c = cuenta.id;
        insert unAsset;
        
        Asset unSegundoAsset = new Asset();
		unSegundoAsset.MSISDN__c = '123';
        unSegundoAsset.name = 'asset2';
        unSegundoAsset.accountId = segundaCuenta.id;
        unSegundoAsset.vlocity_cmt__BillingAccountId__c = segundaCuenta.id;
        unSegundoAsset.vlocity_cmt__ServiceAccountId__c = segundaCuenta.id;
        insert unSegundoAsset;
        
            
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('cuenta',cuenta.id);
        
        Map<String,Object> datosSegundaCuenta = new Map<String,Object>();
        datosSegundaCuenta.put('cuenta',segundaCuenta.id);

        List<object> todosLosSocios = new List<object>();
        todosLosSocios.add(datosPrimerCuenta);
        todosLosSocios.add(datosSegundaCuenta);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio',todosLosSocios);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('crearAcumuladorSocioTitular', input, new Map<String,Object>(), new Map<String,Object>() );
                
        System.assertEquals(2, [select id from account].size());
        system.assertEquals(2, [select id from GP_Socio__c].size());
        
        String idPrimerCuenta = cuenta.id+'0';
        system.assertEquals(1, [select id, id_gp__c from GP_Socio__c where id_gp__c =: idPrimerCuenta ].size());
        
        String idSegundaCuenta = segundaCuenta.id+'0';
        system.assertEquals(1, [select id, id_gp__c from GP_Socio__c where id_gp__c =: idSegundaCuenta ].size());
        
        GP_Socio__c socioUno = [select id, id_gp__c, cuenta__c, activo__c, Socio_padre__c from GP_Socio__c where id_gp__c =: idPrimerCuenta ];
        GP_Socio__c socioDos = [select id, id_gp__c, cuenta__c, activo__c, Socio_padre__c from GP_Socio__c where id_gp__c =: idSegundaCuenta ];
        
        system.assertEquals(cuenta.id, socioUno.cuenta__c);
        system.assertEquals(segundaCuenta.id, socioDos.cuenta__c);
        
        system.assert(socioUno.activo__c);
        system.assert(socioDos.activo__c);
        
        system.assertEquals(null, socioUno.Socio_padre__c);
        system.assertEquals(null, socioDos.Socio_padre__c);
        
        system.assertEquals(2, [select id from GP_Lista_de_Asset__c].size());
        
        GP_Lista_de_Asset__c assetUno = [select id, Socio__r.id_gp__c, asset__c from GP_Lista_de_Asset__c where asset__c =: unAsset.id];
        GP_Lista_de_Asset__c assetDos = [select id, Socio__r.id_gp__c, asset__c from GP_Lista_de_Asset__c where asset__c =: unSegundoAsset.id];       
        
        system.assertEquals(cuenta.id+'0', assetUno.Socio__r.id_gp__c);
        system.assertEquals(segundaCuenta.id+'0', assetDos.Socio__r.id_gp__c);
        
    }
    
    static testMethod void crearAcumuladorTitularJuntoConAcumuladorAdherente(){
        List<Account> lstAcc = new List<Account>();
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        lstAcc.add(cuenta);

        Account segundaCuenta = new Account();
        segundaCuenta.name = 'cuenta2';
        segundaCuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        segundaCuenta.AccountIntegrationId__c = '0000000000000000';
        lstAcc.add(segundaCuenta);
        
        insert lstAcc;
        
        Asset unAsset = new Asset();
		unAsset.MSISDN__c = '111111';
        unAsset.name = 'asd';
        unAsset.accountId = cuenta.id;
        unAsset.vlocity_cmt__BillingAccountId__c = cuenta.id;
        unAsset.vlocity_cmt__ServiceAccountId__c = cuenta.id;
        insert unAsset;
        
        Asset unSegundoAsset = new Asset();
		unSegundoAsset.MSISDN__c = '123';
        unSegundoAsset.name = 'asset2';
        unSegundoAsset.accountId = segundaCuenta.id;
        unSegundoAsset.vlocity_cmt__BillingAccountId__c = cuenta.id;
        unSegundoAsset.vlocity_cmt__ServiceAccountId__c = segundaCuenta.id;
        insert unSegundoAsset;
        
            
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('cuenta',cuenta.id);
        
        
        List<object> todosLosSocios = new List<object>();
        todosLosSocios.add(datosPrimerCuenta);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio',todosLosSocios);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('crearAcumuladorSocioTitular', input, new Map<String,Object>(), new Map<String,Object>() );
                
        System.assertEquals(2, [select id from account].size());
        system.assertEquals(2, [select id from GP_Socio__c].size());
        
        String idPrimerCuenta = cuenta.id+'0';
        system.assertEquals(1, [select id, id_gp__c from GP_Socio__c where id_gp__c =: idPrimerCuenta ].size());
        
        String idSegundaCuenta = ''+segundaCuenta.id+cuenta.id;
        system.assertEquals(1, [select id, id_gp__c from GP_Socio__c where id_gp__c =: idSegundaCuenta ].size());
        
        GP_Socio__c socioUno = [select id, id_gp__c, cuenta__c, activo__c, Socio_padre__c from GP_Socio__c where id_gp__c =: idPrimerCuenta ];
        GP_Socio__c socioDos = [select id, id_gp__c, cuenta__c, activo__c, Socio_padre__c from GP_Socio__c where id_gp__c =: idSegundaCuenta ];
        
        system.assertEquals(cuenta.id, socioUno.cuenta__c);
        system.assertEquals(segundaCuenta.id, socioDos.cuenta__c);
        
        system.assert(socioUno.activo__c);
        system.assert(socioDos.activo__c);
        
        system.assertEquals(null, socioUno.Socio_padre__c);
        system.assertEquals(socioUno.id, socioDos.Socio_padre__c);
        
        system.assertEquals(2, [select id from GP_Lista_de_Asset__c].size());
        
        GP_Lista_de_Asset__c assetUno = [select id, Socio__r.id_gp__c, asset__c from GP_Lista_de_Asset__c where asset__c =: unAsset.id];
        GP_Lista_de_Asset__c assetDos = [select id, Socio__r.id_gp__c, asset__c from GP_Lista_de_Asset__c where asset__c =: unSegundoAsset.id];       
        
        system.assertEquals(cuenta.id+'0', assetUno.Socio__r.id_gp__c);
        system.assertEquals(''+segundaCuenta.id+cuenta.id, assetDos.Socio__r.id_gp__c);
    }
    
    static testMethod void crearUnAcumuladorTitularQueEstabaInactivo(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        insert cuenta;
        
        GP_Socio__c socioInactivo = new GP_Socio__c();
        socioInactivo.activo__c = false;
        socioInactivo.cuenta__c = cuenta.id;
        socioInactivo.Saldo_total__c = 0;
        insert socioInactivo;
        
        Asset unAsset = new Asset();
		unAsset.MSISDN__c = '111111';
        unAsset.name = 'asd';
        unAsset.accountId = cuenta.id;
        unAsset.vlocity_cmt__BillingAccountId__c = cuenta.id;
        unAsset.vlocity_cmt__ServiceAccountId__c = cuenta.id;
        insert unAsset;
        
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('cuenta',cuenta.id);

        List<object> todosLosSocios = new List<object>();
        todosLosSocios.add(datosPrimerCuenta);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio',todosLosSocios);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('crearAcumuladorSocioTitular', input, new Map<String,Object>(), new Map<String,Object>() );
        
        system.debug([select id, id_gp__c, cuenta__c from GP_Socio__c]);
        
        system.assertEquals(1, [select id from GP_Socio__c].size());
        system.assertEquals(cuenta.id+'0', [select id, id_gp__c from GP_Socio__c].id_gp__c);
        system.assertEquals(cuenta.id, [select id, cuenta__c from GP_Socio__c].cuenta__c); 
        system.assert([select id, activo__c from GP_Socio__c].activo__c);
        system.assertEquals(0, [select id, Saldo_total__c from GP_Socio__c].Saldo_total__c);
        system.assertEquals(null, [select id, Socio_padre__c from GP_Socio__c].Socio_padre__c);
        
        system.assertEquals(1, [select id from GP_Lista_de_Asset__c].size());
        system.assertEquals(cuenta.id+'0', [select id, Socio__r.id_gp__c from GP_Lista_de_Asset__c].Socio__r.id_gp__c);
        system.assertEquals(unAsset.id, [select id, asset__c from GP_Lista_de_Asset__c].asset__c);
    }
    
    //crearAcumuladorSubscriptorNuevo
    
    static testMethod void crearUnAcumuladorSuscriptor(){
        
        List<Account> lstAcc = new List<Account>();
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        lstAcc.add(cuenta);

        Account segundaCuenta = new Account();
        segundaCuenta.name = 'cuenta2';
        segundaCuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        segundaCuenta.AccountIntegrationId__c = '0000000000000000';
        lstAcc.add(segundaCuenta);
        
        insert lstAcc;
        
        GP_Socio__c socioTitular = new GP_Socio__c();
        socioTitular.activo__c = true;
        socioTitular.cuenta__c = cuenta.id;
        socioTitular.Saldo_total__c = 0;
        insert socioTitular;
        
        
        Asset unAsset = new Asset();
		unAsset.MSISDN__c = '111111';
        unAsset.name = 'asd';
        unAsset.accountId = cuenta.id;
        unAsset.vlocity_cmt__BillingAccountId__c = cuenta.id;
        unAsset.vlocity_cmt__ServiceAccountId__c = segundaCuenta.id;
        insert unAsset;
        
        List<String> idsAssets = new List<String>();
        idsAssets.add(unAsset.id);
        
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('titularID',cuenta.id);
        datosPrimerCuenta.put('suscriptorID',segundaCuenta.id);
        datosPrimerCuenta.put('assetsID',idsAssets);

        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio',datosPrimerCuenta);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('crearAcumuladorSubscriptorNuevo', input, new Map<String,Object>(), new Map<String,Object>() );
        
        
        system.assertEquals(2, [select id from GP_Socio__c].size());
        
        String idPrimerCuenta = cuenta.id+'0';
        system.assertEquals(1, [select id, id_gp__c from GP_Socio__c where id_gp__c =: idPrimerCuenta ].size());
        
        String idSegundaCuenta = ''+segundaCuenta.id+cuenta.id;
        system.assertEquals(1, [select id, id_gp__c from GP_Socio__c where id_gp__c =: idSegundaCuenta ].size());
        
        GP_Socio__c socioUno = [select id, id_gp__c, cuenta__c, activo__c, Socio_padre__c from GP_Socio__c where id_gp__c =: idPrimerCuenta ];
        GP_Socio__c socioDos = [select id, id_gp__c, cuenta__c, activo__c, Socio_padre__c from GP_Socio__c where id_gp__c =: idSegundaCuenta ];
        
        system.assertEquals(cuenta.id, socioUno.cuenta__c);
        system.assertEquals(segundaCuenta.id, socioDos.cuenta__c);
        
        system.assert(socioUno.activo__c);
        system.assert(socioDos.activo__c);
        
        system.assertEquals(null, socioUno.Socio_padre__c);
        system.assertEquals(socioUno.id, socioDos.Socio_padre__c);
        
        system.assertEquals(1, [select id from GP_Lista_de_Asset__c].size());
        
        GP_Lista_de_Asset__c assetUno = [select id, Socio__r.id_gp__c, asset__c from GP_Lista_de_Asset__c where asset__c =: unAsset.id];
        
        system.assertEquals(''+segundaCuenta.id+cuenta.id, assetUno.Socio__r.id_gp__c);
        
    }
    
    static testMethod void creoUnAcumuladorSuscriptorQueEstabaInactivo(){
        List<Account> lstAcc = new List<Account>();
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        lstAcc.add(cuenta);

        Account segundaCuenta = new Account();
        segundaCuenta.name = 'cuenta2';
        segundaCuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        segundaCuenta.AccountIntegrationId__c = '0000000000000000';
        lstAcc.add(segundaCuenta);
        
        insert lstAcc;
        
        GP_Socio__c socioTitular = new GP_Socio__c();
        socioTitular.activo__c = true;
        socioTitular.cuenta__c = cuenta.id;
        socioTitular.Saldo_total__c = 0;
        insert socioTitular;
        
        GP_Socio__c socioAdherente = new GP_Socio__c();
        socioAdherente.activo__c = false;
        socioAdherente.Socio_padre__c = socioTitular.id;
        socioAdherente.cuenta__c = segundaCuenta.id;
        socioAdherente.Saldo_total__c = 0;
        insert socioAdherente;        
        
        Asset unAsset = new Asset();
		unAsset.MSISDN__c = '111111';
        unAsset.name = 'asd';
        unAsset.accountId = cuenta.id;
        unAsset.vlocity_cmt__BillingAccountId__c = cuenta.id;
        unAsset.vlocity_cmt__ServiceAccountId__c = segundaCuenta.id;
        insert unAsset;
        
        List<String> idsAssets = new List<String>();
        idsAssets.add(unAsset.id);
        
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('titularID',cuenta.id);
        datosPrimerCuenta.put('suscriptorID',segundaCuenta.id);
        datosPrimerCuenta.put('assetsID',idsAssets);

        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio',datosPrimerCuenta);
        
        gp_adapter clase = new gp_adapter();
        Map<String,Object> outPut = new Map<String, Object>();
        
        clase.invokeMethod('crearAcumuladorSubscriptorNuevo', input, outPut, new Map<String,Object>() );
        system.debug(outPut);
        
        system.assertEquals(2, [select id from GP_Socio__c].size());
        
        String idPrimerCuenta = cuenta.id+'0';
        system.assertEquals(1, [select id, id_gp__c from GP_Socio__c where id_gp__c =: idPrimerCuenta ].size());
        
        String idSegundaCuenta = ''+segundaCuenta.id+cuenta.id;
        system.assertEquals(1, [select id, id_gp__c from GP_Socio__c where id_gp__c =: idSegundaCuenta ].size());
        
        GP_Socio__c socioUno = [select id, id_gp__c, cuenta__c, activo__c, Socio_padre__c from GP_Socio__c where id_gp__c =: idPrimerCuenta ];
        GP_Socio__c socioDos = [select id, id_gp__c, cuenta__c, activo__c, Socio_padre__c from GP_Socio__c where id_gp__c =: idSegundaCuenta ];
        
        system.assertEquals(cuenta.id, socioUno.cuenta__c);
        system.assertEquals(segundaCuenta.id, socioDos.cuenta__c);
        
        system.assert(socioUno.activo__c);
        system.assert(socioDos.activo__c);
        
        system.assertEquals(null, socioUno.Socio_padre__c);
        system.assertEquals(socioUno.id, socioDos.Socio_padre__c);
        
        system.assertEquals(1, [select id from GP_Lista_de_Asset__c].size());
        
        GP_Lista_de_Asset__c assetUno = [select id, Socio__r.id_gp__c, asset__c from GP_Lista_de_Asset__c where asset__c =: unAsset.id];
        
        system.assertEquals(''+segundaCuenta.id+cuenta.id, assetUno.Socio__r.id_gp__c);
    }
    
    //sumarRestarPuntos
    
    static testMethod void sumoPuntos(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = true;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '=';
        condicional.Regla__c = regla.id;
        condicional.Valor_contra_el_que_se_compara__c = 'DNI';
        condicional.Variable_a_comparar__c = 'Tipo De Cliente';
        condicional.Variable_contra_la_que_se_compara__c = 'Tipo De Cliente';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(10,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(10, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    static testMethod void RestoPuntosPorEventoCanje(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Canje';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = true;

        insert regla;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'puntos');
        mapaDeAtributo.put('tipo', 'Integer');
        mapaDeAtributo.put('valorInteger', 0);
        
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Canje');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
    }
    
    static testMethod void siLaReglaNoCumpleNoSumaPuntos(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = true;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '!=';
        condicional.Regla__c = regla.id;
        condicional.Valor_contra_el_que_se_compara__c = 'DNI';
        condicional.Variable_a_comparar__c = 'Tipo De Cliente';
        condicional.Variable_contra_la_que_se_compara__c = 'Tipo De Cliente';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(0, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(0, [select id from GP_Historia_transaccion__c].size());
    }
    
    static testMethod void siLaReglaCumpleSumaPuntosCalculados(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        //atributos.add(new GP_AtributoValorDeUnEvento('Monto', 'Integer', 230));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = false;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '+';
        regla.Valor_calculo__c = 20;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '=';
        condicional.Regla__c = regla.id;
        condicional.Valor_contra_el_que_se_compara__c = 'DNI';
        condicional.Variable_a_comparar__c = 'Tipo De Cliente';
        condicional.Variable_contra_la_que_se_compara__c = 'Tipo De Cliente';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        map<String,Object> mapaDeAtributo2 = new Map<String, Object>();
        mapaDeAtributo2.put('variable', 'Monto');
        mapaDeAtributo2.put('tipo', 'Integer');
        mapaDeAtributo2.put('valorInteger', 230);
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        atributoDeEventoLista.add(mapaDeAtributo2);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(250,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(250, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    static testMethod void siLaReglaCumpleRestaPuntosCalculados(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        //atributos.add(new GP_AtributoValorDeUnEvento('Monto', 'Integer', 230));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = false;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '-';
        regla.Valor_calculo__c = 20;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '=';
        condicional.Regla__c = regla.id;
        condicional.Valor_contra_el_que_se_compara__c = 'DNI';
        condicional.Variable_a_comparar__c = 'Tipo De Cliente';
        condicional.Variable_contra_la_que_se_compara__c = 'Tipo De Cliente';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        map<String,Object> mapaDeAtributo2 = new Map<String, Object>();
        mapaDeAtributo2.put('variable', 'Monto');
        mapaDeAtributo2.put('tipo', 'Integer');
        mapaDeAtributo2.put('valorInteger', 230);
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        atributoDeEventoLista.add(mapaDeAtributo2);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(210,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(210, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    static testMethod void siLaReglaCumpleMultiplicoPuntosCalculados(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        //atributos.add(new GP_AtributoValorDeUnEvento('Monto', 'Integer', 230));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = false;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '*';
        regla.Valor_calculo__c = 10;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '=';
        condicional.Regla__c = regla.id;
        condicional.Valor_contra_el_que_se_compara__c = 'DNI';
        condicional.Variable_a_comparar__c = 'Tipo De Cliente';
        condicional.Variable_contra_la_que_se_compara__c = 'Tipo De Cliente';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        map<String,Object> mapaDeAtributo2 = new Map<String, Object>();
        mapaDeAtributo2.put('variable', 'Monto');
        mapaDeAtributo2.put('tipo', 'Integer');
        mapaDeAtributo2.put('valorInteger', 230);
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        atributoDeEventoLista.add(mapaDeAtributo2);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(2300,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(2300, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    static testMethod void siLaReglaCumpleDividoPuntosCalculados(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        //atributos.add(new GP_AtributoValorDeUnEvento('Monto', 'Integer', 230));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = false;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '/';
        regla.Valor_calculo__c = 10;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '=';
        condicional.Regla__c = regla.id;
        condicional.Valor_contra_el_que_se_compara__c = 'DNI';
        condicional.Variable_a_comparar__c = 'Tipo De Cliente';
        condicional.Variable_contra_la_que_se_compara__c = 'Tipo De Cliente';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        map<String,Object> mapaDeAtributo2 = new Map<String, Object>();
        mapaDeAtributo2.put('variable', 'Monto');
        mapaDeAtributo2.put('tipo', 'Integer');
        mapaDeAtributo2.put('valorInteger', 230);
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        atributoDeEventoLista.add(mapaDeAtributo2);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(23,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(23, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    static testMethod void siLaReglaCumpleHagoElPorcentajePuntosCalculados(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        //atributos.add(new GP_AtributoValorDeUnEvento('Monto', 'Integer', 230));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = false;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '%';
        regla.Valor_calculo__c = 50;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '=';
        condicional.Regla__c = regla.id;
        condicional.Valor_contra_el_que_se_compara__c = 'DNI';
        condicional.Variable_a_comparar__c = 'Tipo De Cliente';
        condicional.Variable_contra_la_que_se_compara__c = 'Tipo De Cliente';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        map<String,Object> mapaDeAtributo2 = new Map<String, Object>();
        mapaDeAtributo2.put('variable', 'Monto');
        mapaDeAtributo2.put('tipo', 'Integer');
        mapaDeAtributo2.put('valorInteger', 230);
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        atributoDeEventoLista.add(mapaDeAtributo2);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(115,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(115, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    static testMethod void prueboLaReglaConAtributosInteger(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        atributos.add(new GP_AtributoValorDeUnEvento('Monto', 'Integer', 230));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = false;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '%';
        regla.Valor_calculo__c = 50;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '>';
        condicional.Regla__c = regla.id;
        condicional.Valor_entero__c = 20;
        condicional.Variable_a_comparar__c = 'Monto';
        condicional.Variable_contra_la_que_se_compara__c = 'Monto';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        map<String,Object> mapaDeAtributo2 = new Map<String, Object>();
        mapaDeAtributo2.put('variable', 'Monto');
        mapaDeAtributo2.put('tipo', 'Integer');
        mapaDeAtributo2.put('valorInteger', 230);
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        atributoDeEventoLista.add(mapaDeAtributo2);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(115,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(115, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    static testMethod void prueboLaReglaConAtributosIntegerMenor(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        atributos.add(new GP_AtributoValorDeUnEvento('Monto', 'Integer', 230));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = false;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '%';
        regla.Valor_calculo__c = 50;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '<';
        condicional.Regla__c = regla.id;
        condicional.Valor_entero__c = 249;
        condicional.Variable_a_comparar__c = 'Monto';
        condicional.Variable_contra_la_que_se_compara__c = 'Monto';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        map<String,Object> mapaDeAtributo2 = new Map<String, Object>();
        mapaDeAtributo2.put('variable', 'Monto');
        mapaDeAtributo2.put('tipo', 'Integer');
        mapaDeAtributo2.put('valorInteger', 230);
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        atributoDeEventoLista.add(mapaDeAtributo2);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        
        System.assertEquals(115,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(115, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    static testMethod void prueboLaReglaConAtributosIntegerIgual(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        atributos.add(new GP_AtributoValorDeUnEvento('Monto', 'Integer', 230));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = false;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '%';
        regla.Valor_calculo__c = 50;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '=';
        condicional.Regla__c = regla.id;
        condicional.Valor_entero__c = 230;
        condicional.Variable_a_comparar__c = 'Monto';
        condicional.Variable_contra_la_que_se_compara__c = 'Monto';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        map<String,Object> mapaDeAtributo2 = new Map<String, Object>();
        mapaDeAtributo2.put('variable', 'Monto');
        mapaDeAtributo2.put('tipo', 'Integer');
        mapaDeAtributo2.put('valorInteger', 230);
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        atributoDeEventoLista.add(mapaDeAtributo2);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(115,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(115, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    static testMethod void prueboLaReglaConAtributosIntegerMayorIgual(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        atributos.add(new GP_AtributoValorDeUnEvento('Monto', 'Integer', 230));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = false;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '%';
        regla.Valor_calculo__c = 50;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '>=';
        condicional.Regla__c = regla.id;
        condicional.Valor_entero__c = 230;
        condicional.Variable_a_comparar__c = 'Monto';
        condicional.Variable_contra_la_que_se_compara__c = 'Monto';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        map<String,Object> mapaDeAtributo2 = new Map<String, Object>();
        mapaDeAtributo2.put('variable', 'Monto');
        mapaDeAtributo2.put('tipo', 'Integer');
        mapaDeAtributo2.put('valorInteger', 230);
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        atributoDeEventoLista.add(mapaDeAtributo2);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(115,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(115, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    static testMethod void prueboLaReglaConAtributosIntegerMenorIgual(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        atributos.add(new GP_AtributoValorDeUnEvento('Monto', 'Integer', 230));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = false;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '%';
        regla.Valor_calculo__c = 50;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '<=';
        condicional.Regla__c = regla.id;
        condicional.Valor_entero__c = 230;
        condicional.Variable_a_comparar__c = 'Monto';
        condicional.Variable_contra_la_que_se_compara__c = 'Monto';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        map<String,Object> mapaDeAtributo2 = new Map<String, Object>();
        mapaDeAtributo2.put('variable', 'Monto');
        mapaDeAtributo2.put('tipo', 'Integer');
        mapaDeAtributo2.put('valorInteger', 230);
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        atributoDeEventoLista.add(mapaDeAtributo2);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(115,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(115, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    static testMethod void prueboLaReglaConAtributosIntegerDistinto(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.Saldo_total__c = 0;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));
        atributos.add(new GP_AtributoValorDeUnEvento('Monto', 'Integer', 230));
        

        GP_Regla__c regla = new GP_Regla__c();
        regla.Fecha_vencimiento__c = Date.today().addDays(2);
        regla.Tipo_de_evento__c = 'Bienvenida';
        regla.Valor_resultado_fijo__c = 10;
        regla.Vigencia_desde__c = Date.today().addDays(-1);
        regla.Vigencia_hasta__c = Date.today().addDays(2);
        regla.vencimiento_fecha_fija__c = true;
        regla.SeComparaContraElValorFijo__c = false;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '%';
        regla.Valor_calculo__c = 50;

        insert regla;

        GP_Condicional_logico__c condicional = new GP_Condicional_logico__c();
        condicional.Operador__c = '!=';
        condicional.Regla__c = regla.id;
        condicional.Valor_entero__c = 210;
        condicional.Variable_a_comparar__c = 'Monto';
        condicional.Variable_contra_la_que_se_compara__c = 'Monto';

        insert condicional;


        //Armado del mapa.
        
        map<String,Object> mapaDeAtributo = new Map<String, Object>();
        mapaDeAtributo.put('variable', 'Tipo De Cliente');
        mapaDeAtributo.put('tipo', 'String');
        mapaDeAtributo.put('valorString', 'DNI');
        
        
        map<String,Object> mapaDeAtributo2 = new Map<String, Object>();
        mapaDeAtributo2.put('variable', 'Monto');
        mapaDeAtributo2.put('tipo', 'Integer');
        mapaDeAtributo2.put('valorInteger', 230);
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(mapaDeAtributo);
        atributoDeEventoLista.add(mapaDeAtributo2);
        
        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        primerMapa.put('tipoDeEvento', 'Bienvenida');
        primerMapa.put('numeroDeOrden', 111);
        primerMapa.put('atributosEvento', atributoDeEventoLista);
        
        List<Object> listaAux = new List<Object>();
        listaAux.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('sumarRestarPuntos', listaAux);
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('sumarRestarPuntos', input, new Map<String,Object>(), new Map<String,Object>() );
        
        //==================================================
        
        System.assertEquals(1, [select id from gp_socio__c].size());
        
        system.debug([select id, puntos__c from GP_Saldo_por_vencimiento__c]);

        System.assertEquals(115,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__r.id_gp__c =: cuenta.id+'0'].puntos__c);
        System.assertEquals(115, [select id, saldo_total__c from GP_Socio__c where id_gp__c =: cuenta.id+'0'].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__r.id_gp__c =: cuenta.id+'0'].Generado_por__c);  
    }
    
    //consultarTransacciones
    
    static testMethod void consultoLasTransacciones(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        insert socio;

        GP_Historia_transaccion__c transaccion = new GP_Historia_transaccion__c();
        transaccion.Socio__c = socio.id;
        insert transaccion;
        
        
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('titularID',cuenta.id);
        datosPrimerCuenta.put('suscriptorID','0');
        datosPrimerCuenta.put('fechaDesde',Date.today().addDays(-1));
        datosPrimerCuenta.put('fechaHasta',Date.today().addDays(+1));

        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio',datosPrimerCuenta);
        
        Map<String,Object> outPut = new Map<String,Object>();
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('consultarTransacciones', input, outPut, new Map<String,Object>() );
        
        system.debug(outPut);
        
        List<GP_Historia_transaccion__c> listaResultado = (List<GP_Historia_transaccion__c>) outPut.get('transacciones');
        
        System.assertEquals(1, listaResultado.size());
        System.assertEquals(transaccion.id, listaResultado[0].id);
    }
    
    //consultarEstadoAcumulador
    
    static testMethod void consultarEstadoAcumulador(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.saldo_total__c = 0;
        insert socio;

        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('titularID',cuenta.id);
        datosPrimerCuenta.put('suscriptorID','0');

        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio',datosPrimerCuenta);
        
        Map<String,Object> outPut = new Map<String,Object>();
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('consultarEstadoAcumulador', input, outPut, new Map<String,Object>() );
        
        system.debug(outPut);
        
        Map<String,Object> resultado = (Map<String,Object>) outPut.get('transacciones');
        system.assertEquals('Activo',(String) resultado.get('Estado'));
        system.assertEquals('0', (String) resultado.get('totalPuntosDisponible'));
        
    }
    
    //EliminarAcumuladores
    
    static testMethod void eliminarUnAcumulador(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.saldo_total__c = 0;
        insert socio;

        Map<String,Object> primerMapa = new Map<String,object>();
        primerMapa.put('titularID', cuenta.id);
        primerMapa.put('suscriptorID', '0');
        
        List<Object> atributoDeEventoLista = new List<Object>();
        atributoDeEventoLista.add(primerMapa);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio', atributoDeEventoLista);
        
        Map<String,Object> outPut = new Map<String,Object>();
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('eliminarAcumuladores', input, outPut, new Map<String,Object>() );
        
        system.debug(outPut);
        
        Gp_socio__c socioAux = [select id, activo__c from Gp_socio__c];
        
        system.assertEquals(false, socioAux.activo__c);
    }
    
    //ConsultarPuntos
    
    static testMethod void consultarPuntos(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.saldo_total__c = 0;
        insert socio;
        
        GP_Saldo_por_vencimiento__c saldo = new GP_Saldo_por_vencimiento__c();
        saldo.puntos__c = 10;
        saldo.vencimiento__C = date.today().addDays(2);
        saldo.Socio__c = socio.id;
        
        insert saldo;
        
        GP_Historia_transaccion__c transaccion = new GP_Historia_transaccion__c();
        transaccion.Socio__c = socio.id;
        transaccion.Puntos__c = 10;
        transaccion.Suma_o_resta__c = 'suma';
        insert transaccion;
        
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('titularID',cuenta.id);
        datosPrimerCuenta.put('suscriptorID','0');

        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio',datosPrimerCuenta);
        
        Map<String,Object> outPut = new Map<String,Object>();
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('consultarPuntos', input, outPut, new Map<String,Object>() );
        
        system.debug(outPut);
        
    }
    
    //TransferirPuntos
    
    static testMethod void TransferirPuntos(){
        List<Account> lstAcc = new List<Account>();
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        lstAcc.add(cuenta);

        Account segundaCuenta = new Account();
        segundaCuenta.name = 'cuenta2';
        segundaCuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        segundaCuenta.AccountIntegrationId__c = '0000000000000000';
        lstAcc.add(segundaCuenta);
        
        insert lstAcc;
        
        GP_Socio__c socioTitular = new GP_Socio__c();
        socioTitular.activo__c = true;
        socioTitular.cuenta__c = cuenta.id;
        socioTitular.Saldo_total__c = 100;
        insert socioTitular;
        
        GP_Socio__c socioAdherente = new GP_Socio__c();
        socioAdherente.activo__c = true;
        socioAdherente.Socio_padre__c = socioTitular.id;
        socioAdherente.cuenta__c = segundaCuenta.id;
        socioAdherente.Saldo_total__c = 200;
        insert socioAdherente;
        
        GP_Historia_transaccion__c transaccion = new GP_Historia_transaccion__c();
        transaccion.Socio__c = socioTitular.id;
        transaccion.Puntos__c = 100;
        transaccion.Suma_o_resta__c = 'suma';
        transaccion.Vencimiento__c = date.today().addDays(2);
        insert transaccion;
        
        GP_Historia_transaccion__c transaccion2 = new GP_Historia_transaccion__c();
        transaccion2.Socio__c = socioAdherente.id;
        transaccion2.Puntos__c = 200;
        transaccion2.Suma_o_resta__c = 'suma';
        transaccion2.Vencimiento__c = date.today().addDays(2);
        insert transaccion2;
        
        GP_Saldo_por_vencimiento__c saldo = new GP_Saldo_por_vencimiento__c();
        saldo.puntos__c = 100;
        saldo.vencimiento__C = date.today().addDays(2);
        saldo.Socio__c = socioTitular.id;
        
        insert saldo;
        
        GP_Saldo_por_vencimiento__c saldo2 = new GP_Saldo_por_vencimiento__c();
        saldo2.puntos__c = 200;
        saldo2.vencimiento__C = date.today().addDays(2);
        saldo2.Socio__c = socioAdherente.id;
        
        insert saldo2;
        
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('titularIDdesde',cuenta.id);
        datosPrimerCuenta.put('suscriptorHacia', segundaCuenta.id);
        datosPrimerCuenta.put('suscriptorDesde','0');
        datosPrimerCuenta.put('puntos',50);

        Map<String,Object> input = new Map<String,Object>();
        input.put('datosTransferirPuntos',datosPrimerCuenta);
        
        Map<String,Object> outPut = new Map<String,Object>();
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('transferirPuntos', input, outPut, new Map<String,Object>() );
        
        system.debug(outPut);
        
        gp_socio__c socioAux = [select id, Saldo_total__c from gp_socio__c where id =:socioAdherente.id];
        
        system.assertEquals(250, socioAux.Saldo_total__c);
    }
    
    //AnularCanje
    
    static testMethod void anularUnCanje(){
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socioTitular = new GP_Socio__c();
        socioTitular.activo__c = true;
        socioTitular.cuenta__c = cuenta.id;
        socioTitular.Saldo_total__c = 0;
        insert socioTitular;
        
        GP_Historia_transaccion__c transaccion = new GP_Historia_transaccion__c();
        transaccion.Socio__c = socioTitular.id;
        transaccion.Puntos__c = 100;
        transaccion.Suma_o_resta__c = 'Resta';
        transaccion.Vencimiento__c = date.today().addDays(2);
        transaccion.Numero_de_orden__c = 1111;
        insert transaccion;
        
        
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('titularID',cuenta.id);
        datosPrimerCuenta.put('suscriptorID','0');
        datosPrimerCuenta.put('numOrdenServicio',1111);
        

        Map<String,Object> input = new Map<String,Object>();
        input.put('datosAnularCanje',datosPrimerCuenta);
        
        Map<String,Object> outPut = new Map<String,Object>();
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('anularCanje', input, outPut, new Map<String,Object>() );
        
        system.debug(outPut);
        
        GP_Socio__c socioAux = [select id, saldo_total__c from  GP_Socio__c];
        
        system.assertEquals(100, socioAux.saldo_total__c);
    }
    
    //AgregarAsset
    
    static testMethod void agregarUnAsset(){
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.saldo_total__c = 0;
        insert socio;

        Asset unAsset = new Asset();
		unAsset.MSISDN__c = '111111';
        unAsset.name = 'asd';
        unAsset.accountId = cuenta.id;
        unAsset.vlocity_cmt__BillingAccountId__c = cuenta.id;
        unAsset.vlocity_cmt__ServiceAccountId__c = cuenta.id;
        insert unAsset;
        
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('titularID',cuenta.id);
        datosPrimerCuenta.put('suscriptorID','0');
        datosPrimerCuenta.put('assetID',unAsset.id);
        

        Map<String,Object> input = new Map<String,Object>();
        input.put('datosSocio',datosPrimerCuenta);
        
        Map<String,Object> outPut = new Map<String,Object>();
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('agregarAsset', input, outPut, new Map<String,Object>() );
        
        system.assertEquals(1, [select id from GP_Lista_de_Asset__c].size());
    }
    
    //EliminarUnAsset
    
    static testMethod void eliminarUnAsset(){
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '1111111111111111';
        insert cuenta;
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.cuenta__c = cuenta.id;
        socio.activo__c = true;
        socio.saldo_total__c = 0;
        insert socio;

        Asset unAsset = new Asset();
		unAsset.MSISDN__c = '111111';
        unAsset.name = 'asd';
        unAsset.accountId = cuenta.id;
        unAsset.vlocity_cmt__BillingAccountId__c = cuenta.id;
        unAsset.vlocity_cmt__ServiceAccountId__c = cuenta.id;
        insert unAsset;
        
        GP_Lista_de_Asset__c UnAssetGP = new GP_Lista_de_Asset__c();
        UnAssetGP.Asset__c = unAsset.id;
        unAssetGP.Socio__c = socio.id;
        insert unAssetGP;
        
        Map<String,Object> datosPrimerCuenta = new Map<String,Object>();
        datosPrimerCuenta.put('assetID',unAsset.id);
        
        List<object> todosLosSocios = new List<object>();
        todosLosSocios.add(datosPrimerCuenta);
        
        Map<String,Object> input = new Map<String,Object>();
        input.put('datosAssets',todosLosSocios);
        
        Map<String,Object> outPut = new Map<String,Object>();
        
        gp_adapter clase = new gp_adapter();
        clase.invokeMethod('eliminarAsset', input, outPut, new Map<String,Object>() );
        
        system.assertEquals(0, [select id from GP_Lista_de_Asset__c].size());
    }
    
}