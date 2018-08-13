public class taSalesNominacionExtranjeroController{
    public String name{get;set;}
    public String document{get; set;}
    public String dueDate{get; set;}

    public taSalesNominacionExtranjeroController(){
        Id accountId = ApexPages.currentPage().getParameters().get('accountId');
         Account acc = [SELECT Name, DocumentNumber__c, vlocity_cmt__PrimaryContactId__r.PermanencyDueDate__c FROM Account WHERE Id =: accountId];
         name = acc.Name;
         document = acc.DocumentNumber__c;
         dueDate = String.valueOf(acc.vlocity_cmt__PrimaryContactId__r.PermanencyDueDate__c);
    }
}