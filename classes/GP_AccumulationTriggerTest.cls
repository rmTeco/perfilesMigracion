@isTest
Global with sharing class GP_AccumulationTriggerTest {
    @isTest
    static void testTriggerPremioOK() {
        //Contacto
        Contact pc = new Contact();
        pc.MobilePhone = '15304466';
        pc.Email = 'ns@salesforce.com';
        pc.FirstName = 'N';
        pc.LastName = 'S';
        insert pc;
        //Cuenta
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '111111111111';
        cuenta.vlocity_cmt__PrimaryContactId__c = pc.Id;
        insert cuenta;
        //Asset
        Asset a = new Asset(AccountId = cuenta.Id);
        a.Name = 'Asset Test';
        a.MSISDN__c = '2222';
        a.Subscription_Id__c = 'S2222';
        insert a;

        GP_Regla__c regla = new GP_Regla__c();
        regla.Tipo_de_evento__c = 'Premio Recarga 3M';
        regla.Dias_vencimiento__c = 90;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '*';
        regla.Valor_calculo__c = 1;
        regla.Vigencia_desde__c = Date.Today() - 7;
        regla.Vigencia_hasta__c = Date.Today() + 7;
        insert regla;

        GP_Condicional_logico__c cond1 = new GP_Condicional_logico__c();
        cond1.Regla__c = regla.Id;
        cond1.Variable_a_comparar__c = 'Tipo De Cliente';
        cond1.Operador__c = '=';
        cond1.Valor_contra_el_que_se_compara__c = 'DNI';
        insert cond1;

        GP_Socio__c acum = new GP_Socio__c();
        acum.Activo__c = true;
        acum.Cuenta__c = cuenta.Id;
        acum.Saldo_total__c = 100;
        insert acum;

        GP_Lista_de_asset__c assetAcum = new GP_Lista_de_asset__c();
        assetAcum.Asset__c = a.Id;
        assetAcum.Socio__c = acum.Id;
        assetAcum.Puntos_acumulados_mes_0__c = 10;
        assetAcum.Puntos_acumulados_mes_1__c = 10;
        assetAcum.Puntos_acumulados_mes_2__c = 10;
        assetAcum.Puntos_acumulados_mes_3__c = 10;
        assetAcum.Total_Puntos_Acumulados__c = 40;
        insert assetAcum;
        
        GP_ACCUMULATION_RECHARGE__c accRecharge = new GP_ACCUMULATION_RECHARGE__c();
        accRecharge.Categoria__c = 'BLACK';
        accRecharge.Monto__c = 102;
        accRecharge.MSISDN__c = '2222';
        accRecharge.Suscripcion__c = 'S2222';
        accRecharge.Tipo_de_cliente__c = 'DNI';

        Test.StartTest();
        insert accRecharge;
        Test.StopTest();
        System.assertEquals(202, [ Select Saldo_total__c From GP_Socio__c Limit 1 ].Saldo_total__c );
    }

    @isTest
    static void testTriggerMes3Null() {
        //Contacto
        Contact pc = new Contact();
        pc.MobilePhone = '15304466';
        pc.Email = 'ns@salesforce.com';
        pc.FirstName = 'N';
        pc.LastName = 'S';
        insert pc;
        //Cuenta
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '111111111111';
        cuenta.vlocity_cmt__PrimaryContactId__c = pc.Id;
        insert cuenta;
        //Asset
        Asset a = new Asset(AccountId = cuenta.Id);
        a.Name = 'Asset Test';
        a.MSISDN__c = '2222';
        a.Subscription_Id__c = 'S2222';
        insert a;

        GP_Regla__c regla = new GP_Regla__c();
        regla.Tipo_de_evento__c = 'Recarga por Monto';
        regla.Dias_vencimiento__c = 90;
        regla.Variable_calculo__c = 'Monto';
        regla.Operador_calculo__c = '*';
        regla.Valor_calculo__c = 1;
        regla.Vigencia_desde__c = Date.Today() - 7;
        regla.Vigencia_hasta__c = Date.Today() + 7;
        insert regla;

        GP_Condicional_logico__c cond1 = new GP_Condicional_logico__c();
        cond1.Regla__c = regla.Id;
        cond1.Variable_a_comparar__c = 'Tipo De Cliente';
        cond1.Operador__c = '=';
        cond1.Valor_contra_el_que_se_compara__c = 'DNI';
        insert cond1;

        GP_Socio__c acum = new GP_Socio__c();
        acum.Activo__c = true;
        acum.Cuenta__c = cuenta.Id;
        acum.Saldo_total__c = 100;
        insert acum;

        GP_Lista_de_asset__c assetAcum = new GP_Lista_de_asset__c();
        assetAcum.Asset__c = a.Id;
        assetAcum.Socio__c = acum.Id;
        assetAcum.Puntos_acumulados_mes_0__c = 0;
        assetAcum.Puntos_acumulados_mes_1__c = 0;
        assetAcum.Puntos_acumulados_mes_2__c = 0;
        assetAcum.Puntos_acumulados_mes_3__c = 0;
        assetAcum.Total_Puntos_Acumulados__c = 0;
        insert assetAcum;
        
        GP_ACCUMULATION_RECHARGE__c accRecharge = new GP_ACCUMULATION_RECHARGE__c();
        accRecharge.Categoria__c = 'BLACK';
        accRecharge.Monto__c = 0;
        accRecharge.MSISDN__c = '2222';
        accRecharge.Suscripcion__c = 'S2222';
        accRecharge.Tipo_de_cliente__c = 'DNI';

        Test.StartTest();
        insert accRecharge;
        Test.StopTest();
        //System.assertEquals(202, [ Select Saldo_total__c From GP_Socio__c Limit 1 ].Saldo_total__c );
    }

    @isTest
    static void testTriggerExceptionSinMonto() {
        try{
            GP_ACCUMULATION_RECHARGE__c accRecharge = new GP_ACCUMULATION_RECHARGE__c();
            accRecharge.Categoria__c = 'BLACK';
            accRecharge.MSISDN__c = '2222';
            accRecharge.Suscripcion__c = 'S2222';
            accRecharge.Tipo_de_cliente__c = 'DNI';

            Test.StartTest();
            insert accRecharge;
            Test.StopTest();
        } catch(Exception ex) {
            //System.assertEquals('Error: ** El campo Monto__c es obligatorio.',ex.getMessage());
        }
    }

    @isTest
    static void testTriggerExceptionSinCategoria() {
        try{
            GP_ACCUMULATION_RECHARGE__c accRecharge = new GP_ACCUMULATION_RECHARGE__c();
            accRecharge.Monto__c = 0;
            accRecharge.MSISDN__c = '2222';
            accRecharge.Suscripcion__c = 'S2222';
            accRecharge.Tipo_de_cliente__c = 'DNI';

            Test.StartTest();
            insert accRecharge;
            Test.StopTest();
        } catch(Exception ex) {
            //
        }
    }

    @isTest
    static void testTriggerExceptionSinSuscripcion() {
        try{
            GP_ACCUMULATION_RECHARGE__c accRecharge = new GP_ACCUMULATION_RECHARGE__c();
            accRecharge.Categoria__c = 'BLACK';
            accRecharge.Monto__c = 0;
            accRecharge.MSISDN__c = '2222';
            accRecharge.Tipo_de_cliente__c = 'DNI';

            Test.StartTest();
            insert accRecharge;
            Test.StopTest();
        } catch(Exception ex) {
            //
        }
    }

    @isTest
    static void testTriggerExceptionSinTipoDeCliente() {
        try{
            GP_ACCUMULATION_RECHARGE__c accRecharge = new GP_ACCUMULATION_RECHARGE__c();
            accRecharge.Categoria__c = 'BLACK';
            accRecharge.Monto__c = 0;
            accRecharge.MSISDN__c = '2222';
            accRecharge.Suscripcion__c = 'S2222';

            Test.StartTest();
            insert accRecharge;
            Test.StopTest();
        } catch(Exception ex) {
            //
        }
    }
}