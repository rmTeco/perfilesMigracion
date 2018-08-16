trigger mobileTestTrigger on Contact (after update, after insert) {
    
    for(Contact cs : Trigger.New)  
    {
        // Assembling the necessary payload parameters for Apple.
        // Apple params are: 
        // (<alert text>,<alert sound>,<badge count>,
        // <free-form data>)
        // This example doesn't use badge count or free-form data.
        // The number of notifications that haven't been acted
        // upon by the intended recipient is best calculated
        // at the time of the push. This timing helps
        // ensure accuracy across multiple target devices.
        Map<String, Object> applePayload = 
            Messaging.PushNotificationPayload.apple(
                'iOS: Case ' + cs.name + ' status changed to: ' 
                + cs.name, 'default', 10, null);
        applePayload.put('deeplinking', '{objectType:Contact,objectId:'+cs.Id+'}');
        
        Map<String, Object> androidPayload = new Map<String, Object>();
        //androidPayload.put('message', 'android: Contact ' + cs.name + ' status changed to: ' 
        //        + cs.name);
        androidPayload.put('message', 'Notificación de prueba!');
        androidPayload.put('deeplinking', '{objectType:Contact,objectId:'+cs.Id+'}');

        // Getting recipient users
        String userId1 = cs.OwnerId;
        String userId2 = cs.LastModifiedById;
        //List<String> usersT = new List<String>();
        //usersT=[SELECT id FROM user LIMIT 100];

        // Adding recipient users to list
        Set<String> users = new Set<String>();
        users.add(userId1);
        users.add(userId2);  
        
        connected_apps.VlocityMobileNotification.send(applePayload, androidPayload, users);
        vlocity_mobile.VlocityMobileNotification.send(applePayload, androidPayload, users);
    }

}