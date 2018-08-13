global with sharing class Vlocity_PreProcessor_Multi implements vlocity_cmt.VlocityOpenInterface {
  private Boolean useDisplayText = false;
  map<string, list<CalcMatrixdataWrapper>> cmrExtIDtoWrapperMap =  new map<string, list<CalcMatrixdataWrapper>>();
  //input contains the parent (object type from the Flow)
  global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
    Boolean success = true;
    
      if (methodName == 'calculate') {
      try {
        System.debug(LoggingLevel.ERROR, ' ---- PreProcessor inputMap ' + inputMap);
        
        System.debug(LoggingLevel.ERROR, ' ---- PreProcessor options ' + options);
        SObject parent = (SObject)vlocity_cmt.FlowStaticMap.flowMap.get('parent');
        String parentObjName;
        String parentId;
        List<String> sourceObjectIDs = (List<String>)options.get('sourceObjectIds');
        if(sourceObjectIDs == null) 
        {
            system.debug('Exit from here');
            return true;
        }
        String ids = sourceObjectIds.get(sourceObjectIds.size()-1);
        System.debug(LoggingLevel.ERROR, ' ---- IDS ' + ids);

        if (parent != null) {
          parentId = String.valueOf(parent.Id);
          //either Quote/Order or Opportunity
          parentObjName = parent.getSObjectType().getDescribe().getName();
        }
        System.debug(LoggingLevel.ERROR, ' ---- PreProcessor parentId ' + parentId);
        System.debug(LoggingLevel.ERROR, ' ---- PreProcessor parentObjName ' + parentObjName);
        if (String.isBlank(parentId) || String.isBlank(parentObjName)) {
          return true;
        }

        //getConfigurationValue checks the CustomSetting for this Key 'PreProc' - to retrieve the Input DRBundle where ParentObjectName = Oppty,Quote or Order
        String inputBundle = getConfigurationValue('PreProc' + parentObjName + 'DRBundle');
        System.debug(LoggingLevel.ERROR, ' ---- PreProcessor inputBundle ' + inputBundle);
        if (String.isBlank(inputBundle)) {
          return true;
        }

        System.debug(LoggingLevel.ERROR, ' ---- Begin Initialize RestRequest ');
        // Load the line items using DataRaptor input bundle
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        System.debug(LoggingLevel.ERROR, ' ---- After Initialize RestRequest ' + req + ' res: ' + res);
        
        //initialize DR Rest Call
        req.requestURI = '/v2/DataRaptor/' + inputBundle + '/';
        req.addParameter('Id', parentId);
        RestContext.request = req;
        RestContext.response = res;
        
        System.debug(LoggingLevel.ERROR, 'Matrix name found..'+((String)options.get('configurationName')).substring(10));
        
        //Make sure to get all attributes and values for comparision for a given matrix
        string matrixName = [select vlocity_cmt__CalculationMatrixId__r.Name from vlocity_cmt__CalculationProcedureStep__c  where vlocity_cmt__CalculationProcedureVersionId__r.vlocity_cmt__CalculationProcedureId__r.Name=:((String)options.get('configurationName')) limit 1].vlocity_cmt__CalculationMatrixId__r.Name;
        
        System.debug(LoggingLevel.ERROR, ' ---- matrixName ' + matrixName);

        getCalcMatrixdata(matrixName);

        System.debug(LoggingLevel.ERROR, ' ---- Set Req and Res ' + req + ' res: ' + res);
        System.debug(LoggingLevel.ERROR, ' ---- before DRRestResourceV2.doGet ');
        
        vlocity_cmt.DRRestResourceV2.doGet();
        
        System.debug(LoggingLevel.ERROR, ' ---- after DRRestResourceV2.doGet ');
        
        String resBody = res.responseBody.toString();
        
        System.debug(LoggingLevel.ERROR, ' ---- after resBody ' + resBody);
        System.debug(LoggingLevel.ERROR, ' ---- PreProcessor DR LOGGER output is ' + resBody);
        
        //Once you receive the reponse from the DR Input - i.e. OrderItem and it's JSONAttribute
        Map<String, Object> data = new Map<String, Object>();
        Object drResult = JSON.deserializeUntyped(resBody);
        if (drResult instanceof List<Object>) {
          List<Object> resultList = (List<Object>)drResult;
          for (Object obj : resultList) {
            Map<String, Object> result = (Map<String, Object>)obj;
            processData(result, data);
            //vlocity_cmt.FlowStaticMap.flowMap.put('PreProcessor_input', result);
          }
          inputMap.put('data', data);
        } else if (drResult instanceof Map<String, Object>) {
          Map<String, Object> result = (Map<String, Object>)drResult;
          processData(result, data);
          inputMap.put('data', data);
        }

        System.debug(LoggingLevel.ERROR, ' ---- PreProcessor data input to procedure\n ' +  JSON.serializePretty(data));
        System.debug(LoggingLevel.ERROR, ' ---- inputMap after DR is ' + inputMap);
       
       } catch (Exception e) {
          System.debug(LoggingLevel.ERROR, 'Exception is ' + e);
          System.debug(LoggingLevel.ERROR, 'Exception stack trace ' + e.getStackTraceString());
          success = false;
          throw e;
        }
      }
    
    return success;
  }
  //in ProcessData will process each line item (XLI) and will create a processDetail (line 103)
  private void processData(Map<String, Object> result,  Map<String, Object> data) {
    String rowId = (String)result.get('ID');
    String rowKey = 'Row' + data.size();
    Map<String, Object> row = new Map<String, Object>();
    data.put(rowKey, row);
    row.put('ItemID', rowId);
    Object detailNode = result.get('Detail');
    if (detailNode instanceof List<Object>) {
      List<Object> detailList = (List<Object>)detailNode;
      for (Object obj : detailList) {
        Map<String, Object> detail = (Map<String, Object>)obj;
        processDetail(detail, row, data);
      }
    } else if (detailNode instanceof Map<String, Object>) {
      Map<String, Object> detail = (Map<String, Object>)result.get('Detail');
      processDetail(detail, row, data);
    }
  }
  private void processDetail(Map<String, Object> detail, Map<String, Object> row, Map<String, Object> data) {
    if (detail != null) {
      for (String key : detail.keySet()) {
        if (key != 'Item Attr') {
          row.put(key, detail.get(key));
        }
      }
      // Check for the attribute JSON string
      if (detail.containsKey('Item Attr')) {
        Object itemAttrsJSON = detail.get('Item Attr');
        if (itemAttrsJSON instanceof String) {
          getAttributes((String)itemAttrsJSON, row, data);
        } else if (itemAttrsJSON instanceof List<Object>)
          System.debug(LoggingLevel.ERROR, 'itemAttrsJSON is a List<Object> was expecting a String.');
        else if (itemAttrsJSON instanceof Map<String, Object>)
          System.debug(LoggingLevel.ERROR, 'itemAttrsJSON is a Map<String, Object> was expecting a String.');
      }
    }
  }
  /**
   * Extracts all attributes and values from the attribute JSON and adds them to the matrix row
   */
  public void getAttributes(String prodAttrJSON, Map<String, Object> row, Map<String, Object> data) {
    System.debug(LoggingLevel.ERROR, 'prodAttrJSON ' + prodAttrJSON);
    if (String.isBlank(prodAttrJSON)) {
      return;
    }
    Map<String, Object> rowMap = row;
    Object jsonAttr = JSON.deserializeUntyped(prodAttrJSON);
    if (jsonAttr instanceof List<Object>) {
      
      System.debug(LoggingLevel.ERROR, 'jsonAttr is a List<Object>');
      
      return;
    } else if (jsonAttr == null) {
      
      System.debug(LoggingLevel.ERROR, 'jsonAttr is null');
      
      return;
    }
    Map<String, Object> attrMap = (Map<String, Object>)jsonAttr;
    Boolean bFirst = true;
    for (String key : attrMap.keySet()) {
      
      System.debug(LoggingLevel.ERROR, 'key ' + key);
      
      Object attrs = attrMap.get(key);
      if (attrs instanceof List<Object>) {
        
        System.debug(LoggingLevel.ERROR, 'attrs ' + attrs);
        
        List<Object> attrList = (List<Object>)attrs;
        list<CalcMatrixdataWrapper> charactersticNameWrapperList = new list<CalcMatrixdataWrapper>();
        for (Object attr : attrList) {
          if (!bFirst) {
            rowMap = rowMap.clone();
            data.put('Row' + data.size(), rowMap);
          } else {
            bFirst = false;
          }
          Map<String, Object> attrInfo = (Map<String, Object>)attr;
          String attrCode = (String)attrInfo.get('attributeuniquecode__c');

          // Use the attribute display name
          //String attrName = (String)attrInfo.get('attributedisplayname__c');

          // Use the attribute display code instead
          rowMap.put('Characteristic Name', attrCode);
          Map<String, Object> attributeRunTimeInfo =  (Map<String, Object>)attrInfo.get('attributeRunTimeInfo');
          if (attributeRunTimeInfo == null) {
            
            System.debug('attributeRunTimeInfo is null for ' + attrInfo);
            
            continue;
          }
          String dataType = (String)attributeRunTimeInfo.get('dataType');
          if (dataType == null) {
            
            System.debug(LoggingLevel.ERROR, 'Unable to find the dataType for attribute name ' + attrCode);
            
            continue;
          }
          //get initial value
          Object propertyValue = attributeRunTimeInfo.get('value');
          if (propertyValue == null) {
            propertyValue = attributeRunTimeInfo.get('default');
          }
          try {
            String normDataType = dataType.toLowerCase();
            if (normDataType == 'multi picklist') {
              propertyValue = attributeRunTimeInfo.get('selectedItems');
              if (propertyValue == null || ((List<Object>) propertyValue).isEmpty()) {
                List<Object> values = (List<Object>)attributeRunTimeInfo.get('default');
                String valuesDelimited = '';
                for (Integer index = 0; index < values.size(); index ++) {
                  Map<String, Object> value = (Map<String, Object>)values[index];
                  valuesDelimited += getPropertyValue(value) + ';';
                }
                if (valuesDelimited.length() > 0) {
                  propertyValue = valuesDelimited.subString(0, valuesDelimited.length() - 1);
                  rowMap.put('Characteristic Value', propertyValue);
                }
              } else {
                List<Object> values = (List<Object>)propertyValue;
                String valuesDelimited = '';
                for (Integer index = 0; index < values.size(); index ++) {
                  Map<String, Object> value = (Map<String, Object>)values[index];
                  valuesDelimited += getPropertyValue(value) + ';';
                }
                if (valuesDelimited.length() > 0) {
                  propertyValue = valuesDelimited.subString(0, valuesDelimited.length() - 1);
                  rowMap.put('Characteristic Value', propertyValue);
                }
              }
            } else if (normDataType == 'picklist') {
              propertyValue = attributeRunTimeInfo.get('selectedItem');
              if (propertyValue == null) {
                List<Object> values = (List<Object>)attributeRunTimeInfo.get('default');
                if (values != null && !values.isEmpty()) {
                  String valuesDelimited = null;
                  Map<String, Object> value = (Map<String, Object>)values[0];
                  valuesDelimited = getPropertyValue(value);
                  propertyValue = valuesDelimited;
                  rowMap.put('Characteristic Value', propertyValue);
                }
              } else {
                System.debug('propertyValue is ' + propertyValue);
                if (propertyValue instanceof Map<String, Object>) {
                  Map<String, Object> value = (Map<String, Object>)propertyValue;
                  propertyValue = getPropertyValue(value);
                } else if (propertyValue instanceof String) {
                  propertyValue = getPropertyValue2(attributeRunTimeInfo.get('values'), (String)propertyValue);
                  System.debug('getPropertyValue2 returned ' + propertyValue);
                }
                rowMap.put('Characteristic Value', propertyValue);
              }
            } else {
              rowMap.put('Characteristic Value', propertyValue);
            }
            if (rowMap.containsKey('Reference External Id') && cmrExtIDtoWrapperMap.containsKey((string) rowMap.get('Reference External Id'))) {
              charactersticNameWrapperList = cmrExtIDtoWrapperMap.get((string) rowMap.get('Reference External Id'));
              
              System.debug('charactersticNameWrapperList returned ' + charactersticNameWrapperList);


              for (CalcMatrixdataWrapper cmWrapper : charactersticNameWrapperList) {
                if (cmWrapper.charactersticNameOrderMap.containsKey(attrCode) && propertyValue != null) {
                  if (cmWrapper.itemIDToSearchCount.containsKey((string) rowMap.get('ItemID'))) {
                    Integer searchCount = cmWrapper.itemIDToSearchCount.get((string) rowMap.get('ItemID')) + 1;
                    cmWrapper.itemIDToSearchCount.put((string) rowMap.get('ItemID'), searchCount);
                  } else {
                    cmWrapper.itemIDToSearchCount.put((string) rowMap.get('ItemID'), 1);
                  }
                  if (cmWrapper.ItemrRunTimeattrPositionMap.containsKey((string) rowMap.get('ItemID'))) {
                    cmWrapper.ItemrRunTimeattrPositionMap.get((string) rowMap.get('ItemID')).put(cmWrapper.charactersticNameOrderMap.get(attrCode), new CharactersticNameValue(attrCode, string.valueof( propertyValue)));
                  } else {
                    cmWrapper.runTimeattrPosition.put(cmWrapper.charactersticNameOrderMap.get(attrCode), new CharactersticNameValue(attrCode, string.valueof( propertyValue)));
                    cmWrapper.ItemrRunTimeattrPositionMap.put((string) rowMap.get('ItemID'), cmWrapper.runTimeattrPosition);
                  }
                }
              }
            }
          } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception:::::' + e);
            System.debug(LoggingLevel.ERROR, 'Exception stack trace:::::' + e.getStackTraceString());
            throw e;
          }
        } // end for loop
        getDelimitedRowNode(rowMap, data);
      } // end if
      else if (attrs instanceof Map<String, Object>)
        System.debug(LoggingLevel.ERROR, 'attrs is a Map<String, Object>');
    }
  }
  private String getPropertyValue2(Object valuesList, String propertyValue) {
    if (valuesList instanceof List<Object>) {
      List<Object> objList = (List<Object>)valuesList;
      String internalVal, displayVal;
      for (Object obj : objList) {
        if (obj instanceof Map<String, Object>) {
          Map<String, Object> valueMap = (Map<String, Object>)obj;
          internalVal = String.valueOf(valueMap.get('value'));
          displayVal = String.valueOf(valueMap.get('displayText'));
          if (internalVal == propertyValue || displayVal == propertyValue) {
            if (this.useDisplayText) {
              return displayVal;
            } else {
              if (String.isBlank(internalVal))
                return displayVal;
              else
                return internalVal;
            }
          }
        }
      }
    }
    return propertyValue;
  }
  public String getPropertyValue(Map<String, Object> valueMap) {
    if (this.useDisplayText) {
      return String.valueOf(valueMap.get('displayText'));
    }
    String propertyValue = String.valueOf(valueMap.get('value'));
    if (String.isBlank(propertyValue)) {
      propertyValue = String.valueOf(valueMap.get('displayText'));
    }
    return propertyValue;
  }
  private String getConfigurationValue(String setupName) {
    vlocity_cmt__CpqConfigurationSetup__c cpqSetup = vlocity_cmt__CpqConfigurationSetup__c.getInstance(setupName);
    String retval = null;
    if (cpqSetup != null
        && cpqSetup.vlocity_cmt__SetupValue__c != null
        && cpqSetup.vlocity_cmt__SetupValue__c.length() > 0) {
      retval = cpqSetup.vlocity_cmt__SetupValue__c;
    }
    return retval;
  }

  // Query CalculationMarix data to get the characterstic name, value for future comparision.
  private void getCalcMatrixdata(string CalCulationMatrixName ) {
  //to be removed
    System.debug(LoggingLevel.ERROR,'MATRIX NAME::' + CalCulationMatrixName);
    System.debug(LoggingLevel.ERROR,'cmrExtIDtoWrapperMap-Size::' + cmrExtIDtoWrapperMap);
    for ( vlocity_cmt__CalculationMatrixRow__c cmr : [select id, name, vlocity_cmt__InputData__c, vlocity_cmt__OutputData__c
          from vlocity_cmt__CalculationMatrixRow__c where
          vlocity_cmt__CalculationMatrixVersionId__r.vlocity_cmt__CalculationMatrixId__r.name = :CalCulationMatrixName AND
              vlocity_cmt__CalculationMatrixVersionId__r.vlocity_cmt__IsEnabled__c = true AND name != 'Header' ] ) {
      object inputdata = JSON.deserializeUntyped(cmr.vlocity_cmt__InputData__c);
      System.debug(LoggingLevel.ERROR,'cmr is..'+cmr);
      if (inputdata instanceof Map<String, Object> ) {
        Map<string, Object> inputDataMap = ( Map<string, Object>)inputdata;
        
        System.debug('inputdata returned after cmr ' + inputdata);
        
        if (inputDataMap.ContainsKey('Reference External Id') && inputDataMap.ContainsKey('Characteristic Name') ) {
          string externalId = string.valueof(inputDataMap.get('Reference External Id'));
          
          System.debug('externalId returned ' + externalId);
          
          string charactersticName = string.valueof(inputDataMap.get('Characteristic Name'));
          Set<string> charNameSet = new set<string>();
          boolean addRecordtoWrapper = true;
          charNameSet.addAll(string.valueof(inputDataMap.get('Characteristic Name')).split(';'));
          if (cmrExtIDtoWrapperMap.containsKey(externalId) && charNameSet.size() > 1) {
            if (cmrExtIDtoWrapperMap.get(externalId).size() > 0) {
              for (CalcMatrixdataWrapper cmWrapper : cmrExtIDtoWrapperMap.get(externalId)) {
                if (cmWrapper.charactersticName.equalsIgnoreCase(charactersticName))
                  addRecordtoWrapper = false;
                break;
              }
            }
            if (addRecordtoWrapper)
              cmrExtIDtoWrapperMap.get(externalId).add(new CalcMatrixdataWrapper(charactersticName, charNameSet, 0, externalID));
          } else if (charNameSet.size() > 1) {
            list<CalcMatrixdataWrapper> calcMatrixDataList = new list<CalcMatrixdataWrapper>();
            calcMatrixDataList.add(new CalcMatrixdataWrapper(charactersticName, charNameSet, 0, externalID));
            cmrExtIDtoWrapperMap.put(externalId, calcMatrixDataList);
          }
        }
      }
    }
    System.debug(LoggingLevel.ERROR,'cmrExtIDtoWrapperMap-Size::' + cmrExtIDtoWrapperMap.size());
  }
  @TestVisible
  private void getDelimitedRowNode(Map<String, Object> rowMap, Map<String, Object> data) {
    list<CalcMatrixdataWrapper> charactersticNameWrapperList = new list<CalcMatrixdataWrapper>();
    Map<string, string> charactersticNameValueMap = new map<string, string>();
    string attrNamedelimited = '';
    string attrValuedelimited = '';
    if (cmrExtIDtoWrapperMap.containsKey((string) rowMap.get('Reference External Id'))) {
      charactersticNameWrapperList = cmrExtIDtoWrapperMap.get((string) rowMap.get('Reference External Id'));
      
      System.debug('charactersticNameWrapperList returned ' + charactersticNameWrapperList);
      
      
      for (CalcMatrixdataWrapper cmWrapper : charactersticNameWrapperList) {
        if (integer.valueOf(cmWrapper.itemIDToSearchCount.get((string) rowMap.get('ItemID'))) == cmWrapper.charactersticNameOrderMap.size()) {
          List < integer > attrNameposition = New List<Integer> (cmWrapper.ItemrRunTimeattrPositionMap.get((string) rowMap.get('ItemID')).keySet());
          attrNameposition.sort();
          List < string > attrNameOrderedListName = new List < string > ();
          List < string > attrNameOrderedListValue = new List < string > ();
          for (integer i : attrNameposition) {
            attrNameOrderedListName.add(cmWrapper.runTimeattrPosition.get(i).name);
            attrNameOrderedListValue.add(cmWrapper.runTimeattrPosition.get(i).value);
          }
          rowMap = rowMap.clone();
          rowMap.put('Characteristic Name', string.join(attrNameOrderedListName, ';'));
          rowMap.put('Characteristic Value', string.join(attrNameOrderedListValue, ';'));
          data.put('Row' + (data.size()), rowMap);
        }
      }
    }
    System.debug(LoggingLevel.ERROR,'cmrExtIDtoWrapperMap-Size::' + cmrExtIDtoWrapperMap.size());
  }
  private class CalcMatrixdataWrapper {
    string charactersticName {get; set;}
    set<string> charactersticNameSet = new set<string>();
    map<string, string> runTimecharNameValueMap {set; get;}
    map<string, integer>charactersticNameOrderMap = new map<string, integer>();
    map<integer, CharactersticNameValue> runTimeattrPosition = new map<integer, CharactersticNameValue>();
    integer searchCount {get; set;}
    integer i = 1;
    string externalID = '';
    Map<String, Integer> itemIDToSearchCount = new Map<String, Integer>();
    Map<String, Map<integer, CharactersticNameValue> > ItemrRunTimeattrPositionMap =  new Map<String, Map<integer, CharactersticNameValue> >();
    public CalcMatrixdataWrapper(string charactersticName,  Set<string> charactersticNameSet, integer searchCount , String externalID) {
      this.charactersticName = charactersticName;
      this.charactersticNameSet = charactersticNameSet;
      this.searchCount = searchCount;
      this.externalID = externalID;
      for (string cName :  charactersticNameSet) {
        charactersticNameOrderMap.put(cName, i);
        i++;
      }
    }
  }
  public class CharactersticNameValue {
    public string name;
    public string value;
    public CharactersticNameValue(string name, string value) {
      this.name = name;
      this.value = value;
    }
  }
}