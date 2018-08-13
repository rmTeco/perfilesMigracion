global with sharing class ta_sales_paymentMethodLogic implements vlocity_cmt.VlocityOpenInterface{
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        if(methodName.equals('PopulateEntidades')){
            PopulateEntidades(input, outMap, options);
        }
        
        if(methodName.equals('PopulateTarjetas')){
            PopulateTarjetas(input, outMap, options);
        }
        
        if(methodName.equals('PopulateCuotas')){
            PopulateCuotas(input, outMap, options);
        }

        if(methodName.equals('PopulatePlanDeCuotas')){
            PopulatePlanDeCuotas(input, outMap, options);
        }
        
        if(methodName.equals('PopulateEntidadesFromObject')){
            PopulateEntidadesFromObject(input, outMap, options);
        }
        
        if(methodName.equals('PopulateTarjetasFromObject')){
            PopulateTarjetasFromObject(input, outMap, options);
        }
        
        if(methodName.equals('PopulateDPFInstallmentsFromObject')){
            PopulateDPFInstallmentsFromObject(input, outMap, options);
        }
        
        return true;
    }
    
    public void PopulateEntidades(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        List<Map<String, String>> returnedPicklistValues = new List<Map<String, String>>();
        List<ExternalBankEntitiesIds__c> lstBanks = ExternalBankEntitiesIds__c.getAll().values();
        lstBanks.sort();
        
        for(ExternalBankEntitiesIds__c itemBank : lstBanks){
            Map<String, String> tempMap = new Map<String, String>();
        
            tempMap.put('name', itemBank.BankCode__c);
            tempMap.put('value', itemBank.Name);

            returnedPicklistValues.add(tempMap);
        }
        
        /*for(ExternalBankEntitiesIds__c entities : ExternalBankEntitiesIds__c.getAll().values()){
            Map<String, String> tempMap = new Map<String, String>();
        
            tempMap.put('name', entities.BankCode__c);
            tempMap.put('value', entities.Name);

            returnedPicklistValues.add(tempMap);
        }*/
        system.debug('Lista: ' + returnedPicklistValues);
        //returnedPicklistValues.sort();
        outMap.put('options', returnedPicklistValues);
    }
    
    public void PopulateTarjetas(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        Map<String, List<Map<String, String>>> dependency = new Map<String,List<Map<String, String>>>();
        List<FinancialPromotions__c> lstFinancialPromotions = FinancialPromotions__c.getall().values();
        for (FinancialPromotions__c rel : lstFinancialPromotions){
            if (!dependency.containsKey(rel.Bank_Code__c)){
                dependency.put(rel.Bank_Code__c, new List<Map<String, String>>());
            }
        
            Map<String, String> tempMap = new Map<String, String>();

            tempMap.put('name', rel.Creditcard_Type__c);
            tempMap.put('value', rel.Creditcard_Name__c);

            dependency.get(rel.Bank_Code__c).add(tempMap);
        }
        outMap.put('dependency', dependency);
        system.debug('Tarjetas: ' + dependency);
    }
    
    public void PopulateCuotas(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        Map<String, List<Map<String, String>>> dependency = new Map<String,List<Map<String, String>>>();
        List<FinancialPromotions__c> lstFinancialPromotions = FinancialPromotions__c.getall().values();
        for (FinancialPromotions__c rel : lstFinancialPromotions){
            if (!dependency.containsKey(rel.Bank_Code__c + '_' + rel.Creditcard_Type__c)){
                dependency.put(rel.Bank_Code__c + '_' + rel.Creditcard_Type__c, new List<Map<String, String>>());
            }
        
            Map<String, String> tempMap = new Map<String, String>();

            tempMap.put('name', rel.Instalments__c);
            tempMap.put('value', rel.CFT__c);

            dependency.get(rel.Bank_Code__c + '_' + rel.Creditcard_Type__c).add(tempMap);
        }
        system.debug('Cuotas: ' + dependency);
        outMap.put('dependency', dependency);
   }

   public Map<String, Object> GetCardsByBank(String bankCode){
        List<Map<String, String>> returnedPicklistValues = new List<Map<String, String>>();
        Map<String, Object> outMap = new Map<String, Object>();
        List<FinancialPromotions__c> lstFinancialPromotions = FinancialPromotions__c.getall().values();
        for (FinancialPromotions__c rel : lstFinancialPromotions){
            if (rel.Bank_Code__c == bankCode)
            {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('name', rel.Creditcard_Type__c);
                tempMap.put('value', rel.Creditcard_Name__c);
                returnedPicklistValues.add(tempMap);
            }
        }
        outMap.put('options', returnedPicklistValues);
        return outMap;
    }

    public Map<String, Object> GetInstallmentsByCard(String bankCode, String cardType){
        List<Map<String, String>> returnedPicklistValues = new List<Map<String, String>>();
        Map<String, Object> outMap = new Map<String, Object>();
        String bankCardCode = bankCode + '_' + cardType;
        List<FinancialPromotions__c> lstFinancialPromotions = FinancialPromotions__c.getall().values();
        for (FinancialPromotions__c rel : lstFinancialPromotions){
            if (rel.Bank_Code__c + '_' + rel.Creditcard_Type__c == bankCardCode)
            {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('name', rel.Instalments__c);
                tempMap.put('value', rel.CFT__c);
                returnedPicklistValues.add(tempMap);
            }
        }
        outMap.put('options', returnedPicklistValues);
        return outMap;
    }

    public void PopulatePlanDeCuotas(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        Map<String, List<Map<String, String>>> dependency = new Map<String,List<Map<String, String>>>();
        system.debug('Esta llamando a este metodo!');
        List<FinancialPromotions__c> lstFinancialPromotions = FinancialPromotions__c.getall().values();
        for (FinancialPromotions__c rel : lstFinancialPromotions){
            if (!dependency.containsKey(rel.Bank_Code__c + '_' + rel.Creditcard_Type__c)){
                dependency.put(rel.Bank_Code__c + '_' + rel.Creditcard_Type__c, new List<Map<String, String>>());
            }
        
            Map<String, String> tempMap = new Map<String, String>();

            tempMap.put('name', rel.Installment_Plan__c);
            tempMap.put('value', rel.Installment_Plan__c);

            dependency.get(rel.Bank_Code__c + '_' + rel.Creditcard_Type__c).add(tempMap);
        }
        system.debug('Plan de Cuota: ' + dependency);
        outMap.put('dependency', dependency);
   }
   
   public void PopulateEntidadesFromObject(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        Set<Map<String, String>> returnedPicklistValues = new Set<Map<String, String>>();
        String serializedList = (String) input.get('promotionOptions');
        List<FinancialPromotion__c> financialPromotions = (List<FinancialPromotion__c>)System.JSON.deserialize(serializedList,List<FinancialPromotion__c>.class);

        DescribeFieldResult describe = FinancialPromotion__c.BankEntities__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();
        for(FinancialPromotion__c promotion : financialPromotions){
            Map<String, String> tempMap = new Map<String, String>();
            for(PicklistEntry picklist : availableValues){
                if(picklist.getValue() == promotion.BankEntities__c){
                    tempMap.put('value', picklist.getLabel());  
                    break;  
                }
            }
            tempMap.put('name', promotion.BankEntities__c);
            returnedPicklistValues.add(tempMap); 
        }
        outMap.put('options', returnedPicklistValues);
    }
    
    public void PopulateTarjetasFromObject(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        Set<Map<String, String>> returnedPicklistValues = new Set<Map<String, String>>();   
        String serializedList = (String) input.get('promotionOptions');
        List<FinancialPromotion__c> financialPromotions = (List<FinancialPromotion__c>)System.JSON.deserialize(serializedList,List<FinancialPromotion__c>.class);

        DescribeFieldResult describe = FinancialPromotion__c.CreditCards__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();
        for(FinancialPromotion__c promotion : financialPromotions){
            Map<String, String> tempMap = new Map<String, String>();
            for(PicklistEntry picklist : availableValues){
                if(picklist.getValue() == promotion.CreditCards__c){
                    tempMap.put('value', picklist.getLabel());  
                    break;  
                }
            }
            tempMap.put('name', promotion.CreditCards__c);
            returnedPicklistValues.add(tempMap); 
        }
        outMap.put('options', returnedPicklistValues);
    }
    
    public Map<String, Object> GetPromotionsByBankCard(String bankCode, String cardType, Map<String, Object> options){
        Map<String, Object> outMap = new Map<String, Object>();
        Set<Map<String, String>> returnedPicklistValues = new Set<Map<String, String>>();   
        String serializedList = (String) options.get('promotionOptions');
        List<FinancialPromotion__c> financialPromotions = (List<FinancialPromotion__c>)System.JSON.deserialize(serializedList,List<FinancialPromotion__c>.class);

        for(FinancialPromotion__c promotion : financialPromotions){
            if(promotion.BankEntities__c == bankCode && promotion.CreditCards__c == cardType){
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('value', promotion.NombrePromocion__c);
                tempMap.put('name', promotion.NombrePromocion__c);
                returnedPicklistValues.add(tempMap); 
            }
        }
        outMap.put('options', returnedPicklistValues);
        return outMap;
    }
    
    public Map<String, Object> GetInstallmentsByPromotions(String bankCode, String cardType, String promotionName, Map<String, Object> options){
        Set<Map<String, String>> returnedPicklistValues = new Set<Map<String, String>>();
        Map<String, Object> outMap = new Map<String, Object>();
        String serializedList = (String) options.get('promotionOptions');
        List<FinancialPromotion__c> financialPromotions = (List<FinancialPromotion__c>)System.JSON.deserialize(serializedList,List<FinancialPromotion__c>.class);

        for(FinancialPromotion__c promotion : financialPromotions){
            if(promotion.BankEntities__c    == bankCode 
            && promotion.CreditCards__c     == cardType
            && promotion.NombrePromocion__c == promotionName){
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('percentage', String.valueOf(promotion.Percentage__c));
                tempMap.put('value', String.valueOf(promotion.Interest__c));
                tempMap.put('name', promotion.Instalment__c);
                tempMap.put('id', promotion.Id);
                returnedPicklistValues.add(tempMap); 
            }
        }
        outMap.put('options', returnedPicklistValues);
        return outMap;
    }
    
    public void PopulateDPFInstallmentsFromObject(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        List<Map<String, String>> returnedPicklistValues = new List<Map<String, String>>();
        List<FinancialPromotion__c> lstDPF = [SELECT Id, Instalment__c, Interest__c, /*Percentage__c,*/ NombrePromocion__c FROM FinancialPromotion__c WHERE RecordType.Name = 'Debit to Next Bill'];
        lstDPF.sort();
        
        for(FinancialPromotion__c itemDPF : lstDPF){
            Map<String, String> tempMap = new Map<String, String>();
            String strPercentage = String.valueOf(itemDPF.Interest__c);
            tempMap.put('name', itemDPF.Instalment__c);
            tempMap.put('value', strPercentage);
            tempMap.put('id', itemDPF.Id);
            returnedPicklistValues.add(tempMap);
        }
        
        outMap.put('options', returnedPicklistValues);
    }
}