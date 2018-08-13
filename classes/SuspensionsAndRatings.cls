global class SuspensionsAndRatings implements vlocity_cmt.VlocityOpenInterface {
    
    
    global SuspensionsAndRatings(){}
    
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) 
    {
        Boolean result = true;
        try {
            if (methodName.equals('getHistoric'))
                getHistoric(methodName, input, outMap, options);
            
            return result;
        }
        catch(Exception e) {
            System.debug('SuspensionsAndRatings: invokeMethod -> exception: ' + e);
            return false;
        }
        
    }
    
    
    global static void getHistoric(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        
        System.debug('EN SuspensionsAndRatings-getHistoric');
		System.debug('input:'+input); 

        String parameterAccountId = (String) input.get('accountId');
        String parameterAssetId = (String) input.get('assetId');
        
        System.debug('assetId ' + parameterAssetId);
        
        String parameterProcessTransaction = (String) input.get('processTransaction');
        
        String parameterTypeTransaction =  (String) input.get('typeTransaction');
        String parameterMotiveTransaction =  (String) input.get('motiveTransaction');
        
        List<Map<String, String>> mapHistoryList = new List<Map<String, String>>();
        Map<String, String> mapHistory;
        
              String sqlSelectTransaction;
        if(parameterAccountId != null && !parameterAccountId.equals('S1NNUM3R0')){
        	sqlSelectTransaction = 'SELECT CreatedDate, Name, Asset__c, sinister_type__c FROM Transaction_History__c WHERE Account__c = \''+parameterAccountId+'\'  AND Asset__c <> null';
        	
        }else{
        	sqlSelectTransaction = 'SELECT CreatedDate, Name, Asset__c, sinister_type__c FROM Transaction_History__c WHERE Asset__c = \''+parameterAssetId+'\'';
        }
        
        list<Transaction_History__c> historyList = Database.query(sqlSelectTransaction);
         	
        for(Transaction_History__c history:historyList ){
            String sqlSelectAndFrom = 'SELECT Name, MSISDN__c,Tipo_de_Producto__c, Sub_Status__c FROM Asset '; 
            String sqlWhere = ' WHERE Id = \''+ history.Asset__c +'\'' ;
                       
            If (parameterTypeTransaction!=null && !parameterTypeTransaction.equals('Todos') ){
                sqlWhere = sqlWhere + ' AND Tipo_de_Producto__c= \''  + parameterTypeTransaction +'\'';
            }
            If (parameterMotiveTransaction!=null && !parameterMotiveTransaction.equals('Todos') ){
                sqlWhere = sqlWhere + ' AND Sub_Status__c= \''  + parameterMotiveTransaction +'\'';
            }
            
            String assetSoqlApplied = sqlSelectAndFrom + sqlWhere +' ORDER BY CreatedDate DESC';
           System.debug('assetSoqlApplied:'+assetSoqlApplied);
            list <Asset> assetResult = Database.query(assetSoqlApplied);
			// Asset asset = Database.query(assetSoqlApplied);
			           
             for(Asset asset: assetResult){
			 //if(asset != null){
                mapHistory = new Map<String, String>();
                String strCreatedDate = String.valueOf(history.CreatedDate);
                String strprocessTransaction;
                String nameTransaction;
                String subStatus;               
               
                if (history.sinister_type__c != null){
                    strprocessTransaction = 'Suspension';
                }else{
                    strprocessTransaction = 'Rehabilitacion';
                }
                
                if(asset.MSISDN__c !=null){
                    if(asset.Name != null){
                        nameTransaction='Linea Movil ' + asset.MSISDN__c  +' - '+asset.Name;
                    }else{
                        nameTransaction='Linea Movil ' + asset.MSISDN__c;
                    }
                }else{
                    nameTransaction=asset.Name;
                }
                 
                 if (asset.Sub_Status__c == 'Administrativo'){
                     subStatus = 'Administrativo';
                 }else{
                     subStatus = asset.Sub_Status__c;
                 }
                     
               
                
                if(parameterProcessTransaction == null || parameterProcessTransaction.equals('Todos') || parameterProcessTransaction.equals(strprocessTransaction)){
                    mapHistory.put('DateTransaction', strCreatedDate);
                    mapHistory.put('ProcessTransaction', strprocessTransaction);
                    //mapHistory.put('MotiveTransaction',  asset.Sub_Status__c);
                    mapHistory.put('MotiveTransaction',  subStatus);
                    mapHistory.put('TypeTransaction', asset.Tipo_de_Producto__c);
                     mapHistory.put('NameTransaction', nameTransaction);
                    
                }
                
                mapHistoryList.add(mapHistory);
            }
          
            
        }
        
        outMap.put('Result', mapHistoryList);
    }
    
}