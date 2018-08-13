vlocity
.cardframework
.registerModule
.controller('ProductItemMorePlanDetailsController', ProductItemMorePlanDetailsController);

ProductItemMorePlanDetailsController.$inject = ['$scope', '$rootScope'];

function ProductItemMorePlanDetailsController($scope, $rootScope) {
    var pimppdc = this;
    
    console.info("ta-CPQ-product-item-PlanDetails ");
    
    pimppdc.init = init;
    pimppdc.service = [];
    pimppdc.basicServices = [];
    
    function typeFaf() {
        return {
            "type": "",
            "value": "",
            "description": ""
        };
    };
    
    function init() {

        pimppdc.productGroups = $scope.records[0].productGroups.records;

        console.info(" CANTIDAD productGroups: ", pimppdc.productGroups.length);
        console.info(" CANTIDAD productGroups: ", pimppdc.productGroups);

        for (var i = 0; i < pimppdc.productGroups.length; i++) {
            
            pimppdc.productChilds = pimppdc.productGroups[i].childProducts.records;

            if (pimppdc.productGroups[i].ProductCode.value == "FAN_PV_GSM_0001" ) {

                console.info("CANTIDAD productChilds: " + pimppdc.productChilds.length);

                for (var k = 0; k < pimppdc.productChilds.length; k++) {

                    pimppdc.productChilds[k].Product2.%vlocity_namespace%__JSONAttribute__c = JSON.parse(pimppdc.productChilds[k].Product2.%vlocity_namespace%__JSONAttribute__c);

                    console.info(pimppdc.productChilds[k].Product2.%vlocity_namespace%__JSONAttribute__c)
                    
                    
                    var arrayProducts = {
                        "name": pimppdc.productChilds[k].name,
                        "trafic": "",
                        "service_description": "",
                        "service_type": "",
                        "service_first_block_value": "",
                        "service_cost_value": "",
                        "service_free_unit": "",
                        "service_meter_unit": "",
                        "service_validity_unit": "",
                        "service_validity_meter_unit": ""
                    }

                    angular.forEach(pimppdc.productChilds[k].Product2.%vlocity_namespace%__JSONAttribute__c, function(item){

                        for (var j = 0; j < item.length; j++) {

                            if(item[j].attributedisplayname__c == "Sentido Trafico" && item[j].attributeRunTimeInfo.default.length >0 && item[j].attributeRunTimeInfo.default[0].displayText == "Saliente"){

                                arrayProducts.trafic = item[j].attributeRunTimeInfo.default[0].displayText;

                            }else if(item[j].attributedisplayname__c == "Descripcion Uso del Servicio"){

                                arrayProducts.service_description = item[j].value__c;

                            }else if(item[j].attributedisplayname__c == "Tipo de Servicio"){

                                arrayProducts.service_type = item[j].attributeRunTimeInfo.default[0].value;

                            }else if(item[j].attributedisplayname__c == "Valor del Primer Bloque"){

                                arrayProducts.service_first_block_value = item[j].value__c; 

                            }else if(item[j].attributedisplayname__c == "Valor del Segundo"){

                                arrayProducts.service_cost_value = item[j].value__c;  

                            }else if(item[j].attributedisplayname__c == "Cantidad Unidades Libres"){

                                arrayProducts.service_free_unit = item[j].value__c;

                            }else if(item[j].attributedisplayname__c == "Unidad de Medida de Cantidad" && item[j].attributeRunTimeInfo.default && item[j].attributeRunTimeInfo.default.length>0){

                                arrayProducts.service_meter_unit = item[j].attributeRunTimeInfo.default[0].displayText;

                            }else if(item[j].attributedisplayname__c == "Vigencia Unidades Libres" && item[j].attributeRunTimeInfo.default && item[j].attributeRunTimeInfo.default.length>0){

                                arrayProducts.service_validity_unit = item[j].attributeRunTimeInfo.default[0].displayText; 
                                
                            }else if(item[j].attributedisplayname__c == "Unidad de Medida de Vigencia" && item[j].attributeRunTimeInfo.default && item[j].attributeRunTimeInfo.default.length>0){

                                arrayProducts.service_validity_meter_unit = item[j].attributeRunTimeInfo.default[0].displayText;
                                
                            }else if(item[j].attributedisplayname__c == "Valor del SMS"){
                                
                                arrayProducts.service_cost_value = item[j].value__c;
                                
                            }else if(item[j].attributedisplayname__c == "Valor del MMS"){
                                
                                arrayProducts.service_cost_value = item[j].value__c;
                                
                            }                                                      
                        }
                    });

                    console.info(arrayProducts);
                    pimppdc.service.push(arrayProducts);
                    console.info(pimppdc.service);
                }

            } else if (pimppdc.productGroups[i].ProductCode.value == "FAN_PV_SERVBAS_0001" ) {
                var itemBasic = {
                    "value": ""
                }
                
                for (var k = 0; k < pimppdc.productChilds.length; k++) {
                    console.info(pimppdc.productChilds[k].name);
                    itemBasic.value = pimppdc.productChilds[k].name;
                    console.info(itemBasic);
                    pimppdc.basicServices.push(pimppdc.productChilds[k].name);
                    console.info(pimppdc.basicServices);
                }
                
                
                console.info(pimppdc.basicServices);
                    
            } else if (pimppdc.productGroups[i].ProductCode.value == "FAN_PV_FNF_00001" ) {
                
                var arrayProducts = {
                    "name": pimppdc.productGroups[i].name,
                    "trafic": "",
                    "service_description": "Numeros Amigos",
                    "service_type": "",
                    "service_first_block_value": "",
                    "service_cost_value": "",
                    "service_free_unit": "",
                    "service_meter_unit": "",
                    "service_validity_unit": "",
                    "service_validity_meter_unit": ""
                }
                
                var arrayfaf = [];
                
                for (var k = 0; k < pimppdc.productChilds.length; k++) {
                    
                    
                    for (var z = 0; z < pimppdc.productChilds[k].childProducts.records.length; z++) {
                        
                        var faf = typeFaf();
                    
                        faf.description = pimppdc.productChilds[k].name;
                        
                        pimppdc.productChilds[k].childProducts.records[z].Product2.%vlocity_namespace%__JSONAttribute__c = JSON.parse(pimppdc.productChilds[k].childProducts.records[z].Product2.%vlocity_namespace%__JSONAttribute__c);
                        
                        pimppdc.productChilds[k].Product2.%vlocity_namespace%__JSONAttribute__c = JSON.parse(pimppdc.productChilds[k].Product2.%vlocity_namespace%__JSONAttribute__c);
                        

                        angular.forEach(pimppdc.productChilds[k].Product2.%vlocity_namespace%__JSONAttribute__c, function(item){
                            
                            for (var x = 0; x < item.length; x++) {
                                
                                if(item[x].attributedisplayname__c == "Cantidad Maxima de Lineas Total"){
                                    
                                    faf.value = item[x].value__c;
                                    
                                } 
                            }
                        });
                        
                        angular.forEach(pimppdc.productChilds[k].childProducts.records[z].Product2.%vlocity_namespace%__JSONAttribute__c, function(item){
                            
                            for (var x = 0; x < item.length; x++) {
                                
                                if(item[x].attributedisplayname__c == "Tipo de Servicio"){
                                    
                                    faf.type = item[x].value__c;
                                    
                                } 
                            }
                        });
                        
                        console.info(faf);
                        arrayfaf.push(faf);

                    }
                        
                }
                
                arrayProducts.service_type = arrayfaf;
                pimppdc.service.push(arrayProducts);
                console.info(pimppdc.service);
                
            } else if (pimppdc.productGroups[i].ProductCode.value == "FAN_PV_RESETCD_001" ) {
                
            } else if (pimppdc.productGroups[i].ProductCode.value == "FAN_PV_PACK_002" ) {
                
            }
            
        }

    }
}