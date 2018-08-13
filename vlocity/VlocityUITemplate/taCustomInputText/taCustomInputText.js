vlocity
    .cardframework
    .registerModule
    .controller('CustomInputTextController', CustomInputTextController);
    
    CustomInputTextController.$inject=['$scope'];
    function CustomInputTextController($scope) {
        var citc = this;
        
        citc.init = init;
        
        function init() {
            // console.info('BPTREE: ', $scope.bpTree.response);
            $scope.$watch('bpTree.response.ContactSearch.DocumentTypeSearch', _changeInputFieldSettings);
        }
        
        function _changeInputFieldSettings(newVal, oldVal) {
            if (newVal != oldVal) {
				var minLenght = 0;
				var maxLenght = 255;

				citc.documentType = newVal;
				// console.info('DocumentType: ', newVal);

               	switch (newVal) {
					case 'DNI':
					case 'LEN':
					case 'LCV':
						minLenght = 7;
						maxLenght = 8;
						break;
					case 'CUIT':
						minLenght = 11;
						maxLenght = 11;
						break;
			   	}
			   $scope.child.eleArray[0].propSetMap.minLength = minLenght;
			   $scope.child.eleArray[0].propSetMap.maxLength = maxLenght;
            }
        }
    }