public with sharing class OrderGetMilestoneExtension {
    public string sendStatus {get;set;}
	private ApexPages.StandardController standardController;
    public OrderGetMilestoneExtension(ApexPages.StandardController standardController)
    {
        this.standardController = standardController;
        this.sendStatus = '-';
    }
    public void getMilestone(){
        try
        {
            Id recordId = standardController.getId();
            OrderManagerIntegrationConnector conn = new OrderManagerIntegrationConnector();
            string statusRecieved = conn.getMilestones(recordId);
            Map<String, Object> mapObjectOrderOM = (Map<String, Object>)JSON.deserializeUntyped(statusRecieved);
            List<Object> ListObjectOM = (List<Object>)mapObjectOrderOM.get('milestones');
            String date1;
            String name1;
            for (Object ListObjectOMa : ListObjectOM)
            {
                Map<String, Object> mapObjectOrderOM1 = (Map<String, Object>)ListObjectOMa;
                String state1 = (String)mapObjectOrderOM1.get('state');
                if (state1 != 'SKIPPED')
                {
                    name1 = (String)mapObjectOrderOM1.get('name');
                    date1 = (String)mapObjectOrderOM1.get('updated');
                    break;
                }
            }
            if(name1 !=null && date1 !=null)
            {
                this.sendStatus = name1;
                List<Object> ListObjectOMb = (List<Object>)mapObjectOrderOM.get('nonMilestones');
                Map<String, Object> mapObjectOrderOM2 = (Map<String, Object>)ListObjectOMb[0];
                String date2 = (String)mapObjectOrderOM2.get('updated');
                if (date2>=date1)
                {
                    String name2 = (String)mapObjectOrderOM2.get('manualQueueName');
                    this.sendStatus += ' (La orden se encuentra en ' +  name2 + ')';
                }
            }
            system.debug ('sendStatus: ' + sendStatus);
        }
        catch(Exception e)
        {
            system.debug ('Error Status: ' + e);
            this.sendStatus = 'Se ha producido un error de conectividad, por favor reintente la operación.';
        }
    }
}