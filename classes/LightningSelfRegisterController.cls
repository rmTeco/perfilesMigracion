global without sharing class LightningSelfRegisterController {
    
    public LightningSelfRegisterController() { }
    
    @TestVisible 
    private static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }
    
    @TestVisible 
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
    
    @TestVisible 
    private static void validatePassword(User u, String password, String confirmPassword) {
        if(!Test.isRunningTest()) {
            Site.validatePassword(u, password, confirmPassword);
        }
        return;
    }
    
    @AuraEnabled
    public static OperationResponse selfRegister(String firstname ,String lastname, String email, String password, String confirmPassword, String accountId, String regConfirmUrl, String extraFields, String startUrl, Boolean includePassword, String contactId) {
        
        Savepoint sp = null; 
        try {
            sp = Database.setSavepoint();
            
            if (lastname == null || String.isEmpty(lastname)) {
                return new OperationResponse(false, '06', Label.Site.lastname_is_required);
            }
            
            if (email == null || String.isEmpty(email)) {
                return new OperationResponse(false, '06', Label.Site.email_is_required);
            }

            system.debug('selfRegister:' + contactId + ' - ' + firstname +' - ' +  lastname +' - ' +  email +' - ' +  password +' - ' +  confirmPassword +' - ' +  accountId +' - ' +  regConfirmUrl +' - ' +  extraFields +' - ' +  startUrl +' - ' +  includePassword);
            
            User u = new User();
            u.firstName = firstname;
            u.ProfileId = getCustomerCommunityProfile('Test Community');
            u.lastName = lastname;
            u.ContactId = contactId;
            u.Username = email;
            u.Email = email;
            u.put('Email',email);
            //u.CommunityNickname = 'nname';
            u.TimeZoneSidKey = 'America/Argentina/Buenos_Aires';
            u.LocaleSidKey = 'es';
            u.EmailEncodingKey = 'ISO-8859-1';
            u.LanguageLocaleKey = 'es';
            u.isActive = true;
            u.IsPortalSelfRegistered = true;
            
            //String networkId = Network.getNetworkId();
            
            // If using site to host the community the user should not hit s1 after logging in from mobile.
            //if(networkId != null && siteAsContainerEnabled(networkId)) {
            //u.put('UserPreferencesHideS1BrowserUI',true);
            //}
            
            String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0,1) : '' ) + lastname.substring(0,1);
            nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
            u.put('CommunityNickname', nickname);
            u.Alias = nickname;
            if (extraFields != null) {
                List<Object> extraFieldsList = (List<Object>) JSON.deserializeUntyped(extraFields);        
                for (Object thisFieldObject : extraFieldsList) {
                    Map<String,Object> thisField = (Map<String,Object>) thisFieldObject;
                    Schema.SObjectField sof = Schema.SObjectType.User.fields.getMap().get((String) thisField.get('fieldPath'));
                    u.put(sof, thisField.get('value'));
                }
            }
            
            if (includePassword) {    
                if (!isValidPassword(password, confirmPassword)) {
                    return new OperationResponse(false, '06', Label.site.passwords_dont_match);
                }
                validatePassword(u, password, confirmPassword);
            }
            else {
                password = null;
            }
            
            // lastName is a required field on user, but if it isn't specified, we'll default it to the username
            //String userId = Site.createPortalUser(u, accountId, password);
            String userId = '';
            
            try {
                insert u;
            } catch (DMLException dEx) {
                Database.rollback(sp);
                system.debug('Error: ' + dEx.getMessage());
                if (dEx.getMessage().contains('PORTAL_USER_ALREADY_EXISTS_FOR_CONTACT')) {
                    return new OperationResponse(false, '06', 'El usuario ya existe.');
                } else if (dEx.getMessage().contains('DUPLICATE_USERNAME')){
                    return new OperationResponse(false, '06', 'El nombre de usuario ya existe.');
                } else {
                    return new OperationResponse(false, '06', 'Error creando usuario. Contacte al administrador.');
                }
            }
            
            // create a fake userId for test.
            
            if (u.Id != null) { 
                ApexPages.PageReference confirmRef = new PageReference(regConfirmUrl);
                if(!Test.isRunningTest()) {
                    aura.redirect(confirmRef);
                }
            }
            return new OperationResponse(true, '05', 'Usuario Creado!.');
        }
        catch (Exception ex) {
            Database.rollback(sp);
            system.debug('Error: ' + ex.getMessage());
            return new OperationResponse(false, '06', 'Error creando usuario. Contacte al administrador.');
        }
    }
    
    /*@AuraEnabled
public static List<Map<String,Object>> getExtraFields(String extraFieldsFieldSet) { 
List<Map<String,Object>> extraFields = new List<Map<String,Object>>();
Schema.FieldSet fieldSet = Schema.SObjectType.User.fieldSets.getMap().get(extraFieldsFieldSet);
if(!Test.isRunningTest()) {
if (fieldSet != null) {
for (Schema.FieldSetMember f : fieldSet.getFields()) {
Map<String, Object> fieldDetail = new Map<String, Object>();
fieldDetail.put('dbRequired', f.getDBRequired());
fieldDetail.put('fieldPath', f.getFieldPath());
fieldDetail.put('label', f.getLabel());
fieldDetail.put('required', f.getRequired());
fieldDetail.put('type', f.getType());
fieldDetail.put('value', '');   // client will populate
extraFields.add(fieldDetail);
}}}
return extraFields;
}*/
    
    @AuraEnabled
    public static OperationResponse validateInfo(String documentNumber) {
        
        OperationResponse op;
        
        List<Contact> contactsList = searchContactByDocNumber(documentNumber);
        
        if (contactsList != null && contactsList.size() == 1) {
            //DNI existe
            op = searchUserByContact(contactsList.get(0).Id);
        } else if (contactsList != null && contactsList.size() > 1) {
            op = new OperationResponse(true, '04', 'Varios clientes con mismo DNI, contacte al administrador.');
        } else {
            op = new OperationResponse(true, '03', 'El <b>DNI</b> ingresado no ha sido encontrado.');
        }
        return op;
    }
    
    @TestVisible
    private static List<Contact> searchContactByDocNumber(String documentNumber) {
        List<Contact> contactsList = [SELECT Id, FirstName, LastName, AccountId 
                                      FROM Contact 
                                      WHERE DocumentType__c = 'DNI'
                                      AND DocumentNumber__c =: documentNumber];
        system.debug('Q: '+ contactsList + ' for ' + documentNumber);
        return contactsList;
    }

    @TestVisible
    private static List<Contact> searchContactByContactId(String contactId) {
        List<Contact> contactsList = [SELECT Id, FirstName, LastName, AccountId 
                                      FROM Contact 
                                      WHERE DocumentType__c = 'DNI'
                                      AND Id =: contactId];
        system.debug('Q: '+ contactsList + ' for ' + contactId);
        return contactsList;
    }
    
    @TestVisible
    private static OperationResponse searchUserByContact(Id contactId) {
        
        OperationResponse op;
        List<User> usersList = [SELECT Id 
                                FROM User 
                                WHERE Profile.Name = 'Test Community' 
                                AND ContactId =: contactId];
        system.debug('UserSearch: ' + usersList);
        if (usersList != null && usersList.size() == 1) {
            return new OperationResponse(true, '01', 'El <b>DNI</b> ya tiene usuario, seleccione <b>Olvidé mi contraseña</b>.');
        } else {
            op = new OperationResponse(true, '02', 'Ingrese <b>Correo Electrónico</b>.');
            op.contactId = contactId;
            return op;
        }
    }

    @AuraEnabled
    public static Boolean validateUsername(String email) {

        List<User> usersList = [SELECT Id 
                                FROM User 
                                WHERE Username =: email];

        system.debug('Username: ' + usersList);
        if (usersList.size() == 0) {
            return false;
        } else {
            return true;
        }
    }
    
    @AuraEnabled
    public static OperationResponse createUser(String documentNumber, String email, String regUrl) {
        
        try {
            system.debug('info: ' + documentNumber + ' + ' + email + ' + ' + regUrl);
            List<Contact> contactData = searchContactByDocNumber(documentNumber);
            
            return selfRegister(contactData[0].FirstName, contactData[0].LastName, email, null, null, contactData[0].AccountId, regUrl, null, null, false, contactData[0].Id);
        } catch (DMLException dEx) {
            system.debug(dEx);
            return new OperationResponse(false, '06', 'Error creando usuario');
        } catch (Exception ex) {
            system.debug(ex);
            return new OperationResponse(false, '06', 'Error creando usuario');
        }
    }

    @AuraEnabled
    public static OperationResponse createUserByContactId(String contactId, String email, String regUrl) {
        
        try {
            system.debug('createUserByContactId: ' + contactId + ' + ' + email + ' + ' + regUrl);
            List<Contact> contactData = searchContactByContactId(contactId);
            
            return selfRegister(contactData[0].FirstName, contactData[0].LastName, email, null, null, contactData[0].AccountId, regUrl, null, null, false, contactData[0].Id);
        } catch (DMLException dEx) {
            system.debug(dEx);
            return new OperationResponse(false, '06', 'Error creando usuario');
        } catch (Exception ex) {
            system.debug(ex);
            return new OperationResponse(false, '06', 'Error creando usuario');
        }
    }
    
    public static Boolean emailValidation(String email) {
        try {
            SaleManager sm = new SaleManager();
            
            Map<String,Object> options = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> inputMap = new Map<String,Object>();
            
            options.put('FieldEmail', email);
            
            sm.invokeMethod('ValidateEmailSettings', inputMap, outMap, options);
            
            system.debug('Response: ' + outMap.get('options'));
            
            return true;
        } catch (Exception ex) {
            system.debug(ex);
            return false;
        }
    }
    
    private static Id getCustomerCommunityProfile(String profileName) {
        Id profileId = [SELECT Id FROM Profile WHERE Name =: profileName].Id;
        return profileId;
    }
    
    global class OperationResponse {
        // Error Codes
        /*
* 00 - Error General
* 01 - Recuperar Password
* 02 - Cliente existe - No tiene usuario
* 03 - Cliente No existe
* 04 - Varios clientes con mismo DNI
* 05 - Usuario creado
* 06 - Error creando usuario
*/
        @AuraEnabled global Boolean success = false;
        @AuraEnabled global String code = '';
        @AuraEnabled global String message = '';
        @AuraEnabled global String contactId = '';
        OperationResponse(Boolean succes, String code, String message){
            this.success = success;
            this.code = code;
            this.message = message;
        }
    }
    
    @TestVisible
    private static Auth.AuthConfiguration getAuthConfig(){
        Id networkId = Network.getNetworkId();
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(networkId,'');
        return authConfig;
    }
    
    @AuraEnabled
    public static String getForgotPasswordUrl() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getForgotPasswordUrl();
    }
}