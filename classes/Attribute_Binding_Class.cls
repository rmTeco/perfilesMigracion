public class Attribute_Binding_Class {
  static List<Attributes_Binding__c> parameters =  [Select id,Name,Field__c,Attribute_Name__c,Object__c,Attribute_Category__c from Attributes_Binding__c WHERE Object__c = 'Asset' and Active__c = true];
  
    public static void ins(List<Asset> newMap){
        try{
            Attribute_Binding_Class.getAttributesAndReplace(newMap);
        }
        catch(Exception ex){
            System.debug(ex);
        }
    } 

    public static void getAttributesAndReplace(List<Asset> assetsToUpdate){
        if(Attribute_Binding_Class.parameters != null && Attribute_Binding_Class.parameters.size() > 0){
            XOMUtilities getspecificAttribute = new XOMUtilities();
            for (Asset asset : assetsToUpdate){
                List<Asset> listaDeAssets = new List<Asset>();
                listaDeAssets.add(asset);
                List<Map<String, Object>> assetAttributes = getspecificAttribute.getJsonAttributesFromAnyObject(listaDeAssets , 'Asset');
                if(assetAttributes != null){
                    for(Attributes_Binding__c parameter: Attribute_Binding_Class.parameters){
                        string n = getspecificAttribute.getValueFromAttrs(assetAttributes, parameter.Attribute_Name__c);      
                        
                        if(n!= null && n!= '')
                            asset.put(parameter.Field__c, n);
                    }
                    //asset.put('Status', asset.vlocity_cmt__ProvisioningStatus__c);
                }
            }
        }
    }

    public static void upd(Map<Id, Asset> oldMap, List<Asset> newMap){
        try{
            Attribute_Binding_Class.getAttributesAndReplace(newMap);
        }
        catch(Exception ex){
            system.debug('exception on: ' + ex.getLineNumber() + ex);
            //throw ex;
        }
    }
}