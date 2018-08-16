@RestResource(urlMapping='/v1/integrationprocedure/activateNominatedService/*')
global with sharing class IFS_S437_activateNominatedService {

    private static final String K_TYPE_OF_JOB = 'Nominatividad';
    private static String guId = null;

    @HttpPost
    global static void getPost() {
        System.debug('Entre a getPost()');

        Http http = new Http();
        FromJSON jsonBody;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        res.addHeader('Content-Type', 'application/json');

        writeLog ('REQ', req.requestBody.toString());

        try {
            res.statuscode = 200;
            try {
                jsonBody = new FromJSON();
                jsonBody = (FromJSON)JSON.deserialize(req.requestBody.toString(), FromJSON.class);
            }
            catch (Exception e) {
                throw new CalloutException('Error al deserializar los parametros. Error: ' + e.getMessage());
            }    

            validateContrato(jsonBody);

            jsonBody = transforValue(jsonBody);

            insertInBatchQueue(getInputMap (jsonBody));

            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaOk()));
        }
        catch (FunctionalException fe) {
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',fe.getMessage())));
        }
        catch (CalloutException ce) {
            res.statuscode = 404;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('404',ce.getMessage())));
        }
        catch(Exception e){
            res.statuscode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('500',e.getMessage())));
        }

        writeLog ('RES', res.statuscode + ';' + EncodingUtil.base64Decode(EncodingUtil.base64Encode(res.responseBody)).toString());

    }    

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pDatos) {
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            IFS_LogRecord.record(dts, 'SERVICIO', 'S437', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S437', pTipo, guId, '', pDatos);  
        }
    }

    private static Map<String, Object> getRespuestaOk() {
        System.debug('Entre a getRespuestaOk()');

        Map<String, Object> mapa  = new Map<String, Object>();
        Map<String, Object> mapa1 = new Map<String, Object>();

        mapa.put('validateMaxLinesXDoc', mapa1);
        mapa1.put('respuesta', 'Datos actualizados');

        return mapa;   
    }

    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        System.debug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }

    /*
     * Objetivo: validar que los campos obligatorios no
     *           vengan vacios.
     */
    private static void validateContrato (FromJson pJson) {
        System.debug('Entre a validateContrato()');
        final String K_TYPE_OF_DOCUMENT = 'CUIT,CUIL,DNI,LC,LE,CI,PASAPORTE,CIU,PAU';
        final String K_TYPE_OF_GENERO = 'M,F';
        final String K_FORMAT_OF_FECHA = '^[0-9]{4}-([0][1-9]|[1][012])-([0][1-9]|[12][0-9]|[3][01])';

        if (pJson.activateNominatedService == null) {
            throw new CalloutException('Request invalido, Error en la validacion del JSON.');
        }

        if (String.isBlank(pJson.activateNominatedService.nroLinea)) {
            throw new CalloutException('Request invalido, nroLinea vino vacio');
        }

        if (String.isBlank(pJson.activateNominatedService.numeroDocumento)) {
            throw new CalloutException('Request invalido, numeroDocumento vino vacio');
        }
        
        if (String.isBlank(pJson.activateNominatedService.tipoDocumento)) {
            throw new CalloutException('Request invalido, tipoDocumento vino vacio');
        }
        else {
            if (K_TYPE_OF_DOCUMENT.indexOf(pJson.activateNominatedService.tipoDocumento)==-1) {
                throw new CalloutException('Request invalido, Tipo de Documento invalido [' + 
                pJson.activateNominatedService.tipoDocumento + '] - Tipos validos: [' + K_TYPE_OF_DOCUMENT + ']');
            }
        }
        
        if (String.isBlank(pJson.activateNominatedService.nombre)) {
            throw new CalloutException('Request invalido, nombre vino vacio');
        }

        if (String.isBlank(pJson.activateNominatedService.apellido)) {
            throw new CalloutException('Request invalido, apellido vino vacio');
        }

        if (String.isBlank(pJson.activateNominatedService.genero)) {
            throw new CalloutException('Request invalido, genero vino vacio');
        } else {
            if (K_TYPE_OF_GENERO .indexOf(pJson.activateNominatedService.genero)==-1) {
                throw new CalloutException('Request invalido, genero invalido [' + 
                pJson.activateNominatedService.genero + '] - Tipos validos: [' + K_TYPE_OF_GENERO + ']');
            }
        }

        if (String.isBlank(pJson.activateNominatedService.fechaNacimiento)) {
            throw new CalloutException('Request invalido, fechaNacimiento vino vacio');
        } else {
            if (!(Pattern.matches(K_FORMAT_OF_FECHA, pJson.activateNominatedService.fechaNacimiento))) {
                throw new CalloutException('Request invalido, fechaNacimiento con formato invalido [' + 
                pJson.activateNominatedService.fechaNacimiento + '] - Formato valido: [ YYYY-MM-DD ]');
            }
        }
    }

    /*
     * Objetivo: Transformar los valores de los datos del request
     *           por los utilizados en las API de Vlocity 
     */
    private static FromJson transforValue (FromJson pJson) {
        System.debug('Entre a transforValue ()');
        pJson.activateNominatedService.fechaNacimiento = pJson.activateNominatedService.fechaNacimiento.substring(8,10) + '/' +
        pJson.activateNominatedService.fechaNacimiento.substring(5,7) + '/' + pJson.activateNominatedService.fechaNacimiento.substring(0,4);
        pJson.activateNominatedService.genero = ((pJson.activateNominatedService.genero == 'M') ? 'Masculino' : 'Femenino');
        return pJson;
    }

    /**
     * Objetivo: Recibo la clase que contiene los datos del request
     * y genero el Map que requiere la API desarrollada para insertar
     * el registro que luego tomará otro proceso.
     */
    private static Map<String, Object> getInputMap (FromJSON pJson) {
        System.debug('Entre a getInputMap()');

        if (pJson.activateNominatedService == null) {
            throw new FunctionalException('El request esta vacio o nulo');
        }

        System.debug('..... instancio la clase ToJson()');
        ToJson toJson = new ToJson();
        toJson.typeOfJob = K_TYPE_OF_JOB;
        toJson.lines.add(pJson);
        
        System.debug('..... serializo la clase ToJson()');
        String ljson = JSON.serialize(toJson);

        System.debug('..... desserializo el string json en Map<String, Object>');
        Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(ljson);
        return result;
    }

    /**
     * Objetivo: Insertar en la cola batch el mapa recibido.
     */
    private static void insertInBatchQueue (Map<String, Object> pMapa) {
        System.debug('Entre a insertInBatchQueue()');

        try {
            System.debug('..... instancio la clase xOMBatchLines ()');
            System.debug('Mapa: '+ pMapa);
            if(!Test.isRunningTest()){
                xOMBatchLines.ResultObj result = xOMBatchLines.generateBatchJobsFromJSONUntyped(pMapa);
                if (result.resultCode != 200) {
                    throw new FunctionalException(result.resultMessage);
                }
            }    
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * Objeti|vo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {

    }

    
    private class FromJson {
        public NominatedTag activateNominatedService;
    }

    private class ToJson {
        public ToJson () {
            lines = new List<FromJson>();
        }
        public String typeOfJob;
        public List<FromJson> lines;
    }

    private class NominatedTag {
        public String codCliente;
        public String ticket;
        public String nroLinea;
        public String numeroDocumento;
        public String tipoDocumento;
        public String codUsuario;
        public String nombre;
        public String apellido;
        public String genero;
        public String fechaNacimiento;
        public String marcaExistenciaPadron;
        public String calle;
        public String altura;
        public String piso;
        public String departamento;
        public String descripcionLocalidad;
        public String codigoPostal;
        public String descripcionProvincia;
        public String codPais;
        public String tipoDireccion;
        public String marcaDireccionVerificada;
        public String codAccionNegocio;
    }

}