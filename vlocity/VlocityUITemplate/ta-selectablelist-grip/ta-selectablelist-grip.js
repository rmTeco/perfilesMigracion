vlocity
	.cardframework
	.registerModule
	.controller('TASelectableListBPController', TASelectableListBPCtrl);

	TASelectableListBPCtrl.$inject = ['$scope'];

function TASelectableListBPCtrl($scope) {
	var SLCtrl = this;
	
	SLCtrl.updateList = updateList;
	
	function updateList() {
	    var OriginArray = $scope.bpTree.response[$scope.control.propSetMap.selectableItemConfig.inputList];
	    var resultArray = [];
	    var total = 0;
	    var billableTotal = 0;
	    
	    console.info("update list: ", OriginArray);  
	    for(var i=0; i < OriginArray.length; i++ ) {
	        if(OriginArray[i][$scope.control.propSetMap.selectableItemConfig.preSelected] === true) {
	            total += OriginArray[i].Price;
	            
	            if(!OriginArray[i].WarrantyApplies)
	                billableTotal += OriginArray[i].Price;
	            //console.info("true element: ", OriginArray[i]);  
	            resultArray.push(OriginArray[i]);
	        }
	    }
	    
	    $scope.bpTree.response.total = total;
	    $scope.bpTree.response.billableTotal = billableTotal;
	    
	    return resultArray;
	}
}