public without sharing class TasksUtil{

    private static final string STATUS_COMPLETED = 'Completed';
    private static final string TYPE_PHONE = 'Phone';
    private static final string ACCOUNT_RL_TASKS = 'Tasks';
    
    public static void updateAccountLastCallDate(List<Task> tasks){
        List<Task> tasksThatQualify = new List<Task>();
        for(Task tsk: tasks){
            if(STATUS_COMPLETED.equals(tsk.Status) && TYPE_PHONE.equals(tsk.Type)){
                tasksThatQualify.add(tsk);
            }
        }
        tasks = tasksThatQualify;
        Set<Id> accountIds = new Set<Id>();
        for(Task tsk: tasks){
            accountIds.add(tsk.accountId);
        }
        List<Account> accountsToUpdate = [Select Id, Last_Call_Date__c, (Select id, ActivityDate from Tasks where Status = :STATUS_COMPLETED and Type = :TYPE_PHONE and ActivityDate <> null order by ActivityDate desc limit 1) from Account where id in :accountIds];
        List<Account> updatedAccounts = new List<Account>();
        for(Account acc: accountsToUpdate){
            List<Task> accTasks = acc.getSObjects(ACCOUNT_RL_TASKS);
            if(accTasks != null && accTasks.size()>0 && accTasks[0].ActivityDate != acc.Last_Call_Date__c){
                acc.Last_Call_Date__c = accTasks[0].ActivityDate;
                updatedAccounts.add(acc);
            }
        }
        if(updatedAccounts.size()>0){
            try{
                Database.update(updatedAccounts,false);
            }catch(DmlException ex){}// ignore failed updates.
        }
        /*
        Map<Id, Account> accountsMap = new Map<Id, Account>([Select Id, Last_Call_Date__c from Account where id in :accountIds]);
        for(Task tsk: tasks){
            Account acc = accountsMap.get(tsk.accountId);
            if(acc != null){
                if(acc.Last_Call_Date__c == null || acc.Last_Call_Date__c < tsk.ActivityDate){
                    acc.Last_Call_Date__c = tsk.ActivityDate;
                }
            }
        }
        if(accountsMap.values().size()>0) {
            try{
                Database.update(accountsMap.values(),false);
            }catch(DmlException ex){}// ignore failed updates.
        }
        */
    }
    
    public static testmethod void testUpdateAccountLastCallDate(){
        Account acc = new Account(Name = 'Test');
        insert acc;
        Task tsk = new Task(WhatId = acc.id, ActivityDate = Date.today(), Type='Phone', Status = 'Completed', Subject = 'Call');
        insert tsk;
        System.assertEquals(Date.today(), [Select id, Last_Call_Date__c from Account where id = :acc.id][0].Last_Call_Date__c);
        Task tsk2 = new Task(WhatId = acc.id, ActivityDate = Date.today()-1, Type='Phone', Status = 'Completed', Subject = 'Call');
        insert tsk2;
        System.assertEquals(Date.today(), [Select id, Last_Call_Date__c from Account where id = :acc.id][0].Last_Call_Date__c);
        Task tsk3 = new Task(WhatId = acc.id, ActivityDate = Date.today()+1, Type='Phone', Status = 'Completed', Subject = 'Call');
        insert tsk3;
        System.assertEquals(Date.today()+1, [Select id, Last_Call_Date__c from Account where id = :acc.id][0].Last_Call_Date__c);
    }
}