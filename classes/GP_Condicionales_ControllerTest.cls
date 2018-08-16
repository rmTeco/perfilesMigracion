@isTest
public with sharing class GP_Condicionales_ControllerTest {
        
    public static testMethod void testCtrlVariable() {
        GP_Regla__c regla = new GP_Regla__c();
        regla.Vigencia_desde__c = Date.Today() - 7;
        regla.Vigencia_hasta__c = Date.Today() + 365;
        regla.Dias_vencimiento__c = 10;
        regla.Fecha_vencimiento__c = Date.Today() + 60;
        regla.Tipo_de_evento__c = 'Recarga por Monto';
        insert regla;

        GP_Condicional_logico__c cond = new GP_Condicional_logico__c();
        cond.Regla__c = regla.Id;
        cond.Variable_a_comparar__c = 'Monto';
        insert cond;

        PageReference pageRef = Page.GP_Upsert_Reglas;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',regla.Id);
    
        GP_Condicionales_Controller controller = new GP_Condicionales_Controller();

        //Pruebo getCondicional() con Id de condicion creada
        controller.IdCond = cond.Id;
        controller.getCondicional();
        //Pruebo saveCondicional() cambiando la variable a comparar
        controller.selectedVar = 'Tipo De Servicio';
        controller.saveCondicional();
        //Pruebo insertarCondicion() con una nueva cond
        controller.GP_Condicional_logico = new GP_Condicional_logico__c();
        controller.GP_Condicional_logico.Regla__c = regla.Id;
        controller.GP_Condicional_logico.Variable_a_comparar__c = 'Monto';
        controller.insertarCondicion();
        //Pruebo eliminar
        controller.deleteCond();
        //Pruebo doNothing(), usado para crear actionFunctions y poder reRenderizar componentes de la VF
        controller.doNothing();

        controller.saveAndReturnToList();
    }

    public static testMethod void testCtrlFijo() {
        GP_Regla__c regla = new GP_Regla__c();
        regla.Vigencia_desde__c = Date.Today() - 7;
        regla.Vigencia_hasta__c = Date.Today() + 365;
        regla.Dias_vencimiento__c = 10;
        regla.Fecha_vencimiento__c = Date.Today() + 60;
        regla.Tipo_de_evento__c = 'Upselling';
        //Para pasar por todos los casos del metodo principal
        regla.SeComparaContraElValorFijo__c = true;
        regla.Vencimiento_fecha_fija__c = true;
        insert regla;

        PageReference pageRef = Page.GP_Upsert_Reglas;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',regla.Id);
        System.debug('Parametro ID: ' + ApexPages.currentPage().getParameters().get('id'));
    
        GP_Condicionales_Controller controller = new GP_Condicionales_Controller();
    }

    public static testMethod void testCtrlNuevaRegla() {
        PageReference pageRef = Page.GP_Upsert_Reglas;
        Test.setCurrentPage(pageRef);
        //ApexPages.currentPage().getParameters().put('id',regla.Id);
        System.debug('Parametro ID: ' + ApexPages.currentPage().getParameters().get('id'));
    
        GP_Condicionales_Controller controller = new GP_Condicionales_Controller();

        //Pruebo insertar una condicion en una regla nueva
        controller.GP_Condicional_logico = new GP_Condicional_logico__c();
        controller.GP_Condicional_logico.Variable_a_comparar__c = 'Monto';
        controller.insertarCondicion();
    }
}