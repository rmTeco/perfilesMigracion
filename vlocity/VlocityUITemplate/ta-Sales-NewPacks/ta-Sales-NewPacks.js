vlocity
    .cardframework
    .registerModule
    .controller('PacksItemsDetailController', PacksItemsDetailController);
    
    /*Esta muy raro no carga los packs */ 
    
    PacksItemsDetailController.$inject = ['$scope', '$rootScope', '$timeout'];
    
    function PacksItemsDetailController($scope, $rootScope, $timeout) {
        
        var pidc = this;
        
        pidc.errorRetry = true;
        pidc.showSpinner = true;
        pidc.arrayItemsGroup=[];
        pidc.showList = false;
        pidc.init = init;
        pidc.getCartsProductsById = getCartsProductsById;
        pidc.manageRecursiveGroups = manageRecursiveGroups;
        pidc.getExpandedItems = getExpandedItems;
        pidc.addToCart = addToCart;
        pidc.deleteCartItem = deleteCartItem;
        pidc.total = 0; 
        $scope.bpTree.response.packSelectedToCart = false;
        $scope.bpTree.response.showErrorTemplate = false;
        $scope.$watch('pidc.arrayItemsGroup.length', function (newVal, oldVal) {
            
            console.info("watch arrayItemsGroup");
            console.info(pidc.arrayItemsGroup);
        
        }, true);
        
        $scope.$watch('pidc.showSpinner', function (newVal, oldVal) {
            
            console.info("watch showSpinner", pidc.showSpinner);
            
        }, true);
        
        $scope.$watch('bpTree.response.records', function (newVal, oldVal) {
            
            console.info("watch bpTree.response.records", $scope.bpTree.response.records);
            console.info("watch bpTree.response.records STRINGIFY ", JSON.stringify($scope.bpTree.response.records));
            if(newVal !== undefined && oldVal === undefined){
                init();
            }
            
        }, true);
        
      /*  $scope.$watch('bpTree.response.cartId', function (newVal, oldVal) {
            
            
            if(newVal !== undefined && oldVal === undefined){
                console.info("cartId: ", $scope.bpTree.response.cartId);
                 
            }
            
            
        }, true);*/
        
        function showNotificationTimeOut(message, severity) {
            pidc.showNotification = true;
            pidc.severity = severity;
            pidc.message = message;
            $timeout(function() {
                pidc.showNotification = false;
                pidc.severity = "";
                pidc.message = "";
            }, 3000);
        }
        
        
        function init(){
            console.info($scope.bpTree);
            console.info("Hola, new packs && services! ");
            if($scope.bpTree.response.operationFlow == "Alta Baja Servicios"){
                pidc.operationCode = "Services";
            } else if($scope.bpTree.response.operationFlow == "Compra de Pack"){
                pidc.operationCode = "Packs Opcionales";
            }
            manageRecursiveGroups($scope.bpTree.response.records);
        }
        
        function manageRecursiveGroups(records){
            console.info('manageRecursiveGroups: ', $scope.bpTree.response.records);
            angular.forEach(records, function(valueRecords, keyRecords) {
                console.info('manageRecursiveGroups:valueRecords: ', valueRecords);
                
                if(valueRecords.productGroups){
                    
                    pidc.manageRecursiveRecords = valueRecords.productGroups.records;

                } else if(valueRecords.nameResult && valueRecords.nameResult.productGroups){
                    
                    pidc.manageRecursiveRecords = valueRecords.nameResult.productGroups.records;
                    
                } else {
                    
                    pidc.manageRecursiveRecords = [];
                    
                }
                
                angular.forEach(pidc.manageRecursiveRecords, function(value, key) {

                    if( (value.Name && value.Name.value === pidc.operationCode) || (valueRecords.fields && valueRecords.fields.Name && valueRecords.fields.Name.value === pidc.operationCode)){
                        console.info("Line 81 Compra packs")
                        if(value.actions && value.actions.expanditems && value.actions.expanditems.remote &&  value.actions.expanditems.remote.params && value.actions.expanditems.remote.params.cartId && value.actions.expanditems.remote.params.itemId && value.actions.expanditems.remote.params.productHierarchyPath){
                            console.info(value.actions.expanditems.remote.params);
                            var cartId = value.actions.expanditems.remote.params.cartId;
                            var itemId = value.actions.expanditems.remote.params.itemId;
                            var productHierarchyPath = value.actions.expanditems.remote.params.productHierarchyPath;
                            console.info(' cartId: '+ cartId + ' itemId: ' + itemId + ' productHierarchyPath: ' + productHierarchyPath);
                            getExpandedItems(cartId, itemId, productHierarchyPath, keyRecords, key, null);    

                        }   
                        
                    } else if(pidc.operationCode == "Services" && value.Name.value !== "Packs Opcionales"){
                        console.info("Line 94 ABM Services"); 
                        console.info("value: ", value);
                        console.info("valueRecords: ", valueRecords);
                        
                        //Data para alta baja de servicios disponibles para el plan Ver como llenar el data record 
                        
                        var data = {
                            "type": pidc.operationCode,
                            "productGroup": value, 
                            "dataRecords": {"childProducts": "", "lineItems": [], "productGroups": {"records": ""}},
                            "hideItems": true,
                            "errorRetry": true
                        }
                        pidc.arrayItemsGroup.push(data);
                        pidc.showSpinner=false;
                    }
                    
                });
        
            });
            
        }
        
        function addToCart(itemData, parent, index, dataRecords, child, itemType){
            /* Agregar itemType para childProduct, lineItem */ 
            console.info("addToCart");
            console.info("itemData: ", itemData);
            console.info("dataRecords: ", dataRecords);
            console.info("-parent: "+ parent+ " -index: "+ index + " -child: "+ child);
            pidc.showSpinner=true;
            console.info(dataRecords);
            var items = dataRecords.params.items[0];
            items.cartId = dataRecords.params.cartId;
            items.methodName = dataRecords.params.methodName;
            items.product2Id = itemData.Product2 ? itemData.Product2.Id : itemData.fields.Product2.Id;
            items.name = itemData.Product2 ? itemData.Product2.Name : itemData.fields.Product2.Name;
            items.id = itemData.Id ? itemData.Id.value : itemData.fields.Id.value ;
            
            console.info(JSON.stringify(items));
            
            Visualforce.remoting.Manager.invokeAction("taOrderController.addToCartItems", items, function(response) {
                console.info("-parent: "+ parent+ " -index: "+ index + " -child: "+ child);
                console.info("response addToCart: ", response);
                console.info("response addToCart STRING: ", JSON.stringify(response));
                if(response.result && response.result.records[0] && response.result.records[0].nameResult.lineItems){
                    $scope.bpTree.response.packSelectedToCart = true;
                    $scope.bpTree.response.showErrorTemplate = false;
                    /*getCarts($scope.bpTree.response.cartId);*/
                    /* dos cassos: childProducts, lineItems */ 
                    if(response.result.records[0].nameResult.lineItems.records[0].fields.%vlocity_namespace%__OneTimeCharge__c){
                        console.info(response.result.records[0].nameResult.lineItems.records[0].fields.%vlocity_namespace%__OneTimeCharge__c.value);
                        pidc.total += response.result.records[0].nameResult.lineItems.records[0].fields.%vlocity_namespace%__OneTimeCharge__c.value;
                        console.info(pidc.total);
                    }
                    
                    if(itemType === 'childProducts'){
                        
                        console.info("childProducts");
                    
                        if(child === null){
                            console.info("childProducts: child is null ");
                            if(pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].nameResult.lineItems && pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].nameResult.lineItems.records && pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].nameResult.lineItems.records.length > 0){
                                for(var t=0; t<response.result.records[0].nameResult.lineItems; t++){
                                    pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].nameResult.lineItems.records.push(response.result.records[0].nameResult.lineItems.records[t]);
                                }
                                
                            } else {
                                pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].nameResult.lineItems={
                                                                        "records":response.result.records[0].nameResult.lineItems.records
                                                                    };
                            }
                            
                        } else {
                            console.info("childProducts: child is not null ");
                            pidc.arrayItemsGroup[parent].dataRecords.productGroups.records[index].nameResult.childProducts[child].nameResult.lineItems = {
                                "records" : response.result.records[0].nameResult.lineItems.records
                            }
                        }
                    } else if (itemType === 'lineItems'){
                        
                        console.info("lineItems");
                        
                        if(child === null){
                            console.info("lineItems: child is null ");
                            if(pidc.arrayItemsGroup[parent].dataRecords.lineItems[index].nameResult.lineItems && pidc.arrayItemsGroup[parent].dataRecords.lineItems[index].nameResult.lineItems.records && pidc.arrayItemsGroup[parent].dataRecords.lineItems[index].nameResult.lineItems.records.length > 0){
                                for(var t=0; t<response.result.records[0].nameResult.lineItems; t++){
                                    pidc.arrayItemsGroup[parent].dataRecords.lineItems[index].nameResult.lineItems.records.push(response.result.records[0].nameResult.lineItems.records[t]);
                                }
                                
                            } else {
                                pidc.arrayItemsGroup[parent].dataRecords.lineItems[index].nameResult.lineItems={
                                                                        "records":response.result.records[0].nameResult.lineItems.records
                                                                    };
                            }
                            
                        } else {
                            console.info("lineItems: child is not null ");
                            pidc.arrayItemsGroup[parent].dataRecords.lineItems.records[index].nameResult.childProducts[child].nameResult.lineItems = {
                                "records" : response.result.records[0].nameResult.lineItems.records
                            }
                        }
                        
                        
                    }
                    
                    
                    showNotificationTimeOut("Agregado exitosamente.", "success"); 
                    
                } else {
                    showNotificationTimeOut("Ha ocurrido un error.", "error");
                }
                pidc.showSpinner=false;
                console.info("addToCart:pidc.arrayItemsGroup", pidc.arrayItemsGroup);
                $scope.$apply();                           
                            
            }, 
            {escape: false}
            );

        }
        
        
