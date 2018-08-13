vlocity
    .cardframework
    .registerModule
    .controller('MultiPaymentMethodController', MultiPaymentMethodController);
    
    MultiPaymentMethodController.$inject = ['$scope', '$rootScope', '$filter'];
    function MultiPaymentMethodController($scope, $rootScope, $filter)
    {
        console.info("rootScope: ", $rootScope.ipOrigin);
        if($rootScope.ipOrigin !== undefined && $rootScope.ipOrigin !== null &&  $rootScope.ipOrigin !== ""){
            $scope.bpTree.response.ipOrigin = $rootScope.ipOrigin;   
        }
        var mpmc = this;
        var bpTree = $scope.bpTree;
        var PaymentMethodLimit = 1;
        var dunningMessage = "El método de pago no está disponible porque el cliente posee mora.";
        var limitCredit = "Límite de crédito = 0";
        var limitCreditError = "El monto supera el límite de crédito disponible.";
        var mgsGeneral = "Completá todos los datos."
        var limitAmountSelected = "Los montos seleccionados superan el total de la orden.";
        var expirationDate = "La fecha de vencimiento de la tarjeta no es válida."
        var amountFailed = "Por favor, verifica los montos seleccionados. "
        /* Variable para mostrar detalle */
        mpmc.custom = true;
        mpmc.totalCftAmount = 0;
        
        //mpmc variablesa
        mpmc.taxes = [];
        mpmc.items = [];
        mpmc.financiado = [];
        mpmc.totalBeforeTaxes = 0;
        mpmc.totalTaxes = 0;
        mpmc.totalFinancing = 0;
        mpmc.total = 0;
        mpmc.disableAddPaymentMethod = false;
        mpmc.req = true;
        mpmc.srvErr = false;
        mpmc.months = 12;
        var myDate = new Date();
        mpmc.myMonth = myDate.getMonth();
        mpmc.myYear = myDate.getFullYear();
        mpmc.nextYears = mpmc.myYear + 10;
        mpmc.securityCodeMaxLength = 3;
        
        console.info('myYear: ', mpmc.myYear);
        console.info('next years: ', mpmc.nextYears);

        //mpmc functions
        mpmc.init = init;
        mpmc.addPaymentMethod = addPaymentMethod;
        mpmc.getCardsByBank = getCardsByBank;
        mpmc.getInstallmentsByCard = getInstallmentsByCard;
        mpmc.cloneContainer = cloneContainer;
        mpmc.removeContainer = removeContainer;
        mpmc.updateAvailablePaymentMethod = updateAvailablePaymentMethod;
        mpmc.getDocumentTypes = getDocumentTypes;
        mpmc.validateData = validateData;
        mpmc.toggleCustom = toggleCustom;
        mpmc.PopulateDPFInstallments = PopulateDPFInstallments;
        mpmc.clearData = clearData;
        mpmc.updateAmountSelected = updateAmountSelected;
        mpmc.validateLimitCredit = validateLimitCredit;
        mpmc.range = range;
        mpmc.caculateAmountLeft = caculateAmountLeft;
        mpmc.GetPromotionsByBankCard = GetPromotionsByBankCard;
        mpmc.checkAmountLimit = checkAmountLimit;
        mpmc.getCftByInstallmentsDPF = getCftByInstallmentsDPF;
        mpmc.validateExpirationDate = validateExpirationDate;
        mpmc.financialPromotionsList = {};
        $scope.bpTree.response.promotionOptions = "";
        mpmc.getFinancialPromotions = getFinancialPromotions;
        
        function init() {
            console.info("MultiPaymentMethodController:init");
            mpmc.PaymentMethodQuantity = parseInt($scope.bpTree.response.PaymentMethodQuantity, 10);
            activate();
            getDocumentTypes();
            getPaymentMethod();
            mpmc.originalTotal = angular.copy(mpmc.total);
            PopulateDPFInstallments();
            getFinancialPromotions();

        }
        
        function activate() {
            var order = bpTree.response.BillingOrder;
    
            if (order && order.Items) {
                mpmc.items = angular.isArray(order.Items) ? order.Items : [order.Items];
            }
            
            console.info("order: ", order);
            console.info("response check ");
            console.info("bpTree.response: ", bpTree.response);
            console.info("bpTree.response S013_Response: ", bpTree.response.S013_Response);
            if(bpTree.response.S013_Response !== undefined){    //Muriel 14/03
                console.info("bpTree.response S013_Response NOT UNDEFINED ");
                if (bpTree.response.S013_Response && bpTree.response.S013_Response.IPResult && bpTree.response.S013_Response.IPResult.calculoImpuestosRespuesta)
                    mpmc.taxes = bpTree.response.S013_Response.IPResult.calculoImpuestosRespuesta.infoResCalculoImpuestos;
            }
            if(bpTree.response.GetPaymentAdjustments_Response)
            {
                mpmc.payments = bpTree.response.GetPaymentAdjustments_Response.data;
                
                for(var i = 0; i < mpmc.payments.length; i++){
                    if(mpmc.payments[i].Financial_Promotion__r.Percentage__c > 0){
                        mpmc.financiado.push(mpmc.payments[i]);
                    }
                }
            }
            
            calculateTotals();
        }
    
        function calculateTotals() {

            mpmc.totalTaxes = 0;
            mpmc.totalBeforeTaxes = 0;
            mpmc.totalFinancing = 0;
            mpmc.totalDiscounts = 0;
            
            if(!mpmc.items || mpmc.items.length === 0){
        	    mpmc.total = bpTree.response.S013_Response.IPResult.calculoImpuestosRespuesta.importeComprobante;
        	    return;
        	}
        
            for(var i = 0; i < mpmc.items.length; i++){
                //PFTA-11151. Se deben sumar todos los impuestos por un lado y el precioBase solo una vez
                var nodeTax = mpmc.taxes[mpmc.items[i].Huawei_Invoice_Item_Sequence__c - 1];
                if (nodeTax) {
                    var tax = nodeTax.impuestoxItemInfo.listaInfoImpuestos[0].infoImpuesto;
                    mpmc.totalBeforeTaxes += parseFloat(tax.precioBase);  
                    for (e = 0; e < nodeTax.impuestoxItemInfo.listaInfoImpuestos.length; e++) {
                        var tot = nodeTax.impuestoxItemInfo.listaInfoImpuestos[e].infoImpuesto;
                        mpmc.totalTaxes += parseFloat(tot.importeImpuestoAplicado);
                    }
                    
                    if(nodeTax.impuestoxItemInfo.listaDescuentosImpuestos) {
        	        //  console.info('tengo descuentos');
        		        
            		    for(var j = 0; j < nodeTax.impuestoxItemInfo.listaDescuentosImpuestos.length; j++){
            		        var discount = nodeTax.impuestoxItemInfo.listaDescuentosImpuestos[j];
            		      //  console.info('discount', discount);
            		        if (discount) {
                		        for(var k = 0; k < discount.infoDescuento.listaInfoImpuestos.length; k++){
                		            var impuesto = discount.infoDescuento.listaInfoImpuestos[k].infoImpuesto;
                		            if(k === 0){
                		                // si es el prmero se suma el valor de descuento aplicado y para el resto se suma el impuesto tambien.
                		                mpmc.totalDiscounts += parseFloat(impuesto.montoDescuentoPrecioProducto);
                		            }
                		          //  console.info('impuesto', impuesto);
                		            mpmc.totalDiscounts += parseFloat(impuesto.importeImpuestoAplicado);    
                		        }
            		        }
                		}
        		    }
        		    console.info('totalDiscounts ',mpmc.totalDiscounts);
                }
            }
            
            for(var j = 0; j < mpmc.financiado.length; j++){
                 //PFTA-11151. Se deben sumar todos los impuestos por un lado y el precioBase solo una vez.
                var nodeTaxF = mpmc.taxes[mpmc.financiado[j].Huawei_Invoice_Item_Sequence__c - 1];
                if (nodeTaxF) {
                    var taxf = nodeTaxF.impuestoxItemInfo.listaInfoImpuestos[0].infoImpuesto;
                    mpmc.totalFinancing += parseFloat(taxf.precioBase);
                    for (var f = 0; f < nodeTaxF.impuestoxItemInfo.listaInfoImpuestos.length; f++) {
                         var tot2 = nodeTax.impuestoxItemInfo.listaInfoImpuestos[f].infoImpuesto;
                         mpmc.totalFinancing += parseFloat(tot2.importeImpuestoAplicado);
                    }
                }
            
            }
            
            
            console.info('Total taxes: ',mpmc.totalTaxes);
            console.info('Total beforeTaxes: ',mpmc.totalBeforeTaxes);
            console.info('Total financing: ',mpmc.totalFinancing);
            
            if(mpmc.totalBeforeTaxes > 0 && bpTree.response.BillingOrder.OrderTotal > 0 && bpTree.response.BillingOrder.OrderTotal !== undefined){
                mpmc.total = mpmc.totalTaxes + mpmc.totalBeforeTaxes + mpmc.totalFinancing - mpmc.totalDiscounts;
            } else {
                if(bpTree.response.BillingOrder.OrderTotal !== undefined){
                    
                    mpmc.total = bpTree.response.BillingOrder.OrderTotal;
                    mpmc.totalBeforeTaxes = bpTree.response.BillingOrder.OrderTotal;
                }  else if(bpTree.response.OrderTotal !== undefined){
                    
                    mpmc.total = bpTree.response.OrderTotal;
                    mpmc.totalBeforeTaxes = bpTree.response.OrderTotal;
                    
                } else {
                    
                    mpmc.total = 0;
                }
                
            }
        }
        
        function validateExpirationDate(index){
            /* Validar que la fecha de vencimiento sea mayor que la fecha actual */
            if(mpmc.paymentMethodList[index].expirationMonth <= mpmc.myMonth && mpmc.paymentMethodList[index].expirationYear == mpmc.myYear){
                mpmc.paymentMethodList[index].srvErrExpDate = true;
                mpmc.paymentMethodList[index].msgError = expirationDate;
                
            } else {
                
                mpmc.paymentMethodList[index].srvErrExpDate = false;
                
            }
            
        }
        
        
        function caculateAmountLeft(index){
            console.info("MultiPaymentMethodController:caculateAmountLeft");
            console.info("MultiPaymentMethodController:index: ", index);
            var calculationAmount = 0;
            for(var i=0; i < mpmc.paymentMethodList.length; i++){
                /* VERIFICAR DINAMICA AQUI  CAMBIA LOS AMOUNT ON BLUR*/ 
                if(mpmc.paymentMethodList[i].amountSelected !== "" && mpmc.paymentMethodList[i].amountSelected > 0 && i !== (index+1) ){
                    
                    calculationAmount += parseFloat(mpmc.paymentMethodList[i].amountSelected);
                    console.info("MultiPaymentMethodController:i: ", i);
                    console.info("MultiPaymentMethodController:for:amountSelected: ", mpmc.paymentMethodList[i].amountSelected);
                    
                }
                
            }
            /*Para calcular el monto total faltante */
            var calculationFixAmount = (parseFloat(mpmc.originalTotal) - parseFloat(calculationAmount));
            console.info("MultiPaymentMethodController:calculationFixAmount: ", calculationFixAmount);
            if(calculationFixAmount > 0 && (mpmc.paymentMethodList.length-1 !== index || mpmc.paymentMethodList[index].amountSelected === "") && mpmc.paymentMethodList[mpmc.paymentMethodList.length-1].amountSelected === ""){
                
                
                mpmc.paymentMethodList[mpmc.paymentMethodList.length-1].amountSelected = calculationFixAmount;
                validateLimitCredit(mpmc.paymentMethodList.length-1);
                console.info("MultiPaymentMethodController:length-1: ", mpmc.paymentMethodList.length-1);
                console.info("MultiPaymentMethodController:amountSelected: ", mpmc.paymentMethodList[mpmc.paymentMethodList.length-1].amountSelected);
            }
        }
        
        
        function range(min, max, step) {
            step = step || 1;
            var input = [];
            for (var i = min; i <= max; i += step) {
                input.push(i);
            }
            return input;
        }
        
        
        $scope.$watch("mpmc.paymentMethodList", function(newValue, oldValue){
            console.info("watch list");
            
            if($scope.bpTree.response.SelectPaymentMethodsStep !== undefined){
                $scope.bpTree.response.SelectPaymentMethodsStep.PaymentMethods = [];

                for(var i=0; i < mpmc.paymentMethodList.length; i++){
                    var data = mpmc.paymentMethodList[i];
                    var creditCardData;
                    var dpfData;
                    
                    /* Agrupamos data de pago de tarjeta de credito */ 
                    data.paymentMethodRadioSelected == "Tarjeta de Credito" ? creditCardData = {
                            "ExpirationMonth": data.expirationMonth,
                            "ExpirationYear": data.expirationYear,
                            "CardNumber": data.cardNumber,
                            "CardOwner": data.cardHolder,
                            "CardEntity": data.cardESelected ? data.cardESelected.value : "",
                            "CardBankingEntity": data.bankSelected ? data.bankSelected.name : "",
                            "SecurityCode": data.securityCode,
                            "PromotionCode": data.promotionsByCardsBankSelected ? data.promotionsByCardsBankSelected.name : "",
                            "PromotionId": data.installmentSelected ? data.installmentSelected.id : "",
                            "DocumentType": data.documentType ? data.documentType.name : "",
                            "DocumentNumber": data.documentNumber,
                            "Installments": data.installmentSelected ? data.installmentSelected.name : "",
                            "CftPercentage": data.installmentSelected ? data.installmentSelected.value : "",
                            "AmountInstallments": data.cftAmount
                        } : creditCardData = null;
                        
                        data.paymentMethodRadioSelected == "Tarjeta de Debito" ? debitCardData = {
                            "ExpirationMonth": data.expirationMonth,
                            "ExpirationYear": data.expirationYear,
                            "CardNumber": data.cardNumber,
                            "CardOwner": data.cardHolder,
                            "CardEntity": data.cardESelected ? data.cardESelected.value : "",
                            "CardBankingEntity": data.bankSelected ? data.bankSelected.name : "",
                            "SecurityCode": data.securityCode,
                            "PromotionCode": data.promotionsByCardsBankSelected ? data.promotionsByCardsBankSelected.name : "",
                            "PromotionId": data.installmentSelected ? data.installmentSelected.id : "",
                            "DocumentType": data.documentType ? data.documentType.name : "",
                            "DocumentNumber": data.documentNumber,
                            "Installments": data.installmentSelected ? data.installmentSelected.name : "",
                            "CftPercentage": data.installmentSelected ? data.installmentSelected.value : "",
                            "AmountInstallments": data.cftAmount
                        } : debitCardData = null;
                        
                    var amountPaymentAdjustment = 0; 
                    if(mpmc.paymentMethodList.length == 1 && data.amountSelected == ''){
                        amountPaymentAdjustment = mpmc.originalTotal;
                    } else {
                        amountPaymentAdjustment = data.amountSelected;
                    }

                    /* Agrupamos data de pago de DPF */                         
                    data.paymentMethodRadioSelected == "Debito a Proxima Factura" ? dpfData = {
                            "DPFInstallments": data.installmentDPFSelected.name,
                            "CftPercentage": data.installmentDPFSelected.value,
                            "AmountInstallments": data.cftAmount,
                            "PromotionId": data.installmentDPFSelected.id
                        } : dpfData = null;
                    
                    
                    /* Creamos los nodos de medios de pago */
                    
                    var obj = {
                        "PaymentMethodRadio": data.paymentMethodRadioSelected,
                        "CreditCardData": creditCardData,
                        "DebitCardData": debitCardData,
                        "Amount": amountPaymentAdjustment,
                        "DPFData": dpfData
                    }
                    
                    $scope.bpTree.response.SelectPaymentMethodsStep.PaymentMethods.push(obj);
                    $scope.bpTree.response.SelectPaymentMethodsStep.AmountTotalCft = mpmc.total;
                    console.info($scope.bpTree.response.SelectPaymentMethodsStep.PaymentMethods.length);
                    
                }
            }
            
        }, true);
   
        function checkAmountLimit(index){

            var totalAmountSelected = 0;
            if(mpmc.paymentMethodList.length > 1){
                for(var i=0; i<mpmc.paymentMethodList.length; i++){
                    mpmc.paymentMethodList[i].srvErrGeneral = false;
                    mpmc.paymentMethodList[i].msgError = "";
                    if(mpmc.paymentMethodList[i].amountSelected && mpmc.paymentMethodList[i].amountSelected > 0){
                        console.info("i: ", mpmc.paymentMethodList[i].amountSelected);
                        totalAmountSelected += parseFloat(mpmc.paymentMethodList[i].amountSelected);
                    } else if(mpmc.paymentMethodList[i].amountSelected == 0){
                        mpmc.paymentMethodList[i].srvErrGeneral = true;
                        mpmc.paymentMethodList[i].msgError = amountFailed;
                    }
                }            
            }
            console.info('totalAmountSelected: ', totalAmountSelected);
            
            if( totalAmountSelected > mpmc.originalTotal){
                
                mpmc.caculateAmountLeft(index);
                mpmc.paymentMethodList[index].srvErrGeneral = true;
                mpmc.paymentMethodList[index].msgError = limitAmountSelected;
                
            } else if(totalAmountSelected < mpmc.originalTotal){
                mpmc.caculateAmountLeft(index);
                mpmc.paymentMethodList[index].srvErrGeneral = true;
                mpmc.paymentMethodList[index].msgError = amountFailed;
            }
            
        }
        
        /*Calcular CFT y validar limites de crédito */
        function validateLimitCredit(index){
            
            console.info("MultiPaymentMethodController:validateLimitCredit");
            
            var totalTemp = 0;
            var installmentSelectedFloat = 0;
            var amountSelected = 0;
            console.info("data: ", mpmc.paymentMethodList[index]);
            console.info("mpmc.total: ", mpmc.total);
            
            if(!mpmc.total){
                mpmc.total = mpmc.originalTotal;
            }
            
            console.info("index: ", index);
            console.info("[index].cftAmount: ", mpmc.paymentMethodList[index].cftAmount);
            
            if( mpmc.paymentMethodList[index].cftAmount !== "" &&  mpmc.paymentMethodList[index].cftAmount > 0){
                console.info(" RESTA: " + mpmc.total + " - " + mpmc.paymentMethodList[index].cftAmount);
                mpmc.total = parseFloat(mpmc.total) - parseFloat(mpmc.paymentMethodList[index].cftAmount);
            }
            
            mpmc.paymentMethodList[index].amountSelected !== "" && mpmc.paymentMethodList[index].amountSelected > 0 ? amountSelected = mpmc.paymentMethodList[index].amountSelected : amountSelected = 0;
            
            mpmc.paymentMethodList.length == 1 ? totalTemp = parseFloat(mpmc.total).toFixed(2) : totalTemp = parseFloat(amountSelected).toFixed(2);
            
            console.info("123 - totalTemp: ", totalTemp);
            
            if(mpmc.paymentMethodList[index].paymentMethodRadioSelected == 'Debito a Proxima Factura' && mpmc.paymentMethodList[index].installmentDPFSelected){
                
                installmentSelectedFloat = parseFloat(mpmc.paymentMethodList[index].installmentDPFSelected.value).toFixed(2);
                
            } else if (mpmc.paymentMethodList[index].paymentMethodRadioSelected == 'Tarjeta de Credito' && mpmc.paymentMethodList[index].installmentSelected){
                
                installmentSelectedFloat = parseFloat(mpmc.paymentMethodList[index].installmentSelected.percentage).toFixed(2);
                
            } else if (mpmc.paymentMethodList[index].paymentMethodRadioSelected == 'Tarjeta de Debito' && mpmc.paymentMethodList[index].installmentSelected){
                
                installmentSelectedFloat = parseFloat(mpmc.paymentMethodList[index].installmentSelected.percentage).toFixed(2);
                
            }

            mpmc.paymentMethodList[index].cftAmount = (installmentSelectedFloat * totalTemp) / 100;
            mpmc.total = parseFloat(mpmc.total) + parseFloat(mpmc.paymentMethodList[index].cftAmount);
            console.info("cftAmount: ", mpmc.paymentMethodList[index].cftAmount);
            console.info("mpmc.total: ", mpmc.total);
            totalTemp = parseFloat(totalTemp) + parseFloat(mpmc.paymentMethodList[index].cftAmount);
            console.info("140 - totalTemp: ", totalTemp);

            if(totalTemp > bpTree.response.SelectPaymentMethodsStep.CreditLimit && mpmc.paymentMethodList[index].paymentMethodRadioSelected == 'Debito a Proxima Factura'){
                //PFTA-7723. Por ahora se comentan los errores de credit limit
                //mpmc.paymentMethodList[index].srvErrGeneral = true;
                //mpmc.paymentMethodList[index].msgError = limitCreditError;
            }  else {
                mpmc.paymentMethodList[index].totalAmount = totalTemp;
                mpmc.paymentMethodList[index].srvErrGeneral = false;
                mpmc.paymentMethodList[index].msgError = "";
                mpmc.caculateAmountLeft(index);
                
            }

            
        }
        
        /*Buscar CFT por cada cuota Matrix DPF -- NO SE USA MAS LA MATRIX -- */ 
        function getCftByInstallmentsDPF(index) {
            
            console.info("MultiPaymentMethodController:getCftByInstallmentsDPF");
            /*Visualforce.remoting.Manager.invokeAction(
                "taOrderController.GetMatrixDpfCft", mpmc.paymentMethodList[index].installmentDPFSelected.name,
                        function(result) {
                            console.info('getCftByInstallmentsDPF: ', result);

                        },
                {escape: false} // No escaping, please
            );*/
            
            if(mpmc.paymentMethodList[index].installmentDPFSelected !== "" && mpmc.paymentMethodList[index].installmentDPFSelected !== undefined){
                console.info("installmentDPFSelected.name: ", mpmc.paymentMethodList[index].installmentDPFSelected.name);
                if( mpmc.paymentMethodList.length == 1 ){
                    validateLimitCredit(index);
                } else if(mpmc.paymentMethodList.length > 1 && mpmc.paymentMethodList[index].amountSelected !== "" && mpmc.paymentMethodList[index].amountSelected > 0){
                    validateLimitCredit(index);
                }
                
            } else {
                mpmc.paymentMethodList[index].cftAmount = 0;
            }
            
             $scope.$apply();
            

        }
        
        /* Obtener tipos de documentos */ 
        function getDocumentTypes() {
            
            console.info("MultiPaymentMethodController:getDocumentTypes");
            Visualforce.remoting.Manager.invokeAction(
                "taOrderController.GetDocumentTypes", $scope.bpTree.response,
                        function(result) {
                            console.info('DOCUMENT TYPE: ', result.options);
                            mpmc.documentTypeList = result.options;
                        },
                {escape: false} // No escaping, please
            );
        }

        /* Obtener metodos de pago disponibles */ 
        function getPaymentMethod() {
            
            console.info("MultiPaymentMethodController:getPaymentMethod");
            Visualforce.remoting.Manager.invokeAction(
                "taOrderController.GetPaymentMethods", $scope.bpTree.response,
                        function(result) {
                            console.info('PaymentMethod: ', result);
                            mpmc.medioDePagos = result.options;
                            mpmc.medioDePagosTemp = angular.copy(result.options);
                            mpmc.paymentMethodList = [
                                {
                                    "paymentMethodRadioList": mpmc.medioDePagos,
                                    "paymentMethodRadioSelected": mpmc.medioDePagos[0].value,
                                    "bankSelected": "", 
                                    "cardESelected": "",
                                    "installmentSelected":"",
                                    "amountSelected": "",
                                    "installmentByCardBank": "",
                                    "cardsByBank": "",
                                    "radioDisabled": false,
                                    "cardNumber": "",
                                    "expirationMonth": "",
                                    "expirationYear": "",
                                    "securityCode": "",
                                    "promotionCode": "",
                                    "documentNumber": "",
                                    "documentType": "",
                                    "cardHolder": "",
                                    "cftAmount": "",
                                    "totalAmount": "",
                                    "installmentDPFSelected": "",
                                    "srvErrAmount": false,
                                    "srvErrRadio": false,
                                    "srvErrBank": false,
                                    "srvErrCard": false,
                                    "srvErrInst": false,
                                    "srvErrPromo": false,
                                    "srvErrCardNumber": false,
                                    "srvErrExpDate": false,
                                    "srvErrSec": false,
                                    "srvErrDocType": false,
                                    "srvErrDocNum": false,
                                    "srvErrHolder": false,
                                    "srvErrGeneral": false,
                                    "msgError": "",
                                    "promotionsByCardsBank": "",
                                    "promotionsByCardsBankSelected": "",
                                    "securityCodeMaxLength":3
                                    
                                }
                                
                            ];
                            
                            mpmc.updateAvailablePaymentMethod(mpmc.paymentMethodList[0]);
                            
                            console.info("mpmc.paymentMethodList: ", mpmc.paymentMethodList);
                        },
                {escape: false} // No escaping, please
            );
        }
        
        /* Obtener todas las entidades bancarias */ 
        function PopulateDPFInstallments() {
            
            console.info("MultiPaymentMethodController:PopulateDPFInstallments:PopulateDPFInstallmentsFromObject");
            Visualforce.remoting.Manager.invokeAction(
                "taOrderController.PopulateDPFInstallmentsFromObject", $scope.bpTree.response,
                        function(result) {
                            console.info('installmentDPF: ', result.options);
                            mpmc.installmentDPF = result.options;
                        },
                {escape: false} // No escaping, please
            );
        }
        
        /* Obtener todas las Promociones Fiancieras */ 
        function getFinancialPromotions(index) {
            
            console.info($scope.bpTree.response.BillingOrder.Channel);
            
            if(index !== undefined && mpmc.paymentMethodList[index].paymentMethodRadioSelected == "Tarjeta de Credito"){
                $scope.bpTree.response.recordTypeName = "Credit Card";
            } else if(index !== undefined &&  mpmc.paymentMethodList[index].paymentMethodRadioSelected == "Tarjeta de Debito"){
                $scope.bpTree.response.recordTypeName = "Debit Card";
            } else if($scope.bpTree.response.BillingOrder.Channel == 'Web' || $scope.bpTree.response.BillingOrder.Channel == 'WEB' || $scope.bpTree.response.BillingOrder.Channel == 'Call Center' || $scope.bpTree.response.BillingOrder.Channel == 'E-Commerce' ){
                
                $scope.bpTree.response.recordTypeName = "Credit Card";
                
            }
            
            
            console.info("MultiPaymentMethodController:getFinancialPromotions:getFinancialPromotions");
            Visualforce.remoting.Manager.invokeAction(
                "taOrderController.getFinancialPromotions", $scope.bpTree.response,
                        function(result) {
                            console.info('getFinancialPromotions: ', result);
                            mpmc.financialPromotionsList.promotionOptions = result.options;
                            getBankEntity();
                        },
                {escape: false} // No escaping, please
            );
        }
        
        
        /* Obtener todas las entidades bancarias */ 
        function getBankEntity() {
            
            console.info("MultiPaymentMethodController:getBankEntity:PopulateEntidadesFromObject");
            Visualforce.remoting.Manager.invokeAction(
                "taOrderController.PopulateEntidadesFromObject", mpmc.financialPromotionsList,
                        function(result) {
                            console.info('Bancos: ', result.options);
                            mpmc.entidadesBancarias = result.options;
                        },
                {escape: false} // No escaping, please
            );
        }
        
        /* Obtener las tarjetas disponibles para el banco seleccionado */
        function getCardsByBank(index) {
            
            console.info("MultiPaymentMethodController:getCardsByBank:GetCardsByBankFromObject");
            console.info(mpmc.paymentMethodList[index]);
            var bankSelectedTemp = "";
            if(mpmc.paymentMethodList[index].bankSelected.name)
                bankSelectedTemp = mpmc.paymentMethodList[index].bankSelected.name;
            console.info ('Bank Selected: ', bankSelectedTemp);
            
            if(bankSelectedTemp === ""){
                
                mpmc.paymentMethodList[index].cardsByBank = "";
                resetTotalFromAmountCft(index);
                
            } else {
                Visualforce.remoting.Manager.invokeAction(
                    "taOrderController.GetCardsByBankFromObject", mpmc.financialPromotionsList,
                            function(result) {
                                console.info('Tarjetas: ', result.options);
                                mpmc.paymentMethodList[index].cardsByBank = result.options;
                                mpmc.paymentMethodList[index].promotionsByCardsBank = "";
                                resetTotalFromAmountCft(index);
                                $scope.$apply();
                            },
                    {escape: false} // No escaping, please
                );           
            }
            
        }
        
        function resetTotalFromAmountCft(index){
            if( mpmc.paymentMethodList[index].cftAmount !== "" &&  mpmc.paymentMethodList[index].cftAmount > 0){
                console.info(" RESTA: " + mpmc.total + " - " + mpmc.paymentMethodList[index].cftAmount);
                mpmc.total = parseFloat(mpmc.total) - parseFloat(mpmc.paymentMethodList[index].cftAmount);
                mpmc.paymentMethodList[index].cftAmount = 0;
                mpmc.paymentMethodList[index].installmentByCardBank = "";
            }
        }
        
        function GetPromotionsByBankCard(index) {
            
            console.info("MultiPaymentMethodController:GetPromotionsByBankCard:GetPromotionsByBankCardFromObject");
            console.info(mpmc.paymentMethodList[index]);
            var bankSelectedTemp = "";
            var cardSelected = "";
            
            if(mpmc.paymentMethodList[index].bankSelected.name)
                bankSelectedTemp = mpmc.paymentMethodList[index].bankSelected.name;
        
            if(mpmc.paymentMethodList[index].cardESelected.name)
                cardSelected = mpmc.paymentMethodList[index].cardESelected.name;
                
            if(cardSelected === "377"){
                mpmc.paymentMethodList[index].securityCodeMaxLength = 4;
            } else {
                mpmc.paymentMethodList[index].securityCodeMaxLength = 3;
            }
            
            console.info('Tarjeta Selected and Bank Selected: ', bankSelectedTemp, "_", cardSelected);
            
            if(bankSelectedTemp === ""){
                
                mpmc.paymentMethodList[index].promotionsByCardsBank = "";
                resetTotalFromAmountCft(index);
                
            } else {
                Visualforce.remoting.Manager.invokeAction(
                    "taOrderController.GetPromotionsByBankCardFromObject", bankSelectedTemp, cardSelected, mpmc.financialPromotionsList,
                            function(result) {
                                console.info('Promociones: ', result.options);
                                mpmc.paymentMethodList[index].promotionsByCardsBank = result.options;
                                resetTotalFromAmountCft(index);
                                $scope.$apply();
                            },
                    {escape: false} // No escaping, please
                );           
            }
            
        }
        
        /* Obtener cuotas por tarjeta seleccionada */ 
        function getInstallmentsByCard(index) {
            
            console.info("MultiPaymentMethodController:getInstallmentsByCard:GetInstallmentsByPromotion");
            var bankSelectedTemp = "";
            var cardSelected = "";
            var promotionsByCardsBankSelectedTemp = "";
            
            console.info(mpmc.paymentMethodList[index]);
            
            if(mpmc.paymentMethodList[index].bankSelected.name)
                bankSelectedTemp = mpmc.paymentMethodList[index].bankSelected.name;
                
            if(mpmc.paymentMethodList[index].cardESelected.name)
                cardSelected = mpmc.paymentMethodList[index].cardESelected.name;
                
            if(mpmc.paymentMethodList[index].promotionsByCardsBankSelected && mpmc.paymentMethodList[index].promotionsByCardsBankSelected.name)
                promotionsByCardsBankSelectedTemp = mpmc.paymentMethodList[index].promotionsByCardsBankSelected.name;
                
            console.info('Tarjeta Selected, Bank Selected, Promo Selected : ', bankSelectedTemp, "_", cardSelected, " _ ", promotionsByCardsBankSelectedTemp);
            
            Visualforce.remoting.Manager.invokeAction(
                "taOrderController.GetInstallmentsByPromotion", bankSelectedTemp, cardSelected, promotionsByCardsBankSelectedTemp, mpmc.financialPromotionsList,
                        function(result) {
                            console.info('Cuotas: ', result.options);
                            
                            if(mpmc.paymentMethodList[index].installmentSelected !== "" && mpmc.paymentMethodList[index].installmentSelected !== undefined){
                                console.info(mpmc.paymentMethodList[index].installmentSelected.value);
                                if( mpmc.paymentMethodList.length == 1 ){
                                    validateLimitCredit(index);
                                } else if(mpmc.paymentMethodList.length > 1 && mpmc.paymentMethodList[index].amountSelected !== "" && mpmc.paymentMethodList[index].amountSelected > 0){
                                    validateLimitCredit(index);
                                }
                            } else {
                                resetTotalFromAmountCft(index);
                            }

                            mpmc.paymentMethodList[index].installmentByCardBank = result.options;
                            $scope.$apply();
                        },
                {escape: false} // No escaping, please
            );
        }

        function addPaymentMethod() {
            PaymentMethodLimit++;
            if (PaymentMethodLimit >= mpmc.PaymentMethodQuantity) {
                mpmc.disableAddPaymentMethod = true;
                return;
            }

            var taPaymentMethodContainer = angular.element( document.querySelector( '.taPaymentMethodContainer' ) );
            var taPaymentMethodForm = angular.element( document.querySelector( '.taPaymentMethodForm'   ) );
            taPaymentMethodContainer.append(taPaymentMethodForm.clone(true));
        }
        
        
        /*Mostrar mensajes de error */ 
        function validateData(index){
            
            console.info("MultiPaymentMethodController:validateData");
            var data = mpmc.paymentMethodList[index];
            mpmc.paymentMethodList[index].srvErrGeneral = false;
            mpmc.paymentMethodList[index].srvErrRadio = false;
            mpmc.paymentMethodList[index].srvErrBank = false;
            mpmc.paymentMethodList[index].srvErrCard = false;
            mpmc.paymentMethodList[index].srvErrInst = false;
            mpmc.paymentMethodList[index].srvErrAmount = false;
            mpmc.paymentMethodList[index].srvErrCardNumber = false;
            mpmc.paymentMethodList[index].srvErrExpDate = false;
            mpmc.paymentMethodList[index].srvErrSec = false;
            mpmc.paymentMethodList[index].srvErrDocNum = false;
            mpmc.paymentMethodList[index].srvErrDocType = false;
            mpmc.paymentMethodList[index].srvErrHolder = false;
            mpmc.paymentMethodList[index].srvErrPromo = false;
            
            var control = true; 
            
            if(data.paymentMethodRadioSelected === "" && data.bankSelected === "" && data.cardESelected === "" && data.installmentSelected === "" && data.amountSelected === "" && data.cardNumber === "" && data.expirationMonth === "" && data.expirationYear === "" && data.securityCode === "" && data.documentNumber === "" && data.documentType === "" && data.cardHolder === ""){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrGeneral = true;
                mpmc.paymentMethodList[index].msgError = mgsGeneral;
                
            } else if(data.paymentMethodRadioSelected === ""){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrRadio = true;
                
            } else if(data.bankSelected === "" && (data.paymentMethodRadioSelected == 'Tarjeta de Credito' || data.paymentMethodRadioSelected == 'Tarjeta de Debito')){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrBank = true;
                
            } else if(data.cardESelected === "" && (data.paymentMethodRadioSelected == 'Tarjeta de Credito' || data.paymentMethodRadioSelected == 'Tarjeta de Debito')){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrCard = true;
                
            } else if(data.installmentSelected === "" && (data.paymentMethodRadioSelected == 'Tarjeta de Credito' || data.paymentMethodRadioSelected == 'Tarjeta de Debito')){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrInst = true;
                
            }  else if(data.promotionsByCardsBankSelected === "" && (data.paymentMethodRadioSelected == 'Tarjeta de Credito' || data.paymentMethodRadioSelected == 'Tarjeta de Debito')){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrPromo = true;
                
            } else if(data.installmentDPFSelected === "" && data.paymentMethodRadioSelected == 'Debito a Proxima Factura'){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrInst = true;
                
            } else if(data.cardNumber === "" && (data.paymentMethodRadioSelected == 'Tarjeta de Credito' || data.paymentMethodRadioSelected == 'Tarjeta de Debito') && (bpTree.response.BillingOrder.Channel == 'Web' || bpTree.response.BillingOrder.Channel == 'WEB' || bpTree.response.BillingOrder.Channel == 'E-Commerce' || bpTree.response.BillingOrder.Channel == 'Call Center')){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrCardNumber = true;
                
            } else if(data.expirationMonth === "" && (data.paymentMethodRadioSelected == 'Tarjeta de Credito' || data.paymentMethodRadioSelected == 'Tarjeta de Debito') && (bpTree.response.BillingOrder.Channel == 'Web' || bpTree.response.BillingOrder.Channel == 'WEB' || bpTree.response.BillingOrder.Channel == 'E-Commerce' || bpTree.response.BillingOrder.Channel == 'Call Center')){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrExpDate = true; 
                
            } else if(data.expirationYear === "" && (data.paymentMethodRadioSelected == 'Tarjeta de Credito' || data.paymentMethodRadioSelected == 'Tarjeta de Debito') && (bpTree.response.BillingOrder.Channel == 'Web' || bpTree.response.BillingOrder.Channel == 'WEB' || bpTree.response.BillingOrder.Channel == 'E-Commerce' || bpTree.response.BillingOrder.Channel == 'Call Center')){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrExpDate = true; 
                
            } else if(data.securityCode === "" && (data.paymentMethodRadioSelected == 'Tarjeta de Credito' || data.paymentMethodRadioSelected == 'Tarjeta de Debito') && (bpTree.response.BillingOrder.Channel == 'Web' || bpTree.response.BillingOrder.Channel == 'WEB' || bpTree.response.BillingOrder.Channel == 'E-Commerce' || bpTree.response.BillingOrder.Channel == 'Call Center')){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrSec = true;
                
            } else if(data.documentType === "" && (data.paymentMethodRadioSelected == 'Tarjeta de Credito' || data.paymentMethodRadioSelected == 'Tarjeta de Debito') && (bpTree.response.BillingOrder.Channel == 'Web' || bpTree.response.BillingOrder.Channel == 'WEB' || bpTree.response.BillingOrder.Channel == 'E-Commerce' || bpTree.response.BillingOrder.Channel == 'Call Center')){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrDocType = true;
                
            } else if(data.documentNumber === "" && (data.paymentMethodRadioSelected == 'Tarjeta de Credito' || data.paymentMethodRadioSelected == 'Tarjeta de Debito') && (bpTree.response.BillingOrder.Channel == 'Web' || bpTree.response.BillingOrder.Channel == 'WEB' || bpTree.response.BillingOrder.Channel == 'E-Commerce' || bpTree.response.BillingOrder.Channel == 'Call Center')){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrDocNum = true;
                
            } else if(data.cardHolder === "" && (data.paymentMethodRadioSelected == 'Tarjeta de Credito' || data.paymentMethodRadioSelected == 'Tarjeta de Debito') && (bpTree.response.BillingOrder.Channel == 'Web' || bpTree.response.BillingOrder.Channel == 'WEB' || bpTree.response.BillingOrder.Channel == 'E-Commerce' || bpTree.response.BillingOrder.Channel == 'Call Center')){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrHolder = true;
            
            } else if((data.amountSelected === "" || data.amountSelected === 0 ) && mpmc.paymentMethodList.length > 1){
                
                control = false;
                mpmc.paymentMethodList[index].srvErrAmount = true;
                mpmc.paymentMethodList[index].srvErrGeneral = true;
                data.amountSelected === 0 ? mpmc.paymentMethodList[index].msgError = amountFailed : mpmc.paymentMethodList[index].msgError = mgsGeneral;
            }
            
            console.info("control: ", control);
            console.info("data: ", mpmc.paymentMethodList[index]);
            return control;
            
        }
        
        /* Agregar nuevo medio de pago */
        function cloneContainer(){
            
            console.info("MultiPaymentMethodController:cloneContainer");
            var index = mpmc.paymentMethodList.length-1;
            
            console.info(mpmc.medioDePagosTemp);
            
            if(mpmc.validateData(index)){
                
                PaymentMethodLimit++;
                if (PaymentMethodLimit > mpmc.PaymentMethodQuantity) {
                    mpmc.disableAddPaymentMethod = true;
                    return;
                } else if(PaymentMethodLimit == mpmc.PaymentMethodQuantity) {
                    mpmc.disableAddPaymentMethod = true;
                }
            
                
                var containerToClone = {
                    "paymentMethodRadioList": mpmc.medioDePagosTemp,
                    "paymentMethodRadioSelected": mpmc.medioDePagosTemp[0].value,
                    "bankSelected": "",
                    "cardESelected": "",
                    "installmentSelected":"",
                    "amountSelected": "",
                    "installmentByCardBank": "",
                    "cardsByBank": "",
                    "radioDisabled": false,
                    "cardNumber": "",
                    "expirationMonth": "",
                    "expirationYear": "",
                    "securityCode": "",
                    "promotionCode": "",
                    "documentNumber": "",
                    "documentType": "",
                    "cardHolder": "",
                    "cftAmount": "",
                    "totalAmount": "",
                    "installmentDPFSelected": "",
                    "srvErrAmount": false,
                    "srvErrRadio": false,
                    "srvErrBank": false,
                    "srvErrCard": false,
                    "srvErrInst": false,
                    "srvErrPromo": false,
                    "srvErrCardNumber": false,
                    "srvErrExpDate": false,
                    "srvErrSec": false,
                    "srvErrDocType": false,
                    "srvErrDocNum": false,
                    "srvErrHolder": false,
                    "srvErrGeneral": false,
                    "msgError": "",
                    "promotionsByCardsBank": "",
                    "promotionsByCardsBankSelected": "",
                    "securityCodeMaxLength":3
                };
                
                mpmc.paymentMethodList[index].radioDisabled = true;
                if(mpmc.paymentMethodList[index].amountSelected === "" && mpmc.paymentMethodList[index].cftAmount !== ""){
                    mpmc.total = parseFloat(mpmc.total) - parseFloat(mpmc.paymentMethodList[index].cftAmount);
                    mpmc.paymentMethodList[index].cftAmount = "";
                }
                
                mpmc.paymentMethodList.push(containerToClone);
                mpmc.updateAvailablePaymentMethod(mpmc.paymentMethodList[mpmc.paymentMethodList.length-1]);
                console.info("cloneContainer:length: ", mpmc.paymentMethodList.length);
                if(mpmc.paymentMethodList.length > 2){
                    mpmc.caculateAmountLeft(mpmc.paymentMethodList.length);
                }
                console.info(mpmc.paymentMethodList);
                
            }
            
        }
        
        /*Quitar medio de pago */ 
        function removeContainer(itemIndex) {
            
            console.info("MultiPaymentMethodController:removeContainer");
            
            var foundPM = false;
            var foundPML = false; 
        
            if(mpmc.paymentMethodList.length > 1){
                console.info(PaymentMethodLimit);
            
                PaymentMethodLimit--;
                if (PaymentMethodLimit >= mpmc.PaymentMethodQuantity) {
                    mpmc.disableAddPaymentMethod = true;
                } else {
                    mpmc.disableAddPaymentMethod = false;
                }
                
                var paymentMethodTemp = {
                    "name": mpmc.paymentMethodList[itemIndex].paymentMethodRadioSelected,
                    "value": mpmc.paymentMethodList[itemIndex].paymentMethodRadioSelected
                }
                
                console.info("paymentMethodTemp", paymentMethodTemp);
                console.info("itemIndex", itemIndex);
                
                if(mpmc.paymentMethodList[itemIndex].cftAmount !== "" && mpmc.paymentMethodList[itemIndex].cftAmount > 0){
                    mpmc.total = parseFloat(mpmc.total) - parseFloat(mpmc.paymentMethodList[itemIndex].cftAmount);
                }                
                mpmc.paymentMethodList.splice(itemIndex, 1);
                mpmc.paymentMethodList[mpmc.paymentMethodList.length-1].radioDisabled = false;
                validateLimitCredit(mpmc.paymentMethodList.length-1);
                
                if(mpmc.paymentMethodList.length == 1){
                    mpmc.paymentMethodList[mpmc.paymentMethodList.length-1].amountSelected = "";
                }
                
                if(paymentMethodTemp.name !== "") {
                    
                    for(var i=0; i < mpmc.medioDePagosTemp.length; i++){
                
                        if(mpmc.medioDePagosTemp[i].value == paymentMethodTemp.name ){
                            foundPM = true;
                            break;
                        }
                    }
                    
                    console.info(foundPM);
                    if(foundPM === false){
                        mpmc.medioDePagosTemp.push(paymentMethodTemp);
                    }
                    
                    
                    for(var j=0; j < mpmc.paymentMethodList[mpmc.paymentMethodList.length-1].paymentMethodRadioList.length; j++){
                
                        if(mpmc.paymentMethodList[mpmc.paymentMethodList.length-1].paymentMethodRadioList[j].value == paymentMethodTemp.name ){
                            foundPML = true;
                            break;
                        }
                    }
                    
                    console.info(foundPML);
                    if(foundPML === false){
                        mpmc.paymentMethodList[mpmc.paymentMethodList.length-1].paymentMethodRadioList.push(paymentMethodTemp);
                    }
                }
            }
            
        }
        
        /*Limpiar data cuando se cambia de medio de pago */
        function clearData(items){
            
            console.info("MultiPaymentMethodController:clearData");
            if(items.cftAmount !== "" && items.cftAmount > 0){
                mpmc.total = parseFloat(mpmc.total) - parseFloat(items.cftAmount);
            }
            

            items.bankSelected =  "";
            items.cardESelected = "";
            items.installmentSelected = "";
            //items.amountSelected = "";
            items.radioDisabled =  false;
            items.cardNumber = "";
            items.expirationMonth = "";
            items.expirationYear = "";
            items.securityCode = "";
            items.promotionCode = "";
            items.documentNumber = "";
            items.documentType = "";
            items.cardHolder = "";
            items.cftAmount = "";
            items.totalAmount = "";
            items.installmentDPFSelected ="";
            items.srvErrAmount = false;
            items.srvErrRadio = false;
            items.srvErrBank = false;
            items.srvErrCard = false;
            items.srvErrInst = false;
            items.srvErrPromo = false;
            items.srvErrCardNumber = false;
            items.srvErrExpDate = false;
            items.srvErrSec = false;
            items.srvErrDocType = false;
            items.srvErrDocNum = false;
            items.srvErrHolder = false;
            items.srvErrGeneral = false;
            items.msgError = "";
            items.promotionsByCardsBankSelected = "";
   
        }
        
        /*Actualizar lista de medios de pago disponible cuando se puede pagar una sola vez con ese medio de pago */
        function updateAvailablePaymentMethod(items){
            
            console.info("MultiPaymentMethodController:updateAvailablePaymentMethod");
            console.info(items);
            
            clearData(items);
            mpmc.medioDePagosTemp = angular.copy(items.paymentMethodRadioList);
            
            for(var i=0; i < items.paymentMethodRadioList.length; i++){
                
                if(items.paymentMethodRadioList[i].value == items.paymentMethodRadioSelected && items.paymentMethodRadioSelected !== "Tarjeta de Credito" && items.paymentMethodRadioSelected !== "Tarjeta de Debito" ){
                    
                    mpmc.medioDePagosTemp.splice(i, 1);
                
                }
            }
            /* VERIFICAR SI POSEE MORA*/ /*VERIFICAR SU POSEE LIMITE DE CREDITO */
            if(items.paymentMethodRadioSelected === "Debito a Proxima Factura" && bpTree.response.Dunning === true){
                items.srvErrGeneral = true;
                items.msgError = dunningMessage;
                console.info("Dunning: ", bpTree.response.Dunning);
            } else if (items.paymentMethodRadioSelected === "Debito a Proxima Factura" && bpTree.response.SelectPaymentMethodsStep.CreditLimit <= 0 ){
                items.srvErrGeneral = true;
                items.msgError = limitCredit;
                console.info("CreditLimit: ", bpTree.response.SelectPaymentMethodsStep.CreditLimit);
            }
            
        }
        
        function toggleCustom(){
            
            console.info("MultiPaymentMethodController:toggleCustom");
            mpmc.custom = mpmc.custom === false ? true: false;
        }
        
        /*Change Amount - Actualizar CFT cuando ingresa distintos montos */ 
        function updateAmountSelected(index){
            
            console.info("MultiPaymentMethodController:updateAmountSelected");
            console.info("amountSelected: ", mpmc.paymentMethodList[index].amountSelected);
            
            if(mpmc.paymentMethodList.length > 1 && mpmc.paymentMethodList[index].amountSelected !== ""){
                validateLimitCredit(index);
            }
            
        }
    }