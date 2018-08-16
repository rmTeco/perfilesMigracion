@RestResource(urlMapping='/ta/om/v1/assets')
/**
* Rest controller to create/update Assets with Json attibute support
*/
global with sharing class XOMAssetsREST  {

    //private static final String namespace = ApplicationUtilities.getNameSpacePrefix();
    private static final String VLOCITY_CMT_PREFIX = 'vlocity_cmt__';

    static Integer id_counter = 1;

    /**
    * Sample request: [{"assetReferenceId":"ta_root_asset_reference_id_value", "Name": "Root Asset", "serviceAccountId": "001f400000FqndmAAB", "specifiedBy":{"specificationName": "Product", "globalKey": "6c12c7d9-0152-48b4-a3a6-91d57290d57c"}, "describedBy":[{"characteristic": "Internet Bandwidth", "code": "INT-BAND", "value": "10MBPS" }, {"characteristic": "Contract Term", "code": "CONTRACT-TERM","value": "6 months"}],"children":[]}]
    */
    @HttpPut
    global static void createAssets() {        
        //Logger.startElapseTimeTracking();

        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;

        resp.statusCode = 200;
        resp.headers.put('Content-Type','application/json');

        // Need to suppress all triggers
        //ApplicationUtilities.useVlocityTriggers = false;

        String requestJson = req.requestBody.toString();

        List<Object> jsonObjects= (List<Object>)JSON.deserializeUntyped(requestJson);
        List<Map<String, Object>> assetObjects = convertToObjectsWithParametersAndHierarchy(jsonObjects, null);

        System.debug('processing PUT Assets request: ' + requestJson);

        if ( requestJson == null ) 
        {
            resp.statusCode = 400;
            resp.responseBody = Blob.valueOf('Empty or invalid request. Expected array of Asset objects [{"assetReferenceId__c":"value1", "ServiceAccountId__c":"value2"...}, {...}]');
            return;
        }

        integer level = 0;

        List<Asset> allAssets = new List<Asset>();
        Map<String, Id> assetRefIdToId = new Map<String, Id>();
        Map<String, String> assetRefToProductGlobalKey = new Map<String, String>();
        Map<String, String> assetRefToCharacteristicValues = new Map<String, String>();

        List<Object> simcardDescribedBy;
        List<Object> planDescribedBy;


        Map<string, Id> lineNumberRefToProductId = new Map<string, Id>(); //Hearchy bugg
        // process assets and dump level by level
        while(assetObjects != null && assetObjects.size() > 0 && level < 16)
        {
            List<Asset> assets = new List<Asset>();
            List<Map<String, Object>> nextLevelAssetObjects = new List<Map<String, Object>>();

            for ( Map<String, Object>  assetObject : assetObjects )
            {
                Map<String, Object> productSpec = (Map<String, Object>) assetObject.get('specifiedBy');
                String globalKey = (String) productSpec.get('globalKey');

                if(globalKey == PRODUCT_SIMCARD_GKEY) {
                    simcardDescribedBy = (List<Object>) assetObject.get('describedBy');
                }else if(globalKey == PRODUCT_PLAN_REPRO_GKEY || globalKey == PRODUCT_PLAN_REPRO_GKEY)
                    planDescribedBy = (List<Object>) assetObject.get('describedBy');

                // process json and convert to asset with parent
                Asset assetToCreate = processAsset(assetObject, assetRefIdToId, assetRefToProductGlobalKey);
                if(assetToCreate != null)
                {
                    // add to batch
                    assets.add(assetToCreate);
                    // extract child assets and save parent-child relations
                    List<Map<String, Object>> childrenObjs = 
                    convertToObjectsWithParametersAndHierarchy(
                        (List<Object>) assetObject.get('children'), 
                        assetObject
                        );
                    System.debug('asset with assetReferenceId ' + assetToCreate.get(VLOCITY_CMT_PREFIX + 'assetReferenceId__c')
                        + ' have ' + childrenObjs.size() + ' child assets to process later');
                    
                    nextLevelAssetObjects.addAll(childrenObjs);
                }
            }

            System.debug('saving ' + assets.size() + ' assets from level ' + level);
            upsert assets;

            // update root ids
            if(level == 0)
            {
                for(Asset ass:assets)
                {
                    System.debug('setting RootItemId__c for root item ' + ass.name);
                    ass.put(VLOCITY_CMT_PREFIX + 'RootItemId__c', ass.id);
                    ass.put(VLOCITY_CMT_PREFIX + 'LineNumber__c', '0001');
                }
                upsert assets;                
            }
            for(Asset ass:assets)
            {
                assetRefIdToId.put((String) ass.get(VLOCITY_CMT_PREFIX + 'AssetReferenceId__c'), ass.id); // asset ref to asset id map, it is used to link children   
            }

            allAssets.addAll(assets);

           // time to process children objects in the next loop
           assetObjects = nextLevelAssetObjects;
           level++;
        }

        // fetch products and pricebook entry
        Set<String> globalKeys = new Set<String>();
        globalKeys.addAll(assetRefToProductGlobalKey.values());
        System.debug('global keys to process : ' + globalKeys);

        List<Product2> products = [select Id, name, vlocity_cmt__globalKey__c, vlocity_cmt__JSONAttribute__c from Product2 where vlocity_cmt__GlobalKey__c in : globalKeys];
        List<Pricebook2> defaultPricebook = [select Id from Pricebook2 where vlocity_cmt__IsDefault__c = true];
        if(products == null || products.size() == 0 ) throw new XOMAssetCreationException('Products have not been found by global keys from Payload: ' + globalKeys);
        if(defaultPricebook == null || defaultPricebook.size() == 0 ) throw new XOMAssetCreationException('Unable to link Assets and PricebookEntries: Default pricebook is not defined.');

        Set<Id> productIds = (new Map<Id,SObject>(products)).keySet();
        Id defaultpricebookId = defaultPricebook[0].id;
        List<PricebookEntry> pricebookEntries = 
        [select id, name, Product2Id, Pricebook2Id from PricebookEntry where Product2Id in : productIds and Pricebook2Id = : defaultpricebookId];

        // glKey to prodId
        Map<String, Id> glKeyToProductId = new Map<String, Id>();
        Map<String, String> glKeyToProductJsonAttribute = new Map<String, String>();
        for(Product2 product : products)
        {
            glKeyToProductId.put((String) product.get(VLOCITY_CMT_PREFIX + 'globalKey__c'), product.id);
            glKeyToProductJsonAttribute.put(
                (String) product.get(VLOCITY_CMT_PREFIX + 'globalKey__c'), 
                (String) product.get(VLOCITY_CMT_PREFIX + 'JSONAttribute__c'));
        }
        // prodId to pbeId
        Map<Id, Id> productIdToPBE = new Map<Id, Id>();
        for(PricebookEntry pricebookEntry : pricebookEntries)
        {
            productIdToPBE.put(pricebookEntry.Product2Id, pricebookEntry.id);
        }
        // resolve and set products and pricebookentries 
        for(Asset ass:allAssets)
        {
            String assRefId = (String) ass.get(VLOCITY_CMT_PREFIX + 'assetReferenceId__c');
            String globalKey = (String) assetRefToProductGlobalKey.get(assRefId);
            Id productId =  glKeyToProductId.get(globalKey);
            System.debug('resolving product by globalKey : ' + globalKey + ' product id ' + productId);
            if(productId == null)
                throw new XOMAssetCreationException('Unable to link Assets and Product: Product is not found by Global Key ' + globalKey);                            
            ass.Product2Id = productId;

            if(productIdToPBE.get(productId) == null)
                throw new XOMAssetCreationException('Unable to link Assets and PriceBookEntry: PriceBookEntry is not found for productId ' + productId);                
            ass.put(VLOCITY_CMT_PREFIX + 'PricebookEntryId__c', productIdToPBE.get(productId));

            // set jsonAttribute value taken from product
            //if(!globalKey.equals(PRODUCT_SIMCARD_GKEY)) // Simcard value is set via hardcode in processAsset() method above
            //    ass.put(VLOCITY_CMT_PREFIX + 'JSONAttribute__c', glKeyToProductJsonAttribute.get(globalKey));

            String jsonAttribute = glKeyToProductJsonAttribute.get(globalKey);
            ass.put(VLOCITY_CMT_PREFIX + 'JSONAttribute__c', jsonAttribute);
            ass.put(VLOCITY_CMT_PREFIX + 'ProductHierarchyPath__c' , productId);

            if(globalKey.equals(PRODUCT_SIMCARD_GKEY)) {
                Map<String, String> codeValueMap = new Map<String, String>();
                for(Object charValueObject: simcardDescribedBy) {
                    Map<String, Object> charVal = (Map<String, Object>) charValueObject;
                    String code = (String) charVal.get('code');
                    String value = (String) charVal.get('value');
                    if(value != null && !''.equals(value)) {
                        //process value
                        codeValueMap.put(code, value);
                    }
                }
                
                Map<String, Object> attributeCategories = (Map<String, Object>) JSON.deserializeUntyped(jsonAttribute);
                //attributeCategories = setValueFromAttrs(attributeCategories, 'MSISDN', codeValueMap.get('MSISDN')); MSISDN is beeing saved on rootAsset 17/04/2018
                attributeCategories = setValueFromAttrs(attributeCategories, 'IMSI', codeValueMap.get('FAN_ATT_000072'));
                attributeCategories = setValueFromAttrs(attributeCategories, 'ICCID', codeValueMap.get('FAN_ATT_000071'));
                attributeCategories = setValueFromAttrs(attributeCategories, 'KI', codeValueMap.get('FAN_ATT_000073'));
                
                ass.put(VLOCITY_CMT_PREFIX + 'JSONAttribute__c', JSON.serialize(attributeCategories));
            }
            if(globalKey.equals(PRODUCT_PLAN_REPRO_GKEY) || globalKey.equals(PRODUCT_PLAN_REPRO_SIT_GKEY)){//putting msisdn on plan

                Map<String, String> codeValueMap = new Map<String, String>();
                for(Object charValueObject: planDescribedBy) {
                    Map<String, Object> charVal = (Map<String, Object>) charValueObject;
                    String code = (String) charVal.get('code');
                    String value = (String) charVal.get('value');
                    if(value != null && !''.equals(value)) {
                        //process value
                        codeValueMap.put(code, value);
                    }
                }

                Map<String, Object> attributeCategories = (Map<String, Object>) JSON.deserializeUntyped(jsonAttribute);
                attributeCategories = setValueFromAttrs(attributeCategories, 'Numero de Linea', codeValueMap.get('FAN_ATT_000038'));
                ass.put(VLOCITY_CMT_PREFIX + 'JSONAttribute__c', JSON.serialize(attributeCategories));
            }
            //BUGG Hierarchy PFTA-10341
            lineNumberRefToProductId.put( (string)(ass.get(VLOCITY_CMT_PREFIX + 'LineNumber__c')) , ass.product2id);
        }

        //BUGG Hierarchy PFTA-10341
        allAssets = setProductHierarchyPath(allAssets,lineNumberRefToProductId);

        // update objects
        upsert allAssets;

        //resp.headers.put('api-response-time', Logger.getTimeElapsedDisplay());
    }

    public static Map<String, Object> setValueFromAttrs(Map<String, Object> attributeCategories, String attributeName, String newValue) {
        try {
            for(Object attributeCategory : attributeCategories.values()) {
                for(Object attribute: (List<Object>) attributeCategory) {
                    Map<String, Object> attr = (Map<String, Object>)attribute; 
                    if((attr.containsKey('attributedisplayname__c') && attr.get('attributedisplayname__c') == attributeName)
                        || (attr.containsKey('Name') && attr.get('Name') == attributeName)) {
                        Map<String, Object> attributeRunTimeInfo = (Map<String, Object>)(attr.get('attributeRunTimeInfo'));
                        attributeRunTimeInfo.put('value', newValue);
                        return attributeCategories;
                    }
                }
            }
        }
        catch(exception ex){
            system.debug(ex);
        }
        return attributeCategories;
    }


    public static Asset processAsset(Map<String, Object> assetObject, Map<String, Id> assetReferenceIdToIds,
        Map<String, String>  assetRefToProductGlobalKey) 
    {
        Id serviceAccountId = getIdValueByFieldName( assetObject, 'serviceAccountId');
        String assetReferenceId = (String) assetObject.get('assetReferenceId');
        String assetName = (String) assetObject.get('name');
        //String hierarchy = (String) assetObject.get('Hierarchy'); can't convert from long to string
        //system.debug('hierarchy ' + hierarchy);

        if(serviceAccountId == null || assetReferenceId == null)
        {
            System.debug('Ignoring asset processing due to missing mandatory fields, source json : ' + assetObject );
            return null;
        } else {
            System.debug('Creating asset ' + assetName + ' under account id ' + serviceAccountId);
            Asset asset = new Asset(name = assetName, AccountId = serviceAccountId, Quantity = 1, Price = 0, Status = 'Active');
            asset.put(VLOCITY_CMT_PREFIX + 'AssetReferenceId__c', assetReferenceId);
            asset.put(VLOCITY_CMT_PREFIX + 'ServiceAccountId__c', serviceAccountId);
            asset.put(VLOCITY_CMT_PREFIX + 'BillingAccountId__c', serviceAccountId);
            //asset.put(VLOCITY_CMT_PREFIX + 'ProductHierarchyPath__c', hierarchy);

            //asset.put(VLOCITY_CMT_PREFIX + 'ProvisioningStatus__c', 'Active');
            asset.put(VLOCITY_CMT_PREFIX + 'ProvisioningStatus__c', 'Preactive');

            // resolve parent and root id
            String parentRefId = (String) assetObject.get('parentRefId');
            String rootRefId = (String) assetObject.get('rootRefId');
            if(parentRefId != null && assetReferenceIdToIds.get(parentRefId) != null)
            {
                System.debug('setting parent id as ' + assetReferenceIdToIds.get(parentRefId) + 
                    ' for asset refId ' + asset.get(VLOCITY_CMT_PREFIX + 'AssetReferenceId__c'));
                asset.put(VLOCITY_CMT_PREFIX + 'ParentItemId__c', assetReferenceIdToIds.get(parentRefId));
            }
            if(rootRefId != null && assetReferenceIdToIds.get(rootRefId) != null)
            {
                System.debug('setting root id as ' + assetReferenceIdToIds.get(rootRefId) + 
                    ' for asset refId ' + asset.get(VLOCITY_CMT_PREFIX + 'AssetReferenceId__c'));
                asset.put(VLOCITY_CMT_PREFIX + 'RootItemId__c', assetReferenceIdToIds.get(rootRefId));
            }
            asset.put(VLOCITY_CMT_PREFIX + 'LineNumber__c', (String) assetObject.get('lineNumber'));

            //save global key for asset
            Map<String, Object> productSpec = (Map<String, Object>) assetObject.get('specifiedBy');
            String globalKey = (String) productSpec.get('globalKey');
            assetRefToProductGlobalKey.put(assetReferenceId, globalKey);

            //set characteristics to jsonAttribute knowing jsonTemplate found by productKey
            updateJsonAttribute(asset, globalKey, (List<Object>) assetObject.get('describedBy'));

            return asset;
        }
    }

    //BUGG Hierarchy PFTA-10341
    private static List<Asset> setProductHierarchyPath(List<Asset> assets, Map<string, Id> liineNumberAndId){
        try{
            for(Asset ass : assets){
                string line = String.valueOf(ass.get(VLOCITY_CMT_PREFIX + 'LineNumber__c'));
                if( line.split('\\.').size()>0){
                    List<string> lineNumbers = line.split('\\.');
                    
                    //the idea is to iterate getting the ref for line number 001, then 001.001, etc
                    string hearchy = '';
                    string lineNum = '';//first time it will get the ProductId OF 001, then of 001.001
                    for(integer i=0 ; i<lineNumbers.size()-1; i++){

                        if(i!= 0)
                            hearchy += VALUE_HIERARCHY_SEPARETOR;
                        if(lineNum != '')
                            lineNum += '.' + lineNumbers[i];
                        else
                            lineNum += lineNumbers[i];
                        
                        string s = string.valueOf(liineNumberAndId.get(lineNum));
                        hearchy += s;
                        ass.put(VLOCITY_CMT_PREFIX + 'ProductHierarchyPath__c', hearchy);
                    }
                    
                    if(lineNumbers.size()-1 == 0)
                        hearchy += string.valueOf(ass.get('product2id')); //if you are on root
                    else
                        hearchy += VALUE_HIERARCHY_SEPARETOR + string.valueOf(ass.get('product2id')); //if not on root

                    ass.put(VLOCITY_CMT_PREFIX + 'ProductHierarchyPath__c', hearchy);
                }
            }
            return assets;
        }
        catch(Exception ex){
            system.debug('exception on ' + ex.getLineNumber() + ' ' + ex);
            return assets;
        }
    }

    private static Id getIdValueByFieldName(Map<String, Object> assetObject, String fieldName)
    {
        if ( assetObject.containsKey(fieldName) )
        {
            //try
            //{
                Id idField = Id.valueOf((String)assetObject.get(fieldName));
                return idField;
            //}
            //catch (Exception e)
            //{
            //    System.debug(Logginglevel.ERROR, 'Ignoring asset field processing ' + fieldName + ' due to exception: ' + e.getMessage() + ' source json : ' + assetObject );
            //}
        } else {
            System.debug('Missing field with name ' + fieldName + ' for asset ' + assetObject);
        }

        return null;
    }

    private static List<Map<String, Object>> convertToObjectsWithParametersAndHierarchy(
        List<Object> objects, Map<String, Object> parentObject
        )
    {
        List<Map<String, Object>> converted = new List<Map<String, Object>>();
        Integer lineNo = 1;

        String parentRefId, rootRefId;
        String parentLineNumber;
        String parentServiceAccountId;

        if(parentObject != null)
        {
            parentRefId = (String) parentObject.get('assetReferenceId');
            rootRefId = (String) parentObject.get('rootRefId');
            parentLineNumber = (String) parentObject.get('lineNumber');
            parentServiceAccountId = (String) parentObject.get('serviceAccountId');
        }

        if(objects != null)
        {
            for ( Object  obj : objects )
            {
                Map<String, Object> convertedObj = (Map<String, Object>) obj;

                // saving root-parent hierarchy via asset reference ids
                String assetRefId = (String) convertedObj.get('assetReferenceId');
                //Id rootId = (Id) convertedObj.get('rootRefId');
                if(parentRefId == null) // parent is null hence it is a root object, setting root as asset reference id
                {
                    System.debug('setting  root as ' + assetRefId + ' for child with assetrefid ' + assetRefId);
                    convertedObj.put('rootRefId', assetRefId);
                } else if(rootRefId != null && parentRefId != null) 
                {
                    System.debug('setting parent ' + parentRefId + ' and root ' + rootRefId + ' for child with assetrefid ' + assetRefId);
                    convertedObj.put('parentRefId', parentRefId);
                    convertedObj.put('rootRefId', rootRefId);
                }
                //copy account id from parent
                if(parentServiceAccountId != null && convertedObj.get('serviceAccountId') == null)
                    convertedObj.put('serviceAccountId', parentServiceAccountId);
                // set lineNumber
                calculateLineNumber(convertedObj, parentLineNumber, lineNo);
                converted.add(convertedObj);    
                lineNo++;            
            }
        }            

        return converted;
    }

    private static void calculateLineNumber(Map<String, Object> asset, String parentLinenumber, Integer lineNo)
    {
        String ln = '';

        if(parentLinenumber != null)
        {
            ln = parentLinenumber + '.' + padLeft(lineNo) ;
        }
        else
        {
            ln = padLeft(lineNo);
        }
        System.debug('setting line number to ' + ln);
        asset.put('lineNumber', ln);
    }

    private static String padLeft(Integer i) {
        String str = String.valueOf(i);
        while (str.length() < 4) {
            str = '0' + str;
        }
        return str;
    }

 //Process JSON: [{ "code": "INT-BAND", "value": "10MBPS" }, {"code": "CONTRACT-TERM","value": "6 months"}]
 //TODO: implement
    private static void updateJsonAttribute(Asset asset, String productKey, List<Object>  characteristicValues)
    {
        if(characteristicValues == null || productKey == null){
            return;
        } 
        System.debug('updating jsonAtribute for asset refId ' + asset.get(VLOCITY_CMT_PREFIX + 'AssetReferenceId__c')
         + ' and globalKey ' + productKey);

        //Map<String, XOMAttributeRT> characteristics = new Map<String,XOMAttributeRT> ();
        //XOMAttributeRTLoader.getXOMAttributesWithSpecification(orderItem);

        String jsonAttributeValue;

        if(productKey.equals(PRODUCT_SIMCARD_GKEY))
        { // process Simcard chars
            Map<String, String> codeValueMap = new Map<String, String>();

            for(Object charValueObject: characteristicValues)
            {
                Map<String, Object> charVal = (Map<String, Object>) charValueObject;
                String code = (String) charVal.get('code');
                String value = (String) charVal.get('value');
                if(value != null && !''.equals(value))
                {
                    //process value
                    codeValueMap.put(code, value);
                }
            }
            // generate jsonAttribute
            /*jsonAttributeValue = 
                JSON_ATTR_SIMCARD_1_MSISDN + getRTValue(codeValueMap.get('MSISDN')) + 
                JSON_ATTR_SIMCARD_2_ICCID + getRTValue(codeValueMap.get('FAN_ATT_000071')) + 
                JSON_ATTR_SIMCARD_3_IMSI + getRTValue(codeValueMap.get('FAN_ATT_000072')) +  
                JSON_ATTR_SIMCARD_4_KI + getRTValue(codeValueMap.get('FAN_ATT_000073')) + JSON_ATTR_SIMCARD_5;*/
        } 

        if(jsonAttributeValue != null)
        {
            asset.put(VLOCITY_CMT_PREFIX + 'JSONAttribute__c', jsonAttributeValue); 
            //XOMAttributeRTPersistor.attributesToJSON(characteristics);
        }
            
    }

    public static String getRTValue(String value)
    {
        return value != null? VALUE_PFX + value + VALUE_SFX:'';
    }

    public class XOMAssetCreationException extends Exception
    {
    }

    /*** JSON ATTRIBUTE CONSTANTS ***/

    // Simcard Product Code: FAN_PSIM_REPRO globalKey: 954db6d6-8605-98ea-1fa1-e69236b45120
    // ICCID, KI, MSISDN, IMSI
    public static final string VALUE_HIERARCHY_SEPARETOR = '<';

    public static final String VALUE_PFX = ',"value":"';
    public static final String VALUE_SFX = '"';
    public static final String PRODUCT_SIMCARD_GKEY = '954db6d6-8605-98ea-1fa1-e69236b45120';

    public static final String PRODUCT_PLAN_REPRO_GKEY = 'e0320fa0-fcfd-b757-9350-973604c1e894';
    public static final String PRODUCT_PLAN_REPRO_SIT_GKEY = '77f71b23-89bd-969f-e070-b3fb5502dca5';

    //private static final Map<String, String> codes;
    public static final String JSON_ATTR_SIMCARD_1_MSISDN = '{"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbQ9EAK","attributecategoryid__c":"a1L210000013xIPEAY","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"MSISDN","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"MSISDN","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHd9EAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"';
    //OLD'{"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbQ9EAK","attributecategoryid__c":"a1L210000013xIPEAY","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"MSISDN","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"MSISDN","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHd9EAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text"';
    //+ MSISDNvalue + 
    public static final String JSON_ATTR_SIMCARD_2_ICCID = '"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbQ7EAK","attributecategoryid__c":"a1L210000013xIPEAY","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdAEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"false","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"false"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbQ8EAK","attributecategoryid__c":"a1L210000013xIPEAY","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000041","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tangible","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdBEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbRaEAK","attributecategoryid__c":"a1L210000013xIiEAI","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdCEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"C_OT_MB_EQUIPMENT_SIM","id":30,"displayText":"SIM"}],"values":[{"value":"C_OT_MB_EQUIPMENT_PHONES","id":10,"displayText":"Telefono"},{"value":"C_OT_MB_EQUIPMENT_MODEMS","id":20,"displayText":"Modem"},{"value":"C_OT_MB_EQUIPMENT_SIM","id":30,"displayText":"SIM"},{"value":"C_OT_MB_EQUIPMENT_ACCESORIOS","id":40,"displayText":"Accesorio"},{"value":"C_OT_MB_EQUIPMENT_NETBOOK","id":50,"displayText":"Netbook"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbSeEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000045","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modo de Pago","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdHEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Prepago","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Prepago","id":10,"displayText":"Prepago"}],"values":[{"value":"Hibrido","id":30,"displayText":"Hibrido"},{"value":"Pospago","id":20,"displayText":"Pospago"},{"value":"Prepago","id":10,"displayText":"Prepago"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbSjEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000074","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Fabricacion","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdFEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"N","id":10,"displayText":"Nacional"},{"value":"I","id":20,"displayText":"Internacional"},{"value":"T","id":30,"displayText":"Tierra del Fuego"}],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbScEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000042","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Sistema Origen","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdJEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SAP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"SAP","id":20,"displayText":"SAP"}],"values":[{"value":"Huawei","id":10,"displayText":"Huawei"},{"value":"SAP","id":20,"displayText":"SAP"},{"value":"Infotainment","id":30,"displayText":"Infotainment"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbShEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdIEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbSiEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdGEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbSuEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000139","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Alicuota","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":21,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdDEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"21","valuedatatype__c":"Percent","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Percent","default":"21"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbSvEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000140","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Canal","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdEEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Multi Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Multi Picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbS4EAK","attributecategoryid__c":"a1L210000013xJ4EAI","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdNEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"PTP23FFRI","id":20,"displayText":"Simcard Amarillo 2FF/3FF Bolsita Repro"},{"value":"PTP2FFYRI","id":10,"displayText":"Simcard Amarillo: (2FF Bolsita Repro)"},{"value":"PTPSCCWVI","id":30,"displayText":"Super Chip R Violeta Card Wallet 2ff/3ff"},{"value":"PTPBONIFI","id":50,"displayText":"Usimcard Triple Corte Bonificadas"},{"value":"PTPCDWTCI","id":40,"displayText":"Usimcard Triple Corte Card Wallet"}],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbS5EAK","attributecategoryid__c":"a1L210000013xJ4EAI","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000071","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ICCID","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdKEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":"';
    //OLD'},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbQ7EAK","attributecategoryid__c":"a1L210000013xIPEAY","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdAEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"false","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"false"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbQ8EAK","attributecategoryid__c":"a1L210000013xIPEAY","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000041","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tangible","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdBEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbRaEAK","attributecategoryid__c":"a1L210000013xIiEAI","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdCEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"C_OT_MB_EQUIPMENT_SIM","id":30,"displayText":"SIM"}],"values":[{"value":"C_OT_MB_EQUIPMENT_PHONES","id":10,"displayText":"Telefono"},{"value":"C_OT_MB_EQUIPMENT_MODEMS","id":20,"displayText":"Modem"},{"value":"C_OT_MB_EQUIPMENT_SIM","id":30,"displayText":"SIM"},{"value":"C_OT_MB_EQUIPMENT_ACCESORIOS","id":40,"displayText":"Accesorio"},{"value":"C_OT_MB_EQUIPMENT_NETBOOK","id":50,"displayText":"Netbook"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbSeEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000045","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modo de Pago","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdHEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Prepago","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Prepago","id":10,"displayText":"Prepago"}],"values":[{"value":"Hibrido","id":30,"displayText":"Hibrido"},{"value":"Pospago","id":20,"displayText":"Pospago"},{"value":"Prepago","id":10,"displayText":"Prepago"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbSjEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000074","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Fabricacion","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdFEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"N","id":10,"displayText":"Nacional"},{"value":"I","id":20,"displayText":"Internacional"},{"value":"T","id":30,"displayText":"Tierra del Fuego"}],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbScEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000042","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Sistema Origen","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdJEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SAP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"SAP","id":20,"displayText":"SAP"}],"values":[{"value":"Huawei","id":10,"displayText":"Huawei"},{"value":"SAP","id":20,"displayText":"SAP"},{"value":"Infotainment","id":30,"displayText":"Infotainment"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbShEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdIEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbSiEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdGEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbSuEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000139","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Alicuota","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":21,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdDEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"21","valuedatatype__c":"Percent","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Percent","default":"21"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbSvEAK","attributecategoryid__c":"a1L210000013xJHEAY","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000140","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Canal","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdEEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Multi Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Multi Picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbS4EAK","attributecategoryid__c":"a1L210000013xJ4EAI","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdNEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"PTP23FFRI","id":20,"displayText":"Simcard Amarillo 2FF/3FF Bolsita Repro"},{"value":"PTP2FFYRI","id":10,"displayText":"Simcard Amarillo: (2FF Bolsita Repro)"},{"value":"PTPSCCWVI","id":30,"displayText":"Super Chip R Violeta Card Wallet 2ff/3ff"},{"value":"PTPBONIFI","id":50,"displayText":"Usimcard Triple Corte Bonificadas"},{"value":"PTPCDWTCI","id":40,"displayText":"Usimcard Triple Corte Card Wallet"}],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbS5EAK","attributecategoryid__c":"a1L210000013xJ4EAI","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000071","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ICCID","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdKEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"';
    // + ICCIDvalue + // ,"value": "PTPCDWTCI"
    public static final String JSON_ATTR_SIMCARD_3_IMSI = '"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbS6EAK","attributecategoryid__c":"a1L210000013xJ4EAI","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000072","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMSI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdLEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":"';
    //OLD'},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbS6EAK","attributecategoryid__c":"a1L210000013xJ4EAI","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000072","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMSI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdLEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"';
    // + IMSIDvalue + 
    public static final String JSON_ATTR_SIMCARD_4_KI = '"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbS7EAK","attributecategoryid__c":"a1L210000013xJ4EAI","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000073","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"KI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdMEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":"';
    //OLD'},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t21000001FjbrAAC","attributeid__c":"a1M21000000AbS7EAK","attributecategoryid__c":"a1L210000013xJ4EAI","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000073","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"KI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a1J21000000fHdMEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"';
    //  + KIvalue + 
    public static final String JSON_ATTR_SIMCARD_5 = '"},"$$AttributeDefinitionEnd$$":null}]}';
    //'},"$$AttributeDefinitionEnd$$":null}]}';

    public static final String JSON_ATTR_SIMCARD = 
    JSON_ATTR_SIMCARD_1_MSISDN  +  JSON_ATTR_SIMCARD_2_ICCID + JSON_ATTR_SIMCARD_3_IMSI + JSON_ATTR_SIMCARD_4_KI + JSON_ATTR_SIMCARD_5;
}