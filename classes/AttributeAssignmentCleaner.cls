global class AttributeAssignmentCleaner{

@future
public static void cleaner(){
delete [SELECT Id FROM vlocity_cmt__AttributeAssignment__c WHERE vlocity_cmt__CategoryCode__c LIKE 'FAN%' LIMIT 500];
}
}