@isTest
global class taFetchDataTest {

    static testMethod void Testgetstatecode() {
       
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
       
        taFetchData ctrl = new taFetchData();
        ctrl.invokeMethod('getStateCode', inputMap, outMap, null);
       
    }


 

}