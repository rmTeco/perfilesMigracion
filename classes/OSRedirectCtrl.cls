public with sharing class OSRedirectCtrl {
      
       //below BASEURL variable would be removed after getting final urls for all sources
       String constructedUrl;
String insId;
      // String Sourceparam; 

       static final String BASEURL = URL.getSalesforceBaseUrl().toExternalForm() ;
       static final String SAVEDOSURLP =  'https://vlocity-cmt.cs63.visual.force.com/apex/vlocity_cmt__OmniScriptUniversalPage?layout=lightning#/OS/'; 
       static final String SAVEDOSURLPCLASSIC =  '/apex/vlocity_cmt__OmniScriptUniversalPage?layout=classic#/OS/';
       static final String SAVEDOSURLE = '/scriptState/saveAndResume/true/true';
       static final String VPACKAGE = 'vlocity-cmt.';
       

       public OSRedirectCtrl (){
           //Sourceparam = ApexPages.currentPage().getParameters().get('Source');
           insId = ApexPages.currentPage().getParameters().get('sInstanceId');
system.debug('insid+++++'+insId);

           
           //System.debug('Sourceparam'+Sourceparam);
           System.debug('get page parameters'+ApexPages.currentPage().getHeaders().get('Host'));
       }
       public PageReference returnURL() {
           PageReference pageRef;
           //redirection logic for Cancel Button
           system.debug('++++++constructedUrl'+SAVEDOSURLP + insId + SAVEDOSURLE);
system.debug('++++++classicconstructedUrl'+BASEURL.substring(0,8) + VPACKAGE + BASEURL.substringAfter('.')+  SAVEDOSURLPCLASSIC + insId + SAVEDOSURLE);
              if(insId!= null){
               //constructedUrl = BASEURL.substring(0,8) + VPACKAGE + BASEURL.substringAfter('.')+  SAVEDOSURLP + insId + SAVEDOSURLE;
                constructedUrl = SAVEDOSURLP + insId + SAVEDOSURLE;
                System.debug('constructedUrl@@@@InsideEnroll'+constructedUrl);
           }
           
           if(constructedUrl!=null){
               pageRef = new PageReference(constructedUrl);
           }
               return pageRef;
       }   
   }