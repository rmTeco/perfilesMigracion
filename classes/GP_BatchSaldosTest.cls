@isTest
public with sharing class GP_BatchSaldosTest {

    static testMethod void testBatch() {
        //Para acum padre
        Contact pc = new Contact();
        pc.MobilePhone = '15304466';
        pc.Email = 'ns@salesforce.com';
        pc.FirstName = 'N';
        pc.LastName = 'S';
        insert pc;

        Account a = new Account();
        a.name = 'cuenta1';
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        a.AccountIntegrationId__c = '111111111111';
        a.vlocity_cmt__PrimaryContactId__c = pc.Id;
        insert a;

        GP_Socio__c acum = new GP_Socio__c();
        acum.Cuenta__c = a.Id;
        acum.Activo__c = true;
        insert acum;

        //Para acum hijo
        Contact pc1 = new Contact();
        pc1.MobilePhone = '1530446677';
        pc1.Email = 'ns@gmail.com';
        pc1.FirstName = 'N';
        pc1.LastName = 'S';
        insert pc1;

        Account b = new Account();
        b.name = 'cuenta1';
        b.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        b.AccountIntegrationId__c = '22222';
        b.vlocity_cmt__PrimaryContactId__c = pc1.Id;
        insert b;

        GP_Socio__c acumHijo = new GP_Socio__c();
        acumHijo.Cuenta__c = b.Id;
        acumHijo.Socio_padre__c = acum.Id;
        acumHijo.Activo__c = true;
        insert acumHijo;

        GP_Aviso_Vencimiento__c avisoPrevio = new GP_Aviso_Vencimiento__c();
        avisoPrevio.Cuenta__c = acum.Cuenta__c;
        avisoPrevio.Puntos_que_vencen__c = 5;
        insert avisoPrevio;

        GP_Aviso_Vencimiento__c avisoPrevio1 = new GP_Aviso_Vencimiento__c();
        avisoPrevio1.Cuenta__c = acumHijo.Cuenta__c;
        avisoPrevio1.Puntos_que_vencen__c = 5;
        insert avisoPrevio1;

        List<GP_Saldo_por_vencimiento__c> listSaldos = new List<GP_Saldo_por_vencimiento__c>();
        //Como el batch busca en los primeros 60 días:
        // Los saldos de 0 a 30 generan aviso (31 * 10) ya que sus vencimientos van de 30 a 60 días despues de la fecha actual.
        // Los saldos de 31 a 99 no generan aviso pues su fecha de vencimiento va de 61 a 129 días despues de la fecha actual.
        for(Integer i = 0; i<100; i++) {
            GP_Saldo_por_vencimiento__c sv = new GP_Saldo_por_vencimiento__c();
            sv.Puntos__c = 10;
            sv.Socio__c = acum.Id;
            sv.Vencimiento__c = Date.Today().addDays(30 + i) ;
            listSaldos.add(sv);
        }
        for(Integer j = 0; j<100; j++) {
            GP_Saldo_por_vencimiento__c sv2 = new GP_Saldo_por_vencimiento__c();
            sv2.Puntos__c = 10;
            sv2.Socio__c = acumHijo.Id;
            sv2.Vencimiento__c = Date.Today().addDays(30 + j) ;
            listSaldos.add(sv2);
        }
        insert listSaldos;

        Test.StartTest();
        GP_BatchSaldos batchSaldos = new GP_BatchSaldos();
        ID batchprocessid = Database.executeBatch(batchSaldos);
        Test.StopTest();

        Integer cnt = [Select Count() From GP_Aviso_Vencimiento__c];
        Decimal ptosPadre = [Select Puntos_que_vencen__c From GP_Aviso_Vencimiento__c Where Cuenta__c = :acum.Cuenta__c LIMIT 1].Puntos_que_vencen__c;
        Decimal ptosHijo = [Select Puntos_que_vencen__c From GP_Aviso_Vencimiento__c Where Cuenta__c = :acumHijo.Cuenta__c LIMIT 1].Puntos_que_vencen__c;

        System.assertEquals(2, cnt);
        System.assertEquals(625, ptosPadre); // (310 padre + 310 hijo) + 5 previos del hijo (y por lo tanto del padre tambien)
        System.assertEquals(315, ptosHijo);
    }
}