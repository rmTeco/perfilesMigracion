public class ContactTriggerHandler {
    public static void OnBeforeUpdate(List<Contact> contactsToUpdate) {
        for (Contact contactToUpdate : contactsToUpdate) {
            CapitalizeFullName(contactToUpdate);
        }
    }

    public static void OnBeforeInsert(List<Contact> contactsToInsert) {
        for (Contact contactToInsert : contactsToInsert) {
            CapitalizeFullName(contactToInsert);
        }
    }

    private static void CapitalizeFullName(Contact contact) {
        if (contact.FirstName != null)
            contact.FirstName = contact.FirstName.capitalize();
            
        if (contact.LastName != null)
            contact.LastName = contact.LastName.capitalize();
    }

    /**
     * @Author: Julia Carranza
     * @Description: Method to check all the attributes and put the most important in the Attribute field.
     */
    public static void contactAttributesWeighingValidation(){
        List<AttributesWeighing__c> awList = [SELECT Attribute__c, Object__c, Weighing__c FROM AttributesWeighing__c WHERE Object__c = :Label.Contact];
        //INSERT
        if(Trigger.isInsert){
            for(Contact c : (List<Contact>)Trigger.new){
                if(c.Attributes__c != Null){
                    Set<String> currentAttributes = new Set<String>(c.Attributes__c.split(';'));
                    Decimal currentWeighing = 0;
                    String currentAttribute = '';
                    for(AttributesWeighing__c aw : awList){
                        if(currentAttributes.contains(aw.Attribute__c)){
                            if(aw.Weighing__c > currentWeighing){
                                currentWeighing = aw.Weighing__c;
                                currentAttribute = aw.Attribute__c;
                            }
                        } 
                    }
                    c.Attribute__c = currentAttribute;
                }
            }
        }
        //UPDATE
        if(Trigger.isUpdate){
            //Contact Set Ids identifying which of them had their attributes changed.
            Map<Id, Contact> ContactsOldMap = (Map<Id, Contact>)Trigger.OldMap;
            Set<Id> setContactId = new Set<Id>();
            for(Contact ContactNew : (List<Contact>)Trigger.new){
                if(ContactNew.Attributes__c != ContactsOldMap.get(ContactNew.Id).Attributes__c){
                    setContactId.add(ContactNew.Id);
                }
            }
            for(Id contactId : setContactId){
                Contact currentContact = (Contact)(Trigger.newMap.get(contactId));
                if(currentContact.Attributes__c != Null){
                    Set<String> currentAttributes = new Set<String>(currentContact.Attributes__c.split(';'));
                    Decimal currentWeighing = 0;
                    String currentAttribute = '';
                    for(AttributesWeighing__c aw : awList){
                        if(currentAttributes.contains(aw.Attribute__c)){
                            if(aw.Weighing__c > currentWeighing){
                                currentWeighing = aw.Weighing__c;
                                currentAttribute = aw.Attribute__c;
                            }
                        } 
                    }
                    currentContact.Attribute__c = currentAttribute;
                } else {
                    currentContact.Attribute__c = Null;
                }
            }
        }
    }

    /**
     * @Author: Julia Carranza
     * @Description: Method to empty the Contact Attribute Field once it's attributes are deleted.
     * Not used at the moment.
     */
    /*public static void updateAttributeAccountField(){

        Map<Id, Contact> ContactsOldMap = (Map<Id, Contact>)Trigger.OldMap;
        Set<Id> setContactId = new Set<Id>();
        for(Contact ContactNew : (List<Contact>)Trigger.new){
            if(ContactNew.Attributes__c != ContactsOldMap.get(ContactNew.Id).Attributes__c){
                setContactId.add(ContactNew.Id);
            }
        }

        Map<Id, List<Account>> contactIdToAccountsMap = new Map<Id, List<Account>>();
        //Map(Contact - Accounts).
        List<Account> aList = [SELECT Id, Attributes__c, Attribute__c, vlocity_cmt__PrimaryContactId__c from Account WHERE vlocity_cmt__PrimaryContactId__c IN :setContactId];
        for (Account a : aList) {
            Id contactId = a.vlocity_cmt__PrimaryContactId__c;
            if(contactId != Null){
                List<Account> listAccounts = contactIdToAccountsMap.get(contactId);
                if(listAccounts == null){
                    listAccounts = new List<Account>();
                }
                listAccounts.add(a);
                contactIdToAccountsMap.put(contactId, listAccounts);
            }
        }

        List<Account> accountsToUpdate = new List<Account>(); 
        for(Id contactId : setContactId){
            Contact currentContact = (Contact)(Trigger.newMap.get(contactId));
            if(contactIdToAccountsMap.get(contactId) != Null){
                List<Account> currentAccountList = contactIdToAccountsMap.get(contactId);
                for(Account a : currentAccountList){
                    if(currentContact.Attribute__c == ('Estratégico')){
                        System.debug('Estratégico.');
                        a.Attribute__c = 'Estratégico';
					}
					if(currentContact.Attribute__c == ('Socio Club')){
                        a.Attribute__c = 'Socio Club';
					}
                    if(currentContact.Attribute__c == Null){
                        a.Attribute__c = '';
                    }           
                    system.debug(a.Attributes__c);
                    accountsToUpdate.add(a);
                }
            } 
        }
        System.debug('ACCOUNT LIST: ' + accountsToUpdate);
        update accountsToUpdate;
    }*/
}