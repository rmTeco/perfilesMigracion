Global with sharing class ATGHelperFunctions implements vlocity_cmt.VlocityOpenInterface {
	Global Boolean invokeMethod(String method, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
		Boolean retval = false;

		if (method == 'postCartItem') {

			retval = postCartItem(input,output,options);
		}

		return retval;
	}

	public Boolean postCartItem(Map<String,Object> input,Map<String,Object> output,Map<String,Object> options) {

		String drBundle = 'TransformCartItemAdd';
		if (options.get('drBundle') != null) {
			drBundle = (String)options.get('drBundle');
		}

		System.debug(logginglevel.Error,'BBBBB input ' + input);
		System.debug(logginglevel.Error,'BBBBB drBundle ' + drBundle);

		String jsonString = JSON.serialize(input);

		System.debug(logginglevel.Error,'BBBBB json String ' + jsonString);

		vlocity_cmt.DRProcessResult result = vlocity_cmt.DRGlobal.processObjectsJSON(jsonString, drBundle);

		List<Map<String, Object>> transformResult = (List<Map<String, Object>>)result.toJsonList(); 


		System.debug(logginglevel.Error,'BBBBB result ' + transformResult);
		System.debug(logginglevel.Error,'BBBBB result[0] ' + transformResult[0]);


        vlocity_cmt.CpqAppHandler appHandler = new vlocity_cmt.CpqAppHandler();
        if (appHandler==null) {
            System.debug(logginglevel.Error,'Failed to create service: vlocity_cmt.CpqAppHandler');
            return false;
        }
        appHandler.invokeMethod('postCartsItems', transformResult[0], output, options);

        System.debug(logginglevel.Error,'BBBBB post result ' + output);

        return true;


	}
}