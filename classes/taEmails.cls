global with sharing class taEmails implements vlocity_cmt.VlocityOpenInterface{

    global taEmails(){}
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
            if(methodName.equals('getEmails')){
                getEmails(methodName, input, outMap, options);
            }

            if(methodName.equals('sendEmailToWorkteamManager')){
                sendEmailToWorkteamManager(input, outMap, options);
            }
        }
        catch(Exception e)
        {
            System.debug('taEmails:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    void getEmails(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        try
        {
            List<ValidEmailDomain__c> domainList = ValidEmailDomain__c.getall().values();
            List<Map<String,Object>> listEmails = new List<Map<String,Object>>();

            for (ValidEmailDomain__c mydomain : domainList) {
                    listEmails.add(new Map<String,Object>{'mail' => mydomain.Name});
                }
            System.debug(JSON.serialize(listEmails));
            outMap.put('Emails', listEmails);
        }
        catch(Exception ex)
        {
            throw ex;
        }
    }
    
 



    global static void sendEmailToWorkteamManager(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) 
    {      
        Map<String,Object> result = new Map<String,Object>(); 
        
        try
        {
            //String caseOwner = '0056C000000gQeh';
            //String workteamId = 'a4l6C0000000790';
            
            String caseId = (String)options.get('caseId');
            System.debug ('Caso: ' + caseId);           
            Case myCase = [SELECT Subject, Status, OwnerId, AccountId FROM Case WHERE Id = :caseId];
            Account myAccount = [SELECT Id, Name, AccountIntegrationId__c FROM Account WHERE Id = :myCase.AccountId];
            String url = URL.getSalesforceBaseUrl().toExternalForm() + '/' + myAccount.Id ;
            String workteamId, managerId;

            if (!Test.isRunningTest())
            {
                workteamId = [SELECT Work_Team__c FROM  Team_Member__c WHERE User_member__c = :UserInfo.getUserId()].Work_Team__c;        
                managerId = [SELECT Manager__c FROM WorkTeam__c WHERE Id =:workteamId].Manager__c;
            }
            else
            {
                workteamId = 'a4l6C0000000790';
                //managerId = [SELECT Manager__c FROM WorkTeam__c WHERE Name='EquipoTst' Limit 1].Manager__c;
            }   managerId='005c0000004PsJEAA0';

            String subject = 'Notificación por Ajuste repetitivo - Usuario '+ UserInfo.getName();
            String textBody = 'El usuario '+ UserInfo.getName() +' ha alcanzado el límite máximo preestablecido de ajustes al mismo Cliente ' + 
            + '<a href='+url+' style="color:#00b4c5; text-decoration: none;font-size:12px;"><span style="color:#00b4c5;">' + myAccount.AccountIntegrationId__c + '</span></a>'; 
            String htmlBody = '<html><style>p{margin-top:0px; margin-bottom:0px;}</style><body class="setupTab"  onload="init()"  style=" background-color:#ffffff; bEditID:b1st1; bLabel:body;"><center ><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450" ><tr valign="top" ><td  style=" background-color:#00b4c5; bEditID:r1st1; bLabel:header; vertical-align:middle; height:100; text-align:left;"><img border="0" bEditID="r1sp1" bLabel="headerImage" id="r1sp1" src="https://ta-dev--Desa01.cs63.my.salesforce.com/servlet/servlet.ImageServer?id=0156C000000Ee6N&oid=00D6C0000000eSz" ></img></td></tr><tr valign="top" ><td  style=" background-color:#AAAAFF; bEditID:r2st1; bLabel:accent1; height:0;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" background-color:#FFFFFF; bEditID:r3st1; color:#000000; bLabel:main; font-size:12pt; font-family:arial;"><table border="0" cellpadding="5" width="550" cellspacing="5" height="400" ><tr valign="top" height="400" ><td tEditID="c1r1" style=" background-color:#FFFFFF; bEditID:r3st1; color:#000000; bLabel:main; font-size:12pt; font-family:arial;" aEditID="c1r1" locked="0" ><span style="background-color: rgb(244, 245, 247);"><font style=""><font color="#000000" face="arial" style=""><span style="font-size: 14px;">'+ textBody + '</span></font><span style="color: rgb(0, 0, 0); font-family: arial; font-size: 14px;"></span></font></span></td></tr></table></td></tr><tr valign="top" ><td  style=" background-color:#AAAAFF; bEditID:r4st1; bLabel:accent2; height:0;"></td></tr><tr valign="top" ><td  style=" background-color:#eeeeee; bEditID:r5st1; bLabel:footer; vertical-align:middle; height:100; text-align:center;"><img border="0" bEditID="r5sp1" bLabel="footerImage" id="r5sp1" src="https://ta-dev--Desa01.cs63.my.salesforce.com/servlet/servlet.ImageServer?id=0156C000000Ee7L&oid=00D6C0000000eSz" ></img></td></tr><tr valign="top" ><td  style=" background-color:#AAAAFF; bEditID:r6st1; bLabel:accent3; height:0;"></td></tr></table></center></htmml>';
                    
            System.debug('managerId: '+ managerId);

            if(String.isBlank(managerId))
            { 
                //No hay un manager configurado par el equipo
                result.put('codError', '101');
                result.put('descError', 'El equipo no tiene un manager configurado');                
            }
            else
            {
                //sendInternalEmailUsingTemplate(managerId, templateName, caseId);
                sendInternalEmail(managerId, subject, htmlBody);
                result.put('codError', '0');
                outMap.put('result',result);
            }

        }
        catch(Exception ex) 
        { 
            System.debug('Error general: '+ex.getMessage());
            result.put('codError', '102');
            result.put('descError', 'Error sendEmailToWorkteamManager():'+ ex.getMessage()); 
            outMap.put('result',result); 
        }
    }


    public static void sendInternalEmail(String toUserId, String subject, String htmlBody)
    { 
        try
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                       
            mail.setTargetObjectId(toUserId);            
            mail.setSubject(subject);                         
            mail.setSaveAsActivity(false);    
            mail.setHtmlBody(htmlBody);
           
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
        catch(Exception ex)
        {
            throw ex;
        }                   
    }    
    

    /***************************************************************************/
    /*
    Fecha: 18/04/2018
    Creado por: Gfiore
    Descripcion: Envia email a usuario interno     
    */
    /***************************************************************************/
    /*public static void sendInternalEmailUsingTemplate(String toUserId, String templateName, String whatId)
    { 
        try
        {
            String templateId = [Select Id from EmailTemplate where DeveloperName=:templateName].Id;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //mail.setTargetObjectId(UserInfo.getUserId());
            mail.setWhatId(whatId);
            mail.setTargetObjectId(toUserId);
            mail.setTemplateId(templateId);                          
            mail.setSaveAsActivity(false);              
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
        catch(Exception ex)
        {
            throw ex;
        }                   
    }*/  
    

}