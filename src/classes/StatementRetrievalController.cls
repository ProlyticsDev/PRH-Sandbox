public with sharing class StatementRetrievalController {
    
    public StatementRetrievalController(){
        showResultsTable = true;
        parse(jsonPayload.replace('\\','\\\\'));
    }

    private final string jsonPayload = retrievePayload();

    public static string SearchTerm {get;set;}
    public static string startDate {get;set;}
    public static string endDate {get;set;}
    
    public static boolean showResultsTable{get;set;}
    public static string resultsMessage {get;set;}
    
    public class STATEMENT {
        public String DocumentName {get;set;}
        public String DocumentDate {get;set;}
        public String PeriodKey {get;set;}
        public String StoredAs {get;set;}
        public date documentDateFormatted{
            get{
                return date.parse(DocumentDate.left(10).trim());
            }
        }
    }

    public static List<STATEMENT> statement {get;set;}
    
    public string retrievePayload(){
        
        /*string AccountNo = [SELECT Contact.Account.AccountNo__c
                            FROM User
                            WHERE Id = :UserInfo.getUserId() limit 1].Contact.AccountId;
        
        HTTPrequest req = new HTTPrequest();
		req.setEndpoint('/statements/getDocumentList?cusAcc='+AccountNo);
        req.setMethod('GET');
        
        http http = new http();
        HTTPresponse response = http.send(req);
        
        return response.getBody();*/
        
        return '{"STATEMENT" : [{"DocumentName":"DEB_ST107116       JUN 2016","DocumentDate":"27/06/2016 12:00:00 AM","PeriodKey":"201606","StoredAs":"20160627\\Id922619.pdf"},{"DocumentName":"DEB_ST107116       MAY 2016","DocumentDate":"30/05/2016 12:00:00 AM","PeriodKey":"201605","StoredAs":"20160530\\Id915459.pdf"},{"DocumentName":"DEB_ST107116       APR 2016","DocumentDate":"2/05/2016 12:00:00 AM","PeriodKey":"201604","StoredAs":"20160502\\Id906591.pdf"},{"DocumentName":"DEB_ST107116       MAR 2016","DocumentDate":"29/03/2016 12:00:00 AM","PeriodKey":"201603","StoredAs":"20160329\\Id897389.pdf"},{"DocumentName":"DEB_ST107116       FEB 2016","DocumentDate":"29/02/2016 12:00:00 AM","PeriodKey":"201602","StoredAs":"20160229\\Id888837.pdf"},{"DocumentName":"DEB_ST107116       JAN 2016","DocumentDate":"1/02/2016 12:00:00 AM","PeriodKey":"201601","StoredAs":"20160201\\Id880285.pdf"},{"DocumentName":"DEB_ST107116       DEC 2015","DocumentDate":"4/01/2016 12:00:00 AM","PeriodKey":"201512","StoredAs":"20160104\\Id871603.pdf"},{"DocumentName":"DEB_ST107116       NOV 2015","DocumentDate":"30/11/2015 12:00:00 AM","PeriodKey":"201511","StoredAs":"20151130\\Id862309.pdf"},{"DocumentName":"DEB_ST107116       OCT 2015","DocumentDate":"10/11/2015 12:00:00 AM","PeriodKey":"201510","StoredAs":"20151110\\Id857271.pdf"},{"DocumentName":"DEB_ST107116       SEP 2015","DocumentDate":"28/09/2015 12:00:00 AM","PeriodKey":"201509","StoredAs":"20150928\\Id842791.pdf"},{"DocumentName":"DEB_ST107116       AUG 2015","DocumentDate":"31/08/2015 12:00:00 AM","PeriodKey":"201508","StoredAs":"20150831\\Id833405.pdf"},{"DocumentName":"DEB_ST107116       JUL 2015","DocumentDate":"3/08/2015 12:00:00 AM","PeriodKey":"201507","StoredAs":"20150803\\Id824079.pdf"},{"DocumentName":"DEB_ST107116       JUN 2015","DocumentDate":"29/06/2015 12:00:00 AM","PeriodKey":"201506","StoredAs":"20150629\\Id814319.pdf"},{"DocumentName":"DEB_ST107116       MAY 2015","DocumentDate":"1/06/2015 12:00:00 AM","PeriodKey":"201505","StoredAs":"20150601\\Id806289.pdf"},{"DocumentName":"DEB_ST107116       APR 2015","DocumentDate":"27/04/2015 12:00:00 AM","PeriodKey":"201504","StoredAs":"20150427\\Id796497.pdf"},{"DocumentName":"DEB_ST107116       MAR 2015","DocumentDate":"30/03/2015 12:00:00 AM","PeriodKey":"201503","StoredAs":"20150330\\Id785871.pdf"},{"DocumentName":"DEB_ST107116       FEB 2015","DocumentDate":"4/03/2015 12:00:00 AM","PeriodKey":"201502","StoredAs":"20150304\\Id780515.pdf"},{"DocumentName":"DEB_ST107116       JAN 2015","DocumentDate":"2/02/2015 12:00:00 AM","PeriodKey":"201501","StoredAs":"20150202\\Id762977.pdf"},{"DocumentName":"DEB_ST107116       DEC 2014","DocumentDate":"2/01/2015 12:00:00 AM","PeriodKey":"201412","StoredAs":"20150102\\Id749805.pdf"},{"DocumentName":"DEB_ST107116       NOV 2014","DocumentDate":"1/12/2014 12:00:00 AM","PeriodKey":"201411","StoredAs":"20141201\\Id746911.pdf"}]}';
        
    }
    
    public void DoSearch(){
        
        parse(jsonPayload.replace('\\','\\\\'));        
        
        SET<STATEMENT> results = new SET<STATEMENT>();
        
        for(STATEMENT s : statement){
            
            if(SearchTerm == '' && StartDate == '' && EndDate == ''){
                
                results.addAll(statement);
                
            } else {
                if(SearchTerm != ''){
                    if(s.DocumentName.contains(SearchTerm)){
                        results.add(s);
                    }
                }
                
                if(StartDate != '' && EndDate == ''){
                    if(s.DocumentDateFormatted >= date.parse(StartDate)){
                        results.add(s);
                    }
                }
                
                if(StartDate == '' && EndDate != ''){
                    if(s.DocumentDateFormatted >= date.parse(EndDate)){
                        results.add(s);
                    }
                }
                
                if(StartDate != '' && EndDate != ''){
                    if(s.DocumentDateFormatted >= date.parse(StartDate) && s.DocumentDateFormatted <= date.parse(EndDate)){
                        results.add(s);
                    }
                }
            }
        }
            
        system.debug(results);
        
        if(results.isEmpty()){
            showResultsTable = false;
            resultsMessage = 'No Results Found';
        } else {
            showResultsTable = true;
            resultsMessage = '';
            statement.clear();
            statement.addAll(results);
        }
    }
    
    public static StatementRetrievalController parse(String payload) {
        return (StatementRetrievalController) JSON.deserialize(payload, StatementRetrievalController.class);
    }
   
}