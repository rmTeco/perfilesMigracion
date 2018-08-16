@isTest(seeAllData = false)
public with sharing class KB_KnowledgeInterfaceController_Test {
    

    public KB_KnowledgeInterfaceController_Test(){
        searchTest();
        categoryTest();
    }

    public static KB_Article__kav createData(){
        KB_Article__kav article = new KB_Article__kav();
        article.Title='Test1';
        article.UrlName='Test1'+Integer.valueOf(Math.Random());
        insert article;
        article=[Select id, KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s from KB_Article__kav WHERE PublishStatus='Draft' and id=: article.id limit 1];
        KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, false);

        Vote vote= new Vote();
        vote.ParentId=article.KnowledgeArticleId;
        vote.Type='UP';
        insert vote;

        article = new KB_Article__kav();
        article.Title='Test2';
        article.UrlName='Test2'+Integer.valueOf(Math.Random());
        insert article;
        article=[Select id, KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s from KB_Article__kav WHERE PublishStatus='Draft' and id=: article.id limit 1 UPDATE VIEWSTAT];
        KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, false);

        article = new KB_Article__kav();
        article.Title='Test3';
        article.UrlName='Test3'+Integer.valueOf(Math.Random());
        insert article;
        article=[Select id, KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s from KB_Article__kav WHERE PublishStatus='Draft' and id=: article.id limit 1 UPDATE VIEWSTAT];
        KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, false);

        article = new KB_Article__kav();
        article.Title='Test4';
        article.UrlName='Test4'+Integer.valueOf(Math.Random());
        insert article;
        article=[Select id, KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s from KB_Article__kav WHERE PublishStatus='Draft' and id=: article.id limit 1];
        KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, false);

        article = new KB_Article__kav();
        article.Title='Test5';
        article.UrlName='Test5'+Integer.valueOf(Math.Random());
        insert article;
        article=[Select id, KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s from KB_Article__kav WHERE PublishStatus='Draft' and id=: article.id limit 1 UPDATE VIEWSTAT];
        KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, false);   

        return article;
    }

    static testmethod void searchTest() {

        KB_Article__kav article = createData();
    
        Test.startTest();

        KB_KnowledgeInterfaceController test_KnowledgeInterfaceController = new KB_KnowledgeInterfaceController();
        PageReference pageRef = Page.KB_KnowledgeInterface;
        pageRef.getParameters().put('KnowledgeArticleId', String.valueOf(article.KnowledgeArticleId));
        pageRef.getParameters().put('pageNumber', '1');
        pageRef.getParameters().put('orderBy', Label.KB_Most_viewed);
        Test.setCurrentPage(pageRef);
        
        test_KnowledgeInterfaceController.categoryFilter(null);
        test_KnowledgeInterfaceController.search();
        test_KnowledgeInterfaceController.viewKnowledgeBody();
        test_KnowledgeInterfaceController.searchInput();
        test_KnowledgeInterfaceController.searchText='Test';
        test_KnowledgeInterfaceController.searchInput();
        test_KnowledgeInterfaceController.changePage();

        pageRef.getParameters().put('orderBy', Label.KB_most_voted);
        test_KnowledgeInterfaceController.searchInput();
        pageRef.getParameters().put('orderBy', Label.KB_Titulo_A_Z);
        test_KnowledgeInterfaceController.searchInput();
        pageRef.getParameters().put('orderBy', Label.KB_Titulo_Z_A);
        test_KnowledgeInterfaceController.searchInput();
        pageRef.getParameters().put('orderBy', Label.KB_Ultima_modificacion);
        test_KnowledgeInterfaceController.searchInput();
        test_KnowledgeInterfaceController.topFive();

        Test.stopTest();
    }
    static testmethod void categoryTest() {
        
        Test.startTest();

        KB_KnowledgeInterfaceController test_KnowledgeInterfaceController = new KB_KnowledgeInterfaceController();
        PageReference pageRef = Page.KB_KnowledgeInterface;

        Test.setCurrentPage(pageRef);

        test_KnowledgeInterfaceController.search();
        pageRef.getParameters().put('selected', 'Venta'); 
        pageRef.getParameters().put('selectedCategory', 'KB_CategoriasInternas');   
        test_KnowledgeInterfaceController.searchInput();

        pageRef.getParameters().put('selected', 'TransferenciaDeGastos'); 
        pageRef.getParameters().put('selectedCategory', 'KB_CategoriasInternas');   
        test_KnowledgeInterfaceController.searchInput();
        pageRef.getParameters().put('selected', 'ExperienciaDelCliente'); 
        pageRef.getParameters().put('selectedCategory', 'KB_CategoriasInternas');
        test_KnowledgeInterfaceController.searchInput();    
        pageRef.getParameters().put('selected', 'Instructivos'); 
        pageRef.getParameters().put('selectedCategory', 'KB_CategoriasInternas');
        test_KnowledgeInterfaceController.searchInput();    
        pageRef.getParameters().put('selected', 'TramitesYConsultas'); 
        pageRef.getParameters().put('selectedCategory', 'KB_CategoriasInternas');
        test_KnowledgeInterfaceController.searchInput();

        pageRef.getParameters().put('selected', 'SoporteALaGestion'); 
        pageRef.getParameters().put('selectedCategory', 'KB_CategoriasInternas');
        test_KnowledgeInterfaceController.searchInput();

        Test.stopTest();    
    }
}