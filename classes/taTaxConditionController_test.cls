@IsTest
public class taTaxConditionController_test {
	@IsTest static void invoke_InitialValidations(){
    	String methodName = 'InitialValidations';
		Account acc = new Account (Name='New Test Parent Account');
		insert acc;
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        taTaxConditionController contr = new taTaxConditionController();
        
        Test.startTest();
        contr.lino ='test';
        contr.invokeMethod(methodName, input, outMap, options);
        taTaxConditionController.InitialValidations(acc.Id);
		Test.stopTest();
    }
}