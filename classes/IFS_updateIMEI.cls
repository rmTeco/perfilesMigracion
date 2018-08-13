@RestResource(urlMapping='/v1/integrationprocedure/updateIMEI/*')
global with sharing class IFS_updateIMEI {

    @HttpPost
    global static void getPost() {
        Http http = new Http();
        FromJSON jsonBody;
        Map<String, Object> resultado = null;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        res.addHeader('Content-Type', 'application/json');
        try {
            res.statuscode = 200;
            try {
                jsonBody = new FromJSON();
                jsonBody = (FromJSON)JSON.deserialize(req.requestBody.toString(), FromJSON.class);
            }
            catch (Exception e) {
                throw new CalloutException('Error al deserializar los parametros. Error: ' + e.getMessage());
            }    
            
            checkContrato (jsonBody); 

            res.responseBody = Blob.valueOf(JSON.serialize(updateIMEI(jsonBody)));
        }
        catch (FunctionalException fe) {
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',fe.getMessage())));
        }
        catch (CalloutException ce) {
            res.statuscode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('400',ce.getMessage())));
        }
        catch(Exception e){
            res.statuscode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('500',e.getMessage())));
        }
    }

    /**
     * Objetivo: Verificar que se cumpla el contrato.
     * Si lo cumple termina y sino dispara la excepción: CalloutException.
     */
    private static void checkContrato (FromJSON pJson) {
        System.debug('Entre a checkContrato()');

        if (pJson == null) {
            System.debug('El json vino vacio o nulo'); 
            throw new CalloutException('Error en la validacion de los atributos del request. La estructura request vino vacio.');
        }

        if (String.isBlank(pJson.numeroComprobante)) {
            System.debug('-------- El numero de comprobante vino nulo o vacio.'); 
            throw new CalloutException('Error en la validacion de los atributos del request. El campo numeroComprobante vino vacio.');
        }

        if (String.isBlank(pJson.codAcceso)) {
            System.debug('-------- El campo codAcceso vino nulo o vacio.'); 
            throw new CalloutException('Error en la validacion de los atributos del request. El campo codAcceso vino vacio.');
        }

        if (pJson.lstDetalle == null || pJson.lstDetalle.isEmpty()) {
            System.debug('-------- La lista de datos a actualizar vino nula o vacia.'); 
            throw new CalloutException('La lista de datos a actualizar vino nula o vacia.');
        }

        for (DetailClass details : pJson.lstDetalle) {
            if (details == null) {
                System.debug('-------- La lista de detalle contiene un componente nulo.'); 
                throw new CalloutException('La lista de detalle contiene un componente nulo.');
            }
            if (details.infoDetalleModificar == null) {
                System.debug('-------- La lista de detalle contiene un componente nulo.'); 
                throw new CalloutException('La lista de detalle contiene un componente nulo.');
            }

            if (details.infoDetalleModificar.datosAdicionales == null) {
                System.debug('-------- Datos Adicionales nulos.'); 
                throw new CalloutException('Datos Adicionales nulos.');
            }

            if (String.isBlank(details.infoDetalleModificar.codCargo)) {
                System.debug('-------- Codigo de cargo nulo.'); 
                throw new CalloutException('Codigo de cargo nulo.');
            }

            if (String.isBlank(details.infoDetalleModificar.secuenciaProd)) {
                System.debug('-------- La secuencia prod vino vacia.'); 
                throw new CalloutException(' La secuencia prod vino vacia.');
            }
        }
    }

    /**
     * @Objetivo: Actualizar el IMEI de la factura creada en Huawei.
     */
    private static Map<String, Object> updateIMEI(FromJSON pJson) {
        System.debug('Entre en updateIMEI()');
        Map<String, Object> inputMap = new Map<String, Object>();
        IFS_S451_class iParam = new IFS_S451_class();

        try {
            System.debug(pJson);

            iParam.numeroComprobante = pJson.numeroComprobante;
            iParam.codAcceso.codAccesoCuenta.codAccCuenta.idCuenta = pJson.codAcceso;
            iParam.impDiferida = 'N';
            iParam.impFiscal = 'Y';
            iParam.fechaAltaComprobante = getFormatToday();

            System.debug('----- Antes de recorrer lista items');

            for (DetailClass detalle : pJson.lstDetalle) {
                String nombre = detalle.infoDetalleModificar.datosAdicionales.datoAdicional.nombre;
                String valor = detalle.infoDetalleModificar.datosAdicionales.datoAdicional.valor;
                String codCargo = detalle.infoDetalleModificar.codCargo;
                String secuenciaProd = detalle.infoDetalleModificar.secuenciaProd;

                DetalleModificar detalleAM = new DetalleModificar();
                detalleAM.datosAdicionales = new List<DatosAdicionalesClass>();
                DatosAdicionalesClass datosAdicionales = new DatosAdicionalesClass();
                datosAdicionales.nombreParametro = nombre;
                datosAdicionales.valorParametro = valor;
                detalleAM.datosAdicionales.add(datosAdicionales);
                detalleAM.codCargo = codCargo;
                detalleAM.secuenciaProductoAdquirido = secuenciaProd;
                iParam.listaDetalleModificar.add(detalleAM);
            }

            return runIntegrationProcedure (iParam);
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString();
            System.debug('--------- Error al Actualizar el IMEI - ' + e.getMessage()); 
            System.debug('===========================================================================');
            System.debug(stackTrace);
            System.debug('===========================================================================');
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objetivo: Invocar el Integration Procedure IFS_S451.
     */
    private static Map<String, Object> runIntegrationProcedure (IFS_S451_class pIFSReq) {
        System.debug('Entre en runIntegrationProcedure');
        try {
            String jsonReq = JSON.serialize(pIFSReq);
            Map<String, Object> ifsReqMap = (Map<String, Object>)JSON.deserializeUntyped(jsonReq);
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            input.put('body', ifsReqMap);
            System.debug('----------------- JSON Input ----------------');
            System.debug(JSON.serialize(input));
            System.debug('---------------------------------------------');

            Map<String,Object> result = null;
            if(!Test.isRunningTest()){
                vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                integProcServ.invokeMethod('IFS_S451', input, output, options);
                result = (Map<String,Object>) output.get('IPResult');

                System.debug('----------------- Map Result ----------------');
                System.debug('result: ' + result);
                System.debug('---------------------------------------------');

                if (result != null && !result.isEmpty()) {
                    throw new CalloutException((String)result.get('mensaje'));
                }
            }
            return result;
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString();
            System.debug('===========================================================================');
            System.debug(stackTrace);
            System.debug('===========================================================================');
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objetivo: Arma la estructura de respuesta No Ok.
     */
    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        System.debug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }

    /**
     * @Objetivo: Devolver la fecha/hora actual en formato:
     *            yyyy-mm-dd hh:mi:ss
     */
    private static String getFormatToday() {
        Datetime d = Datetime.now();
        return d.year() + '-' + (d.month()<10?'0'+d.month():''+d.month()) + '-' + 
            (d.day()<10?'0'+d.day():''+d.day()) + ' ' + (d.hour()<10?'0'+d.hour():''+d.hour()) + ':' + 
            (d.minute()<10?'0'+d.minute():''+d.minute()) + ':' + (d.second()<10?'0'+d.second():''+d.second());
    }

    /**
     * Objetivo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {

    }

    private class FromJSON {
        public String numeroComprobante; 
        public String codAcceso;
        public List<DetailClass> lstDetalle;
    }

    private class DetailClass {
        public InfoDetailClass infoDetalleModificar;
    }

    private class InfoDetailClass {
        public AditionalDataClass datosAdicionales;
        public String codCargo;
        public String secuenciaProd;
    }

    private class AditionalDataClass {
        public DatoAdicionalClass datoAdicional;
        public AditionalDataClass() {
            datoAdicional = new DatoAdicionalClass();
        }
    }

    private class DatoAdicionalClass {
        public String nombre;
        public String valor;
    }

    //----------------- Estructura Servicio IFS_S451 ------------//
    private class IFS_S451_class {
        public String numeroComprobante;
        public CodAccessClass codAcceso;
        public List<DetalleModificar> listaDetalleModificar;
        public String impDiferida;
        public String impFiscal;
        public String fechaAltaComprobante;
        public IFS_S451_class () {
            codAcceso = new CodAccessClass();
            listaDetalleModificar = new List<DetalleModificar>();
        }
    }

    private class CodAccessClass {
        public CodAccCuentaClass codAccesoCuenta;
        public CodAccessClass () {
            codAccesoCuenta = new CodAccCuentaClass();
        }
    }

    private class CodAccCuentaClass {
        public AccesoCuenta codAccCuenta;
        public CodAccCuentaClass() {
            codAccCuenta = new AccesoCuenta();
        }
    }

    private class AccesoCuenta {
        public String idCuenta;
    }

    private class DetalleModificar {
        public String secuenciaProductoAdquirido;
        public String codCargo;
        public List<DatosAdicionalesClass> datosAdicionales;
        public DetalleModificar () {
            datosAdicionales = new List<DatosAdicionalesClass>();
        }
    }

    private class DatosAdicionalesClass {
        public String nombreParametro;
        public String valorParametro;
    }

}