global with sharing class KAL_integrationGetTaxes implements vlocity_cmt.VlocityOpenInterface{
	
	global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
		Boolean result=false;
		if (methodName.equals('GetCalculatedTaxes')){
			GetCalculatedTaxes(inputMap, options);
			result = true;
		}
		return result;
	}
	
	public static Map<String, Object> GetCalculatedTaxes(Map<String,Object> inputMap, Map<String,Object> options){
		String orderId = (String)(options.get('OrderId'));
        String domicilio = (String)inputMap.get('delivery');
		System.debug(orderId);
		System.debug(domicilio);        		
        Map<String, Object> request = IntegrationS013Request(orderId, domicilio);
	    System.debug('request s013: '+JSON.serialize(request));
	    Map<String, Object> output = new Map<String, Object>();
	    Map<String, Object> options2 = new Map<String, Object>();	   
	    try{

    		vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
	    	integProcService.invokeMethod('IFS_S013', request, output, options2);
	
    	}catch(Exception ex){
            System.debug('KAL_integrationGetTaxes:GetCalculatedTaxes -> exception: '+ex);
        	throw ex; 
		}

        if(output.isEmpty()){            
            throw new FuncException('Respuesta incorrecta en el servicio S013');            
        }                
        System.debug('response s013: ' + JSON.serialize(output));
        Map<String, Object> response = (Map<String, Object>)output.get('IPResult');               
	    return response;	    
	}
    	
	private static Map<String, Object> IntegrationS013Request(String orderId, String domicilio) {		
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
            
        List<OrderItem> orderItems = taOrderController.GetOrderItemsBillable(orderId);
        Map<String, Object> request = new Map<String, Object>();
        Map<String, Object> calculoImpuestosPeticion = new Map<String, Object>();
        //calculoImpuestosPeticion.put('nivel', 'Cliente');
        //calculoImpuestosPeticion.put('idCliente', order.Account.CustomerIntegrationId__c);        
        Map<String, Object> infoPetCalculoImpuestos = new Map<String, Object>();
        List<Map<String, Object>> listaCantidadCargos = new List<Map<String, Object>>();

        // Obtengo todos los descuentos para luego aplicarlos en el order item que corresponde
        // y se ponen en una estructura tipo hashtable para poder acceder directamente luego
        Map<String, List<vlocity_cmt__OrderPriceAdjustment__c>> hashDescuentos = taOrderController.GetPriceAdjustmentsGroupByOrderItem(orderId);
        
        // // Total  sin impuestos
        Decimal totalBasePrice = 0;
        Integer i = 1;
        	for (OrderItem orderItem : orderItems){
        		String codCargo = '';
            	
            	Map<String, Object> chargeCode = AssetAttributesUtils.ObtenerChargeCode(orderItem.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c);
            	if(chargeCode != null){
                codCargo = String.valueOf(chargeCode.get('value__c'));
            	}
            	
            	for(Integer j = 1 ; j <= orderItem.Quantity; j++){
	                Integer indice = (i*j)-1;
	                Map<String, Object> infoCargo = new Map<String, Object>();
	                Map<String, Object> cargo = new Map<String, Object>();

	                Decimal price = GetBasePrice(orderItem);
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

	                /* aca hago todo lo de descuentos					
	                if(hashDescuentos != null && hashDescuentos.size() > 0){	                    
	                        cargo.put('listaDescuentos', listaDescuentos);
	                    }
	                }*/
	                // fin descuentos
	                infoCargo.put('infoCargo',cargo);
	                listaCantidadCargos.add(infoCargo);
            	}
            	i = i + 1;
            }
			
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
                cargo.put('bienUso', true);
                infoCargo.put('infoCargo',cargo);
                listaCantidadCargos.add(infoCargo);
    
                i = i + 1;
            }
        }

        infoPetCalculoImpuestos.put('listaCantidadCargos', listaCantidadCargos);
        Map<String, Object> infoVentas = new Map<String, Object>();
        infoVentas.put('fechaVenta', IntegrationUtils.ParseDateTime(DateTime.now()));

        //Obtener localidad y provincia        
        Map<String, Object> locationCodes = getCodProvincia(domicilio);
        infoVentas.put('codLocalidad', locationCodes.get('codLocalidad'));
        infoVentas.put('codMunicipio', 'string');
        infoVentas.put('codProvincia', locationCodes.get('codProvincia'));
        
        infoPetCalculoImpuestos.put('infoVentas', infoVentas);

        calculoImpuestosPeticion.put('infoPetCalculoImpuestos', infoPetCalculoImpuestos);
        calculoImpuestosPeticion.put('nivel', 'Cliente');
        calculoImpuestosPeticion.put('idCliente', order.Account.CustomerIntegrationId__c);        
        Map<String, Object> body = new Map<String, Object>();
        body.put('calculoImpuestosPeticion', calculoImpuestosPeticion);
     
        request.put('body', body);		
        System.debug('body' + JSON.serialize(body));
		return request;

    }

    private static Map<String, Object> getCodProvincia(String delivery){        
        Map<String, Object> locationCodes = new Map<String, Object>();
        System.debug('getCodProvincia');
            if(delivery.contains('Ciudad Autónoma de Buenos Aires')) {
                locationCodes.put('codLocalidad', 'Ciudad Autonoma de Buenos Aires');
                locationCodes.put('codProvincia', 'C');
                return locationCodes;    
            }
            else if(delivery.contains('Tierra del Fuego')) {                
                locationCodes.put('codLocalidad', 'Tierra del Fuego');
                locationCodes.put('codProvincia', 'V');
                return locationCodes;
            }
            else if(delivery.contains('Santa Cruz')){                
                locationCodes.put('codLocalidad', 'Santa Cruz');
                locationCodes.put('codProvincia', 'Z');
                return locationCodes;      
            }
            else if(delivery.contains('La Pampa')) {                
                locationCodes.put('codLocalidad', 'La Pampa');
                locationCodes.put('codProvincia', 'L');
                return locationCodes;
            }
            else if(delivery.contains('La Rioja')) {                
                locationCodes.put('codLocalidad', 'La Rioja');
                locationCodes.put('codProvincia', 'F');
                return locationCodes;
            }
            else if(delivery.contains('Catamarca')) {                
                locationCodes.put('codLocalidad', 'Catamarca');
                locationCodes.put('codProvincia', 'K');
                return locationCodes;
            }
            else if(delivery.contains('San Luis')) {                
                locationCodes.put('codLocalidad', 'San Luis');
                locationCodes.put('codProvincia', 'D');
                return locationCodes;
            }
            else if(delivery.contains('Chubut')){                
                locationCodes.put('codLocalidad', 'Chubut');
                locationCodes.put('codProvincia', 'U');
                return locationCodes;
            }
            else if(delivery.contains('Neuquén')) {                
                locationCodes.put('codLocalidad', 'Neuquen');
                locationCodes.put('codProvincia', 'Q');
                return locationCodes;
            }
            else if(delivery.contains('Formosa')){                
                locationCodes.put('codLocalidad', 'Formosa');
                locationCodes.put('codProvincia', 'P');
                return locationCodes;
            }
            else if(delivery.contains('Río Negro')) {                
                locationCodes.put('codLocalidad', 'Rio Negro');
                locationCodes.put('codProvincia', 'R');
                return locationCodes;
            }
            else if(delivery.contains('San Juan')){                
                locationCodes.put('codLocalidad', 'San Juan');
                locationCodes.put('codProvincia', 'J');
                return locationCodes;
            }
            else if(delivery.contains('Jujuy')) {                
                locationCodes.put('codLocalidad', 'Jujuy');
                locationCodes.put('codProvincia', 'Y');
                return locationCodes;
            }
            else if(delivery.contains('Sargento del Estero')){                
                locationCodes.put('codLocalidad', 'Sargento del Estero');
                locationCodes.put('codProvincia', 'G');
                return locationCodes;
            }
            else if(delivery.contains('Corrientes')) {                
                locationCodes.put('codLocalidad', 'Corrientes');
                locationCodes.put('codProvincia', 'W');
                return locationCodes;
            }
         return locationCodes;           
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

        //System.debug('GetBasePrice:alicuota -> ' + alicuota);

        Decimal basePrice = getPrice(orderItem);
        if(alicuota > 0){
            basePrice = basePrice / alicuota;
        }        
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
     
}