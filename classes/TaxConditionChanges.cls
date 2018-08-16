global with sharing class TaxConditionChanges implements vlocity_cmt.VlocityOpenInterface {
    global TaxConditionChanges() {

    }
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;

        try {
            if (methodName.equals('Save')) {
                Save(inputMap, outMap, options);
            }
            if (methodName.equals('PopulateIIBBExemptionsAllProvinces')) {
                PopulateIIBBExemptionsAllProvinces(options);
            }
        } 
        catch (Exception ex) {
            //System.debug('exception: ' + ex.getMessage());
            outMap.put('error', ex.getMessage());
        }
        return result;
    }

    public void Save(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            String taxConditionToModify = GetTaxConditionToModify(inputMap);
            //System.debug('taxConditionToModify: ' + taxConditionToModify);
            system.debug('inputMap = '+ inputMap);
            Map<String, Object> consumerAccount = GetAccountByRecordType(inputMap, 'Consumer');
            Map<String, Object> businessAccount = GetAccountByRecordType(inputMap, 'Business');

            if (taxConditionToModify == 'DNI') {
                if (businessAccount == null) {
                    CreateAccount(inputMap, 'Business', consumerAccount, outMap);
                }
                else {
                    Id businessAccountId = (Id)businessAccount.get('Id');
                    Account objBusinessAccount = [SELECT Id, vlocity_cmt__Status__c FROM Account WHERE Id = :businessAccountId];

                    ReasignBillingAccounts(consumerAccount, objBusinessAccount);
                }
            }
            else if (taxConditionToModify == 'CUIT') {
                if (consumerAccount == null) {
                    CreateAccount(inputMap, 'Consumer', businessAccount, outMap);
                }
                else {
                    Id consumerAccountId = (Id)consumerAccount.get('Id');
                    Account objConsumerAccount = [SELECT Id, vlocity_cmt__Status__c FROM Account WHERE Id = :consumerAccountId];

                    ReasignBillingAccounts(businessAccount, objConsumerAccount);
                }
            }
        }
        catch (Exception ex) {
            System.debug('exception: ' + ex.getMessage());
        }
    }

    private String GetTaxConditionToModify(Map<String, Object> inputMap) {
        try {
            Map<String, Object> taxConditionToModify = (Map<String, Object>)inputMap.get('Step_2_Select_Tax_Condition_To_Modify');
            Map<String, Object> taxConditionBlock = (Map<String, Object>)taxConditionToModify.get('TaxConditionBlock');
            String taxConditionChange = (String)taxConditionBlock.get('TaxConditionChange');

            return taxConditionChange;
        }
        catch (Exception ex) {
             //System.debug('exception: ' + ex.getMessage());
             return '';
        }
    }

    private Map<String, Object> GetAccountByRecordType(Map<String, Object> inputMap, String recordType) {
        try {
            
            Map<String, Object> contact = (Map<String, Object>)inputMap.get('Contact');

            System.debug('contact: ' + contact);
            System.debug('recordType: ' + recordType);

            Map<String, Object> accountByRecordType = (Map<String, Object>)contact.get(recordType);

            System.debug('accountByRecordType: ' + accountByRecordType);

            Map<String, Object> account = (Map<String, Object>)accountByRecordType.get('Account');

            System.debug('account: ' + account);

            return account;
        }
        catch (Exception ex) {
             System.debug('exception: ' + ex.getMessage());
             return null; 
        }
    }

    private List<Object> GetBillingAccounts(Map<String, Object> account) {
        try {
            Object billingAccounts = account.get('BillingAccounts');

            if (billingAccounts instanceof List<Object>) { 
                return (List<Object>)billingAccounts;
            }
            else {
                List<Object> billingAccountsList = new List<Object>();
                Map<String, Object> billingAccount = (Map<String, Object>) account.get('BillingAccounts');
                
                if (billingAccount != null) {
                    billingAccountsList.add(billingAccount);

                    return billingAccountsList;
                }

                return null;
            }
        }
        catch (Exception ex) {
             System.debug('exception: ' + ex.getMessage());
             return null;
        }
    }

    private void CreateAccount(Map<String,Object> inputMap, String accountType, Map<String, Object> account, Map<String, Object> outMap) {
        try {
            Id accountId = (Id)account.get('Id');

            System.debug('accountType: ' + accountType);

            DescribeSObjectResult describeResult = accountId.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());

            String query = ' SELECT ' + String.join(fieldNames, ', ') + ' FROM ' + describeResult.getName() + ' WHERE ' + ' id = :accountId ' + ' LIMIT 1 ';    
            
            Account objAccount = Database.query(query);
            System.debug('objAccount: ' + objAccount);
            Account objNewAccount = objAccount.clone(false, false, false, false);

            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(accountType).getRecordTypeId();
            System.debug('recordTypeId: ' + recordTypeId);

            objNewAccount.RecordTypeId = recordTypeId;
            
            if (accountType == 'Business') {
                objNewAccount.Name = 'New Business Account';
                objNewAccount.DocumentType__c = 'CUIT';
                objNewAccount.DocumentNumber__c = GetDocumentNumber(inputMap);
            }
            else {
                objNewAccount.Name = 'New Consumer Account';
                objNewAccount.DocumentType__c = '';
                objNewAccount.DocumentNumber__c = '';
            }

            System.debug('objNewAccount: ' + objNewAccount);

            insert objNewAccount;
            
            System.debug('objNewAccount.Id: ' + objNewAccount.Id);

            outMap.put('NewAccountId', objNewAccount.Id);

            ReasignBillingAccounts(account, objNewAccount);
        }
        catch (Exception ex) {
            //System.debug('exception: ' + ex.getMessage());
            throw new FuncException('Error al crear cuenta: ' + ex.getMessage());
        }
    }

    private String GetDocumentNumber(Map<String,Object> inputMap) {
        try {
            Map<String, Object> summary = (Map<String, Object>)inputMap.get('Step_8_Summary');
            String newDocumentNumber = (String)summary.get('NewDocumentNumber');

            return newDocumentNumber;
        }
        catch (Exception ex) {
             System.debug('exception: ' + ex.getMessage());
             return '';
        }
    }

    private void ReasignBillingAccounts(Map<String, Object> account, Account accountTo) {
        try {
            List<Account> billingAccountsToUpdate = new List<Account>();
            List<Id> selectedBillingAccounts = GetBillingAccountsToReasign(account);

            if (selectedBillingAccounts != null && !selectedBillingAccounts.isEmpty()) {
                for(Id accountId : selectedBillingAccounts) {
                    billingAccountsToUpdate.add(new Account(Id=accountId, ParentId=accountTo.Id));
                }
            }
            if(billingAccountsToUpdate.size() > 0){
                System.debug('billingAccountsToUpdate: ' + billingAccountsToUpdate);
                update billingAccountsToUpdate;

                if(accountTo.vlocity_cmt__Status__c == 'Disponible'){
                    accountTo.vlocity_cmt__Status__c = 'Active';
                    update accountTo;
                }
            }

            Id prevAccountId = (Id)account.get('Id');
            List<Account> activeAccountsLeft = [SELECT Id FROM Account WHERE ParentId = :prevAccountId];
            if(activeAccountsLeft.size() == 0) {
                Account prevAccount = new Account(Id=prevAccountId, vlocity_cmt__Status__c= 'Disponible');
                update prevAccount;
            }

        }
        catch (Exception ex) {
             System.debug('exception: ' + ex.getMessage());
        }
    }

    private List<Id> GetBillingAccountsToReasign(Map<String, Object> account) {
        try {
            List<Id> selectedBillingAccounts = new List<Id>();
            List<Object> billingAccounts = GetBillingAccounts(account);

            System.debug('billingAccountsToReasign: ' + billingAccounts);

            if (billingAccounts != null && !billingAccounts.isEmpty()) {
                for (Object billingAccount : billingAccounts) {

                    Map<String, Object> objBilling = (Map<String, Object>) billingAccount;

                    Boolean billingAccountIsSelected = (Boolean) objBilling.get('selected');

                    System.debug('billingAccountIsSelected: ' + billingAccountIsSelected);

                    if (billingAccountIsSelected != null && billingAccountIsSelected) {
                        Id billingAccountId = (Id) objBilling.get('Id');
                        selectedBillingAccounts.add(billingAccountId);
                    }
                }
            }

            System.debug('selectedBillingAccounts: ' + selectedBillingAccounts);

            return selectedBillingAccounts;
        }
        catch (Exception ex) {
             System.debug('exception: ' + ex.getMessage());
             return null;
        }
    }

    private void PopulateIIBBExemptionsAllProvinces(Map<String, Object> options) {
        try {
            Schema.DescribeFieldResult fieldResult = TaxConditionDetail__c.Jurisdiction__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            String idTaxCondition = (String) options.get('DRId_TaxCondition__c');

            List<TaxConditionDetail__c> taxConDetList = new List<TaxConditionDetail__c>();
            for(Schema.PicklistEntry p : ple) {
                taxConDetList.add(new TaxConditionDetail__c(TaxCondition__c = idTaxCondition,
                                                            Type__c = 'Ex IIBB', 
                                                            Category__c = 'IIBB_ENA', 
                                                            Jurisdiction__c = p.getLabel(),
                                                            Percentage__c = 100,
                                                            DateFrom__c = Date.today() ));
            }

            insert taxConDetList;
        }
        catch (Exception ex) {
            //System.debug(ex.getMessage());
            throw new FuncException('Error en PopulateIIBBExemptionsAllProvinces: ' + ex.getMessage());
        }
    }
}