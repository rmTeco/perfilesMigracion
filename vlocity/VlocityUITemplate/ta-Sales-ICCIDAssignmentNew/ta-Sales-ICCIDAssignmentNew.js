vlocity.cardframework.registerModule.controller('ICCIDAssignmentController', ['$scope', function($scope) {
    var iac = this;
    iac.ICCIDChange = ICCIDChange;
    
    function ICCIDChange(order, line)
    {
        order.serialesReservados = false;
        line.validacionSerial = 'Pend. Validación';
        //checkCompleteInputs(order);
    }
    
    function checkCompleteInputs(order)
    {
        var emptySerial = false;
        
        angular.forEach(order.serialList, function(item)
        {
                if(!item.serial)
                    emptySerial = true;
        });

        if(emptySerial)
        {
            order.serialesReservados = false;
        }else{
            order.serialesReservados = true;
        }
    }
}]);