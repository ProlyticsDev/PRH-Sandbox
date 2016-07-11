@isTest
public class TEST_CommunitySearchController {
    
    public static testmethod void insertData(){
        
        List<Invoice__c> invoices = new List<Invoice__c>();
        List<Statement__c> statements = new List<Statement__c>();
        
        for(integer i = 0; i < 100; i++){
            
            Invoice__c inv = new Invoice__c();
            	inv.Name = 'Test Invoice ' + string.valueOf(i) + string.valueOf(i);
            invoices.add(inv);
            
            Statement__c st = new Statement__c();
            	st.Name = 'Test Statement ' + string.valueOf(i) + string.valueOf(i);
            statements.add(st);
            
        }
        
        system.debug('Inserting '+invoices.size()+' invoices');
        database.insert(invoices);
        
        system.debug('Inserting '+statements.size()+' statements');
        database.insert(statements);

    }
    
    public static testmethod CommunitySearchController getCon(){
        CommunitySearchController c = new CommunitySearchController();
        c.SearchTerm = 'Test';
        return c;
    }
    
    public static testmethod void testDoSearch(){
        
        insertData();
        CommunitySearchController con = new CommunitySearchController();
		con.SearchTerm = 'Test';
        
        con.DoSearch();
        
        system.assertEquals(con.invoiceHasNext, true);
        con.invoiceNext();
        
        system.assertEquals(con.invoiceHasPrevious, true);
        con.invoicePrevious();
        
        system.assertEquals(con.statementHasNext, true);
        con.statementNext();
        
        system.assertEquals(con.statementHasPrevious, true);
        con.statementPrevious();
        
    }

}