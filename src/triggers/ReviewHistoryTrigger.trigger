trigger ReviewHistoryTrigger on Review_History__c (after insert, after update) {
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        ReviewHistoryUtil.updateManuscriptStatusViaReviewHistory(Trigger.new);
    }
}