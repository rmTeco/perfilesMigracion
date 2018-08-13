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
}