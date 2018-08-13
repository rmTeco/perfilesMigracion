global with sharing class ManagePaymentMethods implements vlocity_cmt.VlocityOpenInterface{

   global ManagePaymentMethods (){}

   global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) 
   {

    System.debug('input: ' + input.get('PaymentId'));
    System.debug('options' + options);
    System.debug('input: ' + outMap.get('error'));
    Boolean result = true;
      try {

         if (methodName.equals('updateStatusCard')) {

           result = updateStatusCard(input, outMap, options);

           if(!result)
           {
            throw new DefaultOmniEditObjectException('Este medio de pago se encuentra actualmente en uso en un pago automatico y no se puede eliminar.');
           }
         }

         if (methodName.equals('getAccountId')) {
           getAccountId(input, outMap, options);
         }

         return result;

      }
      catch(Exception e) {
         System.debug('ManagePaymentMethods: invokeMethod -> exception: '+e);
         throw e;
      }
      
   }

   @RemoteAction
   global static Boolean updateStatusCard(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
   {    
      
     try{
          vlocity_cmt__PaymentMethod__c paymentMethodToUpdate = new vlocity_cmt__PaymentMethod__c();
          paymentMethodToUpdate.Id = (String) input.get('PaymentId');
          paymentMethodToUpdate.vlocity_cmt__IsActive__c = false;
          update paymentMethodToUpdate;
        }
        catch(DmlException e)
        {
          return false;
          //System.debug('Error An unexpected error has occurred: ' + e.getMessage());
          //throw e;
        } 
      return true;
   }

   public void getAccountId(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
    Id billingAccountId;

     Map<String, Object> automaticDebitAction = (Map<String, Object>)input.get('AutomaticDebitAction');
    String selectedAutomaticDebitAction = (String)automaticDebitAction.get('SelectedAutomaticDebitAction');
           
  if (selectedAutomaticDebitAction == 'Update') {
    billingAccountId = (Id)input.get('BillingAccountToResponse');
  }
  else {




   
    List<Object> billingAccounts = GetBillingAccounts(input);

    if (billingAccounts != null && !billingAccounts.isEmpty()) {
        for (Object billingAccount : billingAccounts) {

            Map<String, Object> objBilling = (Map<String, Object>) billingAccount;

            Boolean billingAccountIsSelected = (Boolean) objBilling.get('isSelected');

            if (billingAccountIsSelected != null && billingAccountIsSelected) {
                billingAccountId = (Id) objBilling.get('Id');
            }
        }
    }
      }

    outMap.put('selectedAccountId', billingAccountId);
   }

   private List<Object> GetBillingAccounts(Map<String, Object> inputMap) {
      try {
          Object billingAccounts = inputMap.get('BillingAccounts');

          if (billingAccounts instanceof List<Object>) { 
              return (List<Object>)billingAccounts;
          }
          else {
              List<Object> billingAccountsList = new List<Object>();
              Map<String, Object> billingAccount = (Map<String, Object>) inputMap.get('BillingAccounts');
              
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

   class DefaultOmniEditObjectException extends Exception
   {
   }
}