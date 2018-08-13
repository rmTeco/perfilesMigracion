public class taSalesNominacionArgentinoController{
    public String day{get;set;}
    public String month{get;set;}
    public String year{get;set;}
    public String name{get;set;}
    public String document{get; set;}
    public String address{get;set;}
    public String city{get;set;}
    public String postal{get;set;}
    public String taxCon{get;set;}
    public String phone{get;set;}

    public taSalesNominacionArgentinoController(){
        Date thisDate = Date.today();
        day = String.valueOf(thisDate.day());
        month = String.valueOf(thisDate.month());
        year = String.valueOf(thisDate.year());
        Id accountId = ApexPages.currentPage().getParameters().get('accountId');
        Account acc = [SELECT Name, DocumentType__c, DocumentNumber__c, BillingStreet, BillingCity, BillingPostalCode, TaxCondition__c, Phone FROM Account WHERE Id =: accountId];
        name = acc.Name;
        document = acc.DocumentType__c + ' ' + acc.DocumentNumber__c;
        address = acc.BillingStreet;
        city = acc.BillingCity;
        postal = acc.BillingPostalCode;
        taxCon = acc.TaxCondition__c;
        phone = acc.Phone;

    }

}