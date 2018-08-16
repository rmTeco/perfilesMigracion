@isTest
public with sharing class KAL_datosEntradaControllerTest{

    @isTest
   public static void obtenerLaOrdenActualDelUsuario()
   {
       Test.startTest();
       List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
       User usuario = KAL_DatosTest.crearUsuarioDeComunidad(accs[0].id);
       
       Order orden = KAL_DatosTest.crearUnaOrdenDraftParaElUsuario(accs[0].id,usuario.id,null,null);
               
       system.runAs(usuario){
           Order ordenCreada = KAL_datosEntradaController.getOrdenActualUsuario();        
           system.assertEquals(orden.id, ordenCreada.id);
       }
         
         Test.stopTest();
   }
   
    
    @isTest
    public static void updateDatosAutorizadoTest(){
        String param = '({DocumentNumber=0000000, DocumentType=DNI, FirstName=FirstName, LastName=LastName})';
        String email = 'zaraza@hotmail.com';
        String telefono = '43232323';
        String direccionNumeradaI = 'Calle Falsa 123';
        String provinciaI = 'pobrincia';
        String cityI = 'Buenos Aires';
        String codPostalI = '1431';
        Boolean checkboxDomicilio = false;//Entonces el método devuelve 'Store Pick Up';

        Account accs = new Account();
        accs.name = 'a';
        insert accs;

        User usuario = KAL_DatosTest.crearUsuarioDeComunidad(accs.id);
        Order orden = KAL_DatosTest.crearUnaOrdenDraftParaElUsuario(accs.id,usuario.id,null,null);

            System.runAs(usuario){
                Test.startTest();
                KAL_datosEntradaController.updateDatosAutorizado(param, email, telefono, direccionNumeradaI, provinciaI, cityI, codPostalI, checkboxDomicilio);
                Order laOrder = KAL_utils.obtenerOrdenActualDelUsuario(usuario.id);
                system.assertEquals(param, laOrder.vlocity_cmt__ShippingName__c);
                system.assertEquals(email, laOrder.ShippingEmailContact__c);
                system.assertEquals(telefono, laOrder.ShippingHomePhone__c);
                system.assertEquals(direccionNumeradaI, laOrder.ShippingStreet);
                system.assertEquals(provinciaI, laOrder.ShippingCity);
                system.assertEquals(cityI, laOrder.ShippingState);
                system.assertEquals(codPostalI, laOrder.ShippingPostalCode);
                system.assertEquals('Store Pick Up', laOrder.Delivery_Method__c);
                Test.stopTest();
            }
    }
   
   @isTest
   public static void testgetUserComunidad() {

       Account acct = new Account();
       acct.name = 'a';
       acct.BillingStreet = 'Amenabar 3807';
       acct.BillingState = 'Ciudad Autónoma de Buenos Aires';
       acct.BillingCity = 'Buenos Aires';
       acct.BillingPostalCode = '1429';
       insert acct;
     
       User usuario = KAL_DatosTest.crearUsuarioDeComunidad(acct.id);        

        System.runAs(usuario) {
             // The following code runs as user 'u'
           System.debug('Test: ' + UserInfo.getUserName());
           Map<String,String> datosUsuarioComu = KAL_datosEntradaController.getUserComunidad();
           System.assertEquals(acct.BillingPostalCode, datosUsuarioComu.get('CodigoPostal'));
        }
   }

     @isTest
    public static void getDocumentTypesTest() {
    
        Test.startTest();
           List<Object> documento =  KAL_datosEntradaController.getDocumentTypes();
        Test.stopTest();
         
        Map<String,Object> var = new Map<String,Object>();
        var.put('label', 'DNI');
        var.put('value', 'DNI');

        System.assertEquals(var, (Map<String,Object>) documento[0]);
    } 

    @isTest
    public static void getPlazosEntregaTest(){
        Map<String, Object> plazosDeEntrega = new Map<String, Object>();

        vlocity_cmt__CalculationMatrix__c matriz = new vlocity_cmt__CalculationMatrix__c(
            name = 'ShippingTimeConfiguration'
        );
        insert matriz;

        vlocity_cmt__CalculationMatrixVersion__c versionMatriz = new vlocity_cmt__CalculationMatrixVersion__c(
            name = 'ShippingTimeConfiguration v1',
            vlocity_cmt__CalculationMatrixId__c = matriz.Id
        );
        insert versionMatriz;
        vlocity_cmt__CalculationMatrixRow__c row1 = new vlocity_cmt__CalculationMatrixRow__c(
            vlocity_cmt__CalculationMatrixVersionId__c = versionMatriz.id,
            vlocity_cmt__InputData__c = '{"DistributionZone":"AMBA","ShippingMode":"Express"}',
            vlocity_cmt__OutputData__c = '{"MinimumShippingDays":1.0,"ShippingDays":1.0}'
        );
        insert row1;

        List<Object> listaEsperada = new List<Object>();
        Map<String,Object> inputData = (Map<String,Object>) JSON.deserializeUntyped('{"DistributionZone":"AMBA","ShippingMode":"Express"}');
        Map<String,Object> outputData = (Map<String,Object>) JSON.deserializeUntyped('{"MinimumShippingDays":1.0,"ShippingDays":1.0}');
        Map<String,Object> rowMap = new Map<String,Object>();
        rowMap.put('in', inputData);
        rowMap.put('out', outputData);
        listaEsperada.add(rowMap);

        Map<String, Object> resultadoEsperado = new Map<String, Object>();
        resultadoEsperado.put('matrizEnvio', listaEsperada);

        Test.startTest();
            plazosDeEntrega =  KAL_datosEntradaController.getPlazosEntrega();
        Test.stopTest();

        System.assertEquals(resultadoEsperado, plazosDeEntrega);
    } 

    @isTest
    public static void APEXconseguirDominiosTest(){
        ValidEmailDomain__c emailDomain = new  ValidEmailDomain__c();
        emailDomain.Name= '@prueba.com';
        insert emailDomain;

        Test.startTest();
            List<String> dominios = KAL_datosEntradaController.APEXconseguirDominios();
        Test.stopTest();

        System.assertEquals(emailDomain.Name, dominios[0]);

    }

    @isTest
    public static void GetTaxesTest(){
      String delivery = 'Ciudad Autónoma de Buenos Aires';

      Test.startTest();
      List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
      User usuario = KAL_DatosTest.crearUsuarioDeComunidad(accs[0].id);
                     
      system.runAs(usuario){
        Order orden = KAL_integrationGetTaxesTest.CreateOrderForRequest();      
        KAL_datosEntradaController.GetTaxes(delivery);                
      }         
      Test.stopTest();       
    }

}