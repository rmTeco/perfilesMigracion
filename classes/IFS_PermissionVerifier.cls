/**
 * Herramienta que permite verificar los permisos de un usuario (el que ejecuta el servicio)
 * para un objeto dado (El nombre viene por parametros). 
 *
 * @Author: Alejandro Salord (Certa Consulting).
 */
@RestResource(urlMapping='/v1/integrationprocedure/permissionVerifier/*')
global with sharing class IFS_PermissionVerifier {
    private static final boolean K_DEBUG_ON = false;

    @HttpPost
    global static void getPost() {
        Http http = new Http();
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        RequestJson jsonBody = null;
        res.addHeader('Content-Type', 'application/json');
        try {
            res.statuscode = 200;
            try {
                jsonBody = new RequestJson();
                jsonBody = (RequestJson)JSON.deserialize(req.requestBody.toString(), RequestJson.class);
            }
            catch (Exception e) {
                throw new CalloutException('Error al deserializar los parametros. Error: ' + e.getMessage());
            } 
            
            checkContrato (jsonBody);

            res.responseBody = Blob.valueOf(JSON.serialize(Procesar(jsonBody)));
        }
        catch(Exception e){
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',e.getMessage())));
        }
    }


    /**
     * Verificar que se cumpla el contrato.
     * Si lo cumple termina y sino dispara la excepción: CalloutException.
     */
    private static void checkContrato (RequestJson pJson) {
        printDebug('Entre a checkContrato()');

        if (pJson == null) {
            printDebug('El json vino vacio o nulo'); 
            throw new CalloutException('Error en la validacion de los atributos del request. Vino vacio.');
        }

        List<NameClass> lstObjects = pJson.lstObjects;

        if (lstObjects == null || lstObjects.size()==0) {
            printDebug('La lista de objetos vino nula o vacia'); 
            throw new CalloutException('La lista de objetos vino nula o vacia');
        }
    }


    public static ResponseJson procesar (RequestJson pJsonBody) {

        try {
            ResponseJson response = new ResponseJson(UserInfo.getUserId(), UserInfo.getUserName());

            List<NameClass> lstObjects = pJsonBody.lstObjects;
            for (NameClass sobjectName : lstObjects) {
                ObjectDetails od = new ObjectDetails();
                od.objectName = sobjectName.nombre;
                od.canCreate = 'N';
                od.canRead = 'N';
                od.canUpdate = 'N';
                od.canDelete = 'N';
                SObjectType objToken = Schema.getGlobalDescribe().get(sobjectName.nombre);
                if (objToken == null) {
                    od.status = 'El objeto no existe.';
                }
                else {
                    DescribeSObjectResult objDef = objToken.getDescribe();
                    if (objDef == null) {
                        od.status = 'No se pudo obtener informacion del objeto.';
                    }
                    else {
                        od.isCustom = objDef.isCustom() ? 'El objeto es Custom.' : 'El objeto no es Custom.';
                        od.status = objDef.getLabel();
                        od.canCreate = objDef.isCreateable() ? 'S' : 'N';
                        od.canRead = objDef.isAccessible() ? 'S' : 'N';
                        od.canUpdate = objDef.isUpdateable() ? 'S' : 'N';
                        od.canDelete = objDef.isDeletable() ? 'S' : 'N';
                        Map<String, Schema.SObjectField> drMap = objToken.getDescribe().fields.getMap();
                        for (String fieldName : drMap.keySet()){
                            Schema.SObjectField so = drMap.get(fieldName);
                            Schema.DescribeFieldResult dfr = so.getDescribe();
                            FieldDetails fd = new FieldDetails();
                            fd.fieldName = dfr.getName();
                            fd.isAccessible = dfr.isAccessible() ? 'S' : 'N';
                            fd.fieldLabel = dfr.getLabel();
                            fd.fieldLocalName = dfr.getLocalName();
                            fd.fieldType = String.valueOf(dfr.getType());
                            fd.canCreate = dfr.isCreateable() ? 'S' : 'N';
                            fd.canUpdate = dfr.isUpdateable() ? 'S' : 'N';
                            fd.isDeleteRestrict = dfr.isRestrictedDelete() ? 'S' : 'N';
                            fd.isDeleteCascade = dfr.isCascadeDelete() ? 'S' : 'N';
                            od.lstFieldDetails.add(fd);
                        }
                    }
                }
                response.lstObjects.add(od);
            }            
            return response;
        }
        catch (Exception e) {
            throw e;
        }
    }

    /**
     * Funcion que devuelve respuesta NO Ok en el formato definido en el contrato (IDD).
     */
    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        printDebug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }

    /**
     * Esta funcion es un wrapper del System.debug(o)
     * que permite setear cuando activarlo o no.
     */
    private static void printDebug(String pMensaje) {
        if (K_DEBUG_ON) {
            System.debug(pMensaje);
        }
    }

    public class RequestJson {
        public List<NameClass> lstObjects = null;
        public RequestJson() {
            lstObjects = new List<NameClass>();
        }
    }

    public class NameClass {
        String nombre = null;
    }

    public class ResponseJson {
        public String userId = null;
        public String userName = null;
        public List<ObjectDetails> lstObjects = null;
        public ResponseJson() {
            lstObjects = new List<ObjectDetails>();
        }
        public ResponseJson(String pUserId, String pUserName) {
            userId = pUserId;
            userName = pUserName;
            lstObjects = new List<ObjectDetails>();
        }
    }

    //-- CRUD Permission.
    public class ObjectDetails {
        public String objectName = null;
        public String status = null;
        public String isCustom = null;
        public String canCreate = null;
        public String canRead = null;
        public String canUpdate = null;
        public String canDelete = null;
        public List<FieldDetails> lstFieldDetails = null;
        public ObjectDetails () {
            lstFieldDetails = new List<FieldDetails>();
        }
    }

    public class FieldDetails {
        public String fieldName = null;
        public String isAccessible = null;
        public String fieldLabel = null;
        public String fieldLocalName = null;
        public String fieldType = null;
        public String canCreate = null;
        public String canUpdate = null;
        public String isDeleteRestrict = null;
        public String isDeleteCascade = null;
    }

    /**
     * Objetivo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {

    }
    
}