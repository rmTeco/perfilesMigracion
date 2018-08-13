vlocity.cardframework.registerModule.controller('BillingAccountsController', ['$scope', function($scope) {
        
    $scope.bpTree.response.InvalidAccounts = [];
    var myModule = angular.module('taBillingGroupChanges', modules);
    var bac = this;
    var resultCloseCase;
    
    bac.checkAll = checkAll;
    bac.verifyChecker = verifyChecker;
    
    
    function checkAll(ba) {
    
        baIsSelected = ba.isSelected;
        ba.isReferenced = ba.isSelected;
        
        if(angular.isArray(ba.Assets)){
            angular.forEach(ba.Assets, function(lines){
                if (lines.Status == "Active"){
                    lines.isSelected = baIsSelected;
                }
            });
        } else {
            ba.Assets.isSelected = ba.isSelected;
        }
        
        if (ba.PurchaseFinancing || ba.DebtFinancing){
            if (ba.isSelected){
                IncludeInvalidAccount(ba.Name);
            } else{
                RemoveInvalidAccount(ba.Name);
            }
        }
    }                                  
        
    function verifyChecker(ba){

        var count = 0;
        var checkeds = 0;

        if(angular.isArray(ba.Assets)){
                
            angular.forEach(ba.Assets, function(lines){
                if (lines.Status == "Active"){
                    count++;
                }
                if(lines.isSelected) 
                    checkeds++;
            });
            ba.isSelected = (count == checkeds);

            ba.isReferenced = ba.isSelected;
            
            if (ba.PurchaseFinancing || ba.DebtFinancing){
                if (checkeds > 0){
                    IncludeInvalidAccount(ba.Name);
                } else{
                    RemoveInvalidAccount(ba.Name);
                }
            }
        } else {
            ba.isSelected = ba.Assets.isSelected;
            ba.isReferenced = ba.isSelected;
             if (ba.PurchaseFinancing || ba.DebtFinancing){
                if (ba.isSelected){
                    IncludeInvalidAccount(ba.Name);
                } else{
                    RemoveInvalidAccount(ba.Name);
                }
             }
        }
        
        
    }
                
    function IncludeInvalidAccount(name){
        if (!hasName($scope.bpTree.response.InvalidAccounts, name)){
            $scope.bpTree.response.InvalidAccounts.push(name);
        }
    }
    
    function RemoveInvalidAccount(name){
        $scope.bpTree.response.InvalidAccounts.pop(name);
    }
    
    function hasName(data, name) {
        return data.some(function (el) {
            return el === name;
        });
    }
        
}]);