vlocity.cardframework.registerModule.controller('fileupload', ['$scope','$sce', function($scope, $sce) {
   
 //$( document ).ready(function() {      
 /*    $scope.fileupload = {fileData : '',fileName : ''};
$scope.LoadFile = function(input,i) {

   //var input = document.querySelector('.slds-input');
   var reader = new FileReader();
   var FileName = input.files[i].name ;
    reader.onload = function(e) {
   
      $("#browse-file-preview-doc").append(" <div><iframe width='100' height=100' src='" +e.target.result + "'>preview not avalible </iframe> <p>" +FileName + " </p></div>");
    }
 reader.readAsDataURL(input.files[i]);
  
  
}

$scope.LoadFile1 = function() { 
    
   
    var i;
    var input1 = $scope.fileName ;
    
  /*  for(i=0;i<input1.files.length; i++ ){
        
        $scope.LoadFile(input1,i);
           
    }
}

$scope.setFrame = function(a){
    $("#browse-file-preview-doc").append(" <div><iframe width='100' height=100' src='" +a + "'>preview not avalible </iframe> <p>" +FileName + " </p></div>");
}*/
$scope.getFrameUrl = function(a){
    debugger;
    return $sce.trustAsResourceUrl(a);
}

     
//}); 

 }]);