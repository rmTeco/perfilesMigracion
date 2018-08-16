@isTest
private class taSalesSMSInteractionTest {

  String method = 'ReceiveMessage';
  
  Map<String,Object> input = new Map<String,Object>();
  Map<String,Object> outMap = new Map<String,Object>();
  Map<String,Object> options = new Map<String,Object>();
  
  //testClass.invokeMethod(method, input, outMap, options);

  @isTest
  static void invoke_ValidateClientResponse_OK(){
      String method = 'ValidateClientResponse';
      String testLine = '1234567890';
  
    Map<String,Object> input = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    
    TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
    TestDataFactory.createExpectedMessage();
    
    Account acc = TestDataFactory.createAccounts(1,'Business')[0];
    Order ord = TestDataFactory.createOrders(1, acc)[0];
    Asset ast = TestDataFactory.createAssets(1, acc, testLine)[0];
    acc.Phone = '1234567890';
    update acc;
    
    String smsRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
    String trkRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Tracking').getRecordTypeId();
    
    DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes(300);
    
    CrossObject__c trkCross = new CrossObject__c(
      String1__c = '1234567890',
      Status__c = 'Confirmado',
      Integer1__c = 3,
      DateTime1__c = fechaLimiteVencimiento,
      DateTime3__c = Date.today(), 
      RecordTypeId = trkRecordType
    );
    insert trkCross;
    
    CrossObject__c templateCross =  new CrossObject__c(
      PickList1__c = 'Verificación de Línea Decisora',
      RecordTypeId = smsRecordType,
      Integer1__c=300, Integer2__c=3
    ); 
    insert templateCross;
    
    options.put('accountId', acc.Id);
    options.put('type', 'Verificación de Línea Decisora');
    
    Test.startTest();
    taSalesSMSInteraction testClass = new taSalesSMSInteraction();
    testClass.invokeMethod(method, input, outMap, options);
    Test.stopTest(); 
    
    System.assertEquals(true, (Boolean) outMap.get('IsValid'));
  } 

  @isTest
  static void invoke_CheckAndSaveDecisiveLine_Invalid(){
      String method = 'CheckAndSaveDecisiveLine';
      String testLine = '1234567890';
  
    Map<String,Object> input = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    
    TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
    TestDataFactory.createExpectedMessage();
    
    insert new SMSSender__c(Name='S-Confirmacion-SMS', Sender__c='TestStress - SMS');
    
    Account acc = TestDataFactory.createAccounts(1,'Business')[0];
    acc.CustomerIntegrationId__c = 5645647;
    update acc;
    Order ord = TestDataFactory.createOrders(1, acc)[0];
    Asset ast = TestDataFactory.createAssets(1, acc, testLine)[0];
    
    String smsRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
    String trkRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Tracking').getRecordTypeId();
    
    CrossObject__c templateCross =  new CrossObject__c(
      PickList1__c = 'Verificación de Línea Decisora',
      RecordTypeId = smsRecordType,
      String1__c = '{{Name}} - {{Phone}} - {{OK}} - {{KO}}'
    ); 
    insert templateCross;
    
    options.put('accountId', acc.Id);
    options.put('phone', 123456789);
    options.put('orderId',ord.Id);
    
    Test.startTest();
    taSalesSMSInteraction testClass = new taSalesSMSInteraction();
    testClass.invokeMethod(method, input, outMap, options);
    Test.stopTest();
    
    List<CrossObject__c> trkCross = [SELECT Id FROM CrossObject__c WHERE RecordTypeId = :trkRecordType];
    //PFTA-10979, ya no se hace insert en acc en el metodo
    //Account resultAcc = [SELECT PhoneValidated__c, Phone FROM Account WHERE Id = :acc.Id];
    
    System.assertEquals(1, trkCross.size());
    //System.assertEquals(false, resultAcc.PhoneValidated__c);
    //System.assertEquals('123456789', resultAcc.Phone);
    //System.assertEquals(resultAcc.Id, (String) outMap.get('RootAcount'));
  }

