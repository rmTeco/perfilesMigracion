public class LoyaltyTransactionTriggers {

	/**
     * @Author: Julia Carranza
     * @Description: Method to send a Text Message after Club Member Cancellation.
     */
    public static void sendSMSAfterTransactionReverted() {

    	//cuando Reverted__c = true 
    	//recuperar account
    	//si ContactPreferencePhone__c = sms 9multipicklist
    	//codigo de sms 
    	//label = se te devolvieron tantos $puntos$

        //Identificar las transacciones que han sido revertidas.
        Set<Id> setTransactionId = new Set<Id>();
        Set<Id> setAccountId = new Set<Id>();
        Map<Id, LoyaltyTransaction__c> accountsOldMap = (Map<Id, LoyaltyTransaction__c>)Trigger.OldMap;
        List<LoyaltyTransaction__c> lTransactions = new List<LoyaltyTransaction__c>();
        for(LoyaltyTransaction__c tNew : (List<LoyaltyTransaction__c>)Trigger.new){
            if(tNew.Reverted__c == false && accountsOldMap.get(tNew.Id).Reverted__c == true){
                lTransactions.add(tNew);
                setTransactionId.add(tNew.Id);
            }
        }

        //Mapa de Account Id y Lista de Transacciones Revertidas.
        Map<Id, List<LoyaltyTransaction__c>> accountIdToTransactionMap = new Map<Id, List<LoyaltyTransaction__c>>();
        List<LoyaltyTransaction__c> tList = [SELECT Id, Reverted__c, Points__c, LoyaltyAccount__c FROM LoyaltyTransaction__c 
                            WHERE LoyaltyAccount__c IN :setTransactionId];
        for (LoyaltyTransaction__c t : tList) {
            Id accId = t.LoyaltyAccount__c;
            setAccountId.add(accId);
            if(accId != Null){
                List<LoyaltyTransaction__c> listTransactions = accountIdToTransactionMap.get(accId);
                if(listTransactions == null){
                    listTransactions = new List<LoyaltyTransaction__c>();
                }
                listTransactions.add(t);
                accountIdToTransactionMap.put(accId, listTransactions);
            }
        }

        //Lista de cuentas relaciones a las transacciones mapeadas.
        List<Account> aList = [SELECT Id, vlocity_cmt__ContactPreferences__c, Phone FROM Account 
                            WHERE Id IN :setAccountId];

        //Validaciones para el envio del SMS al usuario.
        for (Account a : aList){
            String multiPicklist = a.vlocity_cmt__ContactPreferences__c;
            if(multiPicklist.contains('SMS')){

                List<LoyaltyTransaction__c> listTransactions = accountIdToTransactionMap.get(a.Id);
                Decimal points = 0;
                for (LoyaltyTransaction__c t : listTransactions) {
                    points += t.Points__c;
                }

                String cellnumber = a.Phone;
                String text = System.Label.SMSTransactionRevertion;
                String totalPoints = String.valueOf(points);
                String textComplete = text.replace('$puntos$', totalPoints);
                String body = '{"body": {"request": {"Target": {"User": {"Celnumber": "'+ cellnumber +'"}}},"communicationText": "'+ textComplete +'"}}';

                System.debug('textComplete: ' + textComplete);

                Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(body);
                Map<String, Object> output = new Map<String, Object>();
                Map<String, Object> options2 = new Map<String, Object>();
                vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                integProcServ.invokeMethod('IFS_S159', input, output, options2);

            }  
        }
    }
}