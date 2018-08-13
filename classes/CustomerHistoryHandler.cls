global with sharing class CustomerHistoryHandler implements vlocity_cmt.VlocityOpenInterface{

    global CustomerHistoryHandler(){}

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) 
    {
        Boolean result = true;
        try {
            if (methodName.equals('getDummyData'))
                getDummyData(methodName, input, outMap, options);

            return result;
        }
        catch(Exception e) {
            System.debug('CustomerHistoryHandler: invokeMethod -> exception: ' + e);
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
        /*
        String startDateScope = (String) input.get('startDateFilter');
        String endDateScope = (String) input.get('endDateFilter');

        system.debug('startDateScope: ' + startDateScope);
        system.debug('endDateScope: ' + endDateScope);
        */

        Map<String, Object> refillsInfo = new Map<String, Object>();
        Map<String, Object> refillsInfo1 = new Map<String, Object>();
        Map<String, Object> refillsInfo2 = new Map<String, Object>();
        Map<String, Object> refillsInfo3 = new Map<String, Object>();
        List<Map<String, String>> sosNodeList = new List<Map<String, String>>();
        List<Map<String, String>> packsNodeList = new List<Map<String, String>>();
        List<Map<String, String>> refillsNodeList = new List<Map<String, String>>();
        List<Map<String, String>> adjustmentNodeList = new List<Map<String, String>>();
        
        Map<String, String> node;

        /* SOS */
        String [] arrayListState = new List<String>();
        arrayListState.add('Cargado');
        arrayListState.add('Consumido');
        arrayListState.add('Cargado2');
        arrayListState.add('Consumido2');

        String [] arrayListCancelado = new List<String>();
        arrayListCancelado.add('Si');
        arrayListCancelado.add('No');

        String [] arrayListPaymentMethod = new List<String>();
        arrayListPaymentMethod.add('Efecitvo');
        arrayListPaymentMethod.add('Tarjeta Credito');
        arrayListPaymentMethod.add('Tarjeta Debito');
        arrayListPaymentMethod.add('Puntos Personal');
        

        /* PACKS */
        String [] arrayListPack = new List<String>();
        arrayListPack.add('Plan Nacional 4G');
        arrayListPack.add('Plan Internacional');
        arrayListPack.add('Plan Familia');
        arrayListPack.add('Plan Internet 40MB');
        arrayListPack.add('Plan Numeros Free');

        String [] arrayListUnitMeasure = new List<String>();
        arrayListUnitMeasure.add('Minutos');
        arrayListUnitMeasure.add('MB');


        String [] arrayListDetalle = new List<String>();
        arrayListDetalle.add('Minutos Libres por un mes');
        arrayListDetalle.add('100 MB Libres por un mes');
        arrayListDetalle.add('60 Minutos Libres por mes');


        /* Refill History*/
        String [] arrayListChannels = new List<String>();
        arrayListChannels.add('SMS');
        arrayListChannels.add('Web');
        arrayListChannels.add('ROL');
        arrayListChannels.add('IVR');

        String [] arrayListBenefitTypes = new List<String>();
        arrayListBenefitTypes.add('De Unidades');
        arrayListBenefitTypes.add('De Crédito');

        String [] arrayListAmounts = new List<String>();
        arrayListAmounts.add('129');
        arrayListAmounts.add('901');
        arrayListAmounts.add('457');
        arrayListAmounts.add('986');
        arrayListAmounts.add('726');
        arrayListAmounts.add('424');
        arrayListAmounts.add('175');
        arrayListAmounts.add('547');
        arrayListAmounts.add('118');
        arrayListAmounts.add('575');
        arrayListAmounts.add('888');
        arrayListAmounts.add('996');
        arrayListAmounts.add('892');
        arrayListAmounts.add('162');

        String [] arrayListBenefitAmounts = new List<String>();
        arrayListBenefitAmounts.add('300');
        arrayListBenefitAmounts.add('350');
        arrayListBenefitAmounts.add('400');

        String [] arrayListAdjustmentMotive= new List<String>();
        arrayListAdjustmentMotive.add('Reintegro');
        arrayListAdjustmentMotive.add('Nota de credito');
        arrayListAdjustmentMotive.add('Nota de debito');


        /* SOS */
        for(Integer i = 0; i < 5; i++)
        {
            String inicio = String.valueOf((system.now()-i).format());
            String fin = String.valueOf((system.now()-i+7).format());
            node = new Map<String, String>();
            node.put('FechaHoraIni', inicio);
            node.put('FechaHoraFin', fin);
            node.put('Monto', String.valueOf(randomWithLimit(999999)));
            node.put('Estado', arrayListState[randomWithLimit(3)]);
            node.put('Cancela', arrayListCancelado[randomWithLimit(1)]);
            node.put('FechaPago', fin);
            node.put('MedioPago', arrayListPaymentMethod[randomWithLimit(3)]);
    
            
            sosNodeList.add(node);
        }

        /*PACKS*/
        for(Integer i = 0; i < 5; i++)
        {
            String inicio = String.valueOf((system.now()-i).format());
            String fin = String.valueOf((system.now()-i+7).format());
            node = new Map<String, String>();
            node.put('acquisitionDate', inicio);
            node.put('dueDate', fin);
            node.put('name', arrayListPack[randomWithLimit(4)]);
            node.put('amount', String.valueOf(randomWithLimit(99999)));
            node.put('detail', arrayListDetalle[randomWithLimit(2)]);
            node.put('detailType', 'UNIDADES OTORGADAS');
            node.put('consumptionCriterion','Algun criterio');
            node.put('quantity', String.valueOf(randomWithLimit(999)));
            node.put('UnitMeasure', arrayListUnitMeasure[randomWithLimit(1)]);
            node.put('dueDate2', fin);

            packsNodeList.add(node);
        }

        /*Refill History*/
        for(Integer i = 0; i < 5; i++)
        {
            String inicio = String.valueOf((system.now()-i).format());
            String fin = String.valueOf((system.now()-i+7).format());
            node = new Map<String, String>();
            node.put('Channel', arrayListChannels[randomWithLimit(3)]);
            node.put('StartDate', inicio);
            node.put('EndDate', fin);
            node.put('Description', 'Saldo virtual');
            Decimal amount = Decimal.valueOf(arrayListAmounts[randomWithLimit(13)]);
            node.put('Amount', String.valueOf(amount));
            node.put('Benefit', 'Con Beneficio');
            node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
            node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
            node.put('CreditUnitBenefits', 'Valor número uno');
            node.put('BenefitStartDate', inicio);
            node.put('BenefitEndDate', fin);

            refillsNodeList.add(node);
        }

        /*Ajuste History*/
        for(Integer i = 0; i < 5; i++)
        {
            String inicio = String.valueOf((system.now()-i).format());
            String fin = String.valueOf((system.now()-i+7).format());
            node = new Map<String, String>();
            node.put('StartDate', inicio);
            node.put('Motivo', arrayListAdjustmentMotive[randomWithLimit(2)]);
            Decimal amount = Decimal.valueOf(arrayListAmounts[randomWithLimit(13)]);
            node.put('Amount', String.valueOf(amount));
            

            adjustmentNodeList.add(node);
        }
        
       // refillsInfo1.put('RefillsSOSList', sosNodeList);
       // refillsInfo2.put('PacksList', packsNodeList);
       // refillsInfo3.put('RefillsList', refillsNodeList);

        refillsInfo.put('RefillsSOSList', sosNodeList);
        refillsInfo.put('PacksList', packsNodeList);
        refillsInfo.put('RefillsList', refillsNodeList);
        refillsInfo.put('AdjustmentList', adjustmentNodeList);
        
        outMap.put('Result', refillsInfo);
    }
}