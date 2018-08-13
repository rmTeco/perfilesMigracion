global with sharing class Vlocity_PostProcessor_Multi implements vlocity_cmt.VlocityOpenInterface {
    String incomingMatrix='';
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) 
    {
        Boolean success = true;
        try 
        {
            if(methodName == 'calculate') 
            {  
                  
                  System.debug(LoggingLevel.ERROR, ' ---- PostProcessor inputMap ' + inputMap);
                  System.debug(LoggingLevel.ERROR, ' ---- PostProcessor outMap ' + outMap);
                  System.debug(LoggingLevel.ERROR, ' ---- PostProcessor options ' + options);
                  //System.debug(LoggingLevel.ERROR, ' ---- PostProcessor FlowStaticMap.flowMap ' + vlocity_cmt.FlowStaticMap.flowMap);

                  SObject parent = (SObject)vlocity_cmt.FlowStaticMap.flowMap.get('parent');
                  String parentObjName;
                  String parentId;
                  if (parent != null) {
                      parentId = String.valueOf(parent.Id);
                      parentObjName = parent.getSObjectType().getDescribe().getName();
                  }
                  System.debug(LoggingLevel.ERROR, ' ---- PostProcessor parentId ' + parentId);
                  System.debug(LoggingLevel.ERROR, ' ---- PostProcessor parentObjName ' + parentObjName);

                  if (String.isBlank(parentId) || String.isBlank(parentObjName)) {
                      System.debug(LoggingLevel.ERROR, ' ---- PostProcessor parentId or parentObjName is blank.');
                      return true;
                  }
                  String outputBundle = getConfigurationValue('PostProc'+parentObjName+'DRBundle');
                  System.debug(LoggingLevel.ERROR, ' ---- PostProcessor outputBundle ' + outputBundle);

                  if (String.isBlank(outputBundle)) {
                      System.debug(LoggingLevel.ERROR, ' ---- PostProcessor outputBundle is blank.');
                      return true;
                  }
                  incomingMatrix = ((String)options.get('configurationName'));
                  incomingMatrix='VlocityMultiAttributeCalculationMatrix';
                  system.debug(LoggingLevel.ERROR,'Incoming matrix is..'+incomingMatrix);
                  List<Object> outputList = (List<Object>)outMap.get('output');
                  List<Object> objectList;
                  System.debug(LoggingLevel.ERROR, ' ---- PostProcessor outputList ' + outputList);
                  if (outputList != null && !outputList.isEmpty()) {
                      vlocity_cmt.PricingCalculationService.CalculationProcedureResults calcProcResults = (vlocity_cmt.PricingCalculationService.CalculationProcedureResults)outputList[0];
                      objectList = calcProcResults.calculationResults;                      
                  }

                  System.debug(LoggingLevel.ERROR, ' ---- PostProcessor calculation results ' + JSON.serializePretty(objectList));

                  if (objectList != null && !objectList.isEmpty()) 
                  {
                      // Map<String, Decimal> mrcMap = new Map<String, Decimal>();
                      // Map<String, Decimal> nrcMap = new Map<String, Decimal>();
                      List<Object> saveList = new List<Object>();        
                      Map<String, Object> dataSet = (Map<String, Object>)inputMap.get('data');
                      //System.debug('***dataSet '+JSON.serializePretty(dataSet));                       
                      if (dataSet != null && !dataSet.isEmpty()) 
                      {
                          //map input data row to external id. This assumes external id is unique across all line items.
                          Map<String, Map<String, Object>> externalIdToDataRowMap = new Map<String, Map<String, Object>>(); 
                          Map<String, Object> IdToDataRowMap = new Map<String, Object>();                       
                          for (String key : dataSet.keySet()) 
                          {
                              Map<String, Object> dataRow = (Map<String, Object>)dataSet.get(key);
                              System.debug(LoggingLevel.ERROR, 'datasetRow1++ '+dataRow);
                              String mapKey = (String)dataRow.get('Reference External Id') + '_$$_' + (String)dataRow.get('ItemID');
                              if (!externalIdToDataRowMap.containsKey(mapKey)) 
                              {
                                  externalIdToDataRowMap.put(mapKey, dataRow);
                              }
                          }
                          System.debug(LoggingLevel.ERROR,'***externalIdToDataRowMap '+JSON.serializePretty(externalIdToDataRowMap));
                          
                          for (Object obj : objectList) 
                          {
                              System.debug(LoggingLevel.ERROR, 'Obj from ObjectList '+obj);
                        
                              // This is a row in the calculation procedure output
                              Map<String, Object> row = (Map<String, Object>)obj;

                              // Get the External Id from the output row
                              String outputExternalId = (String)row.get(incomingMatrix+'__TargetExternalId');
                            
                              System.debug(LoggingLevel.ERROR,'outputExternalId'+outputExternalId);
                            
                              String childItemId = (String)row.get('ID');
                           
                              System.debug(LoggingLevel.ERROR,'***childID '+childItemId);
                                                
                              Map<String, Object> childDataRow = (Map<String, Object>)dataSet.get(childItemId);
                            
                              System.debug(LoggingLevel.ERROR,'***childDataRow '+childDataRow);
                            
                              String childLineNum;
                              if (childDataRow != null) 
                              {
                                  childLineNum = (String)childDataRow.get('Line Number');
                              }
                            
                              System.debug(LoggingLevel.ERROR,'***childLineNum '+childLineNum);
                              System.debug(LoggingLevel.ERROR,'***KeyexternalIdToDataRowMapSet '+ externalIdToDataRowMap.keySet() + 'outputExternalId' + outputExternalId);
                              
                              Map<String, Object> dataSetRow;
                              
                              for (String key : externalIdToDataRowMap.keySet()) 
                              {
                                  if (outputExternalId<>null&&key.startsWith(outputExternalId)) 
                                  {                                                                                         
                                      dataSetRow = (Map<String, Object>)externalIdToDataRowMap.get(key);
                                      System.debug(LoggingLevel.ERROR,'***dataSetRow '+dataSetRow);
                                      System.debug(LoggingLevel.ERROR,'***after '+externalIdToDataRowMap.get(key));
                                      
                                      if (childLineNum.startsWith((String)dataSetRow.get('Line Number'))) 
                                      {
                                        break;
                                      }
                                  }
                              }
                              System.debug(LoggingLevel.ERROR,'***dataSetRow '+dataSetRow);
                                                        
                              if (dataSetRow != null&&row.containsKey(incomingMatrix+'__MRC')&&row.containsKey(incomingMatrix+'__NRC')) 
                              {
                                  String itemID = (String)dataSetRow.get('ItemID'); 
                                
                                  System.debug('itemIDLog: ' + itemID);                               
                                
                                  //this gets the existing MRC and NRC Values
                                  Decimal inputmrc = Decimal.valueOf((Double)dataSetRow.get('Input MRC')).setScale(2, RoundingMode.HALF_UP);    
                                  Decimal inputnrc = Decimal.valueOf((Double)dataSetRow.get('Input NRC')).setScale(2, RoundingMode.HALF_UP);    
                                
                                  System.debug(LoggingLevel.ERROR,'inputmrc: ' + inputmrc);
                                  System.debug(LoggingLevel.ERROR,'inputnrc: ' + inputnrc);

                                  Map<String, Object> objToSaveMap = new Map<String, Object>();
                                  objToSaveMap.put('ID', itemID);
                                
                                  System.debug('row='+row);
                                
                                  //THIS SECTION ADDS UP THE MRC AND NRC
                                  //Modified the code to Replace the MRC and NRC

                                  Decimal mrc;
                                  Decimal nrc;
                                  map<string,map<string,Decimal>> extIdToCurrencyMap = new  map<string,map<string,Decimal>>();

                                  if(row.containsKey('MRC') && row.get('MRC') != null)
                                  {
                                      mrc =  Decimal.valueOf((Double)row.get('MRC')).setScale(2, RoundingMode.HALF_UP);
                                  }
                                  if(row.containsKey('NRC') && row.get('NRC') != null)
                                  {
                                      nrc =  Decimal.valueOf((Double)row.get('NRC')).setScale(2, RoundingMode.HALF_UP);
                                  }
                                
                                  string childItemSize = (childLineNum.split('\\.')).Size() > 0 ? string.Valueof((childLineNum.split('\\.')).Size()): '0';
                                  string orderID =  (String)row.get('ID');
                                  if(!extIdToCurrencyMap.containsKey(((String)row.get(outputExternalId))+orderID))
                                  {
                                      extIdToCurrencyMap.put((String)row.get(outputExternalId)+orderID, new map<string,decimal>{'MRC' => mrc,'NRC'=> nrc});
                                  } 
                                  else if(extIdToCurrencyMap.containsKey(((String)row.get(outputExternalId))+orderID)) 
                                  {
                                      mrc += extIdToCurrencyMap.get(((String)row.get(outputExternalId))+orderID).get('MRC');
                                      nrc += extIdToCurrencyMap.get(((String)row.get(outputExternalId))+orderID).get('NRC');
                                      extIdToCurrencyMap.get(((String)row.get(outputExternalId))+orderID).put('MRC', mrc);
                                      extIdToCurrencyMap.get(((String)row.get(outputExternalId))+orderID).put('NRC', nrc);
                                      //system.debug('MRC ___'+mrc);
                                      //system.debug('NRC ___'+nrc);
                                  }
                                
                                  //System.debug('extIdToCurrencyMap____' +extIdToCurrencyMap);
                                
                                  objToSaveMap.put('MRC', mrc);
                                  //System.debug(LoggingLevel.ERROR,'mrc_afterelse: ' + mrc);                 
                          
                                  objToSaveMap.put('NRC', nrc);
                                  //System.debug(LoggingLevel.ERROR,'nrc_afterelse: ' + nrc);
                                
                                  // save the rest of the fields from the output row
                                  for (String key : row.keySet()) 
                                  {
                                      if (!objToSaveMap.containsKey(key)) 
                                      {
                                          objToSaveMap.put(key, row.get(key));
                                      }
                                  }
                                  saveList.add(objToSaveMap);                             
                              }
                          }
                          //System.debug(LoggingLevel.ERROR, ' ---- PostProcessor objects to save ' + JSON.serializePretty(saveList));
                          
                          // Only save if the saveList is not empty
                          if (!saveList.isEmpty()) 
                          {
                              // set up the request object for the Data Raptor save bundle
                              RestRequest req = new RestRequest();
                              RestResponse res = new RestResponse();
                              req.requestURI = '/v2/DataRaptor/';
                              RestContext.request = req;
                              RestContext.response = res;
                              Map<String, Object> postData = new Map<String, Object>
                              {
                                  'bundleName' => outputBundle,
                                  'objectList' => saveList,
                                  'bulkUpload' => false
                              };
                              String reqData = JSON.serialize(postData);
                              System.debug(LoggingLevel.ERROR, '---- PostProcessor DR Post reqData ' + reqData);
                              req.requestBody = Blob.valueOf(reqData);
                              vlocity_cmt.DRRestResourceV2.doPost();
                              String resBody = res.responseBody.toString();
                              System.debug(LoggingLevel.ERROR, ' ---- PostProcessor DR Post result ' + resBody);
                          }                        
                      }
                  } 
            }
        } 
        catch(Exception e)
        {
            System.debug(LoggingLevel.ERROR, 'Exception is '+e);
            System.debug(LoggingLevel.ERROR, 'Exception stack trace '+e.getStackTraceString());
            success=false;
            throw e;
        }

        return success;        
    }
    
    private String getConfigurationValue(String setupName) 
    {
        vlocity_cmt__CpqConfigurationSetup__c cpqSetup = vlocity_cmt__CpqConfigurationSetup__c.getInstance(setupName); 
        String retval = null;
        if (cpqSetup != null 
              && cpqSetup.vlocity_cmt__SetupValue__c != null
              && cpqSetup.vlocity_cmt__SetupValue__c.length() > 0) 
        {
            retval = cpqSetup.vlocity_cmt__SetupValue__c;          
        }  
        return retval;
    }    
}