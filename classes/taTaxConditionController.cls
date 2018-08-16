global with sharing class taTaxConditionController implements vlocity_cmt.VlocityOpenInterface {

	public String lino {get;set;}

	public taTaxConditionController() {
		
	}

	global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {       
		try {
            return true;
        } 
        catch (Exception e) {
            return false;
		}
    }

	@RemoteAction
	global static Boolean InitialValidations(string accountId) {
		System.debug('accountId: ' + accountId);
		return true;
	}
}