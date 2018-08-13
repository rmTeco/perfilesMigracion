/* Please use vlocity.cardframework.registerModule to register your Angular Controller */
vlocity
    .cardframework
    .registerModule
    .controller('TACPQCategoriesController', TACPQCategoriesController);
    
    TACPQCategoriesController.$inject = ['$scope', '$rootScope'];
    function TACPQCategoriesController($scope, $rootScope) {
        $scope.isCategoryExpanded = true;
        
        $scope.selectedCategory = 'All';
        
        $scope.$on('isCategoryExpanded', function(event, data) {
            $scope.isCategoryExpanded = data;
            
        });
        
        // $scope.defaultCategory = $scope.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.session.defaultCategory;
        
        
        $scope.isSelectedCategory = function(categoryName) {
            
            return categoryName === $scope.selectedCategory;
        }

        $scope.selectCategory = function(category) {
            console.log("Selected: ", category);
            if (category === 'All') {
                $scope.selectedCategory = 'All';
                $rootScope.selectedCategory = 'All';
            } else {
                $scope.selectedCategory = category.catalogName;
                $rootScope.selectedCategory = category.catalogName;
            }
            
            $rootScope.$broadcast('category', category);
            
        }
        
        $scope.expandCategory = function() {
            $scope.categoryExpanded = !$scope.categoryExpanded;
            $scope.$broadcast('isCategoryExpanded', $scope.categoryExpanded);
        }
        
        $scope.initCategory = function(category) {
            $scope.selectedCategory = category.catalogName;
            $rootScope.selectedCategory = category.catalogName;
        }
    }