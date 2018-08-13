vlocity.cardframework.registerModule.controller.$inject = ['$scope', '$timeout', '$rootScope'];
vlocity.cardframework.registerModule.controller('SMSCounterController', function($scope, $timeout, $rootScope) {

    var vm = this;
    var bpTree = $scope.bpTree;
    var myTimeout = null;

    // delete $scope.bpTree.response.SMSTry;
    // delete $scope.bpTree.response.SMSCounterSeconds;
    delete $scope.bpTree.response.SMSConfig.AttemptsCounter;
    delete $scope.bpTree.response.SMSConfig.CounterSeconds;
    
    $scope.bpTree.response.SMSConfig.AttemptsCounter = 0;
    
    function init() {
        // $scope.bpTree.response.SMSConfig.CounterSeconds = convertMinutesToSeconds(1);
        // console.info('init');
        $scope.bpTree.response.SMSConfig.CounterSeconds = $scope.bpTree.response.SMSConfig.AttemptsDelay;
        $scope.bpTree.response.SMSConfig.AttemptsCounter++;
        onTimeout();
    }
    
    $scope.$watch('bpTree.response.SendSMS_Response', function(newValue, oldValue) {
        // console.info('bpTreee', newValue);
        if(newValue) init();
            delete bpTree.response.SendSMS_Response;
    }, true);

    function convertMinutesToSeconds(value) {
        return (value * 1) * 60;
    }
    
    function onTimeout(){
        if($scope.bpTree.response.SMSConfig.CounterSeconds)
            $scope.bpTree.response.SMSConfig.CounterSeconds--;
            
        myTimeout = $timeout(onTimeout,1000);
        if ($scope.bpTree.response.SMSConfig.CounterSeconds === 0) {
            // gc.showErrorTimeout = true;
            stop();
        }
    }

    function stop(){
        $timeout.cancel(myTimeout);
    }
});

// vlocity.cardframework.registerModule.filter("secondsToDateTime", function() {
//     return function(seconds) {
//         return new Date(1970, 0, 1).setSeconds(seconds);
//     };
// });