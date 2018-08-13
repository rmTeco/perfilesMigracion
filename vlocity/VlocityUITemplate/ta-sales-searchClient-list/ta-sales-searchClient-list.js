console.info('SFORCE: ', sforce);
vlocity.cardframework.registerModule.controller('SearchClientController', ['$scope','remoteActions',function($scope) {
    var scc = this;
    scc.activeMessageBlacklist = false;
    scc.init = init;
    scc.setTabActive = setTabActive;
    scc.updateContactEmail = updateContactEmail;
	scc.checkClientsAndRedirect = checkClientsAndRedirect;
	scc.openGestionDeClientesInPrimaryTab = openGestionDeClientesInPrimaryTab;
    
    function init(control) {
        $scope.$watch('control.vlcSI[control.itemsKey][0]', function(newVal, oldVal){
            scc.activeMessageBlacklist = false;
            _setDefaultTab(newVal);
        });
        console.log('INIT'+control);
        console.info('INIT'+control);
       /* remoteActions.getDataViaDynamicSoql('SELECT ApplicationId,Name,Label FROM AppMenuItem where Name=\'Consola_FAN\'').then(function(payload) {
            scc.obj = JSON.parse(payload);
            if(scc.obj.length==0){
                console.log('There is no Consola_FAN App in Org');
            }
            else
            scc.AppId=obj[0].ApplicationId;
            console.log('APPID',scc.AppId);
          }); */
    }
    
    function setTabActive(tabName) {
        scc.tabActive = tabName;
    }

    function updateContactEmail(contactId, emailUpdated) {
        Visualforce.remoting.Manager.invokeAction(
            "taClientSearchController.UpdateContact", contactId, emailUpdated,
                    function(result, event) {
                        console.info('ContactSearcher.UpdateContact: ', result, event);
                    },
            {escape: false} // No escaping, please
        );
    }

    function _setDefaultTab(searchResult) {
        scc.tabActive = 'activeClientes';
        angular.forEach(searchResult, function(value, key) {
            if (value.length) {
                scc.tabActive = key;
                return;
            }
        });
	}
	
	function checkClientsAndRedirect(record, redirectTo) {
	    debugger;
		console.info('Record: ', record);
		
		var url = '/apex/taSalesCreateOrder?contactId=' + record.PrimaryContactId + '&accountId=' + record.AccountId;
		
		console.info('Url: ', url);
		
		switch (redirectTo) {
			case 'CPQ':	
				// url = '/apex/%vlocity_namespace%__OmniScriptUniversalPage?id={0}&accountId=' + record.AccountId + '&contactId=' + record.PrimaryContactId + '&layout=lightning#/OmniScriptType/Sales/OmniScriptSubType/ExistingAccountNewLineSale/OmniScriptLang/English/ContextId/{0}/PrefillDataRaptorBundle//true';
				url += '&operationCode=VTLNCE';
				break;
			case 'NewBilling':
				// url = '/apex/%vlocity_namespace%__OmniScriptUniversalPage?id={0}&accountId=' + record.AccountId + '&contactId=' + record.PrimaryContactId + '&layout=lightning#/OmniScriptType/Sales/OmniScriptSubType/NewLineNewBillingAccountSale/OmniScriptLang/English/ContextId/{0}/PrefillDataRaptorBundle//true';
				url += '&operationCode=VTLNCB&newBilling=true';
				break;
		}
		
		Visualforce.remoting.Manager.invokeAction(
            "taClientSearchController.CheckAccountsStatus", record.AccountId, record.DocumentNumber, record.DocumentType,
                    function(result, event) {
                        if (result === 'true') {
                            scc.activeMessageBlacklist = true;
                        }
                        else {
                            scc.activeMessageBlacklist = false;
                            window.location.href = url;
                        }
                        
                        $scope.$apply();
                    },
            {escape: false} // No escaping, please
        );
	}
	
        
    function openGestionDeClientesInPrimaryTab(accountId) {
        var url ;
        if(sforce.console.isInConsole()){
         url = '/' + accountId;
         sforce.console.openPrimaryTab(null, url, true);
        }
        /*else{
          url='/console?tsid='+AppId+'&useCache=false#%2f'+accountId ;
           window.location.href = url 
        } */
        // sforce.console.openPrimaryTab(id:String, url:URL, active:Boolean,(optional)tabLabel:String, (optional)callback:Function, (optional)name)
    }
}]);