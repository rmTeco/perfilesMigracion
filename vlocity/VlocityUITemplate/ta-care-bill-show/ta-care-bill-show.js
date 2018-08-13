vlocity.cardframework.registerModule
    .controller('cardShowBillController',
                ['$scope', 'interactionTracking', '$timeout', '$interval', '$filter','$rootScope',
                    function($scope, interactionTracking, $timeout, $interval, $filter, $rootScope){ 
                        
                        var interactionData = interactionTracking.getDefaultTrackingData($scope);
                        
    $scope.init = function(){
        
        /*********************************** Intento 3 *******************************************/
        
        console.log("DATAAAA = ", $scope.data);
        console.log("OBJJJ = ", $scope.obj);
        console.log("PARAMSs = ", $scope.params);
        
        
        /**********************************************************************************************/
        

        function b64toBlob(b64Data, contentType, sliceSize) {
          contentType = contentType || '';
          sliceSize = sliceSize || 512;
        
          var byteCharacters = atob(b64Data);
          var byteArrays = [];
        
          for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
            var slice = byteCharacters.slice(offset, offset + sliceSize);
        
            var byteNumbers = new Array(slice.length);
            for (var i = 0; i < slice.length; i++) {
              byteNumbers[i] = slice.charCodeAt(i);
            }
        
            var byteArray = new Uint8Array(byteNumbers);
        
            byteArrays.push(byteArray);
          }
            
          var blob = new Blob(byteArrays);
          return blob;
        }
        
        var b64Data = $scope.obj.pagedatabytes;
        
        var blob = b64toBlob(b64Data);
        
        
        $scope.showFile = function (blob) {
          // It is necessary to create a new blob object with mime-type explicitly set
          // otherwise only Chrome works like it should
          var newBlob = new Blob([blob], {type: "application/pdf"});
          var newBlobImg = new Blob([blob], {type: "image/png"});
          // IE doesn't allow using a blob object directly as link href
          // instead it is necessary to use msSaveOrOpenBlob
          /*if (window.navigator && window.navigator.msSaveOrOpenBlob) {
            window.navigator.msSaveOrOpenBlob(newBlob);
            return;
          } */
         
          // For other browsers: 
          // Create a link pointing to the ObjectURL containing the blob.
          
          //$scope.data = window.URL.createObjectURL(newBlob);
          $scope.data = URL.createObjectURL(newBlob);
          $scope.data2 = $scope.data + "#toolbar=0&navpanes=0&scrollbar=0";
          $scope.data3 = window.URL.createObjectURL(newBlobImg);
          $scope.link = document.createElement('a');
          $scope.link.href = $scope.data;
          console.log("$scope.params.nroComprobante = ",$scope.params.nroComprobante);
          if($scope.params.nroComprobante === undefined){ 
              $scope.link.download="file.pdf";
          }else{
              $scope.link.download = $scope.params.nroComprobante + ".pdf";
          }
         // $scope.link.click();
         
         // $scope.link.download="file.pdf";
         
          
        }
        
        $scope.donwloadFile = function () {
            console.log("donwloadFile");
            $scope.link.click();
            $scope.CapturarDescarga();
            
            
            //$scope.performAction($scope.data.actions[0]);
        }
        
        $scope.printFile = function () {
            console.log("printFile");
            $scope.CapturarImpresion();
            //$scope.performAction($scope.data.actions[0]);
        }
        
        $scope.showFile(blob);
        
        /************************************ Tracking ************************************/
    
     $scope.CapturarImpresion = function(){
          $scope.CapturarEvento('Imprimir Comprobante');
     }
     
     $scope.CapturarDescarga = function(){
          $scope.CapturarEvento('Descargar Comprobante');
     }
    
    $scope.CapturarEvento = function(evento){
        var interactionData = interactionTracking.getDefaultTrackingData($scope);
        var query = 'Vista: Resumen de cuenta corriente'
                    + ' - NumeroCuenta: ' + $scope.params.nroCuenta
                    + ' - NumeroComprobante ' + $scope.params.nroComprobante;

        var accion = evento;
        var eventData = {
                'TrackingService': 'Acuity',
                'TrackingEvent' : 'Resumen de cuenta',
                'Criteria' : query,
                'TrackedAction' : accion,
                'TrackedCard' : 'Resumen de Cuenta Corriente'
            };
            interactionData = angular.extend(interactionData, eventData);
            interactionTracking.addInteraction(interactionData);
    }
    }
    

}]);