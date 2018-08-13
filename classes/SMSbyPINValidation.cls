/**
 * Created by Alex Lazarev 15/09/2017
 *
 * Implements VlocityOpenInterface
 * Provides the needed logic to support OS JSON VOI translation
 *
 * Objects: None - JSON translation for OS
 *
 * Important: The method uses a VlocityOpenInterface integration structure
 *
 * Version: 1.1
 */

global with sharing class SMSbyPINValidation implements vlocity_cmt.VlocityOpenInterface {

	global SMSbyPINValidation() {}

	global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {

		Boolean result = true;
		try {

			if (methodName.equals('generateValidationPIN')) {

				generateValidationPIN(input, outMap, options);
			}
			result = false;

		}
		catch(Exception e) {
			System.debug('BillingCycleChangeValidation: invokeMethod -> exception: '+e);
			result = false;
			outMap.put('error', e.getMessage());
		}
		return result;
	}
	
	void generateValidationPIN(Map<String, Object> inputMap,  Map<String, Object> outMap, Map<String, Object> options) {
	
	    System.debug('Start of generateValidationPIN');
	    outMap.put('SMSbyPINValidation',false);

		Map<String,String> contactMap = new Map<String, String>();
		
		System.debug('inputMap: ' + inputMap);
		// Grabbing Contact Node
		Map<String, Object> contactNodeMap = (Map<String, Object>) inputMap.get('Contact');
		
		System.debug('contactNodeMap: ' + contactNodeMap);
		
		String contactMobilePhone = (String) contactNodeMap.get('MobilePhone');
		System.debug('MobilePhone: ' + contactMobilePhone);
		if(contactMobilePhone != null){
	        outMap.put('SMSbyPINValidation',true);
	        System.debug('outMap: ' + outMap);
		}
		
	}
}