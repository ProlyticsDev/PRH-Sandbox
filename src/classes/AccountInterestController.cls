public with sharing class AccountInterestController {

    public String selectedValues {get; set;}
    public String selectedAccount {get; set;}
    public String selectedAccountName {get; set;}
	public List <Account_Interest__c> aiList {get; set;}
	public List <Account_Interest__c> todelete = new List<Account_Interest__c>();
	public Account_Interest__c ai = new Account_Interest__c();
	
	private final ApexPages.StandardController controller;
	public AccountInterestController(ApexPages.StandardController stdController){
		controller = stdController;
		ai = (Account_Interest__c)controller.getRecord();
		if(Apexpages.currentPage().getParameters().get('accId') !='' ){ 
			ai.Account__c = Apexpages.currentPage().getParameters().get('accId');
			selectedAccount = Apexpages.currentPage().getParameters().get('accId');
			if(selectedAccount !=null)
				selectedAccountName =[select Name from Account where Id = :selectedAccount Limit 1].Name;
		}
		if(Apexpages.currentPage().getParameters().get('msg')!=null){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Account Interest changes successfully made.');
            ApexPages.addMessage(myMsg);
		}
	} 
	
	public String getObjType() 
	{
		return String.valueOf(Account.sObjectType);
	}
	
	public OnixUtil.OnixNodeWrapper getRootNodeOfTree(Id onixId) 
	{
		return OnixUtil.getRootNodeOfUserTree(onixId);
	}

    public String getJsonString() 
    {
        String str = null;
        return str; 
    }
    
    public PageReference cancel() {
    	if(selectedAccountName !=null){
        	String newPageUrl = '/'+ Apexpages.currentPage().getParameters().get('accId');
  			PageReference newPage = new PageReference(newPageUrl);
  			newPage.setRedirect(true);
  			return newPage;
    	}
    	return null;
    }
 	
 	public PageReference save(){
 		saveData();
 		if(selectedAccountName !=null){
			PageReference newPage = new PageReference('/apex/AccountInterest?accId='+selectedAccount+'&msg=succ');
			return newPage.setRedirect(true);
 		}
		return null;
 	}
 	public PageReference saveReturn(){
 		saveData();
 		if(selectedAccountName !=null){
			PageReference newPage = new PageReference('/'+selectedAccount);
			return newPage.setRedirect(true);
 		}
		return null;
 	}
 	public void saveData(){
 		List <Account_Interest__c> newIs = new List<Account_Interest__c>();
 		List <ONIX_Subject__c> onixs = new List<ONIX_Subject__c>();
 		List <String> Ids = new List <String>();
 		List <String> tempIds = new List <String>();
 		Map <Id, String> IdMap = new Map <Id, String>();
 		Map <Id, Id> checkPrev = new Map<Id, String>();
 		for(Account_Interest__c ai: aiList){
 			checkPrev.put(ai.Interest_Category__c, ai.Interest_Category__c);
 		}
 		//system.debug('@@@ '+selectedValues);
 		//Selected values comes in the format Id:Choice,Id:Choice....
 		if(selectedValues!=null && selectedValues!=''){
 			tempIds = selectedValues.split(',',0);
 			if(tempIds.size() > 0){
	 			for(String a: tempIds){
	 				if(a.contains(':')){
 						IdMap.put(a.split(':',0)[0], a.split(':',0)[1]);
	 					Ids.add(a.split(':',0)[0]);
	 				}
 				}
 			}
 			onixs=[select Id from ONIX_Subject__c where Id IN :Ids];
 		}
 			
 		for(ONIX_Subject__c onix:onixs){
 			if(!checkPrev.containsKey(onix.Id)){
 				Account_Interest__c newI = new Account_Interest__c();
 				newI.Account__c=selectedAccount;
 				newI.Interest_Category__c = onix.Id;
 				//system.debug('@@@ map '+IdMap.get(onix.Id));
 				if(IdMap.get(onix.Id)!=null) //&& IdMap.get(onix.Id) != 'Blank')
 					newI.Interested_or_Avoid__c=IdMap.get(onix.Id);
				//else
					//newI.Interested_or_Avoid__c='';
 				newIs.add(newI);
 			}
 		}
 		//cleanup
 		tempIds = null;
 		onixs=null;
 		checkPrev=null;
 		
 		if(selectedAccountName !=null){
 			insert(newIs);
 			if (todelete!=null && todelete.size() > 0 ) {           
				delete todelete;   
				todelete = new List<Account_Interest__c>();
			}
 		}
 	}
 	
 	public PageReference del() {

		string delname = ApexPages.CurrentPage().getParameters().get('delname');
		system.assert( delname != null );
		integer gone = -1;
		integer i = 0;
		for ( i=0; i< aiList.size(); i++ ) {
			if (aiList[i].Id== delname) {
				gone = i;
			}
		}
		if ( gone >= 0) {
			todelete.add(aiList.remove(gone));
		}
		return null;
	}
 	
 	public void getSelectedAccount(){
 		//system.debug('@@@ '+ ApexPages.currentPage().getParameters().get('accountId'));
 		//selectedAccount = ApexPages.currentPage().getParameters().get('accountId');
 		aiList = null;
 		
 	}
 	public List<Account_Interest__c> getInterests(){
 		if(aiList == NULL)
 			aiList = [select Id, Interest_Category__c, Interest_Category__r.Code__c , Interested_or_Avoid__c From Account_Interest__c Where Account__c = :selectedAccount order by LastModifiedDate Desc];
 		return aiList;	
 	}
 	
}