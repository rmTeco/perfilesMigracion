vlocity.cardframework.registerModule.controller('tableCtrl',
    ['$rootScope', 
     '$scope', 
     '$filter', function($rootScope, $scope, $filter) {

    $scope.sortingOrder = '';
    $scope.reverse = false;
    
    
    
    //Items after dividing for different pages
    $scope.pagedItems = [];
    //Determines item per page
    $scope.itemsPerPage = 5;
    //Current selected page
    $scope.currentPage = 0;
    //List includes items per page options
    $scope.numberOfRowsOption = [5, 10, 20];
    //number of items per page
    $scope.numberOfPageLinks = 5;
    
     $scope.sortBy = function(newSortingOrder,$event) {
        $scope.reverse = !$scope.reverse;
        $scope.sortingOrder = newSortingOrder.name;
        
        if ($scope.sortingOrder !== '') {
            $scope.records = $filter('orderBy')($scope.records, $scope.sortingOrder, $scope.reverse);
            $("thead th a.active").removeClass('active');
            $event.currentTarget.classList.add("active");
        }else {
            $event.currentTarget.classList.remove("active");
        }
    };
    
        //To divide cards object in different pages.
    $scope.groupToPages = function (itemsPerPage) {
        $scope.pagedItems = [];
        var ret = [];
        $scope.itemsPerPage = (itemsPerPage) ? itemsPerPage : $scope.itemsPerPage;
        console.log("itemsPerPage: " + $scope.itemsPerPage);
        
        for (var i = 0; i < $scope.records.length; i++) {
            if (i % $scope.itemsPerPage === 0) {
                ret[Math.floor(i / $scope.itemsPerPage)] = [$scope.records[i]];
            } else {
                ret[Math.floor(i / $scope.itemsPerPage)].push($scope.records[i]);
            }
            console.log("ITEMS: " + ret);
        }

        $scope.currentPage = 0;
        $scope.previousPage = 0;
        $scope.nextPage = $scope.currentPage+1;
        
        $scope.pagedItems = ret;
        $scope.range();
    };
    
    //To create pagination links
    $scope.range = function () {
        var size = $scope.pagedItems.length;
        var start = $scope.currentPage;
        
        $scope.currentRange = []; 
        var end = $scope.currentPage + $scope.numberOfPageLinks;
        
        if (size < end) {
            end = size;
            start = size - $scope.numberOfPageLinks;
            if(start < 0){
                start = 0;
            }
        }
        for (var i = start; i < end; i++) {
            $scope.currentRange.push(i);
        }
    };
    
    //To visit a particular page
    $scope.goToPage = function(pageNumber){
        $scope.currentPage = pageNumber;
        $scope.previousPage = pageNumber - 1;
        $scope.nextPage = pageNumber + 1;
        $scope.range();
    }
    
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