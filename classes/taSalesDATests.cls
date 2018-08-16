global with sharing class taSalesDATests implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('ValidateSuspensions')){
                
                //Boolean hasSuspensions = ValidateSuspensions((String) options.get('OrderId'), outMap);
                Boolean hasSuspensions = ValidateSuspensions((String) options.get('OrderId'));
                outMap.put('hasSuspensions', hasSuspensions);
            }
            if (methodName.equals('PaymentRollback')){
                PaymentRollback(inputMap, outMap, options);
            }
            if (methodName.equals('CloseAnnulmentOrder')){
                Map<String, Object> oMap;
                String ordId = (String) options.get('orderId');
                String oldOrdId = (String) options.get('oldOrderId');
                Boolean stat = CloseAnnulmentOrder(ordId, oldOrdId);
                outMap.put('CloseOrderStatus', stat);
            }
            
            result = false;  
            //System.debug('outMap:' + outMap);
        } 
        catch(Exception e)
        {
            System.debug('taSalesDATests:invokeMethod -> exception: '+e);
            throw e; 
            //result = false;
        }
        return result;
    }

    //public Boolean ValidateSuspensions(String OrderId,  Map<String,Object> outMap){
    public Boolean ValidateSuspensions(String OrderId){
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────
    * @description Return true if any of the assetized Order Item has an active Fraude or Siniestro suspension  
    * Return false in other case
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author   Damian Avrij
    * @date     2018-02-05
    * @param    OrderId: The order Id orgin wich has produced the assets
    * @return   Reead in description
    */
        List<OrderItem> ois; 
        Map<String,Object> jsonAttribute;
        Map<String,Object> auxMap;
        String lineNum;
        List<String> lineNums;
        List<Asset> assets;
        Boolean retorno;
        try{
            System.debug('ValidateSuspensions');
            //retrieve all the Plans of the Order
            ois = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE Product2.vlocity_cmt__Type__c LIKE 'Plan%' AND OrderId = :OrderId];
            System.debug('ois:' + ois);
            //outMap.put('ois', ois);

            assets = [SELECT Id FROM Asset WHERE vlocity_cmt__OrderProductId__c IN :ois AND Status='Suspended' AND (Sub_Status__c = 'Línea suspendida por siniestro' OR Sub_Status__c='Línea suspendida por fraude')];
            System.debug('assets:' + assets);

            //outMap.put('assets',assets);
            if (assets.size() > 0 )
                retorno = true;
            else
                retorno = false;
        }
        catch(Exception e){
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
        return retorno;

    }
    public static Boolean CloseAnnulmentOrder(String orderId, String oldOrderId){
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────
    * @description Perform the actions relatives to a close by an annulment order
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author   Damian Avrij
    * @date     2018-02-09
    * @param    orderId: The annulment order Id
    *           oldOrderId: The original order which needs to be annuled
    * @return   nothing
    */   
        Boolean result = false;
        try{
            Order annulOrder = [SELECT Id, Status,StatusCode, TrackingStatus__c FROM Order WHERE Id = :orderId];
            
            // annulOrder.Status = 'Activated';
            /* Se compenta hasta que funcione
            vlocity_cmt.SimpleDecompositionController.decomposeOrder(annulOrder.Id);
            vlocity_cmt.SimpleDecompositionController.startOrchestrationPlan(annulOrder.Id);
            */

            Order oldOrder = [SELECT Status,StatusCode, TrackingStatus__c FROM Order WHERE Id = :oldOrderId];
            oldOrder.Status = 'Cancelled';
            oldOrder.TrackingStatus__c = 'Pendiente de Anulacion';

            update oldOrder;
            update annulOrder;
            result = true;
 
        }
        catch(Exception e){
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
        return result;
    }

    global static void PaymentRollback(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        String orderId = String.valueOf(options.get('OrderId'));

        Map<String, Object> response = call_S072_Payment_Rollback(orderId);
        
        Map<String, Object> ipResult = (Map<String, Object>)response.get('IPResult');
        outMap.put('IPResult', ipResult);
    }

    private static Map<String, Object> call_S072_Payment_Rollback(String orderId){
        System.debug('Call_S072_Payment_Rollback');
        String accountId = orderId;
        System.debug('2');
        
        System.debug('Generate_Request_S072');

        // Account account = [
        //     SELECT 
        //         Name, 
        //         CustomerIntegrationId__c,
        //         vlocity_cmt__BillingEmailAddress__c,
        //         Phone,
        //         vlocity_cmt__PrimaryContactId__r.FirstName,
        //         vlocity_cmt__PrimaryContactId__r.LastName,
        //         vlocity_cmt__PrimaryContactId__r.Email,
        //         vlocity_cmt__PrimaryContactId__r.Phone,
        //         vlocity_cmt__PrimaryContactId__r.MobilePhone,
        //         vlocity_cmt__PrimaryContactId__r.OtherPhone,
        //         vlocity_cmt__PrimaryContactId__r.Birthdate,
        //         vlocity_cmt__PrimaryContactId__r.Gender__c,
        //         vlocity_cmt__PrimaryContactId__r.Salutation,
        //         vlocity_cmt__PrimaryContactId__r.DocumentType__c,
        //         vlocity_cmt__PrimaryContactId__r.DocumentNumber__c,
        //         WebSite,
        //         RecordType.Name
        //     FROM Account
        //     WHERE Id = :accountId
        // ];
        // esto necesito minimo
        // order.Account.AccountIntegrationId__c

        //Obtengo datos del Payment Adjustment
        vlocity_cmt__PaymentAdjustment__c padj = [SELECT 
        vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c, 
        vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationYear__c,
        vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardNumber__c,
        PaymentCode__c
        FROM vlocity_cmt__PaymentAdjustment__c WHERE Order__c = :OrderId];

        //Obtengo datos de la cuenta

        //Order o = [SELECT Name, CustomerIntegrationId__c FROM Account WHERE Account];

        // System.debug('1');
        Map<String, Object> request = new Map<String, Object>();
        
        Map<String, Object> revertirPagoPeticion = new Map<String, Object>();

        List<Map<String, Object>> listaInformacionPagos = new List<Map<String, Object>>();

        // Empieza el FOR
        Map<String, Object> informacionPago = new Map<String, Object>();
        informacionPago.put('codPago', padj.PaymentCode__c);
        
        Map<String, Object> codAcceso = new Map<String, Object>();
        Map<String, Object> codAccesoCuenta = new Map<String, Object>();
        // codAccCuenta.put('idCuenta', order.Account.AccountIntegrationId__c);
        codAccesoCuenta.put('identificadorRecurso', 'COMPLETAAAAAR'); 
        codAcceso.put('codAccesoCuenta', codAccesoCuenta);
        informacionPago.put('codAcceso', codAcceso);

        Map<String, Object> wondersoftInfo = new Map<String, Object>();
        //wondersoftInfo.put('ipOrigen', 'COMPLETAAAAR');

        Map<String, Object> infoBanco = new Map<String, Object>();
        infoBanco.put('codEntidadFinanciera', 'COMPLETAAAAAR');
        infoBanco.put('codSucursalEntidad', 'COMPLETAAAAAR');
        infoBanco.put('codMedioPago', 'COMPLETAAAAAR');
        infoBanco.put('nroTarjetaEncriptado', padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardNumber__c);
        infoBanco.put('codEntidadTC', 'COMPLETAAAAAR');
        //infoBanco.put('nombreActor', 'COMPLETAAAAAR');
        infoBanco.put('fechaVencimientoTarjeta', padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationYear__c + padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c);
        infoBanco.put('codSeguridadTarjeta', 'COMPLETAAAAAR');
        infoBanco.put('cantidadCuotasTarjeta', 'COMPLETAAAAAR');
        wondersoftInfo.put('infoBanco', infoBanco);

        //wondersoftInfo.put('nombreActor', 'COMPLETAAAAAR');
        //wondersoftInfo.put('tipoDocumento', 'COMPLETAAAAAR');
        //wondersoftInfo.put('numeroDocumento', 'COMPLETAAAAAR');
        //wondersoftInfo.put('codPromoBanco', 'COMPLETAAAAAR');
        //informacionPago.put('wondersoftInfo', wondersoftInfo);

        //informacionPago.put('importePago', );
        //informacionPago.put('Pago', );


        listaInformacionPagos.add(informacionPago);
        // Termina el FOR

        revertirPagoPeticion.put('listaInformacionPagos', listaInformacionPagos);
        request.put('revertirPagoPeticion', revertirPagoPeticion);
        
        System.debug('request 072: ' + request);

        Map<String, Object> input = request;
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S072', input, output, options);
        
        System.debug('response s072: ' + JSON.serialize(output));
        Map<String, Object> response = (Map<String, Object>)output.get('IPResult');
        
        // if(response != null && response.get('codigo') == null) // si no da error, se guarda la marca de importado en huawei 
        // {
        //     Account account = new Account();
        //     account.Id = accountId;
        //     account.HuaweiNotice_S202__c = true;
        //     update account;
        // }
        Map<String, Object> outMap = new Map<String, Object>();
        outMap.put('IPResult', response);

        return outMap;
    }

}