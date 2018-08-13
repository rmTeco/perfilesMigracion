/**
 * An apex page controller that exposes the change password functionality
 */
public with sharing class ChangePasswordController {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}
    public boolean passwordChanged {get; set;}
    
    public ChangePasswordController() { 
        passwordChanged = false;
    }    
    
    public PageReference changePassword() {
        if((Site.isPasswordExpired() || (!Site.isPasswordExpired() && String.isNotBlank(oldpassword))) && String.isNotBlank(verifyNewPassword) && String.isNotBlank(newPassword)){
            PageReference pageRef = Site.changePassword(newPassword, verifyNewPassword, oldpassword);
            passwordChanged = !ApexPages.hasMessages();
            
            return null;
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Debe completar todos los campos.'));
        return null;
    }     
    public pageReference home() {
        return new PageReference(Site.getBaseUrl());
    }
}