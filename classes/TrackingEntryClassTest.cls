@IsTest
public class TrackingEntryClassTest {
   @IsTest static void trakingEntrys(){
        
       Id ownerIdTest = UserInfo.getUserId(); 
       Test.startTest();
        vlocity_cmt__VlocityTrackingEntry__c TrackingEntry = new vlocity_cmt__VlocityTrackingEntry__c(Name = 'Test Campaign ',TrackedAction__c = 'Consulta de Comprobante',OwnerId = ownerIdTest);
        insert TrackingEntry;
		Test.stopTest();
		
		system.assertEquals('Consulta de Comprobante', TrackingEntry.TrackedAction__c);
		
   }
}