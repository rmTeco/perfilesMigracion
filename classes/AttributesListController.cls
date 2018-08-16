public class AttributesListController 
{
    public List<AttributeAssignment> attrAssigns;
    public Map<Id,List<AttributeAssignment>> prod2attrAssigns;
    private Map<Id,String> attr2DefPLValue;
    
    public class AttributeAssignment
    {
        public vlocity_cmt__AttributeAssignment__c attrAssign { get; set; }
        public Product2 product { get; set; }
        public List<String> pickListValues { get; set; }
        public String defaultPLValue { get; set; }
        public String isReadonly { get; set; }
        public String isRequired { get; set; }
        
        AttributeAssignment(vlocity_cmt__AttributeAssignment__c attrAssign)
        {
            this.attrAssign = attrAssign;
            this.isReadonly = attrAssign.vlocity_cmt__IsReadOnly__c ? 'yes' : 'no';
            this.isRequired = attrAssign.vlocity_cmt__IsRequired__c ? 'yes' : 'no';
        }
        
    }
    
    public List<AttributeAssignment> getAssignments() 
    {
        //Get list of all atrribute assignments
        List<vlocity_cmt__AttributeAssignment__c> results = [select 
                                                             Id, 
                                                             vlocity_cmt__ObjectId__c, 
                                                             vlocity_cmt__AttributeCategoryId__r.Name, 
                                                             vlocity_cmt__AttributeId__r.Name, 
                                                             vlocity_cmt__AttributeId__c,
                                                             vlocity_cmt__AttributeId__r.vlocity_cmt__Description__c, 
                                                             vlocity_cmt__ValueDataType__c, 
                                                             vlocity_cmt__PicklistId__r.Name,  
                                                             vlocity_cmt__Value__c, 
                                                             vlocity_cmt__DefaultPicklistValueId__r.Name, 
                                                             vlocity_cmt__IsReadOnly__c, 
                                                             vlocity_cmt__IsRequired__c  
                                                             from vlocity_cmt__AttributeAssignment__c
                                                            ];
        
        prod2attrAssigns = new Map<Id,List<AttributeAssignment>>();
        
        //Store results into Map (productID - AttributeAssignments)
        Iterator<vlocity_cmt__AttributeAssignment__c> it=results.iterator();
        System.debug('\n\nStart reading the results');
        while(it.hasNext())
        {
            vlocity_cmt__AttributeAssignment__c attrAssign = (vlocity_cmt__AttributeAssignment__c)it.next();
            System.debug('\n\nattrAssign.Id='+attrAssign.Id+'; ProductId='+attrAssign.vlocity_cmt__ObjectId__c);
            Id productId = Id.valueOf(attrAssign.vlocity_cmt__ObjectId__c);
            System.debug('real ProductId='+productId);
            
            List<AttributeAssignment> attrAssgnTmp = prod2attrAssigns.get(productId);
            if (attrAssgnTmp==null) attrAssgnTmp = new List<AttributeAssignment>();
            attrAssgnTmp.add(new AttributeAssignment(attrAssign));
            
            prod2attrAssigns.put(productId, attrAssgnTmp);
        }
        System.debug('\n\nResults processed');
        
        //Now for each AttributeAssignment we need to resolve ProductId into Product2 record
        resolveProducts();
        
        //get all values from the map(ProductId - AttributeAssignments) and store them into the new List
        attrAssigns = new List<AttributeAssignment>();
        Iterator<Id> productsItr = prod2attrAssigns.keySet().iterator();
        while (productsItr.hasNext())
        {
            Id productId = productsItr.next();
            List<AttributeAssignment> attrAssignTmp = prod2attrAssigns.get(productId);
            if (attrAssignTmp==null || attrAssignTmp.size()==0 || attrAssignTmp.get(0)==null || attrAssignTmp.get(0).product==null) continue;
            attrAssigns.addAll(attrAssignTmp);
        }
        
        return attrAssigns;
        
    }
    
    private void resolveProducts()
    {
        List<Product2> products = [select Id, Name, ProductCode, vlocity_cmt__JSONAttribute__c from Product2 where Id=:prod2attrAssigns.keySet()];
        Iterator<Product2> productsItr = products.iterator();
        while (productsItr.hasNext())
        {
            Product2 product = productsItr.next();
            if (product.ProductCode==null || !product.ProductCode.startsWith('XOM'))
            {
                prod2attrAssigns.remove(product.Id);
                continue;
            }
            //Parse JSON Attribute and store all picklist values in a map (attribute Id - list of values)
            //            Map<Id,List<String>> attr2pickListValues = new Map<Id,List<String>>();
            Map<Id,List<String>> attr2pickListValues = new Map<Id,List<String>>();
            attr2DefPLValue = new Map<Id,String>();
            String json = product.vlocity_cmt__JSONAttribute__c;
            if (json!=null) attr2pickListValues = parseJSONAttribute(json);
            
            //Populate AttributeAssignment objects with Product and picklist values
            List<AttributeAssignment> attrAssgnLst = prod2attrAssigns.get(product.Id);
            Iterator<AttributeAssignment> attrAssItr = attrAssgnLst.iterator();
            while (attrAssItr.hasNext())
            {
                //get AttributeAssignment object
                AttributeAssignment attrAssgn = attrAssItr.next();
                
                //populate product
                attrAssgn.product = product;
                
                //populate picklist values (if needed)
                attrAssgn.pickListValues = attr2pickListValues.get(attrAssgn.attrAssign.vlocity_cmt__AttributeId__c);
                
                //populate default picklist value (if needed)
                attrAssgn.defaultPLValue = attr2DefPLValue.get(attrAssgn.attrAssign.vlocity_cmt__AttributeId__c);
            }
        }
    }
    
    /**
* the method parses JSONAttribute field to get pick list values and default pick list value 
* (if an attribute is a lick list).
* Logic assumes certain format of the corresponding JSON:
* {   <--each attribute starts with an Array
*   "$$AttributeDefinitionStart$$" <-- and this tag in the beginning
*   ...
*   "attributeid__c": ...    <--attribute id
*   ...
*   "valuedatatype__c": "Picklist",    <-- indication that a particular attribute is a picklist
*   ...
*   "displayText": ...   <-- picklist value will be taken from here
*   ...
*	"default"  <--start of the section for the dafult pick list value
*	...
*	"displayText": ...   <-- default picklist value will be taken from here
*   ...
*   "$$AttributeDefinitionEnd$$"
* }
* */
    
    private Map<Id,List<String>> parseJSONAttribute(String json)
    {
        Map<Id,List<String>> attr2pickListValues = new Map<Id,List<String>>();
        
        System.debug('START JSON PARSER. json is: '+json);
        
        Map<String,Object> attrCats = (Map<String,Object>)System.JSON.deserializeUntyped(json);
        List<Object> attrs = attrCats.values();
        System.debug('Attributes are: '+attrs);
        
        for (Object attrListObj : attrs)
        {
            List<Object> attrList = (List<Object>)attrListObj;
                
            for (Object attr : attrList)
            {
                
                
                System.debug('==Attribute is: '+attr);
                Map<String, Object> attrMap = (Map<String,Object>)attr;
                System.debug('==Attribute is converted to Map: '+attrMap);
                
                String attrIdasString = (String)attrMap.get('attributeid__c');
                System.debug('==Attribute Id is: '+attrIdasString);
                Id attrId = attrIdasString==null ? null : Id.valueOf(attrIdasString);
                
                String attrType = (String)attrMap.get('valuedatatype__c');
                System.debug('==Attribute type is: '+attrType);
                
                if ('Picklist'.equals(attrType))
                {
                    List<String> pickListValues = new List<String>();
                    
                    Map<String,Object> attrRunTime = (Map<String,Object>)attrMap.get('attributeRunTimeInfo');
                    System.debug('==Attribute run time is: '+attrRunTime);
                    
                    List<Object> values = (List<Object>)attrRunTime.get('values');
                    System.debug('==Picklist values are: '+values);
                    
                    for (Object value : values)
                    {
                        System.debug('===Picklist value block is: '+value);
                        Map<String, Object> valueMap = (Map<String, Object>)value;
                        System.debug('===Picklist value block as Map is: '+valueMap);
                        
                        String pickList = (String)valueMap.get('displayText');
                        System.debug('===Picklist value is: '+pickList);
                        
                        pickListValues.add(pickList);
                    }
                    
                    List<Object> defaultPLBlock = (List<Object>)attrRunTime.get('default');
                    System.debug('==Default PL block is: '+defaultPLBlock);
                    
                    Map<String,Object> defaultPLBlockMap = new Map<String,Object>();
                    System.debug('==Default PL block Map is: '+defaultPLBlockMap);
                    
                    if (defaultPLBlock.size()>0) defaultPLBlockMap = (Map<String,Object>)defaultPLBlock.get(0);
                    
                    if (attrId != null) 
                    {
                        attr2DefPLValue.put(attrID, (String)defaultPLBlockMap.get('displayText'));
                        attr2pickListValues.put(attrId, pickListValues);
                        System.debug('==Default PL value and all PL values are saved');
                    }
                }
            }
        }
        
        return attr2pickListValues;
    }
}