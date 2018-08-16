public class TreeComponentsItems {
	@AuraEnabled  
	public string label { get; set; }  
	     
	@AuraEnabled  
	public string name { get; set; }
	
	@AuraEnabled  
	public string href { get; set; }  	 
	     
	@AuraEnabled  
	public Boolean expanded { get; set; }  
	     
	@AuraEnabled  
	public List<TreeComponentsItems> items { get; set; }  
	     
	public TreeComponentsItems( String name, String label, Boolean expanded, list<TreeComponentsItems> items) {  
		this.label = label;  
		this.name = name;  
		this.expanded = expanded;  
		this.items = items;   
	}  
}