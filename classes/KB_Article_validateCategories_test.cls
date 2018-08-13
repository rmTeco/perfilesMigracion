@isTest(seeAllData = false)
public class KB_Article_validateCategories_test {

	static testmethod void validateUpdateCategoriesTest(){
		String url;
		//List<String> idList;
		List<KB_Article__kav> articleList;
		KB_Article__kav articleWihtCategories;

		articleWihtCategories = new KB_Article__kav();
		articleWihtCategories.Title='Test';
		url='Paso-a-Paso'+Integer.valueOf(Math.Random());
		articleWihtCategories.UrlName=url;
		articleWihtCategories.KB_ArticleType__c='Paso a Paso';
		insert articleWihtCategories;
		
		articleList =[select id, KnowledgeArticleId from KB_Article__kav where UrlName =:url and PublishStatus ='Draft'];
		List<String> idListPasoAPaso=new List<String>();
		for (KB_Article__kav art: articleList ){
			idListPasoAPaso.add(art.KnowledgeArticleId);
		}


		articleWihtCategories = new KB_Article__kav();
		articleWihtCategories.Title='Test';
		url='Contenido-Libre'+Integer.valueOf(Math.Random());
		articleWihtCategories.UrlName=url;
		articleWihtCategories.KB_ArticleType__c='Contenido Libre';
		insert articleWihtCategories;
		
		articleList =[select id, KnowledgeArticleId from KB_Article__kav where UrlName =:url and PublishStatus ='Draft'];
		List<String> idListContenidoLibre=new List<String>();
		for (KB_Article__kav art: articleList ){
			idListContenidoLibre.add(art.KnowledgeArticleId);
		}



		articleWihtCategories = new KB_Article__kav();
		articleWihtCategories.Title='Test';
		url='Pregunta-y-Respuesta'+Integer.valueOf(Math.Random());
		articleWihtCategories.UrlName=url;
		articleWihtCategories.KB_ArticleType__c='Pregunta y Respuesta';
		insert articleWihtCategories;
		
		articleList =[select id, KnowledgeArticleId from KB_Article__kav where UrlName =:url and PublishStatus ='Draft'];
		List<String>idListPreguntaYRespuesta=new List<String>();
		for (KB_Article__kav art: articleList ){
			idListPreguntaYRespuesta.add(art.KnowledgeArticleId);
		}



		articleWihtCategories = new KB_Article__kav();
		articleWihtCategories.Title='Test';
		url='Video'+Integer.valueOf(Math.Random());
		articleWihtCategories.UrlName=url;
		articleWihtCategories.KB_ArticleType__c='Video';
		insert articleWihtCategories;
		
		articleList =[select id, KnowledgeArticleId from KB_Article__kav where UrlName =:url and PublishStatus ='Draft'];
		List<String>idListVideo=new List<String>();
		for (KB_Article__kav art: articleList ){
			idListVideo.add(art.KnowledgeArticleId);
		}



		articleWihtCategories = new KB_Article__kav();
		articleWihtCategories.Title='Test';
		url='Adjunto'+Integer.valueOf(Math.Random());
		articleWihtCategories.UrlName=url;
		articleWihtCategories.KB_ArticleType__c='Adjunto';
		insert articleWihtCategories;
		
		articleList =[select id, KnowledgeArticleId from KB_Article__kav where UrlName =:url and PublishStatus ='Draft'];
		List<String>idListAdjunto=new List<String>();
		for (KB_Article__kav art: articleList ){
			idListAdjunto.add(art.KnowledgeArticleId);
		}

		Test.startTest();
		KB_Article_validateCategories.validateUpdateCategories(idListPasoAPaso);
		
		KB_Article_validateCategories.validateUpdateCategories(idListContenidoLibre);

		KB_Article_validateCategories.validateUpdateCategories(idListPreguntaYRespuesta);

		KB_Article_validateCategories.validateUpdateCategories(idListVideo);
		Test.stopTest();
	}

	
}