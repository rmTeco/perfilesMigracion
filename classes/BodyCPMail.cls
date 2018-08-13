global with sharing class BodyCPMail implements vlocity_cmt.VlocityOpenInterface{
    global BodyCPMail() {}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        Boolean result = true;

        try 
        {
            if (methodName.equals('GetEmailBody'))
            {
                GetEmailBody(inputMap,outMap);
            }
            else 
            {
                result = false;
            }   
        } 
        catch(Exception e)
        {
            System.debug('BodyCPMail:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    public void GetEmailBody(Map<String, Object> inputMap, Map<String, Object> outMap){
        try{
            Boolean change = false;
            
            CalloutException e = new CalloutException();
            
            String caseId = (String) inputMap.get('DRId_Case');        
             System.debug('inputMap ' + inputMap);
           
            if(caseId == null || caseId == ''){
                e.setMessage('No existe DRId_Case');
                throw e;
            }
            
            String op = (String) inputMap.get('Case:Description');
            
            if(op == null || op == ''){
                e.setMessage('No existe Case:Description');
                throw e;
            }
            
            if(op.contains('ALTA')){
                op = 'alta';
            }else if(op.contains('BAJA')){
                op = 'baja';
            }else{
                e.setMessage('tipo de operacion Alta o Baja no definida');
                throw e;
            }
                            
            Map<String, Object> accounts = new Map<String, Object>();
            Set<String> businessAccounts = new Set<String>();
            Set<String> consumerAccounts = new Set<String>();
            
            if(op.equals('alta')){
                accounts = (Map<String,Object>) inputMap.get('AltaClubPersonal');
                //System.debug('accounts ' + accounts);      
            }else{
                accounts = (Map<String,Object>) inputMap.get('CPMembershipCancellation');
                //System.debug('accounts ' + accounts);  
            }
            
            Object baccs = accounts.get('businessAccounts');
            //System.debug('baccs ' + baccs);
            
            if(baccs != null)
            businessAccounts = getIds(String.valueof(baccs));
       
            Object conAccs = accounts.get('consumerAccounts');
            //System.debug('conAccs ' + conAccs);
            
            if(conAccs != null)
            consumerAccounts = getIds(String.valueof(conAccs));
    
            System.debug('consumerAccounts ' + consumerAccounts);
            
            //query de business accs
            List<Account> bAccountDetailList = [SELECT Name, AccountNumber FROM Account WHERE Id IN :businessAccounts];
    
            //System.debug('bAccountDetailList ' + bAccountDetailList);
    
            //query de consumer accs
            List<Account> cAccountDetailList = [SELECT Name, AccountNumber FROM Account WHERE Id IN :consumerAccounts];
            
            System.debug('cAccountDetailList ' + cAccountDetailList);
            
            //genero description
            Case c = new Case(Id = caseId);
            String newDescription = ''; 
            
            newDescription = 'Cuentas que se han dado de ' + op + ': \n\n';
            
            if(bAccountDetailList.size() != 0){
                change = true;
                newDescription = newDescription + 'Business Accounts: \n\n';
                
                /*loop de customer*/
                for(Account baccount : bAccountDetailList){
                    newDescription = newDescription + '\t Nombre: ' + baccount.Name + '\n';
                    //newDescription = newDescription + '\t Número: ' + baccount.AccountNumber + '\n\n';
                }
            }
            
            if(cAccountDetailList.size() != 0){
                change = true;
                newDescription = newDescription + 'Consumer Accounts: \n\n';
        
                /*loop de business*/
                for(Account caccount : cAccountDetailList){
                    newDescription = newDescription + '\t Nombre: ' + caccount.Name + '\n';
                    //newDescription = newDescription + '\t Número: ' + caccount.AccountNumber + '\n\n';
                }      
            }
            System.debug(newDescription);
            //hago update del case
            
            if(change){
                c.description = newDescription;
                update c;
            }
        }catch(Exception e){
            System.debug('BodyCPMail:GetEmailBody -> exception: ' + e.getMessage());
        }
    }

    public static Set<String> getIds (String params){
        Set<String> ids = new Set<String>();
        String id = '';
        
        List<string> strings = params.split('},');
        
        for(String pos : strings){
            List<String> spplited = pos.split(',');
            
            for(String s : spplited){
                if(s.contains('Id=')){
                    id = s.substringAfter('=');
                }
                if(s.contains('vlcSelected=true')){
                    ids.add(id);
                }
            }
        }
        System.debug(ids);
        return ids;
    }

}