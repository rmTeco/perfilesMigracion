global with sharing class taSalesStockAvailability implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('SearchProduct'))
            {
                SearchProduct(inputMap, outMap);
            }
            if (methodName.equals('ParseIF221'))
            {
                ParseIF221(inputMap, outMap, options);
            }
            result = false;
        }
        catch(Exception e)
        {
            System.debug('taSalesStockAvailability:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    public static Boolean SearchProduct(Map<String,Object> inputMap, Map<String, Object> outMap) {
        System.debug('SearchProduct');
        Boolean result = true;
        try
        {
            Map<String,Object> typeAheadBlock = (Map<String,Object>) inputMap.get('TypeAheadProducto-Block');
            String id = (String)typeAheadBlock.get('Id');
            List<Product2> productsList = [SELECT Id FROM Product2 WHERE Id =: id];

            if (productsList.isEmpty()) {
                result = false;
            }
            return true;
        }
        catch(Exception e)
        {
            result = false;
            return false;
        }
        finally {
            outMap.put('RemoteResult', result);
        }
    }
    public static void ParseIF221(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        System.debug('ParseIF221');       
        Map<String,Object> mapField;
        Map<String,Object> mapField2;
        String codDeposito;
        String stockProducto;
        String stockAux;
        String cantidadDiponible;
        List<String> WHList;
        //Map<String,Integer> StockMap;
        List<Map<String,Object>> outList = new List<Map<String,Object>>();
        Map<String,Object> outMapAux = new Map<String,Object>();
        List<Object> listaNMU;
        List<Object> outList2 = new List<Object>();
        List<Object> listaPorCodigoStock;
        String AuxProdCode;
        String AuxStr;
        String AuxInt;
        WHList = new List<String>();
        Map <String,Object> StockMap = new  Map<String,Object>();
        Boolean result = false;

        try{
            String ProductCode = (String) options.get('ProdutCode');
            String stockProdCode = (String) options.get('stockProdCode');
            system.debug('ProductCode = '+ProductCode);
            //system.debug('listaDepositosConDisponibilidad ='+ options.get('listaDepositosConDisponibilidad'));
            //System.debug('inputMap )' + inputMap);
            //ProductCode = 'PER1228AI';
            //stockProdCode = 'MTPL';

            List<Object> listaDeposito = (List<Object>) options.get('listaDepositosConDisponibilidad');

            System.debug('listaDeposito = ' + listaDeposito);

            

            for (Object itemDeposito:listaDeposito){
                mapField = (Map<String,Object>) itemDeposito;
                codDeposito = (String) mapField.get('codDeposito');
                WHList.add(codDeposito);
                System.debug('codDeposito = ' + codDeposito);
                outMapAux.put('codDeposito',codDeposito);
                listaNMU = (List<Object>) mapField.get('listaCodNMU');
                System.debug('listaNMU = ' + listaNMU);
                for (Object itemNMU:listaNMU){                
                    mapField = (Map<String,Object>) itemNMU;
                    listaPorCodigoStock = (List<Object>) mapField.get('listaPorCodigoStock');
                    System.debug('listaPorCodigoStock = ' + listaPorCodigoStock);
                    AuxProdCode = (String) mapField.get('codNMU');
                    System.debug('AuxProdCode = ' + AuxProdCode);
                    if (AuxProdCode == ProductCode){
                        for (Object itemStock:listaPorCodigoStock){                
                            mapField2 = (Map<String,Object>) itemStock;
                            stockProducto = (String) mapField2.get('stockProducto');   
                            System.debug('stockProducto = ' + stockProducto); 
                            system.debug(stockProdCode + ' es igual a ' +stockProducto+ '?');
                            if (stockProducto == stockProdCode){
                                system.debug('mapField2' + mapField2);
                                cantidadDiponible = (String) mapField2.get('cantidadDisponible');
                            }
                        }
                    }
                }
                outMapAux.put('cantidadDiponible',cantidadDiponible);
                StockMap.put(codDeposito,cantidadDiponible);
                System.debug('cantidadDiponible= ' + cantidadDiponible);
                System.debug('outMapAux= ' + outMapAux);
                outList.add(outMapAux);    
            }
            System.debug('outList= ' + outList);

            //Query database by WH Id to get needed out fields

            List<vlocity_cmt__BusinessSite__c> BSList = [SELECT AssociatedWarehouseId__c, Name, vlocity_cmt__StreetAddress__c, PointOfSaleAddressNumber__c, PostOfficeHours__c, PostOfficePhone__c  FROM vlocity_cmt__BusinessSite__c WHERE AssociatedWarehouseId__c IN :WHList];
            

            //Add stock quantity to the query list        

            for(vlocity_cmt__BusinessSite__c itemBSList:BSList){
                mapField = new Map<String,Object>();
                mapField.put('AssociatedWarehouseId__c',itemBSList.AssociatedWarehouseId__c);
                mapField.put('Name',itemBSList.Name);
                mapField.put('vlocity_cmt__StreetAddress__c',itemBSList.vlocity_cmt__StreetAddress__c);
                mapField.put('PointOfSaleAddressNumber__c',itemBSList.PointOfSaleAddressNumber__c);
                mapField.put('PostOfficeHours__c',itemBSList.PostOfficeHours__c);
                mapField.put('PostOfficePhone__c',itemBSList.PostOfficePhone__c);
                AuxStr = (String) itemBSList.AssociatedWarehouseId__c;
                AuxInt = (String) StockMap.get(AuxStr);
                mapField.put('Cantidad',AuxInt);
                outList2.add(mapField);
            }

            outMap.put('depositos', outList2);
            result = outList2.size() > 0;
        }
        catch(Exception e){
            System.debug('taSalesStockAvailability:ParseIF221 -> exception: '+e);
        }
        finally{
            outMap.put('RemoteResult', result);
        }               
    }
}