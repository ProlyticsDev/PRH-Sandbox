trigger OnixInterestTrigger on Account_Interest__c (after insert, before delete) {
    if(Trigger.isAfter && Trigger.isInsert){
        InterestsUtil.onixInterestAfterInsert(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        InterestsUtil.onixInterestBeforeDelete(Trigger.old);
    }
}