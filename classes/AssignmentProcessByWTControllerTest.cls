public class AssignmentProcessByWTControllerTest {

}

/*@isTest
public class SegmentByProductControllerTest {
    static testMethod void myUnitTest(){
        SegmentByProduct__c segment1 = new SegmentByProduct__c(Name = '01', ProductFamily__c = 'Bundle', SegmentLevel1__c = 'Alta reciente', SegmentLevel2__c = 'TV');
        SegmentByProduct__c segment2 = new SegmentByProduct__c(Name = '02', ProductFamily__c = 'Device', SegmentLevel1__c = 'Alta reciente', SegmentLevel2__c = 'Masivo');
        SegmentByProduct__c segment3 = new SegmentByProduct__c(Name = '03', ProductFamily__c = 'Fixed', SegmentLevel1__c = 'Alta reciente', SegmentLevel2__c = 'Sólo Movil');
        insert segment1;
        insert segment2;
        insert segment3;
        
        Test.StartTest(); 
        PageReference pageRef1 = Page.SegmentByProductLandingPage; 
        SegmentByProductLandingController cont1 = new SegmentByProductLandingController();
        cont1.EditSegment();
        PageReference newpage = new Pagereference('/apex/SegmentByProductPage?Id=' + segment1.Id);
        SegmentByProductPageController cont2 = new SegmentByProductPageController();
        segment1.ProductFamily__c = 'Device';
        segment1.SegmentLevel2__c = 'Sólo Movil';
        cont2.doSave();
        cont1.DeleteSegment();
        cont1.newProfile();
        cont2.doCancel();
        Test.StopTest();
    }
}*/