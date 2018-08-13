global with sharing class CustomValidateAssetImplementation implements vlocity_cmt.VlocityOpenInterface {
    static final String selectedAssetsDelem = ':';
    public static final String selectedAssetsKey = 'jsonPath';
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)  {

        if (methodName.equals('validateSelectedAsset')) {
            validateSelectedAsset(input, output, options);
        }

        return false;
    }

    private void validateSelectedAsset(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options){
        try{
            //Logger.err('Inside validateSelectedAsset');
            String elemName  = (String)options.get('JSON Node'); // Json Node
            System.debug('elemName :: '+JSON.serialize(elemName));
            String allAssets = (String)options.get('Elem Name');
            System.debug('allAssets :: '+JSON.serialize(allAssets));
            if ((allAssets == null) || String.isEmpty(allAssets)) 
                 {
                     System.debug('Here :: ');
                 }
            if ((elemName == null) || String.isEmpty(elemName)) 
                 System.debug('Here it is :: ');
            Object tempPath = options.get(selectedAssetsKey);
            System.debug('tempPath :: '+JSON.serialize(tempPath));
            if(tempPath == null)
                System.debug('Now Here :: ');
        
            List<String> selectedAssetsPath = ((String) tempPath).split(selectedAssetsDelem);
            System.debug('selectedAssetsPath :: '+JSON.serialize(selectedAssetsPath));
            System.debug('selectedAssetsPath[0]---'+selectedAssetsPath[0]);
            Map<String, Object> obMap = (Map<String, Object>)inputMap.get(selectedAssetsPath[0].trim());
            System.debug('obMap---'+obMap);
            List<Object> selectedAssets = (List<Object>)obMap.get(selectedAssetsPath[1].trim());
            List<String> notAvailableList = new List<String>();
            List<LineItemWrapper> lineItems = new List<LineItemWrapper>();
            Boolean allAvailable = true;
            System.debug('selectedAssets :: '+JSON.serialize(selectedAssets));
            for(Object obj : selectedAssets) {
                Map<String, Object> objMap = (Map<String, Object>)obj;
                if(objMap != null) {
                    String availCheck = (String)objMap.get('Available');
                    if(availCheck == null || !availCheck.equals('Not Available')) {
                        LineItemWrapper lw = new LineItemWrapper(obj, 'Ascending');
                        lineItems.add(lw);
                    }else{
                        if(availCheck != null && availCheck.equals('Not Available')) {
                            allAvailable = false;
                            String lineNum = (String)objMap.get('LineNumber');
                            notAvailableList.add(lineNum);
                        }
                    }
                }
            }

            lineItems.sort();
            selectedAssets.clear();

            //Removing children for all products which are not available
            for(LineItemWrapper lw : lineItems) {
                Boolean flag = false;
                Object obj = lw.objItem;
                Map<String, Object> objMap = (Map<String, Object>)obj;
                String lineNum = (String)objMap.get('LineNumber');
                for(String str : notAvailableList){
                    if(lineNum.startsWith(str)) {
                        flag = true;
                        break;
                    }
                }
                if(!flag)
                    selectedAssets.add(obj);
            }
            outputMap.put(elemName,selectedAssets);
            outputMap.put('allAvailable', allAvailable);
            outputMap.put('showAssetList', true);

        }catch(Exception e)
        {
            //Logger.err(e);
            throw e;
        }
    }
    
    public class LineItemWrapper implements Comparable{
    public SObject sObjectItem;
    public String sortBy;
    public Object objItem;
    public LineItemWrapper(SObject item){
        sObjectItem = item;
    }
    
    public LineItemWrapper(Object item, String sortProp){
        objItem = item;
        sortBy = sortProp;
    }

    public Integer compareTo(Object compareTo){
        LineItemWrapper compareToLine = (LineItemWrapper)compareTo;
        Integer returnValue = 0;
        if(sObjectItem != null && compareToLine.sObjectItem != null) {
            if(sortBy ==  null || sortBy == 'Descending'){
                if(String.ValueOf(sObjectItem.get('LineNumber__c')) > String.ValueOf(compareToLine.sObjectItem.get('LineNumber__c'))){
                    returnValue = -1;
                
                } else if (String.ValueOf(sObjectItem.get('LineNumber__c')) < String.ValueOf(compareToLine.sObjectItem.get('LineNumber__c'))){
                    returnValue = 1;
                    
                }
            
            } else if(sortBy == 'Ascending'){
                if(String.ValueOf(sObjectItem.get('LineNumber__c')) > String.ValueOf(compareToLine.sObjectItem.get('LineNumber__c'))){
                    returnValue = 1;
                
                } else if (String.ValueOf(sObjectItem.get('LineNumber__c')) < String.ValueOf(compareToLine.sObjectItem.get('LineNumber__c'))){
                    returnValue = -1;
                    
                }
            
            
            }
        }
        else{
            if(objItem != null && compareToLine.objItem != null) {
                Map<String, Object> sObjMap = (Map<String, Object>)objItem;
                Map<String, Object> sObjMapCompareTo = (Map<String, Object>)compareToLine.objItem;
                if(sortBy ==  null || sortBy == 'Descending'){
                    if(String.ValueOf(sObjMap.get('LineNumber__c')) > String.ValueOf(sObjMapCompareTo.get('LineNumber__c'))){
                        returnValue = -1;
                    
                    } else if (String.ValueOf(sObjMap.get('LineNumber__c')) < String.ValueOf(sObjMapCompareTo.get('LineNumber__c'))){
                        returnValue = 1;
                        
                    }
                
                } else if(sortBy == 'Ascending'){
                    if(String.ValueOf(sObjMap.get('LineNumber__c')) > String.ValueOf(sObjMapCompareTo.get('LineNumber__c'))){
                        returnValue = 1;
                    
                    } else if (String.ValueOf(sObjMap.get('LineNumber__c')) < String.ValueOf(sObjMapCompareTo.get('LineNumber__c'))){
                        returnValue = -1;
                        
                    }
                
                
                }
            }
        }

        return returnValue;
    }
    
}
    
}