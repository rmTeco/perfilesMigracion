@IsTest
public class TrackingEntryClassTest {
   @IsTest static void trakingEntrys(){
       //TrackingEntryClass trackEntry = new TrackingEntryClass();
        /*List<vlocity_cmt__VlocityTrackingEntry__c> ListTrackEntry = TestDataFactory.createTrackingEntry(1);
        
        ListTrackEntry[0].TrackedAction__c = 'Consulta de Comprobante';
        ListTrackEntry[0].OwnerId = '0056C000000txC2';
        system.debug('ListTrackEntry[0] = '+ListTrackEntry[0]);*/
        
        Test.startTest();
        vlocity_cmt__VlocityTrackingEntry__c TrackingEntry = new vlocity_cmt__VlocityTrackingEntry__c(Name = 'Test Campaign ',TrackedAction__c = 'Consulta de Comprobante',OwnerId = '0056C000000txC2');
        insert TrackingEntry;
		Test.stopTest();
		
		system.debug('TrackingEntry = '+TrackingEntry);
		//Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(ListTrackEntry[0].vlocity_cmt__Data__c);
		//Id workUser = responseNode.get('workTeamUser');
		//system.debug('workUser = '+responseNode.get('workTeamUser'));
		
		system.assertEquals('Consulta de Comprobante', TrackingEntry.TrackedAction__c);
		
   }
}