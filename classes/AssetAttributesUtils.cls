/**
* Created by joaquininurrategui on 9/6/17.
*/
global with sharing class AssetAttributesUtils {
    
    public static Map<String,Object> getAssetAttribute (Id idAsset, List<String> attName){
        /*
        Params:
        idAsset = Asset where the attributes want to be retreived.
        attName = List of attributes to be retreived, string must be equal to the attributedisplayname__c field of
        the attribute.

        Return:

        A map of attributedisplayname__c and values of an attribute.

        */
        Map<String, Object> response = new Map<String, Object>();
        Asset objAsset = new Asset();
        Map<String, Object> mapJsonAttributes = new Map<String,Object>();
        
        try{
            List<Asset> objAssets = [Select vlocity_cmt__JSONAttribute__c From Asset Where id = :idAsset];
            
//            if(objAssets.size() == 0 )
//                throw new FuncException('No se a encontrado el servicio seleccionado');
            if(objAssets[0].vlocity_cmt__JSONAttribute__c == null){
                return response;
                //throw new FuncException('No existen atributos cargados para el servicio seleccionado');*/
            }
            
            objAsset = objAssets[0];
            mapJsonAttributes = (Map<String, Object>) JSON.deserializeUntyped(objAsset.vlocity_cmt__JSONAttribute__c);

            Set<String> attributesKeys = mapJsonAttributes.keySet();
            //Attributes may have more than one parent node so this iterates the first child nodes
            for(String attributeKey : attributesKeys){
                List<Object> attributes = (List<Object>)mapJsonAttributes.get(attributeKey);

                //Iterates the second childs

                for(Object attribute : attributes){
                    
                    Map<String, Object> mapAttribute = (Map<String, Object>) attribute;

                    //Iterates the String List send in the parameters

                    for(String displayName : attName){
                        
                        String attValue = '';
                        String attDisplayText = '';

                        //Fields with datatype Picklist have the selected value on another child

                        if(displayName == (String) mapAttribute.get('attributedisplayname__c'))
                        {
                            if((String) mapAttribute.get('valuedatatype__c') == 'Checkbox')
                            {
                                Map<String, Object> mapAttributeRunTimeInfo = (Map<String, Object>)mapAttribute.get('attributeRunTimeInfo');
                                attValue = String.ValueOf(mapAttributeRunTimeInfo.get('value'));
                                response.put(displayName, attValue);
                            } 
                            else if((String) mapAttribute.get('valuedatatype__c') == 'Picklist')
                            {
                                Map<String, Object> mapAttributeRunTimeInfo = (Map<String, Object>)mapAttribute.get('attributeRunTimeInfo');
                                Map<String, Object> mapselectedItem = (Map<String, Object>)mapAttributeRunTimeInfo.get('selectedItem');
                                attValue = String.ValueOf(mapselectedItem.get('value'));
                                attDisplayText = String.ValueOf(mapselectedItem.get('displayText'));

                                Map<String, String> aux = new Map<String, String>();
                                aux.put('value', attValue);
                                aux.put('displayText', attDisplayText);
                                response.put(displayName, aux);
                            }
                            else
                            {
                                attValue = String.ValueOf(mapAttribute.get('value__c'));
                                response.put(displayName, attValue);
                            }
                        }

                    }
                }   
            }
            
            return response;
            
//        }catch(FuncException ex){
//            throw ex;
        } catch(Exception ex){
            //outMap.put('debug', debug+' options: ' + options);
            response.put('error', 'Error inesperado al obtener datos del servicio: ' + ex.getMessage());
            //throw ex;
        }
        return null;
    }

    public static Map<String,Object> GetJSONAttribute (String jsonAttribute, String displayName){
        try
        {
            Map<String, Object> ret = null;
            if(jsonAttribute != null){
                Map<String, Object> attributesKeys = (Map<String, Object>)JSON.deserializeUntyped(jsonAttribute);
                for (Object attributeKey : attributesKeys.values()){
                    // logic if you don't need the key
                    List<Object> attributes = (List<Object>)attributeKey;
                    for(Object attribute : attributes){
                        Map<String, Object> mapAttribute = (Map<String, Object>)attribute;

                        if(mapAttribute.get('attributedisplayname__c') == displayName){
                            return mapAttribute;
                        }
                    }
                }
            }
            return ret;
        }
        catch(Exception e)
        {
           System.debug('Exception Msg: ' + e.getMessage());
           System.debug('Exception Cause: ' + e.getCause());
           System.debug('Exception Stack Trace: ' + e.getStackTraceString());
           throw e;
        }
    }

    public static List<String> GetJSONAttributePickListValues (String jsonAttribute, String displayName){
        List<String> pickListValues = new List<String>();
        Map<String,Object> attributeRunTimeInfo = GetJSONAttribute(jsonAttribute, displayName);
        Map<String, Object> attributeRunTimeInfo2 = (Map<String, Object>) attributeRunTimeInfo.get('attributeRunTimeInfo');
        List<Object> values = (List<Object>) attributeRunTimeInfo2.get('values');
        for (Object optionMapObj : values)
        {
            Map<String, Object> option = (Map<String, Object>) optionMapObj;
            String optionValue = (String) option.get('value');
            pickListValues.add(optionValue);
        }
        return pickListValues;
    }

    public static String setValuesOnJSON(String jsonString, Map<String, String> attribs) {
        System.debug('Reading JSON Attribute');
        Map<String, Object> jsonAttributeMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        for (String jsonAttributeKey : jsonAttributeMap.keySet()) {
            List<Object> jsonMapValuesList = (List<Object>) jsonAttributeMap.get(jsonAttributeKey);

            for (Object o : jsonMapValuesList) {
                Map<String, Object> stringObjectMap = (Map<String, Object>) o;
                String attribute = (String) stringObjectMap.get('attributedisplayname__c');
                System.debug('attribute:' + attribute);
                if (attribs.containsKey(attribute)){
                    Map<String, Object> valueMap = (Map<String, Object>) stringObjectMap.get('attributeRunTimeInfo');
                    //String value = (String) valueMap.get('value');
                    System.debug('value:' + attribs.get(attribute));
                    valueMap.put('value', attribs.get(attribute));
                    attribs.remove(attribute);
                }
            }
        }
        return JSON.serialize(jsonAttributeMap);
    }

    public static Map<String, Object> ObtenerChargeCode(string jsonAtributte) {
        Map<String, Object> ret = null;
        Map<String, Object> attributes = (Map<String, Object>)JSON.deserializeUntyped(jsonAtributte);

        for (Object attribute : attributes.values()){
            // logic if you don't need the key
            List<Object> attributes2 = (List<Object>)attribute;

            for(Object atribute2 : attributes2){
                Map<String, Object> auxAttribute = (Map<String, Object>)atribute2;

                if(auxAttribute.get('attributedisplayname__c') == 'Charge Code' || 
                auxAttribute.get('attributedisplayname__c') == 'ID Sitema Origen'){ //ID Sitema Origen
                    return auxAttribute;
                }
            }
        }

        return ret;
    }  
}