trigger ManuscriptTrigger on Manuscript__c (before insert, before update) {
    Id contributorRecordTypeId = [select Id from RecordType where DeveloperName = 'SFDC_Title_Contributor_Account' limit 1][0].Id;
    List<Account> newAccountList = new List<Account>();
    Map<Id, Id> manuscriptIdAccountIdMap = new Map<Id, Id>();
    Set<Id> authorContactIds = new Set<Id>();
    for (Manuscript__c man : trigger.new){
        if(man.Author_Contact__c != null) authorContactIds.add(man.Author_Contact__c);
    }
    Map<Id, Contact> filledInAuthorContactsMap = new Map<Id,Contact>([Select id, FirstName, LastName, Email, HomePhone,
    MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry from Contact where id in :authorContactIds]);
    for (Manuscript__c man : trigger.new){
        if(man.Author_Contact__c != null){
            Contact authorContact = filledInAuthorContactsMap.get(man.Author_Contact__c);
            if(authorContact != null){
                man.Author_First_Name__c = authorContact.FirstName;
                man.Author_Last_Name__c = authorContact.LastName;
                man.Email__c = authorContact.Email;
                man.Contact_Phone__c = authorContact.HomePhone;
                man.Author_Street__c = authorContact.MailingStreet;
                man.Author_City__c = authorContact.MailingCity;
                man.Author_State__c = authorContact.MailingState; 
                man.Author_Postcode__c = authorContact.MailingPostalCode;
                man.Author_Country__c = authorContact.MailingCountry;
            }
        }
        else if (man.Author_Contact__c == null && man.Manuscript_Status__c == 'Accepted' && man.Author_First_Name__c != null && man.Author_Last_Name__c != null){
            Account author = new Account(FirstName = man.Author_First_Name__c, 
                LastName = man.Author_Last_Name__c,
                PersonEmail = man.Author_Email__c,
                PersonHomePhone = man.Author_Phone__c,
                PersonMailingStreet= man.Author_Street__c,
                PersonMailingCity = man.Author_City__c,
                PersonMailingState = man.Author_State__c,
                PersonMailingPostalCode = man.Author_Postcode__c,
                PersonMailingCountry = man.Author_Country__c,
                RecordTypeId = contributorRecordTypeId,
                Manuscript_Source_ID__c = man.Id,
                Is_AuthorType_BCYA__c = (man.Category__c == 'BCYA'),
                Is_AuthorType_General__c = (man.Category__c == 'General'),
                Is_AuthorType_Destiny__c = (man.Category__c == 'Destiny'),
                Is_AuthorType_Illustrator__c = (man.Category__c == 'Illustrated'),
                Is_AuthorType_International__c = (man.Category__c == 'International'),
                Is_AuthorType_Unmanaged__c = (man.Category__c == null));
            newAccountlist.add(author);
        }
    }
    if(newAccountList.size()>0){
        try {
            insert newAccountList;
            Set<Id> accountIdSet = new Set<Id>();
            for (Account acct: newAccountList){
                accountIdSet.add(acct.Id);
            }
            List<Account> tempAcctList = [select Manuscript_Source_ID__c, PersonContactId from Account where Id in :accountIdSet];
            
            for (Account acct : tempAcctList){
                manuscriptIdAccountIdMap.put(acct.Manuscript_Source_ID__c, acct.PersonContactId);   
            }
            
        }catch(DmlException e){
            for (Manuscript__c man : trigger.new){
                man.addError('There is a error in accepting this manuscript');
            }
        }
        
        for (Manuscript__c man : trigger.new){
            if (manuscriptIdAccountIdMap.keySet().contains(man.Id)){
                man.Author_Contact__c = manuscriptIdAccountIdMap.get(man.Id);
            }
        }
    }
}