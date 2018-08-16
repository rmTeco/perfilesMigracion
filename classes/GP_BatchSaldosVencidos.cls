global class GP_BatchSaldosVencidos implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC){
        String query =  ' Select Id, Socio__c, Vencimiento__c, Puntos__c, Socio__r.Cuenta__c' + 
                        ' From GP_Saldo_por_vencimiento__c' + 
                        ' Where Vencimiento__c < ' + String.valueOf(Date.Today()) + 
                        ' AND Puntos__c >= 0' +
                        ' AND Socio__c != null';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<GP_Saldo_por_vencimiento__c> scope){

        List<GP_Socio__c> actualizarAcumList = listarAcumAActualizar(scope);
        
        if(actualizarAcumList.size() > 0) {
            update actualizarAcumList;
        }
        if(scope.size() > 0) {
            delete scope;
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }

    private List<GP_Socio__c> listarAcumAActualizar(List<GP_Saldo_por_vencimiento__c> listSaldos) {
        Set<String> idsAcums = new Set<String>();
        List<GP_Socio__c> result = new List<GP_Socio__c>();
        Map<String, GP_Socio__c> acumsMap = new Map<String, GP_Socio__c>();
        for(GP_Saldo_por_vencimiento__c saldo : listSaldos) {
            if(!idsAcums.contains(saldo.Id)) {
                idsAcums.add(saldo.Socio__c);
            }
        }
        List<GP_Socio__c> acums = [Select Id, Saldo_total__c 
                                    From GP_Socio__c 
                                    Where Id in :idsAcums];
        if(acums.size() > 0) {
            for(GP_Socio__c acum : acums) {
                if(!acumsMap.containsKey(acum.Id)) {
                    acumsMap.put(acum.Id, acum);
                }
            }
            for(GP_Saldo_por_vencimiento__c saldo : listSaldos) {
                if(acumsMap.containsKey(saldo.Socio__c)) {
                    GP_Socio__c ac = acumsMap.get(saldo.Socio__c);
                    ac.Saldo_total__c -= saldo.Puntos__c;
                }
            }
            result = acumsMap.values();
        }

        return result;
    }
}