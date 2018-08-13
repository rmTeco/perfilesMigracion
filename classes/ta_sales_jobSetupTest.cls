@isTest
public class ta_sales_jobSetupTest {

    @isTest static void scheduleAllTest() {
        //GIVEN
        
        //WHEN
        ta_sales_jobSetup.scheduleAll();
        
        //THEN
        System.assert(true);
        
    }
    
    @isTest static void taskTopicSetupTest() {
        //GIVEN
        PushTopic pushTopic = new PushTopic();
        pushTopic.Name = 'Test';
        pushtopic.Query = 'SELECT id, Type, TaskSubtype FROM Task';
        pushTopic.ApiVersion = 40.0;
        pushTopic.NotifyForOperationCreate = true;
        pushTopic.NotifyForOperationUpdate = true;
        pushTopic.NotifyForOperationUndelete = true;
        pushTopic.NotifyForOperationDelete = true;
        pushTopic.NotifyForFields = 'Referenced';
        insert pushTopic;
        
        //WHEN
        Test.startTest();
        ta_sales_jobSetup.taskTopicSetup();
        Test.stopTest();
        
        //THEN
        System.assert(true);
        
    }
}