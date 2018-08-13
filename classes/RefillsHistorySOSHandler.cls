global with sharing class RefillsHistorySOSHandler implements vlocity_cmt.VlocityOpenInterface{

    global RefillsHistorySOSHandler(){}

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) 
    {
        Boolean result = true;
        try {
            if (methodName.equals('getDummyData'))
                getDummyData(methodName, input, outMap, options);

            return result;
        }
        catch(Exception e) {
            System.debug('RefillsHistorySOSHandler: invokeMethod -> exception: ' + e);
            return false;
        }
        
    }

    static Integer randomWithLimit(Integer upperLimit)
    {
        Integer rand = Math.round(Math.random()*1000);
        return Math.mod(rand, upperLimit);
    }

    global static void getDummyData(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {    
        String startDateScope = (String) input.get('startDateFilter');
        String endDateScope = (String) input.get('endDateFilter');

        system.debug('startDateScope: ' + startDateScope);
        system.debug('endDateScope: ' + endDateScope);


        Map<String, Object> refillsInfo = new Map<String, Object>();
        List<Map<String, String>> refillsNodeList = new List<Map<String, String>>();
        Map<String, String> node;

        String [] arrayListState = new List<String>();
        arrayListState.add('Activa');
        arrayListState.add('Finalizada');
        arrayListState.add('Activa');
        arrayListState.add('Finalizada');


        String [] arrayListPaymentMethod = new List<String>();
        arrayListPaymentMethod.add('Recarga');
        arrayListPaymentMethod.add('Tarjeta Credito');
        arrayListPaymentMethod.add('Tarjeta Debito');
        arrayListPaymentMethod.add('Puntos Personal');
        
        for(Integer i = 0; i < randomWithLimit(99); i++)
        {
            String inicio = String.valueOf((system.now()-i).format());
            String fin = String.valueOf((system.now()-i+7).format());
            node = new Map<String, String>();
            node.put('Fecha', inicio);
            node.put('Estado', arrayListState[randomWithLimit(3)]);
            node.put('Cancela', fin);
            node.put('FechaPago', inicio);
            node.put('Monto', String.valueOf(randomWithLimit(999999)));
            node.put('FechaCompra', String.valueOf((system.now()-5).format()));
            node.put('Cancela1', fin);
            node.put('FechaPago1', inicio);
            node.put('MedioPago', arrayListPaymentMethod[randomWithLimit(3)]);
    
            
            refillsNodeList.add(node);
        }
        
        refillsInfo.put('RefillsSOSList', refillsNodeList);
        outMap.put('Result', refillsInfo);
    }
}