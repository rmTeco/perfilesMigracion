@isTest
public class workTeamHandlerTestTest {

    @isTest
    static void insertWorkTeamTest() {
        //insert work team
        WorkTeam__c myWT = New WorkTeam__c (Name='PruebaWT33', Team_Name__c='PruebaWT33');
        insert myWT;
            
    }
}