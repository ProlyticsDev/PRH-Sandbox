public class InvoiceURLEncryptionController {
    
    private final Invoice__c i;
    private final Document_Setting__mdt settings;
    
    private final string vector;
    
    public string cid {get;set;}
    
    public List<Contact> contactList {get;set;}
    public Set<string> contactIdSet {get;set;}
    
    public InvoiceURLEncryptionController(ApexPages.standardController con){

        if(!test.isRunningTest()){
            List<String> fieldNames = new List<String>{'Document_Id__c', 'Timestamp__c', 'Billing_Number__c' ,'Customer_Account__c', 'Account__c'};
                con.AddFields(fieldNames);
        }
        
        this.i = (Invoice__c) con.getRecord();
        
        settings = [SELECT Id, DeveloperName, Encryption_Key__c 
                    FROM Document_Setting__mdt 
                    WHERE DeveloperName = 'Default'
                    LIMIT 1];
        
    }
    
    public PageReference HashRedirect(){
        
        integer ts = system.now().millisecond();
        
        // original param string
        string params = 'ts=' + i.Timestamp__c 
            + '&docId=' + i.Document_ID__c ;
            //+ '&userId=' + UserInfo.getUserId() 
            //+ '&cusAcc=' + i.Customer_Account__c 
            //+ '&billAcc=' + i.Billing_Number__c;
        
        //build string for encryption
        string hashString = params;//settings.Encryption_Key__c
            //+ i.Customer_Account__c
            //+ params;
        
        //system.debug('hashString: ' + hashString);
        
        // set the encryption parameters
        string algo = 'AES256';
        blob key = blob.valueOf(settings.Encryption_Key__c);
        blob iv = blob.valueOf('1234567890123456');
        Blob clearText = Blob.valueOf(hashString);
        
        // encrypt
        Blob encrypted = Crypto.encrypt(algo, key, iv, blob.valueOf(hashString));
        system.debug('Encrypted String :' + encodingUtil.base64Encode(encrypted)); 
        
        Blob decrypted = Crypto.decrypt(algo, key, iv, encrypted);
        //system.debug('Custom IV Decrypted: ' + decrypted.toString());

        // encrypt with managed iv
        Blob encrypted2 = Crypto.encryptWithManagedIV(algo, key, clearText);
        //system.debug('Managed IV : ' + encodingUtil.base64Encode(encrypted2)); 
        
        Blob decrypted2 = Crypto.decryptWithManagedIV(algo, key, encrypted2);
        //system.debug('Managed IV Decrypted: ' + decrypted2.toString());
        
        // base 64 encoded encrypted string to end of original param string
        //params = params + '&h=' + encodingUtil.base64Encode(encrypted);
        
        //system.debug(params);
        
        // set the main server endpoint
        string endpoint = 'https://portal.penguinrandomhouse.com.au/invoices/downloadPDF?p='+encodingUtil.base64Encode(encrypted);
        system.debug('Endpoint: ' + endpoint);
        
        return (new PageReference(endpoint));
        
    }
    
    
}