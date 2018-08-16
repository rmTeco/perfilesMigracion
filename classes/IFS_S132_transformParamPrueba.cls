global with sharing class IFS_S132_transformParamPrueba  {

    public IFS_S132_transformParamPrueba(){
        prueba();
    }

    public void prueba () {
        Map<String, Object> input = generateRequest ();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        System.debug('request IFS_S132: ' + JSON.serialize(input));
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S132', input, output, options);
        System.debug('response IFS_S132: ' + output);
    }

    private Map<String, Object> generateRequest () {
        System.debug('--- Estoy en generateRequest');
        Map<String, Object> body = new Map<String, Object>();
        Map<String, Object> request = new Map<String, Object>();

        body.put('idSolicitudWS', '2014111948818961');
        body.put('versionWS','1');
        body.put('nombreAppOrigen','FAN');
        body.put('userSolicitud','u582507');
        body.put('date','201410291531000');
        body.put('tipoValorConsulta','1');
        body.put('valorConsulta','541125648345');
        body.put('location','1');
        body.put('smsEncolado','1');
        body.put('autenticacion','1');
        body.put('autentication3g','1');
        body.put('camel','1');
        body.put('categoriasHSS','1');
        request.put('body', body);
        return request;
    }

}