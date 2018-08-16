global class DR_ofertasAdicionales implements vlocity_cmt.VlocityOpenInterface2 {
	
	global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options) {

        //try {
            list<Object> arguments = (List<Object>)inputs.get('arguments');
            List<Object> orderItemsWithAttrs = (List<Object>) arguments;

            List<Object> outputJSON = new List<Object>();
			//outputJSON.add(arguments);

            

            for(Object oi : orderItemsWithAttrs) {
            	Map<String, Object> oiMap = (Map<String, Object>) oi;
            	//outputJSON.add((Object) oiMap.get('attrs')); continue;
            	Object oiValue = oiMap.get('attrs');
            	//outputJSON.add((Object) oiValue);continue;
            	Map<String, Object> oiAttributes = (Map<String, Object>) oiValue;
            	//outputJSON.add((Object) oiAttributes);continue;

            	String codProducto = (String) oiAttributes.get('Codigo Sistema Origen');

            	if(codProducto == null || codProducto == '') continue;


            	Map<String, String> infoProductoJSON = new Map<String, String>();
            	infoProductoJSON.put('codProducto', codProducto);


            	Map<String, Object> offerJSON = new Map<String, Object>();
            	offerJSON.put('producto', (Object) infoProductoJSON);


            	Map<String, Object> modoEfectividadJSON = new Map<String, String>();
            	String num = '1';
            	modoEfectividadJSON.put('modo', (Object) num);
            	modoEfectividadJSON.put('fechaDesdeCaracteristicaProd', (Object) Datetime.now().format('yyyy-MM-dd HH:MM:ss'));
            	

            	offerJSON.put('modoEfectividad', (Object) modoEfectividadJSON);


            	outputJSON.add((Object) offerJSON);
            }

            output.put('result', (Object)outputJSON);

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