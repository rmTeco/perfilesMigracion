@isTest
public with sharing class GP_ControlDeEventosTest{

    static List<GP_sumarRestarPuntosItem> listaFiltrada;
    static List<GP_sumarRestarPuntosItem> resultDatos;
    static List<GP_sumarRestarPuntosItem> datosTR;
    
    
    static testMethod void testErrorTipoEvento() {
        List<GP_sumarRestarPuntosItem> datosTR1 = new List<GP_sumarRestarPuntosItem>();
        List<GP_sumarRestarPuntosItem> result = new List<GP_sumarRestarPuntosItem>();

        //Creo descriptor de eventos
        GP_Evento_descriptor__c eventoDesc1 = new GP_Evento_descriptor__c(
            Tipo_de_evento__c = 'Bienvenida',
            Frecuencia_permitida__c = 'Unica Vez'
        );
        insert eventoDesc1;
                                    


        Test.StartTest();
        try{
            GP_sumarRestarPuntosItem dato = new GP_sumarRestarPuntosItem('', '','Recarga por Monto',0,null);
            datosTR1.add(dato);
            
            result = GP_ControlDeEventos.controlarSocios(datosTR1);    
        }catch(Exception ex){
        }
        Test.StopTest();
    }
    
    /*
    static testMethod void testErrorSocios() {
        List<GP_datosTransaccion> datosTR1 = new List<GP_datosTransaccion>();
        List<GP_datosTransaccion> result = new List<GP_datosTransaccion>();

        //Creo descriptor de eventos
        GP_Evento_descriptor__c eventoDesc1 = new GP_Evento_descriptor__c(
            Tipo_de_evento__c = 'Bienvenida',
            Frecuencia_permitida__c = 'Unica Vez'
        );
        insert eventoDesc1;

        GP_datosTransaccion dato = new GP_datosTransaccion('',String.valueOf(eventoDesc1.Id),'',3,'Bienvenida',0,Date.Today());
        datosTR1.add(dato);

        Test.StartTest();
        try{
            result = GP_ControlDeEventos.controlarSocios(datosTR1);
        } catch(Exception ex){
        }
        Test.StopTest();
    }
    */ 
    
    static testMethod void testSuscriptorYEventos(){
        datosTR = new List<GP_sumarRestarPuntosItem>();
        listaFiltrada = new List<GP_sumarRestarPuntosItem>();
        resultDatos = new List<GP_sumarRestarPuntosItem>();

        insertarCuentas();
        insertarSocios();
        insertarDescEventos();
        insertarCtrlEvento();
        crearDatosTR();

        Test.StartTest();
        resultDatos = GP_ControlDeEventos.controlarSocios(datosTR);
        System.assertEquals(resultDatos, listaFiltrada);
        Test.StopTest();
    }

    //FUNCIONES PARA CREAR REGISTROS Y DATOS DE TRANSACCIONES:
    private static void insertarCuentas() {
        List<Account> cuentasInsert = new List<Account>();
        //Creo Cuenta del socio padre
        Account cuenta1 = new Account(Name = 'Cuenta P1', AccountIntegrationId__c = String.valueOf(10000));
        cuenta1.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        Database.insert(cuenta1);

        Account cuenta2 = new Account(Name = 'Cuenta H1 P1', AccountIntegrationId__c = String.valueOf(10001));
        cuenta2.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        Database.insert(cuenta2);

        Account cuenta3 = new Account(Name = 'Cuenta H2 P1', AccountIntegrationId__c = String.valueOf(10002));
        cuenta3.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        Database.insert(cuenta3);
    }
    private static void insertarSocios() {
        List<GP_Socio__c> sociosInsert = new List<GP_Socio__c>();
        Map<String,Id> cuentasMap = new Map<String,Id>();
        Id IdAux;

        List<Account> cuentas = [Select Id,Name From Account];
        for(Account acct : cuentas) {
            cuentasMap.put(acct.Name,acct.Id);
        }

        //Creo socios, primero el Padre (titularId)
        GP_Socio__c socio;
        IdAux = cuentasMap.get('Cuenta P1');
        GP_Socio__c socioPadre = new GP_Socio__c(Activo__c = true, Cuenta__c = IdAux, Saldo_total__c = 0, Name = 'P1');
        Database.insert(socioPadre);

        IdAux = cuentasMap.get('Cuenta H1 P1');
        socio = new GP_Socio__c(Activo__c = true, Cuenta__c = IdAux, Socio_padre__c = socioPadre.Id, Saldo_total__c = 0, Name = 'H1P1');
        sociosInsert.add(socio);

        IdAux = cuentasMap.get('Cuenta H2 P1');
        socio = new GP_Socio__c(Activo__c = true, Cuenta__c = IdAux, Socio_padre__c = socioPadre.Id, Saldo_total__c = 0, Name = 'H2P1');
        sociosInsert.add(socio);

        Database.insert(sociosInsert);
    }
    private static void insertarDescEventos() {
        List<GP_Evento_descriptor__c> eventoDescInsert = new List<GP_Evento_descriptor__c>();
        //Creo descriptor de eventos
        GP_Evento_descriptor__c eventoDesc;
        eventoDesc = new GP_Evento_descriptor__c(Tipo_de_evento__c = 'Bienvenida',Frecuencia_permitida__c = 'Unica Vez');
        eventoDescInsert.add(eventoDesc);
        eventoDesc = new GP_Evento_descriptor__c(Tipo_de_evento__c = 'Recarga por Monto',Frecuencia_permitida__c = 'Diaria');
        eventoDescInsert.add(eventoDesc);
        eventoDesc = new GP_Evento_descriptor__c(Tipo_de_evento__c = 'Transferencia',Frecuencia_permitida__c = 'Semanal');
        eventoDescInsert.add(eventoDesc);
        eventoDesc = new GP_Evento_descriptor__c(Tipo_de_evento__c = 'Continuidad FOL',Frecuencia_permitida__c = 'Mensual');
        eventoDescInsert.add(eventoDesc);
        eventoDesc = new GP_Evento_descriptor__c(Tipo_de_evento__c = 'Antigüedad',Frecuencia_permitida__c = 'Anual');
        eventoDescInsert.add(eventoDesc);
        //eventoDesc = new GP_Evento_descriptor__c(Tipo_de_evento__c = 'Alta a Débito Automatico',Frecuencia_permitida__c = 'Unica Vez');
        //eventoDescInsert.add(eventoDesc);
        Database.insert(eventoDescInsert);
    }
    private static void insertarCtrlEvento() {
        List<GP_Control_de_evento__c> listCtrl = new List<GP_Control_de_evento__c>();
        GP_Socio__c socio2 = [Select Id From GP_Socio__c Where Name = 'H2P1'];

        //Creo un control de evento para un socio
        Date fecha = Date.Today().toStartOfWeek().addDays(-2);
        GP_Control_de_evento__c ctrl = new GP_Control_de_evento__c(Socio__c = socio2.Id, Tipo_de_evento__c = 'Transferencia', Fecha_ultimo_evento__c = fecha);
        listCtrl.add(ctrl);

        fecha = Date.Today().addDays(-366);
        ctrl = new GP_Control_de_evento__c(Socio__c = socio2.Id, Tipo_de_evento__c = 'Antigüedad', Fecha_ultimo_evento__c = fecha);
        listCtrl.add(ctrl);

        fecha = Date.Today().addDays(-1);
        ctrl = new GP_Control_de_evento__c(Socio__c = socio2.Id, Tipo_de_evento__c = 'Recarga por Monto', Fecha_ultimo_evento__c = fecha);
        listCtrl.add(ctrl);

        fecha = Date.Today().toStartOfMonth().addDays(-6);
        ctrl = new GP_Control_de_evento__c(Socio__c = socio2.Id, Tipo_de_evento__c = 'Continuidad FOL', Fecha_ultimo_evento__c = fecha);
        listCtrl.add(ctrl);

        Database.insert(listCtrl);
    }
    private static void crearDatosTR() {
        
        Map<String,String> cuentasMap = new Map<String,String>();
        List<Account> cuentas = [Select Id, Name From Account];
        for(Account acct : cuentas) {
            cuentasMap.put(acct.Name, String.valueOf(acct.Id));
        }
        String p1Id = cuentasMap.get('Cuenta P1');
        String h1Id = cuentasMap.get('Cuenta H1 P1');
        String h2Id = cuentasMap.get('Cuenta H2 P1');

        //Creo los datos de cada transaccion, los últimos 3 no deberían ser parte del resultado. 
        GP_sumarRestarPuntosItem dato;
        List<GP_AtributoValorDeUnEvento> nullo = new List<GP_AtributoValorDeUnEvento>();
        
        /*
        dato = new GP_sumarRestarPuntosItem(p1Id, '0','Bienvenida',0, nullo);
        listaFiltrada.add(dato);    //OK
        datosTR.add(dato);
        */
        
        // El socio hijo 1 no tiene eventos anteriores
        dato = new GP_sumarRestarPuntosItem(p1Id, h1Id,'Recarga por Monto',0,nullo);
        listaFiltrada.add(dato);    //OK
        datosTR.add(dato);
        dato = new GP_sumarRestarPuntosItem(p1Id, h1Id,'Transferencia',0,nullo);
        listaFiltrada.add(dato);    //OK
        datosTR.add(dato);
        dato = new GP_sumarRestarPuntosItem(p1Id, h1Id,'Antigüedad',0,nullo);
        listaFiltrada.add(dato);    //OK
        datosTR.add(dato);
        dato = new GP_sumarRestarPuntosItem(p1Id, h1Id,'Continuidad FOL',0,nullo);
        listaFiltrada.add(dato);    //OK
        datosTR.add(dato);

        // El socio hijo 2 tiene eventos anteriores
        dato = new GP_sumarRestarPuntosItem(p1Id, h2Id,'Transferencia',0,nullo);
        listaFiltrada.add(dato);    //OK
        datosTR.add(dato);
        dato = new GP_sumarRestarPuntosItem(p1Id, h2Id,'Antigüedad',0,nullo);
        listaFiltrada.add(dato);    //OK
        datosTR.add(dato);
        dato = new GP_sumarRestarPuntosItem(p1Id, h2Id,'Recarga por Monto',0,nullo);
        listaFiltrada.add(dato);    //OK
        datosTR.add(dato);
        dato = new GP_sumarRestarPuntosItem(p1Id, h2Id,'Continuidad FOL',0,nullo);
        listaFiltrada.add(dato);    //OK
        datosTR.add(dato);
        dato = new GP_sumarRestarPuntosItem(p1Id, h2Id,'Premio Recarga 3M',0,nullo);
        listaFiltrada.add(dato);    //OK
        datosTR.add(dato);
        
        /*
        dato = new GP_sumarRestarPuntosItem(p1Id, '0','Bienvenida',0,nullo);
        datosTR.add(dato);
        */
        
        dato = new GP_sumarRestarPuntosItem(p1Id, h1Id,'Recarga por Monto',0,nullo);
        datosTR.add(dato);
        dato = new GP_sumarRestarPuntosItem(p1Id, h2Id,'Transferencia',0,nullo);
        datosTR.add(dato);
    }
}