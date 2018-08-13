global with sharing class ta_techCare_added_value_services implements vlocity_cmt.VlocityOpenInterface{

  public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
  {

    try{
      if(methodName.equals('getAddedValueServicesByAssetId'))
        getAddedValueServicesByAssetId(input, outMap, options);
      else if(methodName.equals('getCaseSLA'))
        getCaseSLA(input, outMap, options);
      else if(methodName.equals('getMassiveIncidents'))
        getMassiveIncidents(input, outMap, options);
      else if(methodName.equals('getDependenciesSize'))
        getDependenciesSize(outMap, options);

    } catch(Exception ex){
      outMap.put('error', ex.getMessage());
    }

    return true;
  }

  private void getDependenciesSize(Map<String, Object> outMap, Map<String, Object> options){
    try{
      String service = (String) options.get('service');

      Map<String, List<String>> controllingInfo = this.getFieldDependencies('Case', 'SubType__c', 'Incident__c');

      boolean hasIncidents = false;

      if(controllingInfo.get(service) != null){
        Integer size = controllingInfo.get(service).size();
        if(size > 0) hasIncidents = true;
      }

      outMap.put('hasIncidents', hasIncidents);
    } catch(Exception ex){
      throw new FuncException('Error inesperado al obtener la cantidad de dependientes: ' + ex.getMessage());
    }
  }

  //By SharSolutions
  private class MyPickListInfo
  {
    public String validFor;
  }

  private Map<String, List<String>> getFieldDependencies(String objectName, String controllingField, String dependentField)
  {
    Map<String, List<String>> controllingInfo = new Map<String, List<String>>();

    Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);

    Schema.DescribeSObjectResult describeResult = objType.getDescribe();
    Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
    Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();

    List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
    List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();

    for(Schema.PicklistEntry currControllingValue : controllingValues){
      controllingInfo.put(currControllingValue.getLabel(), new List<String>());
    }

    //controllingInfo.put('filterValue', new List<String>());

    System.debug('controllingInfo: ' + controllingInfo);

    for(Schema.PicklistEntry currDependentValue : dependentValues){
      String jsonString = JSON.serialize(currDependentValue);
      MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);
      String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
      Integer baseCount = 0;

      for(Integer curr : hexString.getChars()){
        Integer val = 0;

        if(curr >= 65) val = curr - 65 + 10;
        else val = curr - 48;

        if((val & 8) == 8)
          controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
        if((val & 4) == 4)
          controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
        if((val & 2) == 2)
          controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
        if((val & 1) == 1)
          controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    

        baseCount += 4;
      }
    }

    return controllingInfo;
  }

  public void getCaseSLA(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
    try{
      String caseId = (String) options.get('CaseId');

      List<CaseMilestone> lstCaseMilestone = [SELECT TargetDate 
                                                FROM CaseMilestone 
                                               WHERE CaseId = :caseId];

      if(lstCaseMilestone.size() != 0){
        Map<String, Object> similCaseNode = new Map<String, Object>();
        Map<String, Object> caseNode = new Map<String, Object>();

        caseNode.put('TargetDate', lstCaseMilestone[0].TargetDate);
        similCaseNode.put('Case', caseNode);
        outMap.put('SimilCase', similCaseNode);
      }
    } catch(Exception ex){
      outMap.put('error', ex.getMessage());
    }
  }

  public void getMassiveIncidents(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
    try{
      List<Object> antennas = new List<Object>();

      if(input.get('Antennas') != null)
      	antennas = (List<Object>) input.get('Antennas');

      List<Map <String, String>> retOptions = new List<Map <String, String>>();
      Map<String, String> tempMap;
      Map<String, Object> mapAntenna;

      Set<String> incidents = new Set<String>();

      for(Object antenna : antennas){
        mapAntenna = (Map<String, Object>) antenna;

        tempMap = new Map<String, String>();

        String incidentCode = (String) mapAntenna.get('massiveIncident');

        if(!incidentCode.equals('') && !incidents.contains(incidentCode)){
          incidents.add(incidentCode);

          tempMap.put('name', incidentCode);
          tempMap.put('value', incidentCode);

          retOptions.add(tempMap);
        }
      }

      outMap.put('options', retOptions);
    } catch(Exception ex){
      outMap.put('error', 'Error al obtener incidentes masivos: ' + ex.getMessage());
    }
  }

  public void getAddedValueServicesByAssetId(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
    Map<String, Object> response;
    try{
      String idAsset = (String) input.get('assetId');
      String idAccount = (String) input.get('accountId');
      String tempStatusGroup = '';
      Date tempDateGroup;

      Map<String, Object> tempAsset = new Map<String, Object>();
      Map<String, Object> tempGroupAsset = new map<String, Object>();

      List<Map<String, Object>> agrupatedAssets = new List<Map<String, Object>>();//Output aggrupated List<Map>
      List<Map<String, Object>> svaList = new List<Map<String, Object>>();//Outmap Main List

      Asset preAsset = new Asset();
      Asset selectedAsset = new Asset();
      Asset nextAsset = new Asset();

      String grouped;


      List<Asset> assets = [SELECT Asset.Id, Asset.Name, Asset.InstallDate,
                                   Asset.Tipo_de_Producto__c, Asset.vlocity_cmt__LineNumber__c,
                                   Asset.Vlocity_cmt__ProvisioningStatus__c, SubTipo_de_Producto__c
                              FROM Asset
                             WHERE Asset.AccountId = :idAccount
                               AND Asset.vlocity_cmt__ParentItemId__c = :idAsset
                               AND Asset.SubTipo_de_Producto__c != null
                             Order by SubTipo_de_Producto__c DESC];
      System.debug(Assets);
      System.debug(idAccount);
      System.debug(idAsset);
      
      for(Integer i=0;  i < assets.size() - 1; i++){

        if(i>0) preAsset = assets[i-1];
        if(i != Assets.size()) nextAsset = assets[i+1];
        
        selectedAsset = assets[i];

        //Mandatory Attribute
        List<String> attributeList = new List<String>();
        attributeList.add('Mandatorio');
        response = AssetAttributesUtils.getAssetAttribute(selectedAsset.Id, attributeList);
        String mandatory = 'false';
        if(response.get('Mandatorio') != null)
          mandatory = (String) response.get('Mandatorio');
        //End Mandatory Attribute

        tempAsset = new Map<String, Object>();

        //Si el anterior es diferente pero el siguiente es igual
        if((preAsset == null || selectedAsset.SubTipo_de_Producto__c != preAsset.SubTipo_de_Producto__c ) && (selectedAsset.SubTipo_de_Producto__c == nextAsset.SubTipo_de_Producto__c)
          && (selectedAsset.SubTipo_de_Producto__c != 'None')) {

          tempGroupAsset = new Map<String, Object>();
          agrupatedAssets = new List<Map<String, Object>>();

          tempDateGroup = null;
          tempStatusGroup = 'Invalid';

          tempDateGroup = selectedAsset.InstallDate;

          if(selectedAsset.Vlocity_cmt__ProvisioningStatus__c != null)
            tempStatusGroup = selectedAsset.Vlocity_cmt__ProvisioningStatus__c;

          tempGroupAsset.put('Name', selectedAsset.SubTipo_de_Producto__c);
          tempGroupAsset.put('InstallDate', tempDateGroup);
          tempGroupAsset.put('Status', tempStatusGroup);
          tempGroupAsset.put('Grouped', 'true');
          svaList.add(tempGroupAsset);
          grouped = '';
          setTempAsset(tempAsset, selectedAsset, mandatory, grouped); //Guardo los datos del asset en el map
          agrupatedAssets.add(tempAsset);

        } else if(selectedAsset.SubTipo_de_Producto__c == preAsset.SubTipo_de_Producto__c
                  && (selectedAsset.SubTipo_de_Producto__c != 'None')) { //Si el anterior es igual
          grouped = '';
          setTempAsset(tempAsset, selectedAsset, mandatory, grouped); //Guardo los datos del asset en el map
          agrupatedAssets.add(tempAsset);

          if(selectedAsset.SubTipo_de_Producto__c != nextAsset.SubTipo_de_Producto__c)
            tempGroupAsset.put('Services', agrupatedAssets);

          if(selectedAsset.Vlocity_cmt__ProvisioningStatus__c != null && selectedAsset.Vlocity_cmt__ProvisioningStatus__c != preAsset.Vlocity_cmt__ProvisioningStatus__c)
            tempGroupAsset.put('Status', 'Limited');

          if(selectedAsset.InstallDate != null && selectedAsset.InstallDate > preAsset.InstallDate)
            tempGroupAsset.put('InstallDate', selectedAsset.InstallDate);

        } else if((selectedAsset.SubTipo_de_Producto__c != preAsset.SubTipo_de_Producto__c
        	  && selectedAsset.SubTipo_de_Producto__c != nextAsset.SubTipo_de_Producto__c)
        		|| (selectedAsset.SubTipo_de_Producto__c == 'None')){ //si el anterior es diferente y el siguiente diferente
          grouped = 'false';
          setTempAsset(tempAsset, selectedAsset, mandatory, grouped); //Guardo los datos del asset en el map
          svaList.add(tempAsset);
        }

      }//End FOR Assets

      outMap.put('services', svaList);
      System.debug(outMap);
    }
    catch(Exception ex){
      outMap.put('error', 'Error al obtener servicios SVA: ' + ex.getMessage());
      System.debug(ex.getMessage());
    }
  }

  private void setTempAsset(Map<String,Object> tempAsset, Asset selectedAsset, String mandatory, String Grouped){
		tempAsset.put('Id', selectedAsset.Id);
    tempAsset.put('Name', selectedAsset.Name);
    if(String.isNotEmpty(Grouped))tempAsset.put('Grouped', Grouped);
    tempAsset.put('InstallDate', selectedAsset.InstallDate);
    tempAsset.put('Tipo_de_Producto__c', selectedAsset.Tipo_de_Producto__c);
    tempAsset.put('Status', selectedAsset.Vlocity_cmt__ProvisioningStatus__c);
    tempAsset.put('Mandatory', mandatory);
    tempAsset.put('SubTipo_de_Producto__c', selectedAsset.SubTipo_de_Producto__c);
	}

}