@isTest
public with sharing class GP_testExceptions {

    public static testMethod void testGP_APIException() {
        Test.StartTest();
        GP_APIException ex = new GP_APIException('ERROR');
        Test.StopTest();
        System.assertEquals('ERROR',ex.getMessage());
    }

}