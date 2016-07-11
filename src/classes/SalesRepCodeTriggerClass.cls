public with sharing class SalesRepCodeTriggerClass {
    public static void updateAccountOwnerIdOnInsert(List<Account> newAccountList){
        newAccountList = filterToIntegratedAccountOnly(newAccountList);
        Set<String> salesRepCodeSet = new Set<String>();
        List<Sales_Rep_Code__c> srcList = new List<Sales_Rep_Code__c>();
        Map<String, Id> salesRepCodeOwnerIdMap = new Map<String, Id>();
        for (Account acct : newAccountList){
            if (acct.Sales_Rep_Code__c != null){
                salesRepCodeSet.add(acct.Sales_Rep_Code__c);
            }
        }
        // get list of Sales Rep Codes
        srcList = [select Id, Name, OwnerId from Sales_Rep_Code__c where Name in :salesRepCodeSet OR Name = 'DEFAULT'];
        
        for (Sales_Rep_Code__c src : srcList){
            salesRepCodeOwnerIdMap.put(src.Name, src.OwnerId);
        }
        
        for (Account acct : newAccountList){
            if (acct.Sales_Rep_Code__c != null){
                Id retrievedOwnerId = salesRepCodeOwnerIdMap.get(acct.Sales_Rep_Code__c);
                if (retrievedOwnerId != null) { // new - always change
                    acct.OwnerId = retrievedOwnerId;
                }
                else if (salesRepCodeOwnerIdMap.get('DEFAULT') != null){
                    acct.OwnerId = salesRepCodeOwnerIdMap.get('DEFAULT');
                }
            }
            else if (salesRepCodeOwnerIdMap.get('DEFAULT') != null){ // if Sales Rep code is blank
                acct.OwnerId = salesRepCodeOwnerIdMap.get('DEFAULT');
            }
        }
    }
    /*
    public static void updateAccountOwnerIdOnUpdate(List<Account> oldAccountList, List<Account> newAccountList){
        Set<String> salesRepCodeSet = new Set<String>();
        List<Sales_Rep_Code__c> srcList = new List<Sales_Rep_Code__c>();
        Map<String, Id> salesRepCodeOwnerIdMap = new Map<String, Id>();
        for (Integer i = 0; i < newAccountList.size(); i++){
            if (newAccountList[i].Sales_Rep_Code__c != null && oldAccountList[i].Sales_Rep_Code__c != newAccountList[i].Sales_Rep_Code__c){
                salesRepCodeSet.add(newAccountList[i].Sales_Rep_Code__c);
            }
        }
        // get list of Sales Rep Codes
        srcList = [select Id, Name, OwnerId from Sales_Rep_Code__c where Name in :salesRepCodeSet OR Name = 'DEFAULT'];
        
        for (Sales_Rep_Code__c src : srcList){
            salesRepCodeOwnerIdMap.put(src.Name, src.OwnerId);
        }
        
        for (Integer i =0; i < newAccountList.size(); i++){
            if (newAccountList[i].Sales_Rep_Code__c != null && oldAccountList[i].Sales_Rep_Code__c != newAccountList[i].Sales_Rep_Code__c){
                Id retrievedOwnerId = salesRepCodeOwnerIdMap.get(newAccountList[i].Sales_Rep_Code__c);
                if (retrievedOwnerId != null) {
                    newAccountList[i].OwnerId = retrievedOwnerId;
                }
                else  if (salesRepCodeOwnerIdMap.get('DEFAULT') != null){
                    newAccountList[i].OwnerId = salesRepCodeOwnerIdMap.get('DEFAULT');
                }   
            }
            else if (salesRepCodeOwnerIdMap.get('DEFAULT') != null){ // if Sales Rep code is blank
                newAccountList[i].OwnerId = salesRepCodeOwnerIdMap.get('DEFAULT');
            }
            
        }
        
    }
    */
    public static void updateContactOwnerAccount(List<Account> newAccountList){
        newAccountList = filterToIntegratedAccountOnly(newAccountList);
        List<Contact> contacts = new List<Contact>();       
        contacts = [Select AccountId, OwnerId From Contact Where AccountId IN :newAccountList AND Account.RecordType.IsPersonType<>True];
        system.debug('@@@ '+contacts.size());
        if(contacts.size() > 0){
        //Update contact owners
            for(Account account: newAccountList){
                for(Contact contact: contacts){
                    if(account.Id == contact.AccountId && contact.OwnerId != account.OwnerId){
                        contact.OwnerId = account.OwnerId;
                    }
                }               
            }
            try{
                Database.update(contacts, false);
            }catch(DMLException ex){}
        }
        
    }
    private static List<Account> filterToIntegratedAccountOnly(List<Account> newAccount){
        List<Account> filteredAccountList = new List<Account>();
        for(Account acc: newAccount){
            if(acc.AccountNo__c != null && !''.equals(acc.AccountNo__c.trim())){
                filteredAccountList.add(acc);
            }
        }
        return filteredAccountList;
    }
    public static void updateContactOwner(List<Contact> oldContactList,List<Contact> newContactList){
        List <Id> accID = new List <Id>();
        List <Account> accounts = new List<Account>();
        
        for(Contact contact: newContactList){
            if(contact.AccountID != null)
                accID.add(contact.AccountID);
        }
        
        accounts = [Select OwnerId, Id From Account where Id IN :accID];
        if(oldContactList != null){
            for (Integer i =0; i < newContactList.size(); i++){
                if (oldContactList[i].OwnerId != newContactList[i].OwnerId){
                    for(Account account: accounts){
                        if(account.Id == newContactList[i].AccountId)
                            newContactList[i].OwnerId = account.OwnerId;        
                    }
                }else{
                    for(Account account: accounts){
                        if(account.Id == newContactList[i].AccountId && newContactList[i].OwnerId != account.OwnerId)
                            newContactList[i].OwnerId = account.OwnerId;        
                    }
                }
            }
        }else{
            for(Contact contact: newContactList){
                if(contact.AccountId != null){
                    for(Account account: accounts){
                        if(account.Id == contact.AccountId)
                            contact.OwnerId = account.OwnerId;      
                    }   
                }
            }
        }   
    }
    @isTest (SeeAllData=true) private static void testSalesRepCodeClass() {
        // TO DO: test method
    } 
}