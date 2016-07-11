trigger AccountTrigger on Account (before insert, before update, after update) {
    if (trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        SalesRepCodeTriggerClass.updateAccountOwnerIdOnInsert(trigger.new);
    }
    /* CHANGE - to always check
    if (trigger.isUpdate && trigger.isBefore){
        SalesRepCodeTriggerClass.updateAccountOwnerIdOnUpdate(trigger.old, trigger.new); 
    }*/ 
    else if (trigger.isAfter && trigger.isUpdate){
        SalesRepCodeTriggerClass.updateContactOwnerAccount(trigger.new);
    }
}