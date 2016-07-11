public class AdjustmentNoteURLEncryptionController {
    
    private final Adjustment_Note__c aj;
    private final Document_Setting__mdt settings;
    
    public string cid {get;set;}
    
    public List<Contact> contactList {get;set;}
    public Set<string> contactIdSet {get;set;}
    
    public AdjustmentNoteURLEncryptionController(ApexPages.standardController con){
        
        if(!test.isRunningTest()){
            List<String> fieldNames = new List<String>{'Document_Id__c', 'Timestamp__c', 'Billing_Number__c' ,'Customer_Account__c', 'Account__c'};
                con.AddFields(fieldNames);
        }
            
        this.aj = (Adjustment_Note__c) con.getRecord();
        
        settings = [SELECT Id, DeveloperName, Encryption_Key__c 
                    FROM Document_Setting__mdt 
                    WHERE DeveloperName = 'Default'
                    LIMIT 1];
        
        cid = ApexPages.CurrentPage().getParameters().get('cid');
        system.debug('********************** cid: '+ cid);
        
        List<Contact> contactList = [select Id from Contact where AccountId = :aj.Account__c];
        system.debug('********************** contactList: '+contactList);
        
        contactIdSet = new Set<string>();
        
        for(Contact c : contactList){
            contactIdSet.add(string.valueOf(c.Id).left(15));
        }
        
        system.debug('********************** contactIdSet: '+ contactIdSet);
        
    }
    
    public PageReference HashRedirect(){
        
        if(!contactIdSet.contains(cid)){
            return Page.FileNotFound;
            
        } else {
            
            // original param string
            string params = 'ts=' + aj.Timestamp__c + '&docId=' + aj.Document_ID__c + '&userId=' + UserInfo.getUserId() + '&cusAcc=' + aj.Customer_Account__c + '&billAcc=' + aj.Billing_Number__c;
            
            //build string for hashing
            string hashString = settings.Encryption_Key__c;
            hashString += aj.Customer_Account__c;
            hashString += params;
            
            system.debug('///////// hash string: ' + hashString);
            
            // create hash
            Blob targetBlob = Blob.valueOf(hashString);
            Blob hash = Crypto.generateDigest('MD5', targetBlob);
            
            system.debug(encodingUtil.converttohex(hash));
            
            //append hash to end of original param string
            params = params + '&h=' + encodingUtil.converttohex(hash);
            
            system.debug(params);
            
            string endpoint = 'https://portal.penguinrandomhouse.com.au/invoices/downloadPDF?'+params;
            
            return (new PageReference(endpoint));
            
        }
        
    }

}