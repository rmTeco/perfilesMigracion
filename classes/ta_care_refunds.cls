global with sharing class ta_care_refunds implements vlocity_cmt.VlocityOpenInterface{

    global ta_care_refunds() {}
    
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
            if(methodName.equals('getBalanceForRefunds')){
                getBalanceForRefunds(input,outMap,options);
            }
            if(methodName.equals('getThreeMonthsAgoDate')){
                getThreeMonthsAgoDate(outMap);
            }
            if(methodName.equals('getPaymentHistoryForPaymentMethodForRefunds')){
                getPaymentHistoryForPaymentMethodForRefunds(outMap,options);
            }
            if(methodName.equals('getBalanceBillingAccounts')){
                getBalanceBillingAccounts(outMap,options);
            }
            if(methodName.equals('getCreditCardName')){
                getCreditCardName(outMap,options);
            }
            if(methodName.equals('getPaymentResult')){
                getPaymentResult(outMap,options);
            }
            if(methodName.equals('getBillingAccByAccId')){
                getBillingAccByAccId(outMap,options);
            }
            
        }
        catch(Exception e)
        {
            System.debug('getBalanceForRefunds:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }
    
    void getBalanceForRefunds (Map<String, Object> inputMap, Map<String, Object> outMap, Map<String,Object> options) {
        system.debug('ENTRO AL METODO getBalanceForRefunds');
        ta_care_ifs018 integS018 = new ta_care_ifs018();
        List<Object> resultList = integS018.getBalances(options);
        system.debug('LISTA FINAL S018 -->'+resultList);
        outMap.put('listaCuentas',resultList);

    }
    
    void getPaymentHistoryForPaymentMethodForRefunds (Map<String, Object> outMap, Map<String,Object> options) {
        system.debug('ENTRO AL METODO getPaymentHistoryForPaymentMethodForRefunds');
        ta_care_ifs059 integS059 = new ta_care_ifs059();
        List<Object> resultList = integS059.getPaymentHistoryForPaymentMethod(options);
        system.debug('LISTA FINAL S059 -->'+resultList);
        outMap.put('CreditCardPaymentsList',resultList);

    }
    
    void getThreeMonthsAgoDate(Map<String, Object> outMap){
        Date actualDate = date.today();
        Date actualDateLessMonth = actualDate.addMonths(-3);
        datetime dt = datetime.newInstance(actualDateLessMonth.year(), actualDateLessMonth.month(),actualDateLessMonth.day());
        outMap.put('ThreeMonthsAgoDate',dt);
    }
    
    void getBalanceBillingAccounts(Map<String, Object> outMap, Map<String,Object> options){
        try {
            List<Object> billingAccList = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'BillingAccounts');
            List<Object> balanceAccList = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'listaCuentas');
            Map<String, Object> resultMap= new Map<String, Object>();
            List<Object> listResult = new List<Object>();
            Boolean wasFound;
            for(Object obje: balanceAccList){
                wasFound = false;
                Map<String, Object> balanceMap = (Map<String, Object>)obje;
                String intId = (String)balanceMap.get('accountIntId');
                String clientDebt = (String)balanceMap.get('saldoDeudor');
                String positiveBalance = (String)balanceMap.get('saldoAFavor');
                String pastDueBalance = (String)balanceMap.get('saldoVencido');
                String futureExpDateBalance = (String)balanceMap.get('saldoAVencer');
                for (Object ob : billingAccList ) {
                    Map<String, Object> accountMap = (Map<String, Object>)ob;
                    string accIntId = (string)accountMap.get('AccountIntegrationId');
                    if(intId == accIntId){
                        resultMap = accountMap;
                        resultMap.put('saldoDeudor',clientDebt);
                        resultMap.put('saldoAFavor',positiveBalance);
                        resultMap.put('saldoVencido',pastDueBalance);
                        resultMap.put('saldoAVencer',futureExpDateBalance);
                        wasFound = true;
                    }
                }
                If(wasFound){
                    listResult.add(resultMap);
                }
            }
            outMap.put('BalancedBillingAccounts',listResult);

        }
        catch (Exception ex) {
          system.debug(ex.getLineNumber());
          throw ex;
        }
    }
    
    void getCreditCardName (Map<String, Object> outMap, Map<String,Object> options){
        List<Object> resultList = new List<Object>();
        string codTarjeta;
        List<CreditCardsBins__c> mcs = CreditCardsBins__c.getall().values();
        Map<String,String> csMap = new Map<String,String>();
        for(CreditCardsBins__c obj :mcs){
            csMap.put(obj.CredicardTypeId__c,obj.name);
        }
        system.debug('CUSTOM SETTING-->'+csMap);
        List<Object> paymentList = (List<Object>)options.get('CreditCardPaymentsList');
        system.debug('paymentList'+paymentList);
        for(Object obj: paymentList){
            Map<String, Object> resultMap = (Map<String, Object>)obj;
            codTarjeta = (String)resultMap.get('codEntidadTC');
            system.debug('CODIGO DE TARJETA-->'+resultMap.get('codEntidadTC'));
            resultmap.put('nomTarjeta',csMap.get(codTarjeta));
            resultList.add(resultmap);
        }
        outMap.put('NewCreditCardPaymentsModifiedList',resultList);
    }
    
    void getPaymentResult (Map<String, Object> outMap, Map<String,Object> options){
        Boolean result;
        ta_care_ifs072 integS072 = new ta_care_ifs072();
        result = integS072.getRollbackResultSuccess(options);
        outMap.put('PaymentRollBackResultSuccess',result);
    }
    
    void getBillingAccByAccId (Map<String, Object> outMap, Map<String,Object> options){
        Map<String,Object> resultMap = new Map<String,Object>();
        ID accId = (ID)options.get('AccountId');
        List<Object> balanceDetailsList = (List<Object>)options.get('AccountBalanceList');
        for(Object obj: balanceDetailsList){
            Map<String,Object> detailMap = (Map<String,Object>)obj;
            if( accId == (ID)detailMap.get('AccountId')){
                resultMap = detailMap;
            }
        }
        outMap.put('AccountBalanceList',resultMap);
    }

}