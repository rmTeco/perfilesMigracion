vlocity.cardframework.registerModule.controller('QAController', ['$scope', '$timeout', function($scope, $timeout) {

    var qac = this;
    qac.counter = 0;
    qac.init = init;
    qac.onTimeout = onTimeout;
    
    function init(counter) {
        qac.counter = convertMinutesToSeconds(counter);
    }
    
    function convertMinutesToSeconds(value) {
        return (value * 1) * 60;
    }
    
    function onTimeout(){
        qac.counter--;
        mytimeout = $timeout(qac.onTimeout,1000);
        if (!qac.counter) {
            stop();
        }
    }

    function stop (){
        $timeout.cancel(mytimeout);
    }
}]);

vlocity.cardframework.registerModule.filter("secondsToDateTime", function() {
    return function(seconds) {
        return new Date(1970, 0, 1).setSeconds(seconds);
    };
});