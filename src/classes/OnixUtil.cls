public with sharing class OnixUtil {
    /********************* Properties used by getRootNodeOfOnixTree function - starts **********************/
    // map to hold onix subject with Id as the key
    private static Map <Id, ONIX_Subject__c> onixSubjectMap;

    // map to hold child onix with Parent_ONIX_Subject__c as the key
    private static Map <Id, List<ONIX_Subject__c>> parentChildOnixMap;

    // Global JSON generator
    private static JSONGenerator gen {get; set;}

    /********************* Properties used by getRootNodeOfOnixTree function - ends **********************/
    
    
    /********************* Properties used by getSObjectTypeById function - starts ********************* */
    // map to hold global describe data
    private static Map<String,Schema.SObjectType> gd;
    
    // map to store objects and their prefixes
    private static Map<String, String> keyPrefixMap;

    // to hold set of all sObject prefixes
    private static Set<String> keyPrefixSet;
    /********************* Properties used by getSObjectTypeById function - ends **********************/
    
    public String searcRes {get; set;}
    
    /* // initialize helper data */ 
    static {
        // initialize helper data for getSObjectTypeById function
        init1();
        
        // initialize helper data for getRootNodeOfOnixTree function
        //init2(null);
    }
    
    /* // init1 starts <to initialise helper data> */
    private static void init1() {
        // get all objects from the org
        gd = Schema.getGlobalDescribe();
        
        // to store objects and their prefixes
        keyPrefixMap = new Map<String, String>{};
        
        //get the object prefix in IDs
        keyPrefixSet = gd.keySet();
        
        // fill up the prefixes map
        for(String sObj : keyPrefixSet) {
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
            String tempName = r.getName();
            String tempPrefix = r.getKeyPrefix();
            keyPrefixMap.put(tempPrefix, tempName);
        }
    }
    /* // init1 ends */

    /* // init2 starts <to initialise helper data> */
    private static void init2(String onixName, String id) {
        
        if (onixName != null && onixName.trim().length() > 0 && onixName !='poiuytrewq' && onixName !='qwertyuiop'){
            // Protect from SOQL injection            
            String onixNameToFilter = '%' + onixName  + '%';
            // Get onix mapping in a map with key as onix subject id
            onixSubjectMap = new Map<Id, ONIX_Subject__c>([select Id, Name, Parent_ONIX_Subject__c, Code__c, Short_Description__c from ONIX_Subject__c where IsActive__c= TRUE AND Name like :onixNameToFilter order by Parent_ONIX_Subject__c, Name]);
        //}else if (onixName != null && onixName.trim().length() > 0 && onixName =='qwertyuiop'){
        //	onixSubjectMap = new Map<Id, ONIX_Subject__c>([select Id, Name, Parent_ONIX_Subject__c, Code__c, Short_Description__c from ONIX_Subject__c where IsActive__c= TRUE AND (Id = :Id OR Parent_ONIX_Subject__c =:Id) order by Name]);
        }else{
            // Get onix mapping in a map with key as onix subject id
            onixSubjectMap = new Map<Id, ONIX_Subject__c>([select Id, Name, Parent_ONIX_Subject__c, Code__c, Short_Description__c from ONIX_Subject__c where IsActive__c= TRUE order by Parent_ONIX_Subject__c, Name]);         
        }
        
        // populate parent onix - child onix map
        parentChildOnixMap = new Map <Id, List<ONIX_Subject__c>>();         
        for (ONIX_Subject__c r : onixSubjectMap.values()) {
            List<ONIX_Subject__c> tempList;
            if (!parentChildOnixMap.containsKey(r.Parent_ONIX_Subject__c) && onixSubjectMap.containsKey(r.Parent_ONIX_Subject__c)){
                tempList = new List<ONIX_Subject__c>();
                tempList.Add(r);
                parentChildOnixMap.put(r.Parent_ONIX_Subject__c, tempList);
            }
            else if(onixSubjectMap.containsKey(r.Parent_ONIX_Subject__c)) {
                tempList = (List<ONIX_Subject__c>)parentChildOnixMap.get(r.Parent_ONIX_Subject__c);
                tempList.add(r);
                parentChildOnixMap.put(r.Parent_ONIX_Subject__c, tempList);
            }
        }
    } 
    /* // init2 ends */

    /* // public method to get the starting node of the onixTree along with user list */
    public static OnixNodeWrapper getRootNodeOfUserTree (Id onixId) {
        return createNode(onixId);
    }
    
    /* // createNode starts */
    private static OnixNodeWrapper createNode(Id objId) {
        OnixNodeWrapper n = new OnixNodeWrapper();
        Id onixId;
        if (isOnix(objId)) {
            onixId = objId;
        }
        n.myOnixId = onixId;
        if(onixSubjectMap.get(onixId)!=null){
            n.myOnixName = onixSubjectMap.get(onixId).Name;
            n.myOnixDescription = onixSubjectMap.get(onixId).Short_Description__c;
            n.myOnixCode = onixSubjectMap.get(onixId).Code__c;
            n.myParentOnixId = onixSubjectMap.get(onixId).Parent_ONIX_Subject__c;
        }

        if (parentChildOnixMap.containsKey(onixId)){
            n.hasChildren = true;
            n.isLeafNode = false;
            List<OnixNodeWrapper> lst = new List<OnixNodeWrapper>();
            /*for (ONIX_Subject__c r : parentChildOnixMap.get(onixId)) {
                    lst.add(createNode(r.Id));
            }*/           
            n.myChildNodes = lst;
        }
        else {
            n.isLeafNode = true;
            n.hasChildren = false;
        }
        return n;
    }
    
    public static String getTreeJSONWrap() {
        gen = JSON.createGenerator(true);
        String allJ='[ {"title" : "ONIX Subjects","key" : "","tooltip" : "", "unselectable" : true,"hideCheckbox": true,"expand" : true,"isFolder" : true, "children" :';
        List <ONIX_Subject__c> oss =[select Id from ONIX_Subject__c where IsActive__c= TRUE AND Parent_ONIX_Subject__c=NULL Order By Name ASC];
        gen.writeStartArray();
        for(ONIX_Subject__c os: oss){
            getTreeJSON(os.Id);
        }
        gen.writeEndArray();
        allJ=allJ+gen.getAsString();
        allJ=allJ+'} ]';
        return allJ;
    }
    
    public static void getTreeJSON(Id onixId) {
        OnixNodeWrapper node = createNode(onixId);
        convertNodeToJSON(node);
    }
    
    private static void convertNodeToJSON(OnixNodeWrapper objRNW){
        if(objRNW !=null){
        gen.writeStartObject();
            gen.writeStringField('title', objRNW.myOnixDescription+'~'+objRNW.myOnixCode);
            gen.writeStringField('key', objRNW.myOnixId);
            //gen.writeStringField('tooltip', objRNW.myOnixName);
            gen.writeBooleanField('unselectable', false);
            gen.writeBooleanField('expand', false);
            gen.writeBooleanField('isFolder', true);           
            
            if (/*objRNW.hasUsers ||*/ objRNW.hasChildren)
            {
                gen.writeBooleanField('isLazy', true);
                gen.writeFieldName('children');
                gen.writeStartArray();
                    /*if (objRNW.hasUsers)
                    {
                        for (User u : objRNW.myUsers)
                        {
                            gen.writeStartObject();
                                gen.writeStringField('title', u.Name);
                                gen.writeStringField('key', u.Id);
                            gen.WriteEndObject();
                        }
                    }*/
                    if (objRNW.hasChildren)
                    {
                        for (OnixNodeWrapper r : objRNW.myChildNodes)
                        {
                            convertNodeToJSON(r);
                        }
                    }
                gen.writeEndArray();
            }else{
                gen.writeBooleanField('isFolder', false);
            }
        gen.writeEndObject();
        }
    }
    
    /* // general utility function to get the SObjectType of the Id passed as the argument, to be used in conjunction with */ 
    public static String getSObjectTypeById(Id objectId) {
        String tPrefix = objectId;
        tPrefix = tPrefix.subString(0,3);
        
        //get the object type now
        String objectType = keyPrefixMap.get(tPrefix);
        return objectType;
    }
    /* // utility function getSObjectTypeById ends */
    
    /* // check the object type of objId using the utility function getSObjectTypeById and return 'true' if it's of ONIX_Subject__c type */
    public static Boolean isOnix (Id objId) {
        if (getSObjectTypeById(objId) == String.valueOf(ONIX_Subject__c.sObjectType)) {
            return true;
        }
        return false;
    }
    /* // isOnix ends */
    
    public class OnixNodeWrapper {
    
        // Onix info properties - begin
        public String myOnixName {get; set;}
        public String myOnixDescription {get; set;}
        public String myOnixCode {get; set;}
        public Id myOnixId {get; set;}
        public String myParentOnixId {get; set;}
        // Onix info properties - end
        
        
        // Node children identifier properties - begin
        public Boolean hasChildren {get; set;}
        public Boolean isLeafNode {get; set;}
        // Node children identifier properties - end
        
        
        // Node children properties - begin
        public List<OnixNodeWrapper> myChildNodes {get; set;}
        // Node children properties - end   
        
        public OnixNodeWrapper(){
            hasChildren = false;
        }
    }
    public void doSearch() {
        Map<string,string> params = ApexPages.currentPage().getParameters();
        gen = JSON.createGenerator(true);
        if(params.get('id') == null || params.get('id') == ''){
        	searcRes='[ {"title" : "ONIX Subjects","key" : "","tooltip" : "", "unselectable" : true,"hideCheckbox": true,"expand" : true,"isFolder" : true, "children" :';
        	List <ONIX_Subject__c> oss = getRecords(params.get('q'),'');
        	init2(params.get('q'),'');
        	gen.writeStartArray();
        	for(ONIX_Subject__c os: oss){
	            if(!parentChildOnixMap.containsKey(onixSubjectMap.get(os.Id).Parent_ONIX_Subject__c))
                	getTreeJSON(os.Id);
        	}
        	gen.writeEndArray();
        	searcRes=searcRes+gen.getAsString();
        	searcRes=searcRes+'} ]';
        }else{
        	searcRes='';
        	List <ONIX_Subject__c> oss = getRecords(params.get('q'),params.get('id'));
        	init2(params.get('q'),params.get('id'));
        	gen.writeStartArray();
        	for(ONIX_Subject__c os: oss){
                	getTreeJSON(os.Id);
        	}
        	gen.writeEndArray();
        	searcRes=searcRes+gen.getAsString();
        }
    }
    
    // Does the SOQL query, using Ajax request data
    public List<ONIX_Subject__c> getRecords(String onixName, String id) {
        List<ONIX_Subject__c> records = new List<ONIX_Subject__c>();
        if (onixName != null && onixName.trim().length() > 0 && onixName !='poiuytrewq' && onixName !='qwertyuiop'){
            // Protect from SOQL injection            
            String onixNameToFilter = '%' + onixName  + '%';
            records = [select Id from ONIX_Subject__c where IsActive__c= TRUE AND Name Like :onixNameToFilter Order By Name ASC];
        }else if (onixName != null && onixName.trim().length() > 0 && onixName =='qwertyuiop'){
        	records = [select Id from ONIX_Subject__c where IsActive__c= TRUE AND Parent_ONIX_Subject__c=:id Order By Name ASC];
        }else if (onixName != null && onixName.trim().length() > 0){
            records = [select Id from ONIX_Subject__c where IsActive__c= TRUE Order By Name ASC];
        }   
        return records;      
    }
    
    @isTest(SeeAllData=true) 
    static void testOnixUtil() {
        
        
        OnixUtil ou = new OnixUtil();
        ApexPages.currentPage().getParameters().put('q','poiuytrewq');
        ou.doSearch();
        
        Account acc=new Account (Name = 'Test Account');
        insert acc; 
        ONIX_Subject__c onix1 = new ONIX_Subject__c(Name = 'Test Subject1', Code__c='1PAS1', Short_Description__c='Test Short1', IsActive__c= TRUE);
        insert onix1;
        ApexPages.currentPage().getParameters().put('q','qwertyuiop');
        ApexPages.currentPage().getParameters().put('id',onix1.Id);
        ou.doSearch();
        ONIX_Subject__c onix = new ONIX_Subject__c(Name = 'Test Subject', Code__c='1PAS2', Short_Description__c='Test Short', IsActive__c= TRUE);
        insert onix;
        Account_Interest__c ai = new Account_Interest__c(Account__c = acc.Id, Interest_Category__c = onix1.Id, Interested_or_Avoid__c='Interested');
        ApexPages.standardController controller = new ApexPages.standardController(ai);
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        AccountInterestController aic = new AccountInterestController(controller);
        aic.selectedValues = onix.id+':'+'Interested';
        aic.getInterests();
        aic.save();
        ApexPages.CurrentPage().getParameters().put('delname', onix1.id);
        aic.del();
        aic.getSelectedAccount();
        aic.cancel();
        /*
        // test the output in system debug with role Id
        Id onixId = '00E90000000pMaP';
        RoleNodeWrapper startNodeWithRoleId = RoleUtil.getRootNodeOfUserTree(roleId);
        String strJsonWithRoleId = JSON.serialize(startNodeWithRoleId);
        system.debug(strJsonWithRoleId);
        */
        //system.debug('****************************************************');

        // now test the output in system debug with userId
        //Id userId = UserInfo.getUserId() ;
        /*
        RoleNodeWrapper startNodeWithUserId = RoleUtil.getRootNodeOfUserTree(userId);
        String strJsonWithUserId = JSON.serialize(startNodeWithUserId);
        system.debug(strJsonWithUserId);
        */
        
        // test whether all subordinates get added
        //Id userId = '005900000011xZv';
        //String str = RoleUtil.getTreeJSON(userId);
        //List<User> tmpUsrList = RoleUtil.getAllSubordinates('00E90000000pMaP');
        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%tmpUsrList:' + tmpUsrList);
   }
}