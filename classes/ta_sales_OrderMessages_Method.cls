global with sharing class ta_sales_OrderMessages_Method implements vlocity_cmt.VlocityOpenInterface {

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        if (methodName.equals('CheckFriendsNumber')) {
            CheckFriendsNumber(input, outMap, options);
        }

        if (methodName.equals('SaveNumbers')) {
            SaveNumbers(input, outMap, options);
        }

        if (methodName.equals('CheckFriendsNumberFromAsset')) {
            CheckFriendsNumberFromAsset(input, outMap, options);
        }

        if (methodName.equals('SaveNumbersFromAsset')) {
            SaveNumbersFromAsset(input, outMap, options);
        }

        if (methodName.equals('TransformFFIF454')) {
            TransformFFIF454(input, outMap, options);
        }

        if (methodName.equals('CallIF454')) {
            CallIF454(input, outMap, options);
        }

        if (methodName.equals('sendSMSFFChanged')) {
            sendSMSFFChanged(input, outMap, options);
        }

        return true;
    }

    private String setValuesOnJSON(String jsonString, String friendNumber, String friendNumberType) {
        Map<String, Object> jsonAttributeMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        for (String jsonAttributeKey : jsonAttributeMap.keySet()) {
            List<Object> jsonMapValuesList = (List<Object>) jsonAttributeMap.get(jsonAttributeKey);

            for (Object o : jsonMapValuesList) {
                Map<String, Object> stringObjectMap = (Map<String, Object>) o;
                String attribute = (String) stringObjectMap.get('attributedisplayname__c');

                if (attribute == 'Numero Amigo') {
                    Map<String, Object> valueMap = (Map<String, Object>) stringObjectMap.get('attributeRunTimeInfo');
                    String value = (String) valueMap.get('value');
                    valueMap.put('value', friendNumber);
                }
                else if (attribute == 'Tipo Numero Amigo') {
                    Map<String, Object> valueMap = (Map<String, Object>) stringObjectMap.get('attributeRunTimeInfo');
                    Map<String, Object> selectedItemMap = (Map<String, Object>) valueMap.get('selectedItem');
                    selectedItemMap.put('value', friendNumberType);
                    //Get the custom setting where the values are stored
                    FF_Json_values__c ffCustomSetting = FF_Json_values__c.getInstance();
                    
                    if (friendNumberType == 'FIJO') {
                        selectedItemMap.put('id', ffCustomSetting.Tipo_Numero_Amigo_Linea_Id__c);
                        selectedItemMap.put('displayText', ffCustomSetting.Tipo_Numero_Amigo_Linea_Texto__c);
                    }
                    else if (friendNumberType == 'MOVIL') {
                        selectedItemMap.put('id', ffCustomSetting.Tipo_Numero_Amigo_Mobil_Id__c);
                        selectedItemMap.put('displayText', ffCustomSetting.Tipo_Numero_Amigo_Mobil_Texto__c);
                    }
                }
            }
        }
        return JSON.serialize(jsonAttributeMap);
    }

    public void CheckFriendsNumber(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            System.debug('CheckFriendsNumber');
            String FRIENDSNUMBER_NUMBER_PRODUCTCODE_VOZ = 'FAN_PV_FNF_00001';
            String FRIENDSNUMBER_NUMBER_PRODUCTCODE_SMS = 'FAN_PV_FNF_00002';
            String FRIENDSNUMBER_VOICE_PRODUCTCODE = 'FAN_PV_GFNF_VOZ';
            String FRIENDSNUMBER_SMS_PRODUCTCODE = 'FAN_PV_GFNF_SMS';
            String SIMCARD_PRODUCTCODE = 'FAN_PSIM_STANDARD';
            Boolean showStep = false;
            List<Map<String, Object>> plansListMap = new List<Map<String, Object>>();
            String idOrder = (String) options.get('IdOrder');
            //Get the all friend number related products
            String idFriendNumberProductVoz;
            String idFriendNumberProductSms;
            String idFriendNumbersGroupVoiceProduct;
            String idFriendNumbersGroupSMSProduct;
            String idSimcardProduct;
            //Get the order managament
            Order order = [SELECT Id, Gestion__c FROM Order WHERE Id =:idOrder];
            if(order.Gestion__c=='Venta'){
            List<Product2> friendNumberProductsList = [SELECT Id, ProductCode FROM Product2 WHERE ProductCode = :FRIENDSNUMBER_NUMBER_PRODUCTCODE_VOZ OR ProductCode = :FRIENDSNUMBER_NUMBER_PRODUCTCODE_SMS OR ProductCode = :FRIENDSNUMBER_VOICE_PRODUCTCODE OR ProductCode = :FRIENDSNUMBER_SMS_PRODUCTCODE OR ProductCode = :SIMCARD_PRODUCTCODE];

            for (Product2 friendNumberProduct : friendNumberProductsList) {
                if (friendNumberProduct.ProductCode == FRIENDSNUMBER_NUMBER_PRODUCTCODE_VOZ)
                    idFriendNumberProductVoz = String.valueOf(friendNumberProduct.Id);
                else if (friendNumberProduct.ProductCode == FRIENDSNUMBER_NUMBER_PRODUCTCODE_SMS)
                    idFriendNumberProductSms = String.valueOf(friendNumberProduct.Id);
                else if (friendNumberProduct.ProductCode == FRIENDSNUMBER_VOICE_PRODUCTCODE)
                    idFriendNumbersGroupVoiceProduct = String.valueOf(friendNumberProduct.Id);
                else if (friendNumberProduct.ProductCode == FRIENDSNUMBER_SMS_PRODUCTCODE)
                    idFriendNumbersGroupSMSProduct = String.valueOf(friendNumberProduct.Id);
                else if (friendNumberProduct.ProductCode == SIMCARD_PRODUCTCODE)
                    idSimcardProduct = String.valueOf(friendNumberProduct.Id);
            }

            //obtener Numero Amigo
            List<OrderItem> orderProducts = [
                    SELECT Id, ProductName__c, vlocity_cmt__ParentItemId__c
                    FROM OrderItem
                    WHERE (vlocity_cmt__Product2Id__c =: idFriendNumberProductVoz OR vlocity_cmt__Product2Id__c =: idFriendNumberProductSms)
                        AND OrderId =: idOrder];

            if (!orderProducts.isEmpty()) {
                showStep = true;
                Map<String, Id> mapParentGroupWithProductId = new Map<String, Id>();

                for (OrderItem aOrderProduct : orderProducts) {
                    String parentProductId = aOrderProduct.vlocity_cmt__ParentItemId__c;
                    mapParentGroupWithProductId.put(parentProductId, aOrderProduct.Id);
                }
                
                //obtener parents - Grupo Numeros Amigos de SMS - Grupo Numeros Amigos de Voz
                List<OrderItem> parentGroupProducts = [
                        SELECT Id, ProductName__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ParentItemId__c
                        FROM OrderItem
                        WHERE Id IN :mapParentGroupWithProductId.keySet()];

                Map<String, Id> mapParentFreeNumberWithProductId = new Map<String, Id>();

                for (OrderItem aOrderProduct : parentGroupProducts) {
                    String parentProductId = aOrderProduct.vlocity_cmt__ParentItemId__c;
                    mapParentFreeNumberWithProductId.put(parentProductId, aOrderProduct.Id);
                }

                //obtener parents - Numeros gratis
                List<OrderItem> parentFreeNumberProducts = [
                        SELECT Id, ProductName__c, vlocity_cmt__ParentItemId__c
                        FROM OrderItem
                        WHERE Id IN :mapParentFreeNumberWithProductId.keySet()];

                Map<String, Id> mapParentPlanWithProductId = new Map<String, Id>();
                Set<Id> plansIds = new Set<Id>();
                for (OrderItem aOrderProduct : parentFreeNumberProducts) {
                    String parentProductId = aOrderProduct.vlocity_cmt__ParentItemId__c;
                    mapParentPlanWithProductId.put(parentProductId, aOrderProduct.Id);
                }

                //obtener parents - Plan con tarjeta
                List<OrderItem> parentPlanProducts = [
                        SELECT Id, ProductName__c, vlocity_cmt__JSONAttribute__c
                        FROM OrderItem
                        WHERE Id IN :mapParentPlanWithProductId.keySet()];

                //obtener simcars - Plan con tarjeta
                /*
                List<OrderItem> simcardProducts = [
                        SELECT Id, ProductName__c, vlocity_cmt__JSONAttribute__c, vlocity_cmt__ParentItemId__c
                        FROM OrderItem
                        WHERE vlocity_cmt__Product2Id__c = :idSimcardProduct AND vlocity_cmt__ParentItemId__c IN :mapParentPlanWithProductId.keySet()];
                    */

                for (OrderItem planItem : parentPlanProducts) {
                    String lineNumber;
                    Map<String, Object> planMap = new Map<String, Object>();
                    planMap.put('Description', planItem.ProductName__c);
                    
                    //PFTA-9096 Se cambió el get del JSONAttribute de MSISDN a Numero de Linea
                    //Cuando el proceso de ventas guarde el numero de linea en el campo MSISDN se podrá volver a como estaba.
                    
                    //Map<String,Object> jsonAttribute = AssetAttributesUtils.GetJSONAttribute(planItem.vlocity_cmt__JSONAttribute__c, 'MSISDN');
                    Map<String,Object> jsonAttribute = AssetAttributesUtils.GetJSONAttribute(planItem.vlocity_cmt__JSONAttribute__c, 'Numero de linea');
                    
                    lineNumber = (String)((Map<String, Object>)jsonAttribute.get('attributeRunTimeInfo')).get('value');
                    /*
                    for (OrderItem simProduct : simcardProducts){
                        if (simProduct.vlocity_cmt__ParentItemId__c == planItem.Id)
                        {
                            Map<String,Object> jsonAttribute = AssetAttributesUtils.GetJSONAttribute(simProduct.vlocity_cmt__JSONAttribute__c, 'MSISDN');
                            lineNumber = (String)((Map<String, Object>)jsonAttribute.get('attributeRunTimeInfo')).get('value');
                        }
                    }
                    */
                    planMap.put('linea', lineNumber);
                    
                    List<Map<String, Object>> friendsVoiceListMap = new List<Map<String, Object>>();
                    List<Map<String, Object>> friendsSMSListMap = new List<Map<String, Object>>();
                    
                    planMap.put('numerosAmigoVoz', friendsVoiceListMap);
                    
                    planMap.put('numerosAmigoSms',friendsSMSListMap);
                    
                    plansListMap.add(planMap);
                    for (OrderItem freeNumberItem : parentFreeNumberProducts) {
                        if (freeNumberItem.vlocity_cmt__ParentItemId__c == planItem.Id) {
                            for (OrderItem parentGroupItem : parentGroupProducts) {
                                if (parentGroupItem.vlocity_cmt__ParentItemId__c == freeNumberItem.Id) {
                                    for (OrderItem oProduct : orderProducts) {
                                        if (oProduct.vlocity_cmt__ParentItemId__c == parentGroupItem.Id) {
                                            Map<String, Object> friendNumberMap = new Map<String, Object>();
                                            friendNumberMap.put('id',oProduct.Id);
                                            friendNumberMap.put('lineNumber','');
                                            friendNumberMap.put('validated',false);
                                            if (parentGroupItem.vlocity_cmt__Product2Id__c == idFriendNumbersGroupVoiceProduct)
                                                friendsVoiceListMap.add(friendNumberMap);
                                            else if (parentGroupItem.vlocity_cmt__Product2Id__c == idFriendNumbersGroupSMSProduct)
                                                friendsSMSListMap.add(friendNumberMap);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
           
             
            }else
            {
                showStep = false;
            }
            System.debug('ShowFriendsNumberStep' + showStep);
            outMap.put('ShowFriendsNumberStep', showStep);
            outMap.put('numerosAmigosXPlan', plansListMap);
        }
        catch (Exception e) {

        }
    }

    public void CheckFriendsNumberFromAsset(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try {
            String lineNumberToCheck = (String) options.get('lineNumber');
            String jsonRequest = '{"choiceId" : {"nroLinea":"' + lineNumberToCheck + '"}}';
            IFS_S453_queryFriendsAndFamily_cls.ResultObj jsonResponse = IFS_S453_queryFriendsAndFamily_cls.queryFriendsAndFamily(jsonRequest);
            if (jsonResponse.resultCode == 200 || Test.isRunningTest()) {
                Map<String, Object> resultMap = new Map<String, Object>();
                if (!Test.isRunningTest()) {
                    resultMap = (Map<String, Object>) JSON.deserializeuntyped(jsonResponse.resultMessage.toString());
                }
                else {
                    String jsonResultAux = (String) options.get('jsonResult');
                    resultMap = (Map<String, Object>) JSON.deserializeuntyped(jsonResultAux);
                }
                List<Map<String, Object>> friendsVoiceListMap = new List<Map<String, Object>>();
                List<Map<String, Object>> friendsSMSListMap = new List<Map<String, Object>>();
                List<Object> services = (List<Object>) resultMap.get('lstOfertas');
                for (Object service : services) {
                    Map<String, Object> serviceMap = (Map<String, Object>) service;
                    String serviceType = (String) serviceMap.get('tipoServicio');
                    String ofertaId = (String) serviceMap.get('ofertaId');
                    Integer linesCount = 0;
                    Integer linesMax = Integer.valueOf(serviceMap.get('cantMaxLineasTotal'));
                    List<Object> listLines = (List<Object>) serviceMap.get('lstLineas');
                    if (serviceType == 'SMS') {
                        for (Object friendLine : listLines) {
                            Map<String, Object> friendLineMap = (Map<String, Object>) friendLine;
                            AddLineNode(friendsSMSListMap, (String)friendLineMap.get('nroLinea'), 'oProduct.Id', true, ofertaId, (String)friendLineMap.get('assetId'));
                            linesCount++;
                        }
                        while (linesCount < linesMax) {
                            AddLineNode(friendsSMSListMap, '', 'oProduct.Id', false, ofertaId, null);
                            linesCount++;
                        }
                    }
                    else if (serviceType == 'VOZ') {
                        for (Object friendLine : listLines) {
                            Map<String, Object> friendLineMap = (Map<String, Object>) friendLine;
                            AddLineNode(friendsVoiceListMap, (String)friendLineMap.get('nroLinea'), 'oProduct.Id', true, ofertaId, (String)friendLineMap.get('assetId'));
                            linesCount++;
                        }
                        while (linesCount < linesMax) {
                            AddLineNode(friendsVoiceListMap, '', 'oProduct.Id', false, ofertaId, null);
                            linesCount++;
                        }
                    }
                }

                Map<String, Object> planMap = new Map<String, Object>();
                planMap.put('numerosAmigoVoz', friendsVoiceListMap);
                planMap.put('numerosAmigoSms',friendsSMSListMap);
                planMap.put('linea',lineNumberToCheck);
                List<Map<String, Object>> plansListMap = new List<Map<String, Object>>();
                plansListMap.add(planMap);
                outMap.put('numerosAmigosXPlan', plansListMap);
                outMap.put('numerosAmigosXPlanBK', plansListMap);
                outMap.put('services', services);
            }
            else {
                throw new FuncException(jsonResponse.resultMessage.toString());
            }
        }
        catch(Exception e) {
            System.debug('CheckFriendsNumberFromAsset Msg: ' + e.getMessage());
            System.debug('CheckFriendsNumberFromAsset Cause: ' + e.getCause());
            System.debug('CheckFriendsNumberFromAsset Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    public void SaveNumbersFromAsset(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            Id orderId = (Id) options.get('orderId');

            List<Object> friendsNumberPlansToAdd = (List<Object>) options.get('numerosAmigosXPlan');
            
            Map<String, Object> friendsNumberPlan = (Map<String, Object>) friendsNumberPlansToAdd.get(0);
            List<Object> friendsNumberVoice = (List<Object>) friendsNumberPlan.get('numerosAmigoVoz');
            List<Object> friendsNumberSMS = (List<Object>) friendsNumberPlan.get('numerosAmigoSms');

            List<Map<String, Object>> itemsToAdd = new List<Map<String, Object>>();
            List<String> itemsToDelete = new List<String>();

            GetFreeNumbersToUpdate(itemsToAdd, itemsToDelete, friendsNumberVoice, orderId);
            GetFreeNumbersToUpdate(itemsToAdd, itemsToDelete, friendsNumberSMS, orderId);

            if (itemsToDelete.size() > 0 || itemsToAdd.size() > 0) {
                DeleteFriendsNumber(orderId, itemsToDelete);
                AddFriendsNumber(orderId, itemsToAdd);
                //Update de la orden con mismo algoritmo de save Numbers
                //List<Object> friendsNumberPlansToAddToUpdate = new List<Object>();
                //friendsNumberPlansToAddToUpdate.add(mergeFriendsNumberPlan);
                //SaveNumbers(friendsNumberPlansToAddToUpdate);
                //Creacion del cargo si es necesarios
                submitOrder(orderId);//Submitir la orden
            }
        }
        catch (Exception e) {
            System.debug(e);
        }
    }

    public void TransformFFIF454(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        /*
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @description Transform Json to match IF454 input format
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @author   Damian Avrij
        * @date     2018-04-03
        * @param    numerosAmigosXPlan json node
        * @return   IF454inMap: IF454 input json
        */
        Map<String, Object> input154;
        Map<String, Object> choiceId;
        Map<String, Object> nroLinea;
        Map<String, Object> planMap;
        String auxStr;
        String auxStr2, auxStrNew, auxStrOrig;
        String ofertaId;

        List<Object> listaAlta;
        //Map<String, Object> mapAlta;
        Map<String, Object> mapOut;
        Map<String, Object> auxMap;
        Map<String, Object> auxMap2;
        Map<String, Object> auxMapIn;
        Map<String, Object> lNumeroMap;

        List<Object> listOfer;
        List<Object> friendsNumberVoice;
        List<Object> friendsNumberSMS;
        Map<String, Object> friendsNumberPlan;
        Integer cantBajas = 0;
        try {
            input154 = new Map<String, Object>();
            choiceId = new Map<String, Object>();
            nroLinea = new Map<String, Object>();
            auxMapIn = new Map<String, Object>();

            Id orderId = (Id) options.get('orderId');

            Boolean bModified;
            List<Object> friendsNumberPlansToAdd = (List<Object>) input.get('numerosAmigosXPlan');
            planMap = (Map<String, Object>) friendsNumberPlansToAdd.get(0);
            auxStr = (String) planMap.get('linea');
            nroLinea.put('nroLinea', auxStr);
            
            friendsNumberPlan = (Map<String, Object>) friendsNumberPlansToAdd.get(0);
            friendsNumberVoice = (List<Object>) friendsNumberPlan.get('numerosAmigoVoz');
            friendsNumberSMS = (List<Object>) friendsNumberPlan.get('numerosAmigoSms');

            friendsNumberVoice.addAll(friendsNumberSMS);

            listOfer = new List<Object>();

            for (Object lNumero: friendsNumberVoice) {
                lNumeroMap = (Map<String, Object>) lNumero;
                bModified = (Boolean) lNumeroMap.get('modified');
                if (bModified) {
                    ofertaId = (String) lNumeroMap.get('ofertaId');
                    auxMap = new Map<String, Object>();
                    auxMap.put('tipoLinea', 'Onnet');
                    auxStrOrig = (String) lNumeroMap.get('originalLine');
                    auxStrNew = (String) lNumeroMap.get('lineNumber');
                    auxMap.put('nroLinea', auxStrOrig);
                    auxStr = (String) lNumeroMap.get('assetId');
                    auxMap.put('assetId', auxStr);
                    
                    if (auxStrOrig != '' && auxStrOrig != auxStrNew) {
                        //Si hay numeros para dar de baja los agrego al json
                        cantBajas++;
                        insertListOfer(listOfer, ofertaId, 'B', auxMap);
                    }

                    auxMap2 = auxMap.clone();
                    auxMap2.put('nroLinea', auxStrNew);

                    if (auxStrNew != '' && auxStrOrig != auxStrNew) {
                        //Si hay numeros para dar de alta  los agrego al json
                        insertListOfer(listOfer, ofertaId, 'A', auxMap2);
                    }
                }
            }
            
            mapOut = new Map<String, Object>();
            mapOut.put('lstOfertas', listOfer);
            mapOut.put('choiceId', nrolinea);
            
            outMap.put('IF454inMap', mapOut);

            //Calculo el costo de las bajas
            PriceBookEntry priceBook = [SELECT UnitPrice FROM PricebookEntry WHERE ProductCode = 'FAN_PSERV_00007' AND IsActive = true LIMIT 1];

            Double costoBajas = priceBook.UnitPrice * cantBajas;
            outMap.put('CantBajas', cantBajas);
            outMap.put('CostoBajas', costoBajas);
        }
        catch (Exception e) {
            System.debug('TransformFFIF454 Msg: ' + e.getMessage());
            System.debug('TransformFFIF454 Cause: ' + e.getCause());
            System.debug('TransformFFIF454 Stack Trace: ' + e.getStackTraceString());
        }
    }

    public void sendSMSFFChanged(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        /*
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @description Send SMS notification to the line number who has made the Order
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @author   Damian Avrij
        * @date     2018-04-03
        * @param    lineNumber
        * @return   Nothing
        */
        try {
            String lineNumber = (String) input.get('lineNumber');

            //Boolean SMSsendStatus = taSalesSMSInteraction.sendSMSTemplate(nroLinea, 'Recarga Exitosa', variables);
            Boolean SMSsendStatus = taSalesSMSInteraction.sendSMSTemplate(lineNumber, 'Cambio Numeros Amigos Ok', new Map<String, String>());
            outMap.put('SMSsendStatus', SMSsendStatus);
            /*
            if (!SMSsendStatus)
                objOrder.TrackingStatusDetail__c = 'Error en envio SMS de confirmacion recarga al cliente';
            */
        }
        catch (Exception e) {
            System.debug('sendSMSFFChanged Msg: ' + e.getMessage());
            System.debug('sendSMSFFChanged Cause: ' + e.getCause());
            System.debug('sendSMSFFChanged Stack Trace: ' + e.getStackTraceString());
        }
    }

    public void CallIF454(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        /*
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @description Call IF454 Change Friend and Family
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @author   Damian Avrij
        * @date     2018-04-05
        * @param    IF454inMap
        * @return   result
        */
        Map<String, Object> requestIF454;
        try {
            requestIF454 = (Map<String, Object>) input.get('IF454inMap');
            String jsonRequest = JSON.serialize(requestIF454);

            IFS_S454_changeFriendsAndFamily_cls if454 = new IFS_S454_changeFriendsAndFamily_cls();
            IFS_S454_changeFriendsAndFamily_cls.ResultObj jsonResponse = if454.changeFriendsAndFamily(jsonRequest);

            //IFS_S454_changeFriendsAndFamily_cls.ResultObj jsonResponse = IFS_S454_changeFriendsAndFamily_cls.changeFriendsAndFamily(jsonRequest);

            outMap.put('response_IF454',jsonResponse);
            outMap.put('IF454_code',jsonResponse.resultCode);
            //outMap.put('IF454_Msg',jsonResponse.resultMessage);

            if (jsonResponse.resultCode != 200) {
                List<Object> responseList= (List<Object>) JSON.deserializeUntyped(jsonResponse.resultMessage);
                Map<String, Object> responseMap = (Map<String, Object>) responseList[0];
                outMap.put('IF454_Msg',responseMap.get('message'));
            }
        }
        catch (Exception e) {
            System.debug('CallIF454 Msg: ' + e.getMessage());
            System.debug('CallIF454 Cause: ' + e.getCause());
            System.debug('CallIF454 Stack Trace: ' + e.getStackTraceString());
        }
    }

    private void insertListOfer(List<Object> listOfer, String oferId, String operacion, Map<String, Object> mapa) {
        List<Object> lstLineas;
        Map<String, Object> auxMap;
        Map<String, Object> auxMap2;
        Map<String, Object> mapOferta;
        List<Object> listOferAux;
        
        Boolean encontre = false;
        String ofertaId;
        String accion;
        try {
            if (listOfer.isEmpty()) {
                auxMap = new Map<String, Object>();
                lstLineas = new List<Object>();
                lstLineas.add(mapa);
                auxMap.put('lstLineas',lstLineas);
                auxMap.put('ofertaId', oferId);
                auxMap.put('codOperacion', operacion);
                listOfer.add(auxMap);    
            }
            else {
                listOferAux = new List<Object>(listOfer);
                for (Object lstOferta: listOferAux) {
                    mapOferta = (Map<String, Object>) lstOferta;
                    ofertaId = (String) mapOferta.get('ofertaId');
                    accion = (String) mapOferta.get('codOperacion');

                    if (ofertaId == oferId && accion == operacion) {
                        encontre = true;
                        lstLineas = (List<Object>) mapOferta.get('lstLineas');

                        if (lstLineas == null) {
                            lstLineas = new List<Object>();
                            lstLineas.add(mapa);
                            auxMap2 = new Map<String, Object>();
                            auxMap2.put('lstLineas', lstLineas);
                            listOfer.add(auxMap2);
                        }
                        lstLineas.add(mapa);
                    }
                }

                if(!encontre) {
                    auxMap = new Map<String, Object>();
                    lstLineas = new List<Object>();
                    lstLineas.add(mapa);
                    auxMap.put('lstLineas',lstLineas);
                    auxMap.put('ofertaId', oferId);
                    auxMap.put('codOperacion', operacion);

                    listOfer.add(auxMap); 
                }
            }
        }
        catch(Exception e) {
            System.debug('insertListOfer Msg: ' + e.getMessage());
            System.debug('insertListOfer Cause: ' + e.getCause());
            System.debug('insertListOfer Stack Trace: ' + e.getStackTraceString());
        }
    }

    private void submitOrder (String pOrderId) {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> result = new Map<String, Object>();
        try {
            inputMap.put('methodName', 'checkout');
            inputMap.put('cartId', pOrderId);
            inputMap.put('ContextId', pOrderId);
            vlocity_cmt.CpqAppHandler appHandler = new vlocity_cmt.CpqAppHandler();
            appHandler.invokeMethod('checkout', inputMap, outMap, null);
        }
        catch (Exception e) {
            throw new FuncException('Error al submitir la orden: ' + pOrderId + ' - Error: ' + e.getMessage());
        }
    }

    public void GetFreeNumbersToUpdate(List<Map<String, Object>> itemsToAdd, List<String> itemsToDelete, List<Object> friendsNumberList, String orderId) {
        try {
            for (Object friendsNumberObj : friendsNumberList) {
                Map<String,Object> friendsNumberMap = (Map<String,Object>) friendsNumberObj;
                Boolean modified = (Boolean) friendsNumberMap.get('modified');
                String originalLine = (String) friendsNumberMap.get('originalLine');

                if (modified != null && modified == true) {
                    String lineNumber = (String) friendsNumberMap.get('lineNumber');

                    if (String.isNotBlank(lineNumber)) {
                        Map<String, Object> addNode = new Map<String, Object>();
                        addNode.put('assetId',(String) friendsNumberMap.get('assetId'));
                        addNode.put('ofertaId',(String) friendsNumberMap.get('ofertaId'));
                        itemsToAdd.add(addNode);
                    }

                    if (String.isNotBlank(originalLine)) {
                        String assetId = (String) friendsNumberMap.get('ofertaId');
                        Asset asset = [SELECT Product2.ProductCode FROM Asset WHERE Id = :assetId];
                        List<OrderItem> orderItems = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE OrderId = :orderId AND ProductCode__c = :asset.Product2.ProductCode];
                        Integer itemscount = 0;
                        Boolean itemFound = false;

                        while (itemscount < orderItems.size() && !itemFound) {
                            OrderItem item = orderItems.get(itemsCount);
                            Map<String,Object> jsonAttribute = AssetAttributesUtils.GetJSONAttribute(item.vlocity_cmt__JSONAttribute__c, 'Numero Amigo');
                            String numeroAmigo;
                            if (jsonAttribute != null && jsonAttribute.get('value__c') != null) {
                                numeroAmigo = String.valueOf(jsonAttribute.get('value__c'));
                            }

                            if (String.isNotBlank(numeroAmigo) && numeroAmigo == originalLine) {
                                itemsToDelete.add(item.Id);
                                itemFound = true;
                            }
                        
                            itemsCount++;
                        }
                    }
                }
            }
        }
        catch (Exception e) {
            System.debug(e);
            throw e;
        }
    }

    public void DeleteFriendsNumber(String idOrder, List<String> itemsToDelete) {
        try {
            for (String itemToDelete : itemsToDelete)
            {
                Map<String, Object> input = new Map<String, Object>();
                input.put('cartId', idOrder);
                input.put('id', itemToDelete);
                Map<String, Object> outMap = new Map<String, Object>();
                Map<String, Object> options = new Map<String, Object>();
                vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
                if (!Test.isRunningTest()) {
                    cpqAppHandler.invokeMethod('deleteCartsItems',input, outMap, options);
                } else {
                    List<Object> records = new List<Object>();
                    Map<String, Object> items = new Map<String, Object>();
                    items.put('Id', itemToDelete);
                    records.add(items);
                    outMap.put('records', records);
                }
                List<Object> records = (List<Object>) outMap.get('records');
                Map<String,Object> record = (Map<String,Object>) records.get(0);
                String idDeletedItem = (String) record.get('Id');
                if (itemToDelete != idDeletedItem)
                    throw new FuncException('Error al dar de baja un numero amigo');
            }
        }
        catch (Exception e) {
            System.debug(e);
            System.debug('ERROR : ' + e);
            throw e;
        }
    }

    public void AddFriendsNumber(String idOrder, List<Map<String, Object>> itemsToAdd) {
        try {
            Map<String, Object> input = new Map<String, Object>();
            List<Map<String, Object>> lstInputParamsAlta = new List<Map<String, Object>>();
            String ofertaId;

            for(Map<String, Object> addMap : itemsToAdd)
            {
                Id assetId = (Id) addMap.get('assetId');
                ofertaId = (String) addMap.get('ofertaId');
                Asset asset = [select vlocity_cmt__PricebookEntryId__c, vlocity_cmt__ParentItemId__c from Asset where Id = :assetId];
                Map<String, Object> item = new Map<String, Object>();
                item.put('itemId', asset.vlocity_cmt__PricebookEntryId__c);
                lstInputParamsAlta.add(item);
            }

            input.put('itemId', ofertaId);
            input.put('items', lstInputParamsAlta);
            input.put('LevelBasedApproach', false);
            input.put('pagesize', 0);
            input.put('hierarchy', 0);
            input.put('cartId', idOrder);
            
            Map<String, Object> outMap = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();
            vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
            if (!Test.isRunningTest()) {
                cpqAppHandler.invokeMethod('postCartsItems',input, outMap, options);
            } else {
                List<Object> records = new List<Object>();
                Map<String, Object> items = new Map<String, Object>();
                items.put('Id', ofertaId);
                records.add(items);
                outMap.put('records', records);
            }
            
            List<Object> records = (List<Object>) outMap.get('records');
            Map<String,Object> record = (Map<String,Object>) records.get(0);
            String idAddedItem = (String) record.get('Id');

            if (!String.isNotBlank(idAddedItem)) 
                throw new FuncException('Error al dar de alta un numero amigo');
        }
        catch (Exception e) {
            System.debug(e);
            System.debug('ERROR : ' + e);
            throw e;
        }
    }

    public void AddChargeCBS() {
        try {
            Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(Generate_RequestS298());
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options2 = new Map<String, Object>();
            vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();

            if (!Test.isRunningTest()) {
                integProcService.invokeMethod('IFS_S298', input, output, options2);
                }
            else {
                Map<String,Object> IPResultTest = new Map<String,Object>();
                List<Object> listaDeSeriadosTest = new List<Object>();
                Map<String,Object> seriadoTest = new Map<String,Object>();
                seriadoTest.put('numeroSerie','numeroSerie');
                seriadoTest.put('stockProducto','stockProducto');
                seriadoTest.put('aduanaIngreso','aduanaIngreso');
                seriadoTest.put('paisOrigen','paisOrigen');
                seriadoTest.put('codOrdenDespacho','codOrdenDespacho');
                if(!options2.containsKey('isTestListaDeSeriadosTestEmpty'))listaDeSeriadosTest.add(seriadoTest);
                IPResultTest.put('listaDeSeriados',listaDeSeriadosTest);
                IPResultTest.put('txId','txId');
                output.put('IPResult',IPResultTest);
            }

            Map<String, Object> s298_response = (Map<String, Object>)output.get('IPResult');
            String txId = (String) s298_response.get('txId');

            if (!String.isNotBlank(txId))
                throw new FuncException('Error al ejecutar el cargo');
        }
        catch (Exception e) {
            System.debug(e);
            throw e;
        }
    }

    public String Generate_RequestS298() {
        try {
            String codSuscripcion = '1362000060555432';
            String idCuenta = '136200006055';
            String codCuenta = '1362000060555432';
            String codCargo = 'C_VOICF_FL_LOCAL_FEE_MEDIDO_LOCAL';
            String chargePrice = '1542.0000';
            String importeDescuentoAplicado = '100.0000';
            String montoDescuentos = '70.0000';
            String codMoneda = 'ARS';
            String fechaVenta = '2017-10-02 00:00:00';
            String fechaEmisionFacturacion = '2017-10-01 00:00:00';
            String secuenciaProductoAdquirido = '1362000060555432codProducto1';
            String body;
            body = '{"objDeduccion":{';
                body += '"codAccesoSuscriptor":{"codSuscripcion":"' + codSuscripcion + '"},';
                body += '"codAccesoCuenta":{"identificadorRecurso":"string","idCuenta":"' + idCuenta + '","codCuenta":"' + codCuenta + '","condicionPago":"string"},';
                body += '"codAccesoCte":{"identificadorRecurso":"string","idCliente":"string","codCliente":"string"},';
                body += '"codGrupoAbonado":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}';
                body += '},';
            body += '"infoServicio":{';
                body += '"codCargo":"'+codCargo+'",';
                body += '"operacionServicio":[';
                //for()
                //{
                    body += '{"nombreParametro":"string","valorParametro":"string"}';
                //}
                body += ']},';
            body += '"infoDeducTarifas":[';
                //for()
                //{
                    body += '{"secuenciaProductoAdquirido":"'+secuenciaProductoAdquirido+'","codCargo":"'+codCargo+'",';
                    body += '"fechaVenta":"'+fechaVenta+'","fechaEmisionFacturacion":"'+fechaEmisionFacturacion+'","precioCargo":"'+chargePrice+'",';
                    body += '"importeDescuentoAplicado":"'+importeDescuentoAplicado+'","montoDescuentos":"'+montoDescuentos+'","codMoneda":"'+codMoneda+'",';
                    body += '"impuestos":[';
                    //for()
                    //{
                        body += '{"codImpuesto": "string","importeImpuestoAplicado": "0.0000"}';
                    //}
                    body += '],';
                //}
                body += '"descripcion": "string","datosAdicionales": {"nombreParametro": "string","valorParametro": "string"}}';
            body += '],';
            body += '"datosAdicionales": {"nombreParametro": "string","valorParametro": "string"}';
            body +='}';

            return body;
        }
        catch (Exception e) {
            System.debug(e);
            throw e;
        }
    }

    private void AddLineNode(List<Map<String, Object>> friendsListMap, String lineNumber, String productId, Boolean validated, String ofertaId, String assetId) {
        try {
            Map<String, Object> friendNumberMap = new Map<String, Object>();
            friendNumberMap.put('id',productId);
            friendNumberMap.put('lineNumber',lineNumber);
            friendNumberMap.put('validated',validated);
            friendNumberMap.put('ofertaId',ofertaId);
            friendNumberMap.put('assetId',assetId);
            friendsListMap.add(friendNumberMap);
        }
        catch (Exception e) {
            System.debug(e);
        }
    }

    public void SaveNumbers(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            List<Object> friendsNumberPlansToAdd = (List<Object>) options.get('numerosAmigosXPlan');
            SaveNumbers(friendsNumberPlansToAdd);
        }
        catch (Exception e) {
            System.debug(e);
        }
    }

    public void SaveNumbers(List<Object> friendsNumberPlansToAdd) {
        try {
            Map<Id, Map<String,Boolean>> orderItemsToUpdateMap = new Map<Id, Map<String,Boolean>>();

            for (Object planObj : friendsNumberPlansToAdd) {
                System.debug('planObj'+planObj);
                Map<String, Object> planMap = (Map<String, Object>) planObj;
                List<Object> friendsNumberVoice = (List<Object>) planMap.get('numerosAmigoVoz');
                System.debug('friendsNumberVoice'+friendsNumberVoice);
                System.debug('ListVoice'+(List<Object>) planMap.get('numerosAmigoVoz'));
                List<Object> friendsNumberSMS = (List<Object>) planMap.get('numerosAmigoSms');
                
                AddNumbersToUpdate(orderItemsToUpdateMap,friendsNumberVoice);
                AddNumbersToUpdate(orderItemsToUpdateMap,friendsNumberSMS);
            }

            if (orderItemsToUpdateMap.keySet().size() > 0) {
                List<OrderItem> orderProductsToUpdate = new List<OrderItem>();
                List<OrderItem> orderProducts = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE Id =:orderItemsToUpdateMap.keySet()];

                for (OrderItem anOrderItem : orderProducts) {
                    Map<String, Boolean> friendNumberMap = (Map<String, Boolean>) orderItemsToUpdateMap.get(anOrderItem.Id);
                    String lineNumber;
                    Boolean validated;

                    for (String key : friendNumberMap.keySet()) {
                        lineNumber = (String) key;
                        validated = (Boolean) friendNumberMap.get(key);
                    }

                    if (String.isNotBlank(lineNumber) && validated)
                    {
                        String jsonAttribute = setValuesOnJSON(anOrderItem.vlocity_cmt__JSONAttribute__c, lineNumber, 'MOVIL');
                        anOrderItem.vlocity_cmt__JSONAttribute__c = jsonAttribute;
                        orderProductsToUpdate.add(anOrderItem);
                    }
                }

                if (orderProductsToUpdate.size() > 0)
                    update orderProductsToUpdate;
            }
        }
        catch (Exception e) {
            System.debug(e);
        }
    }

    private void AddNumbersToUpdate(Map<Id, Map<String,Boolean>> orderItemsToUpdateMap, List<Object> friendsNumbers) {
        try {
            for (Object friendNumberObj : friendsNumbers) {
                Map<String, Object> friendNumberMap = (Map<String, Object>) friendNumberObj;
                String idItem = (String) friendNumberMap.get('id');
                Map<String, Boolean> newMap = new Map<String, Boolean>();
                String lineNumberItem = (String) friendNumberMap.get('lineNumber');
                Boolean validatedItem = (Boolean) friendNumberMap.get('validated');
                newMap.put(lineNumberItem, validatedItem);
                orderItemsToUpdateMap.put(idItem, newMap);
            }
        }
        catch (Exception e) {
            System.debug(e);
        }
    }
}