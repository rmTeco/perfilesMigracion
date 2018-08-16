global class xOMIDGenerator implements vlocity_cmt.XOMOrchestrationInterfaces.IAutoTask {

	global void executeBatch(List<vlocity_cmt__orchestrationItem__c> items) {
		try {
			List<vlocity_cmt__FulfilmentRequestLine__c> ffRequestLines = new List<vlocity_cmt__FulfilmentRequestLine__c>();

			Set<Id> fulfilmentRequestLineIds = new Set<Id>();
			for (vlocity_cmt__OrchestrationItem__c item: items) {
				fulfilmentRequestLineIds.add(item.vlocity_cmt__FulfilmentRequestLineId__r.Id);
			}

			ffRequestLines.addAll([SELECT vlocity_cmt__JSONAttribute__c, Name, vlocity_cmt__FulfilmentRequestId__r.vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__c   
	                 FROM vlocity_cmt__fulfilmentRequestLine__c 
	                 WHERE Id in :fulfilmentRequestLineIds]);

			Set<Id> orderIdsSet = new Set<Id>();
			Map<String, OrderItem> oiOriginalMap = new Map<String, OrderItem>();
			for(vlocity_cmt__FulfilmentRequestLine__c ffl : ffRequestLines) {
				String assetReferenceAttribute = (String) getJSONAttribute(getJSONAttributes(ffl), 'Simcard AssetReferenceId');
				oiOriginalMap.put(assetReferenceAttribute, null);
				String orderId = ffl.vlocity_cmt__FulfilmentRequestId__r.vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__c;
				orderIdsSet.add(orderId);
			}

			Map<String, OrderItem> oiOriginalRootMap = new Map<String, OrderItem>();
			for(OrderItem oi : [Select vlocity_cmt__RootItemId__c From OrderItem Where Id in :oiOriginalMap.keySet()]) {
				oiOriginalMap.put(oi.Id, oi);
				oiOriginalRootMap.put(oi.vlocity_cmt__RootItemId__c, null);
			}

			Map<String, Map<String, OrderItem>> oiCurrentlRootMap = new Map<String, Map<String, OrderItem>>();
			for(OrderItem oi : [Select vlocity_cmt__AssetReferenceId__c From OrderItem Where Id in :oiOriginalRootMap.keySet()]) {
				oiOriginalRootMap.put(oi.Id, oi);
				oiCurrentlRootMap.put(oi.vlocity_cmt__AssetReferenceId__c, new Map<String, OrderItem>());
			}

			for(OrderItem oi : [Select Id, OrderId, vlocity_cmt__AssetReferenceId__c, vlocity_cmt__JSONAttribute__c From OrderItem Where OrderId in:orderIdsSet and vlocity_cmt__AssetReferenceId__c in :oiOriginalRootMap.keySet()]) {
				oiCurrentlRootMap.get(oi.vlocity_cmt__AssetReferenceId__c).put(oi.OrderId, oi);
			}
			System.debug(oiOriginalMap);
			System.debug(oiOriginalRootMap);
			System.debug(oiCurrentlRootMap);

			for (vlocity_cmt__FulfilmentRequestLine__c ffl: ffRequestLines) {
				if(ffl.vlocity_cmt__JSONAttribute__c == null) {
					continue;
				}
				Map<String, Object> jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(ffl.vlocity_cmt__JSONAttribute__c);

				//retrieve attribute category
				Object taAttributes = (Object)jsonAttribute.get('TA_attributes');

				String subscriberId = generateGUID();

				// set Subscriber Id
				taAttributes = setValueFromAttrs(taAttributes, 'Huawei Subscriber ID', subscriberId);
				// set Prepaid Account Id
				taAttributes = setValueFromAttrs(taAttributes, 'Huawei Prepaid Account Id', generateGUID());
				// set Payment Relationship Id
				taAttributes = setValueFromAttrs(taAttributes, 'Huawei Payment Relationship Id', generateGUID());

				// save attributes back in place
				ffl.vlocity_cmt__JSONAttribute__c = JSON.serialize(jsonAttribute);


				// now save subscriber id at the plan level
				String assetReferenceAttribute = (String) getJSONAttribute(getJSONAttributes(ffl), 'Simcard AssetReferenceId');
				String orderId = ffl.vlocity_cmt__FulfilmentRequestId__r.vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__c;
				
				OrderItem oiOriginal = oiOriginalMap.get(assetReferenceAttribute);
				OrderItem oiRootOriginal = oiOriginalRootMap.get(oiOriginal.vlocity_cmt__RootItemId__c);
				OrderItem oiRootCurrent = oiCurrentlRootMap.get(oiRootOriginal.vlocity_cmt__AssetReferenceId__c).get(orderId);

				Map<String, Object> jsonAttributePlan = (Map<String, Object>)JSON.deserializeUntyped(oiRootCurrent.vlocity_cmt__JSONAttribute__c);

				//retrieve attribute category
				Object taAttributesPlan = (Object)jsonAttributePlan.get('FAN_ATTCAT_000044');
				// set Subscriber Id
				taAttributesPlan = setValueFromAttrs(taAttributesPlan, 'Suscripcion ID', subscriberId);
				oiRootCurrent.vlocity_cmt__JSONAttribute__c = JSON.serialize(jsonAttributePlan);
				update oiRootCurrent;
			}
			update ffRequestLines;
			Map<String, OrderItem> orderItemsToUpdate = new Map<String, OrderItem>();
			for(Map<String, OrderItem> listOfMap : oiCurrentlRootMap.values()) {
				orderItemsToUpdate.putAll(listOfMap.values());
			}
			update orderItemsToUpdate.values();
		}
		catch (Exception ex) {
			system.debug(ex);
			throw new vlocity_cmt.XOMOrchestrationInterfaces.SystemInterfaceRecoverableException ('Exception '+ex+ '. Line number:' + ex.getLineNumber());
            return;
		}
		
	}

	private String generateGUID(){
		Blob b = Crypto.GenerateAESKey(128);
		String h = EncodingUtil.ConvertTohex(b);
		return h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
	}

	global Object getJSONAttribute(List<Map<String, Object>> attributesList, String attribute) {
		for(Map<String, Object> attributeItem : attributesList) {
			if(attributeItem.get('Name') == attribute) {
				return attributeItem.get('value');
			}
		}
		return null;
	}

	global List<Map<String, Object>> getJSONAttributes(vlocity_cmt__FulfilmentRequestLine__c ffl)
    {
        try {
			List<Map<String, Object>> outputJsonAttributes = new List<Map<String, Object>>();
            Map<String, Object> attributeValue;
            string jsonAttributeNode='';

            Map<String, Object> jsonAttribute = (Map<String, Object>)JSON.deserializeUntyped(ffl.vlocity_cmt__JSONAttribute__c);
            for(string node : jsonAttribute.keySet())
            {
                jsonAttributeNode = node;                        
            }
            List<Object> attributesList = (List<Object>)jsonAttribute.get(jsonAttributeNode);
            for(Object attribs : attributesList ){
                attributeValue = new  Map<String, Object>();
                Map<String, Object> attr = (Map<String, Object>)attribs;
              
                attributeValue.put('Name',attr.get('Name'));
                object x = ((Map<String, Object>)(attr.get('attributeRunTimeInfo'))).get('value');
                attributeValue.put('value',x);
                outputJsonAttributes.add(attributeValue);   
            }

            return outputJsonAttributes;
        }
        catch(exception ex){
            system.debug(ex);
            return new List<Map<String, Object>>();     
        }
    }

    /*global string getValueFromAttrs(List<Map<String, Object>> attributes, string nodo)
    {
        try{
            for(object attribute:attributes){
                Map<String, Object> attr = (Map<String, Object>)attribute; 
                if(attr.get('Name') == nodo){
                    attributeRunTimeInfo
                    return String.valueOf(attr.get('value'));
                }
            }
            return '';
        }
        catch(exception ex){
            system.debug(ex);
            return '';
        }   
    }*/

    global Object setValueFromAttrs(Object attributes, String attributeName, String newValue)
    {
        try {
            for(Object attribute: (List<Object>) attributes) {
                Map<String, Object> attr = (Map<String, Object>)attribute; 
                if((attr.containsKey('attributedisplayname__c') && attr.get('attributedisplayname__c') == attributeName)
                	|| (attr.containsKey('Name') && attr.get('Name') == attributeName)) {
                    Map<String, Object> attributeRunTimeInfo = (Map<String, Object>)(attr.get('attributeRunTimeInfo'));
                    attributeRunTimeInfo.put('value', newValue);
                }
            }
        }
        catch(exception ex){
            system.debug(ex);
        }
        return attributes;
    }
/*
    public class JSONAttributeObject {
    	public Map<String, List<AttributeDTO>> attributeCategories;

    }
  "TA_attributes": [
    {
      "$$AttributeDefinitionStart$$": null,
      "categorycode__c": "TA_attributes",
      "attributeid__c": "a0L0U000000059NUAQ",
      "attributeuniquecode__c": "fd7481b9-6257-0e95-0c09-59ace9367a5b",
      "attributedisplayname__c": "Account",
      "id": "a0I0U000000BkSzUAK",
      "objectid__c": "01t0U000000BbQ0QAK",
      "objecttype__c": "Product2",
      "categoryname__c": "TA attributes",
      "valuedatatype__c": "Text",
      "displaysequence__c": "666",
      "attributecategoryid__c": "a0K0U00000009uMUAQ",
      "attributedisplaysequence__c": "1",
      "hasrule__c": false,
      "isactive__c": true,
      "ishidden__c": false,
      "isreadonly__c": false,
      "isquerydriven__c": false,
      "isconfigurable__c": false,
      "attributefilterable__c": true,
      "attributeconfigurable__c": true,
      "isrequired__c": false,
      "formatmask__c": null,
      "valueinnumber__c": null,
      "querycode__c": null,
      "querylabel__c": null,
      "rulemessage__c": null,
      "uidisplaytype__c": null,
      "value__c": null,
      "valuedescription__c": null,
      "attributeRunTimeInfo": {
        "dataType": "Text",
        "default": "",
        "value": "0010U000002kIKJQA2"
      },
      "Name": "Account",
      "Code": "fd7481b9-6257-0e95-0c09-59ace9367a5b",
      "Filterable": true,
      "SegmentValue": "0010U000002kIKJQA2",
      "$$AttributeDefinitionEnd$$": null
*/
}//7867997f-599f-5575-8894-86b595ed41d5