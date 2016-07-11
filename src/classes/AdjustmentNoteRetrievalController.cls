public class AdjustmentNoteRetrievalController {
    
    public AdjustmentNoteRetrievalController(){
        showResultsTable = true;
        sortBy = 'DOCUMENT_NUMBER';
        sortOrder = 'DESC'; 
        reorderTable();
    }

    private static string jsonPayload {get;set;}

    public static string SearchTerm {get;set;}
    public static string startDate {get;set;}
    public static string endDate {get;set;}
    public static string startIndex {get;set;}
    public static string endIndex {get;set;}
    public string sortBy {get;set;}
    public string sortOrder {get;set;}
    
    public static boolean showResultsTable{get;set;}
    public static string resultsMessage {get;set;}
    
    public class ADJUSTMENT_NOTE { //implements Comparable{
        public String ACCOUNT_NUMBER {get;set;}
        public String BILLING_NUMBER {get;set;}
        public String DOCUMENT_NUMBER {get;set;}
        public String DOCUMENT_DATE {get;set;}
        public String DOCUMENT_TYPE {get;set;}
        public String PERIOD_YYYYMM {get;set;}
        public String CUSTOMER_REFERENCE {get;set;}
        public String TOTAL_INVOICE_AMOUNT {get;set;}
        public String DOCUMENT_FILENAME {get;set;}
        public date documentDateFormatted{
            get{
                return date.parse(DOCUMENT_DATE.left(10).trim());
            }
        }
    }
    
    public static List<ADJUSTMENT_NOTE> adjustment_note {get;set;} 
    
    public void reorderTable(){
        retrievePayload();
        parse(jsonPayload.replace('\\','\\\\'));
    }
    
    public void retrievePayload(){
    
        /*string AccountNo = [SELECT Contact.Account.AccountNo__c
                            FROM User
                            WHERE Id = :UserInfo.getUserId() limit 1].Contact.AccountId;
		*/
        
		string endpoint = 'https://endpoint.com/statements/getDocumentList';
		endpoint += '?cusAcc=12345';// + AccountNo;

		if(searchTerm != '' && searchTerm != null)
			endpoint += '&searchTerm=' + searchTerm;

        if(startDate != '' && startDate != null){
            system.debug(startDate);
            date start = date.parse(startDate);
			endpoint += '&startDate=' + string.ValueOf(start.year() + '-' + start.month() + '-' + start.day());
        }

        if(endDate != '' && endDate != null){
            date finish = date.parse(endDate);
			endpoint += '&endDate=' + string.ValueOf(finish.year() + '-' + finish.month() + '-' + finish.day());
        }

		if(startIndex != '' && startIndex != null)
			endpoint += '&startIndex=' + startIndex;

		if(endIndex != null && endIndex != '')
			endpoint += '&endIndex=' + endIndex;

		if(sortBy != '' && sortBy != null)
			endpoint += '&sortBy=' + sortBy;

		if(sortOrder != '' && sortOrder != null)
			endpoint += '&sortOrder=' + sortOrder;
        
        /*HTTPrequest req = new HTTPrequest();
		req.setEndpoint(endpoint);
        req.setMethod('GET');
        
        http http = new http();
        HTTPresponse response = http.send(req);
        
        return response.getBody();*/
                                                     
        system.debug('Endpoint: ' + endPoint);
        
        jsonPayload = '{"ADJUSTMENT_NOTE" : [{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21037851","DOCUMENT_DATE":"4/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"26007                         ","TOTAL_INVOICE_AMOUNT":"-44.99","DOCUMENT_FILENAME":"20160504\\Id9640776.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21031430","DOCUMENT_DATE":"2/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"74288856                      ","TOTAL_INVOICE_AMOUNT":"-191.96","DOCUMENT_FILENAME":"20160502\\Id9625700.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21034819","DOCUMENT_DATE":"3/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"26028                         ","TOTAL_INVOICE_AMOUNT":"-20.51","DOCUMENT_FILENAME":"20160503\\Id9632110.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21037568","DOCUMENT_DATE":"4/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"26036                         ","TOTAL_INVOICE_AMOUNT":"-46.20","DOCUMENT_FILENAME":"20160504\\Id9639968.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21051768","DOCUMENT_DATE":"12/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"26043                         ","TOTAL_INVOICE_AMOUNT":"-71.62","DOCUMENT_FILENAME":"20160512\\Id9679432.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21051842","DOCUMENT_DATE":"12/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"26055                         ","TOTAL_INVOICE_AMOUNT":"-16.19","DOCUMENT_FILENAME":"20160512\\Id9679640.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21025870","DOCUMENT_DATE":"28/04/2016 12:00:00 AM","PERIOD_YYYYMM":"201604","CUSTOMER_REFERENCE":"74417853CRD                   ","TOTAL_INVOICE_AMOUNT":"-39.99","DOCUMENT_FILENAME":"20160503\\Id9629004.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21025876","DOCUMENT_DATE":"28/04/2016 12:00:00 AM","PERIOD_YYYYMM":"201604","CUSTOMER_REFERENCE":"74407671CRD                   ","TOTAL_INVOICE_AMOUNT":"-282.97","DOCUMENT_FILENAME":"20160503\\Id9629014.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21026812","DOCUMENT_DATE":"28/04/2016 12:00:00 AM","PERIOD_YYYYMM":"201604","CUSTOMER_REFERENCE":"26047                         ","TOTAL_INVOICE_AMOUNT":"-14.37","DOCUMENT_FILENAME":"20160503\\Id9629804.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"        ","DOCUMENT_DATE":"29/04/2016 12:00:00 AM","PERIOD_YYYYMM":"201604","CUSTOMER_REFERENCE":"RTN 20/04/16                  ","TOTAL_INVOICE_AMOUNT":"0.00","DOCUMENT_FILENAME":"?"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21085268","DOCUMENT_DATE":"30/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201606","CUSTOMER_REFERENCE":"74494998 EVENT                ","TOTAL_INVOICE_AMOUNT":"-172.71","DOCUMENT_FILENAME":"20160530\\Id9758472.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21070591","DOCUMENT_DATE":"23/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"ubdmay2016                    ","TOTAL_INVOICE_AMOUNT":"-5268.77","DOCUMENT_FILENAME":"20160524\\Id9720418.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21130505","DOCUMENT_DATE":"20/06/2016 12:00:00 AM","PERIOD_YYYYMM":"201606","CUSTOMER_REFERENCE":"26185                         ","TOTAL_INVOICE_AMOUNT":"-499.62","DOCUMENT_FILENAME":"20160620\\Id9842112.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21067849","DOCUMENT_DATE":"20/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"26087                         ","TOTAL_INVOICE_AMOUNT":"0.00","DOCUMENT_FILENAME":"20160520\\Id9716692.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21068726","DOCUMENT_DATE":"20/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"26071                         ","TOTAL_INVOICE_AMOUNT":"-17.81","DOCUMENT_FILENAME":"20160520\\Id9718698.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"        ","DOCUMENT_DATE":"3/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"08/04/16-1                    ","TOTAL_INVOICE_AMOUNT":"0.00","DOCUMENT_FILENAME":"?"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21035683","DOCUMENT_DATE":"3/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"74462901 CR                   ","TOTAL_INVOICE_AMOUNT":"-146.22","DOCUMENT_FILENAME":"20160503\\Id9634764.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"        ","DOCUMENT_DATE":"5/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"050416                        ","TOTAL_INVOICE_AMOUNT":"-17.09","DOCUMENT_FILENAME":"?"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21040031","DOCUMENT_DATE":"5/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"25983                         ","TOTAL_INVOICE_AMOUNT":"-18.90","DOCUMENT_FILENAME":"20160505\\Id9647398.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"21040032","DOCUMENT_DATE":"5/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"25996                         ","TOTAL_INVOICE_AMOUNT":"-10.79","DOCUMENT_FILENAME":"20160505\\Id9647406.pdf"}]}';
    }
    
    public void DoSearch(){
        
        retrievePayload();
        parse(jsonPayload.replace('\\','\\\\'));      
        
    }
    
    public static AdjustmentNoteRetrievalController parse(String payload) {
        return (AdjustmentNoteRetrievalController) JSON.deserialize(payload, AdjustmentNoteRetrievalController.class);
    }
    
}