  @isTest
  static void invoke_CheckAndSaveDecisiveLine_Valid(){
      String method = 'CheckAndSaveDecisiveLine';
      String testLine = '1234567890';
  
    Map<String,Object> input = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    
    TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
    TestDataFactory.createExpectedMessage();
    
    Account acc = TestDataFactory.createAccounts(1,'Business')[0];
    Order ord = TestDataFactory.createOrders(1, acc)[0];
    Asset ast = TestDataFactory.createAssets(1, acc, testLine)[0];
    
    String smsRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
    String trkRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Tracking').getRecordTypeId();
    
    CrossObject__c templateCross =  new CrossObject__c(
      PickList1__c = 'Verificación de Línea Decisora',
      RecordTypeId = smsRecordType,
      String1__c = '{{Name}} - {{Phone}} - {{OK}} - {{KO}}'
    );
    insert templateCross;
    
    options.put('accountId', acc.Id);
    options.put('phone', testLine);
    options.put('orderId',ord.Id);
    
    Test.startTest();
    taSalesSMSInteraction testClass = new taSalesSMSInteraction();
    testClass.invokeMethod(method, input, outMap, options);
    Test.stopTest();
    
    List<CrossObject__c> trkCross = [SELECT Id FROM CrossObject__c WHERE RecordTypeId = :trkRecordType];
    //PFTA-10979, ya no se hace insert en acc en el metodo
    //Account resultAcc = [SELECT PhoneValidated__c, Phone FROM Account WHERE Id = :acc.Id];
    
    System.assertEquals(0, trkCross.size());
    //System.assertEquals(true, resultAcc.PhoneValidated__c);
    //System.assertEquals(testLine, resultAcc.Phone);
    //System.assertEquals(resultAcc.Id, (String) outMap.get('RootAcount'));
  }

  @isTest
  static void invoke_SendSMS_Valid(){
      String method = 'SendSMS';
  
    Map<String,Object> input = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    
    TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
    TestDataFactory.createExpectedMessage();
    
    Account acc = TestDataFactory.createAccounts(1,'Business')[0];
    Order ord = TestDataFactory.createOrders(1, acc)[0];
    
    String smsRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
    String logRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('Log Identity Validation').getRecordTypeId();
    String trkRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Tracking').getRecordTypeId();
    
    DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes(300);
    
    CrossObject__c trkCross = new CrossObject__c(
      String1__c = '1234567890',
      Status__c = 'Confirmado',
      Integer1__c = 3,
      DateTime1__c = fechaLimiteVencimiento,
      DateTime3__c = Date.today(), 
      RecordTypeId = trkRecordType
    );
    insert trkCross;
    
    CrossObject__c templateCross =  new CrossObject__c(
      PickList1__c = 'Verificación de identidad en una orden de venta',
      RecordTypeId = smsRecordType,
      Integer1__c=300, Integer2__c=3
    ); 
    insert templateCross;
    
    options.put('accountId', acc.Id);
    options.put('orderId', ord.Id);
    options.put('cellnumber', '1234567890');
    options.put('text', 'Test Message');
    options.put('type', 'Verificación de identidad en una orden de venta');
    
    Test.startTest();
    taSalesSMSInteraction testClass = new taSalesSMSInteraction();
    testClass.invokeMethod(method, input, outMap, options);
    Test.stopTest();
    
    CrossObject__c resTrkCross = [SELECT Status__c FROM CrossObject__c WHERE Id = :trkCross.Id];
    
    Map<String, Object> resp = (Map<String, Object>) outMap.get('ValidateSMS_Response');
    
    System.assertEquals('Cerrado', resTrkCross.Status__c);
    System.assertEquals(true, (Boolean) resp.get('IsValid'));
  }
  
  @isTest
  static void invoke_SendSMS_NotValid(){
      String method = 'SendSMS';
  
    Map<String,Object> input = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    
    TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
    TestDataFactory.createExpectedMessage();
    
    Account acc = TestDataFactory.createAccounts(1,'Business')[0];
    Order ord = TestDataFactory.createOrders(1, acc)[0];
    
    String smsRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
    String logRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('Log Identity Validation').getRecordTypeId();
    String trkRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Tracking').getRecordTypeId();
    
    DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes(300);
    
    CrossObject__c templateCross =  new CrossObject__c(
      PickList1__c = 'Verificación de identidad en una orden de venta',
      RecordTypeId = smsRecordType,
      Integer1__c=300, Integer2__c=3
    ); 
    insert templateCross;

	SMSSender__c objSMS = new SMSSender__c();
	objSMS.Name = 'S-Confirmacion-SMS';
	objSMS.Sender__c = 'S-Confirmacion-SMS';
	insert objSMS;
    
    options.put('accountId', acc.Id);
    options.put('orderId', ord.Id);
    options.put('cellnumber', '1234567890');
    options.put('text', 'Test Message');
    options.put('type', 'Verificación de identidad en una orden de venta'); 
    
    Test.startTest();
    taSalesSMSInteraction testClass = new taSalesSMSInteraction();
    try {
    testClass.invokeMethod(method, input, outMap, options);
    } catch (exception e) {
        System.assertEquals('Error inesperado al enviar el SMS.',e.getMessage());
    }
    Test.stopTest();
  }

