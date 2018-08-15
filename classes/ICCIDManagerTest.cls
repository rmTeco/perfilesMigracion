@isTest
public with sharing class ICCIDManagerTest {
    
    @testSetup static void createDataTest(){

        //MockupFactory.generate();
        Account account = TestDataFactory.createAccounts(1,'Consumer').get(0);
        Asset asset = TestDataFactory.createAssets(1,account).get(0);
        Contact contact = TestDataFactory.createContacts(1,account).get(0);
        
        account.vlocity_cmt__PrimaryContactId__c = contact.Id;
        update account;
        
        List<Product2> products = TestDataFactory.createProduct(1);
        
    //  vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Barrio Norte',
    //        vlocity_cmt__OrganizationId__c=Account.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
    //         Channel_Type__c='Oficinas Comerciales', Channel_Type_2__c='Oficinas Comerciales', Channel_Type_3__c='Oficinas Comerciales',
    //         Region__c='AMBA');
    // insert storeLocation;

    //  user usernew = new user(ID = UserInfo.getUserID());
    //  string strIdUser = UserInfo.getUserID();

        TestDataFactory.createWorkTeam('Test');

        // WorkTeam__c workTeamParent = new WorkTeam__c(Team_Name__c = 'Test Parent', Name = 'Test Parent');
        // insert workTeamParent;
        // String manager = UserInfo.getUserId();
        // String parent = workTeamParent.Id;
        // WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test', Name = 'Test');
        // Team_Member__c tm = TestDataFactory.setTeamMember('Call Center', userinfo.getUserId(), null);
    
        Order order = TestDataFactory.createOrders(1,account).get(0);
        
        List<OrderItem> orderItems = TestDataFactory.createOrderItemsWithAsset(1, order, asset);

        orderItems[0].vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000062":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000EBfKUAW","attributecategoryid__c":"a0F6C0000006oxLUAQ","categorycode__c":"FAN_ATTCAT_000062","categoryname__c":"Caracteristicas Tangible","attributeuniquecode__c":"FAN_ATT_000154","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"CIUD","displaysequence__c":"null","categorydisplaysequence__c":170,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000cbtFUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000EBAwUAO","attributecategoryid__c":"a0F6C0000006oxLUAQ","categorycode__c":"FAN_ATTCAT_000062","categoryname__c":"Caracteristicas Tangible","attributeuniquecode__c":"FAN_ATT_000152","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Codigo Orden Despacho","displaysequence__c":"null","categorydisplaysequence__c":170,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000cayFUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000EBAmUAO","attributecategoryid__c":"a0F6C0000006oxLUAQ","categorycode__c":"FAN_ATTCAT_000062","categoryname__c":"Caracteristicas Tangible","attributeuniquecode__c":"FAN_ATT_000150","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Aduana Ingreso","displaysequence__c":"null","categorydisplaysequence__c":170,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000cayGUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000EBArUAO","attributecategoryid__c":"a0F6C0000006oxLUAQ","categorycode__c":"FAN_ATTCAT_000062","categoryname__c":"Caracteristicas Tangible","attributeuniquecode__c":"FAN_ATT_000151","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Pais Origen","displaysequence__c":"null","categorydisplaysequence__c":170,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000cayHUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pvqyUAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000031","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Codigo Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000VeL5UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pvqtUAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000030","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ID Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000VeL4UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pvr8UAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000032","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000VeL6UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPvUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"C_OT_MB_EQUIPMENT_SIM","id":30,"displayText":"SIM"}],"values":[{"value":"C_OT_MB_EQUIPMENT_PHONES","id":10,"displayText":"Telefono"},{"value":"C_OT_MB_EQUIPMENT_MODEMS","id":20,"displayText":"Modem"},{"value":"C_OT_MB_EQUIPMENT_SIM","id":30,"displayText":"SIM"},{"value":"C_OT_MB_EQUIPMENT_ACCESORIOS","id":40,"displayText":"Accesorio"},{"value":"C_OT_MB_EQUIPMENT_NETBOOK","id":50,"displayText":"Netbook"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pvsQUAQ","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000042","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Sistema Origen","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000VeL7UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pvv5UAA","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000045","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modo de Pago","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrhKUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Prepago","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Prepago","id":10,"displayText":"Prepago"}],"values":[{"value":"Prepago","id":10,"displayText":"Prepago"},{"value":"Pospago","id":20,"displayText":"Pospago"},{"value":"Hibrido","id":30,"displayText":"Hibrido"}],"selectedItem":{"value":"Prepago","id":10,"displayText":"Prepago"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwIvUAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000074","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Fabricacion","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPwUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"FAN_PKV_NAC","id":10,"displayText":"Nacional"},{"value":"FAN_PKV_INT","id":20,"displayText":"Internacional"},{"value":"FAN_PKV_TFUE","id":30,"displayText":"Tierra del Fuego"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000EC7qUAG","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000156","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"No Aplica Promocion Financiera","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000cdUtUAI","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPyUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true","value":"true"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Requerido","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Requerido","id":10,"displayText":"Requerido"}],"values":[{"value":"Requerido","id":10,"displayText":"Requerido"},{"value":"Opcional","id":20,"displayText":"Opcional"},{"value":"No Aplica","id":30,"displayText":"No Aplica"}],"selectedItem":{"value":"Requerido","id":10,"displayText":"Requerido"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pyG9UAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000139","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Alicuota","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":21,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000Us7MUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"21","valuedatatype__c":"Percent","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Percent","default":"21","value":21},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pyNgUAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000140","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Canal","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000Us7NUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Multi Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Multi Picklist","uiDisplayType":"Dropdown","values":[],"default":[],"selectedItems":[]},"$$AttributeDefinitionEnd$$":null}],"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pxWDUAY","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"MSISDN","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"MSISDN","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPtUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"false","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"false","value":"false"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pofZUAQ","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000041","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tangible","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPuUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true","value":"true"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqQ3UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"PTP3FFMMI","id":10,"displayText":"Simcard Magenta: (3FF Micro SIM)"},{"value":"PTP2FFCCI","id":20,"displayText":"Simcard Cyan: (2FF Bolsita)"},{"value":"PTP4FFVNI","id":30,"displayText":"Simcard Violeta: (4FF Nano SIM)"},{"value":"PTP23FFCI","id":40,"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes"},{"value":"PTPBOLTCI","id":50,"displayText":"Usimcard Triple Corte Bolsita"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwIgUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000071","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ICCID","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqQ0UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwIlUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000072","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMSI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqQ1UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwIqUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000073","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"KI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqQ2UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null}]}';

        update orderItems;
    }
    
    public static testmethod void serialValidationTest(){
        //MockupFactory.generate(); //testSetup

        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Map<String, Object> orderMap = new Map<String, Object>();        
        List<Object> planesList = new List<Object>();
        Map<String, Object> planMap = new Map<String, Object>();
        List<Object> linesList = new List<Object>();
        Map<String, Object> lineMap = new Map<String, Object>();
        
        lineMap.put('serial', '1234567890');
        lineMap.put('validacionSerial', 'test');
        linesList.add(lineMap);
        planMap.put('lineas', linesList);
        planesList.add(planMap);
        orderMap.put('planes', planesList);
        inputMap.put('Order', orderMap);
        
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialValidation', inputMap, outputMap, null);

        lineMap.put('serial','1324875490');
        im.invokeMethod('SerialValidation', inputMap, outputMap, null);
        
        lineMap.put('serial','123');
        im.invokeMethod('SerialValidation', inputMap, outputMap, null);
        
        lineMap.put('serial','');
        im.invokeMethod('SerialValidation', inputMap, outputMap, null);
        Test.stopTest();
    }

    @isTest
    public static void serialAssignmentTest(){
        String mockResponse = '{"listaNumeroSeries":[{"codNMU":"codNMU","imsi":"imsi","aduanaIngreso":"aduanaIngreso","paisOrigen":"paisOrigen","codOrdenDespacho":"codOrdenDespacho","codDeposito":"codDeposito","stockProducto":"stockProducto","numeroSerie":"serial"},{"codNMU":"codNMU","imsi":"imsi","aduanaIngreso":"aduanaIngreso","paisOrigen":"paisOrigen","codOrdenDespacho":"codOrdenDespacho","codDeposito":"codDeposito","stockProducto":"stockProducto","numeroSerie":"serial2"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S095', mockResponse);

        //MockupFactory.generate(); //testSetup
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        Order ord = [SELECT Id FROM Order LIMIT 1];
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();
    }
    
    @isTest
    public static void serialAssignmentWithStorePickUp(){
        //MockupFactory.generate(); //testSetup
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        Order ord = [SELECT Id, Delivery_Method__c FROM Order LIMIT 1];
        ord.Delivery_Method__c = 'Store Pick Up';
        update ord;
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
        
        Map<String,Object> StockAvailableCode_Response = new Map<String,Object>();
        StockAvailableCode_Response.put('StockAvailableCode','StockAvailableCode');
        
        inputMap.put('StockAvailableCode_Response',StockAvailableCode_Response);
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();
    }
    
    @isTest
    public static void serialAssignmentWithStorePickUpAndStockAvailableCodeNULL(){
        //MockupFactory.generate(); //testSetup
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        Order ord = [SELECT Id, Delivery_Method__c FROM Order LIMIT 1];
        ord.Delivery_Method__c = 'Store Pick Up';
        update ord;
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
        
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();
    }
    
    @isTest
    public static void serialAssignmentWithIsTestListaDeSeriadosTestEmpty(){
        //MockupFactory.generate(); //testSetup
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        Order ord = [SELECT Id, Delivery_Method__c FROM Order LIMIT 1];
        ord.Delivery_Method__c = 'Store Pick Up';
        update ord;
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
        
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
        
        options.put('isTestListaDeSeriadosTestEmpty',true);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();
    }
    
    @isTest
    public static void serialAssignmentWithSimCard()
    {
        //MockupFactory.generate(); //testSetup
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        
        
        Order ord = [SELECT Id, Delivery_Method__c FROM Order LIMIT 1];
        ord.Delivery_Method__c = 'Store Pick Up';
        update ord;
        
        OrderItem orderItem = [SELECT PricebookEntryId, vlocity_cmt__JSONAttribute__c FROM OrderItem LIMIT 1];
        orderItem.vlocity_cmt__JSONAttribute__c = '{"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pxWDUAY","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"MSISDN","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"MSISDN","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSIUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSJUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"false","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pofZUAQ","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000041","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tangible","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSKUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"a1g6C000000ZUQ3QAO","attributeid__c":"a0G6C000000pwIvUAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000074","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Fabricacion","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqDsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Nacional","id":10,"value":"N"},{"displayText":"Internacional","id":20,"value":"I"},{"displayText":"Tierra del Fuego","id":30,"value":"T"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pvsQUAQ","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000042","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Sistema Origen","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSOUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SAP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SAP","id":20,"value":"SAP"}],"values":[{"displayText":"Huawei","id":10,"value":"Huawei"},{"displayText":"SAP","id":20,"value":"SAP"},{"displayText":"Infotainment","id":30,"value":"Infotainment"}],"selectedItem":{"displayText":"SAP","id":20,"value":"SAP"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSNUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSMUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSSUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes","id":40,"value":"PTP23FFCI"},{"displayText":"Simcard Cyan: (2FF Bolsita)","id":20,"value":"PTP2FFCCI"},{"displayText":"Simcard Magenta: (3FF Micro SIM)","id":10,"value":"PTP3FFMMI"},{"displayText":"Simcard Violeta: (4FF Nano SIM)","id":30,"value":"PTP4FFVNI"},{"displayText":"Usimcard Triple Corte Bolsita","id":50,"value":"PTPBOLTCI"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIgUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000071","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ICCID","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSPUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIlUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000072","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMSI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIqUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000073","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"KI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSRUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null}]}';
        update orderItem;
        
        PricebookEntry pricebookEntry = [SELECT Id, Product2Id FROM PricebookEntry WHERE Id = :orderItem.PricebookEntryId];
        Product2 product = [SELECT vlocity_cmt__Type__c FROM Product2 WHERE Id = :pricebookEntry.Product2Id LIMIT 1];
        product.vlocity_cmt__Type__c = 'Simcard';
        update product;
        
        
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
        
        
        
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
        
        options.put('isTestListaDeSeriadosTestEmpty',true);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();        
    }
    
    @isTest
    public static void serialAssignmentWithSimCardAndSerial()
    {
        //MockupFactory.generate(); //testSetup
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        
        
        Order ord = [SELECT Id, Delivery_Method__c FROM Order LIMIT 1];
        ord.Delivery_Method__c = 'Store Pick Up';
        update ord;
        
        OrderItem orderItem = [SELECT PricebookEntryId, vlocity_cmt__JSONAttribute__c FROM OrderItem LIMIT 1];
        orderItem.vlocity_cmt__JSONAttribute__c = '{"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pxWDUAY","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"MSISDN","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"MSISDN","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSIUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSJUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"false","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pofZUAQ","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000041","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tangible","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSKUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"a1g6C000000ZUQ3QAO","attributeid__c":"a0G6C000000pwIvUAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000074","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Fabricacion","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqDsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Nacional","id":10,"value":"N"},{"displayText":"Internacional","id":20,"value":"I"},{"displayText":"Tierra del Fuego","id":30,"value":"T"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pvsQUAQ","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000042","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Sistema Origen","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSOUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SAP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SAP","id":20,"value":"SAP"}],"values":[{"displayText":"Huawei","id":10,"value":"Huawei"},{"displayText":"SAP","id":20,"value":"SAP"},{"displayText":"Infotainment","id":30,"value":"Infotainment"}],"selectedItem":{"displayText":"SAP","id":20,"value":"SAP"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSNUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSMUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSSUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes","id":40,"value":"PTP23FFCI"},{"displayText":"Simcard Cyan: (2FF Bolsita)","id":20,"value":"PTP2FFCCI"},{"displayText":"Simcard Magenta: (3FF Micro SIM)","id":10,"value":"PTP3FFMMI"},{"displayText":"Simcard Violeta: (4FF Nano SIM)","id":30,"value":"PTP4FFVNI"},{"displayText":"Usimcard Triple Corte Bolsita","id":50,"value":"PTPBOLTCI"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIgUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000071","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ICCID","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSPUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIlUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000072","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMSI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIqUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000073","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"KI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSRUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null}]}';
        update orderItem;
        
        PricebookEntry pricebookEntry = [SELECT Id, Product2Id FROM PricebookEntry WHERE Id = :orderItem.PricebookEntryId];
        Product2 product = [SELECT vlocity_cmt__Type__c, Name FROM Product2 WHERE Id = :pricebookEntry.Product2Id LIMIT 1];
        product.vlocity_cmt__Type__c = 'Simcard';
        product.Name = 'IsGetSimcardsSerialTest';
        update product;
        
        
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
        
        
        
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
        
        options.put('isTestListaDeSeriadosTestEmpty',true);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();        
    }
    
    @isTest
    public static void SerialReAssingmentTest()
    {
        //String mockResponse = '{"listaNumeroSeries":[{"codNMU":"codNMU","imsi":"imsi","aduanaIngreso":"aduanaIngreso","paisOrigen":"paisOrigen","codOrdenDespacho":"codOrdenDespacho","codDeposito":"codDeposito","stockProducto":"stockProducto","numeroSerie":"serial"},{"codNMU":"codNMU","imsi":"imsi","aduanaIngreso":"aduanaIngreso","paisOrigen":"paisOrigen","codOrdenDespacho":"codOrdenDespacho","codDeposito":"codDeposito","stockProducto":"stockProducto","numeroSerie":"serial2"}]}';

         String mockResponse = '{"listaNumeroSerie":[{"codNMU":"codNMU","imsi":"imsi","aduanaIngreso":"aduanaIngreso","paisOrigen":"paisOrigen","codOrdenDespacho":"codOrdenDespacho","codDeposito":"codDeposito","stockProducto":"stockProducto","numeroSerie":"serial"}]}';
        
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S095', mockResponse);
        
        //GIVEN
        String nameMethod = 'SerialReAssingment';
        
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        
        List<Object> serialList = new List<Object>();
        Map<String,Object> orderMap = new Map<String,Object>();
        
        Map<String,Object> item1 = new Map<String,Object>();
        item1.put('validacionSerial','');
        item1.put('itemId','001xa000004DIlo');
        item1.put('serial','serial');
        item1.put('serialValidado','serialValidado');
        item1.put('productName','productName');
        item1.put('productCode','productCode');
        item1.put('stockProducto','stockProducto');
        
        serialList.add(item1);
        orderMap.put('serialList',serialList);
        
        Order order = [SELECT Id FROM Order LIMIT 1];
        
        options.put('Order',orderMap);
        options.put('IdOrder',order.Id);
        
        Map<String,Object> billingOrder = new Map<String,Object>();
        billingOrder.put('Delivery_Method','Delivery');
        billingOrder.put('Channel','Agentes');
        
        inputMap.put('BillingOrder',billingOrder);
        
        ICCIDManager im = new ICCIDManager();
        
        //WHEN
        Test.startTest();
        im.invokeMethod(nameMethod, inputMap, outputMap, options);
        Test.stopTest();
        
        //THEN
    }
    
    @isTest
    public static void UpdateSalesInvoiceTest()
    {
        //GIVEN
        String nameMethod = 'UpdateSalesInvoice';
        
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        
        Id IdOrder = [SELECT Id FROM Order LIMIT 1].get(0).Id;
        
        options.put('IdOrder',IdOrder);
                
        ICCIDManager im = new ICCIDManager();
        
        //WHEN
        Test.startTest();
        im.invokeMethod(nameMethod, inputMap, outputMap, options);
        Test.stopTest();
        
        //THEN
    }
    
    @isTest
    public static void setValuesOnJSON2Test()
    {
        //GIVEN
        String jsonString = '{"list":[{"attributedisplayname__c":"ICCID","attributeRunTimeInfo":{"value":"ICCID"}}]}';
        String iccid = 'iccid';
                
        ICCIDManager im = new ICCIDManager();
        
        //WHEN
        Test.startTest();
        im.setValuesOnJSON2(jsonString, iccid);
        Test.stopTest();
        
        //THEN
    }
    
    @isTest
    public static void GetStockDefSizeOneTest()
    {
        //GIVEN
        List<String> stocksCode = new String[1];
        String nmuCart = '';
        List<Object> existences = new List<Object>();
                        
        //WHEN
        Test.startTest();
        ICCIDManager.GetStockDef(stocksCode, nmuCart, existences);
        Test.stopTest();
        
        //THEN
    }
    
    @isTest
    public static void GetStockDefSizeMoreOneTest()
    {
        //GIVEN
        List<String> stocksCode = new List<String>();
        String nmuCart = '1';
        List<Object> existences = new List<Object>();
        
        stocksCode.add('stockProducto');
        stocksCode.add('stockProducto');
        
        Map<String,Object> existence = new Map<String,Object>();
        List<Object> ListaPorCodigoStock = new List<Object>();
        Map<String,Object> stock = new Map<String,Object>();
        stock.put('stockProducto','stockProducto');
        stock.put('CantidadDisponible',1);
        ListaPorCodigoStock.add(stock);
        existence.put('ListaPorCodigoStock',ListaPorCodigoStock);
        existence.put('codNMU','1');
        existences.add(existence);
        
        //WHEN
        Test.startTest();
        ICCIDManager.GetStockDef(stocksCode, nmuCart, existences);
        Test.stopTest();
        
        //THEN
    }

    @isTest
    public static void CreateWrapOrderItem(){
        ICCIDManager.WrapOrderItem orderItem = new ICCIDManager.WrapOrderItem('newICCID', 'newIMSI', 'newKI', 'newAduanaIngreso', 'newPaisOrigen', 'newCodOrdenDespacho', 'newStock', true);
    }
}