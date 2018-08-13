/**
 * Created by bodie2003 on 23/11/17.
 */

@IsTest
private class ScratchCard_test {

    @IsTest static void invoke_getCardInfo_correct(){
        String methodName = 'getCardInfo';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();

        ScratchCard testedClass = new ScratchCard();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertNotEquals(empty, outMap.get('dataInput'));
    }

}