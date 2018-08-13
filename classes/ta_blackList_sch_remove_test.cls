@isTest
public class ta_blackList_sch_remove_test{
	@isTest Static Void testschedule(){
        ta_blackList_sch_remove m = new ta_blackList_sch_remove();
		String sch = '0 28 11 * * ?';

        test.startTest();
        String jobID = system.schedule('Blacklist Auto Remove', sch, m);
       	test.stopTest();
    }
}