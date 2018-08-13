vlocity
	.cardframework
	.registerModule
	.controller('hlrController', HLRCtrl);

	HLRCtrl.$inject = ['$rootScope', '$scope', '$filter'];

function HLRCtrl($rootScope, $scope, $filter) {

	var HLRCtrl = this;	
	
	HLRCtrl.Response = HLRParse($scope.bpTree.response.IFS132_Response);
	console.info("response: ", $scope.bpTree.response.IFS132_Response);
	console.info("HLR-RESPONSE: ", HLRCtrl.Response);

	$scope.toogleOpenRow = function(event) {
		
		var $row = $(event.target).closest('.HLR-info-header');
		var $groupRow = $row.next('.HLR-info-body');		

		event.preventDefault();
		
		$row.toggleClass('activeRow');
		if ($row.hasClass('activeRow')) {
			$groupRow.addClass('activeGroup');
		} else {
			$groupRow.removeClass('activeGroup');
		}
		return;		
	};

	function HLRParse(JSONobject) {
		// JSONobject = JSON.parse(JSONstring);
		//alert(JSON.stringify(JSONobject["estado"]));


		var result = {};
		// console.info("JSONobject: ", JSONobject);
	  
		result["portabilidad"]=getPortabilidad(JSONobject);
		result["estados"]=getEstados(JSONobject);
		result["servicios"]=getServicios(JSONobject);
		result["restricciones"]=getRestricciones(JSONobject);
		result["locacion"]=getLocacion(JSONobject);
		result["regionALM"]=getRegionALM(JSONobject);
		result["voiceMail"]=getVoiceMail(JSONobject);
		result["informacionBDU"]=getInformacionBDU(JSONobject);
		result["smsEncolado"]=getSMSEncolado(JSONobject);
		result["autenticacion"]=getAutenticacion(JSONobject);
		result["autenticacion3G"]=getAutenticacion3G(JSONobject);
		result["camel"]=getCamel(JSONobject);
		result["hssSubscriberData"]=getHSSSuscriberData(JSONobject);
		result["hssSubscriberCategorias"]=getCategorias4G(JSONobject);
	  
		// document.getElementById("result").innerHTML = JSON.stringify(result);

		return result;
		
	  }
	  
	  
	  //1.-Portabilidad
	  function getPortabilidad(JSONobject){
		  return JSONobject["portabilidad"];
	  }
	  
	  //2.-Estado
	  function getEstados(JSONobject){
		  return getListado("estado", JSONobject);
	  }
	  
	  //3.-Servicios
	  function getServicios(JSONobject){
		  return getListado("serviciosActivos", JSONobject);
	  }
	  
	  //4.-Restricciones
	  function getRestricciones(JSONobject){
		  return getListado("restriccion", JSONobject);
	  }
	  
	  //5.-Locacion
	  function getLocacion(JSONobject){
		  var resultado = {};
		  resultado["pre"] = {}; 
		  resultado["pre"]["card"] = JSONobject["marca"] +" - "+ JSONobject["modelo"] +" - "+ JSONobject["imeiDelTerminal"];
		  resultado["pre"]["locacionDelMovil"]=JSONobject["locacionDelMovil"];
		  resultado["pre"]["locacionGPRS"]=JSONobject["locacionGPRS"];
		  resultado["pre"]["marca"]=JSONobject["marca"];
		  resultado["pre"]["modelo"]=JSONobject["modelo"];
		  resultado["pre"]["tecnologia"]=JSONobject["tecnologia"];
		  resultado["pre"]["imeiDelTerminal"]=JSONobject["imeiDelTerminal"];
		  resultado["mtMobileSubscriberStat"]=JSONobject["mtMobileSubscriberStat"];
		  return resultado;
	  }
	  
	  //6.-Region ALM
	  function getRegionALM(JSONobject){
		  return JSONobject["regionALM"];
	  }
	  
	  //7.-Voice Mail
	  function getVoiceMail(JSONobject){
		  var resultado = {}; 
		  resultado["card"] = "Voice Mail";
	  
		  resultado["voiceMail"] = JSONobject["voiceMail"];
		  resultado["voiceMailCategoria"] = JSONobject["voiceMailCategoria"];
	  
		  return resultado;
	  }
	  
	  //8.-Informacion BDU
	  function getInformacionBDU(JSONobject){
		  var resultado = {}
		  resultado["hlr"] = JSONobject["hlr"];
		  resultado["hlrSubscriberData"] = {};
		  resultado["hlrSubscriberData"]["resumen"]=JSONobject["hlrSubscriberData"]["nivel1"][0]["nivel2"][0]["nivel3"];
		  resultado["hlrSubscriberData"]["detalle"]=JSONobject["hlrSubscriberData"]["nivel1"][1]["nivel2"];
		  return resultado;
	  }
	  
	  //9.-SMS Encolado
	  function getSMSEncolado(JSONobject){
		  var resultado = {}
		  resultado["estadoSMSEncolado"] = JSONobject["estadoSMSEncolado"];
		  resultado["smsEncolado"] = {};
		  resultado["smsEncolado"]["estadoDelMovil"]=JSONobject["smsEncolado"]["nivel1"][0]["nivel2"][0]["nivel3"];
		  resultado["smsEncolado"]["centroMensajeria"]=JSONobject["smsEncolado"]["nivel1"][0]["nivel2"][0]["nivel3"];
		  return resultado;
	  }
	  
	  //10.-Autenticacion
	  function getAutenticacion(JSONobject){
		  return JSONobject["autentificacion"];
	  }
	  
	  //11.-Autenticacion 3G
	  function getAutenticacion3G(JSONobject){
		  return JSONobject["autentificacion3G"];
	  }
	  
	  //12.-Camel
	  function getCamel(JSONobject){
		  return JSONobject["camel"]["nivel1"][0]["nivel2"];
	  }
	  
	  //13.-HSS Suscriber Data
	  function getHSSSuscriberData(JSONobject){
		  return JSONobject["hssSubscriberData"]["nivel1"][0]["nivel2"][0]["nivel3"];   
	  }
	  
	  //14.-Categorias 4g
	  function getCategorias4G(JSONobject){
		  return JSONobject["hssSubscriberCategorias"]["nivel1"][0]["nivel2"][0]["nivel3"];
	  }
	  
	  function getListado(bloque,JSONobject){
		  var object = {};    
		  var activos = JSONobject[bloque]["activo"];
		  var inactivos = JSONobject[bloque]["inactivo"];
	  
		  object["cantInactivos"] = inactivos.length;
		  object["cantActivos"] = activos.length;
	  
		  if (bloque == "estado"){
		     if(activos.length > 0) {
		         object["card"] = activos[0]["cdesc"];
			 }else{
			     object["card"] = "No hay servicios activos";   
		     }
			  
		  }else if (bloque == "serviciosActivos"){
			  object["card"] = "Servicios ("+object["cantActivos"]+")";
		  }else if (bloque == "restriccion"){
			  object["card"] = "Restricciones ("+object["cantActivos"]+")";
		  }
	  
		  object["activos"]=[];
		  for(var i = 0; i < activos.length; i++){
			  object["activos"][i]= {}
			  object["activos"][i]["Content"]=[];
			  object["activos"][i]["Name"]=activos[i]["cdesc"];
			  values=activos[i]["vdesc"];
			  for (var j = 0; j < values.length ; j++){
				  object["activos"][i]["Content"][j]={};
				  object["activos"][i]["Content"][j]["ideal"]=values[j][0];
			  }
		  }
	  
		  object["inactivos"]=[];
		  for(var i = 0; i < inactivos.length; i++){
			  object["inactivos"][i]= {};
			  object["inactivos"][i]["Content"]=[];
			  object["inactivos"][i]["Name"]=inactivos[i]["cdesc"];
			  values=inactivos[i]["vdesc"];
			  for (var j = 0; j < values.length ; j++){
				  object["inactivos"][i]["Content"][j]={};
				  object["inactivos"][i]["Content"][j]["ideal"]=values[j][0];
				  object["inactivos"][i]["Content"][j]["actual"]=values[j][1];
			  }
		  }
		  return object;
	  }