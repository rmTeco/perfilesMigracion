@isTest
public class TrackingEntriesMaintenanceJobTest {

    @TestSetup
    public static void createTrackingEntry(){
            
        vlocity_cmt__VlocityTrackingEntry__c vte = new vlocity_cmt__VlocityTrackingEntry__c(Name = 'Test');
        insert vte;
        
        Datetime lessThanYesterday = Datetime.now().addDays(-3);
        Test.setCreatedDate(vte.Id, lessThanYesterday);
    }
    
    @isTest
    public static void TrackingEntriesMaintenanceTest(){
        
        Test.startTest();
        TrackingEntriesMaintenanceJob temj = new TrackingEntriesMaintenanceJob();
        Id batchprocessid = Database.executeBatch(temj);

        Test.stopTest();
        
        System.assert(batchprocessid!=null);
        
        
    }
}