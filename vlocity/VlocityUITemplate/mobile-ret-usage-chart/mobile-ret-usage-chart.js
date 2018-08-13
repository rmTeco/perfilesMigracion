vlocity.cardframework.registerModule
    .controller('RetLineChartController', ['$scope', '$timeout', '$rootScope', 'MobileService', function($scope, $timeout, $rootScope, MobileService) {
        
        var vm = this;
        
        $scope.createBarChart = function(timeline) {
            var ctx = document.getElementById("ret-line-chart");
            ctx.height = 300;

            var records = $scope.records;
            var dataMap = {}


            var monthNames = ["January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"
            ];

            _.each(records, function(record) {
                var type = record[nsPrefix + '__Type__c'];
                var amount = record[nsPrefix + '__Amount__c'];

                if (type.toLowerCase() === 'mobile data') {
                    var statementDate = moment(record[nsPrefix + '__StatementDate__c'], 'YYYY-MM-DD').toDate();
                    var month = monthNames[statementDate.getMonth()]
                    if (dataMap[month]) {
                        amount += dataMap[month];
                    }
                    dataMap[month] = amount;

                }
            });

            var labels = Object.keys(dataMap);
            var values = Object.values(dataMap);
            
            if (values.length > 0) {
               vm.showChart = true; 
            } 

            var chart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Usage ($)',
                        data: values,
                        backgroundColor: "#008E8E",
                        borderColor: "#008E8E",
                        fill: false,
                        lineTension: 0,
                        radius: 5
                    }]
                },
                options: {
                    title: {
                        display: true,
                        position: "top",
                        text: "Mobile Data Usage",
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
                            stacked: true
                        }]
                    }
                }
            });
        };

        //Init of graphs
        $scope.createBarChart();
    }]);