public without sharing class KB_KnowledgeViewController {

	public KB_Article__kav articleSelected{get;set;}

	public KB_KnowledgeViewController() {

	}

	public PageReference search(){
		System.debug('search');
	   	string KBid=apexpages.currentpage().getparameters().get('id');
    	System.debug('kbid: ' +KBid);
    	articleSelected=[Select id, KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s from KB_Article__kav WHERE PublishStatus='online' and KnowledgeArticleId =:KBid limit 1 UPDATE VIEWSTAT];
        return null;

    }
}