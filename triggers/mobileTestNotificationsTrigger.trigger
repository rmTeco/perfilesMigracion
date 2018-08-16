trigger mobileTestNotificationsTrigger on Lead (after update, after insert) {
    
    for(Lead cs : Trigger.New)  
    {
        
        Map<String, Object> applePayload = 
            Messaging.PushNotificationPayload.apple(
                'iOS: Case ' + cs.name + ' Notificacion de Ofertas: ' 
                + cs.name, 'default', 10, null);
        applePayload.put('deeplinking', '{objectType:Contact,objectId:'+cs.Id+'}');
        
        Map<String, Object> androidPayload = new Map<String, Object>();
        //androidPayload.put('message', 'android: Contact ' + cs.name + ' status changed to: ' 
        //        + cs.name);
        androidPayload.put('message', 'Notificacion de Ofertas!');
        androidPayload.put('deeplinking', '{objectType:Contact,objectId:'+cs.Id+'}');
        
        // TBD add Receive_Notifications__c And Receive_Offer_Notifications__c to check query
        // Adding recipient users to list
        
        //Set<Id> listaId = new Set<Id>();
        //listaId = [Select id from User where id = '0056C000000tUmbQAE' OR id = '0056C000000tUmdQAE']; 
        
        
        List <User> listaid = new List<User>();
        //listaId = [Select id from User where Receive_Offer_Notifications__c=true]; 
        
        Set<String> users = new Set<String>();
        for(User idindiv : listaId){
            String prueba = String.valueof(idindiv.id); 
            users.add(prueba);
            
        }
        
        
        /*
Set<String> users = new Set<String>();

users.add('0056C000000tUmbQAE');
users.add('0056C000000tUmdQAE');
users.add('0056C000000gOrAQAU');
users.add('0056C000000trmEQAQ');
*/
        //for(Id id : listaId){
        
        //  todo: tostring
        //users.add(id);
        
        //}
        /*system.debug(users.size());
        connected_apps.VlocityMobileNotification.send(applePayload, androidPayload, users);
        vlocity_mobile.VlocityMobileNotification.send(applePayload, androidPayload, users);*/
        
    }
}