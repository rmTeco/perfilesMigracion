public with sharing class ta_Care_SendSms  {

	@InvocableMethod
	public static void getCase(List<Case> CaseFromPB) {

        System.debug('Case from tech_OS');
		System.debug(CaseFromPB);
		List <String> AssetsPorConsultar 		= new List <String> ();
		List <Asset> AssetsConsultados  		= new List <Asset> ();
		// List <Campaign> CampaniasConsultadas 	= new List <Campaign> ();
		// List <String> CampaniasporConsultar 	= new List <String> ();
		List <String>  ContactosPorConsultar 	= new List <String> ();
		List <Contact> ContactoConsultados  	= new List <Contact> ();
		Map<String, Object> outMap 				= new Map<String, Object>();
        Map<String, Object> options 			= new Map<String, Object>();
		
		String communicationText 				= '';
		String msg1								= 'Te informamos que tu Gestión con el número';
		String msg2								= ' por (*AJUSTE UNIDAD o MONTO*) ha sido Aprobada';
		String msg3								= ' por (*AJUSTE UNIDAD o MONTO*) ha sido Rechazada';
		String msg4								= 'Para mayor información diríjase al portal Mi Cuenta de Telecom Personal.';

		for(Case lstCase : CaseFromPB)
		{
			if(lstCase.ContactId != null){
				ContactosPorConsultar.add(lstCase.ContactId);
			}
			// if(lstCase.Campaign__c != null){
			// 	CampaniasporConsultar.add(lstCase.Campaign__c);
			// }

			//CampaniasConsultadas  = consultaCampania(CampaniasporConsultar);
			
		

			if(lstCase.Status 	== 'Realizada exitosa'){
				communicationText	= 	msg1 + ' ' +  lstCase.CaseNumber +' '+ msg2 +' '+  msg4;
										

			}
			 if(lstCase.Status 	== 'No se pudo realizar')
			{
				communicationText	= 	msg1 + ' ' + lstCase.CaseNumber + ' ' + msg3 + ' ' +  msg4;
			}

			ContactoConsultados =  consultaContacto(ContactosPorConsultar);
			System.debug('Contactos ' + ContactoConsultados);
			System.debug('mensaje a enviar  ' + communicationText);



			communicationText	= 	msg1 + lstCase.CaseNumber + msg3 +  msg4;
			String jsonString = '{"params": {"nroLinea": "ContactoConsultados.Phone"},"body": {"bodyFullCodeName": "string","campaignName":"'+SMSSender__c.getInstance('S-Confirmacion-SMS').Sender__c+'","channelName": "SMS","communicationDate": "2017-05-04T02:29:43","communicationText": "string","messageReference": "string","target": {"rawdata": [{"key": "string","value": "string"}],"user": {"customerNumber": 0,"lastName": "string","mail": "string","name": "string"}}}}';
			Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
			SendSMSInvoke objIntegration = new SendSMSInvoke();
			objIntegration.invokeMethod('sendSmsIntegration', input, outMap,options);
		}

}

//Método que se utiliza si enviamos el phone desde el contacto
private static List<Contact> consultaContacto(List <String> ContactosPorConsultar )
{

	List<Contact> lstContactosRetornados = [SELECT Id, Phone
	FROM Contact
	WHERE Id in :ContactosPorConsultar ];

	return lstContactosRetornados;

} 


//Método que se utilzaria si el parámetro a enviar fuera LineNumber
// private static List<Asset> consultaAssets(List <String> AssetsPorConsultar )
// {

// 	List<Asset> lstAssetRetornados = [SELECT Id, MSISDN__c 
// 	FROM Asset
// 	WHERE Id in :AssetsPorConsultar ];

// 	return lstAssetRetornados;

// } 

// private static List<Campaign> consultaCampania(List <String> campaniasPorConsultar )
// {

// 	List<Campaign> lstCampaniasRetornadas = [SELECT Id, Name 
// 	FROM Campaign
// 	WHERE Id in :campaniasPorConsultar ];

// 	return lstCampaniasRetornadas;

// }

//  global static Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
//         Boolean result = true;
        
//         try {
//             if (methodName.Equals('sendSmsIntegration')) {
//                 sendSmsIntegration(inputMap, outMap, options);
//             } 
//         }
//         catch(Exception ex) { outMap.put('error', ex.getStackTraceString()); result = false; }
//         return result;
//     }
    
//     global void sendSmsIntegration(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
//         // Vlocity Integration Procedure Obj
//         vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
//         // Getting S141 data from IP 
//         if(!Test.isRunningTest()){
//         	integProcServ.invokeMethod('IFS_S159', inputMap, outMap, options);
//         }

        
//     }

}