public with sharing class IFS_Prueba {

    public IFS_Prueba() {
        callIntegrationProcedure ();
        callIntegrationProcedure ();
    }

    /**
     * @Objetivo: Realiza el llamado al Integration Procedure.
     */
    public void callIntegrationProcedure () {
        try {
            Map<String,Object> inMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> optMap = new Map<String,Object>();

			Map<String, Object> bodyMap = (Map<String, Object>)JSON.deserializeUntyped('{"infoDeducTarifas":[{"codMoneda":"ARS","precioCargo":"20.5000","fechaVenta":"2018-08-01 10:00:43","codCargo":"C_OT_MB_ADMINISTRATIVOS","secuenciaProductoAdquirido":"1"}],"objDeduccion":{"codAccesoSuscriptor":{"identificadorRecurso":"477747777"}}}');

            inMap.put('body', bodyMap);
            System.debug('inMap --> ' + JSON.serialize(inMap));

            vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
            
            if (integProcService == null) {
                throw new CalloutException('Fallo al instanciar el servicio de integracion: IntegrationProcedureService');
            }

            Object resp = integProcService.invokeMethod('IFS_S298', inMap, outMap, optMap);
            try {

                System.debug('resp --> ' + resp );
                System.debug('outMap --> ' + JSON.serialize(outMap));
                System.debug('optMap --> ' + JSON.serialize(optMap));

                Map<String, Object> response = (Map<String, Object>)outMap.get('IPResult');
                System.debug('IPResult (Map<String, Object>) --> ' + response);
            }
            catch (TypeException te) {
                Object response = (Object)outMap.get('IPResult');
                System.debug('IPResult (String) --> ' + response);
                throw new CalloutException(te.getMessage());
            }
            catch (Exception e) {
                throw e;
            }
        }
        catch (Exception e) {
            System.debug('Error al invocar el integration procedure IFS_S298 - Error: ' + e.getMessage());
            System.debug(e.getStackTraceString());
            throw new CalloutException(e.getMessage());
        }
    }

}