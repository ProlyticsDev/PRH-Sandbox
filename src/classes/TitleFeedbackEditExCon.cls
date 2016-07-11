public with sharing class TitleFeedbackEditExCon {

    private ApexPages.StandardController stdCon;
    
    
    private Title_Feedback__c currentTitleFeedback {
        get{
            return (Title_Feedback__c) stdCon.getRecord();
        }
    }
    

    public TitleFeedbackEditExCon(ApexPages.StandardController controller) {
        this.stdCon = controller;
    }
    
    public static String TITLE_PICKLIST_OTHER_VALUE { get{return 'Other';}}
    
    public List<SelectOption> titlePicklistValues{
        get{
            if(titlePicklistValues==null){
                List<Product2> activeTitles = getTitlesInActiveTitleSet();
                if(activeTitles == null || activeTitles.isEmpty()) return null;
                titlePicklistValues = new List<SelectOption>();
                for(Product2 title: activeTitles){
                    titlePicklistValues.add(new SelectOption(title.id, title.Name));
                }
                titlePicklistValues.add(new SelectOption(TITLE_PICKLIST_OTHER_VALUE, 'Other (Please Specify)'));
            }return titlePicklistValues;
        }private set;
    }
    public String titlePicklistSelectedValue{
        get{
            if(titlePicklistSelectedValue == null && titlePicklistValues != null && !titlePicklistValues.isEmpty()){
                titlePicklistSelectedValue = titlePicklistValues[0].getValue();
            }return titlePicklistSelectedValue;
        }
        set{
            if(value != null && value.startsWith(Product2.sObjectType.getDescribe().getKeyPrefix())){
                currentTitleFeedback.Title__c = (Id) value;
                currentTitleFeedback.Is_Outstanding_Title__c = false;
            }else if(value != titlePicklistSelectedValue){
                currentTitleFeedback.Title__c = null;
                currentTitleFeedback.Is_Outstanding_Title__c = true;
            }
            titlePicklistSelectedValue = value;
        }
    }
    
    private List<Product2> getTitlesInActiveTitleSet(){
        List<Title_Set_Item__c> activeTitleSetItems = [Select Title_Product__r.Id, Title_Product__r.Name from Title_Set_Item__c where Title_Set__r.Is_Active__c = true];
        List<Product2> activeTitles = new List<Product2>();
        for(Title_Set_Item__c tsi: activeTitleSetItems){
            activeTitles.add(tsi.Title_Product__r);
        }
        return activeTitles;    
    }
    
    public PageReference saveAndNew(){
        PageReference pageRef = stdCon.save();
        if(pageRef == null) return null;
        pageRef = ApexPages.CurrentPage();
        Map<String, String> params = pageRef.getParameters();
        if(params.containsKey('id')){
            params.remove('id');
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void noOp(){}
    
    public static testmethod void testTitleFeedbackEditExCon(){
        Product2 title1 = new Product2(Name = 'TBC', Title__c = 'Test Title', ISBN__c = 'Test ISBN');
        insert title1;
        Title_Set__c titleSet = new Title_Set__c(Name = 'Test Title Set', Is_Active__c = true);
        insert titleSet;
        Title_Set_Item__c titleSetItem = new Title_Set_Item__c(Title_Product__c = title1.id, Title_Set__c = titleSet.id);
        insert titleSetItem;
        PageReference pageRef = new PageReference('/apex/TitleFeedbackEdit');
        pageRef.getParameters().put('retURL','/home/home.jsp');
        pageRef.getParameters().put('id','test');
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(new Title_Feedback__c());
        TitleFeedbackEditExCon excon = new TitleFeedbackEditExCon(stdCon);
        String temp = excon.titlePicklistSelectedValue;
        excon.titlePicklistSelectedValue = 'Other';
        System.assertEquals(2, excon.titlePicklistValues.size());
        System.assertEquals(null, excon.saveAndNew().getParameters().get('id'));
    }
}