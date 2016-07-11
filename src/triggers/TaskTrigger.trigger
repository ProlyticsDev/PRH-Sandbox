trigger TaskTrigger on Task (after insert, after update) {
    TasksUtil.updateAccountLastCallDate(Trigger.new);
}