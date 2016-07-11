trigger KeywordInterestTrigger on Title_Keyword_Interest__c (after insert, before delete) {
    if(Trigger.isAfter && Trigger.isInsert){
        InterestsUtil.keywordInterestAfterInsert(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        InterestsUtil.keywordInterestBeforeDelete(Trigger.old);
    }
}