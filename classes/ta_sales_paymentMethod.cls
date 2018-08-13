global with sharing class ta_sales_paymentMethod implements vlocity_cmt.VlocityOpenInterface{
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        System.debug('ta_sales_paymentMethod');
        if(methodName.equals('GetPaymentMethods')){
            getPaymentMethods(input, outMap, options);
        }
        if(methodName.equals('getPaymentMethodsByChannel')){
            getPaymentMethodsByChannel(input, outMap, options);
        }
        if(methodName.equals('getPaymentMethodsWithCreditDiscount')){
            getPaymentMethodsWithCreditDiscount(input, outMap, options);
        }
        if(methodName.equals('GetLineNumberFromAssetId')){
            getLineNumberFromAssetId(input, outMap, options);
        }
        if(methodName.equals('getPaymentTypes')){
            getPaymentTypes(input, outMap, options);
        }
        if(methodName.equals('getPaymentMethodQuantity')){
            getPaymentMethodQuantity(outMap, options);
        }
        if(methodName.equals('getExistingPaymentMethod')){
            getExistingPaymentMethod(input, outMap, options);
        }
        if(methodName.equals('getPaymentMethodFromOrder')){
            getPaymentMethodFromOrder(outMap, options);
        }
        if (methodName.equals('UpdateBillingCycleAndCheckIfShow')) {
            UpdateBillingCycleAndCheckIfShow(input, outMap, options);
        }
        if (methodName.equals('deletePaymentAdjustmentsFromOrder')) {
            deletePaymentAdjustmentsFromOrder(outMap, options);
        }
        if (methodName.equals('savePaymentAdjustments')) {
            savePaymentAdjustments(outMap, options);
        }
        if (methodName.equals('getBillingCycleShow')) {
            getBillingCycleShow(input,outMap, options);
        }
        if (methodName.equals('UpdateBillingCycleValue')) {
            UpdateBillingCycleValue(input, outMap, options);
        }
        if (methodName.equals('GetPaymentAdjustmentsWithCFT')) {
            GetPaymentAdjustmentsWithCFT(input, outMap, options);
        }

        return false;
    }

    public void getPaymentMethodsByChannel(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        System.debug('getPaymentMethodsByChannel');
        Map<String, List<Map<String, String>>> mediosMap = new Map<String, List<Map<String, String>>>();
        List<PaymentMethodType__c> types = [SELECT Name, Efectivo__c, Tarjeta__c, DebitoProxFactura__c, Tarjeta_Debito__c FROM PaymentMethodType__c];
        for(PaymentMethodType__c payType: types){
            List<Map<String, String>> tempList = new List<Map<String, String>>();
            if(payType.Efectivo__c){
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('name', 'Efectivo');
                tempMap.put('value', 'Efectivo');
                tempList.add(tempMap);
            }
            if(payType.Tarjeta__c){
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('name', 'Tarjeta de Credito');
                tempMap.put('value', 'Tarjeta de Credito');
                tempList.add(tempMap);
            }
            if(payType.DebitoProxFactura__c){
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('name', 'Debito a Proxima Factura');
                tempMap.put('value', 'Debito a Proxima Factura');
                tempList.add(tempMap);
            }
            if(payType.Tarjeta_Debito__c){
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('name', 'Tarjeta de Debito');
                tempMap.put('value', 'Tarjeta de Debito');
                tempList.add(tempMap);
            }
            mediosMap.put(payType.Name, tempList);
        }
        outMap.put('dependency', mediosMap);
    }

    public void getPaymentMethods(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
            System.debug('Get Payment Methods');
            System.debug('INPUT: ' + input);
            Boolean creditDiscountPaymentMethod = false;
            if (input.get('CreditDiscountPaymentMethod') != null)
                creditDiscountPaymentMethod = (Boolean) input.get('CreditDiscountPaymentMethod');

            System.debug(userinfo.getUserId());
            vlocity_cmt__BusinessSite__c storeLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());
            System.debug(storeLocation);
            String channel = storeLocation.Channel_Type__c;
            System.debug(channel);
          //  List<PaymentMethodType__c> types = [SELECT Name, Efectivo__c, Tarjeta__c, DebitoProxFactura__c, Tarjeta_Debito__c FROM PaymentMethodType__c WHERE Name = :channel];
          //  system.debug('Method types = ' + types);
          //  PaymentMethodType__c payType = types[0];
            List<Map<String, String>> tempList = new List<Map<String, String>>();
            // INI MOD - GS - PFTA-7435
            String idOrder = (String) input.get('IdOrder');

            System.debug('ID ORDER: ' + idOrder);

            if(idOrder == null){
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('name', 'Efectivo');
                tempMap.put('value', 'Efectivo');
                tempList.add(tempMap);
                tempMap = new Map<String, String>();
                tempMap.put('name', 'Tarjeta de Credito');
                tempMap.put('value', 'Tarjeta de Credito');
                tempList.add(tempMap);
                tempMap = new Map<String, String>();
                tempMap.put('name', 'Debito a Proxima Factura');
                tempMap.put('value', 'Debito a Proxima Factura');
                tempList.add(tempMap);
                tempMap = new Map<String, String>();
                tempMap.put('name', 'Descuento de Saldo');
                tempMap.put('value', 'Descuento de Saldo');
                tempList.add(tempMap);
                tempMap = new Map<String, String>();
                tempMap.put('name', 'Tarjeta de Debito');
                tempMap.put('value', 'Tarjeta de Debito');
                tempList.add(tempMap);
            }else{
                Order ord = new Order();
                //DA-17/01/2019-PFTA-6885: Agrego Gestion__c
                ord = [SELECT Id, Delivery_Method__c, Gestion__c FROM Order WHERE Id = :idOrder];
                Boolean normal = true;
                if(ord.Delivery_Method__c == 'Delivery'){
                    if(channel == 'Oficinas Comerciales'){
                        normal = false;
                    }
                }

                Map<String, Object> validateChannelDelivery = new Map<String, Object>();
                validateChannelDelivery.put('MetodoEntrega', ord.Delivery_Method__c);
                validateChannelDelivery.put('Canal', channel);
                system.debug('validate channel === ' + validateChannelDelivery);
               for ( vlocity_cmt__CalculationMatrixRow__c cmr : [select id, name, vlocity_cmt__InputData__c, vlocity_cmt__OutputData__c
                              from vlocity_cmt__CalculationMatrixRow__c where vlocity_cmt__CalculationMatrixVersionId__r.vlocity_cmt__CalculationMatrixId__r.name = 'PaymentDeliveryMethod' AND name != 'Header'] )
                       {
                         Map<String, Object> inputdata = (Map<String, Object>) JSON.deserializeUntyped(cmr.vlocity_cmt__InputData__c);
                         Map<String, Object> outputdata = (Map<String, Object>) JSON.deserializeUntyped(cmr.vlocity_cmt__OutputData__c);
                         if(inputdata == validateChannelDelivery){
                             String efectivo   = (String)outputdata.get('Efectivo');
                             String descuentoSaldo   = (String)outputdata.get('DescuentoSaldo');
                             String debitoProxFactura  = (String)outputdata.get('DebitoProxFactura');
                             String tarjetaDebito   = (String)outputdata.get('TarjetaDebito');
                             String tarjetaCredito   = (String)outputdata.get('TarjetaCredito');
                             if(efectivo == 'true'){
                               Map<String, String> tempMap = new Map<String, String>();
                               //tempMap.put('name', '1001');
                               tempMap.put('name', 'Efectivo');
                               tempMap.put('value', 'Efectivo');
                               if(normal){
                                   tempList.add(tempMap);
                               }
                               // INI MOD - GS - PFTA-7435

                             }
                             if(tarjetaCredito == 'true'){
                               Map<String, String> tempMap = new Map<String, String>();
                               //tempMap.put('name', '2001');
                               tempMap.put('name', 'Tarjeta de Credito');
                               tempMap.put('value', 'Tarjeta de Credito');
                               if(normal){
                                   tempList.add(tempMap);
                               }
                               // INI MOD - GS - PFTA-7435

                               // FIN MOD - GS - PFTA-7435
                             }
                             if(tarjetaDebito == 'true'){
                               Map<String, String> tempMap = new Map<String, String>();
                               //tempMap.put('name', '2001');
                               tempMap.put('name', 'Tarjeta de Debito');
                               tempMap.put('value', 'Tarjeta de Debito');
                               if(normal){
                                   tempList.add(tempMap);
                               }
                               // INI MOD - GS - PFTA-7435

                               // FIN MOD - GS - PFTA-7435
                             }
                             if(debitoProxFactura == 'true' && ord.Gestion__c != 'Recarga'){
                               Map<String, String> tempMap = new Map<String, String>();
                               //tempMap.put('name', '1201');
                               tempMap.put('name', 'Debito a Proxima Factura');
                               tempMap.put('value', 'Debito a Proxima Factura');
                               if(normal){
                                   tempList.add(tempMap);
                               }
                           }
                           if(descuentoSaldo == 'true' && creditDiscountPaymentMethod){
                             Map<String, String> tempMap = new Map<String, String>();
                             //tempMap.put('name', '9999');
                             tempMap.put('name', 'Descuento de Saldo');
                             tempMap.put('value', 'Descuento de Saldo');
                             if(normal){
                                 tempList.add(tempMap);
                             }
                             // INI MOD - GS - PFTA-7435

                             // FIN MOD - GS - PFTA-7435
                           }

                           }

                     }
            }
            outMap.put('options', tempList);
        }


    public void getPaymentMethodsWithCreditDiscount(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        System.debug('Get Payment Methods With Credit Discount');
        vlocity_cmt__BusinessSite__c storeLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());
        String channel = storeLocation.Channel_Type__c;
        List<PaymentMethodType__c> types = [SELECT Name, Efectivo__c, Tarjeta__c, DebitoProxFactura__c, Tarjeta_Debito__c FROM PaymentMethodType__c WHERE Name = :channel];
        PaymentMethodType__c payType = types[0];
        List<Map<String, String>> tempList = new List<Map<String, String>>();
        if(payType.Efectivo__c ){
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', '1001');
            tempMap.put('value', 'Efectivo');
            tempList.add(tempMap);
        }
        if(payType.Tarjeta__c){
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', '2001');
            tempMap.put('value', 'Tarjeta de Credito');
            tempList.add(tempMap);
        }
        if(payType.DebitoProxFactura__c){
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', '1201');
            tempMap.put('value', 'Debito a Proxima Factura');
            tempList.add(tempMap);
        }
        if(payType.Tarjeta_Debito__c){
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', '4001');
            tempMap.put('value', 'Tarjeta de Debito');
            tempList.add(tempMap);
        }
        Map<String, String> tempMap = new Map<String, String>();
        tempMap.put('name', '9999');
        tempMap.put('value', 'Descuento de Saldo');
        tempList.add(tempMap);

        outMap.put('options', tempList);
    }

    public void getLineNumberFromAssetId(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('Get Line Number From Asset Id');

        String assetId = (String) options.get('assetId');
        System.debug('Asset Id: ' + assetId);
        Asset asset = [SELECT Id, MSISDN__c FROM Asset WHERE Id =: assetId LIMIT 1];

        Map<String, Object> tempMap = new Map<String, Object>();
        tempMap.put('identificadorRecurso', asset.MSISDN__c);

        //Dato mock para mock desa01
        //tempMap.put('identificadorRecurso', '1138305304');
        outMap.put('params', tempMap);
    }

    public void getPaymentTypes(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        List<Map<String, String>> tempList = new List<Map<String, String>>();
        Map<String, String> tempMap = new Map<String, String>();
        tempMap.put('name', '9999');
        tempMap.put('value', 'Descuento de Saldo');
        tempList.add(tempMap);

        tempMap.put('name', '9998');
        tempMap.put('value', 'En Factura de Venta');
        tempList.add(tempMap);

        outMap.put('options', tempList);
    }

    public void getPaymentMethodQuantity(Map<String, Object> outMap, Map<String, Object> options){
        System.debug('Get Payment Method Quantity');
        String channel = (String) options.get('channel');
        System.debug(channel);
        List<PaymentMethodType__c> types = [SELECT PaymentMethodQuantity__c FROM PaymentMethodType__c WHERE Name = :channel];
        if(types.size() > 0)
        {
            String PaymentMethodQuantity = String.valueOf(types[0].PaymentMethodQuantity__c);
            outMap.put('PaymentMethodQuantity', PaymentMethodQuantity);
        }
        else
            outMap.put('error', 'No se obtuvo límite de medios de pagos posibles para combinación.');
    }

    public void getExistingPaymentMethod(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){

        List<Object> paymentMethods = new List<Object>();
        Boolean validateSuccess = true;
        String totalInstallments;
        String expirationYear;
        String expirationMonth;
        String last4Numbers;
        String cardNumber;
        String cardEntity;
        String bankEntity;
        String cardOwner;
        String amountInstallmentPaymentMethod;
        String amountPaymentMethod;
        String promotionId;
        String documentType;
        String documentNumber;
        String assetId;
        Map<String, Object> paramsMap = new Map<String, Object>();
        Map<String, Object> paymentMethod;
        List<Map<String, Object>> retPaymentMethods = new List<Map<String, Object>> ();
        System.debug('getExistingPaymentMethod');
        try{
            String accountId = (String) options.get('AccountId');
            System.debug(accountId);
            String orderId = (String) options.get('OrderId');
            String userChannel ;
            vlocity_cmt__BusinessSite__c storeLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());
            //String userChannel = storeLocation.Channel_Type__c;
            if(storeLocation.Channel__c != null)
            userChannel = storeLocation.Channel__c;
            paymentMethod = (Map<String, Object>) input.get('SelectPaymentMethodsStep');
            System.debug(paymentMethod);
            Boolean isNewPackExistingLine = (Boolean) input.get('IsNewPackExistingLine');
            System.debug('isNewPackExistingLine: ' + isNewPackExistingLine);
            //Trabajo siempre con una lista de medios de pago
            if(paymentMethod == null && isNewPackExistingLine == true){
                Map<String, Object> billingOrder = (Map<String, Object>) input.get('BillingOrder');
                Decimal billingOrderTotal = (Decimal) billingOrder.get('OrderTotal');
                Map<String, Object> tempMap = new Map<String, Object>();
                System.debug(billingOrderTotal);
                tempMap.put('Amount', billingOrderTotal);
                tempMap.put('PaymentMethodRadio', 'Descuento de Saldo');
                paymentMethods.add(tempMap);
            } else if(paymentMethod.get('PaymentMethods') instanceof List<Object>) {
                paymentMethods = (List<Object>) paymentMethod.get('PaymentMethods');
            } else if(paymentMethod.get('PaymentMethods') instanceof Map<String, Object>){
                Map<String, Object> tempMap = (Map<String, Object>) paymentMethod.get('PaymentMethods');
                paymentMethods.add(tempMap);
            }

            System.debug(paymentMethods);
            System.debug(paymentMethods.size());
            if(paymentMethods.size() == 0)
                throw new FuncException('No se ingresaron los medios de pago');

            //Recorro los medios de pago seleccionados y consulto si ya existen
            for(Object objSelectedPaymentMethod : paymentMethods){
                last4Numbers = '';
                expirationMonth = '';
                expirationYear = '';
                totalInstallments = '';
                cardEntity = '';
                bankEntity = '';
                cardOwner = '';
                amountPaymentMethod = '';
                amountInstallmentPaymentMethod = '';
                promotionId = '';
                documentType = '';
                documentNumber = '';
                cardNumber = '';

                Map<String, Object> selectedPaymentMethod = (Map<String, Object>) objSelectedPaymentMethod;

                amountPaymentMethod = String.ValueOf(selectedPaymentMethod.get('Amount'));
                String methodType = (String) selectedPaymentMethod.get('PaymentMethodRadio');
                if (methodType == 'Efectivo')
                    methodType = '1001';
                else if (methodType == 'Descuento de Saldo')
                    methodType = '9998';
                else if (methodType == 'Tarjeta de Credito')
                    methodType = '2001';
                else if (methodType == 'Debito a Proxima Factura')
                    methodType = '1201';
                else if (methodType == 'Tarjeta de Debito')
                    methodType = '4002';

                //CAMBIAR METHOD TYPE TARJETA DE DEBITO PARA 4001 - AM 29/03/2018

                if(methodType == '9998'){
                    System.debug('Get Line Number From Asset Id');
                    assetId = (String) input.get('assetId');
                    if(assetId == ''){
                        assetId = (String) options.get('assetId');
                    }
                    System.debug('Asset Id: ' + assetId);
                    Asset asset = [SELECT Id, MSISDN__c FROM Asset WHERE Id =: assetId LIMIT 1];
                    System.debug(' Asset Line Number: ' + asset);
                    //Boolean validate = ValidateCheckAvailableCredit(asset.MSISDN__c);
                    /*NRO LINEA MOCK S439 */
                    //validateSuccess = ValidateCheckAvailableCredit('1138305304', amountPaymentMethod);
                    validateSuccess = ValidateCheckAvailableCredit(asset.MSISDN__c, amountPaymentMethod);
                }

                //Si hay datos de tarjeta de crédito, los obtengo
                if(selectedPaymentMethod.get('CreditCardData') != null){
                    Map<String, Object> creditCardData = (Map<String, Object>) selectedPaymentMethod.get('CreditCardData');

                    System.debug('CreditCardData:userChannel ');
                    System.debug(userChannel);
                    if(userChannel != 'Físico'){
                        //String expirationDate = (String) creditCardData.get('ExpirationDate');
                        expirationMonth = String.ValueOf(creditCardData.get('ExpirationMonth'));
                        System.debug(expirationMonth);
                        expirationYear = String.ValueOf(creditCardData.get('ExpirationYear'));
                        System.debug(expirationYear);
                        cardNumber = String.ValueOf(creditCardData.get('CardNumber'));
                        System.debug(cardNumber);
                        last4Numbers = extractLast4(cardNumber);
                        System.debug(last4Numbers);
                    }

                    cardOwner = (String) creditCardData.get('CardOwner');
                    totalInstallments = (String) creditCardData.get('Installments');
                    cardEntity = (String) creditCardData.get('CardEntity');
                    bankEntity = (String) creditCardData.get('CardBankingEntity');
                    amountInstallmentPaymentMethod = String.ValueOf(creditCardData.get('AmountInstallments'));
                    promotionId = (String) creditCardData.get('PromotionId');
                    documentType = (String) creditCardData.get('DocumentType');
                    documentNumber = (String) creditCardData.get('DocumentNumber');
                }

                if(selectedPaymentMethod.get('DebitCardData') != null){
                    Map<String, Object> debitCardData = (Map<String, Object>) selectedPaymentMethod.get('DebitCardData');

                    System.debug('DebitCardData:userChannel ');
                    System.debug(userChannel);
                    if(userChannel != 'Físico'){
                        expirationMonth = String.ValueOf(debitCardData.get('ExpirationMonth'));
                        System.debug(expirationMonth);
                        expirationYear = String.ValueOf(debitCardData.get('ExpirationYear'));
                        System.debug(expirationYear);
                        cardNumber = String.ValueOf(debitCardData.get('CardNumber'));
                        System.debug(cardNumber);
                        last4Numbers = extractLast4(cardNumber);
                        System.debug(last4Numbers);
                    }

                    cardOwner = (String) debitCardData.get('CardOwner');
                    totalInstallments = (String) debitCardData.get('Installments');
                    cardEntity = (String) debitCardData.get('CardEntity');
                    bankEntity = (String) debitCardData.get('CardBankingEntity');
                    amountInstallmentPaymentMethod = String.ValueOf(debitCardData.get('AmountInstallments'));
                    promotionId = (String) debitCardData.get('PromotionId');
                    documentType = (String) debitCardData.get('DocumentType');
                    documentNumber = (String) debitCardData.get('DocumentNumber');
                }

                if(selectedPaymentMethod.get('DPFData') != null){
                    Map<String, Object> dpfData = (Map<String, Object>) selectedPaymentMethod.get('DPFData');
                    totalInstallments = (String) dpfData.get('DPFInstallments');
                    amountInstallmentPaymentMethod = String.ValueOf(dpfData.get('AmountInstallments'));
                    promotionId = (String) dpfData.get('PromotionId');
                }
                System.debug('last4Numbers');
                System.debug(last4Numbers);
                //Verifico la existencia del medio de pago
                List<vlocity_cmt__PaymentMethod__c> listExistingPaymentMethod =
                        [SELECT Id,
                                vlocity_cmt__Last4Numbers__c,
                                vlocity_cmt__MethodType__c
                           FROM vlocity_cmt__PaymentMethod__c
                          WHERE vlocity_cmt__MethodType__c = :methodType
                            AND vlocity_cmt__AccountId__c = :accountId
                            AND ((vlocity_cmt__Last4Numbers__c = NULL AND vlocity_cmt__MethodType__c != '2001' AND vlocity_cmt__MethodType__c != '4002') OR
                                    (vlocity_cmt__Last4Numbers__c != NULL AND
                                    vlocity_cmt__Last4Numbers__c = :last4Numbers)
                                )];

                System.debug('listExistingPaymentMethod');
                System.debug(listExistingPaymentMethod);
                //Si existe algún medio de pago, agrego el ID a la lista a retornar
                if(listExistingPaymentMethod.size() > 0){
                    Map<String, Object> existingPaymentMethod = new Map<String, Object>();

                    existingPaymentMethod.put('Id', listExistingPaymentMethod[0].Id);
                    existingPaymentMethod.put('AccountId', accountId);
                    existingPaymentMethod.put('OrderId', orderId);
                    existingPaymentMethod.put('TotalInstallments', totalInstallments);
                    existingPaymentMethod.put('Amount', amountPaymentMethod);
                    existingPaymentMethod.put('AmountInstallments', amountInstallmentPaymentMethod);
                    if(!String.isBlank(promotionId)){
                        existingPaymentMethod.put('PromotionId', promotionId);
                    }

                    System.debug('El medio de pago ya existe: ' + listExistingPaymentMethod[0]);

                    retPaymentMethods.add(existingPaymentMethod);
                } else{
                //Si no existe ningún medio de pago, lo creo con los valores recibidos, y agrego el ID a la lista a retornar
                    Vlocity_cmt__PaymentMethod__c newPaymentMethod =
                        createPaymentMethod(accountId, cardNumber, methodType, expirationYear, expirationMonth, cardEntity, bankEntity, cardOwner, documentType, documentNumber, last4Numbers);
                    Map<String, Object> newMapPaymentMethod = new Map<String, Object>();

                    newMapPaymentMethod.put('Id', newPaymentMethod.Id);
                    newMapPaymentMethod.put('AccountId', accountId);
                    newMapPaymentMethod.put('OrderId', orderId);
                    newMapPaymentMethod.put('TotalInstallments', totalInstallments);
                    newMapPaymentMethod.put('Amount', amountPaymentMethod);
                    newMapPaymentMethod.put('AmountInstallments', amountInstallmentPaymentMethod);
                    if(!String.isBlank(promotionId)){
                        newMapPaymentMethod.put('PromotionId', promotionId);
                    }
                    retPaymentMethods.add(newMapPaymentMethod);
                }
            }

            outMap.put('PaymentMethodWithCreditDiscountError', validateSuccess);
            outMap.put('ValidPaymentMethods', retPaymentMethods);

        } catch(FuncException fex){
            outMap.put('error', 'Error al validar medios de pago: ' + fex.getMessage());
        } catch(Exception ex){
            outMap.put('error', ex.getMessage());
            outMap.put('errorStackTrace', ex.getStackTraceString());
        }
    }

    @RemoteAction
    global static Boolean ValidateCheckAvailableCredit(string lineNumber, String amountPaymentMethod){
        try{
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            Map<String, Object> params = new Map<String, Object>();
            params.put('identificadorRecurso', lineNumber);

            input.put('params', params);

            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod('IFS_S439', input, output, options);
            System.debug(output);

            Map<String, Object> response = (Map<String, Object>) output.get('IPResult');
            System.debug(response);
            Map<String, Object> totalesBalance = (Map<String, Object>) response.get('totalesBalance');
            System.debug(totalesBalance);
            Decimal saldoBalance = Decimal.valueOf((String) totalesBalance.get('saldoBalance'));
            System.debug(saldoBalance);
            Decimal amount = Decimal.valueOf(amountPaymentMethod);

            if(amount > saldoBalance){
                /*Validation not success */
                return false;
            } else {
                /*Validation success */
                return true;

            }
        }catch(DmlException e){
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            return false;
        }
    }

    public static String extractLast4(String ccNumber){
        try{
            // Grabbing total length
            Integer length = ccNumber.length();
            // returning the last 4 digits
            return ccNumber.substring(length-4,length);
        } catch(Exception ex){
            throw new FuncException('Error al obtener los últimos 4 dígitos del número de tarjeta');
        }
    }

    public static vlocity_cmt__PaymentMethod__c createPaymentMethod(String accountId, String creditCardNumber, String methodType, String expirationYear, String expirationMonth, String cardEntity, String bankEntity, String cardHolder, String documentType, String documentNumber){
        try{
            String last4Numbers = extractLast4(creditCardNumber);
            System.debug('last4Numbers: ' + last4Numbers);
            return createPaymentMethod(accountId, creditCardNumber, methodType, expirationYear, expirationMonth, cardEntity, bankEntity, cardHolder, documentType, documentNumber, last4Numbers);
        } catch(Exception ex){
            throw ex;
        }
    }

    public static vlocity_cmt__PaymentMethod__c createPaymentMethod(String accountId, String creditCardNumber, String methodType, String expirationYear, String expirationMonth, String cardEntity, String bankEntity, String cardHolder, String documentType, String documentNumber, String last4Numbers){
        try{
            String cardName = '';
            String bankName = '';
            /*
            if(cardEntity != ''){
                List<FinancialPromotions__c> lstFinancialPromotions = FinancialPromotions__c.getall().values();

                for (FinancialPromotions__c rel : lstFinancialPromotions)
                    if(cardEntity == rel.Creditcard_Type__c)
                        cardName = rel.Creditcard_Name__c;
            }

            if(bankEntity != ''){
                List<ExternalBankEntitiesIds__c> lstBanks = ExternalBankEntitiesIds__c.getAll().values();

                for(ExternalBankEntitiesIds__c itemBank : lstBanks){
                    if(bankEntity == itemBank.BankCode__c)
                        bankName = itemBank.Name;
                }
            }
            */
            System.debug('documentType: ' + documentType);
            System.debug('documentNumber: ' + documentNumber);

            vlocity_cmt__PaymentMethod__c newPaymentMethod = new vlocity_cmt__PaymentMethod__c();

            newPaymentMethod.Vlocity_cmt__AccountId__c = accountId;
            newPaymentMethod.Vlocity_cmt__CardNumber__c = creditCardNumber;
            newPaymentMethod.Vlocity_cmt__MethodType__c = methodType;
            newPaymentMethod.Vlocity_cmt__Last4Numbers__c = last4Numbers;
            newPaymentMethod.Vlocity_cmt__ExpirationMonth__c = expirationMonth;
            newPaymentMethod.Vlocity_cmt__ExpirationYear__c = expirationYear;
            newPaymentMethod.Vlocity_cmt__CardType__c = cardEntity;//cardName;
            newPaymentMethod.BankEntityName__c = bankEntity;//bankName;
            newPaymentMethod.Vlocity_cmt__CardHolderName__c = cardHolder;
            newPaymentMethod.CardHolderDocumentNumber__c = documentNumber;
            newPaymentMethod.CardHolderDocumentType__c = documentType;

            System.debug('Inserto el medio de pago: ' + newPaymentMethod);

            insert newPaymentMethod;

            return newPaymentMethod;
        } catch(Exception ex){
            throw new FuncException('Ocurrió un error al crear el medio de pago: ' + ex.getMessage());
        }
    }

    public void getPaymentMethodFromOrder(Map<String, Object> outMap, Map<String, Object> options){
        System.debug('getPaymentMethodFromOrder');
        String accountId = (String) options.get('accountId');
        String idOrder = (String) options.get('IdOrder');
        List<vlocity_cmt__PaymentAdjustment__c> paymentAdjustmentsList = [SELECT vlocity_cmt__PaymentMethodId__c, vlocity_cmt__TotalInstallments__c FROM vlocity_cmt__PaymentAdjustment__c WHERE vlocity_cmt__AccountId__c = :accountId AND Order__c = :idOrder];
        //System.debug('paymentAdjustmentsList: ' + paymentAdjustmentsList);
        Set<Id> oiIds = new Set<Id>();
        for(vlocity_cmt__PaymentAdjustment__c paymentAdjustment : paymentAdjustmentsList){
            oiIds.add(paymentAdjustment.vlocity_cmt__PaymentMethodId__c);
        }
        List<vlocity_cmt__PaymentMethod__c> paymentMethodList = [SELECT Id, Vlocity_cmt__MethodType__c, BankEntityName__c, Security__c, vlocity_cmt__CardHolderName__c, Vlocity_cmt__CardNumber__c, vlocity_cmt__CardType__c, Vlocity_cmt__ExpirationMonth__c, Vlocity_cmt__ExpirationYear__c FROM vlocity_cmt__PaymentMethod__c WHERE Id in :oiIds AND vlocity_cmt__IsActive__c = true];
        //System.debug('paymentMethodList: ' + paymentMethodList);
        Map<String, String> methodTypes = new Map<String, String>();
        Map<String, String> bankEntityNames = new Map<String, String>();
        Map<String, Decimal> securityCodes = new Map<String, Decimal>();
        Map<String, String> cardHolderNames = new Map<String, String>();
        Map<String, String> cardNumbers = new Map<String, String>();
        Map<String, String> cardTypes = new Map<String, String>();
        Map<String, String> expirationDates = new Map<String, String>();
        for(vlocity_cmt__PaymentMethod__c paymentMethod : paymentMethodList){
            methodTypes.put(paymentMethod.Id, paymentMethod.Vlocity_cmt__MethodType__c);
            bankEntityNames.put(paymentMethod.Id, paymentMethod.BankEntityName__c);
            securityCodes.put(paymentMethod.Id, paymentMethod.Security__c);
            cardHolderNames.put(paymentMethod.Id, paymentMethod.vlocity_cmt__CardHolderName__c);
            cardNumbers.put(paymentMethod.Id, paymentMethod.Vlocity_cmt__CardNumber__c);
            cardTypes.put(paymentMethod.Id, paymentMethod.vlocity_cmt__CardType__c);
            expirationDates.put(paymentMethod.Id, paymentMethod.Vlocity_cmt__ExpirationMonth__c + paymentMethod.Vlocity_cmt__ExpirationYear__c);
        }
        List<Object> paymentMethodsNodeList = new List<Object>();
        for(vlocity_cmt__PaymentAdjustment__c paymentAdjustment : paymentAdjustmentsList)
        {
            String mp = (String) methodTypes.get(paymentAdjustment.vlocity_cmt__PaymentMethodId__c);
            Map<String,Object> paymentMethodNode = new Map<String,Object>();

            if (mp == '1001')
                mp = 'Efectivo';
            else
            if (mp == '9999')
                mp = 'Descuento de Saldo';
            if (mp == '2001')
            {
                //Credit Card Data
                mp = 'Tarjeta de Credito';
                Map<String,Object> creditCardData = new Map<String,Object>();
                creditCardData.put('CardBankingEntity',(String) bankEntityNames.get(paymentAdjustment.vlocity_cmt__PaymentMethodId__c));
                creditCardData.put('CardEntity',(String) cardTypes.get(paymentAdjustment.vlocity_cmt__PaymentMethodId__c));
                //creditCardData.put('BankCardKeyFormula',);
                if (paymentAdjustment.vlocity_cmt__TotalInstallments__c != null)
                    creditCardData.put('Installments',String.ValueOf(paymentAdjustment.vlocity_cmt__TotalInstallments__c));
                //creditCardData.put('PromotionalCode',);
                creditCardData.put('CardNumber',(String) cardNumbers.get(paymentAdjustment.vlocity_cmt__PaymentMethodId__c));
                creditCardData.put('ExpirationDate',(String) expirationDates.get(paymentAdjustment.vlocity_cmt__PaymentMethodId__c));
                if (securityCodes.get(paymentAdjustment.vlocity_cmt__PaymentMethodId__c) != null)
                    creditCardData.put('SecurityCode',(Decimal)securityCodes.get(paymentAdjustment.vlocity_cmt__PaymentMethodId__c));
                //creditCardData.put('DocumentType',);
                //creditCardData.put('DocumentNumber',);
                creditCardData.put('CardOwner',(String) cardHolderNames.get(paymentAdjustment.vlocity_cmt__PaymentMethodId__c));
                creditCardData.put('BankCardKeyFormula', (String) bankEntityNames.get(paymentAdjustment.vlocity_cmt__PaymentMethodId__c) + '_' + (String) cardTypes.get(paymentAdjustment.vlocity_cmt__PaymentMethodId__c));
                paymentMethodNode.put('CreditCardData',creditCardData);
            }
            else
            if (mp == '1201')
            {
                //DPF
                mp = 'Debito a Proxima Factura';
                Map<String,Object> dPFData = new Map<String,Object>();
                if (paymentAdjustment.vlocity_cmt__TotalInstallments__c != null)
                    dPFData.put('DPFInstallments',paymentAdjustment.vlocity_cmt__TotalInstallments__c);
                //dPFData.put('ConditionalCFT',);
                paymentMethodNode.put('DPFData',dPFData);
            }

            paymentMethodNode.put('PaymentMethodRadio',mp);
            paymentMethodsNodeList.add(paymentMethodNode);
        }

        Map<String,Object> paymentMethodResultNode = new Map<String,Object>();
        paymentMethodResultNode.put('PaymentMethods',paymentMethodsNodeList);
        outMap.put('SelectPaymentMethodsStep', paymentMethodResultNode);
        System.debug('outMap: ' + outMap);
        System.debug('JSON: ' + JSON.serialize(outMap));
    }

    public void UpdateBillingCycleAndCheckIfShow(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('Update Billing Cycle And Check If Show');

        String idOrder = (String) options.get('IdOrder');
        String billingCycleValue = (String) input.get('BillingCycleValue');

        Order order = [SELECT Id, Account.CreatedDate FROM Order WHERE Id =: idOrder LIMIT 1];

        Boolean showBillingCycle = true;
        if (order.Account.CreatedDate.isSameDay(Datetime.now()) && OrdersUtilMethods.OrderItemsAreAllPrepaid(idOrder))
            showBillingCycle = false;

        outMap.put('BillingCycleShow', showBillingCycle);

        if (billingCycleValue != null && order != null)
            order.Billing_Cycles__c = billingCycleValue;

        update order;
    }
 public void UpdateBillingCycleValue(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('UpdateBillingCycleValue');

        String idOrder = (String) options.get('IdOrder');
        String billingCycleValue = (String) input.get('BillingCycleValue');

        Order order = [SELECT Id, Account.CreatedDate FROM Order WHERE Id =: idOrder LIMIT 1];

        /*Boolean showBillingCycle = true;
        if (order.Account.CreatedDate.isSameDay(Datetime.now()) && OrdersUtilMethods.OrderItemsAreAllPrepaid(idOrder))
            showBillingCycle = false;

        outMap.put('BillingCycleShow', showBillingCycle);*/

        if (billingCycleValue != null && order != null)
            order.Billing_Cycles__c = billingCycleValue;

        update order;
    }

    public void getBillingCycleShow(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('UpdateBillingCycleShow || UpdateBillingCycleValue');

        String idOrder = (String) options.get('IdOrder');
        String billingCycleValue = (String) input.get('BillingCycleValue');

        Order order = [SELECT Id, Account.CreatedDate FROM Order WHERE Id =: idOrder LIMIT 1];

        Boolean showBillingCycle = true;
        if (order.Account.CreatedDate.isSameDay(Datetime.now()) && OrdersUtilMethods.OrderItemsAreAllPrepaid(idOrder))
            showBillingCycle = false;

        outMap.put('BillingCycleShow', showBillingCycle);

        /*if (billingCycleValue != null && order != null)
            order.Billing_Cycles__c = billingCycleValue;

        update order;*/
    }
    public void deletePaymentAdjustmentsFromOrder(Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('deletePaymentAdjustmentsFromOrder');
        String idOrder = (String) options.get('IdOrder');
        List<vlocity_cmt__PaymentAdjustment__c> paymentAdjustmentsList = [SELECT Id FROM vlocity_cmt__PaymentAdjustment__c WHERE Order__c = :idOrder];
        delete paymentAdjustmentsList;
    }

    public void savePaymentAdjustments(Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('savePaymentAdjustments');
        List<Object> paymentMethods = new List<Object>();
        if(options.get('ValidPaymentMethods') instanceof List<Object>) {
                paymentMethods = (List<Object>) options.get('ValidPaymentMethods');
            } else if(options.get('ValidPaymentMethods') instanceof Map<String, Object>){
                Map<String, Object> tempMap = (Map<String, Object>) options.get('ValidPaymentMethods');
                paymentMethods.add(tempMap);
            }
        System.debug('paymentMethods: ' + paymentMethods);
        List<vlocity_cmt__PaymentAdjustment__c> paymentAdjustmentsList = new List<vlocity_cmt__PaymentAdjustment__c>();
        for(Object mapObj : paymentMethods)
        {
            Map<String, Object> mapMap = (Map<String, Object>) mapObj;
            System.debug('mapMap: ' + mapMap);
            vlocity_cmt__PaymentAdjustment__c payment = new vlocity_cmt__PaymentAdjustment__c();
            payment.vlocity_cmt__AccountId__c = (String) mapMap.get('AccountId');
            payment.vlocity_cmt__PaymentMethodId__c = (String) mapMap.get('Id');
            payment.Order__c = (String) mapMap.get('OrderId');
            String aux = (String) mapMap.get('TotalInstallments');
            if (!String.isBlank(aux))
                payment.vlocity_cmt__TotalInstallments__c = Decimal.ValueOf(aux);

            String auxAmount = (String) mapMap.get('Amount');
            if (!String.isBlank(auxAmount))
                payment.vlocity_cmt__Amount__c = Decimal.ValueOf(auxAmount);

            String auxAmountInstallments = (String) mapMap.get('AmountInstallments');
            if (!String.isBlank(auxAmountInstallments))
                payment.vlocity_cmt__InstallmentAmount__c = Decimal.ValueOf(auxAmountInstallments);

            String auxPromotionId = (String) mapMap.get('PromotionId');
            if (!String.isBlank(auxPromotionId))
                payment.Financial_Promotion__c = auxPromotionId;


            System.debug('payment: ' + payment);
            paymentAdjustmentsList.add(payment);
        }
        System.debug('paymentAdjustmentsList: ' + paymentAdjustmentsList);
        insert paymentAdjustmentsList;
    }

    public void GetPaymentAdjustmentsWithCFT(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        System.debug('GetPaymentAdjustmentsWithCFT');
        String OrderId = String.valueOf(options.get('OrderId'));
        // System.debug('OrderId: ' + OrderId);

        List<vlocity_cmt__PaymentAdjustment__c> payments = [
            SELECT
                Id,
                vlocity_cmt__Amount__c,
                vlocity_cmt__InstallmentAmount__c,
                vlocity_cmt__Method__c
            FROM vlocity_cmt__PaymentAdjustment__c
            WHERE
                Order__c = :OrderId
                AND Financial_Promotion__r.Percentage__c > 0
        ];
        // System.debug(payments);
        outMap.put('data', payments);
    }
}