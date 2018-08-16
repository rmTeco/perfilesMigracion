global with sharing class AssetOrderConciliate {

	public String orderIdOm { get; set; }
	public String orderNumberOm { get; set; }
    public String orderDateCreate { get; set; }
    public String orderDateModify { get; set; }
	public String orderOmState { get; set; }
	public  List<Object>  listMilestones  { get; set; }
	public  List<Object>  listTask  { get; set; }

	
	public AssetOrderConciliate() {
		String paramsOrderId = ApexPages.currentPage().getParameters().get('orderID');
		String paramsOrderNumber = ApexPages.currentPage().getParameters().get('orderNum');

		this.orderNumberOm = paramsOrderNumber;
		this.orderIdOm = paramsOrderId;

        String url ='https://ui.dev.ta.xom.vloc-dev.com/security/v1/login';

		Map<String, String> params = new Map<String, String>();
        params.put('name', 'admin');
        params.put('password', 'vlocity');

 		String jsonParams = JSON.serialize(params);
        
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint(url); 
        req.setHeader('Content-Type','application/json'); 
        req.setBody(jsonParams);

        req.setMethod('POST'); 
        Http http = new Http(); 
        HTTPResponse res = http.send(req);


		String thorSession = res.getHeader('Set-Cookie'); 

		String urlSendOrderID ='https://api.dev.ta.xom.vloc-dev.com/ordermanagement/v1/orderMilestoneInfo/'+paramsOrderId;
	    HttpRequest req1 = new HttpRequest();
	    req1.setEndpoint(urlSendOrderID);
	    req1.setMethod('GET');
	    req1.setHeader('Cookie', thorSession);
	    Http http1 = new Http();
	    HTTPResponse res1 = http1.send(req1);

	    String jsonResult = res1.getBody();
		//'{"created":"2018-05-14T15:26:15.023674Z","lastTaskMovement":"2018-05-14T15:26:35.350620Z","state":"IN_PROGRESS","milestones":[{"name":"Dispatch confirmation order","updated":"2018-05-14T15:26:34.475432Z","state":"SKIPPED"},{"name":"En progreso | Assets Instanciados","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"En progreso | Comptel - Envio de Activación de Servicios","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"En progreso | Comptel - Servicios Activados","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"En progreso | Huawei - Envío Creación del Suscriptor","updated":"2018-05-14T15:26:34.828930Z","state":"COMPLETED"},{"name":"En progreso | Huawei - Suscriptor Creado","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"En progreso | Inicio de la Orden","updated":"2018-05-14T15:26:32.703314Z","state":"COMPLETED"},{"name":"En progreso | Numeración Móvil - Iniciando Actualizacion de Inventario","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"En progreso | Numeración Móvil - Inventario Actualizado","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"Fin de la orden","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"Fin provisión","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"Inicio provisión","updated":"2018-05-14T15:26:34.618998Z","state":"SKIPPED"},{"name":"New mobile line orchestration started","updated":"2018-05-14T15:26:33.596575Z","state":"SKIPPED"},{"name":"NMU Validation","updated":"2018-05-14T15:26:34.196550Z","state":"SKIPPED"}],"nonMilestones":[{"name":"CreateSubscriber - S203","updated":"2018-05-14T15:26:15.023674Z","state":"FATALLY_FAILED","falloutDetails":"2018-05-14 15:29:57.721008+00 fatally failed: non-successful HTTP response code: 400","manualQueueName":"Inbox Tecnico"},{"name":"CRM Order Item Line Courier Id Track Id Updated","updated":"2018-05-14T15:26:34.691351Z","state":"SKIPPED","falloutDetails":null,"manualQueueName":null},{"name":"CRM Request News from Delivery","updated":"2018-05-14T15:26:34.637236Z","state":"SKIPPED","falloutDetails":null,"manualQueueName":null},{"name":"CRM Sales invoice request","updated":"2018-05-14T15:26:34.377175Z","state":"SKIPPED","falloutDetails":null,"manualQueueName":null},{"name":"Envío de Activación de Servicios a la Red","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"Generate Huawei Id","updated":"2018-05-14T15:26:35.350620Z","state":"COMPLETED","falloutDetails":null,"manualQueueName":null},{"name":"PreActivate mobile services request","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"Update assets","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"Update mobile billing information","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"Update mobile rating step 2","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"updateNumberStatus - S326","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"Waiting for Updates","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null}]}';
		
	  	Map<String, Object> mapObjectOrderOM = (Map<String, Object>)JSON.deserializeUntyped(jsonResult);

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
		}
		
		this.listTask = newListTask;
	}

}