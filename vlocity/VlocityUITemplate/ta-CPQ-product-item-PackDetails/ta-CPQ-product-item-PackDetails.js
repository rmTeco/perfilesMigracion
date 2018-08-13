vlocity
    .cardframework
    .registerModule
    .controller('ProductItemMorePackDetailsController', ProductItemMorePackDetailsController);
    
    ProductItemMorePackDetailsController.$inject = ['$scope', '$rootScope'];
    
    function ProductItemMorePackDetailsController($scope, $rootScope) {
        var pimpdc = this;
        
        console.info("ta-CPQ-product-item-PackDetails");
        
        pimpdc.init = init;
        pimpdc.childs = [];
        pimpdc.faf = {
            "lines_max": 0,
            "lines_onnet": 0,
            "lines_offnet": 0,
            "lines_DDI": 0,
            "lines_fixed": 0, 
            "lines_mobile": 0
        };
        pimpdc.pricingElement=0;
        pimpdc.type = "";
        
        function init() {
            /*$scope.records[0].Product2.%vlocity_namespace%__JSONAttribute__c = JSON.parse($scope.records[0].Product2.%vlocity_namespace%__JSONAttribute__c);*/
            
            /* 
            {value: "ONNET", id: 10, displayText: "A Personal"}
            
            {value: "OFFNET", id: 20, displayText: "A otras compañias"}
            
            {value: "NODISTINGUE", id: 30, displayText: "Todo Destino"}
            */
            pimpdc.type = $scope.records[0].Product2.%vlocity_namespace%__Type__c;
            pimpdc.pricingElement=$scope.records[0].PricingElement.value;
            if($scope.records[0].Product2.%vlocity_namespace%__Type__c == "Numeros Amigos"){
                
                angular.forEach($scope.records[0].Product2.%vlocity_namespace%__JSONAttribute__c, function(itemfam){
                    
                        for(var k=0; k<itemfam.length; k++){
                            
                            if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas Total"){
                                
                                pimpdc.faf.lines_max = itemfam[k].attributeRunTimeInfo.default;
                                
                            }else if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas ONNET"){
                                
                                pimpdc.faf.lines_onnet = itemfam[k].attributeRunTimeInfo.default;
                                
                            } else if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas OFFNET"){
                                
                                pimpdc.faf.lines_offnet = itemfam[k].attributeRunTimeInfo.default;
                                
                            } else if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas DDI"){
                                
                                pimpdc.faf.lines_DDI = itemfam[k].attributeRunTimeInfo.default;
                                
                            } else if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas Fijas"){
                                
                                pimpdc.faf.lines_fixed = itemfam[k].attributeRunTimeInfo.default;
                                
                            } else if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas Moviles"){
                                
                                pimpdc.faf.lines_mobile = itemfam[k].attributeRunTimeInfo.default;
                                
                            }
                        }
                    
                });
            }
            
            if($scope.records.length>0  && $scope.records[0].childProducts && $scope.records[0].childProducts.records && $scope.records[0].childProducts.records.length>0){
                
                pimpdc.items = $scope.records[0].childProducts;
                console.info('pimpdc.items: ', pimpdc.items);
                for(var i=0;i<pimpdc.items.records.length;i++) {
                    
                    var item_child = {
                        "type": $scope.records[0].Product2.%vlocity_namespace%__Type__c,
                        "service_type": "",
                        "service_free_units": "",
                        "service_unit": "",
                        "service_coverage": "",
                        "service_use": "",
                        "faf": pimpdc.faf
                    };
                    
                    pimpdc.items.records[i].Product2.%vlocity_namespace%__JSONAttribute__c = JSON.parse(pimpdc.items.records[i].Product2.%vlocity_namespace%__JSONAttribute__c);
                    
                    angular.forEach(pimpdc.items.records[i].Product2.%vlocity_namespace%__JSONAttribute__c, function(item){             
                        
                        for(var j=0; j<item.length; j++){
                            
                            if(item[j].attributedisplayname__c == "Tipo de Servicio"){
                                
                                item_child.service_type = item[j].value__c;
                                
                            }else if (item[j].attributedisplayname__c == "Cantidad Unidades Libres"){
                                
                                item_child.service_free_units = item[j].value__c;
                                
                            }else if (item[j].attributedisplayname__c == "Unidad de Medida de Cantidad" && item[j].attributeRunTimeInfo.default[0].displayText !== "item" ){
                                
                                item_child.service_unit = item[j].attributeRunTimeInfo.default[0].displayText;
                                
                            }else if (item[j].attributedisplayname__c == "Cobertura Uso Servicio" && item[j].attributeRunTimeInfo.default.length>0){
                                
                                item_child.service_coverage = item[j].attributeRunTimeInfo.default[0].displayText;
                                
                            }else if (item[j].attributedisplayname__c == "Red de Uso Servicio" && item[j].attributeRunTimeInfo.default.length>0){
                                
                                item_child.service_use = item[j].attributeRunTimeInfo.default[0].displayText;
                            }
                            
                        }
                    }); 
    
                    console.info(item_child);
                    pimpdc.childs.push(item_child);
                    
                }
            } else {
                
                
                console.info("THE PRODUCT HAS NOT CHILDS");
                
                var item_child = {
                    "type": $scope.records[0].Product2.%vlocity_namespace%__Type__c,
                    "service_type": "",
                    "service_free_units": "",
                    "service_unit": "",
                    "service_coverage": "",
                    "service_use": "",
                    "faf": pimpdc.faf
                }
                    
                angular.forEach($scope.records[0].Product2.%vlocity_namespace%__JSONAttribute__c, function(item){      
                    
                    for(var j=0; j<item.length; j++){
                        
                        if(item[j].attributedisplayname__c == "Tipo de Servicio"){
                            
                            item_child.service_type = item[j].value__c;
                            
                        }else if (item[j].attributedisplayname__c == "Cantidad Unidades Libres"){
                            
                            item_child.service_free_units = item[j].value__c;
                            
                        }else if (item[j].attributedisplayname__c == "Unidad de Medida de Cantidad" &&  item[j].attributeRunTimeInfo.default.length>0  && item[j].attributeRunTimeInfo.default[0].displayText !== "item" ){
                            
                            item_child.service_unit = item[j].attributeRunTimeInfo.default[0].displayText;
                            
                        }else if (item[j].attributedisplayname__c == "Cobertura Uso Servicio" && item[j].attributeRunTimeInfo.default.length>0){
                            
                            item_child.service_coverage = item[j].attributeRunTimeInfo.default[0].displayText;
                            
                        }
                    }
                });
            
                console.info(item_child);
                pimpdc.childs.push(item_child);
            } 
            
            console.info(pimpdc.childs);
        }
    }