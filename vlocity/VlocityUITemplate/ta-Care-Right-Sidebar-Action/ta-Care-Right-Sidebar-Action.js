vlocity
        .cardframework
        .registerModule
        .controller('TACareRightSidebarActionController', TACareRightSidebarActionController);
        
    TACareRightSidebarActionController.$inject = ['$scope', '$rootScope'];
    function TACareRightSidebarActionController($scope, $rootScope) {
        
        console.info("6669");
        console.info($scope.data);
        // Public Fields
        var tcrsa = this;
        
        // Public Methods
        tcrsa.init = init;
        tcrsa.showAction = showAction;
        tcrsa.itemsLimit = 6;
    
        // Method Definitions
        function init() {
            
           
        }
        
        //Mostrar 'Modificar Plazo de Permanencia, sólo si es cliente extranjero y fecha de permanencia expira en 7 días'
        function showAction(action){

            var show = true;
            if(action=='ExpiryForeignDate'){
                if($scope.data.obj && $scope.data.obj.Contact && $scope.data.obj.Contact.DocumentType && $scope.data.obj.Contact.DocumentType == "PAS"){
                    if($scope.data.obj.Contact.PermanencyDueDate){
                        var today = new Date();
                        var oneWeekBefore = new Date($scope.data.obj.Contact.PermanencyDueDate);
                        var dueDate = new Date($scope.data.obj.Contact.PermanencyDueDate);
                        oneWeekBefore.setDate(oneWeekBefore.getDate() - 7);
                        dueDate.setDate(dueDate.getDate());
                        console.info("today" + today);
                        console.info("dueDate" + dueDate);
                        console.info("oneWeekBefore" + oneWeekBefore);
                        console.info((+today <= +dueDate) && (+today >= +oneWeekBefore)) ;
                        if ((+today <= +dueDate) && (+today >= +oneWeekBefore)) 
                        
                        {
                            show = true;    
                        } else {
                            show = false;
                        }
                        
                    } else {
                        show = true;
                    }
                    
                } else {
                    show = false;
                }
            }
            
            return show;
            
        }
        
        /*PFTA-7022*/
        function removeAccents(value) {
            return value
                .replace(/á/g, 'a')            
                .replace(/é/g, 'e')
                .replace(/í/g, 'i')
                .replace(/ó/g, 'o')
                .replace(/ú/g, 'u');
        }
        
        /*PFTA-7022*/
        $scope.ignoreAccents = function(item) { 
            //filter:{'displayName':searchTerm}
            //console.log('--->>>>>>>>>',item);
            if (!$scope.searchTerm)
                return true;       
            var text = removeAccents(item.displayName.toLowerCase())
            var search = removeAccents($scope.searchTerm.toLowerCase());
            return text.indexOf(search) > -1;
        };
        /**/
        

    }