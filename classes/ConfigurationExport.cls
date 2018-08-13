public class ConfigurationExport {
    
    public List<Contact_Motive__c> configuration{get; set;}
    public List<Product2> services{get; set;}
    public List<Contact_Motive__c> motives{get; set;}
    
    public ConfigurationExport(ApexPages.StandardController stdController)
    {
        configuration = new List<Contact_Motive__c>();
        
        for (Contact_Motive__c cfg : [SELECT Id_Service__r.Name, Name, Is_Associable__c, Is_Associable_Text__c
                                      FROM Contact_Motive__c
                                      WHERE Is_Active__c = true
                                      AND Id_Service__r.IsActive = true
                                      AND Id_Service__r.Family = 'Service Plan'
                                      AND RecordType.DeveloperName = 'Contact_Motive'
                                      ORDER BY Id_Service__r.Name, Name])
        {
            configuration.add(cfg);
        }
        
        services = new List<Product2>();
        
        for (Product2 srv : [SELECT Name, IsActive, Is_Active_Text__c
                             FROM Product2
                             WHERE Family = 'Service Plan'
                             ORDER BY Name])
        {
            services.add(srv);
        }
        
        motives = new List<Contact_Motive__c>();
        
        for (Contact_Motive__c mtv : [SELECT Name, Is_Active__c, Is_Active_Text__c
                                      FROM Contact_Motive__c
                                      WHERE RecordType.DeveloperName = 'Contact_Motive'
                                      ORDER BY Name])
        {
            motives.add(mtv);
        }
    }
}