/***************************************************************
Trigger to set Order PriceList to Telecom Price List by Default
****************************************************************/
trigger OrderTrigger on Order (before insert) {
	List<vlocity_cmt__PriceList__c> TAPriceList = [select id from vlocity_cmt__PriceList__c where Name='Telecom Price List'];
	if(TAPriceList.size()>0){
		Id TAPriceListId = TAPriceList[0].id;
		for(Order ord:trigger.new){
			ord.vlocity_cmt__PriceListId__c = TAPriceListId;
		}
	}
	else{
		System.debug('There is no Telecom Price List in the org');
	}

}