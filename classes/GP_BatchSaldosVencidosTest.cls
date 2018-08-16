@isTest
public with sharing class GP_BatchSaldosVencidosTest {

    static testMethod void testBatch() {
        Account a = new Account();
        a.name = 'cuenta1';
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        a.AccountIntegrationId__c = '111111111111';
        insert a;

        GP_Socio__c acum = new GP_Socio__c();
        acum.Cuenta__c = a.Id;
        acum.Saldo_total__c = 1000;
        insert acum;

        List<GP_Saldo_por_vencimiento__c> listSaldos = new List<GP_Saldo_por_vencimiento__c>();
        for(integer i = 0; i<10; i++) {
            GP_Saldo_por_vencimiento__c sv = new GP_Saldo_por_vencimiento__c();
            sv.Puntos__c = 100;
            sv.Socio__c = acum.Id;
            sv.Vencimiento__c = Date.Today().addDays((-4) + i); 
            //Los primeros 4 saldos deben eliminarse por estar vencidos.
            listSaldos.add(sv);
        }
        insert listSaldos;

        Test.StartTest();
        GP_BatchSaldosVencidos batchSaldosVencidos = new GP_BatchSaldosVencidos();
        ID batchprocessid = Database.executeBatch(batchSaldosVencidos);
        Test.StopTest();

        Integer cnt = [Select Count() From GP_Saldo_por_vencimiento__c];
        Double puntosSocio = [Select Saldo_total__c From GP_Socio__c Where Id = :acum.Id].Saldo_total__c;
        System.assertEquals(6, cnt);
        System.assertEquals(600, puntosSocio);
    }
}