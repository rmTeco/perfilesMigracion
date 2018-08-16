@isTest
public with sharing class TaMatrixUtilsTest {
	public static testmethod void unitTest1(){
		
		IFS_S038_updateCycleMock mock = new IFS_S038_updateCycleMock();
        mock.status = 200;
        Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
		TaMatrixUtils.checkPrefa('37110', 'FIBRA', 'Voz');
		Test.stopTest();
	}

	public static testmethod void unitTest2(){

		Map<String, Object> prueba = new Map<String, Object>();
		Test.startTest();
		prueba = TaMatrixUtils.getMediosDePago('PRUEBA');
		Test.stopTest();
	}
    
	public static testmethod void unitTest3(){

		Map<String, Object> prueba = new Map<String, Object>();
		Test.startTest();
		prueba = TaMatrixUtils.getStockMovementOperation('operationType', 'instance', 'deliveryMethod','originStock');
		Test.stopTest();
	}
    
	public static testmethod void unitTest4(){

		Map<String, Object> prueba = new Map<String, Object>();
		Test.startTest();
		prueba = TaMatrixUtils.getStockAvailableCode('channel', 'deliveryMethod');
		Test.stopTest();
	}
    
	public static testmethod void unitTest5(){

		Map<String, Object> prueba = new Map<String, Object>();
		Test.startTest();
		prueba = TaMatrixUtils.GetManageableIdentityValidationMatrix('paymentMethod', 'operation');
		Test.stopTest();
	}
    
	public static testmethod void unitTest7(){

		Map<String, Object> prueba = new Map<String, Object>();
		Test.startTest();
		prueba = TaMatrixUtils.GetStockBillable('stock');
		Test.stopTest();
	}
	
	public static testmethod void unitTest8(){

		Map<String, Object> prueba = new Map<String, Object>();
		Test.startTest();
		prueba = TaMatrixUtils.GetPromocionesFinancierasVigentes('paymentMethod', 'bankEntity', 'cardName', 'installment');
		Test.stopTest();
	}
    
}