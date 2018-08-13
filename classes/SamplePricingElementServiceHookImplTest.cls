@isTest
private class SamplePricingElementServiceHookImplTest {
 
      static testMethod void PreInvokePricingElementServiceHookImpl() {
          Map<String, Object> inputMap = new Map<String, Object>();
          String matrixID = '';
          String pricingSvcVersionId = '';
          Map<String, Object> outMap = new Map<String, Object>();
          Map<String, Object> options = new Map<String, String>();
           List<Account>  Acc = TestDataFactory.createAccounts(1,'Consumer');
           vlocity_cmt__PriceList__c taPriceList = TestDataFactory.createPriceList('Telecom Price List');
            Order Ord = new order(Name='TestOrder',
                            AccountId=Acc[0].id,
                            EffectiveDate=Date.today(),
                            Status='Draft',
                            Pricebook2Id =Test.getStandardPricebookId(),
                            vlocity_cmt__PriceListId__c=taPriceList.Id,
                            Delivery_Method__c='Presencial',
                            vlocity_cmt__OriginatingChannel__c='Agentes' );
            insert Ord ;
           List<OrderItem>OI = TestDataFactory.createOrderItem(2,Ord);
           List<Product2>ProdList = [select id,name,ProductCode from product2];
           ProdList[0].Name='<<Your Set of Products>>';
           upsert ProdList;
           
           
        vlocity_cmt__CalculationProcedure__c testCalcProcedure = new vlocity_cmt__CalculationProcedure__c ();
        testCalcProcedure.Name ='Device_Pricing_Procedure';
        insert testCalcProcedure;
         
          vlocity_cmt__CalculationProcedureVersion__c testCalcVersion = new vlocity_cmt__CalculationProcedureVersion__c(vlocity_cmt__IsEnabled__c   = true,Name='Device_Pricing_Procedure V1 V1 ',
                                                                                                                     vlocity_cmt__CalculationProcedureId__c =testCalcProcedure.Id
                                                                                                                     ,vlocity_cmt__Priority__c =1
                                                                                                                     ,vlocity_cmt__VersionNumber__c =1);
        testCalcVersion.vlocity_cmt__Variables__c ='[{"name":"Reference Product Name","typeaheadDisplayName":"Reference Product Name","userDefined":false,"alias":"ReferenceProductName","isEditable":false,"dataType":"Text","matrixName":"MultiAttribute_Repair_Pricing_Matrix","index":0},{"name":"Reference External Id","typeaheadDisplayName":"Reference External Id","userDefined":false,"alias":"ReferenceExternalId","isEditable":false,"dataType":"Text","matrixName":"MultiAttribute_Repair_Pricing_Matrix","index":0},{"name":"Characteristic Name","typeaheadDisplayName":"Characteristic Name","userDefined":false,"alias":"CharacteristicName","isEditable":false,"dataType":"Text","matrixName":"MultiAttribute_Repair_Pricing_Matrix","index":0},{"name":"Characteristic Value","typeaheadDisplayName":"Characteristic Value","userDefined":false,"alias":"CharacteristicValue","isEditable":false,"dataType":"Text","matrixName":"MultiAttribute_Repair_Pricing_Matrix","index":0},{"name":"NRC","typeaheadDisplayName":"NRC ( MultiAttribute_Repair_Pricing_Matrix )","userDefined":false,"alias":"MultiAttribute_Repair_Pricing_Matrix__NRC","isEditable":false,"dataType":"Text","matrixName":"MultiAttribute_Repair_Pricing_Matrix","index":0},{"name":"MRC","typeaheadDisplayName":"MRC ( MultiAttribute_Repair_Pricing_Matrix )","userDefined":false,"alias":"MultiAttribute_Repair_Pricing_Matrix__MRC","isEditable":false,"dataType":"Text","matrixName":"MultiAttribute_Repair_Pricing_Matrix","index":0}]';
        insert testCalcVersion;
        
         vlocity_cmt__CalculationMatrix__c testMatrix = new vlocity_cmt__CalculationMatrix__c(name='MultiAttribute_Repair_Pricing_Matrix');
        insert testMatrix;
        
          vlocity_cmt__CalculationMatrixVersion__c testMatrixVersion = new vlocity_cmt__CalculationMatrixVersion__c(name='MultiAttribute_Device_Pricing_Matrix V1' ,  vlocity_cmt__CalculationMatrixId__c = testMatrix.id,vlocity_cmt__IsEnabled__c = true, vlocity_cmt__Priority__c = 10, vlocity_cmt__VersionNumber__c = 10);
        testMatrixVersion.vlocity_cmt__StartDateTime__c = Date.newInstance(2017, 01, 01);
        insert testMatrixVersion;
           
            list<vlocity_cmt__CalculationMatrixRow__c> calcSICMatrixRowList = new list<vlocity_cmt__CalculationMatrixRow__c>();
        calcSICMatrixRowList.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=testMatrixVersion.Id, Name='Header',
                                                                          vlocity_cmt__InputData__c='{"name":"Reference Product Name","listValues":null,"label":null,"headerType":"Input","displayOrder":10,"dataType":"Text"}'
                                                                         ));
        calcSICMatrixRowList.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=testMatrixVersion.Id, Name='Header',
                                                                          vlocity_cmt__InputData__c='{"name":"NRC","listValues":null,"label":null,"headerType":"Output","displayOrder":60,"dataType":"Text"}'
                                                                         ));
        
        calcSICMatrixRowList.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=testMatrixVersion.Id, Name='Header',
                                                                          vlocity_cmt__InputData__c='{"name":"Reference External Id","listValues":null,"label":null,"headerType":"Input","displayOrder":20,"dataType":"Text"}'
                                                                         ));
        calcSICMatrixRowList.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=testMatrixVersion.Id, Name='Header',
                                                                          vlocity_cmt__InputData__c='{"name":"Characteristic Name","listValues":null,"label":null,"headerType":"Input","displayOrder":30,"dataType":"Text"}'
                                                                         ));
        calcSICMatrixRowList.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=testMatrixVersion.Id, Name='Header',
                                                                          vlocity_cmt__InputData__c=' {"name":"Characteristic Value","listValues":null,"label":null,"headerType":"Input","displayOrder":40,"dataType":"Text"}' ));
        
        calcSICMatrixRowList.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=testMatrixVersion.Id, Name='Header',
                                                                          vlocity_cmt__InputData__c='{"name":"MRC","listValues":null,"label":null,"headerType":"Output","displayOrder":50,"dataType":"Text"}'
                                                                         ));
        
        
        
        calcSICMatrixRowList.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=testMatrixVersion.Id, 
                                                                          vlocity_cmt__InputData__c='{"Characteristic Value":"Presupuesto;Mid End","Characteristic Name":"Tipo Reparacion;Gama Reparacion","Reference External Id":"FAN_REP_0003","Reference Product Name":"<<Your Set of Products>>"}', 
                                                                          vlocity_cmt__OutputData__c='{"NRC":"192","MRC":"0"}'
                                                                         ));
        
        
        insert calcSICMatrixRowList;
        
        vlocity_cmt__CalculationProcedureStep__c testCalcStep = new vlocity_cmt__CalculationProcedureStep__c(Name='Test Step',vlocity_cmt__CalculationProcedureVersionId__c =testCalcVersion.Id,
                                                                                                            vlocity_cmt__CalculationMatrixId__c = testMatrix.Id);
        insert testCalcStep;
           
           
             
           List<OrderItem>OIList = [select id,Quantity,UnitPrice,PricebookEntryId,PricebookEntry.Pricebook2Id,
                        PricebookEntry.Product2Id,PricebookEntry.UnitPrice,PricebookEntry.IsActive,PricebookEntry.Product2.Name,PricebookEntry.Product2.ProductCode from OrderItem]; 
           Object OrdObj = (object)Ord;
           List<Object> OIObj = (List<Object>)OIList;
           system.debug('CP check'+JSON.serialize(OIObj));
          

           inputMap.put('parent',OrdObj); // order
           inputMap.put('itemList',OIObj) ;//OI
          inputMap.put('cartAction','AddCartItem');
          Test.startTest();
          SamplePricingElementServiceHookImpl PSI = new SamplePricingElementServiceHookImpl();
          PSI.invokeMethod('priceLineItems.PreInvoke',inputMap,outMap,options);
      	  Test.stopTest();
      }
      
 }