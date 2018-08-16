({
    doInit : function(component, event, helper) {
    	//Cuando arranque el componente hago que guarde los datos de la account en attributes, de esta manera cuando
    	//se puedan modificar los datos de dirección, etc, se reemplace los nuevos valores en esos attributes, igualmente
    	//habría que repensar todo ya que hoy en día no se puede modificar la shipping address.
    	
    	//Agregado KAL-67
		var action = component.get("{!c.getUserComunidad}");
		action.setCallback(this, function(response) {
			if(response.getState() === 'ERROR') {
				if(response.getError()[0].message) {
					alert('Error: ' + response.getError()[0].message);
				}
			}
			if(response.getReturnValue() != null){
					var direccionCompletaMap = response.getReturnValue();
					var calle = response.getReturnValue().Calle;
					var numeroCalle = response.getReturnValue().Numero;
					var direccionConNumero = calle + " " + numeroCalle;
					component.set("v.direccionConNumero", direccionConNumero);
					var provincia = response.getReturnValue().Provincia; //debería ser CABA
					component.set("v.provincia", provincia);
					var city = response.getReturnValue().Localidad; //podría ser buenos aires
					component.set("v.city", city);
					var codPostal = response.getReturnValue().CodigoPostal;
					component.set("v.codPostal", codPostal);
			}
		})
		$A.enqueueAction(action);
		//Agregado KAL-67
		
    },
	
  
	navigateToPayment : function(component, event, helper) {				
		component.set("v.Spinner", true);	 
		//var ValidacionesDeEmail = component.get("v.ValidacionesDeEmail");
		var findComp = component.find('datosEnt');	 		
		var domiEntrega = findComp.find("deliveryAdress").get("v.value");
		var documenTypeFinder = findComp.find("documentTypeID").get("v.value");
		var documenNumberFinder = findComp.find("nroDocumentoID").get("v.value");
		var firstNameFinder = findComp.find("nombreID").get("v.value");
		var lastNameFinder = findComp.find("apellidoID").get("v.value");
		var emailUser = findComp.find("emailId").get("v.value");
		
		//Agregado KAL-67
		var telefonoUser = findComp.find("mobilePhone").get("v.value");
		var tipoEnvio = component.get('v.checkboxDomicilo');
		//Por ahora (para los siguientes cuatro datos), como no se puede modificar la shipping address en la pantalla datos de entrega, 
		//se hace de ésta manera, cuando se pueda modificar habrá que repensarlo con el formulario de modificación que se creará.
		var direccionConNumero = component.get("v.direccionConNumero");
		var provincia = component.get("v.provincia");
		var city = component.get("v.city");
		var codPostal = component.get("v.codPostal");
		//Agregado KAL-67
		
		var action = component.get("{!c.updateDatosAutorizado}");	
		var datosUser = '';
		
		var ValidacionesDeEmail = findComp.validarEmail();
		var validarNroDoc = findComp.validarNroDocumento();
		var validarNroPhone = findComp.validarPhone();
		if (ValidacionesDeEmail && validarNroDoc && validarNroPhone)
		{

			if(documenTypeFinder != undefined && documenNumberFinder != undefined && 
				 firstNameFinder != undefined && firstNameFinder != "" && 
				  lastNameFinder != undefined && lastNameFinder != "")
			{
				var documentNumber = documenNumberFinder;			
				var documentType = documenTypeFinder;
				var firstName = firstNameFinder;
				var lastName = lastNameFinder;      
				datosUser = "({DocumentNumber=" + documentNumber +", "+ 
								"DocumentType=" + documentType +", "+
								"FirstName=" + firstName +", "+ 
								"LastName="+ lastName +"})";
			}

			action.setParams({//Ultimos 5 campos agregados por KAL-67
				param : datosUser,
				email : emailUser,
				telefono : telefonoUser,
                direccionNumeradaI : direccionConNumero,
                provinciaI : provincia,
                cityI : city,
				codPostalI : codPostal,
				checkboxDomicilio: tipoEnvio
			});
			action.setCallback(this, function(response) {
				if(response.getState() === 'ERROR') {
					if(response.getError()[0].message) {
						alert('Error: ' + response.getError()[0].message);
					}					
				}else{
					var action2 = component.get("c.GetTaxes");

			action2.setParams({
				delivery : domiEntrega				
			});
			action2.setCallback(this, function(data) {
				if(data.getReturnValue() != null){                
					var retorno = data.getReturnValue();

				 	JSON.stringify(retorno, function (key, value) {
				        if (typeof value === 'function') {
				            return value.toString();
				        }
				        return value;				        
				   	});


					//console.log('response1 is '+JSON.stringify(retorno));
					//var ret = retorno.output;
            		//console.log('response2 is '+ret);					
				}
			})
			$A.enqueueAction(action2);
						
			var cmpTarget1 = component.find('deliveryData');
			var cmpTarget2 = component.find('payment');				
			$A.util.addClass(cmpTarget1, 'slds-is-collapsed');				    	
			$A.util.removeClass(cmpTarget2, 'slds-is-collapsed');
			$A.util.addClass(cmpTarget2, 'slds-is-expanded');
				}
			})
			$A.enqueueAction(action);

			
			/*var cuotas=component.find('selectCuotas').get('v.value');
			component.set("v.cuota", cuotas);
			console.log('cuotas es'+cuotas);*/	 
		
		//component.set("v.Spinner", true);	 
		} 	
		component.set("v.Spinner", false);
    }
})