  @isTest
  static void invoke_receiveMessageTestOK(){
      String method = 'ReceiveMessage';
  
    Map<String,Object> input = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    
    TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
    TestDataFactory.createExpectedMessage();
    
    Account acc = TestDataFactory.createAccounts(1,'Business')[0];
    Order ord = TestDataFactory.createOrders(1, acc)[0];
    acc.phone = '1234567890';
    update acc; 
    
    String smsRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
    String logRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('Log Identity Validation').getRecordTypeId();
    String trkRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Tracking').getRecordTypeId();
    
    DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes(300);
    
    insert new CrossObject__c(
      PickList1__c = 'Verificación de identidad en una orden de venta',
      RecordTypeId = smsRecordType,
      Integer1__c=300, Integer2__c=3
    ); 
    
    insert new CrossObject__c(
      PickList1__c = 'Sms',
      Account__c = acc.Id, 
      Order__c = ord.Id,
      Checkbox1__c = false,
      DateTime1__c = fechaLimiteVencimiento,
      RecordTypeId = logRecordType
    );
    
    insert new CrossObject__c(
      Account__c = acc.Id, 
      Order__c = ord.Id,
      String1__c = '1234567890',
      Status__c = 'Pendiente',
      Integer1__c = 3,
      DateTime1__c = fechaLimiteVencimiento,
      RecordTypeId = trkRecordType
    );
    
    options.put('accountId', acc.Id);
    options.put('IdOrder', ord.Id);
    options.put('ResponseTypeSMS', 'OK');
	  options.put('mensaje', 'Prueba Mensaje Test');
    
    Test.startTest();
    taSalesSMSInteraction testClass = new taSalesSMSInteraction();
    testClass.invokeMethod(method, input, outMap, options);
    Test.stopTest();
    
    Order ord1 = [SELECT TrackingStatus__c FROM Order WHERE Id = :ord.Id];
    
    //System.assertEquals('Preparar pedido', ord1.TrackingStatus__c);
  }
  
  @isTest
  static void invoke_receiveMessageTest_NoOK(){
      String method = 'ReceiveMessage';
  
    Map<String,Object> input = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    
    TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
    TestDataFactory.createExpectedMessage();
    
    Account acc = TestDataFactory.createAccounts(1,'Business')[0];
    Order ord = TestDataFactory.createOrders(1, acc)[0];
    acc.phone = '1234567890';
    update acc; 
    
    String smsRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
    String logRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('Log Identity Validation').getRecordTypeId();
    String trkRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Tracking').getRecordTypeId();
    
    DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes(300);
    
    insert new CrossObject__c(
      PickList1__c = 'Verificación de identidad en una orden de venta',
      RecordTypeId = smsRecordType, 
      Integer1__c=300, Integer2__c=3
    ); 
    
    insert new CrossObject__c(
      PickList1__c = 'Sms',
      Account__c = acc.Id, 
      Order__c = ord.Id,
      Checkbox1__c = false,
      DateTime1__c = fechaLimiteVencimiento,
      RecordTypeId = logRecordType
    );
    
    insert new CrossObject__c(
      Account__c = acc.Id, 
      Order__c = ord.Id,
      String1__c = '1234567890',
      Status__c = 'Pendiente',
      Integer1__c = 3,
      DateTime1__c = fechaLimiteVencimiento,
      RecordTypeId = trkRecordType
    );
    
    options.put('accountId', acc.Id);
    options.put('IdOrder', ord.Id);
    options.put('ResponseTypeSMS', 'NOK');
    options.put('mensaje', 'Prueba Mensaje Test');
    Test.startTest();
    taSalesSMSInteraction testClass = new taSalesSMSInteraction();
    testClass.invokeMethod(method, input, outMap, options);
    Test.stopTest();
    
    Order ord1 = [SELECT TrackingStatus__c FROM Order WHERE Id = :ord.Id];
    
    System.assertEquals('Inicial', ord1.TrackingStatus__c);
  }
  
