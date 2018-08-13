global with sharing class Mkt_CPDataManager implements vlocity_cmt.VlocityOpenInterface{

    
    global Mkt_CPDataManager() {}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true; 

        try{
            if (methodName.equals('getAccountsCP')){
                getAccountsCP(inputMap, outMap);
            }
            if (methodName.equals('createMembers')){
                createMembers(inputMap, outMap);
            }
            if (methodName.equals('deleteMembers')){
                deleteMembers(inputMap, outMap);
            }
            if (methodName.equals('getUsersInfo')){
                getUsersInfo(inputMap, outMap);
            }
        }catch(Exception e){
            System.debug('Mkt_CPDataManager:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

   public void getAccountsCP (Map<String, Object> inputMap, Map<String, Object> outMap) {
        String accountId = (String) inputMap.get('ContextId');

        Account account = [SELECT Id, vlocity_cmt__PrimaryContactId__c, 
                                  vlocity_cmt__PrimaryContactId__r.DocumentNumber__c,
                                  vlocity_cmt__PrimaryContactId__r.DocumentType__c,
                                  vlocity_cmt__PrimaryContactId__r.Dunning__c,
                                  vlocity_cmt__PrimaryContactId__r.Email,
                                  vlocity_cmt__PrimaryContactId__r.Validated__c
                             FROM Account 
                            WHERE Id = :accountId];

        Map<String, Object> accountMap = new Map<String, Object>();
        List<Map<String,Object>> consumerMap = new List<Map<String,Object>>();
        List<Map<String,Object>> businessMap = new List<Map<String,Object>>();
        
        //Contact Data for JSON
        Map<String, Object> contactMap = new Map<String, Object>();
        contactMap.put('DocumentNumber',account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c);
        contactMap.put('DocumentType',account.vlocity_cmt__PrimaryContactId__r.DocumentType__c);
        contactMap.put('Dunning',account.vlocity_cmt__PrimaryContactId__r.Dunning__c);
        contactMap.put('Email',account.vlocity_cmt__PrimaryContactId__r.Email);
        contactMap.put('Validated',account.vlocity_cmt__PrimaryContactId__r.Validated__c);
        accountMap.put('contact', contactMap);

        //Accounts Data for JSON
        List<Account> accounts = [SELECT Id, Name, ClubMember__c, AccountNumber, PersonalClubCategory__c, Dunning__c, Fraud__c, RecordType.DeveloperName
                                    FROM Account 
                                   WHERE vlocity_cmt__PrimaryContactId__c = :account.vlocity_cmt__PrimaryContactId__c 
                                     AND Dunning__c = false 
                                     AND Fraud__c = false 
                                     AND (RecordType.DeveloperName = 'Business' 
                                      OR RecordType.DeveloperName = 'Consumer')];
        //Set accounts nodes
        for(Account acc : accounts){
            Map<String,Object> aux = new Map<String,Object>();
            aux.put('Id',acc.Id);
            aux.put('Name',acc.Name);
            aux.put('Dunning',acc.Dunning__c);
            aux.put('Fraud',acc.Fraud__c);
            aux.put('ClubCategory',acc.PersonalClubCategory__c);
            aux.put('ClubMember',acc.ClubMember__c);
            aux.put('PersonalClubPoints', getPoints(acc.Id));
            if(acc.RecordType.DeveloperName == 'Business'){
                businessMap.add(aux);
            }else{
                consumerMap.add(aux);
            }
            system.debug('Yamil Categoria2: '+aux);
        }

        accountMap.put('businessAccounts', businessMap);
        accountMap.put('consumerAccounts', consumerMap);
        outMap.put('accounts',accountMap);
   }

   public Double getPoints(String accId){
        GP_adapter adapter = new GP_adapter();
        Map<String, Object> pointsResult = new Map<String, Object>();
        Map<String, Object> serviceAccounts = new Map<String, Object>();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> memberData = new Map<String, Object>();
        memberData.put('titularID',accId);
        memberData.put('subscriptorID','0');
        input.put('datosSocio',memberData);
        try{
            adapter.consultarPuntos(input, pointsResult);
        }catch(Exception e){
            return 0;
        }
        Map<String, Object> totalResult = (Map<String, Object>)pointsResult.get('resultadoSaldoTotal');
        Double  points = (Double)totalResult.get('totalPuntosDisponibles');
        return points;
   }

    public void getUsersInfo(Map<String, Object> inputMap, Map<String, Object> outMap){
        try{
            GP_adapter adapter = new GP_adapter();
            Map<String, Object> pointsResult = new Map<String, Object>();
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> memberData = new Map<String, Object>();
            memberData.put('titularID',(String)inputMap.get('ContextId'));
            memberData.put('subscriptorID','0');
            input.put('datosSocio',memberData);
            
            adapter.consultarPuntos(input, pointsResult);
            outMap.put('resultadoSaldoTotal',(Map<String, Object>)pointsResult.get('resultadoSaldoTotal'));
        }catch(Exception e){
            System.debug('getUsersInfo:invokeMethod -> exception: '+e);
            outMap.put('Exception',e);
        }
    }

   public static void createMembers (Map<String, Object> inputMap, Map<String, Object> outMap) {
        Map<String,Object> clubPersonal = (Map<String, Object>)inputMap.get('AltaClubPersonal');
        List<Object> consumers = VlocityOpenInterfaceHelper.getListObjectsFromMap(clubPersonal,'consumerAccounts');
        List<Object> business = VlocityOpenInterfaceHelper.getListObjectsFromMap(clubPersonal,'businessAccounts');
        Map<String, Object> input = new Map<String, Object>();
        List<Map<String, Object>> newMembers = new List<Map<String, Object>>();
        List<Map<String, Object>> membersPointsList = new List<Map<String, Object>>();
        Set<String> accSet = new Set<String>();
        Map<Id, Account> accInfoMap;

        if(consumers != null){
            for(Object acc : consumers) {
                Map<String,Object> mapacc = (Map<String,Object>)acc;
                accSet.add(String.valueOf(mapacc.get('Id')));
            }
            if(business != null){
                for(Object acc : business) {
                    Map<String,Object> mapacc = (Map<String,Object>)acc;
                    accSet.add(String.valueOf(mapacc.get('Id')));
                }
            }
            accInfoMap = new Map<Id, Account>([SELECT Id, PersonalClubCategory__c FROM Account WHERE Id IN :accSet]);
            for(Object acc : consumers){
                Map<String, Object> memberPoints = new Map<String, Object>();
                Map<String,Object> mapacc = (Map<String,Object>)acc;
                Map<String, Object> newMember = new Map<String, Object>();
                newMember.put('cuenta',mapacc.get('Id'));
                newMembers.add(newMember);    
                //Fill JSON for points scoring
                memberPoints.put('titularID',mapacc.get('Id'));
                memberPoints.put('suscriptorID','0');
                memberPoints.put('tipoDeEvento','Bienvenida');
                memberPoints.put('numeroDeOrden',0);
                List<Map<String,Object>> eventAtt = new List<Map<String,Object>>();
                Map<String,Object> aux = new Map<String,Object>();
                aux.put('variable','CATEGORIA DE SOCIO');
                aux.put('tipo','STRING');
                aux.put('valorString', accInfoMap.get(String.valueOf(mapacc.get('Id'))).PersonalClubCategory__c);
                eventAtt.add(aux);
                memberPoints.put('atributosEvento',eventAtt);
                membersPointsList.add(memberPoints);
            }
        }
        if(business != null){
            for(Object acc : business){
                Map<String, Object> memberPoints = new Map<String, Object>();
                Map<String,Object> mapacc = (Map<String,Object>)acc;
                Map<String, Object> newMember = new Map<String, Object>();
                newMember.put('cuenta',mapacc.get('Id'));
                newMembers.add(newMember);    
                //Fill JSON for points scoring
                memberPoints.put('titularID',mapacc.get('Id'));
                memberPoints.put('suscriptorID','0');
                memberPoints.put('tipoDeEvento','Bienvenida');
                memberPoints.put('numeroDeOrden',0);
                List<Map<String,Object>> eventAtt = new List<Map<String,Object>>();
                Map<String,Object> aux = new Map<String,Object>();
                aux.put('variable','CATEGORIA DE SOCIO');
                aux.put('tipo','STRING');
                aux.put('valorString', accInfoMap.get(String.valueOf(mapacc.get('Id'))).PersonalClubCategory__c);
                eventAtt.add(aux);
                memberPoints.put('atributosEvento',eventAtt); 
                membersPointsList.add(memberPoints);
            }
        }   
        
        input.put('datosSocio', newMembers);
        
        try{
            GP_adapter.crearAcumuladorSocioTitular(input);
            outMap.put('AltaGP','Ok');
        }catch(Exception e){
            System.debug('createMembers:invokeMethod: ' + input + '  -> exception: '+e);
            outMap.put('Exception',e);
       }
       try{//This is not the best practice but we cannot differentiate the exception returned from the API 
            Map<String,Object> sumar = new Map<String,Object>(); 
            sumar.put('sumarRestarPuntos',membersPointsList);
            System.debug('Yamil sumar: '+sumar);
            GP_adapter.sumarRestarPuntos(sumar, outMap);
        }catch(Exception e){
            System.debug('sumarRestarPuntos:invokeMethod: ' + membersPointsList + ' -> exception: '+e);
            outMap.put('Exception',e);
        }
   }

   public void deleteMembers (Map<String, Object> inputMap, Map<String, Object> outMap) {
        try{
            Map<String,Object> clubPersonal = (Map<String, Object>)inputMap.get('CPMembershipCancellation');
            List<Object> consumers = new List<Object>();
            consumers = VlocityOpenInterfaceHelper.getListObjectsFromMap(clubPersonal,'consumerAccounts');
            List<Object> business = new List<Object>();
            business = VlocityOpenInterfaceHelper.getListObjectsFromMap(clubPersonal,'businessAccounts');
            Map<String, Object> input = new Map<String, Object>();
            List<Map<String, Object>> newMembers = new List<Map<String, Object>>();
            GP_adapter adapter = new GP_adapter();
        
            if(consumers != null){
                for(Object acc : consumers){
                    Map<String,Object> mapacc = (Map<String,Object>)acc;
                    Map<String, Object> newMember = new Map<String, Object>();
                    newMember.put('titularID',mapacc.get('Id'));
                    newMember.put('suscriptorID','0');
                    newMembers.add(newMember);       
                }
            }
            if(business != null){
                for(Object acc : business){
                    Map<String,Object> mapacc = (Map<String,Object>)acc;
                    Map<String, Object> newMember = new Map<String, Object>();
                    newMember.put('titularID',mapacc.get('Id'));
                    newMember.put('suscriptorID','0');
                    newMembers.add(newMember);    
                }
            }
            
            input.put('datosSocio', newMembers);
            adapter.eliminarAcumuladores(input);
            outMap.put('BajaGP','Ok');
        }catch(Exception e){
            System.debug('deleteMembers:invokeMethod -> exception: '+e);
            outMap.put('Exception',e);
        }
   }
}