vlocity.cardframework.registerModule.controller('containerTableCanvarController',
['$rootScope', '$scope',  '$filter', function($rootScope, $scope, $filter, $window) {
    
    
    var self=this;
    console.log('log inicio');
    console.info('info inicio');
    
    this.favoriteBeatle = 0;
    //this.itemChecked = Boolean(false) ;
    
    this.searchTerm1 = '';
    this.filteredItems=[];
    
    self.workList=[];
    
     this.init = function(){
        console.info('en el init');
        self.bpTree=$scope.bpTree;
        console.info('tree', $scope.bpTree);
        //self.workList=$scope.getCardList();
        self.workList=$scope.bpTree.response.listaInfoPagos;
        //tcc.bpTree.response.listaInfoPagos.infoPago
        console.log('en le init, worklist', self.workList);
        
       
    }
    
    //setTimeout(function(){
      //  console.info('tree2111', $scope.bpTree.response.listaInfoPagos);
        // },20000);
    
    //cards[0].states[0].fields
    
   
    $scope.radioChange = function () {
        
        $scope.bpTree.response.credicardpayment=$scope.bpTree.response.listaInfoPagos.infoPago[self.favoriteBeatle];
            
        
        //$.each($scope.bpTree.response.listaInfoPagos.infoPago,function(index, value){
            /*if (self.itemChecked!==undefined && self.itemChecked === true ){
              
                 $scope.bpTree.response.credicardpayment=null;
                 self.favoriteBeatle= false;
                 
               
          
           }else if(value.idCuenta==self.favoriteBeatle){
                
                $scope.bpTree.response.credicardpayment=value;
               
            }*/
          //  if(value.idCuenta==self.favoriteBeatle){
                
            //    $scope.bpTree.response.credicardpayment=value;
               
            //}
            
            
            
        //});
            
    };
    
    
    $scope.checkChange = function () {
        if (self.itemChecked!==undefined && self.itemChecked === true ){
            $scope.bpTree.response.credicardpayment=null;
            self.favoriteBeatle= false;
            
            jQuery("input[name='index']").each(function(i) {
                jQuery(this).attr('disabled', 'disabled');
            });

        }
        else{
            jQuery("input[name='index']").each(function(i) {
                jQuery(this).attr('disabled', false);
            });
        }
    };
  
    
    $scope.getCardList = function(){
        return $scope.cards[0].states[0].fields;
    }
    
    
    
    window.scope = $scope;
    window.root = $rootScope;
    window.paren = $scope.$parent
    
    
}]);