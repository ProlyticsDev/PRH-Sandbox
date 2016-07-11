trigger TitleInterestTrigger on Title_Interest__c (after insert, before delete) {
    if(Trigger.isAfter && Trigger.isInsert){
        InterestsUtil.titleInterestAfterInsert(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        InterestsUtil.titleInterestBeforeDelete(Trigger.old);
    }
}