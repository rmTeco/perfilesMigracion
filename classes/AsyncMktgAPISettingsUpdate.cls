public class AsyncMktgAPISettingsUpdate implements Queueable{
    
    private MktgCloudAPISettings__c mktgAPISettings;
    
    public AsyncMktgAPISettingsUpdate(MktgCloudAPISettings__c mktgAPISettings){
        this.mktgAPISettings = mktgAPISettings;
    }
    
    public void execute(QueueableContext context) {
        update mktgAPISettings; 
    }
}