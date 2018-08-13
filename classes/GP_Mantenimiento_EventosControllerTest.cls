@isTest
public with sharing class GP_Mantenimiento_EventosControllerTest{

    static testMethod void testController() {
        List<GP_Evento_descriptor__c> aInsertar = new List<GP_Evento_descriptor__c>();
        GP_Evento_descriptor__c eventoDesc = new GP_Evento_descriptor__c(Tipo_de_evento__c = 'Bienvenida', Frecuencia_permitida__c = 'Unica Vez');
        aInsertar.add(eventoDesc);
        eventoDesc = new GP_Evento_descriptor__c(Tipo_de_evento__c = 'Antigüedad', Frecuencia_permitida__c = 'Anual');
        aInsertar.add(eventoDesc);
        eventoDesc = new GP_Evento_descriptor__c(Tipo_de_evento__c = 'Transferencia', Frecuencia_permitida__c = 'Semanal');
        aInsertar.add(eventoDesc);
        eventoDesc = new GP_Evento_descriptor__c(Tipo_de_evento__c = 'Recarga por Monto', Frecuencia_permitida__c = 'Diaria');
        aInsertar.add(eventoDesc);
        insert aInsertar;

        aInsertar.add(new GP_Evento_descriptor__c());

        Test.startTest();
        GP_Mantenimiento_EventosController ctrl = new GP_Mantenimiento_EventosController();

        ctrl.nuevoEvento = new GP_Evento_descriptor__c(Tipo_de_evento__c = 'Upselling', Frecuencia_permitida__c = 'Mensual');
        ctrl.insertRecord();

        ctrl.nuevoEvento = [Select Id,Tipo_de_evento__c,Frecuencia_permitida__c From GP_Evento_descriptor__c Where Tipo_de_evento__c = 'Upselling' AND Frecuencia_permitida__c = 'Mensual'];
        ctrl.nuevoEvento.Tipo_de_evento__c = 'Cater';
        ctrl.updateRecord();

        ctrl.nuevoEvento = [Select Id,Tipo_de_evento__c,Frecuencia_permitida__c From GP_Evento_descriptor__c Where Tipo_de_evento__c = 'Cater' AND Frecuencia_permitida__c = 'Mensual'];
        ctrl.deleteRecord();

        ctrl.doNothing();

        System.assertEquals(aInsertar, ctrl.listaEventos);
        Test.stopTest();
    }
}