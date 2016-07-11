public class testClass {
    
    public Invoice__c inv {get;set;}   
    public ApexPages.StandardSetController con{get; set;} 
    public string SearchTerm {get;set;}
    
    public testClass (){
        inv = new Invoice__c();
        lstInvoice = new List<Invoice__c>();
    }
    
    public List<Invoice__c> lstInvoice{  
        get{  
            if(con != null)  
                return (List<Invoice__c>)con.getRecords();  
            else  
                return null ;  
        }  
        set;
    }  
    public PageReference Search(){
            
        string invoiceQuery = 'SELECT Id, Name, Customer_Ref__c, Action__c';
        invoiceQuery += ' FROM Invoice__c';
        invoiceQuery += ' WHERE Name like \'%' + SearchTerm +'%\'';
        invoiceQuery += ' OR Customer_Ref__c like \'%' + SearchTerm +'%\'';
        
        System.debug('Query ---->'+ invoicequery );
        
        con = new ApexPages.StandardSetController(Database.getQueryLocator(invoiceQuery)); 
        con.setPageSize(5);
        
        system.debug(lstInvoice);

        return null;
    }
    
    public Boolean hasNext  {  
        get{  
            return con.getHasNext();  
        }  
        set;  
    }  
    
    public Boolean hasPrevious  {  
        get{  
            return con.getHasPrevious();  
        }  
        set;  
    }  
    
    public Integer pageNumber {  
        get{  
            return con.getPageNumber();  
        }  
        set;  
    }  
    
    public void previous(){  
        con.previous();  
    }  
    
    public void next() {  
        con.next();  
    }  
    
}