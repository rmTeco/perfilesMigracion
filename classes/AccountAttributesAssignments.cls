global with sharing class AccountAttributesAssignments  implements vlocity_cmt.VlocityOpenInterface{

    //Class used in Vlocity Card ta-Care-console-sidebar / taSegmentAccount
    global AccountAttributesAssignments(){}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        Boolean result = true; 

        try{
            if (methodName.equals('getAccountAttributes')){
                getAccountAttributes(inputMap,outMap);
            }
            else{
                result = false;
            }   
        } 
        catch(Exception e){
            System.debug('invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    static public void getAccountAttributes(Map<String, Object> inputMap, Map<String, Object> outMap){

        Set<String> currentAccAttributes = new Set<String>();
        Set<String> currentConAttributes = new Set<String>();
        String accountId = (String) inputMap.get('ContextId');

        List<Account> account = [SELECT Id, vlocity_cmt__PrimaryContactId__c, SegmentLevel1__c, SegmentLevel2__c, Attributes__c 
                                    FROM Account WHERE Id = :accountId];

        if(!account.isEmpty()){

            outMap.put('Account', account[0]);
            Account acc = account[0];
            if(acc.Attributes__c != Null){
                System.debug('currentAccAttributes sin TRIM: ' + acc.Attributes__c);
                currentAccAttributes = new Set<String>(acc.Attributes__c.split(';'));
            }
            List<AttributesWeighing__c> weighings = [SELECT Object__c, Attribute__c, Weighing__c FROM AttributesWeighing__c
                                                       ORDER BY Weighing__c DESC];

            List<Contact> contact = [SELECT Id, Attributes__c FROM Contact 
                                      WHERE Id = :account[0].vlocity_cmt__PrimaryContactId__c];
            Contact con = contact[0];
            if(con.Attributes__c != Null){
                currentConAttributes = new Set<String>(con.Attributes__c.split(';'));
            }

            System.debug('currentAccAttributes: ' + currentAccAttributes);
            System.debug('currentConAttributes: ' + currentConAttributes);

            String attributes = '';
            String result;
            if(!weighings.isEmpty()){
                for(AttributesWeighing__c aw : weighings){
                    result = Null;
                    if(aw.Object__c == 'Account'){
                        System.debug('Account aw.Attribute__c: ' + aw.Attribute__c);
                        if(currentAccAttributes.contains(aw.Attribute__c)){
                            result = aw.Attribute__c;
                            System.debug('Account result: ' + result);
                        }
                    }
                    if(aw.Object__c == 'Contact'){
                        if(!contact.isEmpty()){
                            System.debug('Contact aw.Attribute__c: ' + aw.Attribute__c);
                            if(currentConAttributes.contains(aw.Attribute__c)){
                                result = aw.Attribute__c;
                                System.debug('Contact result: ' + result);
                            }
                        }
                    }
                    if(result != Null){ 
                        if(attributes == ''){
                            attributes = aw.Attribute__c;
                        }else{
                            attributes = (attributes + ', '+ aw.Attribute__c);
                        }
                    }
                }
                System.debug('Final Attributes: ' + Attributes);
                outMap.put('Attributes', attributes);    
            }
        }
    }
}