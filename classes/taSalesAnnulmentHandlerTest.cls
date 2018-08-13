@isTest
public class taSalesAnnulmentHandlerTest
{
  public static testmethod void AnnulmentHandlerTest()
  {
    Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
    account.AccountIntegrationId__c = '10000000564';
    update account;
    Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
    vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(
      RecordTypeId = idRecordType,
      Name = 'Barrio Norte',
      vlocity_cmt__OrganizationId__c = Account.Id,
      Status__c = 'Activo',
      Type__c = 'POS',
      Channel__c = 'Físico',
      Channel_Type__c = 'Agentes',
      Channel_Type_2__c = 'Agentes',
      Channel_Type_3__c = 'Agentes',
      Region__c='AMBA');
    insert storeLocation;

        WorkTeam__c workTeamParent = new WorkTeam__c(
      Team_Name__c = 'Test Parent',
      Name = 'Test Parent');
        insert workTeamParent;

    AnnulmentTimeLimit__c objTimeAnnul = new AnnulmentTimeLimit__c();
    objTimeAnnul.Channel__c = 'Físico';
    objTimeAnnul.LocationCode__c = 'C';
    objTimeAnnul.Name = 'CABA_Fisico';
    objTimeAnnul.TimeLimit__c = 30.0;
    insert objTimeAnnul;

    User usernew = new user(ID = UserInfo.getUserID());
        String strIdUser = UserInfo.getUserID();

        String manager = UserInfo.getUserId();
        String parent = workTeamParent.Id;
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test', Name = 'Test');
    Team_Member__c tm = TestDataFactory.setTeamMember('Call Center', UserInfo.getUserId(), null);

    List<Order> ordList = TestDataFactory.createOrders(1, account);
    Order ord1 = ordList[0];
    Order order1 = [SELECT Id FROM Order WHERE Id = :ord1.Id];
    
    List<OrderItem> itemsList = new List<OrderItem>();
    List<OrderItem> itemsList1 = TestDataFactory.createOrderItem(1, order1);
    itemsList1[0].vlocity_cmt__OneTimeTotal__c  = 0;
    itemsList1[0].vlocity_cmt__SerialNumber__c  = '89543410307680582547';
    itemsList.add(itemsList1[0]);

    order1.Name = 'OrderTestVPA1';
    order1.OriginStoreLocation__c = storeLocation.Id;
    order1.DeliveryDate__c = Date.parse('04/04/2018');
    update itemsList;
    update order1;

    AnnulmentAvailableChannels__c annulmentAvailableChannels = new AnnulmentAvailableChannels__c(
      Name = 'Test',
      OriginChannel__c = 'Oficinas Comerciales',
      AnnulmentChannel__c = 'Oficinas Comerciales');
    insert annulmentAvailableChannels;

    List<vlocity_cmt__PaymentAdjustment__c> paymentAdjustmentList = TestDataFactory.createPaymentAdjustments(1, account, order1, null, 1);

    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outputMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    options.put('OrderID', order1.Id);
    options.put('orderId', order1.Id);

    Test.startTest();
      taSalesAnnulmentHandler tsah = new taSalesAnnulmentHandler();
      tsah.invokeMethod('ValidateAnnulmentChannel', inputMap, outputMap, options);
    Test.stopTest();
  }

  @isTest static void ReturnSerialsToStock()
  {
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();

    Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];

    Order order = TestDataFactory.createOrders(1, account)[0];

    OrderItem item = TestDataFactory.createOrderItem(1, order)[0];
    item.vlocity_cmt__SerialNumber__c = '89543410307680582547';
    update item;
    
    options.put('orderId', order.id);

