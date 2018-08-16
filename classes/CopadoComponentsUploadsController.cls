public with sharing class CopadoComponentsUploadsController {
	public List<copado__User_Story__c> lstUsersAndUserStories {get; set;}
	public List<Attachment> lstAttachments {get; set;}
	private integer counter=0;
	private integer list_size=10;
	public integer total_size;

	public CopadoComponentsUploadsController() {
		total_size = [select count() from copado__User_Story__c];
	}

	public List<copado__User_Story__c> getStories(){
		lstUsersAndUserStories = [SELECT copado__Status__c,copado__User_Story_Title__c,Id,Name 
								  FROM copado__User_Story__c
								  ORDER BY Name ASC NULLS FIRST
								  LIMIT :list_size 
								  OFFSET :counter];
		
		return lstUsersAndUserStories;
	}
	public PageReference ObtainCopadoMetadataByUserStory(){
		String idUserStory;
		system.debug('userStoryId: ' + ApexPages.currentPage().getParameters().get('userStoryId'));
		if(ApexPages.currentPage().getParameters().get('userStoryId') != null){
			idUserStory = ApexPages.currentPage().getParameters().get('userStoryId');
			lstAttachments = [SELECT Body,BodyLength,ContentType,Description,Id,Name,OwnerId,ParentId 
							  FROM Attachment 
							  WHERE ParentId = : idUserStory];

			if (lstAttachments.size() <= 0) {                     
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'La US Seleccionada no posee metada.');
				ApexPages.addMessage(myMsg);
				return null;
			}else{
				decodeAttachments(lstAttachments);
			}     
		}
		return null;
	}

	void decodeAttachments(List<Attachment> lstAttachments){
		for(Attachment att : lstAttachments){
			decodeBodyAttachment(att.Body);
		}
	}

	void decodeBodyAttachment(Blob bodyBaseAttachment){
		String attachmentString = bodyBaseAttachment.toString();
		system.debug(attachmentString);
	}

	public PageReference Beginning() {
		counter = 0;
		return null;
	}

	public PageReference Previous() {
		counter -= list_size;
		return null;
	}

	public PageReference Next() {
		counter += list_size;
		return null;
	}

	public PageReference End() {
		counter = total_size - math.mod(total_size, list_size);
		return null;
	}

	public Boolean getDisablePrevious() {
		if (counter>0) return false; else return true;
	}

	public Boolean getDisableNext() {
		if (counter + list_size < total_size) return false; else return true;
	}

	public Integer getTotal_size() {
		return total_size;
	}

	public Integer getPageNumber() {
		return counter/list_size + 1;
	}	

	public Integer getTotalPages() {
		if (math.mod(total_size, list_size) > 0) {
			return total_size/list_size + 1;
		} else {
			return (total_size/list_size);
		}
	}
}