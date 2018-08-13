/**
 * Created by Alex Lazarev 13/11/2017
 *
 * Implements VlocityOpenInterface
 * Provides the needed logic to support OS JSON VOI translation
 *
 * Objects: None - JSON translation for OS
 *
 * Important: The method uses a VlocityOpenInterface integration structure
 *
 * Version: 1.1
 */

public with sharing class ta_care_queryFreeUnitsHandler implements vlocity_cmt.VlocityOpenInterface {

	public ta_care_queryFreeUnitsHandler(){}

	public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
		Boolean result = true;

		try {
			if (methodName.Equals('GetProductsFreeUnits')) {
				GetProductsFreeUnits(inputMap, outMap, options);
			}
		}
		catch(Exception ex) {outMap.put('error', ex.getStackTraceString()); result = false; }
		return result;
	}

	public void GetProductsFreeUnits(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

		// Vlocity Integration Procedure Obj
		vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();

		// Getting S441 data from IP
		integProcServ.invokeMethod('IFS_S441', inputMap, outMap, options);
		System.debug('outputMap: ' + outMap);
		//Map<String,Object> respQFU = (Map<String,Object>) outMap.get('IPResult');
		//System.debug('Map<String,Object> responseCBS: ' + respQFU);

	}

	/*public void queryFreeUnitsCallTester(String event){
		Map<String,Object> inputMap = new Map<String, Object>();
		Map<String,Object> outMap = new Map<String, Object>();
		Map<String,Object> options = new Map<String, Object>();

		Object arg1 = (Object)'{"codigoAccesoCliente":{"identificadorRecurso":"1234","idCliente":"string","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}}';
		Object arg2 = (Object)'{"codProducto":"string","secuenciaProductoAdquirido":"string"}';
		Object argsOK = (Object)'{"objConsulta":{"codigoAccesoCliente":{"identificadorRecurso":"1234","idCliente":"string","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}},"codigoDeProducto":{"codProducto":"string","secuenciaProductoAdquirido":"string"}}';
		Object argsERROR = (Object)'{"objConsulta":{"codigoAccesoCliente":{"identificadorRecurso":"0000","idCliente":"string","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}},"codigoDeProducto":{"codProducto":"string","secuenciaProductoAdquirido":"string"}}';


		//inputMap.put('codigoDeProducto',arg2);
		if(event=='OK'){
			inputMap.put('body',argsOK);
		} else if(event=='ERROR'){
			inputMap.put('body',argsERROR);
		}

		System.debug('Inputmap: ' + inputMap);

		GetProductsFreeUnits(inputMap, outMap, options);
	}*/

}