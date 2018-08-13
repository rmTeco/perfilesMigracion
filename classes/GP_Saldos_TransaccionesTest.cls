@isTest
Global with sharing class GP_Saldos_TransaccionesTest {

    private static GP_Socio__c generarSocio(Double saldo) {
        Account cuenta = new Account(Name = 'cuenta de socio Test');
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        insert cuenta;
        GP_Socio__c socio = new GP_Socio__c(Saldo_total__c = saldo, Cuenta__c = cuenta.Id, Activo__c = true);
        insert socio;
        return socio;
    }

    private static GP_Socio__c generarSocioHijo(Double saldo, String socioPadre) {
        Account cuenta = new Account(Name = 'cuenta de socio hijo Test');
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        insert cuenta;
        GP_Socio__c socio = new GP_Socio__c(Saldo_total__c = saldo, Socio_padre__c = socioPadre, Cuenta__c = cuenta.Id, Activo__c = true);
        insert socio;
        return socio;
    }

    private static GP_Regla__c generarRegla() {
        GP_Regla__c regla = new GP_Regla__c();
        insert regla;
        return regla;
    }

    private static void generarSaldos(Double puntos, ID socioId, Date vto) {
        GP_Saldo_por_vencimiento__c saldo = new GP_Saldo_por_vencimiento__c(Puntos__c = puntos, Socio__c = socioId, Vencimiento__c = vto);
        insert saldo;
    }

    public static testMethod void testSumarSaldo() {
        GP_Socio__c socio = generarSocio(0);
        GP_Regla__c regla = generarRegla();
        Date fechaVTO = Date.parse('02/09/2019');
        
        List<GP_datosTransaccion> listDatos = new List<GP_datosTransaccion>();
        GP_datosTransaccion dato = new GP_datosTransaccion(regla.Id,String.valueOf(socio.Cuenta__c),'',30,'Suma','Bienvenida',6540,fechaVTO);
        listDatos.add(dato);

        Test.StartTest();
        List<GP_Historia_transaccion__c> result = GP_Saldos_Transacciones.generarTransaccionActualizarSaldo(listDatos);

        socio = [Select Saldo_total__c From GP_Socio__c Where Id = :socio.Id];
        system.assert(socio.Saldo_total__c == 30);
        Test.StopTest();
    }

    public static testMethod void testConsumirSaldo() {
        GP_Socio__c socio = generarSocio(60);
        GP_Regla__c regla = generarRegla();
        generarSaldos(10, socio.Id, Date.Today());
        generarSaldos(20, socio.Id, Date.Today() + 1);
        generarSaldos(30, socio.Id, Date.Today() + 2);

        List<GP_datosTransaccion> listDatos = new List<GP_datosTransaccion>();
        GP_datosTransaccion dato = new GP_datosTransaccion(regla.Id,socio.Cuenta__c,'',30,'Resta','',0,null);
        listDatos.add(dato);

        Test.StartTest();
        List<GP_Historia_transaccion__c> result = GP_Saldos_Transacciones.generarTransaccionActualizarSaldo(listDatos);

        socio = [Select Saldo_total__c From GP_Socio__c Where Id = :socio.Id];
        system.assert(socio.Saldo_total__c == 30);
        Test.StopTest();
    }

    public static testMethod void testSumarConsumir() {
        GP_Socio__c socio1 = generarSocio(0);
        GP_Regla__c regla1 = generarRegla();
        GP_Socio__c socioTest = new GP_Socio__c();
        
        List<GP_datosTransaccion> listDatos = new List<GP_datosTransaccion>();
        GP_datosTransaccion dato1 = new GP_datosTransaccion(regla1.Id,socio1.Cuenta__c,'',10,'Suma','Bienvenida',6540,Date.Today());
        GP_datosTransaccion dato2 = new GP_datosTransaccion(regla1.Id,socio1.Cuenta__c,'',15,'Suma','Bienvenida',6541,Date.Today() + 1);
        GP_datosTransaccion dato3 = new GP_datosTransaccion(regla1.Id,socio1.Cuenta__c,'',30,'Suma','Bienvenida',6542,Date.Today() + 2);
        GP_datosTransaccion dato4 = new GP_datosTransaccion(regla1.Id,socio1.Cuenta__c,'',30,'Resta','',null,null);
        listDatos.add(dato1);
        listDatos.add(dato2);
        listDatos.add(dato3);
        listDatos.add(dato4);

        Test.StartTest();
        List<GP_Historia_transaccion__c> resultTransac = GP_Saldos_Transacciones.generarTransaccionActualizarSaldo(listDatos);
        Map<String, Object> result = GP_API.consultarPuntos(socio1.Cuenta__c,'');

        List<GP_Saldo_por_vencimiento__c> saldos = [Select Id, Puntos__c From GP_Saldo_por_vencimiento__c Where Socio__c =: socio1.Id];
        List<GP_Historia_transaccion__c> transacciones = [Select Id From GP_Historia_transaccion__c Where Socio__c =: socio1.Id];
        socioTest = [Select Saldo_total__c From GP_Socio__c Where Id = :socio1.Id];

        system.assert(result.get('totalPuntosDisponibles') == socioTest.Saldo_total__c);
        //system.assert(result.get('FechaProxVto') == Date.Today() + 2);
        //system.assert(result.get('SaldoVence') == 25);

        system.assert(saldos.size() == 3);
        system.assert(transacciones.size() == resultTransac.size());
        system.assert(socioTest.Saldo_total__c == 25);
        Test.StopTest();
    }

    public static testMethod void testConsumirSaldoError() {
        GP_Socio__c socio = generarSocio(10);
        GP_Regla__c regla = generarRegla();
        generarSaldos(10, socio.Id, Date.Today());
        generarSaldos(20, socio.Id, Date.Today() + 1);

        List<GP_datosTransaccion> listDatos = new List<GP_datosTransaccion>();
        GP_datosTransaccion dato = new GP_datosTransaccion(regla.Id,socio.Cuenta__c,'',30,'Resta','',0,null);
        listDatos.add(dato);

        Test.StartTest();
        List<GP_Historia_transaccion__c> result = GP_Saldos_Transacciones.generarTransaccionActualizarSaldo(listDatos);
        Test.StopTest();
    }

    public static testMethod void testconsultarSaldoTotalError() {
        Test.StartTest();
        Map<String,Object> result = GP_API.consultarPuntos('','');
        Test.StopTest();
    }

    public static testMethod void testconsultarSaldoTotal() {
        Date vto1 = Date.Today().addDays(100);
        Date vto2 = Date.Today().addDays(105);
        Date vto3 = Date.Today().addDays(300);
        Date vto4 = Date.Today().addDays(350);

        GP_Socio__c socio = generarSocio(5360);
        generarSaldos(360, socio.Id, vto1);
        generarSaldos(5000, socio.Id, vto2);
        GP_Socio__c socioHijo = generarSocioHijo(1000, socio.Id);
        generarSaldos(600, socioHijo.Id, vto3);
        generarSaldos(400, socioHijo.Id, vto4);

        Test.StartTest();
        Map<String,Object> result = GP_API.consultarPuntos(socio.Cuenta__c,'');

        List<Map<String,Object>> puntosxSocios = (List<Map<String,Object>>) result.get('puntosxSocios');
        List<Map<String,Object>> puntosxVto = new List<Map<String,Object>>();

        system.assert(result.get('totalPuntosDisponibles') == socio.Saldo_total__c + socioHijo.Saldo_total__c);

        for (Map<String,Object> mapa : puntosxSocios) {
            puntosxVto = (List<Map<String,Object>>) mapa.get('puntosxVto');
            if (mapa.get('idSocio') == socio.Id){
                system.assert(mapa.get('puntosSocio') == socio.Saldo_total__c);
                for (Map<String,Object> mapaPtos : puntosxVto) {
                    if (mapaPtos.get('puntos') == 360) {
                        system.assert(mapaPtos.get('fechaVto') == vto1);
                    } else {
                        system.assert(mapaPtos.get('puntos') == 5000);
                        system.assert(mapaPtos.get('fechaVto') == vto2);
                    }
                }
            } else if (mapa.get('idSocio') == socioHijo.Id) {
                system.assert(mapa.get('puntosSocio') == socioHijo.Saldo_total__c);
                for (Map<String,Object> mapaPtos : puntosxVto) {
                    if (mapaPtos.get('puntos') == 600) {
                        system.assert(mapaPtos.get('fechaVto') == vto3);
                    } else {
                        system.assert(mapaPtos.get('puntos') == 400);
                        system.assert(mapaPtos.get('fechaVto') == vto4);
                    }
                }
            }
        }
        Test.StopTest();
    }
}