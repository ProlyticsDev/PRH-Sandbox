public without sharing class TitleSetUtil{
    
    public static void resetActiveTitleSets(Title_Set__c newActiveTitleSet){
        List<Title_Set__c> resetTitleSets = [Select id from Title_Set__c where Is_Active__c = true and id <> :newActiveTitleSet.id];
        if(resetTitleSets==null || resetTitleSets.isEmpty()) return;
        for(Title_Set__c temp: resetTitleSets){
            temp.Is_Active__c = false;
        }
        update resetTitleSets;
    }
    
    public static testmethod void Test_resetActiveTitleSets(){
        Title_Set__c oldTitleSet = new Title_Set__c(Name = 'Test1', Is_Active__c = true);
        insert oldTitleSet;
        Title_Set__c newTitleSet = new Title_Set__c(Name = 'Test2', Is_Active__c = true);
        insert newTitleSet;
        System.assertEquals(false, [Select id, Is_Active__c from Title_Set__c where id = :oldTitleSet.id].Is_Active__c);
        
    }
    
}