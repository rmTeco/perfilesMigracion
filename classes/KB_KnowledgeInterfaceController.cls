public without sharing class KB_KnowledgeInterfaceController {
    public List<KB_Article__kav> listOfSuggest{get;set;}

    public String searchText{get;set;}
    public Integer noOfRecords{get; set;}
    public Integer size{get;set;}
    public Integer noOfPages{get;set;}

    //Banner html
    public String body1{get;set;}
    public String body2{get;set;}

    public Wrapper wrap{get;set;}
    public String categoryToFilter {get;set;}
    
    public ApexPages.StandardSetController standardSetCtrl {get;set;}
    public KB_Article__kav articleSelected{get;set;}
    public PageReference viewKnowledgeBody=null;

    public Map<String, Double> mapIdScoreDown {get;set;}
    public Map<String, Double> mapIdScoreUp {get;set;}   
    public Map<String, Integer> mapIdVote {get;set;}

    public Double doArticleScore=0;

    public String orderBy {get; set;}
    public String orderselected=null;

    public KB_KnowledgeInterfaceController() {
        noOfRecords=0;
        size=0;
        noOfPages=1;
        mapIdScoreDown= new Map<String, Double>();
        mapIdScoreUp= new Map<String, Double>();
        orderBy='Ordenar Por';
     }
     
    public PageReference search(){
        getDescribeDataCategoryGroupStructureResults();
        bannerHTML();
        searchInput();
        return null;
    }

    public void topFive(){
        listOfSuggest=new List<KB_Article__kav>();
        List<String> parentIDList= new List<String>();
        Map<String,KB_Article__kav> articleMapSalient= new Map<String,KB_Article__kav>();
        Map<String,KB_Article__kav> articleMap= new Map<String,KB_Article__kav>();
        for(KB_Article__ViewStat viewStat : [SELECT NormalizedScore,  ParentId FROM KB_Article__ViewStat where Channel='AllChannels' and IsDeleted=false order by NormalizedScore desc limit 4]){
            parentIDList.add(viewStat.parentId);            
        }        
        for(KB_Article__kav article :[Select KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s, KB_ArticuloNuevo__c, KB_ArticuloActualizado__c, KB_ArticuloDestacado__c  from KB_Article__kav WHERE PublishStatus='online' and KB_ArticuloDestacado__c=true and KnowledgeArticleId in :parentIDList]){
            articleMapSalient.put(article.KnowledgeArticleId, article);    
        }
        for(KB_Article__kav article :[Select KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s, KB_ArticuloNuevo__c, KB_ArticuloActualizado__c, KB_ArticuloDestacado__c  from KB_Article__kav WHERE PublishStatus='online' and KB_ArticuloDestacado__c=false and KnowledgeArticleId in :parentIDList]){
            articleMap.put(article.KnowledgeArticleId, article);    
        }
        for(String view : parentIDList){ 
            if(articleMapSalient.containsKey(view)){  
                listOfSuggest.add(articleMapSalient.get(view));
            }
        }
        for(String view : parentIDList){ 
            if(articleMap.containsKey(view)){  
                listOfSuggest.add(articleMap.get(view));
            }
        }
        System.debug('articleMap: ' +articleMap);
        System.debug('listOfSuggestTopFive: ' +listOfSuggest);
        
    }

    public void mostViewed(String orderselected){
        List<String> listIds= new List<String>();
        List<String> parentIDList= new List<String>();
        List<KB_Article__kav> listArt= listOfSuggest;
        Map<String,KB_Article__kav> articleMap= new Map<String,KB_Article__kav>();
        listIds=listArticleIds();
        if(orderselected.equalsIgnoreCase(Label.KB_Most_viewed)){
            
            for(KB_Article__ViewStat viewStat :[SELECT NormalizedScore,  ParentId FROM KB_Article__ViewStat where Channel='AllChannels' and IsDeleted=false and ParentId in :listIds order by NormalizedScore desc] ){
                parentIDList.add(viewStat.parentId);
            }    
        }else{

    //  for this salesforce issue https://success.salesforce.com/issues_view?id=a1p300000008XivAAE&title=sorting-knowledge-articles-by-best-rating-may-produce-incorrect-sort-order-when-there-are-one-or-more-articles-without-votes     
            for(KB_Article__VoteStat voteStat : [SELECT NormalizedScore, ParentId FROM KB_Article__VoteStat where Channel='AllChannels' and IsDeleted=false and NormalizedScore != 0 and ParentId in :listIds order by NormalizedScore desc]){
                parentIDList.add(voteStat.parentId);            
            }
            for(KB_Article__VoteStat voteStat : [SELECT NormalizedScore, ParentId FROM KB_Article__VoteStat where Channel='AllChannels' and IsDeleted=false and NormalizedScore = 0 and ParentId in :listIds order by NormalizedScore desc]){
                parentIDList.add(voteStat.parentId);            
            }

        }        
        for(KB_Article__kav article :listArt){
            articleMap.put(article.KnowledgeArticleId, article);    
        }
        listOfSuggest=new List<KB_Article__kav>();
        for(String view : parentIDList){   
            listOfSuggest.add(articleMap.get(view));
        }
        System.debug('articleMap: ' +articleMap);
        System.debug('listOfSuggestTopFive: ' +listOfSuggest); 
    }

    public List<String> listArticleIds(){
        List<String> listIds= new List<String>();
        for(KB_Article__kav article :listOfSuggest){
            listIds.add(article.KnowledgeArticleId);    
        }
        return listIds;
    }

    public Map<String, Decimal> generateMapArticleScore(List<KB_Article__kav> listkb, String vote){
        Map<String, Decimal> mapIdScore= new Map<String, Decimal>();
        for (KB_Article__kav art : listkb){
            try{
                List<AggregateResult> result = [SELECT count(type)vot, ParentId FROM Vote  where ParentId =:art.KnowledgeArticleId and IsDeleted=false and type=:vote group By ParentId ];   
                mapIdScore.put((String)result[0].get('ParentId'), (integer)result[0].get('vot'));
            }catch(Exception e){
                mapIdScore.put(art.KnowledgeArticleId,0);
            }               
        }
        return mapIdScore;     
    }

    public void generateMapArticleVotes(List<KB_Article__kav> listkb){
        System.debug('generateMapArticleVotes');
        mapIdVote= new Map<String, Integer>();
        for (KB_Article__kav art : listkb){
            try{
                List<AggregateResult> votes = [SELECT count(type)vot FROM Vote where ParentId =:art.KnowledgeArticleId and IsDeleted=false];   
                mapIdVote.put(art.KnowledgeArticleId,(integer)votes[0].get('vot'));
            }catch(Exception e){
                mapIdVote.put(art.KnowledgeArticleId,0);
            }
        }
        System.debug('mapIdVote: ' +mapIdVote);
    }
    
    public PageReference searchInput(){
        System.debug('searchInput');
        size=4;
        String uniqueName = apexpages.currentpage().getparameters().get('selected');
        String uniqueCategoryGroup = apexpages.currentpage().getparameters().get('selectedCategory');
        orderselected = (String.isNotEmpty(apexpages.currentpage().getparameters().get('orderBy')))?apexpages.currentpage().getparameters().get('orderBy'):orderselected;

        if(!String.isEmpty(uniqueName) && !String.isEmpty(uniqueCategoryGroup) ){
            wrap.searchNodeByUniqueName( uniqueName,  uniqueCategoryGroup, wrap.children);
            
        }
        listOfSuggest= new List<KB_Article__kav>();
        System.debug('categoryToFilter: ' +categoryToFilter);
        setObjectName();

        if(!String.isEmpty(searchText) && searchText.length()>=3){          
            listOfSuggest=search.query(quering(orderselected))[0];


            if (String.isNotEmpty(orderselected) &&(orderselected.equalsIgnoreCase(Label.KB_Most_viewed)||orderselected.equalsIgnoreCase(Label.KB_most_voted))){
                orderBy=orderselected;
                mostViewed(orderselected);
            }
        } else{
            topFive();
 
        }
            System.debug('listOfSuggest: ' +listOfSuggest);

            standardSetCtrl = new ApexPages.StandardSetController(listOfSuggest);
            standardSetCtrl.setPageSize(size);          
            noOfRecords = standardSetCtrl.getResultSize();

            noOfPages = countPages();
            System.debug('noOfPages int: ' +noOfPages);
            standardSetCtrl.first();
            listOfSuggest=standardSetCtrl.getRecords();
            
            generateMapArticleVotes(listOfSuggest); 

            mapIdScoreDown= generateMapArticleScore(listOfSuggest, 'Down');
            mapIdScoreUp= generateMapArticleScore(listOfSuggest, 'Up');   

        return null;    
    } 

    public String quering (String orderselected){
        String searchquery;
        searchquery='FIND \'*'+searchText+'*\' IN ALL FIELDS RETURNING KB_Article__kav (KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s, LastPublishedDate,  KB_ArticuloNuevo__c, KB_ArticuloActualizado__c, KB_ArticuloDestacado__c WHERE PublishStatus=\'online\'';
        if(String.isNotEmpty(orderselected)){
            if (orderselected.equalsIgnoreCase(Label.KB_Titulo_A_Z)){
                searchquery=searchquery+'order by Title asc';
            }else if (orderselected.equalsIgnoreCase(Label.KB_Titulo_Z_A)){
                searchquery=searchquery+'order by Title desc';
            }else if (orderselected.equalsIgnoreCase(Label.KB_Ultima_modificacion)){
                searchquery=searchquery+'order by LastModifiedDate desc';
            }
            orderBy=orderselected;
        }
        searchquery=searchquery+')';
        searchquery=(String.isEmpty(categoryToFilter))?searchquery:searchquery+' WITH DATA CATEGORY '+categoryToFilter;
        System.debug('searchquery: ' +searchquery);
        return searchquery;
    }

    public Integer countPages(){

        Decimal numberOfRecords=noOfRecords;
        Decimal numberOfrecordsByPage= size;
        Decimal totalPages=(numberOfRecords/numberOfrecordsByPage);

        System.debug('totalPages: ' +totalPages);
        Long pagesL=totalPages.round(System.RoundingMode.UP);
        System.debug('pagesL Long: ' +pagesL);
        return pagesL.intValue();
    }

    public List<DescribeDataCategoryGroupStructureResult> getDescribeDataCategoryGroupStructureResults(){
        wrap = new wrapper();
      List<DescribeDataCategoryGroupResult> describeCategoryResult;
      List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult;
      
      //Making the call to the describeDataCategoryGroups to
      //get the list of category groups associated
      List<String> objType = new List<String>();
      objType.add('KnowledgeArticleVersion');
      describeCategoryResult = Schema.describeDataCategoryGroups(objType); 
      //Creating a list of pair objects to use as a parameter
      //for the describe call
      List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
         
      //Looping throught the first describe result to create
      //the list of pairs for the second describe call
      for(DescribeDataCategoryGroupResult result: describeCategoryResult){
        DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
        p.setSobject(result.getSobject());
        p.setDataCategoryGroupName(result.getName());
        pairs.add(p);
      }
         
      describeCategoryStructureResult = Schema.describeDataCategoryGroupStructures(pairs, false);
      //Getting data from the result
      for(DescribeDataCategoryGroupStructureResult result : describeCategoryStructureResult){

        DataCategory [] toplevelCategories = result.getTopCategories();
        //Recursively get all the categories
        List<DataCategory> allCategories = getAllCategories(toplevelCategories);
        //take out 'All' category from allcategories for better processing
        List<DataCategory> categoryToIterate = new List<DataCategory>();
        for(DataCategory category: allCategories){
            if(category.getName().equalsIgnoreCase('All')){
                categoryToIterate.add(category);
            }
        }
        System.debug('categoryToIterate: ' +categoryToIterate);    
        displayCategories(categoryToIterate, '', new Node(), result.getName());    
        }  
        return describeCategoryStructureResult;
    }
    
    private List<DataCategory> getAllCategories(List<DataCategory> categories){
      if(categories.isEmpty()){
         return new List<DataCategory>();
      } else {
         List<DataCategory> categoriesClone = categories.clone();
         DataCategory category = categoriesClone.get(0);
         List<DataCategory> allCategories = new List<DataCategory>();
         allCategories.add(category);    
         categoriesClone.remove(0);
         categoriesClone.addAll(category.getChildCategories());
         allCategories.addAll(getAllCategories(categoriesClone));

         return allCategories;
      }
    }
       
    private void displayCategories(List<DataCategory> allCategories, String parentName, Node node, String uniqueNameGroup){
        for(DataCategory category : allCategories) {       
            Node nd = new Node(category.getLabel(), category.getName(),uniqueNameGroup);
            if(node.name != null){
                nd.father=node;
                node.children.add(nd);
            }else{
                wrap.children.add(nd);              
            }
            List<DataCategory> childs = category.getChildCategories();
            if(!childs.isEmpty()){
                displayCategories(childs, category.getName(), nd, uniqueNameGroup);
            } 
        }

    }
    
    public void setObjectName() {
        
        List<node>nodeSelectedList = new List<node>();
        categoryToFilter='';
        searchNode(nodeSelectedList, wrap.children);
        for(node nselected: nodeSelectedList){
            categoryToFilter=categoryToFilter+' AND '+(categoryFilter(nselected).removeStart(' BELOW ')); 
        }
        categoryToFilter=(!String.isEmpty(categoryToFilter))?categoryToFilter=categoryToFilter.removeStart(' AND'):'';
    }
 
    public void searchNode(List<Node> nodeSelectedList, List<Node> childrens){
        for(Node node: childrens){
            if (node.selected && (node.father==null || !node.father.selected)){
                nodeSelectedList.add(node);
            }
            if(!node.selected){
               searchNode(nodeSelectedList, node.children);
            }
        }
    }  
   
    public String categoryFilter(Node nodoHijo){
        if(nodoHijo ==null){
            return '';
        }
        return (nodoHijo.uniqueCategoryGroup+'__c'+' BELOW '+nodoHijo.unique+'__c');  
    }
    
    public void bannerHTML(){
        body1='';
        body2='';
        List<Document> docList= new List<Document>();
        try{
            docList =[Select Id, Name, body, Type from Document where Name like 'KB_Banner%'];   
        } catch(exception e){
            System.debug('ERROR: query not found: Select Id, Name, body, Type from Document where Name like');
        }
        if(!docList.isEmpty()&& docList.size()>=2){
            body1=docList.get(0).body.toString();
            System.debug('body1:'+body1);
            body2=docList.get(1).body.toString();
            System.debug('body2:'+body2);
        }

    }

    public void changePage(){
        System.debug('changePage');
        System.debug('changePage :'+apexpages.currentpage().getparameters().get('pageNumber'));
        String pageString= apexpages.currentpage().getparameters().get('pageNumber');
        Integer pageNumber =Integer.valueOf(pageString); 
        System.debug('standardSetCtrl'+standardSetCtrl);
        if(standardSetCtrl!=null){  
            standardSetCtrl.setPageNumber(pageNumber);
            listOfSuggest=standardSetCtrl.getRecords();
             System.debug('generateMapArticleVotes');
            generateMapArticleVotes(listOfSuggest);
        }  
        mapIdScoreDown= generateMapArticleScore(listOfSuggest, 'Down');
        mapIdScoreUp= generateMapArticleScore(listOfSuggest, 'Up');   
    }

    public PageReference viewKnowledgeBody(){
        
        string KBid = apexpages.currentpage().getparameters().get('KnowledgeArticleId');
        System.debug('KBid: ' +KBid);
        if (!String.isEmpty(KBid)){               
            articleSelected= new KB_Article__kav();
            articleSelected =[Select KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s, KB_ArticuloDestacado__c from KB_Article__kav WHERE PublishStatus='online' and KnowledgeArticleId =:KBid limit 1 UPDATE VIEWSTAT];
        }
        
        return null;
    }

    public class Wrapper{
        public List<node> children {get;set;}
        
        public wrapper(){
          children = new List<node>();
        }

        public void searchNodeByUniqueName(String uniqueName, String uniqueCategoryGroup, List<Node> childrens){
            System.debug('searchNodeByUniqueName ');
  
            if(String.isEmpty(uniqueName) || String.isEmpty(uniqueCategoryGroup)){
                System.debug('no se encontro category: ' +uniqueName+' o no se encontro category group: '+uniqueCategoryGroup);
                
            }else{
                for(Node child : childrens){
                    if (child.unique.equalsIgnoreCase(uniqueName) && child.uniqueCategoryGroup.equalsIgnoreCase(uniqueCategoryGroup)){
                        child.selectChild();
                    }else{
                        searchNodeByUniqueName(uniqueName, uniqueCategoryGroup, child.children);
                    }
                }
            }
        }
    }
    
    public class Node {
    
        public String name{get; set;}
        public String unique{get; set;}
        public Node father{get; set;}
        public Boolean selected{get; set;}
        public List<node> children{get; set;}
        public String uniqueCategoryGroup{get; set;}
        public Node(){
            children = new List<node>();
        }
        public Node(String typeName, String uniqueName, String uniqueNameGroup){
            name = typeName;
            unique = uniqueName;
            children = new List<node>();
            selected = false;
            uniqueCategoryGroup=uniqueNameGroup;
        }
        
        public void selectChild(){
            selected=!selected;
            for(Node child : Children){
                child.selected=!selected;
                child.selectChild();
            }
            if(!selected){
                unSelectedFather();
            }else if(father!=null && !father.selected){
                isAllChildSelected();
            }
        }
        
        public void isAllChildSelected(){
            Boolean allSelected=true;
            for(Node child : children){
                allSelected=(allselected && child.selected);
            }
            Selected=allSelected;
            if(father!=null){
                father.isAllChildSelected();
            }
        }
        
        public void unSelectedFather(){
            if(father!=null){
                father.selected=selected;
                father.unSelectedFather();        
            }
        }
    }

}