public with sharing class CommunitySearchController {
    
    public ApexPages.StandardSetController invoiceCon{get; set;} 
    public ApexPages.StandardSetController statementCon{get; set;} 
    public string SearchTerm {get;set;}
    public boolean noneFoundMessage {get;set;}
    
    public string AccountId {get;set;}
    
    public CommunitySearchController(){
        lstInvoice = new List<Invoice__c>();
        lstStatement = new List<Statement__c>();
        
        AccountId = [select Contact.AccountId from User where Id = :UserInfo.getUserId() limit 1].Contact.AccountId;
        
        system.debug('UserId: ' + Userinfo.getUserId());
        system.debug('AccountId: '+ AccountId);
    }
    
    public List<Invoice__c> lstInvoice{  
        get{  
            if(invoiceCon != null)  
                return (List<Invoice__c>) invoiceCon.getRecords();  
            else  
                return null ;  
        }  
        set;
    }  
    
    public List<Statement__c> lstStatement{  
        get{  
            if(statementCon != null)  
                return (List<Statement__c>) statementCon.getRecords();  
            else  
                return null ;  
        }  
        set;
    }
    
    public PageReference DoSearch(){
            
        string invoiceQuery = 'SELECT Id, Name, Customer_Ref__c, Action__c, Invoice_Date__c';
            invoiceQuery += ' FROM Invoice__c';
            invoiceQuery += ' WHERE Name like \'%' + SearchTerm +'%\'';
            invoiceQuery += ' OR Customer_Ref__c like \'%' + SearchTerm +'%\''; 
        	invoiceQuery += ' ORDER BY Invoice_Date__c DESC';
        
        string statementQuery = 'SELECT Id, Name, Statement_Date__c, Action__c';
            statementQuery += ' FROM Statement__c';
            statementQuery += ' WHERE Name like \'%' + SearchTerm +'%\'';
        	statementQuery += ' ORDER BY Statement_Date__c DESC';
        
        System.debug('Invoice Query ---->'+ invoicequery );
        System.debug('Statement Query ---->'+ statementquery );
        
        invoiceCon = new ApexPages.StandardSetController(Database.getQueryLocator(invoiceQuery)); 
        invoiceCon.setPageSize(5);
        
        statementCon = new ApexPages.StandardSetController(Database.getQueryLocator(statementQuery)); 
        statementCon.setPageSize(5);
        
        system.debug(lstInvoice);
        system.debug(lstStatement);
        
        if(lstInvoice.isEmpty() && lstStatement.isEmpty())
            noneFoundMessage = true;
        else
            noneFoundMessage = false;

        return null;
    }
    
    public Boolean invoiceHasNext  {  
        get{  
            return invoiceCon.getHasNext();  
        }  
        set;  
    }  
    
    public Boolean invoiceHasPrevious  {  
        get{  
            return invoiceCon.getHasPrevious();  
        }  
        set;  
    }  
    
    public void invoicePrevious(){  
        invoiceCon.previous();  
    }  
    
    public void invoiceNext() {  
        invoiceCon.next();  
    }  
    
    public Boolean statementHasNext  {  
        get{  
            return statementCon.getHasNext();  
        }  
        set;  
    }  
    
    public Boolean statementHasPrevious  {  
        get{  
            return statementCon.getHasPrevious();  
        }  
        set;  
    }  
    
    public void statementPrevious(){  
        statementCon.previous();  
    }  
    
    public void statementNext() {  
        statementCon.next();  
    } 
    
}