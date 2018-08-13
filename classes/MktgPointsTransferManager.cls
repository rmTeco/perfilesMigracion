global with sharing class MktgPointsTransferManager implements vlocity_cmt.VlocityOpenInterface{
	global MktgPointsTransferManager() {}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true; 

        try{
            if (methodName.equals('getPointsCP')){
                getPointsCP(inputMap, outMap);
            }
            if (methodName.equals('transferPoints')){
                transferPoints(inputMap, outMap);
            }
        }catch(Exception e){
            System.debug('MktgPointsTransferManager:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

   public void getPointsCP (Map<String, Object> inputMap, Map<String, Object> outMap) {
        String accountId = (String) inputMap.get('ContextId');

        System.debug('accountId ' + accountId);

        GP_adapter adapter = new GP_adapter();
        Map<String, Object> pointsResult = new Map<String, Object>();
        Map<String, Object> serviceAccounts = new Map<String, Object>();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> memberData = new Map<String, Object>();
        memberData.put('titularID',accountId);
        memberData.put('subscriptorID','0');
        input.put('datosSocio',memberData);
        try{
            adapter.consultarPuntos(input, pointsResult);
        }catch(Exception e){
            System.debug('getPointsCP:invokeMethod -> exception: '+e);
        }
        outMap.put('getPointsCPResult', pointsResult.get('resultadoSaldoTotal'));
   }

   public void transferPoints (Map<String, Object> inputMap, Map<String, Object> outMap) {
        GP_adapter adapter = new GP_adapter();

        Map<String,Object> transferenciaDePuntos = (Map<String,Object>) inputMap.get('TransferenciadePuntos');

        Double puntosTransferir = Double.valueOf(transferenciaDePuntos.get('PuntosTransferir'));
   		String titularDesde = (String) inputMap.get('ContextId');

		List<Object> SelectableServiceAccounts = VlocityOpenInterfaceHelper.getListObjectsFromMap(transferenciaDePuntos,'SelectableServiceAccounts');
		Map<String, Object> mso = (Map<String, Object>) SelectableServiceAccounts.get(0);
		Object idCuentaDesde = mso.get('idCuenta');

		List<Object> DestinationServiceAccounts = VlocityOpenInterfaceHelper.getListObjectsFromMap(transferenciaDePuntos,'DestinationServiceAccounts');
		Map<String, Object> msd = (Map<String, Object>) DestinationServiceAccounts.get(0);
		Object idCuentaHacia = msd.get('idCuenta');
		Object puntosSocioHacia = msd.get('puntosSocio');

		String suscriptorDesde = (String)idCuentaDesde;
		String suscriptorHacia = (String)idCuentaHacia;

		if(suscriptorDesde == titularDesde){
			suscriptorDesde = '0';
		}else if(suscriptorHacia == titularDesde){
			suscriptorHacia = '0';
		}

		Map<String, Map<String, Object>> input = new Map<String, Map<String, Object>>();
		Map<String, Object> inputParams = new Map<String, Object>();
		inputParams.put('titularIDdesde', titularDesde);
		inputParams.put('suscriptorDesde', suscriptorDesde);
		inputParams.put('suscriptorHacia', suscriptorHacia);
		inputParams.put('puntos', puntosTransferir);

		input.put('datosTransferirPuntos', inputParams);

		System.Debug('input ' + input);

		Map<String, Object> output = new Map<String, Object>();
        try{
            adapter.transferirPuntos(input, output);
        }catch(Exception e){
            System.debug('transferPoints:invokeMethod -> exception: '+e);
        }
   }

    public class datosTransferirPuntos{
        public String titularIDdesde {get;set;}
        public String suscriptorDesde {get;set;}
        public String suscriptorHacia {get;set;}
        public Double puntos {get;set;}
    }
}