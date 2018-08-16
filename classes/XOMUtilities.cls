global class XOMUtilities {

    /*Realizatin mode*/
    global static string INMEDIATO = 'Inmediato';
    global static string PROXIMO_CICLO = 'Proximo Ciclo';
    global static string TIEMPO_ESPECIFICADO = 'Tiempo Especificado';
    global static string DEFAULT_REALIZATION = 'I';

    global static string INMEDIATO_TRANSFORMED = 'I';
    global static string PROXIMO_CICLO_TRANSFROMED = 'N';
    global static string TIEMPO_ESPECIFICADO_TRANSFORMED = 'S';
    /*Realizatin mode*/

    /*FriendAndFamily Type*/
    global static string  DESCONOCIDO = 'Desconocido';
    global static string ONNET = 'Onnet';
    global static string OFFNET = 'Offnet';
    global static string INTERNACIONAL = 'Internacional';
    global static string LINEA_FIJA = 'Linea Fija';
    /* 0: Unknown,1: intra-network,2: inter-network, 3: International, 4: fixed line*/
    global static integer DESCONOCIDO_TRANSFORMED = 0;
    global static integer ONNET_TRANSFORMED = 1;
    global static integer OFFNET_TRANSFORMED = 2;
    global static integer INTERNACIONAL_TRANSFORMED = 3;
    global static integer LINEA_FIJA_TRANSFORMED= 4;
    /*FriendAndFamily Type*/

    public static String validatePaid(String s) {
    
        if(String.isNotEmpty(s))
        {
            return 'PAGADO';
        } 
        else
        {
            return 'NOPAGADO';
        }       
    }

    public static string evalueteRealization(string realization){
        if(realization == XOMUtilities.INMEDIATO)
            return XOMUtilities.INMEDIATO_TRANSFORMED;
        else if(realization == XOMUtilities.PROXIMO_CICLO)
            return XOMUtilities.PROXIMO_CICLO_TRANSFROMED;
        else if(realization == XOMUtilities.TIEMPO_ESPECIFICADO)
            return XOMUtilities.TIEMPO_ESPECIFICADO_TRANSFORMED;
        else
            return XOMUtilities.DEFAULT_REALIZATION;
    }

    public static integer evaluateNetworkType(string netType){
        if(netType == XOMUtilities.DESCONOCIDO)
            return XOMUtilities.DESCONOCIDO_TRANSFORMED;
        else if(netType == XOMUtilities.ONNET)
            return XOMUtilities.ONNET_TRANSFORMED;
        else if(netType == XOMUtilities.OFFNET)
            return XOMUtilities.OFFNET_TRANSFORMED;
        else if(netType == XOMUtilities.INTERNACIONAL)
            return XOMUtilities.INTERNACIONAL_TRANSFORMED;
        else
            return XOMUtilities.LINEA_FIJA_TRANSFORMED;
    }

    global List<Map<String, Object>> getJsonAttributesFromAnyObject(List<SObject> objects, string objectType){
        try{

            List<Map<String, Object>> outputJsonAttributes = new List<Map<String, Object>>();
            Map<String, Object> attributeValue;
            string jsonAttributeNode='';
            for(SObject attribute : objects){
                Map<String, Object> jsonAttribute;
                if(objectType == 'vlocity_cmt__InventoryItem__c')
                    jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(((vlocity_cmt__InventoryItem__c)attribute).vlocity_cmt__JSONAttribute__c);
                else if (objectType == 'Product2')
                    jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(((Product2)attribute).vlocity_cmt__JSONAttribute__c);                    
                else if(objectType == 'vlocity_cmt__FulfilmentRequestLine__c') 
                    jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(((vlocity_cmt__FulfilmentRequestLine__c)attribute).vlocity_cmt__JSONAttribute__c);
                else if (objectType == 'OrderItem')
                    jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(((OrderItem)attribute).vlocity_cmt__JSONAttribute__c);
                else if (objectType == 'Asset')
                    jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(((Asset)attribute).vlocity_cmt__JSONAttribute__c);
                else
                    jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(((vlocity_cmt__InventoryItem__c)attribute).vlocity_cmt__JSONAttribute__c);
                    //jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped((attribute.get(vlocity_cmt__JSONAttribute__c));

                //jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(attribute.vlocity_cmt__JSONAttribute__c);
                for(string node : jsonAttribute.keySet())
                {
                    jsonAttributeNode = node;                        
                
                    List<Object> attributesList = (List<Object>)jsonAttribute.get(jsonAttributeNode);
                    for(Object attribs : attributesList ){
                        attributeValue = new  Map<String, Object>();
                        Map<String, Object> attr = (Map<String, Object>)attribs;
                      
                        if(attr.get('Name') == null)
                            attributeValue.put('Name',attr.get('attributedisplayname__c'));
                        else
                            attributeValue.put('Name',attr.get('Name'));

                        object x = ((Map<String, Object>)(attr.get('attributeRunTimeInfo'))).get('value');
                        attributeValue.put('value',x);
                        outputJsonAttributes.add(attributeValue);   
                    }
                }
            }
            //System.debug(outputJsonAttributes);
            return outputJsonAttributes;
        }
        catch(Exception ex){
            System.debug(ex);
            return  new List<Map<String, Object>>();
        }
    }

     global string getValueFromAttrs(List<Map<String, Object>> attributes, string nodo)
    {
        try{
            for(object attribute:attributes){
                Map<String, Object> attr = (Map<String, Object>)attribute; 
                if(attr.get('Name') == nodo){
                    return String.valueOf(attr.get('value'));
                }
            }
            return '';
        }
        catch(exception ex){
            system.debug(ex);
            return '';
        }   
    }


}