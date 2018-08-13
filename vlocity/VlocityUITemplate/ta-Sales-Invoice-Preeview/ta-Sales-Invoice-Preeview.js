vlocity.cardframework.registerModule.controller('InvoiceController', ['$scope', '$filter', function ($scope, $filter) {

	var vm = this;
	var bpTree = $scope.bpTree;
	
	activate();
	
    $scope.$watch('bpTree.response.GetPaymentAdjustments_Response.data', function(newVal, oldVal) {
	    if (newVal != oldVal) {
            activate();
	    }
	});
    
	function activate() {
	    
    	vm.custom = true;
        vm.taxes = [];
    	vm.items = [];
    	vm.financiado = [];
    	vm.totalBeforeTaxes = 0;
    	vm.totalTaxes = 0;
    	vm.totalFinancing = 0;
    	vm.total = 0;
    	
        vm.toggleCustom = toggleCustom;
    
// 		var order = bpTree.response.BillingOrder;

// 		if (order.Items) {
// 			vm.items = angular.isArray(order.Items) ? order.Items : [order.Items];
// 		}
		if (bpTree.response.S013_Response.IPResult.calculoImpuestosRespuesta) {
		    //PFTA-11109
		    //vm.importeComp = bpTree.response.S013_Response.IPResult.calculoImpuestosRespuesta.importeComprobante;
			vm.taxes = bpTree.response.S013_Response.IPResult.calculoImpuestosRespuesta.infoResCalculoImpuestos;
		}
		if(bpTree.response.GetPaymentAdjustments_Response){
    		vm.payments = bpTree.response.GetPaymentAdjustments_Response.data;
    		for(var i = 0; i < vm.payments.length; i++){
    		    if(vm.payments[i].Financial_Promotion__r && vm.payments[i].Financial_Promotion__r.Percentage__c > 0){
    		        vm.financiado.push(vm.payments[i]);
    		    }
    		}
		}

		calculateTotals();
	}

	function calculateTotals() {

		vm.totalTaxes = 0;
		vm.totalBeforeTaxes = 0;
		vm.totalFinancing = 0;
		vm.totalDiscounts = 0;
		
		// no tengo taxes, entonces pongo como total el importe del comprobante
		if(!vm.taxes || vm.taxes.length === 0){
		    console.info(bpTree);
		    vm.total = bpTree.response.S013_Response.IPResult.calculoImpuestosRespuesta.importeComprobante;
		    return;
		}
		
		for(var i = 0; i < vm.taxes.length; i++){
		    // sino tengo descripcion lo salto, es un cargo financiero
		    console.info('vm.taxes: ');
		    console.info(vm.taxes[i]);
		    if(!vm.taxes[i].impuestoxItemInfo.descripcion){
		        continue;
		    }
		    
		    //Esto es el subtotal sin descuentos. Levantamos el precioBase sobre cualquier impuesto
		    vm.totalBeforeTaxes += parseFloat(vm.taxes[i].impuestoxItemInfo.listaInfoImpuestos[0].infoImpuesto.precioBase);
		    console.info('totalBeforeTaxes ',vm.totalBeforeTaxes);
		    
		    //PFTA-11109. Se debe iterar sobre todos los elementos en listaInfoImpuestos
		    for (taxNum = 0; taxNum < vm.taxes[i].impuestoxItemInfo.listaInfoImpuestos.length; taxNum++) {
		        var tax = vm.taxes[i].impuestoxItemInfo.listaInfoImpuestos[taxNum].infoImpuesto;
    		    //PFTA-11109 - La sumatoria de impuestos es simplemente eso. No se necesita restar el precio base
    		    vm.totalTaxes += parseFloat(tax.importeImpuestoAplicado);
		    }
		    console.info('totalTaxes ',vm.totalTaxes);
	    
		    //Cambio 28/05/18, preguntamos si listaDescuentosImpuestos tiene data antes de recorrer. La respuesta puede no traer nada acá.
		    if(vm.taxes[i].impuestoxItemInfo.listaDescuentosImpuestos) {
		      //  console.info('tengo descuentos');
		        
    		    for(var j = 0; j < vm.taxes[i].impuestoxItemInfo.listaDescuentosImpuestos.length; j++){
    		        var discount = vm.taxes[i].impuestoxItemInfo.listaDescuentosImpuestos[j];
    		      //  console.info('discount', discount);
    		        if (discount) {
        		        for(var k = 0; k < discount.infoDescuento.listaInfoImpuestos.length; k++){
        		            var impuesto = discount.infoDescuento.listaInfoImpuestos[k].infoImpuesto;
        		            if(k === 0){
        		                // si es el prmero se suma el valor de descuento aplicado y para el resto se suma el impuesto tambien.
        		                vm.totalDiscounts += parseFloat(impuesto.montoDescuentoPrecioProducto);
        		            }
        		          //  console.info('impuesto', impuesto);
        		            vm.totalDiscounts += parseFloat(impuesto.importeImpuestoAplicado);    
        		        }
    		        }
        		}
		    }
		    console.info('totalDiscounts ',vm.totalDiscounts);
		}
		
		for(var e = 0; e < vm.financiado.length; e++){
		    var nodeTax = vm.taxes[vm.financiado[e].Huawei_Invoice_Item_Sequence__c - 1];
		    if(nodeTax){
		        //PFTA-11109. Al igual que al resto de los cargos, nos aseguramos de sumar el precioBase solo una vez e iteramos sobre los impuestos.
		        var tot = null;
		        if(nodeTax.impuestoxItemInfo.listaInfoImpuestos && nodeTax.impuestoxItemInfo.listaInfoImpuestos.length > 0){
    		        tot = nodeTax.impuestoxItemInfo.listaInfoImpuestos[0].infoImpuesto;
		        }
		        if(tot){
		            vm.totalFinancing += parseFloat(tot.precioBase);     
		        }
		        
    		    for (var f = 0; f < nodeTax.impuestoxItemInfo.listaInfoImpuestos.length; f++) {
    		        var tot2 = nodeTax.impuestoxItemInfo.listaInfoImpuestos[f].infoImpuesto;
    		        if(tot2){
    		            vm.totalFinancing += parseFloat(tot2.importeImpuestoAplicado);    
    		        }
    		    }
		    }
		    console.info('totalFinancing ', vm.totalFinancing);
		}
		
		vm.total = vm.totalTaxes + vm.totalBeforeTaxes + vm.totalFinancing - vm.totalDiscounts;
	}
	
	vm.getTotalDiscount = function(infoDescuento){
	   // console.info('getTotalDiscount', infoDescuento);
	    var totalDiscount = 0;
	    for(var k = 0; k < infoDescuento.listaInfoImpuestos.length; k++){
	        var infoImpuesto = infoDescuento.listaInfoImpuestos[k].infoImpuesto;
	       // console.info('infoImpuesto', infoImpuesto);
	        if(infoImpuesto){
	            if(k === 0){
	                totalDiscount += parseFloat(infoImpuesto.montoDescuentoPrecioProducto);
	            }
	            totalDiscount += parseFloat(infoImpuesto.importeImpuestoAplicado);
	        }
	    }
	   // console.info('totalDiscount', totalDiscount);
	    return totalDiscount;
	}
	
    function toggleCustom(){
        vm.custom = vm.custom === false ? true: false;
    }
        
}]);