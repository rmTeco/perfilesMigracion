global with sharing class IFS_S348 implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('PurchaseIntegration')){
                PurchaseIntegration(inputMap, outMap, options);
            }
            
            result = false;  
        } 
        catch(Exception e)
        {
            System.debug('IFS_S348:invokeMethod -> exception: '+e+e.getStackTraceString());
            throw e; 
            //result = false;
        }
        return result;
    }
    
    global static void PurchaseIntegration(map<String,Object> input, map<String,Object> output, map<String,Object> options){
        List <vlocity_cmt__PaymentAdjustment__c> payments = new List <vlocity_cmt__PaymentAdjustment__c>();
        List <Order> orderList = new List <Order>();
        List <Account> accountList = new List <Account>();
        List <Map<String,Object>> listaInformacionPagos = new List <Map<String,Object>>();
        List <Map<String,Object>> listaItemsFactura = new List <Map<String,Object>>();
        Map<String,Object> procesarPagosPeticion = new Map<String,Object>();
        Map<String,Object> body = new Map<String,Object>();
        Map<String,Object> request = new Map<String,Object>();
        Map<String,Object> PaymentMethod = new Map<String,Object>();
        Map<String,Object> ReferenceMap = new Map<String,Object>();
        List<Object> PaymentMethods = new List<Object>();
        Order order = new Order();
        Account account = new Account();
        PaymentMethod=(map<String,Object>)input.get('SelectPaymentMethodsStep');
        PaymentMethods=(List<Object>)PaymentMethod.get('PaymentMethods');
        System.debug('PaymentMethods: '+PaymentMethods);
        String orderID = (String)input.get('IdOrder');
        String ipOriginValue = (String)input.get('ipOrigin');
        System.debug('ipOriginValue: '+ipOriginValue);
        String accountID = (String)input.get('accountId');
        Boolean getErrors = false;
        
        payments = [select id, vlocity_cmt__PaymentMethodId__r.id, 
                    vlocity_cmt__PaymentMethodId__r.BankEntityName__c, 
                    vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardHolderName__c, 
                    vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c, 
                    vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationYear__c, 
                    vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c, 
                    vlocity_cmt__PaymentMethodId__r.vlocity_cmt__IsPrimary__c, 
                    vlocity_cmt__PaymentMethodId__r.vlocity_cmt__RoutingTransitNumber__c, 
                    vlocity_cmt__PaymentMethodId__r.CardHolderDocumentNumber__c, 
                    vlocity_cmt__PaymentMethodId__r.CardHolderDocumentType__c,
                    vlocity_cmt__PaymentMethodId__r.vlocity_cmt__Last4Numbers__c,
                    Financial_Promotion__r.id,
                    Financial_Promotion__r.CreditCards__c,
                    Financial_Promotion__r.NombrePromocion__c,
                    Financial_Promotion__r.InstalmentPlan__c,
                    Financial_Promotion__r.Name,
                    vlocity_cmt__PaymentMethodId__c, 
                    vlocity_cmt__Amount__c,
                    PaymentCode__c,
                    Order__c, 
                    Order__r.OriginStoreLocation__r.PaymentChannel__c,
                    vlocity_cmt__TotalInstallments__c
                    from vlocity_cmt__PaymentAdjustment__c 
                    where Order__c =: orderID
                    AND (vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c = '2001' OR vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c = '4002')];

                    //Cambiar 4002 tarjeta de debito por 4001 - AM 29/03/2018

        if(test.isRunningTest()){
            payments = (List<vlocity_cmt__PaymentAdjustment__c>)options.get('payments');
        }
        System.debug('payments: '+payments);
        if(payments.size() > 0){
            orderList = [select id, Gestion__c, OriginStoreLocation__r.PointOfSaleId__c, PreInvoiceNumber__c from Order where id =: orderID];
            accountList = [select id, Name, DocumentNumber__c, DocumentType__c, accountintegrationid__c from Account where id=:accountID];
            order = orderList.get(0);
            account = accountList.get(0);
            String tipoPago;
            if(order.Gestion__c == 'Recarga'){
                tipoPago = 'RechargeInvoice';
            }else{
                tipoPago= 'SalesInvoice';}
            Date now = Date.today();
            Integer i=1;
            for(vlocity_cmt__PaymentAdjustment__c pago : payments){
                Map <String, Object> raiz = new Map<String,Object>();
                Map <String, Object> mapItemsFactura = new Map<String,Object>();
                Map <String, Object> pagoEfectivo = new Map<String,Object>();
                Map <String, Object> infoBanco = new Map<String,Object>();
                Map <String, Object> wondersoftInfo = new Map<String,Object>();
                Map <String, Object> infoPago = new Map<String,Object>();
                Map <String, Object> objetoPago = new Map<String,Object>();
                Map <String, Object> codAccesoCuenta = new Map<String,Object>();
                Map <String, Object> codAccCuenta = new Map<String,Object>();

                if(pago.vlocity_cmt__PaymentMethodId__r.BankEntityName__c!=null){
                    infoBanco.put('codEntidadFinanciera',pago.vlocity_cmt__PaymentMethodId__r.BankEntityName__c.leftPad(3, '0'));
                }

                infoBanco.put('codMedioPago', IntegrationUtils.ParseCodMedioPago(pago.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c));
                infoBanco.put('codEntidadTC',pago.Financial_Promotion__r.CreditCards__c);
                infoBanco.put('nombreActor',pago.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardHolderName__c);
                String monthExp = '';
                if(Integer.valueOf(pago.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c) >= 10){
                    monthExp = pago.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c;
                } else {
                    monthExp = '0'+pago.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c;
                }
                infoBanco.put('fechaVencimientoTarjeta',pago.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationYear__c + monthExp );
                for(Object temp : PaymentMethods){
                    map<String,Object> mapa = new map<String,Object>();
                    mapa = (map<String,Object>) temp;
                    map<String,Object> inside = new map<string,object>();
                    if(mapa.containsKey('CreditCardData')){
                        inside= (Map<String,Object>) mapa.get('CreditCardData');
                        String numeros = (String) inside.get('CardNumber');
                        String ultimosNumeros = numeros.right(4);
                        if(ultimosNumeros == pago.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__Last4Numbers__c){
                            infoBanco.put('nroTarjetaEncriptado',inside.get('CardNumber'));
                            infoBanco.put('codSeguridadTarjeta',inside.get('SecurityCode'));
                        }
                    } else if(mapa.containsKey('DebitCardData')){
                        inside = (Map<String,Object>) mapa.get('DebitCardData');
                        String numeros = (String) inside.get('CardNumber');
                        String ultimosNumeros = numeros.right(4);
                        if(ultimosNumeros == pago.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__Last4Numbers__c){
                            infoBanco.put('nroTarjetaEncriptado',inside.get('CardNumber'));
                            infoBanco.put('codSeguridadTarjeta',inside.get('SecurityCode'));
                        }
                    }
                }

                if(pago.vlocity_cmt__TotalInstallments__c!=null){
                    infoBanco.put('cantidadCuotasTarjeta',String.valueOf(pago.vlocity_cmt__TotalInstallments__c).leftPad(2, '0'));
                }
                
                pagoEfectivo.put('importePago',pago.vlocity_cmt__Amount__c);
                pagoEfectivo.put('codMedioPago',pago.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c);
                pagoEfectivo.put('planCuota',pago.Financial_Promotion__r.InstalmentPlan__c);
                pagoEfectivo.put('infoBanco',infoBanco);
                mapItemsFactura.put('numeroComprobante', order.PreInvoiceNumber__c);
                listaItemsFactura.add(mapItemsFactura);
                pagoEfectivo.put('listaItemsFactura',listaItemsFactura);

                //pago.PaymentCode__c
                infoPago.put('pagoEfectivo',pagoEfectivo);
                wondersoftInfo.put('ipOrigen',ipOriginValue);
                wondersoftInfo.put('nombreActor',pago.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardHolderName__c);
                wondersoftInfo.put('tipoDocumento',pago.vlocity_cmt__PaymentMethodId__r.CardHolderDocumentType__c);
                wondersoftInfo.put('numeroDocumento',pago.vlocity_cmt__PaymentMethodId__r.CardHolderDocumentNumber__c);
                wondersoftInfo.put('codPromoBanco',pago.Financial_Promotion__r.Name);
                codAccCuenta.put('idCuenta',account.AccountIntegrationId__c);
                /*MOCK: SOLO FUNCIONA CON ID DE FLORIDA ACOSTA*/
                //codAccCuenta.put('idCuenta','1380001003300001');
                /*MOCK: NO SOLO FUNCIONA CON ID JUAN CANET GET ERRORS NO FUNCIONA CON ID CUENTA NULL*/
                //codAccCuenta.put('idCuenta','1380001006310001');
                if(codAccCuenta.get('idCuenta') == null){
                    getErrors = true;
                }
                codAccesoCuenta.put('codAccCuenta',codAccCuenta);                
                objetoPago.put('codAccesoCuenta',codAccesoCuenta);                
                raiz.put('wondersoftInfo',wondersoftInfo);
                raiz.put('infoPago',infoPago);
                
                raiz.put('nroPuntoVentaFiscal',order.OriginStoreLocation__r.PointOfSaleId__c);
                raiz.put('tipoPago',tipoPago);
                raiz.put('fechaPago',IntegrationUtils.ParseDateTime(now));
                raiz.put('codMoneda','ARS');
                raiz.put('objetoPago',objetoPago);
                raiz.put('identificadorPagoCanal',i);
                raiz.put('codCanal', pago.Order__r.OriginStoreLocation__r.PaymentChannel__c);
                //AM 8/8/2018 - 1 para pagar factura - 2 Otros pagos(aun no definido). 
                raiz.put('codAccionNegocio', '1'); 
                
                listaInformacionPagos.add(raiz);
                ReferenceMap.put(String.valueOf(i),pago.id);
                //pago
                
                i++;
            }

            procesarPagosPeticion.put('listaInformacionPagos',listaInformacionPagos);
            body.put('procesarPagosPeticion',procesarPagosPeticion);
            
            // Map<String, Object> bodySend = (Map<String, Object>)JSON.serialize(body);
            /*REQUEST Funcional para MOCK*/
            //String bodySend = '{"procesarPagosPeticion":{"listaInformacionPagos":[{"identificadorPagoCanal":1,"objetoPago":{"codAccesoCuenta":{"codAccCuenta":{"idCuenta":"1380001003300001"}}},"codMoneda":"ARS","fechaPago":"2018-02-39 09:00:00","tipoPago":"SalesInvoice","nroPuntoVentaFiscal":1,"infoPago":{"pagoEfectivo":{"infoBanco":{"cantidadCuotasTarjeta":"08","fechaVencimientoTarjeta":"1212","nombreActor":"qerty","codEntidadTC":"377","codMedioPago":"2001","codEntidadFinanciera":"872"},"planCuota":1,"codMedioPago":"4","importePago":134}},"wondersoftInfo":{"codPromoBanco":"Ahora 12","numeroDocumento":"12345678","tipoDocumento":"DNI","nombreActor":"qerty","ipOrigen":"10.244.72.16"}}]}}';
            vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
            
            Map<String,Object> inMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> opt = new Map<String,Object>();
            
            inMap.put('body', body);
            
            if(test.isRunningTest()){
                IFS_S348_Test metodoTest = new IFS_S348_Test();
                outMap= metodoTest.generarRespuesta();
             }else {    
                integProcService.invokeMethod('IFS_S348', inMap, outMap, opt);
            }
            
            System.debug('request S348: ' + JSON.serialize(inMap));
            System.debug('response S348: ' + JSON.serialize(outMap));
            
            Boolean salvable = true;
            List<Object> errors = new List<Object>();
            if(getErrors == false){
                Map<String, Object> response = (Map<String, Object>)outMap.get('IPResult');
                output.put('IPResult', response);

                if(response.containsKey('procesarPagosRespuesta')){
                    List<vlocity_cmt__PaymentAdjustment__c> paymentsAModificar = new List<vlocity_cmt__PaymentAdjustment__c>();
                    map<String,Object> auxiliarCheck = (map<String,Object>) outMap.get('IPResult');
                    Map<String, Object> procesarPagosRespuestaMap = new Map<String, Object>();
                    procesarPagosRespuestaMap=(Map<String, Object>)response.get('procesarPagosRespuesta');
                    if(procesarPagosRespuestaMap.containsKey('listaInformacionPagos')){
                        List<Object> listaInformacionPagosAux=(List<Object>)procesarPagosRespuestaMap.get('listaInformacionPagos');
                        for(Object pago : listaInformacionPagosAux){
                            map<String,Object> pagoInterior = new map<String,Object>();
                            map<String,Object> resultadoPago = new map<String,Object>();
                            map<String,Object> pagoFallido = new map<String,Object>();
                            map<String,Object> pagoExitoso = new map<String,Object>();
                            
                            pagoInterior=(map<String,Object>)pago;
                            String comparacionInterna = (String)pagoInterior.get('identificadorPagoCanal');
                            resultadoPago=(map<String,Object>)pagoInterior.get('resultadoPago');
                            if(resultadoPago.containsKey('pagoExitoso')){
                                pagoExitoso=(map<String,Object>)resultadoPago.get('pagoExitoso');
                                String codPago = (String)pagoExitoso.get('codPago');
                                String idModificar = (String)ReferenceMap.get(comparacionInterna);
                                
                                for(vlocity_cmt__PaymentAdjustment__c paymentAdj : payments){
                                    if(paymentAdj.id == idModificar){
                                        paymentAdj.PaymentCode__c=codPago;
                                        paymentsAModificar.add(paymentAdj);
                                    }
                                }
                            } else if(resultadoPago.containsKey('pagoFallido')){
                                pagoFallido=(map<String,Object>)resultadoPago.get('pagoFallido');
                                getErrors = true;

                                Map<String,Object> errorDetail = (Map<String, Object>)pagoFallido.get('errorDetail');
                                errors.add(errorDetail);
                                String codigo = String.valueOf(errorDetail.get('codigo'));
                                // los errores del tipo COM, TEC y SEG son salvables, pueden ser de comunicacion que reintando se pueden pasar.SelectOption
                                // en cambio los de negocio empezados con NEG, no se pueden salvar
                                if(!codigo.startsWith('COM') && !codigo.startsWith('TEC') && !codigo.startsWith('SEG')){
                                    salvable = false;
                                }                                
                            }
                        }
                                                            
                        update paymentsAModificar;
                    }
                } else {
                    System.debug('!procesarPagosRespuesta'); 
                }
            
            }

            // output.put('errors', getErrors);
            output.put('errors', null);
            if(getErrors){
                output.put('errors', errors);
                output.put('salvable', salvable);
            }

            // output.put('errors', true);
            // output.put('salvable', true);
        }        
    }
}