global with sharing class RefillHistoryPacksHandler implements vlocity_cmt.VlocityOpenInterface{

    global RefillHistoryPacksHandler(){}

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) 
    {
        Boolean result = true;
        try {
            if (methodName.equals('getDummyData'))
                getDummyData(methodName, input, outMap, options);

            return result;
        }
        catch(Exception e) {
            System.debug('RefillHistoryPacksHandler: invokeMethod -> exception: ' + e);
            return false;
        }
        
    }

    static Integer randomWithLimit(Integer upperLimit)
    {
        Integer rand = Math.round(Math.random()*1000);
        return Math.mod(rand, upperLimit);
    }

    global static void getDummyFilterData(List<Map<String, String>> PacksNodeFilter)
    {
        String [] arrayListPack = new List<String>();
        arrayListPack.add('Plan Nacional 4G');
        arrayListPack.add('Plan Internacional');
        arrayListPack.add('Plan Familia');
        arrayListPack.add('Plan Internet 40MB');
        arrayListPack.add('Plan Numeros Free');

        Map<String, String> node;
        
        for(Integer i = 0; i < 5; i++)
        {
            node = new Map<String, String>();
            node.put('namePack', arrayListPack[i]);
            PacksNodeFilter.add(node);
        }
    }

    global static void getDummyData(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {    
        String startDateScope = (String) input.get('startDateFilter');
        String endDateScope = (String) input.get('endDateFilter');
        String namePackScope = (String) input.get('namePack');

        Map<String, Object> packsInfo = new Map<String, Object>();
        List<Map<String, String>> packsNodeList = new List<Map<String, String>>();
        Map<String, String> node;

        /*Console Log*/
        system.debug('startDateScope: ' + startDateScope);
        system.debug('endDateScope: ' + endDateScope);
        system.debug('namePackScope: ' + namePackScope);

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


        /*
        List<Map<String, String>> PacksNodeFilter = new List<Map<String, String>>();
        node = new Map<String, String>();
        
        for(Integer i = 0; i < 5; i++)
        {
            node = new Map<String, String>();
            node.put('filter', arrayListPack[i]);
            PacksNodeFilter.add(node);
        }*/   

        List<Map<String, String>> PacksNodeFilter = new List<Map<String, String>>();

        if(String.isNotBlank(namePackScope))
        {
            getDummyFilterData(PacksNodeFilter);
            packsInfo.put('PacksFilter', PacksNodeFilter);
        }

        
        if(namePackScope == 'Plan Nacional 4G')
        {
            if(String.isNotBlank(startDateScope) && String.isNotBlank(endDateScope))
            {
                for(Integer i = 0; i < 30; i++)
                {
                    if(((system.today()-i) >= date.valueOf(startDateScope)) && (system.today()-i) <= date.valueOf(endDateScope))
                    {
                        String inicio = String.valueOf((system.now()-i).format());
                        String fin = String.valueOf((system.now()-i+7).format());
                        node = new Map<String, String>();
                        node.put('acquisitionDate', inicio);
                        node.put('dueDate', fin);
                        node.put('name', arrayListPack[0]);
                        node.put('amount', String.valueOf(randomWithLimit(99999)));
                        node.put('detail', arrayListDetalle[randomWithLimit(2)]);
                        node.put('detailType', 'UNIDADES OTORGADAS');
                        node.put('consumptionCriterion','Algun criterio');
                        node.put('quantity', String.valueOf(randomWithLimit(999)));
                        node.put('UnitMeasure', arrayListUnitMeasure[randomWithLimit(1)]);
                        node.put('dueDate2', fin);

                        packsNodeList.add(node);
                    }
                }
            }

        }
        else if(namePackScope == 'Plan Internacional')
        {
            for(Integer i = 0; i < 50; i++)
            {

                String inicio = String.valueOf((system.now()-i).format());
                String fin = String.valueOf((system.now()-i+7).format());
                node = new Map<String, String>();
                node.put('acquisitionDate', inicio);
                node.put('dueDate', fin);
                node.put('name', arrayListPack[1]);
                node.put('amount', String.valueOf(randomWithLimit(99999)));
                node.put('detail', arrayListDetalle[randomWithLimit(2)]);
                node.put('detailType', 'UNIDADES OTORGADAS');
                node.put('consumptionCriterion','Algun criterio');
                node.put('quantity', String.valueOf(randomWithLimit(999)));
                node.put('UnitMeasure', arrayListUnitMeasure[randomWithLimit(1)]);
                node.put('dueDate2', fin);

                packsNodeList.add(node);
            }
        }
        else if(namePackScope == 'Plan Familia')
        {
            for(Integer i = 0; i < 115; i++)
            {
                if(((system.today()-i) >= date.valueOf(startDateScope)) && (system.today()) <= date.valueOf(endDateScope))
                {
                    String inicio = String.valueOf((system.now()-i).format());
                    String fin = String.valueOf((system.now()-i+7).format());
                    node = new Map<String, String>();
                    node.put('acquisitionDate', inicio);
                    node.put('dueDate', fin);
                    node.put('name', arrayListPack[2]);
                    node.put('amount', String.valueOf(randomWithLimit(99999)));
                    node.put('detail', arrayListDetalle[randomWithLimit(2)]);
                    node.put('detailType', 'UNIDADES OTORGADAS');
                    node.put('consumptionCriterion','Algun criterio');
                    node.put('quantity', String.valueOf(randomWithLimit(999)));
                    node.put('UnitMeasure', arrayListUnitMeasure[randomWithLimit(1)]);
                    node.put('dueDate2', fin);

                    packsNodeList.add(node);
                }
            }
        }
        else if(namePackScope == 'Plan Internet 40MB')
        {
            for(Integer i = 0; i < 40; i++)
            {
                String inicio = String.valueOf((system.now()-i).format());
                String fin = String.valueOf((system.now()-i+7).format());
                node = new Map<String, String>();
                node.put('acquisitionDate', inicio);
                node.put('dueDate', fin);
                node.put('name', arrayListPack[3]);
                node.put('amount', String.valueOf(randomWithLimit(99999)));
                node.put('detail', arrayListDetalle[randomWithLimit(2)]);
                node.put('detailType', 'UNIDADES OTORGADAS');
                node.put('consumptionCriterion','Algun criterio');
                node.put('quantity', String.valueOf(randomWithLimit(999)));
                node.put('UnitMeasure', arrayListUnitMeasure[randomWithLimit(1)]);
                node.put('dueDate2', fin);

                packsNodeList.add(node);
            } 
        }
        else if(namePackScope == 'Plan Numeros Free')
        {
            for(Integer i = 0; i < 40; i++)
            {
                String inicio = String.valueOf((system.now()-i).format());
                String fin = String.valueOf((system.now()-i+7).format());
                node = new Map<String, String>();
                node.put('acquisitionDate', inicio);
                node.put('dueDate', fin);
                node.put('name', arrayListPack[4]);
                node.put('amount', String.valueOf(randomWithLimit(99999)));
                node.put('detail', arrayListDetalle[randomWithLimit(2)]);
                node.put('detailType', 'UNIDADES OTORGADAS');
                node.put('consumptionCriterion','Algun criterio');
                node.put('quantity', String.valueOf(randomWithLimit(999)));
                node.put('UnitMeasure', arrayListUnitMeasure[randomWithLimit(1)]);
                node.put('dueDate2', fin);

                packsNodeList.add(node);
            }
        }
        else 
        {
            for(Integer i = 0; i < 64; i++)
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
        }

        packsInfo.put('PacksList', packsNodeList);
        
        outMap.put('Result', packsInfo);
    }
}