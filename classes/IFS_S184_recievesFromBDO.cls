@RestResource(urlMapping='/v1/integrationprocedure/CustomerCare_Portability_recievesFromBDO/*')
global with sharing class IFS_S184_recievesFromBDO {

    public static final boolean K_DEBUG_ON =  true;
    private static String guId = null;

    @HttpPost
    global static void getData() {
        FromJSON jsonBody;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        Map<String, Object> result = new Map<String, Object>();
        Map<String, Object> result1 = new Map<String, Object>();
        Long nroSolicitudPortacion;


        res.addHeader('Content-Type', 'application/json');
        try {
            
            writeLog ('REQ', req.requestBody.toString());

            res.statuscode = 200;
            jsonBody = (FromJSON)JSON.deserialize(req.requestBody.toString(),FromJSON.class);
            if (jsonBody == null) {
               throw new CalloutException('El request vino nulo');
            }

            printDebug('paso 1 : antes de entrar  a  checkContrato----->');
            checkContrato(jsonBody);
            printDebug('paso N : despues de salir de checkContrato----->');
               
            nroSolicitudPortacion = jsonBody.requestFromBDO.nroSolicitudPortacion;
            Case caso = getCase (jsonBody);
            if (caso != null){
                IF (caso.Area__c == jsonBody.requestFromBDO.estadoProcesoPortacion && caso.Subarea__c == jsonBody.requestFromBDO.subEstadoProcesoPortacion){
                    throw new IPException();
                } else {
                    actualizarCaso(jsonBody, caso);
                }
            } else {
                insertarCasoRedireccionar(jsonBody);
            }

            result.put('nroSolicitudPortacion',nroSolicitudPortacion);
            res.responseBody = Blob.valueOf(JSON.serialize(result));

            writeLog ('RES', res.statuscode + ';' + JSON.serialize(result));
        }
        catch (FunctionalException fe) {
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',fe.getMessage())));
            writeLog ('RES', res.statuscode + ';' + getRespuestaNoOk('417',fe.getMessage()));
        }
        catch (CalloutException ce) {
            res.statuscode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('400',ce.getMessage())));
            writeLog ('RES', res.statuscode + ';' + getRespuestaNoOk('400',ce.getMessage()));
        }
        catch (IPException e) {
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('184-01','Mensaje ya enviado')));
            writeLog ('RES', res.statuscode + ';' + getRespuestaNoOk('184-01','Mensaje ya enviado'));
        }
    }

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pDatos) {
        printDebug('Entre en writeLog - pTipo --> ' + pTipo + ' - pDatos --> ' + pDatos);
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            IFS_LogRecord.record(dts, 'SERVICIO', 'S184', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S184', pTipo, guId, '', pDatos);  
        }
    }

    static void insertarCasoRedireccionar(FromJSON jsonBody)
    {
        Case caso = getCasePadre (jsonBody);
        if(caso != null){
            List<Case> cH = new List<Case>();
            List<String> strList = new List<String>();
            String strLineas = jsonBody.requestFromBDO.lineasPortacion;
            String[] arrLineas = strLineas.split('\\|');
            for(Integer a=0; a<arrLineas.size();a++){
                    strList.add(arrLineas[a]);
            }
            List<Id> idCaso = new List<Id>();
            for (String strNum : strList){
                insertarCasoHijo(jsonBody,caso.id, cH, strNum);
            }
            for (Case cHH : cH){
                idCaso.add(cHH.Id);
            }
            PortabilityHandler.ProcessPortability(idCaso);
        } else {
                insertarCaso(jsonBody);
        }
    }

    static Case getCase (FromJSON jsonBody){
        Long pNroSolicitud = jsonBody.requestFromBDO.nroSolicitudPortacion;
        String lNroSolicitud = String.valueOf(pNroSolicitud);
        String strLineas = JsonBody.requestFromBDO.lineasPortacion;
        try{
            Case c = [SELECT Port_Rejection_Cod__c, Port_Line_Qty__c, Due_Date__c,Port_Network_Type__c, Port_Receiver_Cod__c, Port_Donor_Cod__c, Port_Doc_No__c, Port_Doc_Type__c, RecordTypeId, Id, ExternalCaseId__c, Area__c, Subarea__c, Origin, Speech__c, Modified_Date__c FROM Case WHERE ExternalCaseId__c = :lNroSolicitud];
            Case cP = [SELECT Port_Rejection_Cod__c, Port_Line_Qty__c, Due_Date__c,Port_Network_Type__c, Port_Receiver_Cod__c, Port_Donor_Cod__c, Port_Doc_No__c, Port_Doc_Type__c, RecordTypeId, Id, ExternalCaseId__c, Area__c, Subarea__c, Origin, Speech__c, Modified_Date__c, LineNumber__c, ParentId FROM Case WHERE LineNumber__c = :strLineas];
            if (cP.ParentId == null || cP.ParentId == c.Id)
            {
                return cP;
            } else {
                return null;
            }
        } catch(Exception e) {
            return null;
        }
    }
    
    static Case getCasePadre (FromJSON jsonBody){
        Long pNroSolicitud = jsonBody.requestFromBDO.nroSolicitudPortacion;
        String lNroSolicitud = String.valueOf(pNroSolicitud);
        try{
            Case c = [SELECT Port_Rejection_Cod__c, Port_Line_Qty__c, Due_Date__c,Port_Network_Type__c, Port_Receiver_Cod__c, Port_Donor_Cod__c, Port_Doc_No__c, Port_Doc_Type__c, RecordTypeId, Id, ExternalCaseId__c, Area__c, Subarea__c, Origin, Speech__c, Modified_Date__c FROM Case WHERE ExternalCaseId__c = :lNroSolicitud];
            return c;
        } catch(Exception e) {
            return null;
        }
    }

    public static void actualizarCaso (FromJSON pJsonBody, Case c){

        if(c.Origin != pJsonBody.requestFromBDO.tipoProcesoPortacion){
            c.Origin = pJsonBody.requestFromBDO.tipoProcesoPortacion;
        }
        if(c.Area__c != pJsonBody.requestFromBDO.estadoProcesoPortacion){
            c.Area__c = pJsonBody.requestFromBDO.estadoProcesoPortacion;
            c.Modified_Date__c =DateTime.ValueOf(pJsonBody.requestFromBDO.fechaEstadoProcesoPortacion);
        }
        if(c.Subarea__c != pJsonBody.requestFromBDO.subEstadoProcesoPortacion){
            c.Subarea__c = pJsonBody.requestFromBDO.subEstadoProcesoPortacion;
        }
        if(c.Speech__c != pJsonBody.requestFromBDO.descripcionEstadoProcesoPortacion){
            c.Speech__c = pJsonBody.requestFromBDO.descripcionEstadoProcesoPortacion;
        }
        if(c.Port_Rejection_Cod__c != pJsonBody.requestFromBDO.codCausaRechazoPortacion){
            c.Port_Rejection_Cod__c = pJsonBody.requestFromBDO.codCausaRechazoPortacion;
        }
        update c;
        List<Id> idCaso = new List<Id>();
        idCaso.add(c.Id);
        PortabilityHandler.UpdatePortabilityCases(idCaso);
    }

    public static void insertarCaso (FromJSON pJsonBody){
        String strNroSolicitud = String.valueOf(pJsonBody.requestFromBDO.nroSolicitudPortacion);
        printDebug('paso insertarCaso : ' + pJsonBody);
 
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portability').getRecordTypeId();
 
        Case c = new Case();
        c.RecordTypeId = recordTypeId;
        
        c.ExternalCaseId__c = (strNroSolicitud == null) ? null : strNroSolicitud;
        if (!string.isBlank(pJsonBody.requestFromBDO.apoderado.tipoDocumento)) {
            c.Port_Doc_Type__c =pJsonBody.requestFromBDO.apoderado.tipoDocumento;
        }
        if (!string.isBlank(pJsonBody.requestFromBDO.apoderado.numeroDocumento)) {
            c.Port_Doc_No__c =Double.ValueOf(pJsonBody.requestFromBDO.apoderado.numeroDocumento);
        }

        c.Port_Donor_Cod__c = (pJsonBody.requestFromBDO.codOperadoraDonante == null) ? null : pJsonBody.requestFromBDO.codOperadoraDonante;
        c.Port_Receiver_Cod__c = (pJsonBody.requestFromBDO.codOperadoraReceptora==null) ? null : pJsonBody.requestFromBDO.codOperadoraReceptora;
        c.Origin = pJsonBody.requestFromBDO.tipoProcesoPortacion;
        c.Port_Network_Type__c =(pJsonBody.requestFromBDO.tipoRed == null) ? null : pJsonBody.requestFromBDO.tipoRed;
        c.Area__c = pJsonBody.requestFromBDO.estadoProcesoPortacion;

        if (!string.isBlank(pJsonBody.requestFromBDO.subEstadoProcesoPortacion)) {
            c.Subarea__c =pJsonBody.requestFromBDO.subEstadoProcesoPortacion;
        }

        c.Speech__c =(pJsonBody.requestFromBDO.descripcionEstadoProcesoPortacion == null) ? null : pJsonBody.requestFromBDO.descripcionEstadoProcesoPortacion;

        if (!string.isBlank(pJsonBody.requestFromBDO.fechaEstadoProcesoPortacion)) {
            c.Modified_Date__c =DateTime.ValueOf(pJsonBody.requestFromBDO.fechaEstadoProcesoPortacion);
        }

        
        if (!string.isBlank(pJsonBody.requestFromBDO.fechaVentanaPortacion)) {
            c.Due_Date__c =DateTime.ValueOf(pJsonBody.requestFromBDO.fechaVentanaPortacion);
        }

        c.Port_Line_Qty__c = (pJsonBody.requestFromBDO.cantidadLineasPortacion == null) ? NULL : pJsonBody.requestFromBDO.cantidadLineasPortacion;
        c.Port_Rejection_Cod__c =  (pJsonBody.requestFromBDO.codCausaRechazoPortacion == null ) ? null : pJsonBody.requestFromBDO.codCausaRechazoPortacion;

        if (!string.isBlank(pJsonBody.requestFromBDO.nroLinea)) {
            c.SuppliedPhone =pJsonBody.requestFromBDO.nroLinea;
        }

        if (!string.isBlank(pJsonBody.requestFromBDO.nroUnicoSolicitudPortacion)) {
            c.VoucherNumber__c =pJsonBody.requestFromBDO.nroUnicoSolicitudPortacion;
        }

        if (!string.isBlank(pJsonBody.requestFromBDO.codMercadoDonante)) {
            c.Port_Market__c =pJsonBody.requestFromBDO.codMercadoDonante;
        }
        List<String> strList = new List<String>();
        String strLineas = pJsonBody.requestFromBDO.lineasPortacion;
        String[] arrLineas = strLineas.split('\\|');
        for(Integer a=0; a<arrLineas.size();a++){
                strList.add(arrLineas[a]);
        }
        List<Id> idCaso = new List<Id>();
        List<Case> cH = new List<Case>();
        if(strList.size() > 1){
            insert c;
            idCaso.add(c.Id);
            for(String strNum : strList){
                insertarCasoHijo(pJsonBody, c.id, cH, strNum);
            }
            insert cH;
            for (Case cHH : cH){
                idCaso.add(cHH.Id);
            }
        } else {
            c.LineNumber__c = strList[0];
            insert c;
            idCaso.add(c.Id);
        }
        PortabilityHandler.ProcessPortability(idCaso);
    }

    private static void insertarLineas(String lineasPortacion, Id pId){
        String strLineas = lineasPortacion;
        String[] arrLineas = strLineas.split('\\|');

        for(Integer a=0; a < arrLineas.size(); a++){
            CaseComment com= new CaseComment();
            com.CommentBody = arrLineas[a];
            com.IsPublished = TRUE;
            com.ParentId = pId;
            insert com;
        }

    }

    public static void insertarCasoHijo (FromJSON pJsonBody, Id idPadre, List<Case> cH, String strNum){
        printDebug('paso insertarCaso : ' + pJsonBody);
 
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portability').getRecordTypeId();
 
        Case c = new Case();       
        c.ParentId = idPadre;
        c.RecordTypeId = recordTypeId;
        c.LineNumber__c = strNum;
        
        if (!string.isBlank(pJsonBody.requestFromBDO.apoderado.tipoDocumento)) {
            c.Port_Doc_Type__c =pJsonBody.requestFromBDO.apoderado.tipoDocumento;
        }
        if (!string.isBlank(pJsonBody.requestFromBDO.apoderado.numeroDocumento)) {
            c.Port_Doc_No__c =Double.ValueOf(pJsonBody.requestFromBDO.apoderado.numeroDocumento);
        }

        c.Port_Donor_Cod__c = (pJsonBody.requestFromBDO.codOperadoraDonante == null) ? null : pJsonBody.requestFromBDO.codOperadoraDonante;
        c.Port_Receiver_Cod__c = (pJsonBody.requestFromBDO.codOperadoraReceptora==null) ? null : pJsonBody.requestFromBDO.codOperadoraReceptora;
        c.Origin = pJsonBody.requestFromBDO.tipoProcesoPortacion;
        c.Port_Network_Type__c =(pJsonBody.requestFromBDO.tipoRed == null) ? null : pJsonBody.requestFromBDO.tipoRed;
        c.Area__c = pJsonBody.requestFromBDO.estadoProcesoPortacion;

        if (!string.isBlank(pJsonBody.requestFromBDO.subEstadoProcesoPortacion)) {
            c.Subarea__c =pJsonBody.requestFromBDO.subEstadoProcesoPortacion;
        }

        c.Speech__c =(pJsonBody.requestFromBDO.descripcionEstadoProcesoPortacion == null) ? null : pJsonBody.requestFromBDO.descripcionEstadoProcesoPortacion;

        if (!string.isBlank(pJsonBody.requestFromBDO.fechaEstadoProcesoPortacion)) {
            c.Modified_Date__c =DateTime.ValueOf(pJsonBody.requestFromBDO.fechaEstadoProcesoPortacion);
        }

        
        if (!string.isBlank(pJsonBody.requestFromBDO.fechaVentanaPortacion)) {
            c.Due_Date__c =DateTime.ValueOf(pJsonBody.requestFromBDO.fechaVentanaPortacion);
        }

        c.Port_Line_Qty__c = (pJsonBody.requestFromBDO.cantidadLineasPortacion == null) ? NULL : pJsonBody.requestFromBDO.cantidadLineasPortacion;
        c.Port_Rejection_Cod__c =  (pJsonBody.requestFromBDO.codCausaRechazoPortacion == null ) ? null : pJsonBody.requestFromBDO.codCausaRechazoPortacion;

        if (!string.isBlank(pJsonBody.requestFromBDO.nroLinea)) {
            c.SuppliedPhone =pJsonBody.requestFromBDO.nroLinea;
        }

        if (!string.isBlank(pJsonBody.requestFromBDO.nroUnicoSolicitudPortacion)) {
            c.VoucherNumber__c =pJsonBody.requestFromBDO.nroUnicoSolicitudPortacion;
        }

        if (!string.isBlank(pJsonBody.requestFromBDO.codMercadoDonante)) {
            c.Port_Market__c =pJsonBody.requestFromBDO.codMercadoDonante;
        }

        cH.add(c);
    }

    private static void checkContrato(FromJSON contrato){

            if (contrato.requestFromBDO.nroSolicitudPortacion == NULL || contrato.requestFromBDO.nroSolicitudPortacion <= 0) {
                throw new CalloutException('Error: El campo nroSolicitudPortacion es requerido');
            }
            printDebug('paso 2 : pase chequeo nroSolicitudPortacion----->');
            if (!validacodOperadora(contrato.requestFromBDO.codOperadoraDonante)){
                throw new FunctionalException('Error: Un Codigo de operador Donante valido es requerido');
            }
            printDebug('paso 3 : pase chequeo codOperadoraDonante----->');
            if (!validacodOperadora(contrato.requestFromBDO.codOperadoraReceptora)){
                throw new FunctionalException('Error: Un Codigo de operador Receptor valido es requerido');
            }
            printDebug('paso 4 : pase chequeo codOperadoraReceptora----->');
            if (!validaTipoRed(contrato.requestFromBDO.tipoRed)){
                throw new FunctionalException('Error: Un tipo de red valido es requerido');
            }
            printDebug('paso 5 : pase chequeo tipoRed----->');
            if (!validaTipoProcesoPortacion(contrato.requestFromBDO.tipoProcesoPortacion)){
                throw new FunctionalException('Error: Un tipo proceso portacion valido es requerido');
            }
            printDebug('paso 6 : pase chequeo tipoProcesoPortacion----->');
            if (!validaEstadoProcesoPortacion(contrato.requestFromBDO.estadoProcesoPortacion)){
                throw new FunctionalException('Error: Un estado proceso portacion valido es requerido');
            }
            printDebug('paso 7 : pase chequeo estadoPortacion----->');
            if (!validaSubEstadoProcesoPortacion(contrato.requestFromBDO.subEstadoProcesoPortacion)){
                throw new FunctionalException('Error: Un sub estado proceso portacion valido es requerido');
            }
            printDebug('paso 8 : pase chequeo subEstadoPortacion----->');
            if (string.isBlank(contrato.requestFromBDO.descripcionEstadoProcesoPortacion)) {
                throw new CalloutException('Error: El campo descripcion estado es requerido');
            }
            printDebug('paso 9 : pase chequeo descriptcionEstadoProcesoPortacion----->');

            if(String.isNotBlank(contrato.requestFromBDO.fechaEstadoProcesoPortacion) &&  
                !Pattern.matches('\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d', contrato.requestFromBDO.fechaEstadoProcesoPortacion)){
                throw new CalloutException('Error: El formato de fecha Estado Portacion  es invalido (yyyy-mm-dd HH:mm:ss)');
            }

           printDebug('paso 10 : pase chequeo fechaEstadoProcesoPortacion----->');

            if(String.isNotBlank(contrato.requestFromBDO.fechaVentanaPortacion) &&  
                !Pattern.matches('\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d', contrato.requestFromBDO.fechaVentanaPortacion)){
                throw new CalloutException('Error: El formato de fecha Ventana Portacion  es invalido (yyyy-mm-dd HH:mm:ss)');
            }
           printDebug('paso 11 : pase chequeo fechaEstadoProcesoPortacion----->');


            if (string.isBlank(contrato.requestFromBDO.lineasPortacion)) {
                throw new FunctionalException('Error: El campo lineas a portar es requerido');
            }
           printDebug('paso 11 : pase chequeo lineasPortacion----->');
            if (contrato.requestFromBDO.cantidadLineasPortacion == null) {
                throw new FunctionalException('Error: El campo cantidad de lineas a portar es requerido');
            }
           printDebug('paso 12 : pase chequeo cantidadlineasPortacion----->');
            if (!validaDocumentacionLista(contrato.requestFromBDO.documentacionLista)){
                throw new FunctionalException('Error: Falta la documentacionLista');
            }
           printDebug('paso 13 : pase chequeo lista documentacion----->');
           if(contrato.requestFromBDO.apoderado != null){
                if (string.isBlank(contrato.requestFromBDO.apoderado.numeroDocumento) || !contrato.requestFromBDO.apoderado.numeroDocumento.isNumeric()) {
                    throw new FunctionalException('Error: El campo numero de documento es requerido y debe ser numerico');
                }

                if (string.isBlank(contrato.requestFromBDO.apoderado.tipoDocumento)) {
                    throw new FunctionalException('Error: El campo tipo de documento es requerido');
                }
                
                if (string.isBlank(contrato.requestFromBDO.apoderado.nombre)) {
                    throw new FunctionalException('Error: El campo nombre es requerido');
                }
                
                if (string.isBlank(contrato.requestFromBDO.apoderado.apellido)) {
                    throw new FunctionalException('Error: El campo apellido es requerido');
                }
           }
            printDebug('paso 14 : pase chequeo numeroDocumento debe ser numerico----->');
            if (contrato.requestFromBDO.reversion != null){
                if (contrato.requestFromBDO.reversion.nroSolicitudPortacion == null || contrato.requestFromBDO.reversion.nroSolicitudPortacion == 0) {
                    throw new FunctionalException('Error: El campo nroSolicitudPortacion en la reversion es requerido');
                }
            }
            printDebug('paso 15 : pase chequeo reversion----->');
    }

    private static Boolean validacodOperadora(String pCodOperador) {
        Boolean resultado = true;

        if (string.isBlank(pCodOperador)) {
            resultado = false;
        }
        else
        {
            if (pCodOperador != '5555' &&  pCodOperador != '5666' &&  pCodOperador != '5777' &&  pCodOperador != '5888') {
                resultado = false;
            }
        }
        return resultado;
    }

    private static Boolean validaTipoRed(String pTipoDeRed){
        Boolean resultado = true;

        if (string.isBlank(pTipoDeRed)) {
            resultado = false;
        }
        else
        {
            if (pTipoDeRed != 'FIJA' && pTipoDeRed != 'MOVIL' && pTipoDeRed != 'BANDA ANCHA' && pTipoDeRed != 'TELEVISION') {
                resultado = false;
            }
        }
        return resultado;
    }

    private static Boolean validaTipoProcesoPortacion(String pTipoProceso){
        Boolean resultado = true;

        if (string.isBlank(pTipoProceso)) {
            resultado = false;
        }
        else
        {
            if (pTipoProceso != 'ALIM' && pTipoProceso != 'ALEX' && pTipoProceso != 'RVIM' && pTipoProceso != 'RVEX') {
                resultado = false;
            }
        }
        return resultado;
    }

    private static Boolean validaEstadoProcesoPortacion(String pEstadoProceso){
        Boolean resultado = true;

        if (string.isBlank(pEstadoProceso)) {
            resultado = false;
        }
        else
        {
            if (pEstadoProceso != 'PABD' && pEstadoProceso != 'AACE' && pEstadoProceso != 'ERR' && pEstadoProceso != 'PDON' && pEstadoProceso != 'ASOL' && pEstadoProceso != 'AREC' && pEstadoProceso != 'RSOL' &&  pEstadoProceso != 'RACE' && pEstadoProceso != 'RREC') {
                resultado = false;
            }
        }
        return resultado;
    }

    private static Boolean validaSubEstadoProcesoPortacion(String pSubEstadoProceso){
        Boolean resultado = true;
        String valor = pSubEstadoProceso;

        if (string.isBlank(valor)) {
            resultado = true;
        }
        else
        {
            if (valor != 'AUTO' && valor != 'MAN' &&  valor != 'PCON' && valor != 'ABD' &&  valor != 'NULL' &&  valor != 'APSI' &&  valor != 'NULL' &&  valor != 'RESI' &&  valor != 'RIMP' &&  valor != 'TIME') {
                resultado = false;
            }
        }
        return resultado;
    }

    private static Boolean validaDocumentacionLista(List<FromJSON_2> lstDocumentos){
        Boolean resultado = true;

        if (lstDocumentos == null || lstDocumentos.size() == 0) {
            resultado = true;
        }
        else
        {

            printDebug('paso 13 : Dentro de ValidaDocumentacionLista / dentro else----->');

            for (Integer i =0; i < lstDocumentos.size(); i++) {
                String valor = lstDocumentos[i].tipoProcesoPortacion;
                if (!string.isBlank(valor)){
                    if (valor != 'ALEX' && valor != 'ALIM'){
                        resultado = false;
                        break;
                    }
                }
            }
        }
        return resultado;
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

    public class FromJSON {
        public FromJSON_1 requestFromBDO; 
    }


    public class FromJSON_1 {
        public Long nroSolicitudPortacion; 
        public String nroUnicoSolicitudPortacion;
        public String codOperadoraDonante;
        public String codOperadoraReceptora;
        public String tipoRed;
        public String tipoProcesoPortacion;
        public String estadoProcesoPortacion;
        public String subEstadoProcesoPortacion;
        public String descripcionEstadoProcesoPortacion;
        public String fechaEstadoProcesoPortacion;
        public String codMercadoDonante;
        public String fechaVentanaPortacion;
        public String lineasPortacion;
        public Integer cantidadLineasPortacion;
        public String nroLinea;
        public String PINPortacion;
        public String codCausaRechazoPortacion;
        public List<FromJSON_2> documentacionLista;
        public FromJSON_3 reversion;
        public FromJSON_4 apoderado;
    }
     public class FromJSON_2 {
        public String comentario; 
        public String datosDocumento; 
        public String tipoDocumentacionPortacion; 
        public String nombreArchivoPortacion; 
        public String tipoProcesoPortacion; 
    }
     public class FromJSON_3 {
        public Long nroSolicitudPortacion; 
    }
     public class FromJSON_4 {
        public String tipoDocumento;
        public String numeroDocumento;
        public String nombre;
        public String apellido;
    }

    static void printDebug(String pMensaje) {
        if (K_DEBUG_ON) {
            System.debug(pMensaje);
        }
    }
    //---- Clases para soportar el intercambio de parametros ----//
    /**
     * @Objetivo: Para saber que codigo mandar debo poder
     *            diferenciar una excepcion funcional de
     *            otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {

    }   
    private class IPException extends Exception {

    } 
}