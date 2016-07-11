global class CommunityUtility {
    
    public string stringEncrypter(string clearText){
        
        system.debug('clearText: ' + clearText);
        
        string algo = 'AES256';
        blob key = blob.valueOf('12345678901234567890123456789012');
        blob iv = blob.valueOf('1234567890123456');
        Blob hashstring = Blob.valueOf(clearText);
        
        Blob encrypted = Crypto.encrypt(algo, key, iv, hashString);
        system.debug('Encrypted String :' + encodingUtil.base64Encode(encrypted)); 
        
        string finalString = encodingUtil.base64Encode(encrypted)
            .replace('=','.')
            .replace('+', '-')
            .replace('/', '_');
        
        system.debug('Final String :' + finalString); 
        
        return finalString;
    }
    
    public integer getEpochTime(){
        
        long milliNow = datetime.now().gettime();
        long milliEpoch = datetime.newInstanceGMT(1970, 1, 1, 0, 0, 0).gettime();
        
        return integer.valueOf((milliNow - milliEpoch)/1000);
    }
    
    public string retrievePayload(string requestBody
                                  , string documentType){
                                      
                                      string endpoint='https://portal.penguinrandomhouse.com.au/' + documentType + '/getDocumentList?p=' + requestBody;
                                      
                                      HTTPrequest req = new HTTPrequest();
                                      req.setEndpoint(endpoint);
                                      req.setMethod('GET');
                                      
                                      http http = new http();
                                      HTTPresponse response = http.send(req);
                                      
                                      system.debug(req.getEndpoint());
                                      system.debug(response.getBody());
                                      //return response.getBody();
                                      return '{"ROW_COUNT":5 , "INVOICE" : [{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"74374597","DOCUMENT_DATE":"1/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"lehg0516                      ","TOTAL_INVOICE_AMOUNT":"626.98","DOCUMENT_FILENAME":"20160415\\Id9547028.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"74374598","DOCUMENT_DATE":"1/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"LEAU0516                      ","TOTAL_INVOICE_AMOUNT":"1669.45","DOCUMENT_FILENAME":"20160415\\Id9543794.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"74374599","DOCUMENT_DATE":"1/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"LEPEN0516                     ","TOTAL_INVOICE_AMOUNT":"1642.93","DOCUMENT_FILENAME":"20160418\\Id9551424.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"74374600","DOCUMENT_DATE":"1/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"LERH0516                      ","TOTAL_INVOICE_AMOUNT":"921.21","DOCUMENT_FILENAME":"20160415\\Id9543724.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"74374601","DOCUMENT_DATE":"1/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"LESS0516                      ","TOTAL_INVOICE_AMOUNT":"365.91","DOCUMENT_FILENAME":"20160415\\Id9542406.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"74374602","DOCUMENT_DATE":"1/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"53403                         ","TOTAL_INVOICE_AMOUNT":"291.73","DOCUMENT_FILENAME":"20160415\\Id9544330.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"74374603","DOCUMENT_DATE":"1/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"53408                         ","TOTAL_INVOICE_AMOUNT":"138.72","DOCUMENT_FILENAME":"20160415\\Id9546790.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"74374604","DOCUMENT_DATE":"1/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"53409                         ","TOTAL_INVOICE_AMOUNT":"721.97","DOCUMENT_FILENAME":"20160418\\Id9551414.pdf"},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"20980902","DOCUMENT_DATE":"1/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"91445                         ","TOTAL_INVOICE_AMOUNT":"0.00","DOCUMENT_FILENAME":""},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"20980903","DOCUMENT_DATE":"1/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"92330                         ","TOTAL_INVOICE_AMOUNT":"0.00","DOCUMENT_FILENAME":""},{"ACCOUNT_NUMBER":"107116    ","BILLING_NUMBER":"107116    ","DOCUMENT_NUMBER":"20980904","DOCUMENT_DATE":"1/05/2016 12:00:00 AM","PERIOD_YYYYMM":"201605","CUSTOMER_REFERENCE":"92427                         ","TOTAL_INVOICE_AMOUNT":"0.00","DOCUMENT_FILENAME":""}]}';
                                      
                                  }
    
    public string getRequestBody(string cusAcc, string searchTerm, string startDate, string endDate,
                                 string startIndex, string endIndex, string sortBy, string sortOrder){
        
                                     string requestBody = '?userId='+UserInfo.getUserId()
                                         + '&custAcc=' + cusAcc;
                                     
                                     if(searchTerm != null && searchTerm != '')
                                         requestBody += '&SearchTerm=' + SearchTerm;
                                     
                                     if(startDate != null && startDate != ''){
                                         string s = startDate.substring(6,10)+'-'+startDate.substring(3,5)+'-'+startDate.substring(0,2);
                                         requestBody += '&StartDate=' + s;
                                     }
                                     
                                     if(endDate != null && endDate != ''){
                                         string e = endDate.substring(6,10)+'-'+endDate.substring(3,5)+'-'+ endDate.substring(0,2);
                                         requestBody += '&EndDate=' + e;
                                     }
                                     
                                     if(startIndex != null && startIndex != '')
                                         requestBody += '&startIndex=' + startIndex;
                                     
                                     if(endIndex != null && endIndex != '')
                                         requestBody += '&endIndex=' + endIndex;
                                     
                                     if(sortBy != null && sortBy != '')
                                         requestBody += '&sortBy=' + sortBy;
                                     
                                     if(sortOrder != null && sortOrder != '')
                                         requestBody += '&sortOrder=' + sortOrder;
                                     
                                     requestBody = stringEncrypter(requestBody);
                                     
                                     return requestBody;
                                     
                                 }
    
}