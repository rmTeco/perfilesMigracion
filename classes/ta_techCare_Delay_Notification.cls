global class ta_techCare_Delay_Notification implements vlocity_cmt.VlocityOpenInterface{
	
    public Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        Boolean resp = false; 
        if (methodName.equals('SendDelayNotification')){
           resp = SendDelayNotification(inputMap, outMap, options); 
        }        
        return resp;
    }
        
    public static Boolean SendDelayNotification (Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){                        
        Boolean success = false;
        String mail = '', phone='';
        Id caseId = (Id)inputMap.get('caseId');		                             
        String suppliedPhone = (String)inputMap.get('SuppliedPhone');
        String caseMail = (String)inputMap.get('caseMail');                        
        String contactPhoneNumber = (String)inputMap.get('contactPhoneNumber');
        String contactMail = (String)inputMap.get('contactMail');

            if(caseMail !='' || contactMail !=''){
                mail = caseMail !=''? caseMail : contactMail;
                success = SendMail(mail, inputMap, outMap, success);
                
            }else if(suppliedPhone !='' || contactPhoneNumber !=''){
                phone  = suppliedPhone !=''? suppliedPhone : contactPhoneNumber;                                       
               success = SendSMS(phone, inputMap, success);
            }else{
                ///error---destinatary not found        
                 success = false;                 
            }                                        
     
        return success;                                                                        
	}

    public static Boolean SendMail(String mail, Map<String, Object> inputMap, Map<String, Object> outMap, Boolean success){
         /////enviar mail                            
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> address = new List<String>();
        String caseNumber = (String) inputMap.get('caseNumber');                           
        
        String subject = 'Gestión de Servicio Técnico';
        String body = '<p>Estimado Cliente,<br/>'
            +'<br/>'
            +'Le informamos que su gestión N° ' +caseNumber+' de Servicio Técnico presenta una demora adicional debido a problemas operativos.<br/>'
            +'Recibirá un aviso adicional cuando su gestión se encuentre lista para ser retirada.<br/>'
            +'<br/>'
            +' Cordialmente.<br/>'
            +'<br/>'
            +'Servicio de Soporte Tecnico.</p>';                                            

        try{
            //set mail structure
            email.setSubject( subject );
            address.add(mail);
            email.setToAddresses(address);
            
            system.debug('prepare to send mail');            
            email.setHtmlBody(body);
            //invoke method
            Messaging.SendEmailResult [] r =
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            outMap.put('sendEmailStatus', 'OK');
            outMap.put('sendEmailTo', address);
            success = true;
        } catch(Exception ex){
            outMap.put('sendEmailStatus', 'ERROR');
            outMap.put('sendEmailTo', 'N/A');
            throw ex;
        }       
         return success;   
                                
    }

    public static Boolean SendSMS(String telefono, Map<String, Object> inputMap, Boolean success){
        Map<String, Object> outMap  = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        String caseNumber = (String) inputMap.get('caseNumber');
        
        system.debug('inside SendSMS');
        String communicationText = 'Estimado Cliente,'
            +'Le informamos que su gestión N° ' +caseNumber+' de Servicio Técnico presenta una demora adicional debido a problemas operativos.'
            +'Recibirá un aviso adicional cuando su gestión se encuentre lista para ser retirada.'
            +' Cordialmente.'
            +'Servicio de Soporte Tecnico';
         
        String jsonString = '{"params": {"nroLinea": "telefono"},"body": {"bodyFullCodeName": "string","campaignName":"'+SMSSender__c.getInstance('S-Confirmacion-SMS').Sender__c+'","channelName": "SMS","communicationDate": "2017-05-04T02:29:43","communicationText": "string","messageReference": "string","target": {"rawdata": [{"key": "string","value": "string"}],"user": {"customerNumber": 0,"lastName": "string","mail": "string","name": "string"}}}}';
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        try{
            SendSMSInvoke objIntegration = new SendSMSInvoke();
            objIntegration.invokeMethod('sendSmsIntegration', input, outMap,options);
            success = true;            
            }catch(Exception ex){
                outMap.put('sendSMS', 'ERROR');
        }        
        return success;
    }     
    
}