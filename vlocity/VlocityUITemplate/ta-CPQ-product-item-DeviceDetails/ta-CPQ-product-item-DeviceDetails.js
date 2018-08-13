vlocity
    .cardframework
    .registerModule
    .controller('DeviceMoreDetailsController', DeviceMoreDetailsController);
    
    DeviceMoreDetailsController.$inject = ['$scope', '$rootScope'];
    
    function DeviceMoreDetailsController($scope, $rootScope) {
        var dmdc = this;
        
        dmdc.init = init;
        dmdc.attributes;
        dmdc.details = {};
        
        function init() {
            console.info("obj: ", $scope.obj);
            dmdc.attributes = $scope.records[0].Product2.%vlocity_namespace%__JSONAttribute__c;
            readJSONAttribute();
            console.info(dmdc.details);
        }
        
        function readJSONAttribute(){
            angular.forEach(dmdc.attributes, function(item){
                        
                for(var j=0; j<item.length; j++){
                    dmdc.details[item[j].attributedisplayname__c] = item[j].attributeRunTimeInfo.default; 
                }
                        
            });
        }
    }