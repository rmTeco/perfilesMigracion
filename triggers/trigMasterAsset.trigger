trigger trigMasterAsset on Asset (after delete, after insert, after undelete, before delete, before insert, after update, before update) {
    try{
        if(Trigger.isBefore){
            System.debug('isBefore');
            if(Trigger.isUpdate){
                System.debug('isUpdate');
                Attribute_Binding_Class.upd(trigger.oldMap, trigger.new);
            }
            else if (Trigger.isInsert){
                System.debug('isInsert');
                Attribute_Binding_Class.ins(trigger.new);                
            }
        }
        if(Trigger.isAfter){
            System.debug('isAfter');
            if(Trigger.isUpdate){
                System.debug('isUpdate');
                String newBundleStatus;
                List<Asset> assetsToUpdate = new List<Asset>();
                List<Asset> assetsWithChildren  = [ SELECT Id, Status, BundleStatus__c, (SELECT Status, BundleStatus__c FROM ChildAssets) FROM Asset WHERE Id IN :trigger.newMap.keySet()];

                for(Asset a : assetsWithChildren) {
                    newBundleStatus = 'Active';
                    for(Asset aChild : a.ChildAssets){
                        if(aChild.Status != 'Active')
                            newBundleStatus = 'Inactive';
                    }
                    if(a.Status != 'Active')
                        newBundleStatus = 'Inactive';

                    if(newBundleStatus != a.BundleStatus__c){
                        assetsToUpdate.add(new Asset(Id=a.Id, BundleStatus__c=newBundleStatus));
                    }
                }
                update assetsToUpdate;
            }
        }
    }
    catch(Exception ex){
        System.debug(ex);
    }
    ApplicationDomain.TriggerHandler(Assets.Class);
}