public class KB_Article_validateCategories {
    
    @InvocableMethod(label='KB_validateCategories' description='Validate categories to publish articles.')
    public static void validateUpdateCategories(List<String> kbArticleId ){ 
        System.debug('validateUpdateCategories ArticleId: ' +kbArticleId); 
        if(!kbArticleId.isEmpty()){       
            String artId=kbArticleId.get(0);
            List <KB_Article__kav> articlesList= [Select Id, PublishStatus, KB_AssignedCategory__c, KnowledgeArticleId, KB_ArticleType__c, KB_Body__c  from KB_Article__kav where UrlName =: artId and PublishStatus ='Draft'];
            
            for(KB_Article__kav article: articlesList){
                List <KB_Article__DataCategorySelection> dataCategoriList =[Select DataCategoryName from KB_Article__DataCategorySelection where ParentId =: article.Id];            
                System.debug('dataCategoriList: ' +dataCategoriList);
                //if(article.PublishStatus.equalsIgnoreCase('Draft')){
                    article.KB_AssignedCategory__c =(dataCategoriList.size()>=1);
                //  article.KB_RunValidations__c=false;
               // }
                if(String.isEmpty(article.KB_Body__c)){
                    if(!String.isEmpty(article.KB_ArticleType__c)){
                        String articleType;
                        if(article.KB_ArticleType__c.equalsIgnoreCase('Contenido Libre')){
                            articleType='KB_Contenido_libre_template';
                        }
                        else if(article.KB_ArticleType__c.equalsIgnoreCase('Paso a Paso')){
                            articleType='KB_Paso_a_paso_template';
                        }
                        else if(article.KB_ArticleType__c.equalsIgnoreCase('Pregunta y Respuesta')){
                            articleType='KB_Preguntas_y_respuestas_template';
                        }
                        else if(article.KB_ArticleType__c.equalsIgnoreCase('Video')){
                            articleType='KB_Video_template';
                        }
                        else if(article.KB_ArticleType__c.equalsIgnoreCase('Adjunto')){
                            articleType='KB_Adjunto_template';
                        }

                        for(StaticResource staticR:[select id, name, Body from StaticResource where name =:articleType]){
                            System.debug('staticR.Body: ' +staticR.Body.toString());
                            article.KB_Body__c=staticR.Body.toString();
                        }
                    }   
                }
            }
            update articlesList;
        }
    }
}