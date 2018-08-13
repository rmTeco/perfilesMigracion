global class ta_sales_UserUtils implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;
        try {
            String userId = (String) options.get('userId');
            if (methodName.equals('checkUserHasCustomPermissionAccess')) {
                String customPermission = (String) options.get('customPermission');
                result = checkUserHasCustomPermissionAccess(customPermission,userId);
            }
            else if (methodName.equals('getUserChannel')) {
                Id profileId = UserInfo.getProfileId();
                Profile profile = [SELECT Id, Name FROM Profile WHERE Id =: profileId];

                vlocity_cmt__BusinessSite__c storeLocation = getStoreLocation(userId);
                outMap.put('ProfileName', profile.Name);
                outMap.put('UserChannel', storeLocation.Channel_Type__c);
                outMap.put('UserChannelMode', storeLocation.Channel__c);
            }
            else if (methodName.equals('getStoreLocation')) {
                vlocity_cmt__BusinessSite__c storeLocation = getStoreLocation(userId);
                outMap.put('UserStoreLocation', storeLocation.Id);
            }
            result = false; 
        }
        catch(Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            result = false;
        }

        return result; 
    }

    public static vlocity_cmt__BusinessSite__c getStoreLocation(Id userId) {
        try {
            Team_Member__c tm = [
                SELECT Work_Team__r.Work_Place__c,
                       Work_Team__r.Work_Place__r.Name,
                       Work_Team__r.Work_Place__r.BillingMode__c,
                       Work_Team__r.Work_Place__r.Channel__c,
                       Work_Team__r.Work_Place__r.Channel_Type__c,
                       Work_Team__r.Work_Place__r.Channel_Type_2__c,
                       Work_Team__r.Work_Place__r.Channel_Type_3__c, 
                       Work_Team__r.Work_Place__r.PointOfSaleId__c,
                       Work_Team__r.Work_Place__r.Location__c
                  FROM Team_Member__c 
                 WHERE User_Member__c = :userId 
                   AND Is_Active__c = true
                 LIMIT 1];

            return tm.Work_Team__r.Work_Place__r;
        }
        catch(QueryException e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            return null;
        }
    }

    public static Boolean checkUserHasCustomPermissionAccess(String customPermission, Id userId) {
        try {
            Set<Id> permissionSetIds = new Set<Id>();
            List<User> userList = new List<User>();
            for (SetupEntityAccess access : [SELECT ParentId
                                               FROM SetupEntityAccess 
                                              WHERE SetupEntityId IN (SELECT Id 
                                                                        FROM CustomPermission 
                                                                       WHERE DeveloperName =: customPermission)])
                permissionSetIds.add(access.ParentId);
                userList = [SELECT Username
                              FROM User
                             WHERE Id IN (SELECT AssigneeId
                                            FROM PermissionSetAssignment
                                           WHERE PermissionSetId IN :permissionSetIds
                                             AND AssigneeId =: userId)];

            return userList.isEmpty() ? false : true;
        }
        catch(Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
}