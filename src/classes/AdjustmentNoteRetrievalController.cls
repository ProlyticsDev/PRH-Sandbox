public with sharing class AdjustmentNoteRetrievalController {
    
    public AdjustmentNoteRetrievalController(){
        doSearch();
    }
    
    public static final CommunityUtility util = new CommunityUtility();

    public string jsonPayload;
    
    public static integer ROW_COUNT {get;set;}
        
    public static final string cusAcc = '107116'; //[select Account.AccountNo__c from Contact where Id = :userInfo.getUserId() limit 1].Account.AccountNo__c;
    public static string SearchTerm {get;set;}
    public static string startDate {get;set;}
    public static string endDate {get;set;}
    public static string startIndex {get;set;}
    public static string endIndex {get;set;}
    public static string sortBy {get;set;}
    public static string sortOrder {get;set;}
    
    public boolean hasNext {
        get{
            if(endIndex != null && (ROW_COUNT >= integer.valueOf(endIndex) + 1))
                return true;
            else
                return false;
        }
    }
    
    public boolean hasPrevious {
        get{
            if(startIndex != null && integer.valueOf(startIndex) > 0)
                return true;
            else
                return false;
        }
    }
    
    public void getNext(){
        startIndex = string.valueOf(integer.valueOf(startIndex) + 20);
        endIndex = string.valueOf(integer.valueOf(endIndex) + 20);
        
        doSearch();
    }
    
    public void getPrevious(){
        startIndex = string.valueOf(integer.valueOf(startIndex) - 20);
        endIndex = string.valueOf(integer.valueOf(endIndex) - 20);
        
        doSearch();
    }
    
    public class ADJUSTMENT_NOTE {

        public String ACCOUNT_NUMBER{get;set;}
        public String BILLING_NUMBER{get;set;}
        public String DOCUMENT_NUMBER{get;set;}
        public String DOCUMENT_DATE{get;set;}
        public String DOCUMENT_TYPE{get;set;}
        public String PERIOD_YYYYMM{get;set;}
        public String CUSTOMER_REFERENCE{get;set;}
        public String TOTAL_INVOICE_AMOUNT{get;set;}
        public String DOCUMENT_FILENAME{get;set;}
        public date documentDateFormatted{
            get{
                return date.parse(DOCUMENT_DATE.left(10).trim());
            }
        }
        public string encryptedUrl {
            get{
                integer ts = util.getEpochTime();

                string clearText = 'userId='+UserInfo.getUserId()
                    + '&cusAcc=' + cusAcc
                    + '&docId=' + DOCUMENT_NUMBER
                    + '&ts=' + ts;
                
                clearText = util.stringEncrypter(clearText);
                return clearText; 
            }
        }
    }
    
    public static List<ADJUSTMENT_NOTE> adjustment_note {get;set;}  
    
    
    public void DoSearch(){
        
        string requestBody = util.getRequestBody(cusAcc, searchTerm, startDate, endDate, startIndex, endIndex, sortBy, sortOrder);
        jsonPayload = util.retrievePayload(requestBody, 'invoices');
        
        parse(jsonPayload.replace('\\','\\\\')); 
            
    }
    
    public static AdjustmentNoteRetrievalController parse(String payload) {
        return (AdjustmentNoteRetrievalController) JSON.deserialize(payload, AdjustmentNoteRetrievalController.class);
    }

}