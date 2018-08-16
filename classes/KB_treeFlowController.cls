public with sharing class KB_treeFlowController  {

	public String[] status = new String[]{};
	public List<KB_Article__kav> fatherList{get; set;}
	public Node nodeSelected {get; set;}
	public String title {get; set;}
	public String parentId {get; set;}

	public KB_treeFlowController(){
		fatherList=new  List<KB_Article__kav>();
		fatherList=[Select Id, Title, KnowledgeArticleId, KB_ExternalID__c, UrlName from KB_Article__kav where KB_EsUnFlujo__c=true and KB_ArticuloPadre__c =null and PublishStatus ='Online' order by Title];
		
	}


	@RemoteAction
	public static Node getArts(){
		System.debug('Debug| getArts');
		Node nodeSelected= null;
		List<KB_Article__kav> fatherList=new  List<KB_Article__kav>();
		fatherList=[Select Id, Title, KnowledgeArticleId, KB_ExternalID__c, UrlName, KB_ArticuloPadre__c, PublishStatus  from KB_Article__kav where KB_EsUnFlujo__c=true and KB_ArticuloPadre__c =null and PublishStatus ='Online' order by Title];
		
		for (KB_Article__kav art :fatherList){
			if(art.Title.equalsIgnoreCase('No navega - Inicio - v1.2')){
				nodeSelected= new Node(art, 'tab0');
					
			}
		}

		fatherList=[Select Id, Title, KnowledgeArticleId, KB_ExternalID__c, UrlName, KB_ArticuloPadre__c, PublishStatus  from KB_Article__kav where KB_EsUnFlujo__c=true and KB_ArticuloPadre__c =null and PublishStatus ='Draft' order by Title];
		
		for (KB_Article__kav art :fatherList){
			if(art.Title.equalsIgnoreCase('No navega - Inicio - v1.2')){
				nodeSelected= new Node(art, 'tab0');
					
			}
		}
		getchild(0,nodeSelected,nodeSelected);
		return nodeSelected;
	}

	public static void getchild(Integer tab, Node father, Node nodeSelected){
		tab=tab+1;
		for(KB_Article__kav art : [Select Id, Title, KnowledgeArticleId,  KB_ExternalID__c, KB_ArticuloPadre__c, UrlName, PublishStatus  from KB_Article__kav where KB_EsUnFlujo__c=true and KB_ArticuloPadre__c =:father.article.KB_ExternalID__c and PublishStatus ='Online' order by Title]){
			Node child = new Node(art, 'tab'+tab);
			nodeSelected.nodes.add(child);
			getchild(tab, child, nodeSelected);
		}

		for(KB_Article__kav art : [Select Id, Title, KnowledgeArticleId,  KB_ExternalID__c, KB_ArticuloPadre__c, UrlName, PublishStatus  from KB_Article__kav where KB_EsUnFlujo__c=true and KB_ArticuloPadre__c =:father.article.KB_ExternalID__c and PublishStatus ='Draft' order by Title]){
			Node child = new Node(art, 'tab'+tab);
			nodeSelected.nodes.add(child);
			getchild(tab, child, nodeSelected);
		}
	}

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Online','On Line'));
        options.add(new SelectOption('Draft','Draft'));
        options.add(new SelectOption('Archived','Archived'));

        return options;
    }

    public String[] getstatus() {
        return status;
    }
 
    public void setstatus(String[] status) {
        this.status = status;
    }
    

	public void insertKnowledge(){
    	System.debug('insertKnowledge');
    	
    	try{
//	    	String title = apexpages.currentpage().getparameters().get('KBtitle');
//	    	String parentId = apexpages.currentpage().getparameters().get('KBparentId');
//	    	System.debug('Debug| parameters: '+apexpages.currentpage().getparameters());
	    	System.debug('Debug| parameters: title: ' +title+' parentId: '+parentId);
	    	KB_Article__kav draft = new KB_Article__kav();
	    	draft.Title= title;
			draft.UrlName= createUrlName(title);
	    	draft.KB_EsUnFlujo__c=true;
	    	draft.KB_ArticuloPadre__c=parentId;
	    	System.debug('Debug| Draft: ' +draft);
	    	insert draft;
	    }catch(Exception e){
	    	System.debug('Debug| ERROR: ' +e);
	    }
    }

    private String createUrlName(String title){
    	String urlName= title.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|| |\\(|\\)|\\{|\\}|\\;|\\\'"]', '-');
    	urlName= urlName.removeStart('-');
		urlName= urlName.removeEnd('-');
    	return urlName;
    }

	public class Node {
    
        public KB_Article__kav article {get; set;}
        public List <Node> nodes {get; set;}
        public String tabulation {get;set;}

        public Node(){
            nodes = new List<node>();
        }
        public Node(KB_Article__kav kb, String tab){
            article = kb;
            tabulation = tab;
            nodes = new List<node>();
            
            
        }
        
    }
    
}