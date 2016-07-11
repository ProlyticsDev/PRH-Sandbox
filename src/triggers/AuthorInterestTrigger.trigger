trigger AuthorInterestTrigger on Author_Interest__c (after insert, before delete) {
    if(Trigger.isAfter && Trigger.isInsert){
        InterestsUtil.authorInterestAfterInsert(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        InterestsUtil.authorInterestBeforeDelete(Trigger.old);
    }
}