  @isTest
  static void SendSMSTemplateOK(){
    String smsRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
    String logRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('Log Identity Validation').getRecordTypeId();
    String trkRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Tracking').getRecordTypeId();
    
    DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes(300);
    
    String templateType = 'Recarga Exitosa';
    String msj = 'Hola';
    
    insert new CrossObject__c(
      PickList1__c = templateType,
      RecordTypeId = smsRecordType, 
      String1__c = msj
    );

    SMSSender__c objSMS = new SMSSender__c();
    objSMS.Name = 'S-Confirmacion-SMS';
    objSMS.Sender__c = 'S-Confirmacion-SMS';
    insert objSMS;
    
    Map<String, String> variables = new Map<String, String>();
    variables.put('Name', 'Nombre');
    
    Test.startTest();
    taSalesSMSInteraction.sendSMSTemplate('12345678', templateType, variables);
    Test.stopTest();
    
    List<CrossObject__c> retCross = [SELECT Id 
                       FROM CrossObject__c 
                      WHERE Picklist1__c = :templateType
                        AND Status__c = 'Pendiente'
                        AND MarkForDeletion__c = true];
     
     System.assertEquals(1, retCross.size());
  }

  @isTest
    static void ReceiveMessageTestOK() {
    String smsRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
    String LogRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('Log Identity Validation').getRecordTypeId();
    String trkRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Tracking').getRecordTypeId();
    
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
    TestDataFactory.createExpectedMessage(); 
    
    Account acc = TestDataFactory.createAccounts(1,'Business')[0];
    Order ord = TestDataFactory.createOrders(1, acc)[0];
    
    insert new CrossObject__c(
      PickList1__c = 'Verificación de identidad en una orden de venta',
      RecordTypeId = smsRecordType,
      Integer1__c=300, Integer2__c=3
    );
    
    DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes(290);
    
    insert new CrossObject__c(
      Account__c = acc.Id, 
      Order__c = ord.Id,
      String1__c = '1234567890',
      Status__c = 'Pendiente',
      Integer1__c = 3,
      DateTime1__c = fechaLimiteVencimiento,
      RecordTypeId = trkRecordType
    );
    
    insert new CrossObject__c(
      PickList1__c = 'Sms',
      Account__c = acc.Id, 
      Order__c = ord.Id,
      Checkbox1__c = false,
      DateTime1__c = fechaLimiteVencimiento,
      RecordTypeId = LogRecordType
    );
    
    Test.startTest();
    taSalesSMSInteraction.ReceiveMessage('1234567890', 'OK');
    Test.stopTest();
    
    Order ord1 = [SELECT TrackingStatus__c FROM Order WHERE Id = :ord.Id];
    
    System.assertEquals('Preparar pedido', ord1.TrackingStatus__c);
    }
    
    @isTest
    static void ReceiveMessageTestNoOK() {
    String smsRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
    String LogRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('Log Identity Validation').getRecordTypeId();
    String trkRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Tracking').getRecordTypeId();
    
    String orderRecordType = Schema.SObjectType.Order.getRecordTypeInfosByName().get('MobilePhoneOrder').getRecordTypeId();
    
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
    TestDataFactory.createExpectedMessage();
    
    Account acc = TestDataFactory.createAccounts(1,'Business')[0];
    Order ord = TestDataFactory.createOrders(1, acc)[0];
    
    ord.RecordTypeId = orderRecordType;
    update ord;
    
    insert new CrossObject__c(
      PickList1__c = 'Verificación de identidad en una orden de venta',
      RecordTypeId = smsRecordType,
      Integer1__c=300, Integer2__c=3
    );
    
    DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes(290);
    
    insert new CrossObject__c(
      Account__c = acc.Id, 
      Order__c = ord.Id,
      String1__c = '1234567890',
      Status__c = 'Pendiente',
      Integer1__c = 3,
      DateTime1__c = fechaLimiteVencimiento,
      RecordTypeId = trkRecordType
    );
    
    System.debug('order record type: ' + ord.RecordType.Name);
    
    Test.startTest();
    taSalesSMSInteraction.ReceiveMessage('1234567890', 'NOK');
    Test.stopTest();
    
    Order ord1 = [SELECT TrackingStatus__c FROM Order WHERE Id = :ord.Id];
    
    System.assertEquals('Cancelada - Validacion Rechazada', ord1.TrackingStatus__c);
    }
    
    @isTest
    static void ValidateClientResponseTest() {
    
    }
    
    @isTest
    static void SendSMSTest() {
    
    }
    
    @isTest
    static void CheckAndSaveDecisiveLineTest() {
    
    }
    
}