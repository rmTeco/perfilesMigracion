global with sharing class CommunityIntegration implements vlocity_cmt.VlocityOpenInterface {
    
    global CommunityIntegration(){}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try {
            if (methodName.equals('Get_IFS_S439')) {
                Get_IFS_S439(inputMap, outMap, options);
            }
            if (methodName.equals('Get_IFS_S139')) {
                Get_IFS_S139(inputMap, outMap, options);
            }
        }
        catch(Exception e){
            System.debug('An unexpected error has occured: ' + e.getMessage());
            return false;
        }
        return result;
    }
    
    global void Get_IFS_S439(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

         try {
            String AssetId = (String)inputMap.get('AssetId');
            Asset assDetail = [SELECT Id, Name, MSISDN__c FROM Asset WHERE Id=:AssetId];
            String linenumber = assDetail.MSISDN__c;
            String nameAsset = assDetail.Name;
            String params = '{"params":{"identificadorRecurso":"'+linenumber+'"}}';
            inputMap = (Map<String, Object>)JSON.deserializeUntyped(params);

            // Vlocity Integration Procedure Obj
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();

            // Getting S087 data from IP // Infoteinment
            integProcServ.invokeMethod('IFS_S439', inputMap, outMap, options);
            Map<String,Object> complementoOutMap = (Map<String, Object>)JSON.deserializeUntyped('{"AssetName":"' + nameAsset + '"}');
            ((Map<String, Object>) outMap.get('IPResult')).put('AssetDetail', complementoOutMap);
            Map<String, Object> response = (Map<String, Object>) outMap.get('IPResult');
            String error = (String) outMap.get('error');

        } catch (Exception ex) {
            System.debug('GetIntegration exception: ' + ex.getStackTraceString());
        }
    }

    global void Get_IFS_S139(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

         try {
            String AssetId = (String)inputMap.get('AssetId');
            Asset assDetail = [SELECT Id, Name, MSISDN__c FROM Asset WHERE Id=:AssetId];
            String linenumber = assDetail.MSISDN__c;
            String params = '{"body":{"codigoAcceso":{"identificadorRecurso":"'+linenumber+'"}}}';
            inputMap = (Map<String, Object>)JSON.deserializeUntyped(params);

            // Vlocity Integration Procedure Obj
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();

            // Getting S087 data from IP // Infoteinment
            integProcServ.invokeMethod('IFS_S139', inputMap, outMap, options);
            Map<String, Object> response = (Map<String, Object>) outMap.get('IPResult');
            String error = (String) outMap.get('error');

        } catch (Exception ex) {
            System.debug('GetIntegration exception: ' + ex.getStackTraceString());
        }
    }
    
}