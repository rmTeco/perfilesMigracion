@isTest
public with sharing class GP_APITest {
    
    /*
    Test
    static testMethod void adherirUnSocioBulk() {

        Account cuenta = new Account();
        cuenta.name = 'unaCuenta';

        insert cuenta;

        GP_socioAAdherir socioAAdherir = new GP_socioAAdherir(cuenta.id, 'black', 'Low');

        List<GP_socioAAdherir> sociosAAdherir = new List<GP_socioAAdherir>();
        sociosAAdherir.add(socioAAdherir);

        String resultado = GP_Api.adherirSocio(sociosAAdherir);

        system.assertEquals(1, [select id from GP_Socio__c where activo__c = true].size());
    }

    static testMethod void adherirUnSocioQueYaExistiaAnteriorMente() {
        Account cuenta = new Account();
        cuenta.name = 'unaCuenta';

        insert cuenta;

        GP_Socio__c socio = new GP_Socio__c();
        socio.Activo__c = false;
        socio.Cuenta__c = cuenta.id;

        insert socio;

        GP_socioAAdherir socioAAdherir = new GP_socioAAdherir(cuenta.id, 'black', 'Low');

        List<GP_socioAAdherir> sociosAAdherir = new List<GP_socioAAdherir>();
        sociosAAdherir.add(socioAAdherir);

        String resultado = GP_Api.adherirSocio(sociosAAdherir);

        system.assertEquals(1, [select id from GP_Socio__c where activo__c = true].size());
    }

    static testMethod void consultarUnaTransaccion(){

        GP_Socio__c socio = new GP_Socio__c();
        socio.activo__c = true;
        insert socio;

        GP_Historia_transaccion__c transaccion = new GP_Historia_transaccion__c();
        transaccion.Socio__c = socio.id;
        insert transaccion;

        System.assertEquals(1, Gp_api.consultarTransacciones(socio.id, Date.today().addDays(-1), Date.today().addDays(+1)).size());

    }

    static testMethod void consultarEstadoSocio(){
        GP_Socio__c socio = new GP_Socio__c();
        socio.activo__c = true;
        insert socio;

        system.assertEquals(socio.id, Gp_api.consultarEstadoSocio(socio.id).id);
    }

    static testMethod void eliminarSocio(){
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.activo__c = true;
        insert socio;

        GP_Saldo_por_vencimiento__c saldo = new GP_Saldo_por_vencimiento__c();
        saldo.Socio__c = socio.id;
        saldo.puntos__c = 10;
        insert saldo;

        List<String> listaDeIds = new List<String>();
        listaDeIds.add(socio.id);

        gp_api.eliminarSocios(listaDeIds);

        System.assertEquals(1, [select id, activo__c from gp_socio__c].size());
        System.assertEquals(false, [select id, activo__c from gp_socio__c].activo__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());        
    }

    static testMethod void transferirPuntos(){

        GP_Socio__c socio = new GP_Socio__c();
        socio.saldo_total__c = 10;
        socio.activo__c = true;
        insert socio;

        GP_Saldo_por_vencimiento__c saldo = new GP_Saldo_por_vencimiento__c();
        saldo.Socio__c = socio.id;
        saldo.puntos__c = 10;
        saldo.vencimiento__c = Date.today().addDays(2);   
        insert saldo;

        GP_Socio__c socio2 = new GP_Socio__c();
        socio2.activo__c = true;
        insert socio2;

        gp_api.transferirPuntos(socio.id, socio2.id, 9);

        System.assertEquals(1,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__c =: socio.id].puntos__c);  
        System.assertEquals(9,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__c =: socio2.id].puntos__c);
        System.assertEquals(1, [select id, saldo_total__c from GP_Socio__c where id =: socio.id].saldo_total__c);
        System.assertEquals(9, [select id, saldo_total__c from GP_Socio__c where id =: socio2.id].saldo_total__c);

    }

    static testMethod void seGeneranVariasTransaccionesDeAltaSiSeConsumenVariosPuntosDeDistintasFechas(){
        GP_Socio__c socio = new GP_Socio__c();
        socio.saldo_total__c = 15;
        socio.activo__c = true;
        insert socio;

        GP_Saldo_por_vencimiento__c saldo = new GP_Saldo_por_vencimiento__c();
        saldo.Socio__c = socio.id;
        saldo.puntos__c = 10;
        saldo.vencimiento__c = Date.today().addDays(2);   
        insert saldo;

        GP_Saldo_por_vencimiento__c saldo2 = new GP_Saldo_por_vencimiento__c();
        saldo2.Socio__c = socio.id;
        saldo2.puntos__c = 5;
        saldo2.vencimiento__c = Date.today().addDays(3);   
        insert saldo2;

        GP_Socio__c socio2 = new GP_Socio__c();
        socio2.activo__c = true;
        socio2.saldo_total__c = 0;
        insert socio2;

        gp_api.transferirPuntos(socio.id, socio2.id, 11);

        system.debug([select id, puntos__c from GP_Historia_transaccion__c where socio__c =: socio2.id]);
        system.debug([select id, puntos__c from GP_Historia_transaccion__c where socio__c =: socio.id]);

        System.assertEquals(2,[select id, puntos__c from GP_Historia_transaccion__c where socio__c =: socio2.id].size());  
        System.assertEquals(4, [select id, saldo_total__c from GP_Socio__c where id =: socio.id].saldo_total__c);
        System.assertEquals(11, [select id, saldo_total__c from GP_Socio__c where id =: socio2.id].saldo_total__c); 
    }


    static testMethod void anularCanje(){
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.saldo_total__c = 10;
        socio.activo__c = true;
        insert socio;

        GP_Historia_transaccion__c transaccion = new GP_Historia_transaccion__c();
        transaccion.socio__c = socio.id;
        transaccion.numero_de_orden__c = 1;
        transaccion.puntos__c = 12;
        transaccion.vencimiento__c = Date.today().addDays(2);
        transaccion.Suma_o_resta__c = 'Resta';

        insert transaccion;

        gp_api.anularCanje(socio.id, 1);

        system.assertEquals(22, [select id, saldo_total__c from gp_socio__c ].saldo_total__c);
        system.assertEquals(12, [select id, puntos__c, vencimiento__c from GP_Saldo_por_vencimiento__c].puntos__c);
        system.assertEquals(Date.today().addDays(2), [select id, puntos__c, vencimiento__c from GP_Saldo_por_vencimiento__c].vencimiento__c);
    }

    //Realizar 
    static testMethod void siElCanjeGeneroVariasTransaccionesDeRestaAnulaTodasLasTransaccionesDeRestaYPorCadaUnaGeneraUnaDeAlta(){}

    static testMethod void modificarPermisoSocio(){
        GP_Socio__c socio = new GP_Socio__c();
        socio.activo__c = true;
        insert socio;

        gp_api.ModificarPermisoSocio(socio.id, 'Low');

        system.assertEquals('Low', [select id, permiso__c from gp_socio__c].permiso__c);
    }

    static testMethod void modificarTipoDeSocio(){
        GP_Socio__c socio = new GP_Socio__c();
        socio.activo__c = true;
        insert socio;

        gp_api.ModificarTipoDeSocio(socio.id, 'Black');

        system.assertEquals('Black', [select id, Tipo_de_socio__c from gp_socio__c].Tipo_de_socio__c);
    }

    static testMethod void sumarRestarPuntos(){
        
        GP_Socio__c socio = new GP_Socio__c();
        socio.activo__c = true;
        insert socio;


        List<GP_AtributoValorDeUnEvento> atributos = new List<GP_AtributoValorDeUnEvento>();
        atributos.add(new GP_AtributoValorDeUnEvento('Tipo De Cliente', 'String', 'DNI'));

        List<GP_sumarRestarPuntosItem> items = new List<GP_sumarRestarPuntosItem>();
        items.add(new GP_sumarRestarPuntosItem(socio.id, 'Bienvenida', 1, atributos));

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

        gp_api.sumarRestarPuntos(items);

        System.assertEquals(10,[select id, puntos__c from GP_Saldo_por_vencimiento__c where socio__c =: socio.id].puntos__c);
        System.assertEquals(10, [select id, saldo_total__c from GP_Socio__c where id =: socio.id].saldo_total__c);
        System.assertEquals(1, [select id from GP_Historia_transaccion__c].size());
        System.assertEquals(regla.id,[select id, Generado_por__c from GP_Historia_transaccion__c where socio__c =: socio.id].Generado_por__c);  
        
    }*/


}