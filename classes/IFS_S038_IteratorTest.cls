@isTest 
private class IFS_S038_IteratorTest {
     @isTest static  void test() {
         
         IFS_S038_updateCycleMock mock = new IFS_S038_updateCycleMock();
        mock.status = 200;
        Test.setMock(HttpCalloutMock.class, mock);
         
         List<String> lista = new List<String>();
         
         lista.add('{"test":"testUno"}');
         lista.add('{"test2":"testDos"}');
        
         IFS_S038_Iterator.Iterate(lista);
         
         
     }
}