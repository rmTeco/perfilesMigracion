@isTest
Global with sharing class GPEventoGeneralBatchTriggerTest {
    @isTest
    static void insertarGP_Evento_General_Batch() {
        List<Object> listMapAttr = new List<Object>();

        Map<String, Object> mapAux = new Map<String, Object>();
        mapAux.put('NombreDelAtributo', 'Tiene Canje');
        mapAux.put('TipoDeAtributo', 'Boolean');
        mapAux.put('Valor', True);
        listMapAttr.add(mapAux);

        mapAux = new Map<String, Object>();
        mapAux.put('NombreDelAtributo', 'Tipo De Cliente');
        mapAux.put('TipoDeAtributo', 'String');
        mapAux.put('Valor', 'DNI');
        listMapAttr.add(mapAux);

        mapAux = new Map<String, Object>();
        mapAux.put('NombreDelAtributo', 'Millas');
        mapAux.put('TipoDeAtributo', 'Integer');
        mapAux.put('Valor', 501);
        listMapAttr.add(mapAux);

        Map<String, Object> jsonAttr = new Map<String, Object>();
        jsonAttr.put('listaDeAtributos', listMapAttr);
        String jsonAttrSerialized = JSON.serialize(jsonAttr);

        //Cuenta
        Account cuenta = new Account();
        cuenta.name = 'cuenta1';
        cuenta.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        cuenta.AccountIntegrationId__c = '111111111111';
        //cuenta.vlocity_cmt__PrimaryContactId__c = pc.Id;
        insert cuenta;

        GP_Socio__c acum = new GP_Socio__c();
        acum.Activo__c = true;
        acum.Cuenta__c = cuenta.Id;
        acum.Saldo_total__c = 100;
        insert acum;

        GP_Evento_General_Batch__c evGralBatch = new GP_Evento_General_Batch__c();
        evGralBatch.ID_Suscriptor__c = '0';
        evGralBatch.ID_Titular__c = acum.Cuenta__c;
        evGralBatch.Tipo_de_evento__c = 'Canje por LanPass';
        evGralBatch.JsonAtribute__c = jsonAttrSerialized;

        insert evGralBatch;
    }
}