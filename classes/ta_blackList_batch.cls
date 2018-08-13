global with sharing class ta_blackList_batch implements Database.Batchable<sObject>, Database.AllowsCallouts{

    global final String query = 'SELECT Name, MSISDN__c, Blacklist_Remove_Date__c FROM Asset WHERE BlackList__c = true AND Blacklist_Remove_Date__c <= ' + String.ValueOf(Date.today());

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(this.query);
    }

    global void execute(Database.BatchableContext BC, list<Asset> lstAssets){
        List<Asset> successAssets = new List<Asset>();

        for(Asset ast : lstAssets){
            try{
                Map<String, Object> input = new Map<String, Object>();
                Map<String, Object> output = new Map<String, Object>();
                Map<String, Object> options = new Map<String, Object>();

                Map<String, Object> params = new Map<String, Object>();
                params.put('nroLinea', ast.MSISDN__c);

                input.put('params', params);

                vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                integProcServ.invokeMethod('IFS_S114', input, output, options);

                String success;
                Map<String, Object> resp;

                if(Test.isRunningTest()){
                    success = 'true';
                } else{ 
                    resp = (Map<String, Object>) output.get('IPResult');
                    success = (String) resp.get('respuesta');
                }

                if(success.equals('true')){
                    ast.Blacklist_Remove_Date__c = null;
                    ast.BlackList__c = false;
                    successAssets.add(ast);
                    //System.debug('Se eliminó correctamente de blacklist al asset ' + ast.Id);
                } else{
                    System.debug('No se pudo sacar de blacklist al asset ' + ast.Id + ' - ' + resp);
                }

            } catch(Exception ex){
                System.debug('Error al remover la línea ' + ast.MSISDN__c + ' de blacklist: ' + ex.getMessage());
                System.debug(ex.getStackTraceString());
            }
        }

        if(successAssets.size() > 0)
            update successAssets;

    }

    global void finish(Database.BatchableContext BC){

    }

}