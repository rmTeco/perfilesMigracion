global with sharing class taSalesSMSInteraction implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('ReceiveMessage')){
                ReceiveMessage(inputMap, outMap, options);
            }
            if (methodName.equals('ValidateClientResponse')){
                ValidateClientResponse(inputMap, outMap, options);
            }
            if (methodName.equals('SendSMS')){
                SendSMS(inputMap, outMap, options);
            }
            if (methodName.equals('CheckAndSaveDecisiveLine')){
                CheckAndSaveDecisiveLine(inputMap, outMap, options);
            }
            result = false;  
        } 
        catch(Exception e)
        {
            System.debug('taSalesSMSInteraction:invokeMethod -> exception: '+e);
            throw e; 
            //result = false;
        }
        return result;
    }

    global static void ReceiveMessage(String line, String mensaje){
        RecordType recordTypeTemplate = [SELECT Id FROM RecordType WHERE Name = 'SMS Template'];

        CrossObject__c template = [SELECT Integer1__c, Integer2__c FROM CrossObject__c WHERE RecordTypeId = :recordTypeTemplate.Id AND PickList1__c = 'Verificación de identidad en una orden de venta'];

        RecordType recordTypeLog = [SELECT Id FROM RecordType WHERE Name = 'Log Identity Validation'];
        DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes((Integer)template.Integer1__c * -1);

        RecordType recordType = [SELECT Id, Name FROM RecordType WHERE name = 'SMS Tracking'];

        List<CrossObject__c> operations = [
            SELECT Id, Integer1__c, Account__c, Order__c
            FROM CrossObject__c 
            WHERE 
                RecordTypeId = :recordType.Id
                AND String1__c = :line
                AND Status__c = 'Pendiente'
                AND Integer1__c <= :template.Integer2__c
                AND DateTime1__c >= :fechaLimiteVencimiento
            ORDER BY CreatedDate ASC];

        if(operations.size() > 0){
            CrossObject__c operation = operations[0];
            SMS_Expected_Response_Type__c expected = SMS_Expected_Response_Type__c.getInstance('SMS_Expected_Response_Type');

            if(mensaje.startsWith(expected.Ok__c.toUpperCase())){
                operation.Status__c = 'Confirmado';
            }else if(mensaje.startsWith(expected.Ko__c.toUpperCase())){
                operation.Status__c = 'Cancelado';
            }
            operation.DateTime3__c = System.now();
            update operation;

            String idOrder = operation.Order__c;

            if(idOrder != null && idOrder != ''){
                String statusToSet;
                String status;
                
                if(operation.Status__c == 'Confirmado'){
                    status = 'Draft';
                    statusToSet = 'Preparar pedido';    
                } else {
                    status = 'Cancelled';
                    statusToSet = 'Cancelada - Validacion Rechazada';    
                }

                Order order = [SELECT Id, Name FROM Order WHERE Id = :idOrder];
                order.Status =  status;
                order.TrackingStatus__c = statusToSet;
                update order;
            }

            String accountId = operation.Account__c;

            if(accountId != null && accountId != ''){
                Account account = [SELECT Id FROM Account WHERE Id = :accountId];
                List<CrossObject__c> logs = [
                    SELECT Id
                    FROM CrossObject__c
                    WHERE PickList1__c = 'Sms'
                        AND Order__c = :idOrder
                        AND RecordTypeId = :recordTypeLog.Id
                        AND Account__c = :accountId
                        AND Checkbox1__c = false
                        AND DateTime1__c >= :fechaLimiteVencimiento
                    ORDER BY CreatedDate ASC];
                if(logs.size() > 0){
                    CrossObject__c log = logs[0];
                    log.Checkbox1__c = true;
                    update log;
                }
            }
        }
    }

    /*global static void ReceiveMessage(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        String accountId = (String) options.get('accountId');
        // System.debug('ACCOUNT ID ' + accountId);
        String idOrder = (String) options.get('IdOrder');
        String smsResponse = ((String)options.get('ResponseTypeSMS')).toUpperCase();

        if(accountId != null && accountId != ''){
            Account account = [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId];

            RecordType recordTypeTemplate = [SELECT Id, Name FROM RecordType WHERE name = 'SMS Template'];
            CrossObject__c template = [SELECT Integer1__c, Integer2__c, Name FROM CrossObject__c where RecordTypeId = :recordTypeTemplate.Id AND PickList1__c = 'Verificación de identidad en una orden de venta'];

            // seteo el log de verificacion de identidad como validado correctamente
            RecordType recordTypeLog = [SELECT Id, Name FROM RecordType WHERE name = 'Log Identity Validation'];
            DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes((Integer)template.Integer1__c * -1);
            List<CrossObject__c> logs = [
                SELECT Id
                FROM CrossObject__c
                WHERE PickList1__c = 'Sms'
                    AND Order__c = :idOrder
                    AND RecordTypeId = :recordTypeLog.Id
                    AND Account__c = :accountId
                    AND Checkbox1__c = false
                    AND DateTime1__c >= :fechaLimiteVencimiento
                ORDER BY CreatedDate ASC];
            if(logs.size() > 0){
                CrossObject__c log = logs[0];
                log.Checkbox1__c = true;
                update log;
            }

            RecordType recordType = [SELECT Id, Name FROM RecordType WHERE name = 'SMS Tracking'];

            String line = account.Phone;
            System.debug('line: ' +  line);

            List<CrossObject__c> operations = [
                SELECT Id, Integer1__c, Order__c
                FROM CrossObject__c 
                WHERE 
                    RecordTypeId = :recordType.Id
                    AND String1__c = :line
                    AND Status__c = 'Pendiente'
                    AND Integer1__c <= :template.Integer2__c
                    AND DateTime1__c >= :fechaLimiteVencimiento
                ORDER BY CreatedDate ASC];

            if(operations.size() > 0){
                CrossObject__c operation = operations[0];
                // CrossObject__c operation = [SELECT Id, Order__c FROM CrossObject__c WHERE RecordTypeId = :recordType.Id AND String1__c =: line AND Status__c = 'Pendiente' ORDER BY CreatedDate ASC][0];
                // System.debug('operation ' + operation);
                SMS_Expected_Response_Type__c expected = SMS_Expected_Response_Type__c.getInstance('SMS_Expected_Response_Type');

                // if(validateClientResponse(account.phone)){
                    if(smsResponse.startsWith(expected.Ok__c.toUpperCase())){
                        System.debug('CONFIRMADO');
                        operation.Status__c = 'Confirmado';
                    }else if(smsResponse.startsWith(expected.Ko__c.toUpperCase())){
                        System.debug('CANCELADO');
                        operation.Status__c = 'Cancelado';
                    }
                // }
                operation.DateTime3__c = System.now();
                update operation;

                idOrder = operation.Order__c;
                System.debug('IDORDER ' +idOrder);

                if(idOrder != null && idOrder != ''){
                    String statusToSet;
                    String status;
                    
                    if(operation.Status__c == 'Confirmado'){
                        status = 'Draft';
                        statusToSet = 'Preparar pedido';    
                    } else {
                        status = 'Cancelled';
                        statusToSet = 'Cancelada - Validacion Rechazada';    
                    }

                    Order order = [SELECT Id, Name FROM Order WHERE Id = :idOrder];
                    order.Status =  status;
                    order.TrackingStatus__c = statusToSet;
                    update order;
                }
            }
        }
    }*/

    global static void ReceiveMessage(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        String msisdn = (String) options.get('nroLinea');
        String accountId = '';
        String idOrder = '';
        if (msisdn != null && msisdn != ''){
            Asset assetInfo = [SELECT Id, AccountId, vlocity_cmt__OrderProductId__r.OrderId FROM Asset WHERE MSISDN__c = :msisdn];
            accountId = assetInfo.AccountId;
            idOrder = assetInfo.vlocity_cmt__OrderProductId__r.OrderId;
        }
        String smsResponse = ((String)options.get('mensaje')).toUpperCase();

        if(accountId != null && accountId != ''){
            Account account = [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId];

            RecordType recordTypeTemplate = [SELECT Id, Name FROM RecordType WHERE name = 'SMS Template'];
            CrossObject__c template = [SELECT Integer1__c, Integer2__c, Name FROM CrossObject__c where RecordTypeId = :recordTypeTemplate.Id AND PickList1__c = 'Verificación de identidad en una orden de venta'];

            // seteo el log de verificacion de identidad como validado correctamente
            RecordType recordTypeLog = [SELECT Id, Name FROM RecordType WHERE name = 'Log Identity Validation'];
            DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes((Integer)template.Integer1__c * -1);
            List<CrossObject__c> logs = [
                SELECT Id
                FROM CrossObject__c
                WHERE PickList1__c = 'Sms'
                    AND Order__c = :idOrder
                    AND RecordTypeId = :recordTypeLog.Id
                    AND Account__c = :accountId
                    AND Checkbox1__c = false
                    AND DateTime1__c >= :fechaLimiteVencimiento
                ORDER BY CreatedDate ASC];
            if(logs.size() > 0){
                CrossObject__c log = logs[0];
                log.Checkbox1__c = true;
                update log;
            }

            RecordType recordType = [SELECT Id, Name FROM RecordType WHERE name = 'SMS Tracking'];

            String line = account.Phone;
            System.debug('line: ' +  line);

            List<CrossObject__c> operations = [
                SELECT Id, Integer1__c, Order__c
                FROM CrossObject__c 
                WHERE 
                    RecordTypeId = :recordType.Id
                    AND String1__c = :line
                    AND Status__c = 'Pendiente'
                    AND Integer1__c <= :template.Integer2__c
                    AND DateTime1__c >= :fechaLimiteVencimiento
                ORDER BY CreatedDate ASC];

            if(operations.size() > 0){
                CrossObject__c operation = operations[0];
                // CrossObject__c operation = [SELECT Id, Order__c FROM CrossObject__c WHERE RecordTypeId = :recordType.Id AND String1__c =: line AND Status__c = 'Pendiente' ORDER BY CreatedDate ASC][0];
                // System.debug('operation ' + operation);
                SMS_Expected_Response_Type__c expected = SMS_Expected_Response_Type__c.getInstance('SMS_Expected_Response_Type');

                // if(validateClientResponse(account.phone)){
                    if(smsResponse.startsWith(expected.Ok__c.toUpperCase())){
                        System.debug('CONFIRMADO');
                        operation.Status__c = 'Confirmado';
                    }else if(smsResponse.startsWith(expected.Ko__c.toUpperCase())){
                        System.debug('CANCELADO');
                        operation.Status__c = 'Cancelado';
                    }
                // }
                operation.DateTime3__c = System.now();
                update operation;

                idOrder = operation.Order__c;
                System.debug('IDORDER ' +idOrder);

                if(idOrder != null && idOrder != ''){
                    String statusToSet;
                    String status;
                    
                    if(operation.Status__c == 'Confirmado'){
                        status = 'Draft';
                        statusToSet = 'Preparar pedido';    
                    } else {
                        status = 'Cancelled';
                        statusToSet = 'Cancelada - Validacion Rechazada';    
                    }

                    Order order = [SELECT Id, Name FROM Order WHERE Id = :idOrder];
                    order.Status =  status;
                    order.TrackingStatus__c = statusToSet;
                    update order;
                }
            }
        }
    }

    global static void ValidateClientResponse(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        Boolean isValid = false;
        String type = (String)options.get('type');
        String accountId = (String)options.get('accountId');
        Account account = [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId];
        isValid = validateClientResponse(type, account.phone);

        outMap.put('IsValid', isValid);
        // outMap.put('juan', 'perez');
    }

    global static void SendSMS(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        // Map<String, Object> request = (Map<String, Object>)options.get('S159_Request');
        System.debug('SendSMS');

        String accountId = (String)options.get('accountId');
        String orderId = (String)options.get('orderId');
        String type = (String)options.get('type');
        String cellnumber = (String)options.get('cellnumber');
        String text = (String)options.get('text');
        //Boolean isValid = validateClientResponse(type, accountId); Modificado por Joshua Juanchini por la línea de abajo
        Boolean isValid = validateClientResponse(type, cellnumber);
        // Boolean isValid = false;

        Map<String, Object> validateSMS_Response = new Map<String, Object>();
        validateSMS_Response.put('IsValid', isValid);
        outMap.put('ValidateSMS_Response', validateSMS_Response);
        // outMap.put('S159_Response', null);
        System.debug('2');
        if(!isValid){
            System.debug('3');
            // String body = '{"body": {"request": {"Target": {"User": {"Celnumber": "'+ cellnumber +'"}}},"communicationText": "'+ text +'"}}';
            String body = '{"params":{"nroLinea":"'+ cellnumber +'"},"body":{"bodyFullCodeName":"string","campaignName":"'+SMSSender__c.getInstance('S-Confirmacion-SMS').Sender__c+'","channelName":"SMS","communicationDate":"","communicationText":"'+ text +'","messageReference":"string","target":{"rawdata":[{"key":"string","value":"string"}],"user":{"customerNumber":0,"lastName":"string","mail":"string","name":"string"}}}}';
            Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(body);
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options2 = new Map<String, Object>();

            System.debug('SendSMS: ' + JSON.serialize(input));
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod('IFS_S159', input, output, options2);

			String execCode = 'OK';

            if(!Test.isRunningTest()){
            	Map<String, Object> response = (Map<String, Object>) output.get('IPResult');
            	execCode = (String) response.get('executionCode');
            }
            
            if(execCode != 'OK'){
                throw new FuncException('Error inesperado al enviar el SMS.');
            }

            System.debug('4');
            // SMS Tracking
            RecordType recordTypeTemplate = [SELECT Id, Name FROM RecordType WHERE name = 'SMS Template'];
            CrossObject__c template = [SELECT Integer1__c, Integer2__c FROM CrossObject__c where RecordTypeId = :recordTypeTemplate.Id AND PickList1__c = 'Verificación de identidad en una orden de venta'];
            
            RecordType recordType = [SELECT Id, Name FROM RecordType WHERE name = 'SMS Tracking'];
            // me traigo todos los SMS tracking pendientes que no estan vencidos y que tienen intentos pendiente
            DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes((Integer)template.Integer1__c * -1);
            System.debug('query: ' + recordType.Id + ' ' + template.Integer2__c + ' ' + fechaLimiteVencimiento);
            List<CrossObject__c> operations = [
                SELECT Id, Integer1__c
                FROM CrossObject__c 
                WHERE 
                    RecordTypeId = :recordType.Id
                    AND String1__c = :cellnumber
                    AND Status__c = 'Pendiente'
                    AND Integer1__c < :template.Integer2__c
                    AND DateTime1__c > =:fechaLimiteVencimiento
                ORDER BY CreatedDate ASC];

            System.debug('operations: ' + operations);

            CrossObject__c trackSMS;
            if(operations.size() > 0){
                trackSMS = operations[0];
                trackSMS.Integer1__c = trackSMS.Integer1__c + 1;
                trackSMS.DateTime2__c = System.now();
            } else{
                trackSMS = new CrossObject__c();
                trackSMS.DateTime1__c = DateTime.now();
                trackSMS.String1__c = cellnumber;
                trackSMS.String2__c = text;
                trackSMS.Picklist1__c = type;
                trackSMS.Integer1__c = 1;

                trackSMS.RecordTypeId = recordType.Id;
                trackSMS.Status__c = 'Pendiente';
                trackSMS.Account__c = accountId;
                if(orderId != null && orderId != ''){
                    trackSMS.Order__c = orderId;
                }

                if(type == 'Verificación de identidad en una orden de venta'){
                    // es una nueva validacion, la guardo como log en false, cuando responda se pasa a true, sino queda siempre como un intento en false
                    RecordType recordTypeLog = [SELECT Id, Name FROM RecordType WHERE name = 'Log Identity Validation'];
                    CrossObject__c logValidationIdentity = new CrossObject__c();
                    logValidationIdentity.Picklist1__c = 'Sms';
                    logValidationIdentity.Account__c = accountId;
                    if(orderId != null && orderId != ''){
                        logValidationIdentity.Order__c = orderId;
                    }
                    logValidationIdentity.DateTime1__c = DateTime.now();
                    logValidationIdentity.RecordTypeId = recordTypeLog.Id;
                    insert logValidationIdentity;
                }
                
            }
            upsert trackSMS;
            
        }
        
    }

    public static Boolean sendSMSTemplate(String cellNumber, String templateSMS, Map<String, String> variables){

        Boolean bReturn = false;

        try{
            //templateSMS = 'Recarga Exitosa';
            CrossObject__c template = [SELECT Id, String1__c FROM CrossObject__c WHERE Picklist1__c = :templateSMS AND RecordType.Name = 'SMS Template' LIMIT 1];

            //Parseo del string
            String msgToSend = template.String1__c;
            String value;
            
            Set <String> myKeySet;
            myKeySet = variables.keySet();
            String keytoSearch;

            for (String myKey :myKeySet){
                value = variables.get(myKey);
                keytoSearch = '{{'+myKey+'}}';
                msgToSend = msgToSend.replace(keytoSearch, value);
            }

            //Invocacion al servicio envio
            //String body = '{"body": {"request": {"Target": {"User": {"Celnumber": "'+ cellnumber +'"}}},"communicationText": "'+ msgToSend +'"}}';
            String body = '{"params":{"nroLinea":"'+ cellnumber +'"},"body":{"bodyFullCodeName":"string","campaignName":"'+SMSSender__c.getInstance('S-Confirmacion-SMS').Sender__c+'","channelName":"SMS","communicationDate":"","communicationText":"'+ msgToSend +'","messageReference":"string","target":{"rawdata":[{"key":"string","value":"string"}],"user":{"customerNumber":0,"lastName":"string","mail":"string","name":"string"}}}}';
            System.debug('Request S159: ' + body);
            Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(body);
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options2 = new Map<String, Object>();
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod('IFS_S159', input, output, options2); 

			String execCode = 'OK';
			
			if(!Test.isRunningTest()){
				Map<String, Object> response = (Map<String, Object>) output.get('IPResult');
            	execCode = (String) response.get('executionCode');
			}
            //Dejo registro en CO de tracking SMS
            RecordType trackingrt = [SELECT Id FROM RecordType WHERE SObjectType = 'CrossObject__c' AND DeveloperName = 'SMSTracking'];
            CrossObject__c coTracking;

            if(execCode == 'OK'){
                bReturn = true;     
                coTracking =  new CrossObject__c(String1__c = cellNumber, String2__c = msgToSend, RecordTypeId = trackingrt.Id, DateTime1__c = System.now(), Picklist1__c = templateSMS, Status__c = 'Pendiente', MarkForDeletion__c = true);     
            }
            else{
                coTracking =  new CrossObject__c(String1__c = cellNumber, String2__c = msgToSend, RecordTypeId = trackingrt.Id, DateTime1__c = System.now(), Picklist1__c = templateSMS, Status__c = 'Fallo Envio', MarkForDeletion__c = true);     
            }
            insert coTracking;
        }
        catch(Exception e){
            System.debug('sendSMSTemplate -> exception: '+e);
            throw e;
        }
        return bReturn;
        //throw new FuncException('Error inesperado al enviar el SMS: ' + output);

        
    }

    global static void CheckAndSaveDecisiveLine(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        System.debug('checkAndSaveDecisiveLine');
        String accountId = (String)options.get('accountId');
        String phone = String.valueOf(options.get('phone'));
        String phoneS121 = String.valueOf(options.get('phoneS121'));

        //PFTA-10979
        //We only send SMS if the number is not the same
        Boolean sendSMS = false;
        if (phone != phoneS121) {
            System.debug('Se ingresó un numero manualmente');
            sendSMS = true;
        } 

        Account account = [SELECT Id, RecordTypeId, vlocity_cmt__RootAccountId__c, Name FROM Account WHERE Id = :accountId];
        String recordTypeId = account.RecordTypeId;
        RecordType recordType = [SELECT Id, Name FROM RecordType WHERE Id = :recordTypeId];

        if(recordType.Name == 'Billing'){
            // si el account pasado es de tipo billing, debe actualizar el del padre
            accountId = account.vlocity_cmt__RootAccountId__c;
        }

        Boolean hasPhone = false;
        List<Asset> assets = [SELECT Id, AccountId FROM Asset WHERE AccountId = :accountId AND MSISDN__c = :phone];
        if(assets.size() > 0){
            System.debug('TENGO ASSET CON MISMO NUMERO');
            hasPhone = true;
        }

        // Llamamos al IP S159
        if(sendSMS && !hasPhone){
            System.debug('Mando SMS al S159');
            SMS_Expected_Response_Type__c expected = SMS_Expected_Response_Type__c.getInstance('SMS_Expected_Response_Type');
            
            //armo el text de envio de SMS haciendo los replaces
            recordType = [SELECT Id, Name FROM RecordType WHERE name = 'SMS Template'];
            String typeSMS = 'Verificación de Línea Decisora';
            CrossObject__c templateSMS = [SELECT String1__c  FROM CrossObject__c WHERE RecordTypeId = :recordType.Id AND Picklist1__c = :typeSMS];
            String text = templateSMS.String1__c;
            text = text.replace('{{Name}}', account.Name);
            text = text.replace('{{Phone}}', phone);
            text = text.replace('{{OK}}', expected.Ok__c);
            text = text.replace('{{KO}}', expected.Ko__c);

            String body = '{"body": {"request": {"Target": {"User": {"Celnumber": "'+ phone +'"}}},"communicationText": "'+ text +'"}}';
            Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(body);
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options2 = new Map<String, Object>();
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod('IFS_S159', input, output, options2);
            outMap.put('IP_Response', output);

            // hago el track de envio de SMS
            recordType = [SELECT Id, Name FROM RecordType WHERE name = 'SMS Tracking'];

            CrossObject__c trackSMS = new CrossObject__c();
            trackSMS.String1__c = phone;
            trackSMS.String2__c = text;
            trackSMS.Picklist1__c = typeSMS;
            trackSMS.DateTime1__c = DateTime.now();
            trackSMS.RecordTypeId = recordType.Id;
            trackSMS.Status__c = 'Pendiente';
            insert trackSMS;

        } 

        // Actualizamos siempre el account con el phone recibido, y si el telefono es unos de los assets se deja como validado
        
        //PFTA-10979, se debe actualizar al final de la gestión.
        /*
        account = new Account();
        account.Id = accountId;
        account.Phone = phone;
        account.PhoneValidated__c = hasPhone;
        update account;
        */
        
        outMap.put('PhoneValidated', hasPhone);
        outMap.put('Phone',phone);
        outMap.put('RootAcount',accountId);
    }

    private static Boolean validateClientResponse(String type, String line){
        // type = 'Verificación de identidad en una orden de venta'
        System.debug('validateClientResponse');
        RecordType recordTypeTemplate = [SELECT Id, Name FROM RecordType WHERE name = 'SMS Template'];
        System.debug(recordTypeTemplate.Id + ' ' + type);
        CrossObject__c template = [SELECT Integer1__c, Integer2__c FROM CrossObject__c where RecordTypeId = :recordTypeTemplate.Id AND PickList1__c = :type];

        RecordType recordType = [SELECT Id, Name FROM RecordType WHERE name = 'SMS Tracking'];
        DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes((Integer)template.Integer1__c * -1);
        
        System.debug('fechaLimiteVencimiento: ' + fechaLimiteVencimiento);
        System.debug('line: ' + line);
        System.debug('template.Integer2__c: ' + template.Integer2__c);
        System.debug('recordType.Id: ' + recordType.Id);
        
        List<CrossObject__c> operations = [
            SELECT Id, DateTime1__c, DateTime2__c 
            FROM CrossObject__c 
            WHERE RecordTypeId = :recordType.Id 
                AND String1__c =: line 
                AND Status__c = 'Confirmado' 
                AND Integer1__c <= :template.Integer2__c
                AND DateTime1__c > =:fechaLimiteVencimiento
                AND DateTime3__c != null
            ORDER BY CreatedDate ASC];
        System.debug('validateClientResponse ' + operations);
        CrossObject__c operation = null;
        if(operations.size() > 0){
            operation = operations[0];
        }

        Boolean isValid = false;
        if(operation != null){
            isValid = true;

            operation.Status__c = 'Cerrado';
            update operation;
        }
        
        return isValid;
    }
}