/*
        function getCarts(cartId){
            

            Visualforce.remoting.Manager.invokeAction("taOrderController.getCarts", cartId, function(response) {
                
                console.info(response.result);
                            
            }, 
            {escape: false}
            );
            
            
        }*/
        

        function deleteCartItem(itemData, parent, index, dataRecord, child, itemType){
            
            /*ver para itemType childProduct, lineItem, */ 
            console.info("array: ", pidc.arrayItemsGroup[parent]);
            console.info("deleteCartItem");
            console.info("itemData: ", itemData);
            console.info("dataRecord: ", dataRecord);
            pidc.showSpinner=true;
            var items = {
                "methodName": dataRecord.params.methodName, 
                "cartId": dataRecord.params.cartId,
                "Id": dataRecord.params.id,
                "product2Id": itemData.Product2 ? itemData.Product2.Id : itemData.fields.Product2.Id,
                "name": itemData.Product2 ? itemData.Product2.Name : itemData.fields.Product2.Name,
                "groupId":  itemData.Id ? itemData.Id.value : itemData.fields.Id.value,
                "parentHierarchyPath": itemData.productHierarchyPath ? itemData.productHierarchyPath : itemData.fields.productHierarchyPath,
                "inCartQuantityId": pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].fields.Product2.Id
            }

            console.info(JSON.stringify(items));
            Visualforce.remoting.Manager.invokeAction("taOrderController.deleteCartItem", items, function(response) {
                            
                console.info("response deleteCartItem: ", response);
                console.info("response deleteCartItem: STRING", JSON.stringify(response));
                
                console.info("parent: " +parent+ " index: "+ index + " child: "+ child);
                console.info(response.result.messages[0]);
                pidc.showSpinner=false;
                if(response.result.messages[0].severity === "INFO" && response.result.messages[0].code === "152"){
                    $scope.bpTree.response.packSelectedToCart = false;
                    
                    /*getCarts($scope.bpTree.response.cartId);*/
                    showNotificationTimeOut("Eliminado exitosamente.", "success");
                    if(!child){
                        /* Restar item del total a pagar */ 
                        if(pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].nameResult.lineItems.records[0].fields.%vlocity_namespace%__OneTimeCharge__c){
                            console.info(pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].nameResult.lineItems.records[0].fields.%vlocity_namespace%__OneTimeCharge__c.value);
                            pidc.total -= pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].nameResult.lineItems.records[0].fields.%vlocity_namespace%__OneTimeCharge__c.value;
                            console.info(pidc.total);
                        }
                        delete pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].nameResult.lineItems;
                    } else {
                        /* Restar item del total a pagar */ 
                        if(pidc.arrayItemsGroup[parent].dataRecords.productGroups.records[index].childProducts[child].nameResult.lineItems.records[0].fields.%vlocity_namespace%__OneTimeCharge__c){
                            console.info(pidc.arrayItemsGroup[parent].dataRecords.productGroups.records[index].childProducts[child].nameResult.lineItems.records[0].fields.%vlocity_namespace%__OneTimeCharge__c.value);
                            pidc.total -= pidc.arrayItemsGroup[parent].dataRecords.productGroups.records[index].childProducts[child].nameResult.lineItems.records[0].fields.%vlocity_namespace%__OneTimeCharge__c.value;
                            console.info(pidc.total);
                        }
                        delete pidc.arrayItemsGroup[parent].dataRecords.productGroups.records[index].childProducts[child].nameResult.lineItems;
                    }
                    
                    
                }else {
                    console.info("SHOW ERROR");
                    showNotificationTimeOut("Ha ocurrido un error.", "error");
                }
                
                $scope.$apply();
                            
            }, 
            {escape: false}
            );
            
            
        }
        
        function getCartsProductsById(actionData, parent, index){
            console.info("getCartsProductsById");
            pidc.showSpinner=true;
            var data = {
                "cartId": actionData.cartId, 
                "productId": actionData.id
            }
            /* AJUSTAR ESTA VALIDACIÓN DE CERRAR EL VER MAS PARA ABM SERVICIOS */ 
            if(pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].showMoreInfo === true){
                
                pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].showMoreInfo = false;
                pidc.showSpinner=false;
                
            } else if(pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].showMoreInfo === false && pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].moreInfo && pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].moreInfo.length > 0){
                
                for(var t=0; t<pidc.arrayItemsGroup[parent].dataRecords.childProducts.length; t++){
                    
                    pidc.arrayItemsGroup[parent].dataRecords.childProducts[t].showMoreInfo = false;
                    
                }
                
                pidc.showSpinner=false;
                pidc.arrayItemsGroup[parent].dataRecords.childProducts[t].showMoreInfo = true;
                
            } else {
                
                for(var q=0; q<pidc.arrayItemsGroup[parent].dataRecords.childProducts.length; q++){
                    
                    pidc.arrayItemsGroup[parent].dataRecords.childProducts[q].showMoreInfo = false;
                    
                }
            
                Visualforce.remoting.Manager.invokeAction("taOrderController.getCartsProductsById", data, function(response) {
                    
                    console.info("taOrderController.getCartsProductsById:response: ", response);
                    
                    
                    if(response.result.records.length > 0){
        
                        pidc.childs = [];
                        pidc.faf = {
                            "lines_max": 0,
                            "lines_onnet": 0,
                            "lines_offnet": 0,
                            "lines_DDI": 0,
                            "lines_fixed": 0, 
                            "lines_mobile": 0
                        };
                        pidc.pricingElement=0;
                        pidc.type = "";
        
                        /* 
                        {value: "ONNET", id: 10, displayText: "A Personal"}
                        
                        {value: "OFFNET", id: 20, displayText: "A otras compañias"}
                        
                        {value: "NODISTINGUE", id: 30, displayText: "Todo Destino"}
                        */
                        pidc.type = response.result.records[0].fields.Product2.%vlocity_namespace%__Type__c;
                        pidc.pricingElement=response.result.records[0].fields.PricingElement.value;
                        if(response.result.records[0].fields.Product2.%vlocity_namespace%__Type__c == "Numeros Amigos"){
                            
                            angular.forEach(response.result.records[0].fields.Product2.%vlocity_namespace%__JSONAttribute__c, function(itemfam){
                                
                                    for(var k=0; k<itemfam.length; k++){
                                        
                                        if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas Total"){
                                            
                                            pidc.faf.lines_max = itemfam[k].attributeRunTimeInfo.default;
                                            
                                        }else if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas ONNET"){
                                            
                                            pidc.faf.lines_onnet = itemfam[k].attributeRunTimeInfo.default;
                                            
                                        } else if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas OFFNET"){
                                            
                                            pidc.faf.lines_offnet = itemfam[k].attributeRunTimeInfo.default;
                                            
                                        } else if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas DDI"){
                                            
                                            pidc.faf.lines_DDI = itemfam[k].attributeRunTimeInfo.default;
                                            
                                        } else if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas Fijas"){
                                            
                                            pidc.faf.lines_fixed = itemfam[k].attributeRunTimeInfo.default;
                                            
                                        } else if(itemfam[k].attributedisplayname__c == "Cantidad Maxima de Lineas Moviles"){
                                            
                                            pidc.faf.lines_mobile = itemfam[k].attributeRunTimeInfo.default;
                                            
                                        }
                                    }
                                
                            });
                        }
                        
                        if(response.result.records.length>0  && response.result.records[0].nameResult.childProducts && response.result.records[0].nameResult.childProducts.records && response.result.records[0].nameResult.childProducts.records.length>0){
                            
                            pidc.items = response.result.records[0].nameResult.childProducts;
                            console.info('pidc.items: ', pidc.items);
                            for(var i=0;i<pidc.items.records.length;i++) {
                                
                                var item_child = {
                                    "type": response.result.records[0].fields.Product2.%vlocity_namespace%__Type__c,
                                    "service_type": "",
                                    "service_free_units": "",
                                    "service_unit": "",
                                    "service_coverage": "",
                                    "service_use": "",
                                    "service_description": "",
                                    "service_validity": "",
                                    "service_validity_unit": "",
                                    "faf": pidc.faf
                                };
                                
                                pidc.items.records[i].fields.Product2.%vlocity_namespace%__JSONAttribute__c = JSON.parse(pidc.items.records[i].fields.Product2.%vlocity_namespace%__JSONAttribute__c);
                                
                                angular.forEach(pidc.items.records[i].fields.Product2.%vlocity_namespace%__JSONAttribute__c, function(item){
    
                                    for(var j=0; j<item.length; j++){
                                        
                                        if(item[j].attributedisplayname__c == "Tipo de Servicio"){
                                            
                                            item_child.service_type = item[j].value__c;
                                            
                                        }else if (item[j].attributedisplayname__c == "Cantidad Unidades Libres"){
                                            
                                            item_child.service_free_units = item[j].value__c;
                                            
                                        }else if (item[j].attributedisplayname__c == "Unidad de Medida de Cantidad" && item[j].attributeRunTimeInfo.default[0] && item[j].attributeRunTimeInfo.default[0].displayText !== "item" ){
                                            
                                            item_child.service_unit = item[j].attributeRunTimeInfo.default[0].displayText;
                                            
                                        }else if (item[j].attributedisplayname__c == "Cobertura Uso Servicio" && item[j].attributeRunTimeInfo.default && item[j].attributeRunTimeInfo.default.length>0){
                                            
                                            item_child.service_coverage = item[j].attributeRunTimeInfo.default[0].displayText;
                                            
                                        }else if (item[j].attributedisplayname__c == "Red de Uso Servicio" && item[j].attributeRunTimeInfo.default && item[j].attributeRunTimeInfo.default.length>0){
                                            
                                            item_child.service_use = item[j].attributeRunTimeInfo.default[0].displayText;
                                            
                                        }else if (item[j].attributedisplayname__c == "Descripcion de Uso" && item[j].attributeRunTimeInfo.default && item[j].attributeRunTimeInfo.default.length>0){
                                            
                                            item_child.service_description = item[j].value__c;
                                            
                                            console.info("Descripción: " + item[j].value__c);
                                        }else if (item[j].attributedisplayname__c == "Vigencia Unidades Libres" && item[j].attributeRunTimeInfo.default && item[j].attributeRunTimeInfo.default.length>0){
                                            
                                            item_child.service_validity = item[j].value__c;
                                        }else if (item[j].attributedisplayname__c == "Unidad de Medida de Vigencia" && item[j].attributeRunTimeInfo.default && item[j].attributeRunTimeInfo.default.length>0){
                                            var value = item[j].attributeRunTimeInfo.default[0].displayText;
                                            if(value == "dia" && item_child.service_validity === "1"){
                                                value = "día";
                                            } else if(value == "dia" && item_child.service_validity !== "1"){
                                                value = "días";
                                            }
                                            
                                            item_child.service_validity_unit = value;    
                                            
                                            
                                            console.info("service_validity_unit: "+ item_child.service_validity_unit);
                                            
                                        }
                                        
                                    }
                                            
                                }); 
    
                                console.info(item_child);
                                pidc.childs.push(item_child);
    
                            }
                        } else {
                            
                            
                            console.info("THE PRODUCT HAS NOT CHILDS");
                            
                            var item_child = {
                                "type": response.result.records[0].fields.Product2.%vlocity_namespace%__Type__c,
                                "service_type": "",
                                "service_free_units": "",
                                "service_unit": "",
                                "service_coverage": "",
                                "service_use": "",
                                "service_description": "",
                                "service_validity": "",
                                "service_validity_unit": "",
                                "faf": pidc.faf
                            }
                                
                            angular.forEach(response.result.records[0].fields.Product2.%vlocity_namespace%__JSONAttribute__c, function(item){      
                                
                                for(var j=0; j<item.length; j++){
                                    
                                    if(item[j].attributedisplayname__c == "Tipo de Servicio"){
                                        
                                        item_child.service_type = item[j].value__c;
                                        
                                    }else if (item[j].attributedisplayname__c == "Cantidad Unidades Libres"){
                                        
                                        item_child.service_free_units = item[j].value__c;
                                        
                                    }else if (item[j].attributedisplayname__c == "Unidad de Medida de Cantidad" &&  item[j].attributeRunTimeInfo.default && item[j].attributeRunTimeInfo.default.length>0  && item[j].attributeRunTimeInfo.default[0].displayText !== "item" ){
                                        
                                        item_child.service_unit = item[j].attributeRunTimeInfo.default[0].displayText;
                                        
                                    }else if (item[j].attributedisplayname__c == "Cobertura Uso Servicio" && item[j].attributeRunTimeInfo.default &&  item[j].attributeRunTimeInfo.default.length>0){
                                        
                                        item_child.service_coverage = item[j].attributeRunTimeInfo.default[0].displayText;
                                        
                                    }else if(item[j].attributedisplayname__c == "Descripcion de Uso"){
                                        
                                        item_child.service_description = item[j].value__c;
                                        
                                    }else if (item[j].attributedisplayname__c == "Vigencia Unidades Libres" && item[j].attributeRunTimeInfo.default && item[j].attributeRunTimeInfo.default.length>0){
                                            
                                        item_child.service_validity = item[j].value__c;
                                    }else if (item[j].attributedisplayname__c == "Unidad de Medida de Vigencia" && item[j].attributeRunTimeInfo.default && item[j].attributeRunTimeInfo.default.length>0){
                                        
                                        item_child.service_validity_unit = item[j].attributeRunTimeInfo.default[0].displayText;
                                    }
                                }
                            });
                        
                            console.info(item_child);
                            pidc.childs.push(item_child);
                        } 
                        
                        console.info("pidc.childs: ", pidc.childs);
                        console.info("parent: "+ parent + " index: " + index);
                        pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].moreInfo = pidc.childs;
                        pidc.arrayItemsGroup[parent].dataRecords.childProducts[index].showMoreInfo = true;
                        console.info("childProducts: ", pidc.arrayItemsGroup[parent].dataRecords.childProducts[index]);
    
                    }
                    
                    pidc.showSpinner=false;
                    $scope.$apply();
                                
                }, 
                {escape: false}
                );
            
            }
            
        }

        function getExpandedItems(cartId, itemId, productHierarchyPath, index, child, itemType) {
            console.info("getExpandedItems");
            console.info(" index: "+ index + " child: " +child);
            pidc.showSpinner=true;
            
            if(pidc.arrayItemsGroup[index]){
                
                console.info("pidc.arrayItemsGroup[index]: ", pidc.arrayItemsGroup[index]);
                
            }
            
            
            if(pidc.arrayItemsGroup[index] && pidc.arrayItemsGroup[index].hideItems === false && (pidc.arrayItemsGroup[index].dataRecords.childProducts.length > 0 || pidc.arrayItemsGroup[index].dataRecords.lineItems.length > 0 || pidc.arrayItemsGroup[index].dataRecords.productGroups.records.length > 0)  && itemType !== 'productGroups' ){
                console.info("1");
                pidc.arrayItemsGroup[index].hideItems = true;
                pidc.showSpinner=false;
            } else if(pidc.arrayItemsGroup[index] && pidc.arrayItemsGroup[index].hideItems === true && (pidc.arrayItemsGroup[index].dataRecords.childProducts.length > 0 || pidc.arrayItemsGroup[index].dataRecords.lineItems.length > 0 || pidc.arrayItemsGroup[index].dataRecords.productGroups.records.length > 0)  && itemType !== 'productGroups' ){
                pidc.arrayItemsGroup[index].hideItems = false;
                pidc.showSpinner=false;
                console.info("2");
            }  else if(pidc.arrayItemsGroup[index] && pidc.arrayItemsGroup[index].dataRecords.productGroups.records.length > 0  && itemType === 'productGroups' && pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].hideItems === false && ((pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.childProducts && pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.childProducts.length > 0) || (pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.lineItems && pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.lineItems.length > 0)  || (pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.productGroups && pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.productGroups.length > 0) )){
                console.info("3");
                pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].hideItems = true;
                pidc.showSpinner=false;
                
            } else if(pidc.arrayItemsGroup[index] && pidc.arrayItemsGroup[index].dataRecords.productGroups.records.length > 0  && itemType === 'productGroups' && pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].hideItems === true && ((pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.childProducts && pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.childProducts.length > 0) || (pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.lineItems && pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.lineItems.length > 0)  || (pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.productGroups && pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.productGroups.length > 0) )){
                console.info("4");
                pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].hideItems = false;
                pidc.showSpinner=false;
                
            } else {
                console.info("5");
                Visualforce.remoting.Manager.invokeAction(
                    "taOrderController.getExpandedPacksItems", cartId, itemId, productHierarchyPath,
                            function(response) {
                                
                                console.info("getExpandedItems:response", response);
                                if(response === null && pidc.arrayItemsGroup[index] && itemType !== 'productGroups' ){
                                    pidc.arrayItemsGroup[index].errorRetry = false;
                                    pidc.arrayItemsGroup[index].hideItems = true;
                                } else if(pidc.arrayItemsGroup[index] && response !== null && itemType !== 'productGroups' ){
                                    pidc.arrayItemsGroup[index].errorRetry = true;
                                } else if(response === null && !pidc.arrayItemsGroup[index] && itemType !== 'productGroups' ){
                                    pidc.errorRetry = false; 
                                } else if(response !== null && !pidc.arrayItemsGroup[index]){
                                    pidc.errorRetry = true;
                                }
                                
                                if(response && response.result && response.result.records && pidc.arrayItemsGroup.length === 0){
                                    for(var i=0; i<response.result.records.length; i++){
                                        if(response.result.records[i].nameResult && response.result.records[i].nameResult.productGroups &&  response.result.records[i].nameResult.productGroups.records){
                                            
                                            for(var j=0; j<response.result.records[i].nameResult.productGroups.records.length; j++){
                                                
                                                if(response.result.records[i].nameResult.productGroups.records[j].fields && response.result.records[i].nameResult.productGroups.records[j].fields.Name && response.result.records[i].nameResult.productGroups.records[j].fields.Name.value){
                                                    
                                                    
                                                    var data = {
                                                        "type": pidc.operationCode,
                                                        "productGroup": response.result.records[i].nameResult.productGroups.records[j], 
                                                        "dataRecords": {"childProducts": "", "lineItems": [], "productGroups": {"records": ""}},
                                                        "hideItems": true,
                                                        "errorRetry": true
                                                    }
                                                    pidc.arrayItemsGroup.push(data);
                                                    
                                                }
                                                
                                            }
                                        
                                        }
                                    }
    
                                } else if(response && response.result && response.result.records && index !== undefined && pidc.arrayItemsGroup.length > 0){
                                    console.info("Line 258");
                                    console.info("arrayItemsGroup: ", pidc.arrayItemsGroup[index]);
                                    if(pidc.arrayItemsGroup[index].hideItems === true && itemType !== 'productGroups' ){
                                        pidc.arrayItemsGroup[index].hideItems = false;
                                        
                                        /*La primera vez que se llena dataRecords*/ 
                                            
                                        for(var i=0; i<response.result.records.length; i++){
                                            
                                            if(pidc.arrayItemsGroup[index].dataRecords.childProducts === ""){
                                            
                                                if(response.result.records[i].nameResult && response.result.records[i].nameResult.childProducts &&  response.result.records[i].nameResult.childProducts.records){
                                                    pidc.arrayItemsGroup[index].dataRecords.childProducts = response.result.records[i].nameResult.childProducts.records;
                                                }
                                                
                                                /*Verificamos si el productGroup posee Line Items para asignarlos */
                                                if(response.result.records[i].nameResult && response.result.records[i].nameResult.lineItems && response.result.records[i].nameResult.lineItems.records){
                                                    console.info("line 275 index: ", index);
                                                    
                                                    if(pidc.arrayItemsGroup[index].dataRecords.childProducts === ""){
                                                        pidc.arrayItemsGroup[index].dataRecords.childProducts = response.result.records[i].nameResult.lineItems.records;
                                                    }
                                                    
                                                    console.info("pidc.arrayItemsGroup[index]: ", pidc.arrayItemsGroup[index]);
                                                    /*Aca llenamos los line Items por el data record */ 
                                                    for(var k=0; k<response.result.records[i].nameResult.lineItems.records.length; k++){
                                                        
                                                        for(var g=0; g<pidc.arrayItemsGroup[index].dataRecords.childProducts.length; g++){
                                                            /*Asignarle al data record child sus line items */ 
                                                            if((pidc.arrayItemsGroup[index].dataRecords.childProducts[g].fields.Product2Id.value === response.result.records[i].nameResult.lineItems.records[k].fields.Product2Id) || (pidc.arrayItemsGroup[index].dataRecords.childProducts[g].fields.Product2Id === response.result.records[i].nameResult.lineItems.records[k].fields.Product2Id) ){
                                                                pidc.arrayItemsGroup[index].dataRecords.childProducts[g].nameResult.lineItems={
                                                                    "records":[]
                                                                };
                                                                pidc.arrayItemsGroup[index].dataRecords.childProducts[g].nameResult.lineItems.records.push(response.result.records[i].nameResult.lineItems.records[k]);
                                                                response.result.records[i].nameResult.lineItems.records[k].isChild = true; 
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                }

                                            }
                                            
                                            if(pidc.arrayItemsGroup[index].dataRecords.lineItems.length === 0){
                                                console.info("lineItems.length === 0");
                                                if(response.result.records[i].nameResult && response.result.records[i].nameResult.lineItems &&  response.result.records[i].nameResult.lineItems.records){
                                                    for(var p=0; p<response.result.records[i].nameResult.lineItems.records.length; p++){
                                                        console.info(response.result.records[i].nameResult.lineItems.records[p].isChild);
                                                        if(typeof response.result.records[i].nameResult.lineItems.records[p].isChild === "undefined"){
                                                            pidc.arrayItemsGroup[index].dataRecords.lineItems.push(response.result.records[i].nameResult.lineItems.records[p]);
                                                        }
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                            if(pidc.arrayItemsGroup[index].dataRecords.productGroups.records === ""){
                                                    
                                                if(response.result.records[i].nameResult && response.result.records[i].nameResult.productGroups &&  response.result.records[i].nameResult.productGroups.records){
                                                    pidc.arrayItemsGroup[index].dataRecords.productGroups.records = response.result.records[i].nameResult.productGroups.records;
                                                    
                                                    for(var q=0; q<pidc.arrayItemsGroup[index].dataRecords.productGroups.records.length; q++){
                                                        
                                                        pidc.arrayItemsGroup[index].dataRecords.productGroups.records[q].hideItems = true;
                                                        pidc.arrayItemsGroup[index].dataRecords.productGroups.records[q].errorRetry = true; 
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    } else if(pidc.arrayItemsGroup[index].hideItems === false && itemType === 'productGroups'){
                                            
                                        console.info("itemType: ", itemType);
                                        console.info("index: ", index);
                                        console.info("child: ", child);
                                        
                                        if(itemType === 'productGroups' && pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child]){
                                            console.info("Is productGroups");
                                            
                                            for(var i=0; i<response.result.records.length; i++){
                                                if(response.result.records[i].nameResult && response.result.records[i].nameResult.childProducts &&  response.result.records[i].nameResult.childProducts.records){
                                                    if(pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].hideItems === true){
                                                        pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.childProducts = response.result.records[i].nameResult.childProducts.records;
                                                        pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].hideItems = false;
                                                        
                                                        for(var k=0; k<response.result.records[i].nameResult.lineItems.records.length; k++){
                                                        
                                                            for(var g=0; g<pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.childProducts.length; g++){
                                                                /*Asignarle al data record child sus line items */ 
                                                                if((pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.childProducts[g].fields.Product2Id.value === response.result.records[i].nameResult.lineItems.records[k].fields.Product2Id) || (pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.childProducts[g].fields.Product2Id === response.result.records[i].nameResult.lineItems.records[k].fields.Product2Id) ){
                                                                    pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.childProducts[g].nameResult.lineItems={
                                                                        "records":[]
                                                                    };
                                                                    pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].nameResult.childProducts[g].nameResult.lineItems.records.push(response.result.records[i].nameResult.lineItems.records[k]);
                                                                    response.result.records[i].nameResult.lineItems.records[k].isChild = true; 
                                                                }
                                                            }
                                                            
                                                        }
                                                        
                                                        
                                                    } else {
                                                        pidc.arrayItemsGroup[index].dataRecords.productGroups.records[child].hideItems = false; 
                                                    }
                                                    
                                                }
                                            }
                                            
                                        }
                                        
                                    } else {
                                        pidc.arrayItemsGroup[index].hideItems = true;
                                    }
                                    
                                    
                                    
                                }
                                
                                console.info("getExpandedItems:pidc.arrayItemsGroup", pidc.arrayItemsGroup);
                                pidc.showSpinner=false;
                                $scope.$apply();
                                
                                /*if(response.result.records){
                                    manageRecursiveGroups(response.result.records);
                                }*/
    
                            },
                    {escape: false} // No escaping, please
                );
                
            }
            
        }
        

    }