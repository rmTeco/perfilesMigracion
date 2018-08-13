@isTest
private class IFS_EndpointFixer_Test {
    @isTest static  void testFixEndpoint() {
        IFS_EndpointFixer fixer = new IFS_EndpointFixer();
        EndPointService__c endpoint= new EndPointService__c();
        String address= 'www.testing123.com/something/{whatever}/test';
        endpoint.EndPoint__c=address;
        String textToFind = 'whatever';
        String replacementText = 'Live_Forever';
        String results = fixer.fixEndpoint(textToFind, replacementText, endpoint);
        String comparisonText = 'www.testing123.com/something/Live_Forever/test';
        system.assertEquals(results,comparisonText);
    }
    
    @isTest static  void testFixEndpointGetService() {
        IFS_EndpointFixer fixer = new IFS_EndpointFixer();
        EndPointService__c endpoint= new EndPointService__c();
        String address= 'www.testing123.com/something/{whatever}/test';
        endpoint.EndPoint__c=address;
        String textToFind = 'whatever';
        String replacementText = 'Live_Forever';
        String results = fixer.FixEndpointGetService(textToFind, replacementText, endpoint, '');
        String comparisonText = 'www.testing123.com/something/Live_Forever/test';
    }
    
    @isTest static  void testLeaveEndpointAsIs() {
        IFS_EndpointFixer fixer = new IFS_EndpointFixer();
        EndPointService__c endpoint= new EndPointService__c();
        String address= 'www.testing123.com/something/{whatever}/test';
        endpoint.EndPoint__c=address;
        String textToFind = 'wonderwall';
        String replacementText = 'Live_Forever';
        String results = fixer.fixEndpoint(textToFind, replacementText, endpoint);
        String comparisonText = 'www.testing123.com/something/{whatever}/test';
        system.assertEquals(results,comparisonText);
    }
}