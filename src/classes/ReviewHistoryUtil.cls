public without sharing class ReviewHistoryUtil{
    
    // review history after insert / update
    public static void updateManuscriptStatusViaReviewHistory(List<Review_History__c> reviewHistories){
        Set<Id> manuscriptIds = new Set<Id>();
        for(Review_History__c rh: reviewHistories){
            manuscriptIds.add(rh.Manuscript__c);
        }
        List<Manuscript__c> manuscripts = [Select id, Manuscript_Status__c, (Select id, FORMULA_RL_Delegate__c, Action_Date__c, Review_Action__c from Review_History__r order by Action_Date__c DESC limit 1) from Manuscript__c where id in :manuscriptIds];
        List<Manuscript__c> manuscriptsToUpdate = new List<Manuscript__c>();
        for(Manuscript__c manu: manuscripts){
            List<Review_History__c> rhs = manu.getSObjects('Review_History__r');
            if(rhs != null && rhs.size()>0 && rhs[0].Review_Action__c != manu.Manuscript_Status__c){
                manu.Manuscript_Status__c = rhs[0].Review_Action__c;
                manu.Last_Delegate__c = rhs[0].FORMULA_RL_Delegate__c;
                manu.Last_Action_Date__c = rhs[0].Action_Date__c;
                manuscriptsToUpdate.add(manu);
            }
        }
        if(manuscriptsToUpdate.size()>0){
            update manuscriptsToUpdate;
        }
    }
    
    public static testmethod void test_updateManuscriptStatusViaReviewHistory(){
        Manuscript__c man = new Manuscript__c(Name = 'Test', Author_First_Name__c = 'test', Author_Last_Name__c = 'Test',
            Manuscript_Status__c = 'For Initial Review');
        insert man;
        Review_History__c rh = new Review_History__c(Manuscript__c = man.id, Action_Date__c = Date.today()-1, Review_Action__c = 'Reading');
        insert rh;
        System.assertEquals(rh.Review_Action__c, [Select Manuscript_Status__c from Manuscript__c where id = :man.id][0].Manuscript_Status__c);
        
        Review_History__c rh2 = new Review_History__c(Manuscript__c = man.id, Action_Date__c = Date.today(), Review_Action__c = 'Declined');
        insert rh2;
        System.assertEquals(rh2.Review_Action__c, [Select Manuscript_Status__c from Manuscript__c where id = :man.id][0].Manuscript_Status__c);
        
        Review_History__c rh3 = new Review_History__c(Manuscript__c = man.id, Action_Date__c = Date.today()-2, Review_Action__c = 'Test');
        insert rh3;
        System.assertEquals(rh2.Review_Action__c, [Select Manuscript_Status__c from Manuscript__c where id = :man.id][0].Manuscript_Status__c);
        
    }
}