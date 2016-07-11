public without sharing class InterestsUtil {

    private static final String REL_ACCOUNT_CONTACTS = 'Contacts';
    private static final String REL_ACCOUNT_ONIXINT = 'Account_Interests__r';
    private static final String REL_ACCOUNT_KEYINT = 'Title_Keyword_Interests__r';
    private static final String REL_ACCOUNT_TITLEINT = 'Title_Interests__r';
    private static final String REL_ACCOUNT_AUTHORINT = 'Author_Interests__r';
    
    public static void onixInterestAfterInsert(List<Account_Interest__c> newOnixInterests){
        Set<Id> accountIds = new Set<Id>();
        for(Account_Interest__c onixInt: newOnixInterests){
            accountIds.add(onixInt.Account__c);
        }
        Map<Id,Account> accountsWithContactIdsMap = new Map<Id, Account>([Select id, (Select id from Contacts) from Account where id in :accountIds]);
        List<Contact_ONIX_Interest__c> contactOnixInterestsToInsert = new List<Contact_ONIX_Interest__c>();
        for(Account_Interest__c onixInt: newOnixInterests){
            Account accWithConIds = accountsWithContactIdsMap.get(onixInt.Account__c);
            List<Contact> contactsList = accWithConIds.getSObjects(REL_ACCOUNT_CONTACTS);
            if(contactsList!=null && contactsList.size()!=0) {
                for(Contact con: contactsList){
                    contactOnixInterestsToInsert.add(new Contact_ONIX_Interest__c(Contact__c = con.id, Account_ONIX_Interest__c = onixInt.id));
                }
            }
        }
        if(contactOnixInterestsToInsert.size()>0) bulkInsert(contactOnixInterestsToInsert);
    }
    public static void onixInterestBeforeDelete(List<Account_Interest__c> deletedOnixInterests){
        for(List<Contact_ONIX_Interest__c> contactOnixInterestsToDelete: [Select id from Contact_ONIX_Interest__c where Account_ONIX_Interest__c in :deletedOnixInterests]){
            delete contactOnixInterestsToDelete;
        }
    }
    
    public static void keywordInterestAfterInsert(List<Title_Keyword_Interest__c> newKeywordInterests){
        Set<Id> accountIds = new Set<Id>();
        for(Title_Keyword_Interest__c keyInt: newKeywordInterests){
            accountIds.add(keyInt.Account__c);
        }
        Map<Id,Account> accountsWithContactIdsMap = new Map<Id, Account>([Select id, (Select id from Contacts) from Account where id in :accountIds]);
        List<Contact_Keyword_Interest__c> contactKeywordInterestsToInsert = new List<Contact_Keyword_Interest__c>();
        for(Title_Keyword_Interest__c keyInt: newKeywordInterests){
            Account accWithConIds = accountsWithContactIdsMap.get(keyInt.Account__c);
            List<Contact> contactsList = accWithConIds.getSObjects(REL_ACCOUNT_CONTACTS);
            if(contactsList!=null && contactsList.size()!=0) {
                for(Contact con: contactsList){
                    contactKeywordInterestsToInsert.add(new Contact_Keyword_Interest__c(Contact__c = con.id, Title_Keyword_Interest__c = keyInt.id));
                }
            }
        }
        if(contactKeywordInterestsToInsert.size()>0) bulkInsert(contactKeywordInterestsToInsert);
    }
    public static void keywordInterestBeforeDelete(List<Title_Keyword_Interest__c> deletedKeywordInterests){
        for(List<Contact_Keyword_Interest__c> contactKeywordInterestsToDelete: [Select id from Contact_Keyword_Interest__c where Title_Keyword_Interest__c in :deletedKeywordInterests]){
            delete contactKeywordInterestsToDelete;
        }
    }
    
    public static void titleInterestAfterInsert(List<Title_Interest__c> newTitleInterests){
        Set<Id> accountIds = new Set<Id>();
        for(Title_Interest__c titleInt: newTitleInterests){
            accountIds.add(titleInt.Account__c);
        }
        Map<Id,Account> accountsWithContactIdsMap = new Map<Id, Account>([Select id, (Select id from Contacts) from Account where id in :accountIds]);
        List<Contact_Title_Interest__c> contactTitleInterestsToInsert = new List<Contact_Title_Interest__c>();
        for(Title_Interest__c titleInt: newTitleInterests){
            Account accWithConIds = accountsWithContactIdsMap.get(titleInt.Account__c);
            List<Contact> contactsList = accWithConIds.getSObjects(REL_ACCOUNT_CONTACTS);
            if(contactsList!=null && contactsList.size()!=0) {
                for(Contact con: contactsList){
                    contactTitleInterestsToInsert.add(new Contact_Title_Interest__c(Contact__c = con.id, Title_Interest__c = titleInt.id));
                }
            }
        }
        if(contactTitleInterestsToInsert.size()>0) bulkInsert(contactTitleInterestsToInsert);
    }
    public static void titleInterestBeforeDelete(List<Title_Interest__c> deletedTitleInterests){
        for(List<Contact_Title_Interest__c> contactTitleInterestsToDelete: [Select id from Contact_Title_Interest__c where Title_Interest__c in :deletedTitleInterests]){
            delete contactTitleInterestsToDelete;
        }
    }
    
    public static void authorInterestAfterInsert(List<Author_Interest__c> newAuthorInterests){
        Set<Id> accountIds = new Set<Id>();
        for(Author_Interest__c authorInt: newAuthorInterests){
            accountIds.add(authorInt.Account__c);
        }
        Map<Id,Account> accountsWithContactIdsMap = new Map<Id, Account>([Select id, (Select id from Contacts) from Account where id in :accountIds]);
        List<Contact_Author_Interest__c> contactAuthorInterestsToInsert = new List<Contact_Author_Interest__c>();
        for(Author_Interest__c authorInt: newAuthorInterests){
            Account accWithConIds = accountsWithContactIdsMap.get(authorInt.Account__c);
            List<Contact> contactsList = accWithConIds.getSObjects(REL_ACCOUNT_CONTACTS);
            if(contactsList!=null && contactsList.size()!=0) {
                for(Contact con: contactsList){
                    contactAuthorInterestsToInsert.add(new Contact_Author_Interest__c(Contact__c = con.id, Author_Interest__c = authorInt.id));
                }
            }
        }
        if(contactAuthorInterestsToInsert.size()>0) bulkInsert(contactAuthorInterestsToInsert);
    }
    public static void authorInterestBeforeDelete(List<Author_Interest__c> deletedAuthorInterests){
        for(List<Contact_Author_Interest__c> contactAuthorInterestsToDelete: [Select id from Contact_Author_Interest__c where Author_Interest__c in :deletedAuthorInterests]){
            delete contactAuthorInterestsToDelete;
        }
    }
    
    public static void contactAfterInsert(List<Contact> newContacts){
        Set<Id> accountIds = new Set<Id>();
        for(Contact con: newContacts){
            accountIds.add(con.AccountId);
        }
        Map<Id,Account> accountsWithInterestIdsMap = new Map<Id, Account>([Select id, (Select id from Account_Interests__r), (Select id from Title_Keyword_Interests__r), (Select id from Title_Interests__r), (Select id from Author_Interests__r) from Account where id in :accountIds]);
        List<Contact_ONIX_Interest__c> contactOnixInterestsToInsert = new List<Contact_ONIX_Interest__c>();
        List<Contact_Keyword_Interest__c> contactKeywordInterestsToInsert = new List<Contact_Keyword_Interest__c>();
        List<Contact_Title_Interest__c> contactTitleInterestsToInsert = new List<Contact_Title_Interest__c>();
        List<Contact_Author_Interest__c> contactAuthorInterestsToInsert = new List<Contact_Author_Interest__c>();
        for(Contact con: newContacts){
            Account accWithInterestIds = accountsWithInterestIdsMap.get(con.AccountId);
            if(accWithInterestIds!=null){
                List<Account_Interest__c> onixInterestList = accWithInterestIds.getSObjects(REL_ACCOUNT_ONIXINT);
                if(onixInterestList!=null && onixInterestList.size()!=0) {
                    for(Account_Interest__c onixInt: onixInterestList){
                        contactOnixInterestsToInsert.add(new Contact_ONIX_Interest__c(Contact__c = con.id, Account_ONIX_Interest__c = onixInt.id));
                    }
                }
                List<Title_Keyword_Interest__c> keywordInterestList = accWithInterestIds.getSObjects(REL_ACCOUNT_KEYINT);
                if(keywordInterestList!=null && keywordInterestList.size()!=0) {
                    for(Title_Keyword_Interest__c keyInt: keywordInterestList){
                        contactKeywordInterestsToInsert.add(new Contact_Keyword_Interest__c(Contact__c = con.id, Title_Keyword_Interest__c = keyInt.id));
                    }
                }
                List<Title_Interest__c> titleInterestList = accWithInterestIds.getSObjects(REL_ACCOUNT_TITLEINT);
                if(titleInterestList!=null && titleInterestList.size()!=0) {
                    for(Title_Interest__c titleInt: titleInterestList){
                        contactTitleInterestsToInsert.add(new Contact_Title_Interest__c(Contact__c = con.id, Title_Interest__c = titleInt.id));
                    }
                }
                List<Author_Interest__c> authorInterestList = accWithInterestIds.getSObjects(REL_ACCOUNT_AUTHORINT);
                if(authorInterestList!=null && authorInterestList.size()!=0) {
                    for(Author_Interest__c authorInt: authorInterestList){
                        contactAuthorInterestsToInsert.add(new Contact_Author_Interest__c(Contact__c = con.id, Author_Interest__c = authorInt.id));
                    }
                }
            }
        }
        if(contactOnixInterestsToInsert.size()>0) bulkInsert(contactOnixInterestsToInsert);
        if(contactKeywordInterestsToInsert.size()>0) bulkInsert(contactKeywordInterestsToInsert);
        if(contactTitleInterestsToInsert.size()>0) bulkInsert(contactTitleInterestsToInsert);
        if(contactAuthorInterestsToInsert.size()>0) bulkInsert(contactAuthorInterestsToInsert);
    }
    
    private static void bulkInsert(List<SObject> sobjects){
        List<SObject> smallList = new List<SObject>();
        for(SObject sobj: sobjects){
            smallList.add(sobj);
            if(smallList.size()==Limits.getLimitDMLRows()){
                insert smallList;
                smallList = new List<SObject>();
            }
        }
        if(smallList.size()>0){
            insert smallList;
        }
    }
    
    public static testmethod void testInterestsUtil(){
        ONIX_Subject__c testOnixSub = new ONIX_Subject__c(Name = 'TestSub', Code__c = 'TEST');
        insert testOnixSub;
        Product2 testTitle = new Product2(Name = 'TBD', Title__c = 'Test Title', ISBN__c = 'TestISBN');
        insert testTitle;
        Id authorRTID = [Select id from RecordType where DeveloperName = 'SFDC_Title_Contributor_Account'][0].id;
        Account testAuthor = new Account(LastName = 'TestAuthor', recordTypeId = authorRTID, Is_AuthorType_BCYA__c = true);
        insert testAuthor;
        Account testAccount = new Account(Name = 'TestAcc');
        insert testAccount;
        Contact testContact = new Contact(LastName = 'Test Contact', accountid=testAccount.id);
        insert testContact;
        
        Account_Interest__c testOnixInt = new Account_Interest__c(Account__c = testAccount.id, Interest_Category__c = testOnixSub.id);
        insert testOnixInt;
        System.assertEquals(1, [Select id from Contact_ONIX_Interest__c where Account_ONIX_Interest__c = :testOnixInt.id].size());
        System.assertEquals(1, [Select id from Contact_ONIX_Interest__c where Contact__c = :testContact.id and Account_ONIX_Interest__c = :testOnixInt.id].size());
        
        Title_Keyword_Interest__c testkeyInt = new Title_Keyword_Interest__c(Account__c = testAccount.id, Keyword__c ='TESTKEYWORD');
        insert testkeyInt;
        System.assertEquals(1, [Select id from Contact_Keyword_Interest__c where Title_Keyword_Interest__c = :testkeyInt.id].size());
        System.assertEquals(1, [Select id from Contact_Keyword_Interest__c where Contact__c = :testContact.id and Title_Keyword_Interest__c = :testkeyInt.id].size());
        
        Title_Interest__c testTitleInt = new Title_Interest__c(Account__c = testAccount.id, Title__c =testTitle.id);
        insert testTitleInt;
        System.assertEquals(1, [Select id from Contact_Title_Interest__c where Title_Interest__c = :testTitleInt.id].size());
        System.assertEquals(1, [Select id from Contact_Title_Interest__c where Contact__c = :testContact.id and Title_Interest__c = :testTitleInt.id].size());
        
        Author_Interest__c testAuthorInt = new Author_Interest__c(Account__c = testAccount.id, Author__c =testAuthor.id);
        insert testAuthorInt;
        System.assertEquals(1, [Select id from Contact_Author_Interest__c where Author_Interest__c = :testAuthorInt.id].size());
        System.assertEquals(1, [Select id from Contact_Author_Interest__c where Contact__c = :testContact.id and Author_Interest__c = :testAuthorInt.id].size());
        
        Contact testContact2 = new Contact(LastName = 'Test Contact2', accountid=testAccount.id);
        insert testContact2;
        
        System.assertEquals(2, [Select id from Contact_ONIX_Interest__c where Account_ONIX_Interest__c = :testOnixInt.id].size());
        System.assertEquals(1, [Select id from Contact_ONIX_Interest__c where Contact__c = :testContact.id and Account_ONIX_Interest__c = :testOnixInt.id].size());
        System.assertEquals(1, [Select id from Contact_ONIX_Interest__c where Contact__c = :testContact2.id and Account_ONIX_Interest__c = :testOnixInt.id].size());
        
        System.assertEquals(2, [Select id from Contact_Keyword_Interest__c where Title_Keyword_Interest__c = :testkeyInt.id].size());
        System.assertEquals(1, [Select id from Contact_Keyword_Interest__c where Contact__c = :testContact.id and Title_Keyword_Interest__c = :testkeyInt.id].size());
        System.assertEquals(1, [Select id from Contact_Keyword_Interest__c where Contact__c = :testContact2.id and Title_Keyword_Interest__c = :testkeyInt.id].size());
        
        System.assertEquals(2, [Select id from Contact_Title_Interest__c where Title_Interest__c = :testTitleInt.id].size());
        System.assertEquals(1, [Select id from Contact_Title_Interest__c where Contact__c = :testContact.id and Title_Interest__c = :testTitleInt.id].size());
        System.assertEquals(1, [Select id from Contact_Title_Interest__c where Contact__c = :testContact2.id and Title_Interest__c = :testTitleInt.id].size());
        
        System.assertEquals(2, [Select id from Contact_Author_Interest__c where Author_Interest__c = :testAuthorInt.id].size());
        System.assertEquals(1, [Select id from Contact_Author_Interest__c where Contact__c = :testContact.id and Author_Interest__c = :testAuthorInt.id].size());
        System.assertEquals(1, [Select id from Contact_Author_Interest__c where Contact__c = :testContact2.id and Author_Interest__c = :testAuthorInt.id].size());
        
        delete testOnixInt;
        System.assertEquals(0, [Select id from Contact_ONIX_Interest__c where Contact__c = :testContact.id].size());
        System.assertEquals(0, [Select id from Contact_ONIX_Interest__c where Contact__c = :testContact2.id].size());
        
        delete testkeyInt;
        System.assertEquals(0, [Select id from Contact_Keyword_Interest__c where Contact__c = :testContact.id].size());
        System.assertEquals(0, [Select id from Contact_Keyword_Interest__c where Contact__c = :testContact2.id].size());
        
        delete testTitleInt;
        System.assertEquals(0, [Select id from Contact_Title_Interest__c where Contact__c = :testContact.id].size());
        System.assertEquals(0, [Select id from Contact_Title_Interest__c where Contact__c = :testContact2.id].size());
        
        delete testAuthorInt;
        System.assertEquals(0, [Select id from Contact_Author_Interest__c where Contact__c = :testContact.id].size());
        System.assertEquals(0, [Select id from Contact_Author_Interest__c where Contact__c = :testContact2.id].size());
                
    }
}