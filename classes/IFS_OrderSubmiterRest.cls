@RestResource(urlMapping='/v1/integrationprocedure/submitOrderRest/*')
global with sharing class IFS_OrderSubmiterRest {
    public static final boolean K_DEBUG_ON = true;

    @HttpPost
    global static void getPost() {
        Http http = new Http();
        Map<String, Object> resultado = null;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        res.addHeader('Content-Type', 'application/json');
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
        try {
            //submitOrder((String)params.get('orderId'));
            Id batchId = schedulerBatch ();
            res.statuscode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('200', 'Batch Id: ' + batchId)));
        }
        catch (Exception e) {
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417', e.getMessage())));
        }
    }

    private static Id schedulerBatch () {
        IFS_OrderSubmiter osb = new IFS_OrderSubmiter();
        return System.enqueueJob(osb);
    }

    /**
     * @Objetivo: Realiza el checkout de la orden.
     */
    private static void submitOrder (String pOrderId) {
        printDebug('Entre a submitOrder() -- OrdenId --> ' + pOrderId);

        try {
            printLimitAndUsedSize();
            String result = vlocity_cmt.SimpleDecompositionController.decomposeAndCreatePlanEx(Id.valueOf(pOrderId), false);
            Map<String, Object> resultMap = (Map<String, Object>)JSON.deserializeUntyped(result);
            if (resultMap != null) {
                Boolean stat = (Boolean) resultMap.get('isOk');
                if (!stat) {
                    printLimitAndUsedSize();
                    throw new FunctionalException((String)resultMap.get('errorMsg'));
                }
            }
            printLimitAndUsedSize();
        }
        catch (Exception e) {
            throw new FunctionalException('Error al submitir la orden: ' + pOrderId + ' - Error: ' + e.getMessage());
        }
    }

    /**
     * @Objetivo: Arma la estructura de respuesta No Ok.
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

    private static void printLimitAndUsedSize() {
        printDebug('Heap Size --> ' + Limits.getHeapSize());
        printDebug('Queries --> ' + Limits.getQueries() + ' - Limit -->  ' + Limits.getLimitQueries());
    }

    private static void printDebug(String pMensaje) {
        if (K_DEBUG_ON) {
            System.debug(pMensaje);
        }
    }

    /**
     * @Objetivo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {

    }



}