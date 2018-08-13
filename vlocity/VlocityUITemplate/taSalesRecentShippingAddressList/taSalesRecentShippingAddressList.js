vlocity
    .cardframework
    .registerModule
    .controller('RecentShippingAddressController', RecentShippingAddressController);

    RecentShippingAddressController.$inject = ['$rootScope','$scope'];
    function RecentShippingAddressController($rootScope, $scope) {
    	var rsac = this;
    	
    	var init = function () {
    	    console.info("pepe");
    	    //console.info(control.vlcSI[control.itemsKey]);
    	    //console.info($control.vlcSI[control.itemsKey]);
    	    console.info($scope.bpTree.response.ShippingAddressCloneOrder);
    	    console.info($scope.bpTree.response.recentShippingAddress);
    	    angular.forEach($scope.bpTree.response.recentShippingAddress, function(value, key) {
    	        console.info(value);
            if ($scope.bpTree.response.ShippingAddressCloneOrder && value.ShippingStreet1 == $scope.bpTree.response.ShippingAddressCloneOrder.SidestreetA && value.ShippingStreet2 == $scope.bpTree.response.ShippingAddressCloneOrder.SidestreetB && value.ShippingPostalCode == $scope.bpTree.response.ShippingAddressCloneOrder.PostalCode && value.ShippingApartment == $scope.bpTree.response.ShippingAddressCloneOrder.Department && value.ShippingFloor == $scope.bpTree.response.ShippingAddressCloneOrder.Floor && value.ShippingStreetNumber == $scope.bpTree.response.ShippingAddressCloneOrder.StreetNumber && value.ShippingStreet == $scope.bpTree.response.ShippingAddressCloneOrder.Street && value.ShippingCity == $scope.bpTree.response.ShippingAddressCloneOrder.City && value.ShippingStateCode == $scope.bpTree.response.ShippingAddressCloneOrder.State)
            
                rsac.selectedAddress(value);
    	    });
        }
    	
        rsac.selectedAddress = function(address) {
            console.info("SelectedAddress");
            console.info($scope.bpTree.response.ShippingAddressData);
            rsac.activeAddress = address;
            //$scope.bpTree.response.ShippingAddressData.isRecentAddressSelected = true;
            
    	    $scope.bpTree.response.ShippingAddressData.Address.SidestreetA = address.ShippingStreet1;
    	    $scope.bpTree.response.ShippingAddressData.Address.SidestreetB = address.ShippingStreet2;
    	    $scope.bpTree.response.ShippingAddressData.Address.PostalCode = address.ShippingPostalCode;
    	    $scope.bpTree.response.ShippingAddressData.Address.Department = address.ShippingApartment;
    	    $scope.bpTree.response.ShippingAddressData.Address.Floor = address.ShippingFloor;
    	    $scope.bpTree.response.ShippingAddressData.Address.StreetNumber = address.ShippingStreetNumber;
    	    $scope.bpTree.response.ShippingAddressData.Address.Street = address.ShippingStreet;
    	    $scope.bpTree.response.ShippingAddressData.Address.City = address.ShippingCity;
    	    $scope.bpTree.response.ShippingAddressData.Address.State = address.ShippingStateCode;
    	    $scope.bpTree.response.ShippingAddressData.Address.Ids = address.OrderIds;
    	    $scope.bpTree.response.ShippingAddressData.Address.showDeleted = false;
    	    
    	    $scope.bpTree.response.ShippingAddressData.isRecentAddressSelected = true;
    	}
    	// $scope.bpTree.response.ShippingAditionalInformation
    	// $scope.bpTree.response.ShippingStateCode
    	
    	init();

        
    }