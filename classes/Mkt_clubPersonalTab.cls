global with sharing class Mkt_clubPersonalTab implements vlocity_cmt.VlocityOpenInterface{
    global mkt_clubPersonalTab() {}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        Boolean result = true; 

        try{
            if (methodName.equals('getAccountHeader')){
                getAccountHeader(inputMap,outMap);
            }
            else{
                result = false;
            }   
        } 
        catch(Exception e){
            System.debug('clubPersonalTab:AccountHeader -> exception: '+e);
            result = false;
        }
        return result;
    }
 
    public void getAccountHeader(Map<String, Object> inputMap, Map<String, Object> outMap){
        try{
            GP_adapter adapter = new GP_adapter();
            String accountId = (String) inputMap.get('ContextId');
            Set<Id> idSet = new Set<Id>();
            //Set<serviceAccountWrapper> memberSet = new Set<serviceAccountWrapper>();

            //Main Account Info
            Account acc = [SELECT Id, Name, PersonalClubCategory__c 
                                 FROM Account
                                WHERE Id = :accountId LIMIT 1];

            outMap.put('Name', acc.Name);
            outMap.put('PersonalClubCategory', acc.PersonalClubCategory__c);
            
            Map<String, Object> pointsResult = new Map<String, Object>();
            Map<String, Object> serviceAccounts = new Map<String, Object>();
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> memberData = new Map<String, Object>();
            memberData.put('titularID',acc.Id);
            memberData.put('suscriptorID','0');
            input.put('datosSocio',memberData);

            adapter.consultarPuntos(input, pointsResult);

            Map<String, Object> points = (Map<String, Object>)pointsResult.get('resultadoSaldoTotal');
            outMap.put('PersonalClubPoints', points.get('totalPuntosDisponibles'));

            //Service Accounts Info
            List<Map<String, Object>> membersList = (List<Map<String, Object>>)points.get('puntosxSocios');
            Integer puntosPorVencer = 0;
            for(Map<String, Object> member : membersList){
                idSet.add((String)member.get('idCuenta'));
                for(Object obj : (List<Object>)member.get('saldos')) {
                    Map<String, Object> saldosMap = (Map<String, Object>)obj;
                    if(Date.valueOf(saldosMap.get('fechaVto')) <= (Date.today().addDays(60))) {
                        puntosPorVencer += Integer.valueOf(((Map<String, Object>)obj).get('puntos'));
                    }
                }
            }

            outMap.put('puntosPorVencer', puntosPorVencer);

            List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :idSet];
            for(Account account: accounts){
                for(Map<String, Object> member : membersList){
                    if(account.Id == (String)member.get('idCuenta')){
                        if(account.Id == accountId){
                            member.put('Type','Titular');    
                        }
                        else{
                            member.put('Type','Usuario');   
                        }
                        member.put('Name',account.Name);
                        break;
                    }   
                }    
            }

            System.debug('membersList: ' + membersList);

            outMap.put('ServiceAccounts',membersList);
            
            //outMap.clear();
            //outMap.put('resultado',pointsResult);
        }catch(Exception e){
            System.debug('getAccountHeader:invokeMethod -> exception: '+e);
        }
    }
}