public class OVStepperController{
    private ApexPages.StandardController stdController;
    private final Order order;
    public Map<Integer,Map<String,String>> mapSteps {get;set;}
    
    public OVStepperController(ApexPages.StandardController stdController)
    {
        this.order = (Order)stdController.getRecord();
        Order ord = [SELECT Id, Status FROM Order WHERE Id =: order.Id];
        Schema.DescribeFieldResult fieldResult = Schema.Order.Status.getDescribe();
        List<Schema.PicklistEntry> statusValues = fieldResult.getPickListValues();
        mapSteps = new Map<Integer,Map<String,String>>();
        String strClass = 'step';
        String statusName = '';
        Integer intIndex = 0;
        for(Schema.PicklistEntry ple : statusValues)
        {
            Map<String,String> tempMap = new Map<String,String>();
            statusName = ple.getValue();
            if(ord.Status == statusName)
            {
                strClass = 'step active';
            }
            else   
            {
                strClass = 'step';
            }
            tempMap.put(statusName, strClass);
            mapSteps.put(intIndex, tempMap);
            intIndex++;
        }
    }

}