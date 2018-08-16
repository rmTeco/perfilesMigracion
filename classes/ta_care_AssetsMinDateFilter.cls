/**
 * Created by Alex Lazarev 23/11/2017
 *
 * Implements VlocityOpenInterface
 * Provides the needed logic to support OS JSON VOI translation
 *
 * Objects: Custom Setting
 *
 * Important: The method uses a VlocityOpenInterface integration structure
 *
 * Version: 1.0
 */

global with sharing class ta_care_AssetsMinDateFilter implements vlocity_cmt.VlocityOpenInterface {

    global ta_care_AssetsMinDateFilter(){}

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {

        Boolean result = true;
        try {

            if (methodName.equals('getAssetMinDate')) {

                getAssetMinDate(input, outMap, options);
            }
            result = false;

        } catch(Exception e) {  System.debug('ta_care_AssetsMinDateFilter: invokeMethod -> exception: '+e); result = false; outMap.put('error', e.getMessage()); }
        return result;
    }

    void getAssetMinDate(Map<String, Object> inputMap,  Map<String, Object> outMap, Map<String, Object> options) {
        try{
            AssetsMinimalDateFilter__c assetFilterDate = AssetsMinimalDateFilter__c.getValues('FilterDate');

            outMap.put('AssetMinDate',assetFilterDate.AssetMinDate__c);
        }catch (Exception e){
            System.debug('getAssetMinDate: invokeMethod -> exception: '+e);
        }
    }


}