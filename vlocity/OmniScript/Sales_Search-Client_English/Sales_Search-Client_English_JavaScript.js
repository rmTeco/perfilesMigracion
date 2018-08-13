$(document).ready(function() {
var select=document.getElementById('SearchClientDocumentType');

for (i=0;i<select.length;  i++) {
   if (select.options[i].value== 'CUIT' || select.options[i].value== 'CUIL') {
     select.remove(i);
   }
}

baseCtrl.prototype.$scope.resetclientcount = function(scp,ctrl)
{

 scp.bpTree.response.ClientsSearchCount = 0;
 scp.bpTree.response.error = '';
scp.bpTree.response.Clients = null;
$('#Clients').scope().control.vlcSI.recSet = null;
}

});