    Test.startTest();
      taSalesAnnulmentHandler tsah = new taSalesAnnulmentHandler();
      tsah.invokeMethod('ReturnSerialsToStock', inputMap, outMap, options);
    Test.stopTest();
  }
  
  @isTest static void ReturnSerialsToStockCEG()
  {
    String mockResponse = '{"listaResultado":[{"mensajeResultado": "OK","codigoResultado": "0","numeroSerie": "99543410307677114097"}],"codigoResultado": "OK"}';
    VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S105', mockResponse);

    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();

    Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
    
    vlocity_cmt__BusinessSite__c bsns = TestDataFactory.createStoreLocation('Test');
    bsns.Channel_Type_3__c = 'Oficinas Comerciales';
    bsns.Channel_Type_2__c = 'Oficinas Comerciales';
    bsns.Channel_Type__c = 'Oficinas Comerciales';
    bsns.Channel__c = 'Físico';
    update bsns;
    
    Order order = TestDataFactory.createOrders(1, account)[0];
    order.Gestion__c = 'Cambio en Garantia';
    //order.Gestion__c = 'Venta';
    order.OriginStoreLocation__c = bsns.id;
    update order;

    OrderItem item = TestDataFactory.createOrderItem(1, order)[0];
    item.vlocity_cmt__SerialNumber__c = '89543410307680582547';
    update item;
    
    options.put('orderId', order.id);
    options.put('annulmentOrderId', order.id);

    Test.startTest();
      taSalesAnnulmentHandler tsah = new taSalesAnnulmentHandler();
      tsah.invokeMethod('ValidateOrderCEG', inputMap, outMap, options);
      tsah.invokeMethod('ValidatePuntoDeVenta', inputMap, outMap, options);
      tsah.invokeMethod('ValidateCanalPresencial', inputMap, outMap, options);
      tsah.invokeMethod('ReturnSerialsToStockCEG', inputMap, outMap, options);
    Test.stopTest();
  }

  @isTest static void PaymentRollback()
  {
    Map<String,Object> inputMap = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    
    Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
    account.AccountIntegrationId__c = '10000000564';

    Order order = TestDataFactory.createOrders(1, account)[0];
    order.DateTime_Sent_S029__c = Datetime.now();

    vlocity_cmt__PaymentAdjustment__c paymentAdjustment = TestDataFactory.createPaymentAdjustments(1, account, order, null, 1)[0];

    List<CardType__c> csList = new List<CardType__c>();
    csList.add(new CardType__c(
      name = 'Tarjeta_Credito',
      CardTypeCode__c = 2.001,
      ResponseCardType__c = 'TAR'
    ));

    csList.add(new CardType__c(
      name = 'Tarjeta_Debito',
      CardTypeCode__c = 4.002,
      ResponseCardType__c = 'DEB'
    ));

    insert csList;

    String mockResponse = '{"cantidadMaxConsulta":10,"referenciaItemPaginado":0,"cantidadItemsConsulta":10,"listaInfoPagos":{"infoPago":[{"codPuntoDeVenta":"1234","importeImpuestoAplicado":"0.0000","saldoBalance":"0.0000","montoValidadoPago":"0.0000","listaDatosAdicionales":{"datosAdicionales":[{"valorParametro":"string","nombreParametro":"string"}]},"infoRecargaBonus":{"listaBalances":{"listaUnidadLibre":[{"fechaVigenciaHastaProdAdq":"string","fechaVigenciaDesdeProdAdq":"string","codMoneda":"string","cantUnidadesLibres":"string","nombreBalance":"string","codBalance":"string","codTipoBalance":"string"}]},"listaUnidadesLibres":{"listaUnidadLibre":[{"fechaVigenciaHastaProdAdq":"string","fechaVigenciaDesdeProdAdq":"string","cantUnidadesLibres":"string","descUnidadMedida":"string","codUnidadDeMedida":"string","descUsoUnidadesLibres":"string","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"string"}]}},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codMoneda":"ARS","nuevoBal":{"saldoBalance":"string"},"saldoBalance":"string","nombreBalance":"string","codBalance":"string","codTipoBalance":"string"}]},"cicloVida":{"ListaStatusCicloVida":[{"estadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","descripcionEstadoSuscripcion":"string"}],"listaStatusCicloVidaAnt":[{"estadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","descripcionEstadoSuscripcion":"string"}]},"periodoTiempo":"Mensual","userReversa":{"codGerencia":"string","codUsuario":"string"},"codGerencia":"string","codUsuario":"u591234","codRespuesta":"0","estadoPago":"IMP","modoAcceso":"3","codCanal":"3","infoBanco":{"cantidadCuotasTarjeta":0,"fechaEmisionCheque":"2018-01-01 00:00:00","nroCheque":"","codSeguridadTarjeta":"234","fechaVencimientoTarjeta":"202005","nombreEntidadFinanciera":"BANCO SANTANDER RIO S.A.","codEntidadTC":"404","ultimosDigitosTarjeta":"4516258445785478","codMedioPago":"TAR","codSucursalEntidad":"040","codEntidadFinanciera":"072"},"infoVoucher":{"numeroSerie":"9876543"},"codMotivoRecarga":"1","codMedioPago":"TAR","listaDetallesPagos":{"detallePago":[{"montoDescuentoPrecioProducto":"0.0000","listaImpuestos":{"impuestos":[{"importeImpuestoAplicado":"string","codImpuesto":"string"}]},"importeComprobante":"150.0000","codCargo":"C_VOICE_CHARGECODE","tipoItemComprobante":"","codComprobante":"0001","numeroComprobante":"1235433","montoCuotaConvenioCta":"0.0000","tipoPago":"PFT"}]},"tasaDeCambio":"0.0000","monedaExtranjera":{"codMoneda":"ARS","importePago":"0.0000"},"codMoneda":"ARS","importePago":"150.0000","fechaAplicacionPago":"2018-01-05 00:00:00","tipoTransaccionPago":"OnLine","txId":"1234567890","identificadorRecurso":"1140587458","codSuscripcion":"13800010002","idCliente":"23800010688","idCuenta":"2380001068810001"},{"codPuntoDeVenta":"1234","importeImpuestoAplicado":"0.0000","saldoBalance":"0.0000","montoValidadoPago":"0.0000","listaDatosAdicionales":{"datosAdicionales":[{"valorParametro":"string","nombreParametro":"string"}]},"infoRecargaBonus":{"listaBalances":{"listaUnidadLibre":[{"fechaVigenciaHastaProdAdq":"string","fechaVigenciaDesdeProdAdq":"string","codMoneda":"string","cantUnidadesLibres":"string","nombreBalance":"string","codBalance":"string","codTipoBalance":"string"}]},"listaUnidadesLibres":{"listaUnidadLibre":[{"fechaVigenciaHastaProdAdq":"string","fechaVigenciaDesdeProdAdq":"string","cantUnidadesLibres":"string","descUnidadMedida":"string","codUnidadDeMedida":"string","descUsoUnidadesLibres":"string","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"string"}]}},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codMoneda":"ARS","nuevoBal":{"saldoBalance":"string"},"saldoBalance":"string","nombreBalance":"string","codBalance":"string","codTipoBalance":"string"}]},"cicloVida":{"ListaStatusCicloVida":[{"estadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","descripcionEstadoSuscripcion":"string"}],"listaStatusCicloVidaAnt":[{"estadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","descripcionEstadoSuscripcion":"string"}]},"periodoTiempo":"Mensual","userReversa":{"codGerencia":"string","codUsuario":"string"},"codGerencia":"string","codUsuario":"u591234","codRespuesta":"0","estadoPago":"IMP","modoAcceso":"3","codCanal":"3","infoBanco":{"cantidadCuotasTarjeta":0,"fechaEmisionCheque":"2018-01-01 00:00:00","nroCheque":"","codSeguridadTarjeta":"235","fechaVencimientoTarjeta":"202005","nombreEntidadFinanciera":"BANCO PIANO S.A.","codEntidadTC":"404","ultimosDigitosTarjeta":"4516258445785478","codMedioPago":"DEB","codSucursalEntidad":"040","codEntidadFinanciera":"301"},"infoVoucher":{"numeroSerie":"9876543"},"codMotivoRecarga":"1","codMedioPago":"DEB","listaDetallesPagos":{"detallePago":[{"montoDescuentoPrecioProducto":"0.0000","listaImpuestos":{"impuestos":[{"importeImpuestoAplicado":"string","codImpuesto":"string"}]},"importeComprobante":"150.0000","codCargo":"C_VOICE_CHARGECODE","tipoItemComprobante":"","codComprobante":"0001","numeroComprobante":"1235433","montoCuotaConvenioCta":"0.0000","tipoPago":"PFT"}]},"tasaDeCambio":"0.0000","monedaExtranjera":{"codMoneda":"ARS","importePago":"0.0000"},"codMoneda":"ARS","importePago":"150.0000","fechaAplicacionPago":"2018-01-05 00:00:00","tipoTransaccionPago":"OnLine","txId":"2234567890","identificadorRecurso":"1140587458","codSuscripcion":"13800010002","idCliente":"23800010688","idCuenta":"2380001068810001"},{"codPuntoDeVenta":"string","importeImpuestoAplicado":"string","saldoBalance":"string","montoValidadoPago":"string","listaDatosAdicionales":{"datosAdicionales":[{"valorParametro":"string","nombreParametro":"string"}]},"infoRecargaBonus":{"listaBalances":{"listaUnidadLibre":[{"fechaVigenciaHastaProdAdq":"string","fechaVigenciaDesdeProdAdq":"string","codMoneda":"string","cantUnidadesLibres":"string","nombreBalance":"string","codBalance":"string","codTipoBalance":"string"}]},"listaUnidadesLibres":{"listaUnidadLibre":[{"fechaVigenciaHastaProdAdq":"string","fechaVigenciaDesdeProdAdq":"string","cantUnidadesLibres":"string","descUnidadMedida":"string","codUnidadDeMedida":"string","descUsoUnidadesLibres":"string","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"string"}]}},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codMoneda":"ARS","nuevoBal":{"saldoBalance":"string"},"saldoBalance":"string","nombreBalance":"string","codBalance":"string","codTipoBalance":"string"}]},"cicloVida":{"ListaStatusCicloVida":[{"estadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","descripcionEstadoSuscripcion":"string"}],"listaStatusCicloVidaAnt":[{"estadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","descripcionEstadoSuscripcion":"string"}]},"periodoTiempo":"Mensual","userReversa":{"codGerencia":"string","codUsuario":"string"},"codGerencia":"string","codUsuario":"u591234","codRespuesta":"0","estadoPago":"IMP","modoAcceso":"3","codCanal":"3","infoBanco":{"cantidadCuotasTarjeta":0,"fechaEmisionCheque":"","nroCheque":"","codSeguridadTarjeta":"254","fechaVencimientoTarjeta":"202012","nombreEntidadFinanciera":"BBVA BANCO FRANCES S.A.","codEntidadTC":"377","ultimosDigitosTarjeta":"5462895712045695","codMedioPago":"TAR","codSucursalEntidad":"0001","codEntidadFinanciera":"017"},"infoVoucher":{"numeroSerie":"12345678"},"codMotivoRecarga":"1","codMedioPago":"TAR","listaDetallesPagos":{"detallePago":[{"montoDescuentoPrecioProducto":"0.0000","listaImpuestos":{"impuestos":[{"importeImpuestoAplicado":"string","codImpuesto":"string"}]},"importeComprobante":"399.0000","codCargo":"C_VOICE_CHARGECODE","tipoItemComprobante":"","codComprobante":"0003","numeroComprobante":"9876543","montoCuotaConvenioCta":"0.0000","tipoPago":"PFV"}]},"tasaDeCambio":"0.0000","monedaExtranjera":{"codMoneda":"ARS","importePago":"0.0000"},"codMoneda":"ARS","importePago":"339.0000","fechaAplicacionPago":"2018-01-20 00:00:00","tipoTransaccionPago":"OnLine","txId":"1234567811","identificadorRecurso":"1140587459","codSuscripcion":"13800010005","idCliente":"23800010688","idCuenta":"2380001068810001"},{"codPuntoDeVenta":"1234","importeImpuestoAplicado":"0.0000","saldoBalance":"0.0000","montoValidadoPago":"0.0000","listaDatosAdicionales":{"datosAdicionales":[{"valorParametro":"string","nombreParametro":"string"}]},"infoRecargaBonus":{"listaBalances":{"listaUnidadLibre":[{"fechaVigenciaHastaProdAdq":"string","fechaVigenciaDesdeProdAdq":"string","codMoneda":"string","cantUnidadesLibres":"string","nombreBalance":"string","codBalance":"string","codTipoBalance":"string"}]},"listaUnidadesLibres":{"listaUnidadLibre":[{"fechaVigenciaHastaProdAdq":"string","fechaVigenciaDesdeProdAdq":"string","cantUnidadesLibres":"string","descUnidadMedida":"string","codUnidadDeMedida":"string","descUsoUnidadesLibres":"string","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"string"}]}},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codMoneda":"ARS","nuevoBal":{"saldoBalance":"string"},"saldoBalance":"string","nombreBalance":"string","codBalance":"string","codTipoBalance":"string"}]},"cicloVida":{"ListaStatusCicloVida":[{"estadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","descripcionEstadoSuscripcion":"string"}],"listaStatusCicloVidaAnt":[{"estadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","descripcionEstadoSuscripcion":"string"}]},"periodoTiempo":"Mensual","userReversa":{"codGerencia":"string","codUsuario":""},"codGerencia":"string","codUsuario":"u591234","codRespuesta":"0","estadoPago":"PAG","modoAcceso":"3","codCanal":"3","infoBanco":{"cantidadCuotasTarjeta":0,"fechaEmisionCheque":"","nroCheque":"","codSeguridadTarjeta":"123","fechaVencimientoTarjeta":"202105","nombreEntidadFinanciera":"CITIBANK N.A.","codEntidadTC":"403","ultimosDigitosTarjeta":"1234123412341234","codMedioPago":"DEB","codSucursalEntidad":"","codEntidadFinanciera":"016"},"infoVoucher":{"numeroSerie":"12345678"},"codMotivoRecarga":"1","codMedioPago":"DEB","listaDetallesPagos":{"detallePago":[{"montoDescuentoPrecioProducto":"0.0000","listaImpuestos":{"impuestos":[{"importeImpuestoAplicado":"string","codImpuesto":"string"}]},"importeComprobante":"436.0000","codCargo":"C_VOICE_CHARGECODE","tipoItemComprobante":"","codComprobante":"0003","numeroComprobante":"9876543","montoCuotaConvenioCta":"0.0000","tipoPago":"PFV"}]},"tasaDeCambio":"0.0000","monedaExtranjera":{"codMoneda":"ARS","importePago":"0.0000"},"codMoneda":"ARS","importePago":"436.0000","fechaAplicacionPago":"2018-01-20 00:00:00","tipoTransaccionPago":"OnLine","txId":"1234567812","identificadorRecurso":"1140587459","codSuscripcion":"13800010005","idCliente":"23800010688","idCuenta":"2380001068810001"}]}}';
    
    VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S059', mockResponse);

    List<Object> jsonDataCards = (List<Object>)JSON.deserializeUntyped('[{"SecurityCode":"123","Ammount":8000,"CardNumber":"AMERICAN EXPRESS XXXX-XXXX-XXXX-","PaymentAdjustmentId":"'+paymentAdjustment.Id+'","$$hashKey":"object:296","AmmountFormatted":"ARS 8,000.00"}]');
    options.put('OrderId', order.Id);
    options.put('CardsPaymentsCharged', jsonDataCards);
    
    Test.startTest();
    taSalesAnnulmentHandler tsah = new taSalesAnnulmentHandler();
    tsah.invokeMethod('PaymentRollback', inputMap, outMap, options);
    Test.stopTest();
  }

  @isTest static void HotInvoiceRollback()
  {
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();

    Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];

    Order order = TestDataFactory.createOrders(1, account)[0];

    options.put('OrderId', order.Id);

    Test.startTest();
      taSalesAnnulmentHandler tsah = new taSalesAnnulmentHandler();
      tsah.invokeMethod('HotInvoiceRollback', inputMap, outMap, options);
    Test.stopTest();
  }

  @isTest static void CorrectionCBS()
  {
    Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
    account.AccountIntegrationId__c = '10000000564';
    update account;
    Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
    vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(
      RecordTypeId = idRecordType,
      Name = 'Barrio Norte',
      vlocity_cmt__OrganizationId__c = Account.Id,
      Status__c = 'Activo',
      Type__c = 'POS',
      Channel__c = 'Físico',
      Channel_Type__c = 'Agentes',
      Channel_Type_2__c = 'Agentes',
      Channel_Type_3__c = 'Agentes',
      Region__c = 'AMBA');
    insert storeLocation;

    WorkTeam__c workTeamParent = new WorkTeam__c(
      Team_Name__c = 'Test Parent',
      Name = 'Test Parent');
    insert workTeamParent;

    AnnulmentTimeLimit__c objTimeAnnul = new AnnulmentTimeLimit__c();
    objTimeAnnul.Channel__c = 'Físico';
    objTimeAnnul.LocationCode__c = 'C';
    objTimeAnnul.Name = 'CABA_Fisico';
    objTimeAnnul.TimeLimit__c = 30.0;
    insert objTimeAnnul;

    User usernew = new user(ID = UserInfo.getUserID());
    String strIdUser = UserInfo.getUserID();

    String manager = UserInfo.getUserId();
    String parent = workTeamParent.Id;
    WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test', Name = 'Test');
    Team_Member__c tm = TestDataFactory.setTeamMember('Call Center', UserInfo.getUserId(), null);

    Order order = TestDataFactory.createOrders(1, account)[0];
    
    order.ChargesInvoicePayload__c = '{"solicitudCorreccionInformacion":{"numeroComprobante":"11511111","listaDetalle":{"elementoDetalle":[{"codCargo":"C_OT_MB_EQUIPMENT_SIM","idItemCorreccion":{"nroItemComprobante":1},"importeFacturaOriginal":{"importeItemComprobanteNeto":"20.0000","importeItemComprobanteBruto":"24.2000"},"montoNetoAjuste":"0.0000","montoAjuste":"0.0000","importeFacturaFinal":{"importeItemComprobanteSinImp":"20.0000","importeItemComprobante":"24.2000"},"codMoneda":"ARS","descripcionServicio":"Plan Nacional Prepago"}]},"cantidadItemsConsulta":1,"referenciaItemPaginado":1,"cantidadMaxConsulta":1}}';
    
    List<OrderItem> itemsList = new List<OrderItem>();
    List<OrderItem> itemsList1 = TestDataFactory.createOrderItem(1, order);
    itemsList1[0].vlocity_cmt__OneTimeTotal__c  = 0;
    itemsList1[0].vlocity_cmt__SerialNumber__c  = '89543410307680582547';
    itemsList.add(itemsList1[0]);
    
    order.Name = 'OrderTestVPA1';
    order.OriginStoreLocation__c = storeLocation.Id;
    order.DeliveryDate__c = Date.parse('04/04/2018');
    update itemsList;
    update order;

    AnnulmentAvailableChannels__c annulmentAvailableChannels = new AnnulmentAvailableChannels__c(
      Name = 'Test',
      OriginChannel__c = 'Oficinas Comerciales',
      AnnulmentChannel__c = 'Oficinas Comerciales');
    insert annulmentAvailableChannels;

    List<vlocity_cmt__PaymentAdjustment__c> paymentAdjustmentList = TestDataFactory.createPaymentAdjustments(1, account, order, null, 1);

    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outputMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    options.put('OrderId', order.Id);

    Test.startTest();
      taSalesAnnulmentHandler tsah = new taSalesAnnulmentHandler();
      tsah.invokeMethod('CorrectionCBS', inputMap, outputMap, options);
    Test.stopTest();
  }

  @isTest static void GetChargesByInvoiceCBS()
  {
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();

    Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];

    Order order = TestDataFactory.createOrders(1, account)[0];

    options.put('OrderId', order.Id);

    Test.startTest();
      taSalesAnnulmentHandler tsah = new taSalesAnnulmentHandler();
      tsah.invokeMethod('GetChargesByInvoiceCBS', inputMap, outMap, options);
    Test.stopTest();
  }

  @isTest static void ValidateSuspensions()
  {
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();

    Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];

    Order order = TestDataFactory.createOrders(1, account)[0];

    OrderItem orderItem = TestDataFactory.createOrderItem(1, order)[0];
    orderItem.vlocity_cmt__OneTimeTotal__c  = 0;
    orderItem.vlocity_cmt__SerialNumber__c  = '89543410307680582547';

    options.put('orderId', order.Id);

    Test.startTest();
      taSalesAnnulmentHandler tsah = new taSalesAnnulmentHandler();
      tsah.invokeMethod('ValidateSuspensions', inputMap, outMap, options);
    Test.stopTest();
  }

  @isTest static void ValidateAnnulmentTerm()
  {
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();

    Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
    Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
    vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(
      RecordTypeId = idRecordType,
      Name = 'Test',
      vlocity_cmt__OrganizationId__c = Account.Id,
      Status__c = 'Activo',
      Type__c = 'POS',
      Channel__c = 'Físico',
      Channel_Type__c = 'Agentes',
      Channel_Type_2__c = 'Agentes',
      Channel_Type_3__c = 'Agentes',
      vlocity_cmt__State__c ='C');
    insert storeLocation;

    AnnulmentTimeLimit__c annulmentTimeLimit = new AnnulmentTimeLimit__c(
      Name = 'Test',
      Channel__c = 'Físico',
      LocationCode__c = 'C',
      TimeLimit__c = 30);
    insert annulmentTimeLimit;

    Order order = TestDataFactory.createOrders(1, account)[0];
    order.OriginStoreLocation__c = storeLocation.Id;
    order.DeliveryDate__c = System.today();
    update order;

    options.put('orderId', order.Id);
    options.put('OrderId', order.Id);

    Test.startTest();
      taSalesAnnulmentHandler tsah = new taSalesAnnulmentHandler();
      tsah.invokeMethod('ValidateAnnulmentTerm', inputMap, outMap, options);
      
      tsah.invokeMethod('AnnulmentTermError', inputMap, outMap, options);
      tsah.invokeMethod('AnnulmentChannelError', inputMap, outMap, options);
      tsah.invokeMethod('ValidateDeliveredOM', inputMap, outMap, options);
      tsah.invokeMethod('AnnulmentSuspensionsError', inputMap, outMap, options);
      tsah.invokeMethod('CreateCancelCase', inputMap, outMap, options);
      
    Test.stopTest();
  }
 

  @isTest static void CloseAnnulmentOrder(){
    Map<String,Object> inputMap = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    
    Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
    account.AccountIntegrationId__c = '10000000564';

    List <Order> order = TestDataFactory.createOrders(2, account);
    options.put('orderId', order[0].Id);
    options.put('oldOrderId', order[1].Id);
    options.put('trackingStatus', 'Anulado');
    options.put('orderApprovalStatus', null);
    options.put('trackingStatusAnnulment', 'Exitoso');
    Test.startTest();
    taSalesAnnulmentHandler tsah = new taSalesAnnulmentHandler();
    tsah.invokeMethod('CloseAnnulmentOrder', inputMap, outMap, options);
    Test.stopTest();
  }
}