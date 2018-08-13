/**
 * Created by Alex Lazarev 15/08/2017
 *
 * Implements VlocityOpenInterface
 * Provides the needed logic to support OS JSON VOI translation
 *
 * Objects: Account / Task / Custom Settings
 *
 * Important: The method uses a VlocityOpenInterface integration structure
 *
 * Version: 2.0
 */

global with sharing class BillingCycleChangeValidation implements vlocity_cmt.VlocityOpenInterface {

	global BillingCycleChangeValidation() {}

	global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {

		Boolean result = true;
		try {

			if (methodName.equals('checkIfBillingAccIsDunning')) {

				checkIfBillingAccIsDunning(input, outMap, options);
			}
			if (methodName.equals('checkIfBillingAccIsPurchaseFinancing')) {

				checkIfBillingAccIsPurchaseFinancing(input, outMap, options);
			}
            if (methodName.equals('checkIfBillingAccIsDebtFinancing')) {

				checkIfBillingAccIsDebtFinancing(input, outMap, options);
			}
			if (methodName.equals('calculateCyclingApproval')) {

				calculateCyclingApproval(input, outMap, options);
			}
			if (methodName.equals('generateActiveWithServicesBAs')) {

				generateActiveWithServicesBAs(input, outMap, options);
			}
			if (methodName.equals('returnSelectedBAs')) {

				returnSelectedBAs(input, outMap, options);
			}
			if (methodName.equals('CreateTasks')) {

				CreateTasks(input, outMap, options);
			}
			result = false;

		}
		catch(Exception e) {
			System.debug('BillingCycleChangeValidation: invokeMethod -> exception: '+e);
			result = false;
			outMap.put('error', e.getMessage());
		}
		return result;
	}

	void checkIfBillingAccIsDunning(Map<String, Object> inputMap,  Map<String, Object> outMap, Map<String, Object> options) {

		System.debug('Start of checkIfBillingAccIsDunning');

		Map<String,String> dunningMap = new Map<String, String>();
		List<Account> accNames= new List<Account>();
		List<Map<String, String>> dunningAccounts = new List<Map<String, String>>();


		try{

			// Clearing only the DunningAccName node to avoid steps bugs
			outMap.put('DunningAccName',dunningAccounts);
			outMap.put('ShowError',false);

			// Grabbing all the BAs nodes
			List<Object> billingAccounts = (List<Object>) inputMap.get('SelectedBillingAccounts');

			for(Object billingAccount : billingAccounts){

				Map<String, Object> billingAccMap = (Map<String, Object>) billingAccount;
				System.debug('billingAccount: ' + (String) billingAccMap.get('Name'));

				// Adding to dunningNames only those that are selected and
				// dunning
				if((Boolean) billingAccMap.get('Dunning') == true){
					dunningMap.put('Name',(String)billingAccMap.get('Name'));
					dunningAccounts.add(dunningMap);
					outMap.put('ShowError',true);
				}
			}

			System.debug('dunningMap: ' + dunningMap);
		} catch (Exception e){
			System.debug('checkIfBillingAccIsDunning: invokeMethod -> exception: '+e);
		}

		if(!dunningAccounts.isEmpty()){
			outMap.put('DunningAccName', dunningAccounts);
		}
		System.debug('outMap: ' + outMap);
	}

	void checkIfBillingAccIsPurchaseFinancing(Map<String, Object> inputMap,  Map<String, Object> outMap, Map<String, Object> options) {

		System.debug('Start of checkIfBillingAccIsPurchaseFinancing');

		Map<String,String> purchaseMap = new Map<String, String>();
		List<Account> accNames= new List<Account>();
		List<Map<String, String>> purchaseAccounts = new List<Map<String, String>>();


		try{

			// Clearing only the DunningAccName node to avoid steps bugs
			outMap.put('PurchaseFinancingAccName',purchaseAccounts);
			outMap.put('ShowError',false);

			// Grabbing all the BAs nodes
			List<Object> billingAccounts = (List<Object>) inputMap.get('SelectedBillingAccounts');

			for(Object billingAccount : billingAccounts){

				Map<String, Object> billingAccMap = (Map<String, Object>) billingAccount;
				System.debug('billingAccount: ' + (String) billingAccMap.get('Name'));
				System.debug('PurchaseFinancing: ' + billingAccMap.get('PurchaseFinancing'));

				// Adding to dunningNames only those that are selected and
				// dunning
				if((Boolean) billingAccMap.get('PurchaseFinancing') == true){
					purchaseMap.put('Name',(String)billingAccMap.get('Name'));
					purchaseAccounts.add(purchaseMap);
					outMap.put('ShowError',true);
				}
			}

			System.debug('purchaseAccounts: ' + purchaseAccounts);
		} catch (Exception e){
			System.debug('checkIfBillingAccIsDunning: invokeMethod -> exception: '+e);
		}

		if(!purchaseAccounts.isEmpty()){
			outMap.put('PurchaseFinancingAccName', purchaseAccounts);
		}
		System.debug('outMap: ' + outMap);
	}

    void checkIfBillingAccIsDebtFinancing(Map<String, Object> inputMap,  Map<String, Object> outMap, Map<String, Object> options) {

		System.debug('Start of checkIfBillingAccIsDebtFinancing');

		Map<String,String> debtMap = new Map<String, String>();
		List<Account> accNames= new List<Account>();
		List<Map<String, String>> debtAccounts = new List<Map<String, String>>();


		try{

			// Clearing only the DunningAccName node to avoid steps bugs
			outMap.put('DebtFinancingAccName',debtAccounts);
			outMap.put('ShowError',false);

			// Grabbing all the BAs nodes
			List<Object> billingAccounts = (List<Object>) inputMap.get('SelectedBillingAccounts');

			for(Object billingAccount : billingAccounts){

				Map<String, Object> billingAccMap = (Map<String, Object>) billingAccount;
				System.debug('billingAccount: ' + (String) billingAccMap.get('Name'));
				System.debug('DebtFinancing: ' + billingAccMap.get('DebtFinancing'));

				// Adding to dunningNames only those that are selected and
				// dunning
				if((Boolean) billingAccMap.get('DebtFinancing') == true){
					debtMap.put('Name',(String)billingAccMap.get('Name'));
					debtAccounts.add(debtMap);
					outMap.put('ShowError',true);
				}
			}

			System.debug('debtMapAccounts: ' + debtAccounts);
		} catch (Exception e){
			System.debug('checkIfBillingAccIsDebtFinancing: invokeMethod -> exception: '+e);
		}

		if(!debtAccounts.isEmpty()){
			outMap.put('DebtFinancingAccName', debtAccounts);
		}
		System.debug('outMap: ' + outMap);
	}
    
	void calculateCyclingApproval(Map<String, Object> inputMap,  Map<String, Object> outMap, Map<String, Object> options){

		try{	
			vlocity_cmt__BillingDataTrim__c settings = vlocity_cmt__BillingDataTrim__c.getOrgDefaults();
			Integer limitCyclingDays;
			if(settings.BillCycleMaxDays__c.intValue() == null)
				limitCyclingDays = 0;
			else {
				limitCyclingDays = settings.BillCycleMaxDays__c.intValue();
			}
			Integer currentCyclingDays = null;
			String cyclingApproved = 'true';
			String cyclingBillingAccount;
			Map<String,String> cyclingMap = new Map<String, String>();
			List<Map<String, String>> cyclingListofMaps = new List<Map<String, String>>();
		
			try{
				outMap.put('CycleChange', cyclingListofMaps);
				outMap.put('ShowError',false);

				// Get the Id from the Billing account of which we will get the last AccountHistory Date
				List<Object> billingAccounts = (List<Object>) inputMap.get('SelectedBillingAccounts');
				for (Object billingAccount : billingAccounts){
					Map<String, Object> billingAccMap = (Map<String, Object>) billingAccount;
					List<Account> accNames = new List<Account>();

					accNames.add(new Account(Id = (String)billingAccMap.get('Id'), Name = (String)billingAccMap.get('Name')));
					List<AccountHistory> accountsHistory = BillingIntegrationHandler.lastEditPerAccountHistory(accNames);

					for (Account accName : accNames){
						if (!accountsHistory.isEmpty()){
							for (AccountHistory accHist : accountsHistory){
								// If list is empty then there are no AccountHistory changes to validate
								if (accName.Id == accHist.AccountId ){
									// getting Billing account difference between today and last history modification date
									// Today is always greater than last update or 0 and allway add +1 else its not counting
									// current day
									currentCyclingDays = Date.valueOf(accHist.CreatedDate).daysBetween(Date.today()+1);
									// if the current amount of days since last update is less o iqual to limit
									if (currentCyclingDays < limitCyclingDays) {
										cyclingBillingAccount = accName.Name;
										cyclingApproved = 'false';
										outMap.put('ShowError',true);
									// if the currentCyclingDays is bigger than the limit, then we allow the cycle
									} else if (currentCyclingDays >= limitCyclingDays) {
										cyclingBillingAccount = accName.Name;
										cyclingApproved = 'true';
									}
								}

								cyclingMap.put('CycleChangeAllowed', cyclingApproved);
								cyclingMap.put('CyclingBillingAccount', cyclingBillingAccount);

								cyclingListofMaps.add(cyclingMap);
							}
						} else {
							cyclingMap.put('CycleChangeAllowed', cyclingApproved);
							cyclingMap.put('CyclingBillingAccount', accName.Name);

							cyclingListofMaps.add(cyclingMap);
						}

					}
				}
			} catch (Exception e){
				System.debug('calculateCyclingApproval: invokeMethod -> exception: '+e);
			}

			outMap.put('CycleChange', cyclingListofMaps);
			outMap.put('CyclingLimitDay', String.valueOf(limitCyclingDays));
		} catch(Exception ex){
			throw new FuncException('Error al calcular el ciclo de aprobación: ' + ex.getMessage());
		}

	}

	void generateActiveWithServicesBAs(Map<String, Object> inputMap,  Map<String, Object> outMap, Map<String, Object> options){

		List<Object> activeWithAssetsBAs = new List<Object>();

		try{

			List<Object> billingAccounts = (List<Object>) inputMap.get('BillingAccounts');

			// getting inside BillingAccount node
			for(Object billingAccount : billingAccounts){
				System.debug('billingAccount: ' + billingAccount);

				Map<String, Object> billingAccMap = (Map<String, Object>) billingAccount;

				// if node has Assets
				if((String) billingAccMap.get('Assets') != null){
					List<Object> assetsList = (List<Object>) inputMap.get('Assets');
					for(Object asset : assetsList){

						// check inside the asset node for active service and add this BillingAccount
						// to the map
						Map<String, Object> assetsMap = (Map<String, Object>) asset;
						if((String)assetsMap.get('Status') == 'Active'){
							activeWithAssetsBAs.add(billingAccount);
						}

					}
				}
			}

			outMap.put('BillingAccounts', activeWithAssetsBAs);
			System.debug('BillingAccounts: ' + activeWithAssetsBAs);
			System.debug('outMap: ' + outMap);
		} catch (Exception e){
			System.debug('generateActiveWithServicesBAs: invokeMethod -> exception: '+e);
		}
	}

	void returnSelectedBAs(Map<String, Object> inputMap,  Map<String, Object> outMap, Map<String, Object> options){

		Map<String,String> selectedMap = new Map<String, String>();
		List<Map<String, String>> selectedListOfMaps = new List<Map<String, String>>();
		List<Object> selectedBillingAccounts = new List<Object>();

		try{
			outMap.put('ShowError',false);
			List<Object> billingAccounts = (List<Object>) inputMap.get('BillingAccounts');

			for(Object billingAccount : billingAccounts){

				Map<String, Object> billingAccMap = (Map<String, Object>) billingAccount;
				System.debug('billingAccount: ' + (String) billingAccMap.get('Name'));

				// Adding to selectedNames only those that are selected and
				// not dunning to check theirs last billing cycle edit date
				if((Boolean) billingAccMap.get('isSelected') == true){
					// && (Boolean) billingAccMap.get('Dunning') == false
					//selectedNames.add((Id)billingAccMap.get('Id'));
					//selectedMap.put('Id', (String)billingAccMap.get('Id'));
					//selectedListOfMaps.add(selectedMap);
					selectedBillingAccounts.add(billingAccMap);
				} else {
					outMap.put('ShowError',true);
				}
			}

		} catch (Exception e){
			System.debug('returnSelectedBAs: invokeMethod -> exception: '+e);
		}

		if(!selectedBillingAccounts.isEmpty()){
			outMap.put('SelectedBillingAccounts', selectedBillingAccounts);
		}
		System.debug('outMap: ' + outMap);

	}

public void CreateTasks(Map<String, Object> inputMap,  Map<String, Object> outMap, Map<String, Object> options){
		//String debug = 'Inicio | ';

		try {
			List<Task> taskList = new List<Task>();
			Id caseId = (Id)inputMap.get('CaseId');

			List<Object> selectedBillingAccounts = (List<Object>)inputMap.get('SelectedBillingAccounts');
			Map<String, Object> newBillingCycle = (Map<String, Object>)inputMap.get('NewBillingCycle');
			Integer selectedBillingCycle = Integer.ValueOf(newBillingCycle.get('BillingCycleSelect'));

			//debug += 'Cantidad de Billing Accounts: ' + selectedBillingAccounts.size() + '| ';
			
  			for (Object billingAccount : selectedBillingAccounts) {
				Map<String, Object> objBilling = (Map<String, Object>) billingAccount;

				Id billingAccountId = (Id) objBilling.get('Id');
				Task taskObject = new Task();

				//debug += 'Se agrega billingAccountId: '+ billingAccountId+' en: '+ caseId + ' | ';

				taskObject.Subject = 'Actualización de cuenta de facturación: ' + billingAccountId;
				taskObject.Description = 'Nuevo ciclo de facturación: ' + selectedBillingCycle;
				taskObject.Status = 'Not Started';
				taskObject.WhatId = caseId;

				taskList.Add(taskObject);
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
}