global with sharing class taSalesSimulationInvoiceHandler implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('Call_S202_Create_Customer')){
                Call_S202_Create_Customer(inputMap, outMap, options);
            }
            if (methodName.equals('Call_S015_Create_Billing_Account')){
                Call_S015_Create_Billing_Account(inputMap, outMap, options);
            }
            if (methodName.equals('Call_S013_Simulate_Calculate_Taxes')){
                Call_S013_Simulate_Calculate_Taxes(inputMap, outMap, options);
            }
            if (methodName.equals('GetOrderItemsBillable')){
                GetOrderItemsBillable(inputMap, outMap, options);
            }
            if(methodName.equals('GetPriceAdjustmentsGroupByOrderItem')){
                GetPriceAdjustmentsGroupByOrderItem(inputMap,outMap, options);
            }
            
            result = false;  
            //System.debug('outMap:' + outMap);
        } 
        catch(Exception e)
        {
            System.debug('taSalesSimulationInvoiceHandler:invokeMethod -> exception: '+e);
            throw e; 
            //result = false;
        }
        return result;
    }

    // global static void S013_Request_AppendInterest(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
    //     // System.debug('S013_Request_AppendInterest');
    //     Map<String, Object> request = (Map<String, Object>) options.get('S013_Request');
    //     Decimal interest = (Decimal)options.get('Interest');

    //     // "cantidadUnidades": 1,
    //     // "precioUnitario": interest,
    //     // "codCargo": "C_Interest__21"
    //     // System.debug('2');

    //     Map<String, Object> nodeInterest = new Map<String, Object>();
    //     nodeInterest.put('cantidadUnidades', 1);
    //     nodeInterest.put('precioUnitario', interest);
    //     // nodeInterest.put('codCargo', 'C_Interest__21');

    //     // System.debug('3');
    //     Map<String, Object> infoPetCalculoImpuestos = (Map<String, Object>)request.get('infoPetCalculoImpuestos');
    //     if(infoPetCalculoImpuestos == null){
    //         infoPetCalculoImpuestos = new Map<String, Object>();
    //         request.put('infoPetCalculoImpuestos', infoPetCalculoImpuestos);
    //     }
    //     // System.debug('4');
    //     List<Object> listaCantidadCargos = (List<Object>)infoPetCalculoImpuestos.get('listaCantidadCargos');
    //     if(listaCantidadCargos == null){
    //         listaCantidadCargos = new List<Object>();
    //         infoPetCalculoImpuestos.put('listaCantidadCargos', listaCantidadCargos);

    //         Map<String, Object> infoCargo = new Map<String, Object>();
    //         infoCargo.put('infoCargo', nodeInterest);
    //         listaCantidadCargos.add(infoCargo);
    //     } else {
    //         listaCantidadCargos.add(nodeInterest);
    //     }
        

    //     // listaCantidadCargos.put('infoCargo')
    //     // Map<String, Object> infoCargo = (Map<String, Object>)listaCantidadCargos.put('infoCargo');
    //     // // System.debug('5.5');
    //     // if(infoCargo == null){
    //     //     infoCargo = new Map<String, Object>();
    //     //     listaCantidadCargos.put('infoCargo', infoCargo);
    //     // }
    //     // infoCargo.add(nodeInterest);

    //     // System.debug('Request: ' + request);
    //     // System.debug('6');

    //     for (String fieldName : request.keySet()){
    //         // System.debug('field name is ' + fieldName);
    //         outMap.put(fieldName, request.get(fieldName));
    //     }
    // }

    global static void Call_S202_Create_Customer(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        System.debug('Call_S202_Create_Customer');
        String accountId = String.valueOf(options.get('AccountId'));
        System.debug('2');
        Map<String, Object> input = Generate_RequestS202(accountId);
        System.debug('request 202: ' + JSON.serialize(input));
        // Map<String, Object> input = new Map<String, Object>();
        // System.debug('request s094: ' + JSON.serialize(input));
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S202', input, output, options2);
        
        System.debug('response s202: ' + JSON.serialize(output));
        Map<String, Object> response = (Map<String, Object>)output.get('IPResult');
        
        if(response != null && response.get('codigo') == null) // si no da error, se guarda la marca de importado en huawei 
        {
            Account account = new Account();
            account.Id = accountId;
            account.HuaweiNotice_S202__c = true;
            update account;
        }
        
        outMap.put('IPResult', response);
    }

    private static Map<String, Object> Generate_RequestS202(String accountId) {
        System.debug('Generate_RequestS202');

        Account account = [
            SELECT 
                Name, 
                CustomerIntegrationId__c,
                vlocity_cmt__BillingEmailAddress__c,
                Phone,
                vlocity_cmt__PrimaryContactId__r.FirstName,
                vlocity_cmt__PrimaryContactId__r.LastName,
                vlocity_cmt__PrimaryContactId__r.Email,
                vlocity_cmt__PrimaryContactId__r.Phone,
                vlocity_cmt__PrimaryContactId__r.MobilePhone,
                vlocity_cmt__PrimaryContactId__r.OtherPhone,
                vlocity_cmt__PrimaryContactId__r.Birthdate,
                vlocity_cmt__PrimaryContactId__r.Gender__c,
                vlocity_cmt__PrimaryContactId__r.Salutation,
                vlocity_cmt__PrimaryContactId__r.DocumentType__c,
                vlocity_cmt__PrimaryContactId__r.DocumentNumber__c,
                WebSite,
                RecordType.Name
            FROM Account
            WHERE Id = :accountId
        ];
        // System.debug('1');
        Map<String, Object> request = new Map<String, Object>();
        Map<String, Object> body = new Map<String, Object>();
        Map<String, Object> cliente = new Map<String, Object>();
        Map<String, Object> infoCliente = new Map<String, Object>();
        infoCliente.put('idCliente', account.CustomerIntegrationId__c);
        infoCliente.put('codCliente', account.CustomerIntegrationId__c);

        String tipoCliente = '1';
        if(account.RecordType.Name == 'Business'){
            tipoCliente = '2';
        }

        infoCliente.put('tipoCliente', tipoCliente);

        Map<String, Object> infoBasicaCliente = new Map<String, Object>();
        List<Map<String, Object>> listaDatosAdicionales = new List<Map<String, Object>>();
        Map<String, Object> datoAdicional = new Map<String, Object>();
        // System.debug('2');
        datoAdicional.put('valorParametro', 'CF'); // COMPLETAR
        datoAdicional.put('nombreParametro', 'C_Cust_IVACategory_code'); // COMPLETAR
        listaDatosAdicionales.add(datoAdicional);
        infoBasicaCliente.put('listaDatosAdicionales', listaDatosAdicionales); // COMPLETAR
        
        // System.debug('3');
        infoCliente.put('infoBasicaCliente', infoBasicaCliente);
        // System.debug('4');
        if(tipoCliente == '2'){
            // si es empresa
            Map<String, Object> infoEmpresa = new Map<String, Object>();
            infoEmpresa.put('web', account.WebSite);
            infoEmpresa.put('direccionEmail', account.vlocity_cmt__BillingEmailAddress__c);
            infoEmpresa.put('numeroTelefono', account.Phone);
            infoEmpresa.put('nombreFantasia', account.Name);
            infoEmpresa.put('razonSocial', account.Name);
            // System.debug('5');
            cliente.put('infoEmpresa', infoEmpresa);
        } else {
            // si es particular 
            Map<String, Object> infoIndividuo = new Map<String, Object>();
            infoIndividuo.put('direccionEmail', account.vlocity_cmt__PrimaryContactId__r.Email);
            infoIndividuo.put('numeroTelefonoAlternativo', account.vlocity_cmt__PrimaryContactId__r.OtherPhone);
            System.debug('6');
            Map<String, Object> numeroContacto = new Map<String, Object>();
            numeroContacto.put('numeroTelefono', account.vlocity_cmt__PrimaryContactId__r.MobilePhone);
            infoIndividuo.put('numeroContacto', numeroContacto);
            System.debug('61');
            infoIndividuo.put('numeroTelefono', account.vlocity_cmt__PrimaryContactId__r.Phone);
            // infoIndividuo.put('fechaNacimiento', account.vlocity_cmt__PrimaryContactId__r.Birthdate + ''); //  se concatena el espacio para que renderize la hora (00:00:00) como lo necesita huawei
            infoIndividuo.put('fechaNacimiento', IntegrationUtils.ParseDateTime(account.vlocity_cmt__PrimaryContactId__r.Birthdate));
            infoIndividuo.put('genero', IntegrationUtils.ParseGender(account.vlocity_cmt__PrimaryContactId__r.Gender__c));
            System.debug('62');
            infoIndividuo.put('apellido', account.vlocity_cmt__PrimaryContactId__r.LastName);
            infoIndividuo.put('nombre', account.vlocity_cmt__PrimaryContactId__r.FirstName);
            System.debug('644');
            infoIndividuo.put('tituloCortesia', IntegrationUtils.ParseSalutation(account.vlocity_cmt__PrimaryContactId__r.Salutation));
            System.debug('63');
            infoIndividuo.put('numeroDocumento', account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c);
            infoIndividuo.put('tipoDocumento', IntegrationUtils.ParseDocumentType(account.vlocity_cmt__PrimaryContactId__r.DocumentType__c));
            System.debug('64');
            cliente.put('infoIndividuo', infoIndividuo);
        }
        System.debug('7');
        cliente.put('infoCliente', infoCliente);
        body.put('cliente', cliente);
        body.put('codCliente', account.CustomerIntegrationId__c); // COMPLETAR

        System.debug('8');
        request.put('body', body);

        Map<String, Object> params = new Map<String, Object>();
        params.put('idCliente', account.CustomerIntegrationId__c);
        request.put('params', params);

        System.debug('8');
        return request;
    }

    global static void Call_S015_Create_Billing_Account(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        System.debug('Call_S015_Create_Billing_Account');
        String accountId = (String)(options.get('AccountId'));
        String orderId = (String)(options.get('OrderId'));
        System.debug('2');
        Map<String, Object> input = Generate_RequestS015(accountId, orderId);
        System.debug('request 015: ' + JSON.serialize(input));
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S015', input, output, options2);
        
        System.debug('response s015: ' + JSON.serialize(output));
        Map<String, Object> response = (Map<String, Object>)output.get('IPResult');

        if(response != null && response.get('codigo') == null) // si no da error, se guarda la marca de importado en huawei 
        {
            Account account = new Account();
            account.Id = accountId;
            account.HuaweiNotice_S015__c = true;
            update account;
        }
        
        outMap.put('IPResult', response);
    }

    private static Map<String, Object> Generate_RequestS015(String accountId, String orderId) {
        System.debug('Generate_RequestS015');
        Account account = [
            SELECT 
                CustomerIntegrationId__c,
                AccountIntegrationId__c,
                vlocity_cmt__BillDeliveryMethod__c,
                vlocity_cmt__BillingEmailAddress__c,
                vlocity_cmt__PrimaryContactId__r.Salutation,
                vlocity_cmt__PrimaryContactId__r.FirstName,
                vlocity_cmt__PrimaryContactId__r.LastName,
                vlocity_cmt__PrimaryContactId__r.Phone,
                vlocity_cmt__PrimaryContactId__r.MobilePhone,
                vlocity_cmt__PrimaryContactId__r.OtherPhone,
                vlocity_cmt__PrimaryContactId__r.Email
            FROM Account
            WHERE Id = :accountId
        ];

        String billingCycle = [
            SELECT 
                Billing_Cycles__c
            FROM Order
            WHERE Id = :orderId
        ].Billing_Cycles__c;
        if(billingCycle == null){
            billingCycle = '7';
        }
        // System.debug('billingCycle ' + billingCycle);
        billingCycle = billingCycle.leftPad(2, '0');

        System.debug('1');
        Map<String, Object> request = new Map<String, Object>();
        Map<String, Object> body = new Map<String, Object>();

        Map<String, Object> cuenta = new Map<String, Object>();
        cuenta.put('idCuenta', account.AccountIntegrationId__c);
        Map<String, Object> infoCuenta = new Map<String, Object>();
        infoCuenta.put('codCuenta', account.AccountIntegrationId__c);
        infoCuenta.put('idCliente', account.CustomerIntegrationId__c);
        infoCuenta.put('tipoCicloFacturacion', billingCycle);
        
        // Este parametro indica que la cuenta es del tipo post-pago. 
        // Desde el CRM siempre se crean cuentas post-pago aunque se este dando de alta una linea prepago.
        infoCuenta.put('condicionPago', 'POS');

        Map<String, Object> infoBasicaCuenta = new Map<String, Object>();

        String paperBill = 'Y';
        String email = account.vlocity_cmt__PrimaryContactId__r.Email;
        if(account.vlocity_cmt__BillDeliveryMethod__c == 'eMail'){
            paperBill = 'N';
            email = account.vlocity_cmt__BillingEmailAddress__c;
        }

        Map<String, Object> datosDeContacto = new Map<String, Object>();
        datosDeContacto.put('tituloCortesia', IntegrationUtils.ParseSalutation(account.vlocity_cmt__PrimaryContactId__r.Salutation));
        datosDeContacto.put('nombre', account.vlocity_cmt__PrimaryContactId__r.FirstName);
        datosDeContacto.put('apellido', account.vlocity_cmt__PrimaryContactId__r.LastName);
        datosDeContacto.put('numeroTelefono', account.vlocity_cmt__PrimaryContactId__r.Phone);
        datosDeContacto.put('numeroContacto', account.vlocity_cmt__PrimaryContactId__r.MobilePhone);
        datosDeContacto.put('numeroTelefonoAlternativo', account.vlocity_cmt__PrimaryContactId__r.OtherPhone);
        datosDeContacto.put('direccionEmail', email);
        infoBasicaCuenta.put('datosDeContacto', datosDeContacto);
        
        List<Map<String, Object>> datosAdicionales = new List<Map<String, Object>>();
        Map<String, Object> datoAdicional = new Map<String, Object>();
        
        datoAdicional.put('nombreParametro', 'C_INV4PRINTPAPERBILL_TP');
        datoAdicional.put('valorParametro', paperBill);
        datosAdicionales.add(datoAdicional);
        infoBasicaCuenta.put('DatosAdicionales', datosAdicionales);

        infoCuenta.put('infoBasicaCuenta', infoBasicaCuenta);
        cuenta.put('infoCuenta', infoCuenta);
        body.put('cuenta', cuenta);

        System.debug('7');
        request.put('body', body);

        Map<String, Object> params = new Map<String, Object>();
        params.put('idCliente', account.CustomerIntegrationId__c);
        request.put('params', params);

        System.debug('8');
        return request;
    }

    global static void Call_S013_Simulate_Calculate_Taxes(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        System.debug('Call_S013_Simulate_Calculate_Taxes');
        String orderId = (String)(options.get('OrderId'));
        
        List<OrderItem> orderItems = taOrderController.GetOrderItemsBillable(orderId);
        if(orderItems.size() <= 0){
            throw new FuncException('No hay nada facturable.');
        }

        Map<String, Object> input = Generate_RequestS013(orderId);
        System.debug('request s013: ' + JSON.serialize(input));
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S013', input, output, options2);
        System.debug('response s013: ' + JSON.serialize(output));
        Map<String, Object> response = (Map<String, Object>)output.get('IPResult');

        Map<String, Object> calculoImpuestosRespuesta = (Map<String, Object>)response.get('calculoImpuestosRespuesta');
        List<Object> infoResCalculoImpuestos = (List<Object>)calculoImpuestosRespuesta.get('infoResCalculoImpuestos');
        
        if(response == null || calculoImpuestosRespuesta == null){
            throw new FuncException('Respuesta incorrecta en el servicio S013');
        }

        Order order = new Order(Id = orderId);
        order.BillSimulationDate__c = System.now();
        order.BillSimulationPayload__c = JSON.serialize(response);
        update order;
        
        
        Integer i = 1;
        for (OrderItem orderItem : orderItems){
            orderItem.Huawei_Invoice_Item_Sequence__c = String.valueOf(i);
            i++;
        }
        update orderItems;

        List<vlocity_cmt__PaymentAdjustment__c> payments = taOrderController.GetPaymentAdjustmentsWithCFT(orderId);
        for (vlocity_cmt__PaymentAdjustment__c payment : payments){
            payment.Huawei_Invoice_Item_Sequence__c = String.valueOf(i);
            i++;
        }
        update payments;

        Map<String, List<vlocity_cmt__OrderPriceAdjustment__c>> hashDescuentos = taOrderController.GetPriceAdjustmentsGroupByOrderItem(orderId);

        // agrego descripciones de items y de descuentos a la respuesta para mostrar en la simulacion
        i = 0;
        if(infoResCalculoImpuestos != null){
            for(OrderItem orderItem : orderItems){
                Map<String, Object> auxinfoResCalculoImpuesto = (Map<String, Object>)infoResCalculoImpuestos.get(i);
                Map<String, Object> impuestoxItemInfo = (Map<String, Object>)auxinfoResCalculoImpuesto.get('impuestoxItemInfo');
                impuestoxItemInfo.put('descripcion', orderItem.vlocity_cmt__Product2Id__r.Name);
                
                if(hashDescuentos != null && hashDescuentos.size() > 0){
                    List<vlocity_cmt__OrderPriceAdjustment__c> descuentos = hashDescuentos.get(orderItem.Id);
                    if(descuentos != null){
                        List<Object> listaDescuentosImpuestos = (List<Object>)impuestoxItemInfo.get('listaDescuentosImpuestos');
                        if(listaDescuentosImpuestos != null){
                            Integer j =0;
                            for(vlocity_cmt__OrderPriceAdjustment__c descuento : descuentos){
                                Map<String, Object> auxDescuentosImpuestos = (Map<String, Object>)listaDescuentosImpuestos.get(j);
                                Map<String, Object> infoDescuento = (Map<String, Object>)auxDescuentosImpuestos.get('infoDescuento');
                                infoDescuento.put('descripcion', descuento.vlocity_cmt__PriceListEntryId__r.vlocity_cmt__PricingElementId__r.vlocity_cmt__DisplayText__c);
                                j++;
                            }
                        }
                    }
                }
    
                i++;
            }
        }
        

        outMap.put('IPResult', response);
    }

    private static Map<String, Object> Generate_RequestS013(String orderId) {
        System.debug('Generate_RequestS013');
        Order order = [SELECT  OrderNumber, 
                Account.AccountIntegrationId__c, 
                Account.CustomerIntegrationId__c,
                CreatedDate,
                BillingMode__c,
                vlocity_cmt__OrderTotal__c,
                OriginStoreLocation__c,
                OriginStoreLocation__r.PointOfSaleId__c,
                OriginStoreLocation__r.Location__r.Name,
                OriginStoreLocation__r.vlocity_cmt__State__c,
                PickUpStoreLocation__c,
                PickUpStoreLocation__r.PointOfSaleId__c,
                PickUpStoreLocation__r.Location__r.Name,
                PickUpStoreLocation__r.vlocity_cmt__State__c
            FROM Order 
            WHERE Id = :orderId
        ];
        // System.debug('1');
        List<OrderItem> orderItems = taOrderController.GetOrderItemsBillable(orderId);
        // System.debug('orderItemsBillable: ' + JSON.serialize(orderItems));
        // System.debug('2');

        Map<String, Object> request = new Map<String, Object>();
        Map<String, Object> calculoImpuestosPeticion = new Map<String, Object>();
        calculoImpuestosPeticion.put('nivel', 'Cliente');
        calculoImpuestosPeticion.put('idCliente', order.Account.CustomerIntegrationId__c);
        // System.debug('3');
        Map<String, Object> infoPetCalculoImpuestos = new Map<String, Object>();
        List<Map<String, Object>> listaCantidadCargos = new List<Map<String, Object>>();

        // Obtengo todos los descuentos para luego aplicarlos en el order item que corresponde
        // y se ponen en una estructura tipo hashtable para poder acceder directamente luego
        Map<String, List<vlocity_cmt__OrderPriceAdjustment__c>> hashDescuentos = taOrderController.GetPriceAdjustmentsGroupByOrderItem(orderId);
        // System.debug('4');
        // // Total  sin impuestos
        Decimal totalBasePrice = 0;

        Integer i = 1;
        for (OrderItem orderItem : orderItems){
            String codCargo = '';
            System.debug('antes de charge code');
            Map<String, Object> chargeCode = AssetAttributesUtils.ObtenerChargeCode(orderItem.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c);
            if(chargeCode != null){
                codCargo = String.valueOf(chargeCode.get('value__c'));
            }
            System.debug('despues de charge code');
            for(Integer j = 1 ; j <= orderItem.Quantity; j++){
                Integer indice = (i*j)-1;
                Map<String, Object> infoCargo = new Map<String, Object>();
                Map<String, Object> cargo = new Map<String, Object>();
                System.debug('antes price');
                Decimal price = GetBasePrice(orderItem);
                System.debug('despues price');
                                
                System.debug('Base Price:' +price);

                totalBasePrice = totalBasePrice + price;

                String origenProducto = 'NAC';
                Map<String, Object> attrbFabricacion = AssetAttributesUtils.GetJSONAttribute(orderItem.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c, 'Fabricacion');
                if(attrbFabricacion != null){
                    // System.debug('despacho: ' + attrbFabricacion.get('value__c'));
                    String despacho = String.valueOf(attrbFabricacion.get('value__c'));
                    if(despacho != null){
                        origenProducto = IntegrationUtils.ParseFabricacion(despacho);
                    }

                }
            
                cargo.put('codCargo', codCargo);
                cargo.put('secuenciaProductoAdquirido', indice + 1);
                cargo.put('precioBase', IntegrationUtils.ParseAmount(price));
                cargo.put('cantUnidadesProdAdquiridas', '1');
                cargo.put('codMoneda', 'ARS');
                cargo.put('origenProducto', origenProducto);
                cargo.put('bienUso', false);

                // System.debug('hashDescuentos: ' + JSON.serialize(hashDescuentos));
                        
                // aca hago todo lo de descuentos
                if(hashDescuentos != null && hashDescuentos.size() > 0){
                    List<vlocity_cmt__OrderPriceAdjustment__c> descuentos = hashDescuentos.get(orderItem.Id);
                    if(descuentos != null && descuentos.size() > 0){
                        List<Object> listaDescuentos = new List<Object>();
                        for(vlocity_cmt__OrderPriceAdjustment__c descuento : descuentos){

                            Map<String, Object> infoDescuentos = new Map<String, Object>();
                            Map<String, Object> auxInfoDescuentos = new Map<String, Object>();

                            //Decimal discount = getDiscount(descuento.vlocity_cmt__OrderItemId__r.vlocity_cmt__PricingLogData__c, descuento.vlocity_cmt__PriceListEntryId__c);
                            System.debug('antes baseDiscount: ');
                            Decimal baseDiscount = GetBaseDiscount(orderItem.vlocity_cmt__Product2Id__r.Alicuota__c, orderItem.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c, descuento.vlocity_cmt__OrderItemId__r.vlocity_cmt__PricingLogData__c, descuento.vlocity_cmt__PriceListEntryId__c);
                            System.debug('baseDiscount: ' + baseDiscount);

                            totalBasePrice = totalBasePrice - baseDiscount;
                            
                            //auxInfoDescuentos.put('codDescuentoPrecioProducto', descuento.vlocity_cmt__PriceListEntryId__r.vlocity_cmt__PricingElementId__r.vlocity_cmt__Code__c);
                            auxInfoDescuentos.put('codDescuentoPrecioProducto', descuento.vlocity_cmt__Sequence__c);
                            auxInfoDescuentos.put('cantidadDescuento', 1);
                            auxInfoDescuentos.put('montoDescuentoPrecioProducto', IntegrationUtils.ParseAmount(baseDiscount));
                            auxInfoDescuentos.put('descripcionDescuentoPrecioProducto', descuento.vlocity_cmt__PriceListEntryId__r.vlocity_cmt__PricingElementId__r.vlocity_cmt__DisplayText__c);
                            infoDescuentos.put('infoDescuentos', auxInfoDescuentos);
                            // listaDescuentos.put('infoDescuento', infoDescuento);
                            listaDescuentos.add(infoDescuentos);
                            
                        }
                        cargo.put('listaDescuentos', listaDescuentos);
                    }
                }
                // fin descuentos

                // System.debug('asd');
                infoCargo.put('infoCargo',cargo);
                listaCantidadCargos.add(infoCargo);
                // System.debug('5');
            }

            i = i + 1;
        }
        
        System.debug('6');

        // agrego los cargos de CFT
        if(order.vlocity_cmt__OrderTotal__c > 0){
            List<vlocity_cmt__PaymentAdjustment__c> payments = taOrderController.GetPaymentAdjustmentsWithCFT(OrderId);
            HW_Charge_Code_Taxes_CFT__c taxCFT = HW_Charge_Code_Taxes_CFT__c.getInstance('Default');
            String codCargo = taxCFT.Charge_Code__c;
            for (vlocity_cmt__PaymentAdjustment__c payment : payments){
                // System.debug('ENTROOO');
                Integer indice = i - 1;
                Map<String, Object> infoCargo = new Map<String, Object>();
                Map<String, Object> cargo = new Map<String, Object>();
    
                Decimal price = 0;
    
                // necesitamos pasar a HW el porcentaje del CFT del total de la orden sin impuestos.
                // si hubiese mas de un metodo de pago, tenemos q calcular primero el porcentaje que representa ese pago en el total de la orden y luego seguir con los calculos
                // asumo que el campo payment.vlocity_cmt__Amount__c viene sin el CFT calculado.
    
                // Ejemplo, si algo vale $8.000 (impuestos incluidos) y paga una tarjeta con $5.000 y otra $3.000 y ambas tienen un CFT del %5
                // buscamos el porcentaje que representa $3000 en el total de la orden
                // 3000 * 100 / 5000 = 37,5%
                // System.debug(payment.vlocity_cmt__Amount__c);
                // System.debug(order.vlocity_cmt__OrderTotal__c);
                System.debug('totalBasePrice: ' + totalBasePrice);

                Decimal percentaje = payment.vlocity_cmt__Amount__c * 100 / order.vlocity_cmt__OrderTotal__c;
                System.debug('payment.vlocity_cmt__Amount__c: ' + payment.vlocity_cmt__Amount__c);
                System.debug('order.vlocity_cmt__OrderTotal__c: ' + order.vlocity_cmt__OrderTotal__c);
                System.debug('porcentaje: ' + percentaje);
                // ahora obtengo el bruto con el porcentaje obtenido
                // 37,5% * $6611,5702 (total de la orden sin impuestos) / 100 = $2479,3388
                Decimal basePrice = percentaje * totalBasePrice / 100;
                System.debug('basePrice: ' + basePrice);
                // por ultimo calculo el CFT del bruto recien calculado
                // $2479,3388 * 0,05 / 100 = $123,9669 esto le tengo q mandar a HW para que calcule los impuestos del CFT aplicado
                price = basePrice * payment.Financial_Promotion__r.Percentage__c / 100;           
                System.debug('price: ' + price);

                cargo.put('codCargo', codCargo);
                cargo.put('secuenciaProductoAdquirido', indice + 1);
                cargo.put('precioBase', IntegrationUtils.ParseAmount(price));
                cargo.put('cantUnidadesProdAdquiridas', '1');
                cargo.put('codMoneda', 'ARS');
                cargo.put('origenProducto', 'NAC');
                cargo.put('bienUso', false);
                infoCargo.put('infoCargo',cargo);
                listaCantidadCargos.add(infoCargo);
    
                i = i + 1;
            }
        }
        // System.debug('5');
        infoPetCalculoImpuestos.put('listaCantidadCargos', listaCantidadCargos);


        Map<String, Object> infoVentas = new Map<String, Object>();

        infoVentas.put('fechaVenta', IntegrationUtils.ParseDateTime(DateTime.now()));

        if(order.PickUpStoreLocation__c != null){
            if( order.PickUpStoreLocation__r.Location__r != null && 
                order.PickUpStoreLocation__r.Location__r.Name != null){
                infoVentas.put('codLocalidad', String.valueOf(order.PickUpStoreLocation__r.Location__r.Name).touppercase());
            }

            if(order.PickUpStoreLocation__r.vlocity_cmt__State__c != null){
                infoVentas.put('codProvincia', order.PickUpStoreLocation__r.vlocity_cmt__State__c.touppercase());
            }

        } else {
            if(order.OriginStoreLocation__c != null){
                if( order.OriginStoreLocation__r.Location__r != null && 
                    order.OriginStoreLocation__r.Location__r.Name != null){
                    infoVentas.put('codLocalidad', String.valueOf(order.OriginStoreLocation__r.Location__r.Name).touppercase());
                }

                if(order.OriginStoreLocation__r.vlocity_cmt__State__c != null){
                    infoVentas.put('codProvincia', order.OriginStoreLocation__r.vlocity_cmt__State__c.touppercase());
                }
            }
        }

        infoPetCalculoImpuestos.put('infoVentas', infoVentas);

        calculoImpuestosPeticion.put('infoPetCalculoImpuestos', infoPetCalculoImpuestos);

        Map<String, Object> body = new Map<String, Object>();
        body.put('calculoImpuestosPeticion', calculoImpuestosPeticion);

        // System.debug('8');
        request.put('body', body);
        return request;
    }

    // el epc tiene los precios con IVA
    // por lo tanto vamos a buscar la alicuota aplicada a un nodo particular del jsonAttribute
    public static Decimal GetBasePrice(OrderItem orderItem){
        Decimal alicuota = 0;
        if(orderItem.vlocity_cmt__Product2Id__r.Alicuota__c != null){
            alicuota = Decimal.valueOf(orderItem.vlocity_cmt__Product2Id__r.Alicuota__c);
            alicuota = alicuota+1;
        } else {
            Map<String, Object> attrbAlicuota = AssetAttributesUtils.GetJSONAttribute(orderItem.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c, 'Alicuota');
            if(attrbAlicuota != null){
                // System.debug('alicuota: ' + attrbAlicuota.get('value__c'));
                alicuota = Decimal.valueOf(String.valueOf(attrbAlicuota.get('value__c')));
                // convierto el 21 a 1.21 para poder dividirlo luego
                alicuota = (alicuota / 100) + 1;
            }
        }
        /*AM Sacar else donde se busca el attributo*/

        System.debug('GetBasePrice:alicuota -> ' + alicuota);

        Decimal basePrice = getPrice(orderItem);
        if(alicuota > 0){
            basePrice = basePrice / alicuota;
        }

        // basePrice = 60;
        return basePrice;
    }

    private static Decimal getPrice(OrderItem orderItem){
        Decimal ret = 0;
        Map<String, Object> attribute = null;
        System.debug('pricinglogdata: ' + JSON.serialize(orderItem.vlocity_cmt__PricingLogData__c));
        if(orderItem.vlocity_cmt__PricingLogData__c == null){
            System.debug('orderItem.vlocity_cmt__EffectiveRecurringTotal__c: ' + orderItem.vlocity_cmt__EffectiveRecurringTotal__c);
            if(orderItem.vlocity_cmt__EffectiveOneTimeTotal__c != null){
                ret = orderItem.vlocity_cmt__EffectiveOneTimeTotal__c;
            }
            if(orderItem.vlocity_cmt__EffectiveRecurringTotal__c != null){
                ret += orderItem.vlocity_cmt__EffectiveRecurringTotal__c;
            }
        } else {
            Map<String, Object> priceLog = (Map<String, Object>)JSON.deserializeUntyped(orderItem.vlocity_cmt__PricingLogData__c);
            System.debug('vlocity_cmt__PricingLogData__c: ' + orderItem.vlocity_cmt__PricingLogData__c);
            Map<String,Object> logData = (Map<String,Object>)priceLog.get('LogData');
            List<Object> ot_std_prc = (List<Object>)logData.get('OT_STD_PRC');
            if(ot_std_prc == null){
                throw new FuncException('No se pudo obtener el precio del producto \'' + orderItem.vlocity_cmt__Product2Id__r.Name + '\'.');
            }
            
            Map<String, Object> aux = (Map<String, Object>)ot_std_prc[0];
            ret = Decimal.valueOf(String.valueOf(aux.get('BaseValue')));
        }
        System.debug('getPrice:alicuota -> ' + ret);
        return ret;
    }

    public static Decimal GetBaseDiscount(String orderItemAlicuota, String jsonAttribute, String priceLog, String priceListEntryId){
        Decimal alicuota = 0;
        if(orderItemAlicuota != null){
            alicuota = Decimal.valueOf(orderItemAlicuota);
            alicuota = alicuota+1;
        } else {
            Map<String, Object> attrbAlicuota = AssetAttributesUtils.GetJSONAttribute(jsonAttribute, 'Alicuota');
            if(attrbAlicuota != null){
                // System.debug('alicuota: ' + attrbAlicuota.get('value__c'));
                alicuota = Decimal.valueOf(String.valueOf(attrbAlicuota.get('value__c')));
                // convierto el 21 a 1.21 para poder dividirlo luego
                alicuota = (alicuota / 100) + 1;
            }
        }
        System.debug('GetBaseDiscount:alicuota -> ' + alicuota);
        /*AM Sacar else donde se busca por json attribute */
        Decimal baseDiscount = getDiscount(priceLog, priceListEntryId);
        if(alicuota > 0){
            baseDiscount = baseDiscount / alicuota;
        }

        return baseDiscount;

        // Decimal ret = null;
        // Map<String, Object> attribute = null;
        // if(stringPriceLog != null){
        //     Map<String, Object> priceLog = (Map<String, Object>)JSON.deserializeUntyped(stringPriceLog);
        //     Map<String,Object> logData = (Map<String,Object>)priceLog.get('LogData');
        //     List<Object> ot_std_prc = (List<Object>)logData.get('OT_STD_PRC');

        //     for (Object element : ot_std_prc){
        //         Map<String, Object> aux = (Map<String, Object>)element;
        //         if(aux.get('PriceListEntryId') == priceListEntryId){
        //             ret = Decimal.valueOf(String.valueOf(aux.get('BaseAdjustment'))) * -1;
        //             break;
        //         }
        //     }
        // }

        // return ret;
    }
    
    private static Decimal getDiscount(String stringPriceLog, String priceListEntryId){
        Decimal ret = null;
        Map<String, Object> attribute = null;
        if(stringPriceLog != null){
            Map<String, Object> priceLog = (Map<String, Object>)JSON.deserializeUntyped(stringPriceLog);
            Map<String,Object> logData = (Map<String,Object>)priceLog.get('LogData');
            List<Object> ot_std_prc = (List<Object>)logData.get('OT_STD_PRC');

            for (Object element : ot_std_prc){
                Map<String, Object> aux = (Map<String, Object>)element;
                if(aux.get('PriceListEntryId') == priceListEntryId){
                    ret = Decimal.valueOf(String.valueOf(aux.get('BaseAdjustment'))) * -1;
                    break;
                }
            }
        }

        return ret;
    }

    global static void GetOrderItemsBillable(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        // System.debug('GetOrderItemsBillable');
        String orderId = (String)(options.get('OrderId'));
        List<OrderItem> orderItems = taOrderController.GetOrderItemsBillable(orderId);
        outMap.put('Items', orderItems);
    }

    global static void GetPriceAdjustmentsGroupByOrderItem(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        // System.debug('GetPriceAdjustmentsGroupByOrderItem');
        String orderId = (String)(options.get('OrderId'));
        Map<String, List<vlocity_cmt__OrderPriceAdjustment__c>> priceAdjustments = taOrderController.GetPriceAdjustmentsGroupByOrderItem(orderId);
        outMap.put('data', priceAdjustments);
    }
}