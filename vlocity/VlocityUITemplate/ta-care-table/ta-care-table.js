vlocity.cardframework.registerModule.controller('tableCtrl',
    ['$rootScope', 
     '$scope', 
     '$filter', function($rootScope, $scope, $filter) {

    $scope.sortingOrder = '';
    $scope.reverse = false;
    
     $scope.sortBy = function(newSortingOrder) {
        $scope.reverse = !$scope.reverse;
        $scope.sortingOrder = newSortingOrder.name;
        
        if ($scope.sortingOrder !== '') {
            $scope.records = $filter('orderBy')($scope.records, $scope.sortingOrder, $scope.reverse);
        }
    };
    var ctrl = this;
    ctrl.mobile = false;
    $scope.init = function (){
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {
            // Take the user to a different screen here.
            ctrl.mobile = true;
        }
        
         $(document).ready(function(){
            $('.accordion').click(function() {
                console.log('asda');
                var acc = $(this);
                
                console.log(acc.next());
                acc.next().addClass("active");
                if (acc.next().css( "display") === "block") {
                    acc.next().css( "display", "none" );
                } else {
                    acc.next().css( "display", "block" );
                }
               
               /* 
            var acc = $('.accordion');
            var i;
            
            console.log(acc);
            for (i = 0; i < acc.length; i++) {
                acc[i].onclick = function(){
                    this.classList.toggle("active");
            
                    var panel = this.nextElementSibling;
                    console.log('next no se que');
                    console.log(panel);
                    if (panel.style.display === "block") {
                        panel.style.display = "none";
                    } else {
                        panel.style.display = "block";
                    }
                }
            }*/
            });
            });
        
    }

}]);