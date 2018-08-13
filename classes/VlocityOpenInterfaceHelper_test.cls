/**
 * Created by Alex Lazarev on 24/11/17.
 */

@IsTest
private class VlocityOpenInterfaceHelper_test {

    @isTest
    static void VOI_list() {
        Map<String,Object> testMap = new Map<String, Object>();
        Object objL = (Object)'{"Id":"5006C0000019mAtQAI","Nombre":"Problemas con recarga","Status":"Closed","Number":"00014701","Type":"Caso","Date":"2017-11-17T20:01:29.000Z","MinDate":"2017-10-05"},{"Id":"5006C0000019mAjQAI","Nombre":"Título","Status":"New","Number":"00014699","Type":"Caso","Date":"2017-11-17T19:53:27.000Z","MinDate":"2017-10-05"},{"Id":"8016C0000000OgSQAU","Nombre":"Problemas con recarga","Status":"Draft","Number":"00009888","Type":"Orden","Date":"2017-10-26T13:05:41.000Z","MinDate":"2017-10-05"}';
        String jsonNode = 'Negotiations';
        testMap.put(jsonNode,objL);

        Test.startTest();

        List<Object> objList = VlocityOpenInterfaceHelper.getListObjectsFromMap(testMap,jsonNode);
        Test.stopTest();
        System.debug(objList);

        System.assertEquals((String)objL,(String)objList[0]);

    }

    @isTest
    static void VOI_node() {
        Map<String,Object> testMap = new Map<String, Object>();
        Object objN = (Object)'{"Id":"5006C0000019mAtQAI","Nombre":"Problemas con recarga","Status":"Closed","Number":"00014701","Type":"Caso","Date":"2017-11-17T20:01:29.000Z","MinDate":"2017-10-05"}';
        String jsonNode = 'Negotiations';
        testMap.put(jsonNode,objN);

        Test.startTest();

        List<Object> objList = VlocityOpenInterfaceHelper.getListObjectsFromMap(testMap,jsonNode);
        Test.stopTest();
        System.debug(objList);

        System.assertEquals((String)objN,(String)objList[0]);

    }
}