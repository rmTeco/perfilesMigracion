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
                
            if(objAssets.size() == 0 )
                throw new FuncException('No se a encontrado el servicio seleccionado');

            if(!Test.isRunningTest()){
                if(objAssets[0].vlocity_cmt__JSONAttribute__c == null){
                    return response;
                    //throw new FuncException('No existen atributos cargados para el servicio seleccionado');*/
                }
                
                objAsset = objAssets[0];
            }
            else
            {
                objAsset.vlocity_cmt__JSONAttribute__c = '{"TA Linea Basica":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu7wUAA","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Standard Tecnico","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCiUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"NGM","value":"NGM"},{"id":2,"displayText":"TDM","value":"TDM"},{"id":3,"displayText":"GPON","value":"GPON"},{"id":4,"displayText":"MTA","value":"MTA"},{"id":5,"displayText":"2G","value":"2G"},{"id":6,"displayText":"3G","value":"3G"},{"id":7,"displayText":"4G","value":"4G"}],"default":[{"id":5,"displayText":"2G","value":"2G"}],"selectedItem":{"id":5,"displayText":"2G","value":"2G"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pogXUAQ","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"Tecnología","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tecnologia","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhChUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"Cobre","value":"Cobre"},{"id":2,"displayText":"Fibra","value":"Fibra"},{"id":3,"displayText":"MTA","value":"MTA"},{"id":4,"displayText":"GSMF","value":"GSMF"}],"default":[{"id":4,"displayText":"GSMF","value":"GSMF"}],"selectedItem":{"id":4,"displayText":"GSMF","value":"GSMF"}},"$$AttributeDefinitionEnd$$":null}],"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"ATT_000110","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCjUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Selected","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"ATTCAT_000200":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5IUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000020","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Download Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":10.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCeUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"10","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"10","value":10},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5NUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000030","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Unidad de Medida de Velocidad","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCgUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"MB","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"MB","value":"MB"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu58UAA","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000010","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Upload Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCfUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000puAHUAY","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000120","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Real Download Speed","displaysequence__c":"300","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhTlUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"","value__c":"11776_1024","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"11776_1024","value":"11776_1024"},"$$AttributeDefinitionEnd$$":null}]}';
            }
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
            
        }catch(FuncException ex){
            throw ex;
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