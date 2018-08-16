global with sharing class PruebaDependentPickListNoMigrar implements vlocity_cmt.VlocityOpenInterface{
    
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        
        try{
	        if(methodName.equals('firstPicklist')){
	        	populateFirstPicklist(input, outMap, options);
	        }
	    } catch(Exception ex){
	    	outMap.put('error', 'Error inesperado: ' + ex.getMessage());
	    }

	    return true;
    }

    private void populateFirstPicklist(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
    	Map<String, List<Map<String, String>>> dependency = new Map<String,List<Map<String, String>>>();

    	List<Map<String, String>> tempListMap = new List<Map<String, String>>();
    	Map<String, String> tempMap = new Map<String, String>();

    	//-GENERICS-------------------------------------------------------------
    	Map<String, String> genericOthers = new Map<String, String>();
    	genericOthers.put('name', 'Otros');
		genericOthers.put('value', 'Otros');
    	Map<String, String> genericErrInf = new Map<String, String>();
		genericErrInf.put('name', 'Informacion Incorrecta');
		genericErrInf.put('value', 'Informacion Incorrecta');
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		tempListMap = new List<Map<String, String>>();
		tempMap = new Map<String, String>();
    	tempMap.put('name', 'Inconv con derivación a representante');
    	tempMap.put('value', 'Inconv con derivación a representante');
    	tempListMap.add(tempMap);
    	tempListMap.add(genericOthers);
    	tempListMap.add(genericErrInf);
    	dependency.put('*111', tempListMap);
    	//----------------------------------------------------------------------
		tempListMap = new List<Map<String, String>>();
		tempListMap.add(genericOthers);
    	tempListMap.add(genericErrInf);
		dependency.put('*878 (Saldo Virtual)', tempListMap);
		//----------------------------------------------------------------------

		/*dependency.put('*150 (saldo)', new List<Map<String, String>>());
		dependency.put('*152 (packs, nros amigos)', new List<Map<String, String>>());
		dependency.put('*CLUB (*2582)', new List<Map<String, String>>());
		dependency.put('*25225 (Black)', new List<Map<String, String>>());
		dependency.put('*25283 (Clave)', new List<Map<String, String>>());
		dependency.put('*77666 (Promo)', new List<Map<String, String>>());
		dependency.put('*7526 (PLAN)', new List<Map<String, String>>());
		dependency.put('*2447 (Chip)', new List<Map<String, String>>());
		dependency.put('*333 (recarga delivery)', new List<Map<String, String>>());
		dependency.put('*151 (recargas)', new List<Map<String, String>>());
		dependency.put('*767 (SOS)', new List<Map<String, String>>());
		dependency.put('*555 (contestador)', new List<Map<String, String>>());
		dependency.put('*99999 (PBP)', new List<Map<String, String>>());
		dependency.put('*88988 (SAEC)', new List<Map<String, String>>());
		dependency.put('*910', new List<Map<String, String>>());*/

		outMap.put('dependency', dependency);
    }

}