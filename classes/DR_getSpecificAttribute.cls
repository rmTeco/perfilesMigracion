global class DR_getSpecificAttribute implements vlocity_cmt.VlocityOpenInterface2{
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options)
    {

        try{
            //vlocity_cmt__InventoryItemId__c

            list<Object> arguments = (List<Object>)inputs.get('arguments'); //get arguments
            string objectId = (string)arguments[0]; //object Id to get GET ATTRS
            string nodeToSave = (string)arguments[1]; //node to take from those attrs
            string objectToSearch = ''; //from what object was that id? [optional] if there is no third argument we will suposse you want the inventory item of a fulfilmentRequestLine (the first porpuse of this class)
            List<Map<string, Object>> allAttrs;

            if(objectId != null && nodeToSave != null)
            {
                if(arguments.size() > 2) //if there is a third argument
                {
                    objectToSearch =(string)arguments[2];
                    if(objectToSearch == 'OrderItem'){
                        allAttrs = this.getJsonAttributesFromAnyObject([SELECT id, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE id = :objectId], 'OrderItem');
                    }
                    else if(objectToSearch == 'vlocity_cmt__InventoryItem__c'){
                        allAttrs = this.getJsonAttributesFromAnyObject([select id, vlocity_cmt__JSONAttribute__c from vlocity_cmt__InventoryItem__c where id IN(select vlocity_cmt__InventoryItemId__c from vlocity_cmt__FulfilmentRequestLine__c where id =  :objectId)], 'vlocity_cmt__InventoryItem__c');
                    }
                    else if(objectToSearch == 'getParentOrderProductAttributes'){
                        //vlocity_cmt__ParentItemId__c
                        allAttrs = this.getJsonAttributesFromAnyObject([SELECT id, vlocity_cmt__JSONAttribute__c,vlocity_cmt__ParentItemId__c FROM OrderItem WHERE vlocity_cmt__ParentItemId__c ='' AND OrderId = :objectId], 'OrderItem');
                    }

                }
                else
                {
                    List<vlocity_cmt__InventoryItem__c> inventoryItem = [select id, vlocity_cmt__JSONAttribute__c from vlocity_cmt__InventoryItem__c where id IN(select vlocity_cmt__InventoryItemId__c from vlocity_cmt__FulfilmentRequestLine__c where id =  :objectId)];
                    allAttrs = getJsonAttributes(inventoryItem[0].id);
                }

                string newNode = getValueFromAttrs(allAttrs, nodeToSave);

                if(newNode != '')
                    output.put('result',newNode);
                else
                    output.put('result', 'nothing found');
                return true;
            }
                output.put('result', 'No id passed');
                return false;
        }
        catch(exception ex){
            system.debug(ex);
            return false;
        }
    
    }

    global List<Map<String, Object>> getJsonAttributes(string fullfilmentRequstLineId)
        {
            try{

                List<Map<String, Object>> outputJsonAttributes = new List<Map<String, Object>>();
                Map<String, Object> attributeValue;
                string jsonAttributeNode='';

                List<vlocity_cmt__InventoryItem__c> fullfilmentRequstLineList = 
                    [SELECT vlocity_cmt__JSONAttribute__c 
                     FROM vlocity_cmt__InventoryItem__c 
                     WHERE id = :fullfilmentRequstLineId];
               
                for(vlocity_cmt__InventoryItem__c attribute : fullfilmentRequstLineList){
                    Map<String, Object> jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(attribute.vlocity_cmt__JSONAttribute__c);
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
                return outputJsonAttributes;
            }
            catch(exception ex){
                system.debug(ex);
                return new List<Map<String, Object>>();     
            }
        } 


    global List<Map<String, Object>> getAllAttributes(List<Object> intentoryItemAttrs)
    {
        try
        {
            system.debug('inventoryItem '+intentoryItemAttrs[0]);
            List<Map<String, Object>> outputJsonAttributes = new List<Map<String, Object>>();
            for(object jsonAttribute : intentoryItemAttrs)
            {
                List<Object> categories =(List<Object>)(((Map<String, Object>)jsonAttribute).get('vlocity_cmt__JSONAttribute__c'));
                system.debug('categories '+categories);
                                system.debug('ketset '+((Map<string, object>)categories[0]).keySet());


                for(object category : ((Map<string, object>)categories[0]).keySet()){
                    system.debug('category '+category);

                }
                system.debug('jsonAttribute '+jsonAttribute);
                //system.debug('keyset '+((Map<string, object>)intentoryItemAttrs[0]).keySet());
                Map<String, Object> attributeValue;
                //((Map<String,Object>)jsonAttribute).keySet())
                //((Map<String, Object>)JSON.deserializeUntyped(((Map<String, Object>)jsonAttribute).vlocity_cmt__JSONAttribute__c)).keySet()

               // ((Map<String, Object>)JSON.deserializeUntyped(Vlocity_cmt__InventoryItem__c)jsonAttribute).keySet()
                for(string node : ((Map<string, object>)jsonAttribute).keySet())
                {
                    string jsonAttributeCategory = node;                        
                    List<Object> attributesFromCategoryList = (List<Object>)((Map<String,Object>)jsonAttribute).get(jsonAttributeCategory);
                    for(Object attribs : attributesFromCategoryList ){
                        attributeValue = new  Map<String, Object>();
                        Map<String, Object> attr = (Map<String, Object>)attribs;
                          
                        attributeValue.put('Name',attr.get('Name'));
                        object x = ((Map<String, Object>)(attr.get('attributeRunTimeInfo'))).get('value');
                        attributeValue.put('value',x);
                        outputJsonAttributes.add(attributeValue);   
                    }
                }
            }
            system.debug(outputJsonAttributes);
            return outputJsonAttributes;
        }
        catch(exception ex){
            system.debug(ex);
            return new List<Map<String, Object>>();
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

    global List<Map<String, Object>> getJsonAttributesFromOrderItems(List<OrderItem> orderItems){
        try{

            List<Map<String, Object>> outputJsonAttributes = new List<Map<String, Object>>();
            Map<String, Object> attributeValue;
            string jsonAttributeNode='';

           
            for(OrderItem attribute : orderItems){
                Map<String, Object> jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(attribute.vlocity_cmt__JSONAttribute__c);
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
            System.debug(outputJsonAttributes);
            return outputJsonAttributes;
        }
        catch(Exception ex){
            System.debug(ex);
            return  new List<Map<String, Object>>();
        }
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
            System.debug(outputJsonAttributes);
            return outputJsonAttributes;
        }
        catch(Exception ex){
            System.debug(ex);
            return  new List<Map<String, Object>>();
        }
    }

}