@isTest
public class anularPagoButtonControllerTest {

	
	public static testMethod void test() {
        MockupFactory.generate(); 
	    Account laCuenta = new Account();
	    laCuenta.name = 'Daniel San';
	    insert laCuenta;
        Order laOrden = new Order();
        laOrden.accountid = laCuenta.id;
        laOrden.Status = 'Draft';
        laOrden.effectivedate = Date.today();
        laOrden.vlocity_cmt__OriginatingChannel__c = 'Agentes';
        laOrden.TrackingStatus__c = 'Pendiente de Anulación de Pago por Vencimiento de Plazo de Retiro';
        laOrden.delivery_method__c = 'Store Pick Up';
        insert laOrden;
        Task laTarea = new Task();
        laTarea.ActivityDate = Date.today();
        laTarea.subject = 'Orden-Anulación de Pago';
        laTarea.WhatId = laOrden.id;
        insert laTarea;
        ApexPages.StandardController sc = new ApexPages.StandardController(laTarea);
        AnularPagoButtonController testTaskPlan = new AnularPagoButtonController(sc);
        
        
	}
    
    	public static testMethod void testError() {
        MockupFactory.generate(); 
	    Account laCuenta = new Account();
	    laCuenta.name = 'Daniel San';
	    insert laCuenta;
        Order laOrden = new Order();
        laOrden.accountid = laCuenta.id;
        laOrden.Status = 'Draft';
        laOrden.effectivedate = Date.today();
        laOrden.vlocity_cmt__OriginatingChannel__c = 'Agentes';
        laOrden.TrackingStatus__c = 'Pendiente de Anulación de Pago por Vencimiento de Plazo de Retiro';
        laOrden.delivery_method__c = 'Store Pick Up';
        insert laOrden;
        laOrden.TrackingStatus__c = 'Pendiente de Anulación de Pago por Vencimiento de Plazo de Retiro';
        update laOrden;
        Task laTarea = new Task();
        laTarea.ActivityDate = Date.today();
        laTarea.subject = 'Orden-Anulación de Pago';
        laTarea.WhatId = laOrden.id;
        insert laTarea;
        ApexPages.StandardController sc = new ApexPages.StandardController(laTarea);
        AnularPagoButtonController testTaskPlan = new AnularPagoButtonController(sc);
        
        
	}

}