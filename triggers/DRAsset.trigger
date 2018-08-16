trigger DRAsset on DRAsset__c (after insert, after update) {
    vlocity_cmt.DRGlobal.triggerHandler(Trigger.new);
}