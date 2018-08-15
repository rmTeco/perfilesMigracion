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
    }

    public static void StockMovement(List<String> serialNumbers, String codOperacion, String codDeposito)
    {
        System.debug('StockMovement');
        try{
            Map<String,Object> request = new Map<String,Object>();
            Map<String,Object> body = new Map<String,Object>();
            String idUnicoTransaccion = GuidUtil.NewGuid();
            System.debug('StockUtils:IP:idUnicoTransaccion: ' + idUnicoTransaccion);
            Map<String,Object> valueIdUnico = new Map<String,Object>();
            valueIdUnico.put('X-Consumer-Transaction-ID', idUnicoTransaccion);

            if (serialNumbers.size() > 0)
            {
                //AM 06/06/2018 Ajuste para Implementar Idempotencia 
                List<Object> serialOperationList = new List<Object>();

                for(String serial : serialNumbers){
                    Map<String,Object> serialNode = new Map<String,Object>();
                    serialNode.put('codOperacion', codOperacion);
                    serialNode.put('numeroSerie', serial);
                    serialNode.put('codDeposito', codDeposito);
                    serialOperationList.add(serialNode);
                }

                body.put('listaOperacion', serialOperationList);

                request.put('body', body);
                request.put('params', valueIdUnico);
                //AM 06/06/2018 Ajuste para Implementar Idempotencia FIN
                System.debug('Llamado IP');
                Map<String, Object> response = new Map<String, Object>();
                Map<String, Object> options = new Map<String, Object>();
                vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
                System.debug('IFS_S105 - request : ' + request);
                integProcService.invokeMethod('IFS_S105', request, response, options);
                System.debug('response: ' + response);
                String codigoResultado = (String) response.get('codigoResultado');

                if (codigoResultado == 'ERROR')
                {
                    String mensajeResultado = (String) response.get('listaResultado.mensajeResultado');
                    System.debug('mensajeResultado105: ' + mensajeResultado);
                    throw new CallOutException(mensajeResultado);
                }


                /*for(String serial : serialNumbers)
                {
                    Map<String,Object> serialNode = new Map<String,Object>();
                    serialNode.put('codOperacion', codOperacion);
                    serialNode.put('numeroSerie', serial);
                    serialNode.put('codDeposito', codDeposito);
                    serialNode.put('cantidad', 1);
                    request.put(String.valueOf(key), serialNode);
                    key++;
                }
                //JSEIBERT - IFS105 IP - INI
                //Map<String,Object> response = IFS_S105_stockMovement.stockMovement(request);
                System.debug('Llamado IP');
                Map<String, Object> response = new Map<String, Object>();
                Map<String, Object> options = new Map<String, Object>();
                vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
                System.debug('IFS_S105 - request : ' + request);
                integProcService.invokeMethod('IFS_S105', request, response, options);
                System.debug('response: ' + response);
                String codigoResultado = (String) response.get('codigoResultado');

                if (codigoResultado == 'ERROR')
                {
                    String mensajeResultado = (String) response.get('listaResultado.mensajeResultado');
                    System.debug('mensajeResultado105: ' + mensajeResultado);
                    throw new CallOutException(mensajeResultado);
                }
                //JSEIBERT - IFS105 IP - FIN
                */
            }
        }
        catch(DmlException e)
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
            Map<String,Object> request = new Map<String,Object>();
            Integer key = 1;

            if (!serialNumbers.KeySet().IsEmpty())
            {
                for(String serial : serialNumbers.KeySet())
                {
                    Map<String,Object> serialNode = new Map<String,Object>();
                    serialNode.put('codOperacion', (String) ((Map<String,Object>)serialNumbers.get(serial)).get('codOperacion'));
                    serialNode.put('numeroSerie',serial);
                    serialNode.put('codDeposito', (String) ((Map<String,Object>)serialNumbers.get(serial)).get('codDeposito'));
                    serialNode.put('cantidad',1);
                    request.put(String.valueOf(key),serialNode);
                    key++;
                }
                System.debug('IFS_S105 - request : ' + request);
                String idUnicoTransaccion = GuidUtil.NewGuid();
                System.debug('StockUtils:idUnicoTransaccion: ' + idUnicoTransaccion);
                Map<String,Object> response = IFS_S105_stockMovement.stockMovement(request, idUnicoTransaccion);
                System.debug('response s105: ' + response);

                String httpStatusCode = (String) response.get('httpStatusCode');

                if (httpStatusCode != '200' && httpStatusCode != '201' && httpStatusCode != '202' && httpStatusCode != '204')
                {
                    String mensaje = (String) response.get('mensaje');
                    throw new CallOutException(mensaje);
                }
            }
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
    }
}