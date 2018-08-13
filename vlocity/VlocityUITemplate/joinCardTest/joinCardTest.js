vlocity.cardframework.registerModule
.controller('joinCardTestController',
        ['$scope', '$timeout', '$interval', '$filter',
            function($scope, $timeout, $interval, $filter) {

    console.log('controller')
    $scope.init = function(){
        console.log('init')
        window.scope = $scope;
    }