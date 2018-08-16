trigger testMobile on Case (after update) {
    for(Case cs : Trigger.New)  
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
                'iOS: Case ' + cs.CaseNumber + ' status changed to: ' 
                + cs.Status, 'default', 10, null);
        applePayload.put('deeplinking', '{objectType:Case,objectId:'+cs.Id+'}');
        
        Map<String, Object> androidPayload = new Map<String, Object>();
        androidPayload.put('message', 'android: Case ' + cs.CaseNumber + ' status changed to: ' 
                + cs.Status);
        androidPayload.put('deeplinking', '{objectType:Case,objectId:'+cs.Id+'}');

        // Getting recipient users
        String userId1 = cs.OwnerId;
        String userId2 = cs.LastModifiedById;

        // Adding recipient users to list
        Set<String> users = new Set<String>();
        users.add(userId1);
        users.add(userId2);  
        
        //connected_apps.VlocityMobileNotification.send(applePayload, androidPayload, users);
        //vlocity_mobile.VlocityMobileNotification.send(applePayload, androidPayload, users);
    }
}