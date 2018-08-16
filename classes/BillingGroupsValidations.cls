global with sharing class BillingGroupsValidations implements vlocity_cmt.VlocityOpenInterface
{
    global BillingGroupsValidations() {}
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
      

        Boolean result = true;
        try
        {
        
            if (methodName.equals('HiMethod'))
            {
                 
                HiMethod(input, outMap, options);
            }
            if (methodName.equals('ValidSelection'))
            {
                 
                ValidSelection(input, outMap, options);
            }
            if (methodName.equals('ChangeAssetsAccount'))
            {
                 
                ChangeAssetsAccount(input, outMap, options);
            }
            if (methodName.equals('ValidateToAccountFinancing'))
            {
                ValidateToAccountFinancing(input, outMap, options);
            }
            if (methodName.equals('ValidateFromAccountsFinancing'))
            {
                ValidateFromAccountsFinancing(input, outMap, options);
            }
            result = false;
          
        } 
        catch(Exception e)
        {
            System.debug('ChangesValidation:invokeMethod -> exception: '+e);
            result = false;
        }
        return result; 
    }

    void ValidateToAccountFinancing (Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> options)
    {

        System.debug('inputMap >>>> ' + inputMap);
        System.debug('options >>>> ' + options);

        String debug = '';
        Boolean validationOK = true;

        try{
            String newAccountId = (String) inputMap.get('BillingAccountToResponse');

            debug += 'obtuve el BillingAccountToResponse | ';

            List<Object> billingAccounts = (List<Object>) inputMap.get('BillingAccounts');

            debug += 'obtuve la lista de BillingAccounts | ';

            for(Object billingAccount : (List<Object>) billingAccounts)
            {
                debug += 'recorro las billingAccounts | ';

                Map<String, Object> billingAcc = (Map<String, Object>) billingAccount;


                debug += 'obtuve la billingAcc | ';

                if((String) billingAcc.get('Id') == newAccountId){
                    if((Boolean) billingAcc.get('PurchaseFinancing') ||
                        (Boolean) billingAcc.get('DebtFinancing'))
                    {
                        validationOK = false;
                    }

                    break;
                }
            }
        }
        catch(Exception ex){
            debug += ex.getMessage();
        }

        if(debug != '')
            outMap.put('debug', debug);

        Map<String, Object> bloqueCheck = (Map<String, Object>) inputMap.get('BillingAccountToStep');

        bloqueCheck.put('AuxAccountIsValid',validationOK);

        outMap.put('BillingAccountToStep', bloqueCheck);
        outMap.put('validationToAccount', validationOK);
    }

    void ValidateFromAccountsFinancing(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> options)
    {
        String debug = '';
        List<Object> rejectedBillingAccounts = new List<Object>();

        try{

            List<Object> checkedBillingAccounts = (List<Object>) inputMap.get('checkedBillingAccounts');
            debug += 'Obtuve checkedBillingAccounts | ';

            List<Object> billingAccounts = (List<Object>) inputMap.get('BillingAccounts');
            debug += 'Obtuve billingAccounts | ';

            for(Object billingAccount : billingAccounts)
            {
                debug += 'Recorro billingAccounts | ';

                Map<String, Object> billingAcc = (Map<String, Object>) billingAccount;
                String billingAccId = (String) billingAcc.get('Id');

                for(Object chkBillingAccount : checkedBillingAccounts){
                    debug += 'Recorro checkedBillingAccounts | ';

                    Map<String, Object> checkedBillingAcc = (Map<String, Object>) chkBillingAccount;
                    String checkedBillingAccId = (String) checkedBillingAcc.get('id');

                    if(billingAccId == checkedBillingAccId)
                    {
                        debug += 'Se seleccionó la cuenta ' + billingAccId +' | ';

                        if((Boolean) billingAcc.get('PurchaseFinancing') ||
                        (Boolean) billingAcc.get('DebtFinancing'))
                        {
                            debug += 'Se agrega la cuenta a la lista de rejected | ';

                            Map<String, String> rejBillAcc = new Map<String, String>();

                            rejBillAcc.put('id', checkedBillingAccId);

                            rejectedBillingAccounts.add(rejBillAcc);

                            debug += 'Se agregó | ';
                        }
                    }
                }
            }
        }
        catch(Exception ex)
        {
            debug += ex.getMessage();
        }

        outMap.put('debug', debug);
        outMap.put('rejectedBillingAccounts', rejectedBillingAccounts);
    }

    void HiMethod (Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> options)
    {
        System.debug('Comienzo del himethod');
        //String accountId = (String) inputMap.get('id');
        //string valorPorParametro = (string) options.get('probandoValor');
        //integer numPrueba = 2;
        //System.debug('valorPorParametro: ' + valorPorParametro);
                integer actualMonth = date.today().month() ;
        System.debug('actualMonth: ' + actualMonth);
        //outMap.put('options',false);
    }

    void ChangeAssetsAccount(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> options)
    {
        boolean flagOk = true;

        try{
            List<Object> checkedAssets = (List<Object>) inputMap.get('checkedAssets');
            String newAccountId = (String) inputMap.get('BillingAccountToResponse');

            List<Asset> listChangedAssets = new List<Asset>();
            
            List<Id> assetIds = new List<Id>();

            for(Object checkedAsset : checkedAssets){

                Map<String, Object> mapCheckedAsset = (Map<String, Object>) checkedAsset;
                
                Id assetId = (Id) mapCheckedAsset.get('id');
                
                assetIds.add(assetId);

                //Asset asset = [SELECT Id, Name FROM Asset WHERE Id = :assetId];

                //asset.AccountId = newAccountId;

                //listChangedAssets.add(asset);
            }
            
            for(Asset asset: [SELECT Id, Name FROM Asset WHERE Id IN :assetIds]) {
            	asset.AccountId = newAccountId;
            	listChangedAssets.add(asset);
            }

            update listChangedAssets;
        } catch(Exception ex){
            outMap.put('Error', ex.getMessage());

            flagOk = false;
        }

        outMap.put('successUpdate', flagOk);
    }

    void ValidSelection (Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> options)
    {
        String debug = '';
        List<Map<String,String>> checkedAssets = new List<Map<String,String>>();
        List<Map<String,String>> checkedBillingAccounts = new List<Map<String,String>>();

        try{        

            debug += 'instanciados checked Assets y checkedBillingAccounts | ';
            Object billingAccounts = options.get('BillingAccounts');

            for(Object billingAcc : (List<Object>) billingAccounts){
                Map<String, Object> acc = (Map<String, Object>) billingAcc;

                debug += 'recorre billingAccounts | ';

                if(acc.containsKey('Assets')){

                    debug += 'existe Assets | ';

                    if(acc.get('Assets') instanceof List<Object>){

                        debug += 'es una lista | ';

                        List<Object> assets = (List<Object>) acc.get('Assets');

                        boolean addBillingAccount = true;

                        for(Object asset : assets){

                            debug += 'recorro Assets | ';

                            Map<String, Object> mapAsset = (Map<String, Object>) asset;

                            if(mapAsset.containsKey('isSelected') && (boolean) mapAsset.get('isSelected')){

                                if(addBillingAccount){
                                    Map<String, String> checkedAcc = new Map<String,String>();
                                    checkedAcc.put('id', (String) acc.get('Id'));
                                    checkedBillingAccounts.add(checkedAcc);

                                    addBillingAccount = false;
                                }

                                Map<String, String> checkedAsset = new Map<String,String>();
                                checkedAsset.put('id', (String) mapAsset.get('Id'));
                                
                                checkedAssets.add(checkedAsset);
                            }
                        }
                    } 
                    else
                    {
                        debug += 'No es una lista | ';

                        Map<String, Object> mapAsset = (Map<String, Object>) acc.get('Assets');

                        debug += 'Convierto Assets a object | ';

                        debug += 'mapAsset: ' + mapAsset + ' | ';

                        if(mapAsset.containsKey('isSelected') && (boolean) mapAsset.get('isSelected')){
                            debug += 'Obtuve isSelected | ';

                            //Agrego la billing Account
                            Map<String, String> checkedAcc = new Map<String,String>();
                            checkedAcc.put('id', (String) acc.get('Id'));
                            checkedBillingAccounts.add(checkedAcc);

                            debug += 'Agregué BillingAccounts | ';

                            //Agrego el asset
                            Map<String, String> checkedAsset = new Map<String,String>();
                            checkedAsset.put('id', (String) mapAsset.get('Id'));
                            
                            checkedAssets.add(checkedAsset);

                            debug += 'Agregué Asset | ';
                        }

                        debug += 'isSelected salió | ';
                    }
                }
            }
        }
        catch(Exception ex)
        {
            debug += ex.getMessage();
        }

        outMap.put('debug', debug);
        outMap.put('checkedBillingAccounts', checkedBillingAccounts);
        outMap.put('checkedAssets', checkedAssets);
    }
}