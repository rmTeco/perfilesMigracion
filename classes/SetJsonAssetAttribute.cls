public class SetJsonAssetAttribute
{

    List<ID> listaIDs = new List<ID>();
    Map<String, object> inputMap = new Map<String, object>();
    MAP<String, object> outputMap = new Map<String, object>();
    Map<String, object> optionsMap = new Map<String, object>();
    public void setJsonAttribute(List<Asset> newAssetList)
    {
        for (Asset a: newAssetList)
        {
            if (a.Migrated__c)
            {
                listaIDs.add(a.Product2Id); 
            } 
        }  
        Map<ID,String> mapIdProducto = new Map<ID,String>();
        List<Product2> listaProductos = null;
        listaProductos = [SELECT p.ID, p.vlocity_cmt__JSONAttribute__c FROM Product2 p WHERE p.ID IN :listaIDs];
        for (Product2 prod : listaProductos)
        {
            mapIdProducto.put(prod.ID, prod.vlocity_cmt__JSONAttribute__c);
        }
        for (Asset a: newAssetList)
        {
            if (String.isBlank(a.vlocity_cmt__AttributeSelectedValues__c))
            {
                a.vlocity_cmt__JSONAttribute__c = mapIdProducto.get(a.Product2Id);
            }
            else
            {
                String originalAttributesJSON = mapIdProducto.get(a.Product2Id);
                List<vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest> actionRequestsList = new List<vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest>();
                inputMap.clear();
                outputMap.clear();
                optionsMap.clear();
                Object variableJsonObj =  JSON.deserializeUntyped(a.vlocity_cmt__AttributeSelectedValues__c);
                if (variableJsonObj instanceof Map<String,Object>)
                {
                    Map<String,Object> variableJsonMap = (Map<String,Object>)variableJsonObj;
                    for(String k: variableJsonMap.keyset())
                    {
                            //use JSONAttributeSupport.ActionType.ASSIGN ,if you have to just Set the value and no attrib rules.
                    actionRequestsList.add(new vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest(k, vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, variableJsonMap.get(k)));
                    }
                    vlocity_cmt.JSONAttributeSupport jsonSupport = new vlocity_cmt.JSONAttributeSupport();
                    inputMap.put('objectSO', null);
                    //inputMap.put('runTimeAttributesJSON', oi.JSONAttribute__c);
                    inputMap.put('runTimeAttributesJSON', originalAttributesJSON);
                    inputMap.put('originalAttributesJSON', originalAttributesJSON);
                    inputMap.put('JSONAttributeActionRequestList', actionRequestsList);
                    jsonSupport.invokeMethod('applyAttributeActions', inputMap, outputMap, optionsMap);
                    a.vlocity_cmt__JSONAttribute__c = (String)outputMap.get('modifiedJSON');
                    String modifiedJSON = (String)outputMap.get('modifiedJSON');
                    System.debug('------------------------ modifiedJSON = '+ modifiedJSON);
                }
            }
        }
    }

}