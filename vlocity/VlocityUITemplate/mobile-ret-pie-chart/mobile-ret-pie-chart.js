vlocity.cardframework.registerModule
    .controller('RetPieChartController',
                 ['$scope', '$timeout', '$rootScope', 'MobileService', function($scope, $timeout, $rootScope, MobileService) {
    
    var vm = this;
     
    $scope.createPieChart = function(timeline) {
        var ctx = document.getElementById("ret-pie-chart");
        ctx.height = 300;

        var records = $scope.records;
        var dataMap = {}
        
         _.each(records, function(record) {
            var type =  record[nsPrefix + '__Type__c'];
            var amount = record[nsPrefix + '__Amount__c'];
            if (dataMap[type]) {
                amount += dataMap[type];
            } 
            dataMap[type] =  amount;
        });
        
        var labels = Object.keys(dataMap);
        var values = Object.values(dataMap);
        var colors = MobileService.colorsPicker(values.length);
        
        if (values.length > 0) {
            vm.showChart = true; 
        }         
        
        var chart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Amount ($)',
                    data: values,
                    backgroundColor: colors
                }]
            },
            options: {
                 title: {
                        display: true,
                        position: "top",
                        text: "Statement Amount by Type",
                        fontSize: 18,
                        fontColor: "#111"
                    },
                    legend: {
                        display: true,
                        position: "bottom",
                        labels: {
                            fontColor: "#333",
                            fontSize: 16
                        }
                    },
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true,
                        }
                      
                    }]
                },
                xAxes: [{
                      categorySpacing: 10
                }]
            }

        });
    };

    //Init of graphs
    $scope.createPieChart();
}]);