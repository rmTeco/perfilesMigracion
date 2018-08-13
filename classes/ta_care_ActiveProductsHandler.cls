/**
 * Created by Alex Lazarev 26/10/2017
 *
 * Implements VlocityOpenInterface
 * Provides the needed logic to support OS JSON VOI translation
 *
 * Objects: None - JSON translation for OS
 *
 * Important: The method uses a VlocityOpenInterface integration structure
 *
 * Version: 2.1
 * * Updated with only Main method call to avoid code duplicate v2.1
 * * Updated to call IP v2.0
 * + Implemented multiple methods
 */

global with sharing class ta_care_ActiveProductsHandler implements vlocity_cmt.VlocityOpenInterface {
    global ta_care_ActiveProductsHandler() { }

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;

        try {
            if (methodName.Equals('GetActiveProductsMain')) {
                GetActiveProductsMain(inputMap, outMap, options);
            }
        }
        catch(Exception ex) {
            outMap.put('error', ex.getStackTraceString());
            result = false;
        }
        return result;
    }

    global void GetActiveProductsMain(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        Boolean debug = true;
         try {
            if(debug) System.debug('inputMap: ' + inputMap);
            //outMap = null;
            Object empty = null;
            outMap.put('CbsNode', empty);
            outMap.put('InfoteinmentNode',empty);
            outMap.put('IPResult', empty);

            // Vlocity Integration Procedure Obj
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();

            // Getting S087 data from IP // Infoteinment
            integProcServ.invokeMethod('IFS_S087', inputMap, outMap, options);
            if(debug) System.debug('Map<String,Object> Infot: ' + outMap);
            Map<String,Object> responseInfoteinment = (Map<String,Object>) outMap.get('IPResult');
            if(debug) System.debug('Map<String,Object> responseInfoteinment: ' + responseInfoteinment);

            // Getting S020 data from IP // CBS -- Not working!!!
            // Removed from Card ta-MyServices
            //integProcServ.invokeMethod('IFS_S020', inputMap, outMap, options);
            //if(debug) System.debug('Map<String,Object> CBS: ' + outMap);
            //Map<String,Object> responseCBS = (Map<String,Object>) outMap.get('IPResult');
            //if(debug) System.debug('Map<String,Object> responseCBS: ' + responseCBS);

            //outMap.put('CbsNode', (Object)responseCBS);
            outMap.put('InfoteinmentNode',(Object)responseInfoteinment);

            outMap.remove('error');
            outMap.remove('errorCode');
            outMap.remove('IPResult');
            if(debug) System.debug(outMap);
        } catch (Exception ex) {
            System.debug('GetActiveProductsMain exception: ' + ex.getStackTraceString());
        }
    }

}