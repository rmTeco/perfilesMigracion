public with sharing class OrderController {

	public String orderIdOm { get; set; }
	public String orderNumberOm { get; set; }
    public String orderDateCreate { get; set; }
    public String orderDateModify { get; set; }
	public String orderOmState { get; set; }
	public  List<Object>  listMilestones  { get; set; }
	public  List<Object>  listTask  { get; set; }
	public String error { get; set; }


	public OrderController() {
		String jsonToProccess = getMilestones();
		getOrderConciliateOM(jsonToProccess);
	}

	public String getMilestones() {

		String paramsOrderId = ApexPages.currentPage().getParameters().get('orderID');
		String paramsOrderNumber = ApexPages.currentPage().getParameters().get('orderNum');

		this.orderNumberOm = paramsOrderNumber;
		this.orderIdOm = paramsOrderId;
		
		OrderManagerIntegrationConnector connector = new OrderManagerIntegrationConnector();

		String jsonOM = connector.getMilestones(paramsOrderId);

		return jsonOM;
	}

	public void getOrderConciliateOM( String jsonResult) {

		String getJson = jsonResult;

		if(getJson.contains('<')){
				this.error = (String)getJson;
		}else{ 
				
		  	Map<String, Object> mapObjectOrderOM = (Map<String, Object>)JSON.deserializeUntyped(getJson);

			String dateOri = (String) mapObjectOrderOM.get('created');
			String dateOriToFormat = dateOri.split('T')[0];
			String[] formatDateOri = dateOriToFormat.split('-');
			this.orderDateCreate = formatDateOri[2]+'-'+formatDateOri[1]+'-'+formatDateOri[0];

			String dateMod = (String) mapObjectOrderOM.get('lastTaskMovement');
			String dateModToFormat = dateMod.split('T')[0];
			String[] formatDateMod = dateModToFormat.split('-');
			this.orderDateModify = formatDateMod[2]+'-'+formatDateMod[1]+'-'+formatDateMod[0];

			this.orderOmState =  (String) mapObjectOrderOM.get('state');

			this.listMilestones = (List<Object>)mapObjectOrderOM.get('milestones');

			List<Object> toListTask = (List<Object>)mapObjectOrderOM.get('nonMilestones'); 
			List<Object>  newListTask = new List<Object>();
			
			for(Object a: toListTask){

			    Map<String, Object> mapListTask = new Map<String, Object>();
			    mapListTask = (Map<String, Object>)a ;
			    
			    if (mapListTask.get('falloutDetails')==null){
					mapListTask.put('falloutDetails', '');
			   	}

			    if (mapListTask.get('manualQueueName')==null){
					mapListTask.put('manualQueueName', '');
			   	}      	
				newListTask.add(mapListTask);

				this.listTask = newListTask;
			}
		}
	}

}