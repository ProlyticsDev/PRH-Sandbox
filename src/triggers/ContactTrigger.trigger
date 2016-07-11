trigger ContactTrigger on Contact (before insert, before update, after insert) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        SalesRepCodeTriggerClass.updateContactOwner(trigger.old,trigger.new);
    }
    if(Trigger.isAfter && Trigger.isInsert){
        InterestsUtil.contactAfterInsert(trigger.new);
    }
}