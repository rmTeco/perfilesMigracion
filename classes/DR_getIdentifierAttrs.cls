global class DR_getIdentifierAttrs implements vlocity_cmt.VlocityOpenInterface2 {
	
	global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options) {

        //try {
            list<Object> arguments = (List<Object>)inputs.get('arguments');
            string fullfilmentRequestLineId = (string)arguments[0];

            
            if(fullfilmentRequestLineId != null) {
                List<vlocity_cmt__FulfilmentRequestLine__c> frlList = [select vlocity_cmt__JSONAttribute__c from vlocity_cmt__FulfilmentRequestLine__c where id = :fullfilmentRequestLineId];
                
                if(frlList == null || frlList.size() == 0) return false;

                vlocity_cmt__FulfilmentRequestLine__c frl = frlList[0];

                output.put('result', getIdentifierAttrs((Map<String, Object>)JSON.deserializeUntyped(frl.vlocity_cmt__JSONAttribute__c)));
            }
            system.debug(output);
            return true;
     //   }
      //  catch(exception ex){
       //     system.debug(ex);
        //    return false;
        //}
    
	}

	global List<Object> getIdentifierAttrs(Map<String, Object> attributeCategories) {
		List<Object> identifierAttrs = new List<Object>();

		
		for(Object attributeObj : attributeCategories.values()) {
			List<Object> attributeList = (List<Object>) attributeObj;
			for(Object attribute : attributeList) {
	            Map<String, Object> attributeMap = (Map<String, Object>) attribute;
	          
	            String name = (String) attributeMap.get('Name');

	            if(name != 'MSISDN2' && name != 'ICCID' && name != 'IMSI') continue;

	            object value = ((Map<String, Object>)(attributeMap.get('attributeRunTimeInfo'))).get('value');

	            Map<String, String> indentifierAttr = new Map<String, String>();

	            indentifierAttr.put('type', name);
	            indentifierAttr.put('value', (String) value);

	            identifierAttrs.add((Object) indentifierAttr);
		    }
		}


		return identifierAttrs;
	}
}