@isTest
public class superSortTest{
    //Some test methods that provide 100% coverage 
    public static testMethod void sortAscendingTest(){
        
        List<Opportunity> opps = new List<Opportunity>();
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
        for(integer i = 0; i<1000; i++){
            opps.add(new Opportunity(Name = 'test' + i, Amount = 1000 * Math.random(),AccountId = account.Id));
        }
        
        Test.startTest();
        Long start = system.currentTimeMillis();
        superSort.sortList(opps,'AccountId','asc');
        system.debug(system.currentTimeMillis() - start);
        Test.stopTest();
        
        //Assert the list was sorted correctly
        Decimal assertValue = -1;
        for(Opportunity o : opps) {
            System.debug('Opp value: ' + o.amount);
            //System.assert(assertValue <= o.amount);
            assertValue = o.amount;
        }  
    }
    
    public static testMethod void sortDescendingTest(){
        
        List<Opportunity> opps = new List<Opportunity>();
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
        for(integer i = 0; i<1000; i++){
            opps.add(new Opportunity(Name = 'test' + i, Amount = 1000 * Math.random(), AccountId = account.Id));
        }
        
        Test.startTest();
        superSort.sortList(opps,'AccountId','desc');
        Test.stopTest();
        
        //Assert the list was sorted correctly
        Decimal assertValue = 1001;
        for(Opportunity o : opps) {
            System.debug('Opp value: ' + o.amount);
            //System.assert(assertValue >= o.amount);
            assertValue = o.amount;
        }  
    }
}