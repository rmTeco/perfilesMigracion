public class AttributesUsage {

    /**
     * @Author: Julia Carranza
     * @Description: Method to check the attributes for Account and Contact.
     */
    public static void checkObjectAttributesRules() {

        List<SObject> incomingList = (List<SObject>)Trigger.new;
        Boolean accountType = incomingList[0] instanceof Account;
        Boolean contactType = incomingList[0] instanceof Contact;

        Boolean attribute1 = false;
        Boolean attribute2 = false;

        Set<Id> setAccountId = new Set<Id>();
        Set<Id> setContactId = new Set<Id>();

        String objectType = '';

        //Contact and Account Set Ids identifying which of them had their attributes changed.
        if(Trigger.isUpdate){
            if(accountType){
                Map<Id, Account> accountsOldMap = (Map<Id, Account>)Trigger.OldMap;
                for(Account accountNew : (List<Account>)Trigger.new){
                    if(accountNew.Attributes__c != accountsOldMap.get(accountNew.Id).Attributes__c){
                        setAccountId.add(accountNew.Id);
                    }
                }
            }

            if(contactType){
                Map<Id, Contact> contactsOldMap = (Map<Id, Contact>)Trigger.OldMap;
                for(Contact contactNew : (List<Contact>)Trigger.new){
                    if(contactNew.Attributes__c != contactsOldMap.get(contactNew.Id).Attributes__c){
                        setContactId.add(contactNew.Id);
                    }
                }
            }
        }
        
        //Contact and Account Attributes Rule Validations.
        if(accountType){
            objectType = 'Account';
        } else if (contactType){ 
            objectType = 'Contact';
        }
        List<AttributesRules__c> arList = [SELECT Attribute1__c, Attribute2__c, Object__c FROM AttributesRules__c WHERE Object__c = :objectType];

        if(Trigger.isInsert){
            if(accountType){
                for (Account a : (List<Account>)Trigger.new) {
                    if(a.Attributes__c != Null){
                        Set<String> currentAttributes = new Set<String>(a.Attributes__c.split(';'));
                        for(AttributesRules__c rule : arList){
                            if(currentAttributes.contains(rule.Attribute1__c)){
                                attribute1 = true;
                            }
                            if(currentAttributes.contains(rule.Attribute2__c)){
                                attribute2 = true;

                            }
                            if(attribute1 && attribute2){                
                                a.addError(label.AttributeError);
                            } else {
                                attribute1 = false;
                                attribute2 = false;
                            }
                        }
                    }
                }
            }
            if(contactType){
                for (Contact c : (List<Contact>)Trigger.new) {             
                    if(c.Attributes__c != Null){
                        Set<String> currentAttributes = new Set<String>(c.Attributes__c.split(';'));
                        for(AttributesRules__c rule : arList){
                            if(currentAttributes.contains(rule.Attribute1__c)){
                                attribute1 = true;
                            }
                            if(currentAttributes.contains(rule.Attribute2__c)){
                                attribute2 = true;
                            }
                            if(attribute1 && attribute2){   
                                c.addError(label.AttributeError);
                            } else {
                                attribute1 = false;
                                attribute2 = false;
                            }
                        }
                    }
                }
            }

        } else if(Trigger.isUpdate){
            if(accountType){
                List<Account> accountList = new List<Account>();

                for (Id accountId : setAccountId) {
                    Account currentAccount = (Account)(Trigger.newMap.get(accountId));
                    if(currentAccount.Attributes__c != Null){
                        Set<String> currentAttributes = new Set<String>(currentAccount.Attributes__c.split(';'));
                    
                        for(AttributesRules__c rule : arList){
                            if(currentAttributes.contains(rule.Attribute1__c)){
                                attribute1 = true;
                            }
                            if(currentAttributes.contains(rule.Attribute2__c)){
                                attribute2 = true;
                            }
                            if(attribute1 && attribute2){              
                                Trigger.newMap.get(accountId).addError(label.AttributeError);
                            } else {
                                attribute1 = false;
                                attribute2 = false;
                            }
                        }
                    }
                }
            }

            if(contactType){
                List<Contact> contactList = new List<Contact>();

                for (Id contactId : setContactId) {
                    Contact currentContact = (Contact)(Trigger.newMap.get(contactId));
                    if(currentContact.Attributes__c != Null){
                        Set<String> currentAttributes = new Set<String>(currentContact.Attributes__c.split(';'));
                    
                        for(AttributesRules__c rule : arList){
                            if(currentAttributes.contains(rule.Attribute1__c)){
                                attribute1 = true;
                            }
                            if(currentAttributes.contains(rule.Attribute2__c)){
                                attribute2 = true;
                            }
                            if(attribute1 && attribute2){
                                Trigger.newMap.get(contactId).addError(label.AttributeError);
                            } else {
                                attribute1 = false;
                                attribute2 = false;
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     * @Author: Julia Carranza
     * @Description: Method to check if the attributes can be edited depending on the user profile.
     */
    public static void checkObjectAttributesProfilePermissions(){
        List<SObject> incomingList = (List<SObject>)Trigger.new;
        Boolean accountType = incomingList[0] instanceof Account;
        Boolean contactType = incomingList[0] instanceof Contact;

        Boolean attribute1 = false;
        Boolean attribute2 = false;

        Set<Id> setAccountId = new Set<Id>();
        Set<Id> setContactId = new Set<Id>();

        String objectType = '';
        Id profileId = userinfo.getProfileId();
        AttributesByProfile__c ar = AttributesByProfile__c.getInstance(profileId);

        //INSERT
        if(Trigger.isInsert){
            if(accountType){
                for(Account a : (List<Account>)Trigger.new){
                    if(a.Attributes__c != Null){
                        Set<String> currentAttributes = new Set<String>(a.Attributes__c.split(';'));
                        Set<String> permitedAttributes = new Set<String>();
                        if(ar.AccountAttributes__c != Null){
                            permitedAttributes = new Set<String>(ar.AccountAttributes__c.split('; '));
                        }
                        for(String s : currentAttributes){
                            if(!permitedAttributes.contains(s)){
                                a.addError(label.AttributeProfilePermissionError);
                            }
                        }
                    }
                }
            }
            if(contactType){
                for(Contact c : (List<Contact>)Trigger.new){
                    if(c.Attributes__c != Null){
                        Set<String> currentAttributes = new Set<String>(c.Attributes__c.split(';'));
                        Set<String> permitedAttributes = new Set<String>();
                        if(ar.AccountAttributes__c != Null){
                            permitedAttributes = new Set<String>(ar.ContactAttributes__c.split('; '));
                        }

                        for(String s : currentAttributes){
                            if(!permitedAttributes.contains(s)){
                                c.addError(label.AttributeProfilePermissionError);
                            }
                        }
                    }
                }
            }
        }
        //UPDATE
        else if(Trigger.isUpdate){
            if(accountType){
                Map<Id, Account> accountsOldMap = (Map<Id, Account>)Trigger.OldMap;
                for(Account accountNew : (List<Account>)Trigger.new){
                    if(accountNew.Attributes__c != accountsOldMap.get(accountNew.Id).Attributes__c){
                        setAccountId.add(accountNew.Id);
                    }
                }

                for (Id accountId : setAccountId) {
                    Account currentAccount = (Account)(Trigger.newMap.get(accountId));
                    Account oldAccount = accountsOldMap.get(accountId);
                    Set<String> currentAttributes = new Set<String>();
                    Set<String> oldAttributes = new Set<String>();
                    if(currentAccount.Attributes__c != Null){
                        currentAttributes = new Set<String>(currentAccount.Attributes__c.split(';'));
                    }
                    if(oldAccount.Attributes__c != Null){
                        oldAttributes = new Set<String>(oldAccount.Attributes__c.split(';'));
                    }
                    Set<String> permitedAttributes = new Set<String>(ar.AccountAttributes__c.split('; '));
                    Set<String> editedAttributes = new Set<String>();

                    if(currentAttributes != Null){
                        for(String sNew : currentAttributes){
                            if(!oldAttributes.contains(sNew)){
                                editedAttributes.add(sNew);
                            }
                        }
                    }

                    if(oldAttributes != Null){
                        for(String sOld : oldAttributes){
                            if(!currentAttributes.contains(sOld)){
                                editedAttributes.add(sOld);
                            }
                        }
                    }

                    for(String sEdited : editedAttributes){
                        if(!permitedAttributes.contains(sEdited)){
                            currentAccount.addError(label.AttributeProfilePermissionError);
                        }
                    }
                }
            }
            if(contactType){
                Map<Id, Contact> contactsOldMap = (Map<Id, Contact>)Trigger.OldMap;
                for(Contact contactNew : (List<Contact>)Trigger.new){
                    if(contactNew.Attributes__c != contactsOldMap.get(contactNew.Id).Attributes__c){
                        setContactId.add(contactNew.Id);
                    }
                }

                for (Id contactId : setContactId) {
                    Contact currentContact = (Contact)(Trigger.newMap.get(contactId));
                    Contact oldContact = contactsOldMap.get(contactId);
                    Set<String> currentAttributes = new Set<String>();
                    Set<String> oldAttributes = new Set<String>();
                    
                    if(currentContact.Attributes__c != Null){
                        currentAttributes = new Set<String>(currentContact.Attributes__c.split(';'));
                    }
                    if(oldContact.Attributes__c != Null){
                        oldAttributes = new Set<String>(oldContact.Attributes__c.split(';'));
                    }

                    System.debug('CUSTOMSETTING: ' + ar);
                    System.debug('CUSTOMSETTING.AccountAttributes__c: ' + ar.AccountAttributes__c);
                    Set<String> permitedAttributes = new Set<String>();
                    if(ar.ContactAttributes__c != Null){
                        permitedAttributes = new Set<String>(ar.ContactAttributes__c.split('; '));
                    }
                    Set<String> editedAttributes = new Set<String>();

                    System.debug('currentAttributes: ' + currentAttributes);
                    if(currentAttributes != Null){
                        for(String sNew : currentAttributes){
                            if(!oldAttributes.contains(sNew)){
                                editedAttributes.add(sNew);
                            }
                        }
                    }

                    if(oldAttributes != Null){
                        for(String sOld : oldAttributes){
                            if(!currentAttributes.contains(sOld)){
                                editedAttributes.add(sOld);
                            }
                        }
                    }

                    for(String sEdited : editedAttributes){
                        System.debug('EDITADOS LISTA: ' + editedAttributes);
                        System.debug('EDITADOR ITERADO: ' + sEdited);
                        if(!permitedAttributes.contains(sEdited)){
                            currentContact.addError(label.AttributeProfilePermissionError);
                        }
                    }
                }
            }
        }
    }
}