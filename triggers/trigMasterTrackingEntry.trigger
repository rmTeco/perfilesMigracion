trigger trigMasterTrackingEntry on vlocity_cmt__VlocityTrackingEntry__c (before insert) {

        if (Trigger.isBefore) {
            if (Trigger.isInsert) { TrackingEntryClass.updateTrackingEntry(Trigger.new); }
        }

}