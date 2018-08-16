global with sharing class KB_articleVoteController {
    public KB_articleVoteController() {
        
    }

    @remoteAction
    global static String changeRating(String idArt, String rating ){
        System.debug('changeRating');
        System.debug('vote: '+idArt+rating);

        Vote vote= new Vote();
        vote.ParentId=idArt;
        vote.Type=rating;
        try{
            INSERT vote;
            
        }catch(exception e){
            
            vote=[SELECT Id FROM Vote where PARENTID=:idArt and  CreatedById =:UserInfo.getUserId()];
            DELETE vote;
            vote= new Vote();
            vote.ParentId=idArt;
            vote.Type=rating; 
            INSERT vote;
            System.debug('ERROR:' + e);
        }

        System.debug('vote: ' +vote);

        return null;
    }

    
    @remoteAction
    global static String sendMail(String comentario, String option, String idArt){

        if(String.isNotBlank(comentario)||String.isNotBlank(option)){

            KB_Article__kav articleSelected=[Select id, KnowledgeArticleId, Title from KB_Article__kav WHERE PublishStatus='online' and KnowledgeArticleId =:idArt limit 1 ];
                
            EmailTemplate emailTemplate = [select Id, Subject, Body from EmailTemplate where Name='KB_Template_email_HTML'];
            //Name='KB_Template_email'];

            String sub=emailTemplate.Subject;
            sub= sub.replace('{!KB_article.Title}', articleSelected.Title);

            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!KB_article.Title}', articleSelected.Title+'\n');
            plainBody = plainBody.replace('{!option}', option+'\n');
            plainBody = plainBody.replace('{!comentario}', comentario);
           
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

            KB_email_List__c email= KB_email_List__c.getall().get('emails');
            message.toAddresses = email.to__c.split(','); 
            message.subject = sub;
            message.plainTextBody = plainBody;  
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }

            /* SE COMENTA LA GENERACIÓN DE CASOS HASTA CONFIRMACIÓN DE TELECOM
            
            Group owner=[select Name, Id from Group where Type = 'Queue' and DeveloperName='KB_Publicadores'];
            RecordType record =[SELECT DeveloperName,Id FROM RecordType where DeveloperName='KB_KnowledgeArticles' limit 1];
            Case c1 = new Case (subject=articleSelected.Title, Type='KnowledgeArticles', Description=comentario, 
                KB_MotivoReclamo__c=option, RecordTypeID=record.Id, OwnerId=owner.id);
            INSERT c1;

            System.debug('Case: ' + c1);
            */
        } 
         return null;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        Schema.DescribeFieldResult fieldResult = Case.KB_MotivoReclamo__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        } 

        return options;
 
    }
}