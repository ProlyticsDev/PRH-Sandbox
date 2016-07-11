public class TreeViewController {
	
	public Boolean selectable {get; set;}
	
	public String selectNodeKeys {get; set;}

	{
		selectable = false;
		selectNodeKeys = 'No value selected';
	}
	
	public String JsonData {get; set;}
	
	//public String onixId {get; set;}
	
    public String getJsonString() 
    {
        //if (JsonData == null){
		//	JsonData = OnixUtil.getTreeJSONWrap();
        //}
        return JsonData;
    }

}