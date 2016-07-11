@isTest
public class TEST_URLEncryptionClasses {
    
    public static testmethod void test_InvoiceURLEncryptionController(){
        
        Account a = new Account();
        	a.Name = 'Test Account';
        	a.AccountNo__c = '999999';
        insert a;
        
        Contact c = new Contact();
        	c.AccountId = a.Id;
        	c.LastName = 'Test';
        
        insert c;
        
        invoice__c inv = new Invoice__c();
        	inv.Account__c = a.Id;
        	inv.Document_ID__c = '123456789.pdf';
        	inv.Billing_Number__c = '999999';
        	
        insert inv;
        
        ApexPages.StandardController sc = new ApexPages.standardController(inv);
        InvoiceURLEncryptionController invCon = new InvoiceURLEncryptionController(sc);
        
        invCon.cid = string.valueOf(c.Id).left(15);
        invCon.contactList = new List<Contact>{c};
        
        invCon.HashRedirect();
    }
    
    public static testmethod void test_StatementURLEncryptionController(){
        
        Account a = new Account();
        	a.Name = 'Test Account';
        	a.AccountNo__c = '999999';
        insert a;
        
        Contact c = new Contact();
        	c.AccountId = a.Id;
        	c.LastName = 'Test';
        
        insert c;
        
        Statement__c st = new Statement__c();
        	st.Account__c = a.Id;
        	st.Document_ID__c = '123456789.pdf';
        
        insert st;
        
        ApexPages.StandardController sc = new ApexPages.standardController(st);
        StatementURLEncryptionController stCon = new StatementURLEncryptionController(sc);
        
        stCon.cid = string.valueOf(c.Id).left(15);
        stCon.contactList = new List<Contact>{c};
        
        stCon.HashRedirect();
    }

}