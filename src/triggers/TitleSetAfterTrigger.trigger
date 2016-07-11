trigger TitleSetAfterTrigger on Title_Set__c (after insert, after update, after undelete) {
    
    // find the new active TitleSet
    Title_Set__c newActiveTitleSet;
    for(Title_Set__c temp: Trigger.new){
        if(temp.Is_Active__c){
            if( !Trigger.isUpdate || (Trigger.oldMap.get(temp.id).Is_Active__c != temp.Is_Active__c)){
                newActiveTitleSet = temp;
                break;
            }
        }
    }
    if(newActiveTitleSet!= null){
        TitleSetUtil.resetActiveTitleSets(newActiveTitleSet);
    }
}