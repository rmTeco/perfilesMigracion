global with sharing class taSalesOrderPaymentInteraction implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('SendPayment')){
                SendPayment(inputMap, outMap, options);
            }
            if (methodName.equals('ValidatePaymentAdjustment')){
                ValidatePaymentAdjustment(inputMap, outMap, options);
            }
            result = false;
            //System.debug('outMap:' + outMap);
        }
        catch(Exception e)
        {
            System.debug('taSalesOrderPaymentInteraction:invokeMethod -> exception: '+e+e.getStackTraceString());
            throw e;
            //result = false;
        }
        return result;
    }

    private void ValidatePaymentAdjustment(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        System.debug('ValidatePaymentAdjustment');

        String idOrder = (String)options.get('IdOrder');
        System.debug(idOrder);
        Order order = [SELECT  OrderNumber,
                AccountId,
                vlocity_cmt__OrderTotal__c
            FROM Order
            WHERE Id = :idOrder];

        List<vlocity_cmt__PaymentAdjustment__c> paymentAdjustmentsValidate = [
            SELECT
                Id,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c,
                vlocity_cmt__Amount__c

            FROM vlocity_cmt__PaymentAdjustment__c
            WHERE Order__r.Id = :idOrder];

        System.debug('PRINT ORDER TOTAL: '+order.vlocity_cmt__OrderTotal__c);
        System.debug('PRINT paymentAdjustmentsValidate.size: '+paymentAdjustmentsValidate.size());

        if(order.vlocity_cmt__OrderTotal__c == 0 && paymentAdjustmentsValidate.size() == 0){

            vlocity_cmt__PaymentMethod__c newPaymentMethod = new vlocity_cmt__PaymentMethod__c();
            newPaymentMethod.Vlocity_cmt__AccountId__c = order.AccountId;
            newPaymentMethod.Vlocity_cmt__MethodType__c = '1001';
            insert newPaymentMethod;

            vlocity_cmt__PaymentAdjustment__c paymentAdjC = new vlocity_cmt__PaymentAdjustment__c();
            paymentAdjC.vlocity_cmt__AccountId__c = order.AccountId;
            paymentAdjC.vlocity_cmt__PaymentMethodId__c = newPaymentMethod.id;
            paymentAdjC.Order__c = idOrder;
            paymentAdjC.vlocity_cmt__Amount__c = order.vlocity_cmt__OrderTotal__c;
            paymentAdjC.vlocity_cmt__PaymentMethodId__r = newPaymentMethod;
            insert paymentAdjC;
        }

    }

    private void SendPayment(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('Send Payment');

        String orderId = (String)options.get('IdOrder');

        Map<String, Object> input = Generate_RequestS029(orderId);
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();

        System.debug('request s029: ' + JSON.serialize(input));
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S029', input, output, options2);
        System.debug('response S029: ' + JSON.serialize(output));

        outMap.put('IP_Response', output);
        System.debug('IP_Response ====> ' + output);
        Map<String, Object> ip_result = (Map<String, Object>)output.get('IPResult');
        String numeroComprobante = String.valueOf(ip_result.get('numeroComprobante'));
        Order order = new Order(Id = orderId);
        order.BillingMode__c = GetOrderInvoicingMethod(orderId);

        if (numeroComprobante != null) {
            order.PreInvoiceNumber__c = numeroComprobante;
            order.vlocity_cmt__TrackingNumber__c = numeroComprobante; // se graba aca tambien para OM ya que lo van a buscar ahi.
            order.DateTime_Sent_S029__c = Datetime.now();
            order.TrackingStatus__c = 'Pendiente de pago';
        } else {
            order.PreInvoiceNumber__c = '';
            order.TrackingStatus__c = 'Cancelada - Timeout Validacion';
        }

        update order;

        // List<OrderItem> orderItems = taOrderController.GetOrderItemsBillable(orderId);
        // Integer i = 1;
        // for (OrderItem orderItem : orderItems){
        //     orderItem.Huawei_Invoice_Item_Sequence__ct - 1ring.valueOf(i);
        // }
        // update orderItems;
    }

    private Map<String, Object> Generate_RequestS029(String idOrder) {
        System.debug('Generate_RequestS029');
        Order order = [SELECT  OrderNumber,
                AccountId,
                Account.AccountIntegrationId__c,
                CreatedDate,
                BillSimulationPayload__c,
                vlocity_cmt__OrderTotal__c,
                PickUpStoreLocation__r.PointOfSaleId__c,
                PickUpStoreLocation__r.vlocity_cmt__State__c,
                PickUpStoreLocation__r.Location__r.Name,
                OriginStoreLocation__r.PointOfSaleId__c,
                OriginStoreLocation__r.Location__r.Name,
                OriginStoreLocation__r.vlocity_cmt__State__c,
                OriginStoreLocation__r.Channel_Type_3__c,
                OriginStoreLocation__r.PaymentChannel__c,
                Gestion__c
            FROM Order
            WHERE Id = :idOrder];

        if(order.BillSimulationPayload__c == null){
            throw new FuncException('No hay simulacion.');
        }
        System.debug('1');
        Map<String, Object> simulation = (Map<String, Object>)JSON.deserializeUntyped(order.BillSimulationPayload__c);

        String billingMode = GetOrderInvoicingMethod(idOrder);

        // System.debug('simulacion: ' + JSON.serialize(simulation));

        Map<String, Object> request = new Map<String, Object>();

        request.put('codOrden', order.OrderNumber);

        Map<String, Object> codAcceso = new Map<String, Object>();
        Map<String, Object> codAccesoCuenta = new Map<String, Object>();
        Map<String, Object> codAccCuenta = new Map<String, Object>();
        codAccCuenta.put('idCuenta', order.Account.AccountIntegrationId__c);
        codAccesoCuenta.put('codAccCuenta', codAccCuenta);
        codAcceso.put('codAccesoCuenta', codAccesoCuenta);
        request.put('codAcceso', codAcceso);

        request.put('codTipoCanal', IntegrationUtils.ParseInvoiceType(billingMode));
        System.debug('1');
        Map<String, Object> infoCargos = new Map<String,Object>();
        infoCargos.put('tipoCargo', 'S');
        infoCargos.put('fechaAltaOrden', IntegrationUtils.ParseDateTime(order.CreatedDate));
        infoCargos.put('fechaAltaComprobante', IntegrationUtils.ParseDateTime(DateTime.now()));
        List<Map<String, Object>> listaDetalleCargoInfo = new List<Map<String, Object>>();

        List<OrderItem> orderItems = taOrderController.GetOrderItemsBillable(idOrder);

        // de la simulacion
        Map<String, Object> calculoImpuestosRespuesta = (Map<String, Object>)simulation.get('calculoImpuestosRespuesta');
        if(calculoImpuestosRespuesta == null){
            throw new FuncException('La respuesta de la simulacion no es correcta');
        }

        System.debug('2');
        vlocity_cmt__BusinessSite__c storeLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());

        Map<String, List<vlocity_cmt__OrderPriceAdjustment__c>> hashDescuentos = taOrderController.GetPriceAdjustmentsGroupByOrderItem(idOrder);

        // Map<String, Object> infoResCalculoImpuesto = (Map<String, Object>)calculoImpuestosRespuesta.get('infoResCalculoImpuesto');
        // List<Object> arrImpuestos = (List<Object>)infoResCalculoImpuesto.get('impuestoxItemInfo');
        List<Object> arrImpuestos = (List<Object>)calculoImpuestosRespuesta.get('infoResCalculoImpuestos');

        // // Total  sin impuestos
        Decimal totalBasePrice = 0;

        Integer i = 1;

        for (OrderItem orderItem : orderItems){
            System.debug('2');
            String codCargo = '';
            String origenProducto = '';
            Map<String, Object> chargeCode = AssetAttributesUtils.ObtenerChargeCode(orderItem.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c);
            if(chargeCode == null){
                String error = String.format('El producto {0} ({1}) no tiene Charge Code configurado.', new String[] { orderItem.vlocity_cmt__Product2Id__r.Name, orderItem.vlocity_cmt__Product2Id__r.ProductCode });
                throw new FuncException(error);
            }

            // System.debug('chargeCode: ' + chargeCode);
            if(chargeCode != null){
                codCargo = String.valueOf(chargeCode.get('value__c'));
                origenProducto = String.valueOf(chargeCode.get('categorycode__c'));
            }

            System.debug('3');

            // System.debug('indice: ' + indice);
            System.debug('4');
            
            Map<String, Object> detalleCargoInfo = new Map<String, Object>();
            // Map<String, Object> detalleCargoInfo = new Map<String, Object>();
            // System.debug('5');
            // Decimal price = orderItem.vlocity_cmt__EffectiveOneTimeTotal__c + orderItem.vlocity_cmt__EffectiveRecurringTotal__c;
            Decimal price = taSalesSimulationInvoiceHandler.GetBasePrice(orderItem);

            totalBasePrice = totalBasePrice + price;

            detalleCargoInfo.put('secuenciaProductoAdquirido', orderItem.Huawei_Invoice_Item_Sequence__c);
            detalleCargoInfo.put('codCargo', codCargo);
            //detalleCargoInfo.put('codProducto', orderItem.vlocity_cmt__Product2Id__r.FAN_IntegrationKey__c);
            //detalleCargoInfo.put('descripcionProducto', orderItem.vlocity_cmt__Product2Id__r.Name);
            detalleCargoInfo.put('cantUnidadesProdAdquiridas', '1');
            detalleCargoInfo.put('precioBase', IntegrationUtils.ParseAmount(price));
            detalleCargoInfo.put('precioProducto', IntegrationUtils.ParseAmount(price));

            // va para el wave 3 el EPC deberia modelar las ofertas y descuentos en el producto
            // "listaDescuentos": [
            //     {
            //     "codDescuentoPrecioProducto": "string",
            //     "cantidadDescuento": "string",
            //     "montoDescuentoPrecioProducto": "string",
            //     "descripcionDescuentoPrecioProducto": "string",
            //     "listaImpuestos": [
            //         {
            //         "codImpuesto": "string",
            //         "importeImpuestoAplicado": "string",
            //         "alicuotaImpuesto": "string",
            //         "tipoCategoriaImpositiva": "string"
            //         }
            //     ]
            //     }
            // ],

            System.debug('COD CARGO: ' + codCargo);
            System.debug('ORIGEN PRODUCTO: ' + origenProducto);



            //detalleCargoInfo.put('origenProducto', origenProducto);
            //// TO DO categorycode__c es una letra, se debera convertir a NAC, IMP, TDF REVISAR!
            detalleCargoInfo.put('origenProducto', 'NAC');
            detalleCargoInfo.put('bienUso', false);
                
            if(arrImpuestos != null && 
                Integer.valueOf(orderItem.Huawei_Invoice_Item_Sequence__c) - 1 < arrImpuestos.size() &&
                arrImpuestos[Integer.valueOf(orderItem.Huawei_Invoice_Item_Sequence__c) - 1] != null){
                
                List<Map<String, Object>> listaImpuestos = new List<Map<String, Object>>();

                Map<String, Object> auxImpuesto = (Map<String, Object>)arrImpuestos[Integer.valueOf(orderItem.Huawei_Invoice_Item_Sequence__c) - 1];
                Map<String, Object> impuestoxItemInfo = (Map<String, Object>)auxImpuesto.get('impuestoxItemInfo');

                List<Object> listaInfoImpuestos = (List<Object>)impuestoxItemInfo.get('listaInfoImpuestos');
                for(Integer k = 0 ; k < listaInfoImpuestos.size(); k++){
                    Map<String, Object> infoImpuesto2 = (Map<String, Object>)listaInfoImpuestos[k];
                    Map<String, Object> infoImpuesto = (Map<String, Object>)infoImpuesto2.get('infoImpuesto');

                    Map<String, Object> impuesto = new Map<String, Object>();
                    impuesto.put('codImpuesto', infoImpuesto.get('codImpuesto'));
                    impuesto.put('importeImpuestoAplicado', infoImpuesto.get('importeImpuestoAplicado'));
                    impuesto.put('alicuotaImpuesto', infoImpuesto.get('alicuotaImpuesto'));
                    impuesto.put('tipoCategoriaImpositiva', infoImpuesto.get('tipoCategoriaImpositiva'));

                    listaImpuestos.add(impuesto);
                }
                detalleCargoInfo.put('listaImpuestos', listaImpuestos);
                System.debug('6');

                // aca hago todo lo de descuentos
                List<Object> listaDescuentosImpuestos = (List<Object>)impuestoxItemInfo.get('listaDescuentosImpuestos');
                if(hashDescuentos != null && hashDescuentos.size() > 0 &&
                listaDescuentosImpuestos != null && listaDescuentosImpuestos.size() > 0){
                    // obtengo los descuentos de las respuesta del S013

                    List<vlocity_cmt__OrderPriceAdjustment__c> descuentos = hashDescuentos.get(orderItem.Id);
                    if(descuentos != null && descuentos.size() > 0){
                        List<Map<String, Object>> listaDescuentos = new List<Map<String, Object>>();
                        for(vlocity_cmt__OrderPriceAdjustment__c descuento : descuentos){

                            Map<String, Object> infoDescuentos = new Map<String, Object>();

                            //Decimal discount = getDiscount(descuento.vlocity_cmt__OrderItemId__r.vlocity_cmt__PricingLogData__c, descuento.vlocity_cmt__PriceListEntryId__c);
                            Decimal baseDiscount = taSalesSimulationInvoiceHandler.GetBaseDiscount(orderItem.vlocity_cmt__Product2Id__r.Alicuota__c, orderItem.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c, descuento.vlocity_cmt__OrderItemId__r.vlocity_cmt__PricingLogData__c, descuento.vlocity_cmt__PriceListEntryId__c);
                            // System.debug('baseDiscount: ' + baseDiscount);

                            totalBasePrice = totalBasePrice - baseDiscount;

                            //infoDescuentos.put('codDescuentoPrecioProducto', descuento.vlocity_cmt__PriceListEntryId__r.vlocity_cmt__PricingElementId__r.vlocity_cmt__Code__c);
                            infoDescuentos.put('codDescuentoPrecioProducto', descuento.vlocity_cmt__Sequence__c);
                            infoDescuentos.put('cantidadDescuento', 1);
                            infoDescuentos.put('montoDescuentoPrecioProducto', IntegrationUtils.ParseAmount(baseDiscount));
                            infoDescuentos.put('descripcionDescuentoPrecioProducto', descuento.vlocity_cmt__PriceListEntryId__r.vlocity_cmt__PricingElementId__r.vlocity_cmt__DisplayText__c);

                            List<Map<String, Object>> auxListaImpuestos = new List<Map<String, Object>>();
                            for(Object auxDescuentoImpuesto : listaDescuentosImpuestos){
                                Map<String, Object> infoDescuento = (Map<String, Object>)((Map<String, Object>)auxDescuentoImpuesto).get('infoDescuento');
                                List<Object> listaInfoImpuestos2 = (List<Object>)infoDescuento.get('listaInfoImpuestos');
                                for(Object auxInfoImpuesto : listaInfoImpuestos2){
                                    Map<String, Object> auxDescuentoImpuesto2 = (Map<String, Object>)auxInfoImpuesto;
                                    Map<String, Object> infoImpuesto = (Map<String, Object>)auxDescuentoImpuesto2.get('infoImpuesto');

                                    Map<String, Object> aux = new Map<String, Object>();
                                    aux.put('codImpuesto', infoImpuesto.get('codImpuesto'));
                                    aux.put('importeImpuestoAplicado', infoImpuesto.get('importeImpuestoAplicado'));
                                    aux.put('alicuotaImpuesto', infoImpuesto.get('alicuotaImpuesto'));
                                    aux.put('tipoCategoriaImpositiva', infoImpuesto.get('tipoCategoriaImpositiva'));

                                    auxListaImpuestos.add(aux);
                                }
                                
                            }
                            infoDescuentos.put('listaImpuestos', auxListaImpuestos);

                            listaDescuentos.add(infoDescuentos);

                        }

                        detalleCargoInfo.put('listaDescuentos', listaDescuentos);
                    }
                }
                // fin descuentos


                // Completar con los datos del S095
                // IMEI, Linea, Serie, N Despacho, Aduana, Origen, Orden
                // KI, MSSDN del plan, ICCID,Codigo Orden Despacho, Aduana Ingreso, Pais Origen, Codigo Orden Despacho
                // AssetAttributesUtils.GetJSONAttribute('');

                // List<Map<String,Object>> listaDatosAdicionales = new List<Map<String,Object>>();

                // Map<String,Object> mapa1 = new Map<String,Object>();
                // mapa1.put('nombreParametro', 'IMEI');
                // mapa1.put('valorParametro', '213123321');

                // Map<String,Object> mapa2 = new Map<String,Object>();
                // mapa2.put('nombreParametro', 'LINE1');
                // mapa2.put('valorParametro', 'Linea:5654664564 Serie:8577687686 N. Desp IV53');

                // Map<String,Object> mapa3 = new Map<String,Object>();
                // mapa3.put('nombreParametro', 'LINE2');
                // mapa3.put('valorParametro', 'Aduana: Ezeiza Origen: BR Orden: 2254323');

                // listaDatosAdicionales.add(mapa1);
                // listaDatosAdicionales.add(mapa2);
                // listaDatosAdicionales.add(mapa3);


                // detalleCargoInfo.put('listaDatosAdicionales', listaDatosAdicionales);
                //////////////////////////////////

                Map<String, Object> datosProductoCRM = new Map<String, Object>();
                datosProductoCRM.put('descripcionProducto', orderItem.vlocity_cmt__Product2Id__r.Name);
                if(orderItem.vlocity_cmt__Product2Id__r.Tangible__c == true){
                    if(orderItem.vlocity_cmt__Product2Id__r.vlocity_cmt__Type__c == 'Simcard'){
                        Map<String, Object> nmu = AssetAttributesUtils.getJSONAttribute(orderItem.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c,'NMU Simcard');
                        datosProductoCRM.put('codProducto', nmu.get('attributeuniquecode__c'));
                    }
                    else{
                        datosProductoCRM.put('codProducto', orderItem.vlocity_cmt__Product2Id__r.NMU__c);
                    }
                }
                else{
                    datosProductoCRM.put('codProducto', orderItem.vlocity_cmt__Product2Id__r.ProductCode);
                }
                string modalidadVenta = 'NA';
                if(orderItem.vlocity_cmt__Product2Id__r.Family == 'Movil' && orderItem.vlocity_cmt__Product2Id__r.vlocity_cmt__Type__c == 'Dispositivo'){
                    modalidadVenta = 'PV';
                }
                datosProductoCRM.put('modalidadVenta', modalidadVenta);

                detalleCargoInfo.put('datosProductoCRM', datosProductoCRM);

                listaDetalleCargoInfo.add(detalleCargoInfo);
            }
        }

        // SE AGREGAN LOS CARGOS DE CFT
        List<vlocity_cmt__PaymentAdjustment__c> payments = taOrderController.GetPaymentAdjustmentsWithCFT(idOrder);
        HW_Charge_Code_Taxes_CFT__c taxCFT = HW_Charge_Code_Taxes_CFT__c.getInstance('Default');
        String codCargo = taxCFT.Charge_Code__c;
        String codCargoDescripcion = taxCFT.Description__c;
        // System.debug('Cargos CFT size: '+payments.size());
        for (vlocity_cmt__PaymentAdjustment__c payment : payments){
            String origenProducto = '';
            System.debug(Integer.valueOf(payment.Huawei_Invoice_Item_Sequence__c));
            System.debug(arrImpuestos.size());
            if(Integer.valueOf(payment.Huawei_Invoice_Item_Sequence__c) - 1 < arrImpuestos.size() &&
                arrImpuestos[Integer.valueOf(payment.Huawei_Invoice_Item_Sequence__c) - 1] != null){
                Map<String, Object> detalleCargoInfo = new Map<String, Object>();
                System.debug('necesitamos pasar a HW el porcentaje del CFT');
                // necesitamos pasar a HW el porcentaje del CFT del total de la orden sin impuestos.
                // si hubiese mas de un metodo de pago, tenemos q calcular primero el porcentaje que representa ese pago en el total de la orden y luego seguir con los calculos
                // asumo que el campo payment.vlocity_cmt__Amount__c viene sin el CFT calculado.

                // Ejemplo, si algo vale $8.000 (impuestos incluidos) y paga una tarjeta con $5.000 y otra $3.000 y ambas tienen un CFT del %5
                // buscamos el porcentaje que representa $3000 en el total de la orden
                // 3000 * 100 / 5000 = 37,5%
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
                Decimal price = basePrice * payment.Financial_Promotion__r.Percentage__c / 100;
                System.debug('price: ' + price);

                detalleCargoInfo.put('secuenciaProductoAdquirido', payment.Huawei_Invoice_Item_Sequence__c);
                detalleCargoInfo.put('cantUnidadesProdAdquiridas', '1');
                detalleCargoInfo.put('precioBase', IntegrationUtils.ParseAmount(price));
                detalleCargoInfo.put('precioProducto', IntegrationUtils.ParseAmount(price));

                // detalleCargoInfo.put('origenProducto', 'NAC');
                detalleCargoInfo.put('bienUso', false);

                List<Map<String, Object>> listaImpuestos = new List<Map<String, Object>>();

                Map<String, Object> auxImpuesto = (Map<String, Object>)arrImpuestos[Integer.valueOf(payment.Huawei_Invoice_Item_Sequence__c) - 1];
                Map<String, Object> impuestoxItemInfo = (Map<String, Object>)auxImpuesto.get('impuestoxItemInfo');

                List<Object> listaInfoImpuestos = (List<Object>)impuestoxItemInfo.get('listaInfoImpuestos');
                System.debug('listaInfoImpuestos: ' + JSON.serialize(listaInfoImpuestos));
                for(Integer k = 0 ; k < listaInfoImpuestos.size(); k++){
                    Map<String, Object> infoImpuesto2 = (Map<String, Object>)listaInfoImpuestos[k];
                    Map<String, Object> infoImpuesto = (Map<String, Object>)infoImpuesto2.get('infoImpuesto');

                    Map<String, Object> impuesto = new Map<String, Object>();
                    impuesto.put('codImpuesto', infoImpuesto.get('codImpuesto'));
                    impuesto.put('importeImpuestoAplicado', infoImpuesto.get('importeImpuestoAplicado'));
                    impuesto.put('alicuotaImpuesto', infoImpuesto.get('alicuotaImpuesto'));
                    impuesto.put('tipoCategoriaImpositiva', infoImpuesto.get('tipoCategoriaImpositiva'));

                    listaImpuestos.add(impuesto);
                }

                detalleCargoInfo.put('listaImpuestos', listaImpuestos);
                System.debug('6');
                //////////////////////////////////

                Map<String, Object> datosProductoCRM = new Map<String, Object>();
                datosProductoCRM.put('descripcionProducto', codCargoDescripcion);
                datosProductoCRM.put('codProducto', codCargo);
                datosProductoCRM.put('modalidadVenta', 'NA');

                detalleCargoInfo.put('datosProductoCRM', datosProductoCRM);

                listaDetalleCargoInfo.add(detalleCargoInfo);
            }

            i = i + 1;
        }

        // armo la lista de cargos a partir de lo que se mando a simular
        // se recupera el payload enviado y se arma para el request de facturacion.
        infoCargos.put('listaDetalleCargoInfo', listaDetalleCargoInfo);
        infoCargos.put('codMoneda', 'ARS');
        request.put('infoCargos', infoCargos);
        request.put('codVendedor', UserInfo.getUserId());

        // METODOS DE PAGOS
        List<vlocity_cmt__PaymentAdjustment__c> paymentAdjustments = [
            SELECT
                Id,
                vlocity_cmt__PaymentMethodId__r.BankEntityName__c,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardNumber__c,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationYear__c,
                vlocity_cmt__PaymentMethodId__r.Security__c,
                vlocity_cmt__TotalInstallments__c,
                vlocity_cmt__Amount__c,
                Financial_Promotion__r.id,
                Financial_Promotion__r.Name,
                Financial_Promotion__r.CreditCards__c,
                Financial_Promotion__r.NombrePromocion__c,
                Financial_Promotion__r.InstalmentPlan__c

            FROM vlocity_cmt__PaymentAdjustment__c
            WHERE Order__r.Id = :idOrder];

        List<Map<String, Object>> listaInfoPagos = new List<Map<String, Object>>();
        for (vlocity_cmt__PaymentAdjustment__c paymentAdjustment : paymentAdjustments){
            // System.debug('paymentAdjustment: ' + paymentAdjustment);
            Map<String, Object> infoPago = new Map<String, Object>();
            infoPago.put('codMedioPago', paymentAdjustment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c);

            Map<String, Object> wondersoftInfo = new Map<String, Object>();

            if(paymentAdjustment.Financial_Promotion__r.Name != null){
                wondersoftInfo.put('codPromoBanco', paymentAdjustment.Financial_Promotion__r.Name);
            }

            infoPago.put('wondersoftInfo', wondersoftInfo);

            System.debug('8.1');
            String cardNumber = paymentAdjustment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardNumber__c;
            System.debug('8.1.1');
            // if(cardNumber != null){
                System.debug('8.2. cardNumber:' + cardNumber);
                List<Map<String, Object>> listaInfoBancos = new List<Map<String, Object>>();
                Map<String, Object> infoBanco = new Map<String, Object>();

                String codEntidadFinanciera = null;
                if(paymentAdjustment.vlocity_cmt__PaymentMethodId__r.BankEntityName__c != null){
                    codEntidadFinanciera = paymentAdjustment.vlocity_cmt__PaymentMethodId__r.BankEntityName__c.leftPad(3, '0');
                }
                infoBanco.put('codEntidadFinanciera', codEntidadFinanciera);

                // infoBanco.put('codMedioPago', paymentAdjustment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c);

                // infoBanco.put('nroTarjetaEncriptado', paymentAdjustment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardNumber__c);
                // if(paymentAdjustment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationYear__c != null && paymentAdjustment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c != null){
                //     infoBanco.put('fechaVencimientoTarjeta', paymentAdjustment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationYear__c + paymentAdjustment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c);
                // }
                // infoBanco.put('codSeguridadTarjeta', paymentAdjustment.vlocity_cmt__PaymentMethodId__r.Security__c);

                String cantidadCuotasTarjeta = null;
                if(paymentAdjustment.vlocity_cmt__TotalInstallments__c != null){
                    cantidadCuotasTarjeta = String.valueOf(paymentAdjustment.vlocity_cmt__TotalInstallments__c).leftPad(2, '0');
                }
                infoBanco.put('cantidadCuotasTarjeta', cantidadCuotasTarjeta);

                String codEntidadTC = null;
                if(paymentAdjustment.Financial_Promotion__r.CreditCards__c != null){
                    codEntidadTC = paymentAdjustment.Financial_Promotion__r.CreditCards__c;
                }
                infoBanco.put('codEntidadTC', codEntidadTC);

                listaInfoBancos.add(infoBanco);
                infoPago.put('listaInfoBancos', listaInfoBancos);
            // }

            infoPago.put('codMoneda', 'ARS');

            // System.debug('8.1.3');
            string tipoPago = 'SalesInvoice';
            if(order.Gestion__c == 'Recarga')
                tipoPago = 'RechargeInvoice';
            infoPago.put('tipoPago', tipoPago);

            infoPago.put('codCanal', order.OriginStoreLocation__r.PaymentChannel__c);

            // System.debug('8.1.4');
            infoPago.put('importePago', IntegrationUtils.ParseAmount(paymentAdjustment.vlocity_cmt__Amount__c));

            String planCuota = null;
            if(paymentAdjustment.Financial_Promotion__r.InstalmentPlan__c != null) {
                planCuota = String.valueOf(paymentAdjustment.Financial_Promotion__r.InstalmentPlan__c);
            }
            infoPago.put('planCuota', planCuota);

            listaInfoPagos.add(infoPago);
        }
        System.debug('8.3. listaInfoPagos:' + listaInfoPagos);
        request.put('listaInfoPagos', listaInfoPagos);

        // "listaInfoPagos": [{
        //     "codMedioPago": "string",
        //     "listaInfoBancos": [
        //         {
        //         "codEntidadFinanciera": "string",
        //         "codSucursalEntidad": "string",
        //         "codMedioPago": "string",
        //         "nroTarjetaEncriptado": "string",
        //         "codEntidadTC": "string",
        //         "nombreActor": "string",
        //         "fechaVencimientoTarjeta": "string",
        //         "codSeguridadTarjeta": "string",
        //         "nroCheque": "string",
        //         "fechaEmisionCheque": "string",
        //         "cantidadCuotasTarjeta": "string"
        //         }
        //     ],
        //     "codMoneda": "string",
        //     "codPlataformaPago": "string",
        //     "importePago": "string",
        //     "planCuota": "string",
        //     "tipoPago": "string",
        //     "codCanal": "string"
        // }],

        // update order;

        //PFTA-8166 y PFTA-8124
        Boolean haveTangible = taOrderController.ValidateTangibleExistence(idOrder);
        String impDiferida = 'N';
        if(haveTangible){
            if(storeLocation != null && storeLocation.Channel__c != 'Físico'){
                impDiferida = 'Y';
            }
        }
        request.put('impDiferida', impDiferida);
        //FIN PFTA-8166 y PFTA-8124

        if(order.PickUpStoreLocation__r != null){
            System.debug(JSON.serialize(order.PickUpStoreLocation__r));
            if( order.PickUpStoreLocation__r.Location__r != null &&
                order.PickUpStoreLocation__r.Location__r.Name != null){
                request.put('codLocalidad', String.valueOf(order.PickUpStoreLocation__r.Location__r.Name).touppercase());
            }

            if(order.PickUpStoreLocation__r.vlocity_cmt__State__c != null){
                request.put('codProvincia', order.PickUpStoreLocation__r.vlocity_cmt__State__c.touppercase());
            }

            if (order.PickUpStoreLocation__r.PointOfSaleId__c != null){
                request.put('nroPuntoVentaFiscal', order.PickUpStoreLocation__r.PointOfSaleId__c);
            }

        } else {
            if(order.OriginStoreLocation__r != null){
                if( order.OriginStoreLocation__r.Location__r != null &&
                    order.OriginStoreLocation__r.Location__r.Name != null){
                    request.put('codLocalidad', String.valueOf(order.OriginStoreLocation__r.Location__r.Name).touppercase());
                }

                if(order.OriginStoreLocation__r.vlocity_cmt__State__c != null){
                    request.put('codProvincia', order.OriginStoreLocation__r.vlocity_cmt__State__c.touppercase());
                }

                if (order.OriginStoreLocation__r.PointOfSaleId__c != null){
                    request.put('nroPuntoVentaFiscal', order.OriginStoreLocation__r.PointOfSaleId__c);
                }
            }
        }

        Map<String, Object> body = new Map<String, Object>();
        body.put('body', request);

        // Map<String, Object> syncFacturaPeticion = new Map<String, Object>();
        // syncFacturaPeticion.put('syncFacturaPeticion', request);

        // Map<String, Object> body = new Map<String, Object>();
        // body.put('body', syncFacturaPeticion);

        System.debug('End Generate_RequestS029');
        return body;
    }

    public static string GetOrderInvoicingMethod(String orderId){
        // La configuración seria,
        // Modo de entrega Delivery >  Siempre es 12 (Electronico)
        // Canales presenciales y entrega presencial/store pickup  > Según el canal del usuario
        // Canales no presenciales  y entrega store pickup > según el canal del punto de venta seleccionado para store pickup.
        // Canales no presenciales y entrega presencial > Según el canal del usuario
        System.debug('GetOrderInvoicingMethod');
        System.debug('GetOrderInvoicingMethod2');

        String channel;
        Order order = [
            SELECT Id,
                Delivery_Method__c,
                OriginStoreLocation__r.Channel__c,
                OriginStoreLocation__r.BillingMode__c,
                OriginStoreLocation__r.PaymentChannel__c,
                PickUpStoreLocation__r.BillingMode__c,
                PickUpStoreLocation__r.Name
            FROM Order
            WHERE Id =: orderId LIMIT 1];

        String delivery = order.Delivery_Method__c;
        String canality = order.OriginStoreLocation__r.Channel__c;
        // String originBillingMode = order.OriginStoreLocation__r.Channel_Type_3__c;
        // String pickupBillingMode = order.PickUpStoreLocation__r.Channel_Type_3__c;

        System.debug('delivery ' + delivery);
        System.debug('canality ' + canality);
        String billingMode = 'Fiscal';

        if(delivery == 'Delivery'){
            // Delivery_Invoicing_Type__c deliveryInvoicingType = Delivery_Invoicing_Type__c.getInstance();
            // String valueDeliveryInvoicingType= Integer.valueOf(deliveryInvoicingType.Delivery_Invoicing_Type__c);

            billingMode = 'Electronico';
        } else {
            if(canality != 'Físico' && delivery == 'Store Pick Up'){
                // Canales no presenciales  y entrega store pickup > según el del punto de venta seleccionado para store pickup.
                billingMode = order.PickUpStoreLocation__r.BillingMode__c;

                if(billingMode == null){
                    throw new FuncException('El Store Location (PickUpStore) \'' + order.PickUpStoreLocation__r.Name + '\' no tiene configurado BillingMode__c.');
                }

            } else {
                // sino segun el del usuario logeado
                vlocity_cmt__BusinessSite__c storeLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());
                Id storeLocationId = storeLocation.Id;
                billingMode = storeLocation.BillingMode__c;

                if(billingMode == null){
                    throw new FuncException('El Store Location (del usuario logeado) \'' + storeLocation.Name + '\' no tiene configurado BillingMode__c.');
                }
            }

        }
        System.debug('billing mode:' + billingMode);
        return billingMode;
   }
}