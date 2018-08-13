public with sharing class StockUtils{

    public static void StockMovement(String orderId, String codOperacion, String codDeposito)
    {
        System.debug('StockMovement');
        try{
            List<String> serialNumbers = GetSerialsFromOrder(orderId);
            StockMovement(serialNumbers, codOperacion, codDeposito);
        }
        catch(DmlException e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
        catch(CallOutException e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
        catch(Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
    }

    public static void StockMovement(List<String> serialNumbers, String codOperacion, String codDeposito)
    {
        System.debug('StockMovement');
        try{
            Map<String,Object> serialNumbers2 = new Map<String,Object>();
            for(String serial : serialNumbers)
            {
                Map<String,Object> serialNode = new Map<String,Object>();
                serialNode.put('codDeposito',codDeposito);
                serialNode.put('codOperacion',codOperacion);
                serialNumbers2.put(serial,serialNode);
            }
            StockMovement(serialNumbers2);
        }
        catch(CallOutException e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
        catch(Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
    }

    //Realiza el movimiento de stock de los seriales recibidos
    /*Estructura de serialNumbers
    {
        "123412341234123":{"codDeposito":"CP123001","codOperacion":"ASDF"},
        "567856785687788":{"codDeposito":"CP123001","codOperacion":"ASDF"}
    }
    */
    public static void StockMovement(Map<String,Object> serialNumbers)
    {
        System.debug('StockMovement');
        try{
            String idUnicoTransaccion = GuidUtil.NewGuid();
            String serviceRequest = '{"body": {"listaOperacion": [';
            Integer key = 0;
            for(String serial : serialNumbers.KeySet())
            {
                if (key > 0) serviceRequest += ',';
                serviceRequest += '{';
                serviceRequest += '"codDeposito": "' + ((Map<String,Object>)serialNumbers.get(serial)).get('codDeposito') + '",';
                serviceRequest += '"codOperacion": "' + ((Map<String,Object>)serialNumbers.get(serial)).get('codOperacion') + '",';
                serviceRequest += '"numeroSerie": "' + serial + '"';
                serviceRequest += '}';
                key++;
            }
            serviceRequest += ']},';
            serviceRequest += '"params": {';
            serviceRequest += '"X-Consumer-Transaction-ID": "' + idUnicoTransaccion + '"';
            serviceRequest += '}}';

            System.debug('IFS_S105 - request : ' + serviceRequest);

            Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(serviceRequest);
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
            integProcService.invokeMethod('IFS_S105', input, output, options);

            Map<String, Object> s105_response = (Map<String, Object>)output.get('IPResult');
            System.debug('IFS_S105 - response : ' + JSON.serialize(s105_response));
            String codigoResultado = (String)s105_response.get('codigoResultado');
            if (codigoResultado == 'OK')
            {
                List<Object> listaDeSeriados = (List<Object>) s105_response.get('listaResultado');
                for(Object itemSeriado : listaDeSeriados)
                {
                    Map<String,Object> itemSeriadoMap = (Map<String,Object>) itemSeriado;
                    String codigoResultadoSerial = (String) itemSeriadoMap.get('codigoResultado');
                    if (codigoResultadoSerial != '0')
                    {
                        String serie = (String) itemSeriadoMap.get('numeroSerie');
                        String mensajeResultadoSerial = (String) itemSeriadoMap.get('mensajeResultado');
                        throw new CallOutException('Error al invocar al servicio 105. CodigoResultado: ' + codigoResultadoSerial + ', MensajeResultado: ' + mensajeResultadoSerial + ', NumeroSerie: ' + serie);
                    }
                }
            }
            else
                throw new CallOutException('Error al invocar al servicio 105. Codigo: ' + codigoResultado);
        }
        catch(CallOutException e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
        catch(Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
    }

    public static void StockQuantityManagement(Map<String, Map<String, Object>> nmus, String orderId, String serviceOperation)
    {
        System.debug('StockQuantityManagement');
        try{
            String idUnicoTransaccion = GuidUtil.NewGuid();
            String serviceRequest = '{"body": {';
            serviceRequest += '"codAplicacion": "SFDC_CRM",';
            serviceRequest += '"codPuntoDeVenta": "0",';
            serviceRequest += '"idOperacion": "' + orderId + '",';
            serviceRequest += '"operacion": "' + serviceOperation + '",';
            serviceRequest += '"listaNMU": [';
            Integer key = 0;
            for(String nmuToSend : nmus.KeySet())
            {
                if (key > 0) serviceRequest += ',';
                serviceRequest += '{';
                serviceRequest += '"codDeposito": "' + ((Map<String,Object>)nmus.get(nmuToSend)).get('codDeposito') + '",';
                serviceRequest += '"codNMU": "' + nmuToSend + '",';
                serviceRequest += '"cantidad": "' + ((Map<String,Object>)nmus.get(nmuToSend)).get('cantidad') + '"';
                serviceRequest += '}';
                key++;
            }
            serviceRequest += ']},';
            serviceRequest += '"params": {';
            serviceRequest += '"X-Consumer-Transaction-ID": "' + idUnicoTransaccion + '"';
            serviceRequest += '}}';

            System.debug('IFS_S101 - request : ' + serviceRequest);

            Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(serviceRequest);
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
            integProcService.invokeMethod('IFS_S101', input, output, options);

            Map<String, Object> s101_response = (Map<String, Object>)output.get('IPResult');
            System.debug('IFS_S101 - response : ' + JSON.serialize(s101_response));
            String codigoResultado = (String)s101_response.get('codigoResultado');
            if (codigoResultado != 'OK')
                throw new CallOutException('Error al invocar al servicio 101. Codigo: ' + codigoResultado);
        }
        catch(CallOutException e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
        catch(Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
    }

    private static List<String> GetSerialsFromOrder(String orderId)
    {
        System.debug('GetSerialsFromOrder');
        try{
            List<String> serialNumbers = new List<String>(); 
            List<Order> orders = [
                    SELECT Id, Status,
                    (SELECT Id, OrderId, Product2.Name, Product2.ProductCode, Quantity, vlocity_cmt__SerialNumber__c FROM OrderItems where vlocity_cmt__SerialNumber__c != null)
                    FROM Order
                    WHERE Id = :orderId
            ];
            if (orders[0].OrderItems.size() > 0)
            {
                for(OrderItem item : orders[0].OrderItems)
                {
                    serialNumbers.add(item.vlocity_cmt__SerialNumber__c);
                }
            }
            return serialNumbers;
        }
        catch(DmlException e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
        catch(Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
    }
}