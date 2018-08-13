global with sharing class AutomaticDebitSubscription implements vlocity_cmt.VlocityOpenInterface
{
    global AutomaticDebitSubscription() {}
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;
        try
        {        
            if (methodName.equals('CreateTasks'))
            {
                CreateTasks(input, outMap, options);
            }
            result = false; 
        } 
        catch(Exception e)
        {
            System.debug('AutomaticDebitSubscription:invokeMethod -> exception: '+e);
            result = false;
        }
        return result; 
    }
    public static void CreateTasks (Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> options)
    {
        try {
            System.debug('Comienzo del CreateTasks');
            List<Task> taskList = new List<Task>();
            Id caseId = (Id)inputMap.get('DRId_Case');
            System.debug('caseId '+ caseId);
            //obtener primero PaymentMethod
            Map<String,Object>paymentmethod = (Map<String,Object>)inputMap.get('PaymentMethod');
            //System.debug('paymentmethod '+ paymentmethod);

            List<Object> payments = (List<Object>)AutomaticDebitSubscription.getPaymentMethods(paymentmethod);
            System.debug('payments '+ payments);
            Map<String, Object> step = (Map<String, Object>) inputMap.get('AutomaticDebitAction');
           // System.debug('step '+ step);
            String debitAction = (String) step.get('SelectedAutomaticDebitAction');
            System.debug('debitAction '+ debitAction);
            List<Object> billingAccounts = (List<Object>)inputMap.get('BillingAccounts');
            System.debug('billingAccounts '+ billingAccounts);


            //compruebo la operación
            If(debitAction == 'Adhesion')
            {
                System.debug('primer if '+ debitAction);

                        // recorro las ba para saber las seleccionadas
                        for(Object billingAccount : billingAccounts)
                        {
                            System.debug('billingAccount '+ billingAccount);
                            Map<String, Object> objBilling = (Map<String, Object>) billingAccount;
                            System.debug('objBilling '+ objBilling);
                            Boolean isSelectedBool =  false;
                            if(objBilling.get('isSelected') != null)
                                isSelectedBool = (Boolean) objBilling.get('isSelected');
                            
                            System.debug('isSelected '+ objBilling.get('isSelected'));

                            if(isSelectedBool)
                            {
                                System.debug('baisSelected ');
                                Id billingAccountId = (Id) objBilling.get('Id');
                                System.debug('IdBa '+ billingAccountId);
                                //busco el payment seleccionado
                                for (Object payment : payments) 
                                {
                                   // Map<String, Object> objBilling = (Map<String, Object>) billingAccount;
                                    Map<String, Object> objPayment = (Map<String, Object>) payment;
                                    Boolean paymentSelectedBool =  false;
                                    if(objPayment.get('Selected') != null)
                                        paymentSelectedBool = (Boolean)objPayment.get('Selected');

                                    Id paymentId = (Id)objPayment.get('PaymentId');
                                    If(paymentSelectedBool)
                                    {
                                        System.debug('paymentSelected ');
                                        //Id billingAccountId = (Id) inputMap.get('AccountId');
                                        Task taskObject = new Task();
                                        taskObject.Subject = 'Débito automático: ' + billingAccountId;
                                        taskObject.Description = debitAction + ': ' + paymentId;
                                        taskObject.Status = 'Not Started';
                                        taskObject.WhatId = caseId;
                    
                                        taskList.Add(taskObject);
            
                                        break;
                                    }
                                }
                            }
                        }
            }else if (debitAction == 'Update' ){
                System.debug('elseif primero '+ debitAction);
                String selectedBillingId = (String) inputMap.get('BillingAccountToResponse');

                for (Object payment : payments) 
                {
                   // Map<String, Object> objBilling = (Map<String, Object>) billingAccount;
                    
                    Map<String, Object> objPayment = (Map<String, Object>) payment;
                    Boolean paymentSelectedBool =  false;
                    if(objPayment.get('Selected') != null)
                        paymentSelectedBool = (Boolean)objPayment.get('Selected');
                    Id paymentId = (Id)objPayment.get('PaymentId');
                    If(paymentSelectedBool)
                    {
                        Task taskObject = new Task();
                        taskObject.Subject = 'Débito automático: ' + selectedBillingId;
                        taskObject.Description = debitAction + ': ' + paymentId;
                        taskObject.Status = 'Not Started';
                        taskObject.WhatId = caseId;
    
                        taskList.Add(taskObject);

                        break;
                    }
                }
            }else if(debitAction == 'Stop'){
                System.debug('elseif primero '+ debitAction);
                String selectedBillingId = (String) inputMap.get('BillingAccountToResponse');

                for(Object billingAccount : billingAccounts)
                {
                    System.debug('billingAccount '+ billingAccount);
                    Map<String, Object> objBilling = (Map<String, Object>) billingAccount;
                    System.debug('objBilling '+ objBilling);
                    Id billingAccountId = (Id) objBilling.get('Id');
                    System.debug('IdBa '+ billingAccountId);
                    if(billingAccountId == selectedBillingId)
                    {                        
                        //busco el payment 
                            //Map<String, Object> objPayment = (Map<String, Object>) payment;
                            Object autoPaymentIdObj = (Object) objBilling.get('AutoPaymentMethodIdFormula');
                            Id autoPaymentId;
                            if(autoPaymentIdObj instanceof Id)
                                autoPaymentId = (Id) autoPaymentIdObj;

                            //Id paymentId = (Id)objPayment.get('PaymentId');
                            If(autoPaymentId != null)
                            {
                                System.debug('paymentSelected ');
                                //Id billingAccountId = (Id) inputMap.get('AccountId');
                                Task taskObject = new Task();
                                taskObject.Subject = 'Débito automático: ' + billingAccountId;
                                taskObject.Description = debitAction + ': ' + autoPaymentId;
                                taskObject.Status = 'Not Started';
                                taskObject.WhatId = caseId;
            
                                taskList.Add(taskObject);
    
                            }
                        
                    }
                }

            }else if(debitAction == 'Delete'){
                // recorro las ba para saber las seleccionadas
                        for(Object billingAccount : billingAccounts)
                        {
                            System.debug('billingAccount '+ billingAccount);
                            Map<String, Object> objBilling = (Map<String, Object>) billingAccount;
                            System.debug('objBilling '+ objBilling);
                            Boolean isSelectedBool =  false;
                            if(objBilling.get('isSelected') != null)
                                isSelectedBool = (Boolean) objBilling.get('isSelected');
                            
                            System.debug('isSelected '+ objBilling.get('isSelected'));

                            if(isSelectedBool)
                            {
                                System.debug('baisSelected ');
                                Id billingAccountId = (Id) objBilling.get('Id');
                                System.debug('IdBa '+ billingAccountId);
                                //busco el payment 
                                Object autoPaymentIdObj = (Object) objBilling.get('AutoPaymentMethodIdFormula');
                                Id autoPaymentId;
                                if(autoPaymentIdObj instanceof Id)
                                    autoPaymentId = (Id) autoPaymentIdObj;

                                //Id paymentId = (Id)objPayment.get('PaymentId');
                                If(autoPaymentId != null)
                                {
                                    System.debug('paymentSelected ');
                                    //Id billingAccountId = (Id) inputMap.get('AccountId');
                                    Task taskObject = new Task();
                                    taskObject.Subject = 'Débito automático: ' + billingAccountId;
                                    taskObject.Description = debitAction + ': ' + autoPaymentId;
                                    taskObject.Status = 'Not Started';
                                    taskObject.WhatId = caseId;
                
                                    taskList.Add(taskObject);
        
                                    break;
                                }
                                
                            }
                        }
            }

            insert taskList; 

            //outMap.put('debug', debug);
        }
        catch (Exception ex) {
            throw new FuncException('Error al crear tareas: ' + ex.getMessage());
            //outMap.put('debug', 'Exception(' + ex.getMessage() + ') '+debug);
            //System.debug('exception: ' + ex.getMessage());
        }
    }


    public static List<Object> getPaymentMethods(Map<String,Object> paymentsMap)
    {
        Object paymentMethods = paymentsMap.get('PaymentMethods');

         if (paymentMethods instanceof List<Object>) {
              return (List<Object>)paymentMethods;
          }
          else {
              List<Object> paymentMethodsList = new List<Object>();
              Map<String, Object> paymentMethod = (Map<String, Object>) paymentsMap.get('PaymentMethods');
              
             if (paymentMethod != null) {
                  paymentMethodsList.add(paymentMethod);

                 return paymentMethodsList;
              }

             return null;
          }
    }

}